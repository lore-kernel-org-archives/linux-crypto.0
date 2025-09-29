Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010071.outbound.protection.outlook.com [52.101.84.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87A01DA61B;
	Mon, 29 Sep 2025 23:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759189902; cv=fail; b=ZH1km7LMLdxTawNZtgLoaA8AAk+Fw0FiLd/OW2udRdJdFK9/gUqJXpeNFbl9uKUVUz46u7tEo3Ow0Az6c8QH8sK4lmMCbWPox/m91cYnpQRwUKbKIPHyj+73qPCOTt4DJuMhsisWOljXyudm4mckYVB1YyMGibINPkVEOmYcI2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759189902; c=relaxed/simple;
	bh=gQJ328qkYTCveTYOX5KSTw0+RtDVtEr3JL4jDZBTEh0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OnZIm7njiLbClMe+5hvlYXQllsBNW+UlHFX4vuNhRRSNG9DQkfUiWQT5hlt+ppIBVu1i0amsTHBNVi5zKddrpStxDfxheOWyQP910dUBoIMmtGNeUGNPaf6GhporWue0CGWAm2TcFCGFozepKoWbhZ04UECBx2rziclC9+tcHCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=S2zySEgm; arc=fail smtp.client-ip=52.101.84.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="S2zySEgm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQnTzStTi7nQTxzXFuYdoxPuMrof1sI/fZXrHzv38Qg9z07Awkc966fUcUvWTGGLUhf2U9D/8pRNmCT20lf8FL6DWrOJmOGhVhNbyGsDDSkU0SILZKrF9S4qyfE65w/pfSRJt0/ADpfA6L+KZ25/Q+ocN8gjq8HavKNHZceK6lTIW7wVplQAu7202eqjxySC9ABZg/5GCUr8IObDZ6MGupTdbfvNBsrjoEI+LUNXgU1LVCrCCq2tLgbUEc5EGQqLvllt/yzXvqeO1SC6FyNnifFlRzdxp6U1PvlL1OiFDyhoxgmdc8yPvQxSEY6q11XEn4n0VlBjfgvor0dQMTCWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQJ328qkYTCveTYOX5KSTw0+RtDVtEr3JL4jDZBTEh0=;
 b=NFzJWZ6kVSxdhXiDsnBzD2BYID9tAoJbYr5zjbnbZEOXP6n9HTplEDnVL5qAIDxfvH1BByxRn7FfWePzbPyyVdl2NXQX/7NNMGMbi1VptslHaC4mrPDzs0W8kHkZuYWDZg0N70WAHqSz+5NsB+WS5UWOYAuPa5AQa8xlBDx9wF0VRIHvmpPXolLPfqae09vuwdNJ+RjajxUMO7Wt7sZY58e6TlKvjLL6rUBZJ71Xhlu7Luyjk6STrJNb0ON/hpfEmbTsp+xMGas32yQMS356rAAhIFs7l2JbTMQmhXg2tHVgrjX+QRGyZvzo8hGOxGc8i2d/HBOnTwCEQe7a75UNAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQJ328qkYTCveTYOX5KSTw0+RtDVtEr3JL4jDZBTEh0=;
 b=S2zySEgmiKimn2j/mGFGhTFW1i8Fe+Eqa35SCa9DssKKj3XV2VwK1t+I62vCin6AmERRFQYxSxcYl4rMzdAwZVI9Ua9YAr3igP1FgU2E/wz7x5kghfeqCLnDEFOWVK2iIrtCu0v8B4qvRfojMuj545OWoq1gKObysRy9xrq52A80Pha8jnZmvzoQp4dSXiIqlCS45D/b18sm4AhiKAHNI75N4GokVofDr9fJSfjrr4RmW9eGB4GmpeoACNY4hrudh94PQQ9brFOAeDFiXfukxvPw/gVMb/UiXe7rbzChl/6Gct0pesb9BjD+5qpefQEG9QnJDfggDnWmQUuYNwmvJA==
Received: from GV1PR04MB9071.eurprd04.prod.outlook.com (2603:10a6:150:22::11)
 by AS8PR04MB7989.eurprd04.prod.outlook.com (2603:10a6:20b:28b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 23:51:36 +0000
Received: from GV1PR04MB9071.eurprd04.prod.outlook.com
 ([fe80::b7f2:1d0:6b6a:ba58]) by GV1PR04MB9071.eurprd04.prod.outlook.com
 ([fe80::b7f2:1d0:6b6a:ba58%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 23:51:36 +0000
From: Han Xu <han.xu@nxp.com>
To: "suman.kumar.chakraborty@intel.com" <suman.kumar.chakraborty@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "terrelln@fb.com"
	<terrelln@fb.com>, "dsterba@suse.com" <dsterba@suse.com>, Richard Weinberger
	<richard@nod.at>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, Miquel
 Raynal <miquel.raynal@bootlin.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY TECHNOLOGY DEVICES (MTD)"
	<linux-mtd@lists.infradead.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: [Bug report] crypto: zstd: kernel dump during UBIFS write back
Thread-Topic: [Bug report] crypto: zstd: kernel dump during UBIFS write back
Thread-Index: AQHcMZrx9JDccXT2b0uVuaCQ5ij3Dw==
Date: Mon, 29 Sep 2025 23:51:36 +0000
Message-ID:
 <GV1PR04MB9071B5AC95DBD48B67FACF44971BA@GV1PR04MB9071.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR04MB9071:EE_|AS8PR04MB7989:EE_
x-ms-office365-filtering-correlation-id: ac6d4cd0-92f8-4c55-a82f-08ddffb3204c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?quwsEjSIytvHibMfOsmLZ1o6wn2LXuk6qA61IhX4ixUixSEK6oQac2Wgwy?=
 =?iso-8859-1?Q?dpddvCqhZwkRHX8d9mx2u7QNmK1J2OqvYf40pFNTcOHmsYSKs+dSfUqe2Z?=
 =?iso-8859-1?Q?ssRX8p6m128uNAKv0ZS9WrVlv51rfocAirZkqiitWTj8Ic23IebRb/GSo1?=
 =?iso-8859-1?Q?7QCfNk2d2IX9ZVwHw8rbAs66PYzNF9Gj3Tny0F3Hr8zuxvIlqZYFT1ScDq?=
 =?iso-8859-1?Q?FASWhm71UchLhzVNbZYQi0wo4MgXSunjIj55CYSp/6ZcPKirbvc0IW02Dx?=
 =?iso-8859-1?Q?C5HW3SKtYOPJeykpIBlYWFkmolftlgkLLIN/sPnkefwuHCCrR8mYl79/6I?=
 =?iso-8859-1?Q?akauA3DPnjEHnPrIXQae3PmEH86SY42twW8FQXwbkYSDx64kQ6aXfdyqsS?=
 =?iso-8859-1?Q?j6Ej7eYZzb1ZsQ32f6IP8Ry5ifscCM8K9yh6SYPN9aWk4PTfcBMA53shIQ?=
 =?iso-8859-1?Q?t9OhlT7SrIczvnXSWElDNNNtJmJG6VApN5rzRdoMRsJbz4YXNZXSYRCl9m?=
 =?iso-8859-1?Q?YI1UXk+011c0V/Yo1issP4Q0Zu68pG+aXFcpwNOiVHkCSXWvee3BOnFxCs?=
 =?iso-8859-1?Q?PaSDvwpXgUh0bN33zvDS8hOZ0TOSw5sbLNDHP0tMNSPAzt+Qj9gxY2EVN8?=
 =?iso-8859-1?Q?gep8vdr4LbpVBGLOLusLiTjtO4oihtUZcTvKxG59BwBEqlNrCVhHzgCKYs?=
 =?iso-8859-1?Q?eYO3DBkQa53XZaKRkq7I+45sNRw/zYTNc6VhUuPV3iMJWorynyMm7QeTmB?=
 =?iso-8859-1?Q?/ChC+UuLoiO6Q+b74TI3WWHqdiK+FwzLCGrSF1tOh9AQ27+ib0vxkvqtCf?=
 =?iso-8859-1?Q?w6jIo7/qeAdCYABSRikb47isM59ER8jTcF2I3aEhXanxdArtUJeu75Fl8u?=
 =?iso-8859-1?Q?4t5eq4sf1QXFSzCYv6SGF5LePkcaoyG3IY7hUQG0dlLBcHXLa3VqkxUcU8?=
 =?iso-8859-1?Q?CVak5Maqrj7O56BSfpf6W1xaf4sLtbE2YVo4kKCkzujqO/BD6Y7ZRHTYKY?=
 =?iso-8859-1?Q?hgyNttPaP+ZUSJKeRZ5ILdi+yDacwmu9/btNfnWoCvhTHgfDaTARh8Q7RZ?=
 =?iso-8859-1?Q?p8mhrFFWkpXI83+QHCHPMxlyNxDYbv6eSoI6wau+LSFGSxeHx6a3rYaS6/?=
 =?iso-8859-1?Q?2dZx1yL6PCn8b6AWI0RNFulFvF5LSCWzObZl3C4ZGECyOLJyN/fWWesUFG?=
 =?iso-8859-1?Q?J2MWx4wuS0kpun67EyDq8eem+zX557qdX1WfPmwoMtxg7XlOQgHlxOhw+S?=
 =?iso-8859-1?Q?t78SE5C1QLXnLsImY9WkIAtoJ/Ont9aLeyUJ3NEsp13QSNnjwIFwLLy90V?=
 =?iso-8859-1?Q?/SEfRqiu0M8xAuCJQT+3KHY6HnXZ15LZqgqL5MZw6YtouVUdpVi9FIySVU?=
 =?iso-8859-1?Q?MOEAosqi1Mmx2IAHWLlWIrn51jeuol4NneiprY8+RwUM7GeBNcBeF1v0yC?=
 =?iso-8859-1?Q?4M4MSRKvKEdPv8RzeawinTrTtXgb+Vo0rwNT8mnc1f2kl5bH2X0az9MtgR?=
 =?iso-8859-1?Q?2efgSZFwahxaypYmpmYlDcnfZ86QwRxziBbrBW/M6hJwcZzWUfc14EN4GJ?=
 =?iso-8859-1?Q?hZmVOLRBgzfHVBDgjXPelTcidahz?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9071.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?CZHjS6sGnAlfededCE9vhfDUBahawMYbOMIKMmu07I4joC/2JFqBKM1t/q?=
 =?iso-8859-1?Q?GUv6dF0ZozuoHmYRBNzll5kbgF3QokjHM6U6BNfFhBJ3e4ZNYkX6HE/zKC?=
 =?iso-8859-1?Q?poRHp+NM9Yg2Q+P6NbqerH+EKrx1EBtCMYb7Lj2Gxznh4MU2wrK+8InKYl?=
 =?iso-8859-1?Q?H7205oLdV2a0AxzucKV/iq9rpVS9qeNWpp16UOrzr6rj0L46icyh+ysaWa?=
 =?iso-8859-1?Q?SeTFJq+65C/E0CBZv//UBMmfQbvil2yYyeTLrWwcMDEgDEM+iHasLqhZNd?=
 =?iso-8859-1?Q?h/3d1rqdOZei7OgHrXLaFp/VNOVaHed9f4eXQd+jHOLtgNhRsxAJUlNCMk?=
 =?iso-8859-1?Q?YKREYze+KvdStFiUwkE6H9MKQx2BOqFSvtx76vRU4NcLZoVFukk07bEMJ+?=
 =?iso-8859-1?Q?1v+V3qa+voBiKVcnG3x91+iJUCe2qb397eCHlbpLl5iKwzhaVJmKaLkgx1?=
 =?iso-8859-1?Q?qo8KOy9m6DkwndfmCvie5wm/AgUAW67P+aCAJvfyE+B0VN3XvxS/1Qm667?=
 =?iso-8859-1?Q?ORNRd3xAlkqsPRw85QdGuTiJHMqIkq3QHnlZoC6jlTJ4wgRbTuQvn9rmel?=
 =?iso-8859-1?Q?K5QqC5vxwEXeowv+T+uFXXXtxUrUZu2lSrBt1IDP0eopCuCOwoV71rXN6I?=
 =?iso-8859-1?Q?sM3KPI+EtA/8pgzkrt3Ew20u3I0MbYnOKqbVDTZzGDoS2eVtZ4zGdcNeZV?=
 =?iso-8859-1?Q?h1bv1QEZqBpEPxaPHP3q2JXIUpiwQvYTFBFWCAPvtzH+5uj2OTr+/v5rbx?=
 =?iso-8859-1?Q?TrMZJM7aL95QV8pqL71OE0ZetvOTykx4zng3z6FmG2VBmtNLS6HhkcybG7?=
 =?iso-8859-1?Q?VDEAvWO0lHOmpeNiCliWvGecf2PqFDWwXAmbAhLbdAIKNM0cnKhfWV71LV?=
 =?iso-8859-1?Q?FB9uYNe/bDy4Vly2wIXtBjQE8yXybF8lcblYf5Xqu0n/rbsv1OsygE/kU9?=
 =?iso-8859-1?Q?gqtr6mAmoMd9qgOcN1N76JR3S/KQzk2wl3Z9jV6m1bwImOdUxAHsagbO/s?=
 =?iso-8859-1?Q?TEPhk2WRgwSRmlHCIpaCd1Bfy3BJXqIEElt5K6zn2jT+K4PeNDS1E2w8C0?=
 =?iso-8859-1?Q?7TMp41Nc5fdYgCRmeDauNVirNcwfPr20E2P8fmTeCJddi7afP8sm/Iu7Yw?=
 =?iso-8859-1?Q?6UfSd5vw7+o4zt8eyNkVi5JmGSe/j2U9coOqhkKOmdhEXa9MV1rSBtGXCL?=
 =?iso-8859-1?Q?XkWRMNRrjYtChx33+zPFB+Pl+SlQxvwtAVEEqzJ0/SsgWW0Surf9GISfJ9?=
 =?iso-8859-1?Q?swbvClus52kyJKFeFWDs3bODb3Dv7zi4jUZb8lTC0sljd03kEymms+yVSb?=
 =?iso-8859-1?Q?xJYohy48DTZdXZqVdZVBUuPXRviFlqeVpQa2f9CWf13mnqVKHKUUy/efKz?=
 =?iso-8859-1?Q?0YdrZJ2qJbQ2WoHM7CVIUGXhmsF8qWFXSWRAAI0z6Pv5KGUADgw/FCPCs0?=
 =?iso-8859-1?Q?3cGURuk5MBfEQdVHf7xuiq3gPdAbVpWxlHKVBP5xE5kToxPuYHyhfw8bgf?=
 =?iso-8859-1?Q?vGk0+poLoUAeGh5xvvqgiGzPhPbzU9mLawUNO7RE/hWgYYJONUgtQdCdWq?=
 =?iso-8859-1?Q?RBlwOP4F85csMUApeqXzC5h/0RrLTODsVR+dEMZu8iET4oWLefWssosP/6?=
 =?iso-8859-1?Q?jPLn2JE8B0z/4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9071.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac6d4cd0-92f8-4c55-a82f-08ddffb3204c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 23:51:36.2557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: br2ELd75eaBPrZOPYGpJgh5Vn6FRG/vR93IsNhQjhok1FOrzKWbc3J8xSmqk5n+x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7989

Hi Suman,=0A=
=0A=
The patch f5ad93ffb5411 "crypto: zstd - convert to acomp"=0A=
leads to the following kernel dump during UBIFS write back.=0A=
=0A=
To reproduce:=0A=
Build arm64 kernel with defconfig, plus CONFIG_MTD_NAND_NANDSIM, CONFIG_MTD=
_UBI and CONFIG_UBIFS_FS enabled.=0A=
=0A=
Run the following bash script to trigger the kernel dump:=0A=
mkdir -p tmp=0A=
flash_erase /dev/mtd0 0 0=0A=
ubiattach /dev/ubi_ctrl -m 0=0A=
ubimkvol /dev/ubi0 -N test -m=0A=
mount -t ubifs ubi0:test tmp=0A=
dd if=3D/dev/urandom of=3Dtestfile bs=3D128 count=3D1=0A=
cp testfile tmp=0A=
sync=A0=0A=
=0A=
Log:=0A=
Erasing 131072 Kibyte @ 0 -- 100 % complete=0A=
[ =A0 60.179066] ubi0: attaching mtd0=0A=
[ =A0 60.232494] ubi0: scanning is finished=0A=
[ =A0 60.236291] ubi0: empty MTD device detected=0A=
[ =A0 60.282193] ubi0: attached mtd0 (name "NAND simulator partition 0", si=
ze 128 MiB)=0A=
[ =A0 60.289761] ubi0: PEB size: 16384 bytes (16 KiB), LEB size: 15872 byte=
s=0A=
[ =A0 60.296462] ubi0: min./max. I/O unit sizes: 512/512, sub-page size 256=
=0A=
[ =A0 60.303076] ubi0: VID header offset: 256 (aligned 256), data offset: 5=
12=0A=
[ =A0 60.309832] ubi0: good PEBs: 8192, bad PEBs: 0, corrupted PEBs: 0=0A=
[ =A0 60.315987] ubi0: user volume: 0, internal volumes: 1, max. volumes co=
unt: 92=0A=
[ =A0 60.323160] ubi0: max/mean erase counter: 0/0, WL threshold: 4096, ima=
ge sequence number: 3176911815=0A=
[ =A0 60.332327] ubi0: available PEBs: 8028, total reserved PEBs: 164, PEBs=
 reserved for bad PEB handling: 160=0A=
[ =A0 60.341953] ubi0: background thread "ubi_bgt0d" started, PID 466=0A=
UBI device number 0, total 8192 LEBs (130023424 bytes, 124.0 MiB), availabl=
e 8028 LEBs (127420416 bytes, 121.5 MiB), LEB size 15872 bytes (15.5 KiB)=
=0A=
Set volume size to 127420416=0A=
Volume ID 0, size 8028 LEBs (127420416 bytes, 121.5 MiB), LEB size 15872 by=
tes (15.5 KiB), dynamic, name "test", alignment 1=0A=
[ =A0 60.407476] UBIFS (ubi0:0): default file-system created=0A=
[ =A0 60.412898] UBIFS (ubi0:0): Mounting in unauthenticated mode=0A=
[ =A0 60.420849] UBIFS (ubi0:0): UBIFS: mounted UBI device 0, volume 0, nam=
e "test"=0A=
[ =A0 60.428137] UBIFS (ubi0:0): background thread "ubifs_bgt0_0" started, =
PID 470=0A=
[ =A0 60.435337] UBIFS (ubi0:0): LEB size: 15872 bytes (15 KiB), min./max. =
I/O unit sizes: 512 bytes/512 bytes=0A=
[ =A0 60.444981] UBIFS (ubi0:0): FS size: 126722048 bytes (120 MiB, 7984 LE=
Bs), max 8028 LEBs, journal size 6364672 bytes (6 MiB, 401 LEBs)=0A=
[ =A0 60.457141] UBIFS (ubi0:0): reserved for root: 4952683 bytes (4836 KiB=
)=0A=
[ =A0 60.463806] UBIFS (ubi0:0): media format: w5/r0 (latest is w5/r0), UUI=
D 2B0FCD95-73DD-4B63-B790-33F6C7212991, big LPT model=0A=
1+0 records in=0A=
1+0 records out=0A=
128 bytes copied, 0.0035255 s, 36.3 kB/s=0A=
[ =A0 61.243714] Unable to handle kernel paging request at virtual address =
ffff000840000000=0A=
[ =A0 61.251726] Mem abort info:=0A=
[ =A0 61.254564] =A0 ESR =3D 0x0000000096000005=0A=
[ =A0 61.258346] =A0 EC =3D 0x25: DABT (current EL), IL =3D 32 bits=0A=
[ =A0 61.263684] =A0 SET =3D 0, FnV =3D 0=0A=
[ =A0 61.266760] =A0 EA =3D 0, S1PTW =3D 0=0A=
[ =A0 61.269919] =A0 FSC =3D 0x05: level 1 translation fault=0A=
[ =A0 61.274821] Data abort info:=0A=
[ =A0 61.277721] =A0 ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000=0A=
[ =A0 61.283229] =A0 CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0=0A=
[ =A0 61.288307] =A0 GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0=0A=
[ =A0 61.293647] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D000000008208=
4000=0A=
[ =A0 61.300380] [ffff000840000000] pgd=3D0000000000000000, p4d=3D18000008b=
ffff403, pud=3D0000000000000000=0A=
[ =A0 61.309121] Internal error: Oops: 0000000096000005 [#1] =A0SMP=0A=
[ =A0 61.314791] Modules linked in:=0A=
[ =A0 61.317861] CPU: 0 UID: 0 PID: 115 Comm: kworker/u16:4 Not tainted 6.1=
6.0-rc1-00055-gf5ad93ffb541 #171 PREEMPT=0A=
[ =A0 61.327960] Hardware name: Freescale i.MX8QXP MEK (DT)=0A=
[ =A0 61.333105] Workqueue: writeback wb_workfn (flush-ubifs_0_0)=0A=
[ =A0 61.338794] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)=0A=
[ =A0 61.345769] pc : crc32_le_arm64_4way+0x60/0xc0=0A=
[ =A0 61.350225] lr : crc32_le_arch+0xa8/0xe4=0A=
[ =A0 61.354151] sp : ffff800083dbb720=0A=
[ =A0 61.357472] x29: ffff800083dbb720 x28: 00000000ffffffea x27: 000000000=
0000000=0A=
[ =A0 61.364628] x26: fffffdffe0590940 x25: 0000000000000000 x24: 000000000=
0000001=0A=
[ =A0 61.371786] x23: ffff800083dbb890 x22: ffff000815eac310 x21: 000000000=
0000000=0A=
[ =A0 61.378945] x20: ffff0008134aa000 x19: 00000000ffffffff x18: 000000000=
000000a=0A=
[ =A0 61.386103] x17: 0000000000000000 x16: 0000000000000000 x15: 000000000=
0000000=0A=
[ =A0 61.393262] x14: 0000000000000000 x13: 0000000000000000 x12: 000000000=
0000000=0A=
[ =A0 61.400420] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff00083=
ffffff8=0A=
[ =A0 61.407579] x8 : ffff00083ffffc08 x7 : ffff00083ffff808 x6 : 000000000=
0000000=0A=
[ =A0 61.414739] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 000000000=
0000000=0A=
[ =A0 61.421896] x2 : 03ffffffff4d2a7f x1 : ffff00083ffff408 x0 : 00000000b=
4fb8473=0A=
[ =A0 61.429057] Call trace:=0A=
[ =A0 61.431508] =A0crc32_le_arm64_4way+0x60/0xc0 (P)=0A=
[ =A0 61.435964] =A0ubifs_prepare_node+0x30/0x44=0A=
[ =A0 61.439986] =A0ubifs_jnl_write_data+0x174/0x280=0A=
[ =A0 61.444355] =A0do_writepage+0x94/0x320=0A=
[ =A0 61.447943] =A0ubifs_writepage+0xf4/0x194=0A=
[ =A0 61.451792] =A0write_cache_pages+0x64/0xd4=0A=
[ =A0 61.455727] =A0ubifs_writepages+0x1c/0x28=0A=
[ =A0 61.459576] =A0do_writepages+0xa8/0x17c=0A=
[ =A0 61.463250] =A0__writeback_single_inode+0x38/0x19c=0A=
[ =A0 61.467881] =A0writeback_sb_inodes+0x23c/0x408=0A=
[ =A0 61.472164] =A0__writeback_inodes_wb+0x50/0x108=0A=
[ =A0 61.476534] =A0wb_writeback.isra.0+0x164/0x1f0=0A=
[ =A0 61.480817] =A0wb_workfn+0x220/0x324=0A=
[ =A0 61.484231] =A0process_one_work+0x150/0x294=0A=
[ =A0 61.488253] =A0worker_thread+0x2dc/0x3dc=0A=
[ =A0 61.492015] =A0kthread+0x130/0x204=0A=
[ =A0 61.495255] =A0ret_from_fork+0x10/0x20=0A=
[ =A0 61.498849] Code: 9ad14cc6 a8c12c2a a8c134ec a8c13d0e (a8c14530)=0A=
[ =A0 61.504953] ---[ end trace 0000000000000000 ]---=0A=
[ =A0 61.509627] ------------[ cut here ]------------=0A=
[ =A0 61.514259] WARNING: CPU: 0 PID: 115 at kernel/exit.c:902 do_exit+0x6f=
4/0x8e8=0A=
[ =A0 61.521422] Modules linked in:=0A=
[ =A0 61.524495] CPU: 0 UID: 0 PID: 115 Comm: kworker/u16:4 Tainted: G =A0 =
=A0 =A0D =A0 =A0 =A0 =A0 =A0 =A0 6.16.0-rc1-00055-gf5ad93ffb541 #171 PREEMP=
T=0A=
[ =A0 61.536167] Tainted: [D]=3DDIE=0A=
[ =A0 61.539048] Hardware name: Freescale i.MX8QXP MEK (DT)=0A=
[ =A0 61.544195] Workqueue: writeback wb_workfn (flush-ubifs_0_0)=0A=
[ =A0 61.549883] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)=0A=
[ =A0 61.556858] pc : do_exit+0x6f4/0x8e8=0A=
[ =A0 61.560444] lr : make_task_dead+0x84/0x180=0A=
[ =A0 61.564553] sp : ffff800083dbb350=0A=
[ =A0 61.567874] x29: ffff800083dbb350 x28: fffffffffffffcff x27: ffff80008=
1de5000=0A=
[ =A0 61.575030] x26: ffff800081bd8f90 x25: 0000000000000000 x24: 000000000=
0000000=0A=
[ =A0 61.582191] x23: ffff800081bde168 x22: 000000000000000b x21: ffff00081=
238c600=0A=
[ =A0 61.589347] x20: 000000000000000b x19: ffff00081238c600 x18: 00000000f=
fffffff=0A=
[ =A0 61.596506] x17: 3734386266346230 x16: 3030303030303020 x15: ffff80010=
3dbb047=0A=
[ =A0 61.603664] x14: ffff00081238c680 x13: ffff8000829d6c98 x12: 000000000=
00005fd=0A=
[ =A0 61.610823] x11: 00000000000001ff x10: ffff00081238c680 x9 : 000000000=
0000023=0A=
[ =A0 61.617981] x8 : 0000000000000000 x7 : ffff00081238c680 x6 : 000000000=
00091c5=0A=
[ =A0 61.625140] x5 : 000000000000002c x4 : 000000000000b5c5 x3 : 000000000=
0000000=0A=
[ =A0 61.632298] x2 : ffff00081238c600 x1 : 0000000000002710 x0 : ffff80008=
3dbbca8=0A=
[ =A0 61.639459] Call trace:=0A=
[ =A0 61.641910] =A0do_exit+0x6f4/0x8e8 (P)=0A=
[ =A0 61.645497] =A0make_task_dead+0x84/0x180=0A=
[ =A0 61.649259] =A0arm64_force_sig_fault+0x0/0x70=0A=
[ =A0 61.653452] =A0die_kernel_fault+0x234/0x4e0=0A=
[ =A0 61.657476] =A0__do_kernel_fault+0x11c/0x188=0A=
[ =A0 61.661586] =A0do_translation_fault+0x60/0xcc=0A=
[ =A0 61.665782] =A0do_mem_abort+0x44/0x94=0A=
[ =A0 61.669281] =A0el1_abort+0x40/0x64=0A=
[ =A0 61.672524] =A0el1h_64_sync_handler+0xa4/0x120=0A=
[ =A0 61.676807] =A0el1h_64_sync+0x6c/0x70=0A=
[ =A0 61.680308] =A0crc32_le_arm64_4way+0x60/0xc0 (P)=0A=
[ =A0 61.684762] =A0ubifs_prepare_node+0x30/0x44=0A=
[ =A0 61.688785] =A0ubifs_jnl_write_data+0x174/0x280=0A=
[ =A0 61.693157] =A0do_writepage+0x94/0x320=0A=
[ =A0 61.696744] =A0ubifs_writepage+0xf4/0x194=0A=
[ =A0 61.700593] =A0write_cache_pages+0x64/0xd4=0A=
[ =A0 61.704528] =A0ubifs_writepages+0x1c/0x28=0A=
[ =A0 61.708377] =A0do_writepages+0xa8/0x17c=0A=
[ =A0 61.712052] =A0__writeback_single_inode+0x38/0x19c=0A=
[ =A0 61.716682] =A0writeback_sb_inodes+0x23c/0x408=0A=
[ =A0 61.720965] =A0__writeback_inodes_wb+0x50/0x108=0A=
[ =A0 61.725335] =A0wb_writeback.isra.0+0x164/0x1f0=0A=
[ =A0 61.729618] =A0wb_workfn+0x220/0x324=0A=
[ =A0 61.733032] =A0process_one_work+0x150/0x294=0A=
[ =A0 61.737055] =A0worker_thread+0x2dc/0x3dc=0A=
[ =A0 61.740816] =A0kthread+0x130/0x204=0A=
[ =A0 61.744056] =A0ret_from_fork+0x10/0x20=0A=
[ =A0 61.747645] ---[ end trace 0000000000000000 ]---=
