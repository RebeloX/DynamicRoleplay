/*
	WItem - MyRPG World Item DataHolder 
	Luís Gustavo Miki
*/

native WItem:witem_push(rowid, itemname[], type, extra, objectid, Float:x, Float:y, Float:z, int, vw, areaid, ownertype, owner);
native witem_destroy(WItem:witemid);
native WItem:witem_getbyobject(objectid);
native WItem:witem_getbyarea(areaid);
native WItem:witem_getbyrow(rowid);
native witem_getrow(WItem:witemid);
native witem_getobject(WItem:witemid);
native witem_getarea(WItem:witemid);
native witem_getname(WItem:witemid, string[], len = sizeof(string));
native witem_gettype(WItem:witemid);
native witem_getownertype(WItem:witemid);
native witem_getowner(WItem:witemid);
native witem_destroyall();

forward OnWItemDestroy(obj, area);
forward OnWItemNotice(WItem:item);
