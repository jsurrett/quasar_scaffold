import ImportForm from 'quasar-scaffold/components/ImportForm.vue'
import { t } from 'quasar-scaffold-host/boot/i18n'
import { toSnakeCase } from 'quasar-scaffold/utils/index'
import EditResourceSchemaForm from 'quasar-scaffold/components/EditResourceSchemaForm.vue'
import ResourceDataTable from 'quasar-scaffold/components/ResourceDataTable/Index.vue'
import schemaColumnEnhancements from 'quasar-scaffold-host/resourceHelpers/schemaColumnEnhancements'
import routesComponentMapper from 'quasar-scaffold-host/resourceHelpers/routesComponentMapper'

export function paramsWithBelongsToParams ({ params, resourceName, parentResourceName }) {
  const idValue = params[`${resourceName}Id`]
  const parentIdValue = params[`${parentResourceName}Id`]

  const newParams = {
    resourceName,
    id: Number.parseInt(idValue, 10) || idValue
  }

  if (parentIdValue) {
    newParams.belongsTo = {
      name: parentResourceName,
      id: Number.parseInt(parentIdValue, 10),
    }
  }

  if (schemaColumnEnhancements[resourceName]) {
    newParams.schemaBase = schemaColumnEnhancements[resourceName]
  }

  return newParams
}

export function sectionResourceRoutes ({
  resourceName,
  Index,
  Edit,
  FormInputs,
  rootIndexRoute,
  parentResourceName,
  children = []
}) {
  const localizedImport = t('datatable.import')
  const localizedNew = t('actions.new')
  const localizedEdit = t('actions.edit')
  const localizedBatchEdit = t('actions.batchEdit')
  const localizedResourceName = t(`resources.${resourceName}`)

  Index = Index || routesComponentMapper[resourceName]?.Index || ResourceDataTable
  Edit = Edit || routesComponentMapper[resourceName]?.Edit || EditResourceSchemaForm
  FormInputs = FormInputs || routesComponentMapper[resourceName]?.FormInputs || Edit

  const defaultIndexRoute = {
    path: '',
    component: Index,
    props: ({ params }) => resourceParamsWithBelongsToParams(params),
  }

  function resourceParamsWithBelongsToParams (params) {
    return paramsWithBelongsToParams({
      params, resourceName, parentResourceName
    })
  }

  return {
    path: toSnakeCase(resourceName),
    meta: { title: localizedResourceName },
    component: () => import('quasar-scaffold/components/RouterChildren.vue'),
    children: [
      rootIndexRoute || defaultIndexRoute,
      {
        path: 'import',
        component: ImportForm,
        props: ({ params }) => resourceParamsWithBelongsToParams(params),
        meta: { title: localizedImport },
      },
      {
        path: 'new',
        component: FormInputs,
        props: ({ params }) => resourceParamsWithBelongsToParams(params),
        meta: { title: localizedNew },
      },
      {
        path: 'batch',
        component: FormInputs,
        props: () => resourceParamsWithBelongsToParams({ id: 'batch' }),
        meta: { title: localizedBatchEdit },
      },
      {
        path: `:${resourceName}Id`,
        component: Edit,
        props: ({ params }) => resourceParamsWithBelongsToParams(params),
        meta: { title: localizedEdit },
        children
      },
    ]
  }
}
