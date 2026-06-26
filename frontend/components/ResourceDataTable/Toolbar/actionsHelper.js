import { t } from 'quasar-scaffold-host/boot/i18n'

function handleSelectedUpdate ({ route, router }) {
  router.push(`${route.path}/batch`)
}

export function handleSelectedDestroy ({ resource }) {
  const selectedIds = resource.selectedIds

  confirm(
    t('messages.confirmMultipleDelete', { count: selectedIds.length })
  ) && resource.destroy(selectedIds)
}

function handleExport ({ resource }) {
  resource.export()
}

// TODO: Finish implementing import functionality
// Consider using papaparse for CSV import instead of current partial implementation
// function handleImport ({ route, router }) {
//   router.push({ path: `${route.fullPath}/import` })
// }

export function gotoNew ({ route, router }) {
  router.push({ path: `${route.path}/new` })
}

export const defaultTableActions = [
  { name: 'createNew',    icon: 'plus-circle', title: 'datatable.createNew',    action: gotoNew,               areIdsOptional: true, permission: 'create'  },
  { name: 'batchUpdate',  icon: 'pencil',      title: 'datatable.batchUpdate',  action: handleSelectedUpdate,                        permission: 'update'  },
  { name: 'batchDestroy', icon: 'delete',      title: 'datatable.batchDestroy', action: handleSelectedDestroy,                       permission: 'destroy' },
  { name: 'export',       icon: 'export',      title: 'datatable.export',       action: handleExport,          areIdsOptional: true                        },
]
