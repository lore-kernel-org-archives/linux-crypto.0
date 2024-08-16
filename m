Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192D51C231F
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723833142; cv=fail; b=Weu2N047NGTdnZWSSoWaIfTfr/oHyaiE7aLzoyghgItymZjwGIeH8odDGs3U3KwJA0rIv25ZceoHtmYXaR/09N/RiFtmyyLSX2YmLV31fZ5vooZSFpWvCbfGm+iLblaUCogoJ2PelXeB/qaKs2l7teHLVv+sUhLTkF07Q4ZBBEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723833142; c=relaxed/simple;
	bh=oXnONFKzA/ixwICIX4Ewyf0o8h/v25RTOe6oNhUQuE0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TguZrID+fl5KHvz/jB1mwHd27sda0iwzyK/PN5GcfW2TyDyHrQNvwlzEBH+c3CCCnjRdzoI79YGFu7DNxNS1SOwh5bp45F/5C1uEYMpwjGphJXLE6sBhjuUX4np3WWtPhLD+q/WE35j0mOs9ytRuk3P+EBmowWfFz+ozi8/7OCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gH6JxrG9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dl7yvmlz; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gH6JxrG9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dl7yvmlz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723833140; x=1755369140;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oXnONFKzA/ixwICIX4Ewyf0o8h/v25RTOe6oNhUQuE0=;
  b=gH6JxrG9RtriTv+WuEgKjKqTmNr1uWnVFgLasD3BClNtFAhPrxMNOpFA
   yENRTy/aDi09SenAHpd3OtL+Mbpb6J/0/DYwrtP09FrdmEJxKh4S1kVDT
   gIMUo9GY9zfOSKm/J6QAValGv1LvgSoPwmRjpJxEdYTN4hJDq5gWin631
   8J39nQHBZyeMZIa/E+XEPMEd6wFelHYlUgAuIC5Xop/dtFLMeLH4QMUiz
   1hPghou+jG86h2Xujd80iIrVUH4k0/JqacQ9tUuyc1OA1J0xqIj3LQNqB
   6n62f9CVUKKNmky9pXAC2oPKqTG9oIefCS4qkyg5w46FwQ172HUyiYk8F
   Q==;
X-CSE-ConnectionGUID: uPWTmW8BRU69tuQpbXPB3A==
X-CSE-MsgGUID: /AF4suhQSnSTRsln/BDY/w==
X-IronPort-AV: E=Sophos;i="6.10,152,1719849600"; 
   d="scan'208";a="25449940"
Received: from mail-southcentralusazlp17012055.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.55])
  by ob1.hgst.iphmx.com with ESMTP; 17 Aug 2024 02:32:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UB1/hrs9VA0ypY9YNJu57yw7jZG648WYiFXPhVn1HcY9ofZL2+Ql/PmbZM9SSoZ6VPnffG/yqnmZuJgfw8MH9XzuE0zHwJ4GvpDFp4MKlWlP2D25bnUMlAQcRKaiKkp4JYoHyzZoyrMGiQWKULBPsvVLq60fBi/mks6Wej1e0dHnxqwJtFo5dVcGXPM3eRfTKQLn0py1zxSh8hWMr7iwUlBmC24TchfX6SbV1FMqoyABpGNE2IWi/KiUbUkdtLSioInBjBHrZc1Ev+sVQMfWppdupzPbWfMldO79q2z3Ep63FejQCgDswBf4DbpbxmmwKFXdzLnSdaQ2Z+R05JAl3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyI60nwLlvPq0kkd1w3jLgoFsbbHOQ3Kzm2qFf+RFZ0=;
 b=IjuxKG1Y6fNf97C/OXP/yMK05KLOUT1vPi0YQ2GBlmGqmNPDXkRlwxIp1yqzO4mY1Fyg8+Asdd+7K79ZN3qTeDUlytriZuUZv9lBzhrtGRQ7XECJWmed1js4H1hzEGnVBMZobePFdvzhlH/meiJbwN+P+T352DR7Og08hiQ3M1B16sqEdlOtgXPIv8Ps5yl1DdoSbJ38m9ILBsYP9o3TD0aFlPlmPHy7hgQu+jX+cuNE+7oxYPuttqr8f+rOsjHEL7whNHSmHtVcunQ1PhRUMTgYVAuX3TrKiNt33rLPuYGiuFbTFwASfZabrvm7sM5ltBoByBFOzl79lZXnbjnzsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyI60nwLlvPq0kkd1w3jLgoFsbbHOQ3Kzm2qFf+RFZ0=;
 b=dl7yvmlzFOVCA23VwgLKULCP8xw2OlmcPRkq33rlnLKyni7l16fvsY9EhiDgYWy7rvxORC6rz1EvIXsuk7JCkNXkN9eCWtRdW/+KGGO8yUpfBJjFaLEPzzh8gtwGqaVDlCPz9H027UVtXmnAzNn3OJTR41GLjTlPlcpa9gguDdE=
Received: from BY5PR04MB6849.namprd04.prod.outlook.com (2603:10b6:a03:228::17)
 by CH2PR04MB6602.namprd04.prod.outlook.com (2603:10b6:610:66::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 18:32:14 +0000
Received: from BY5PR04MB6849.namprd04.prod.outlook.com
 ([fe80::b2a6:2bbf:ed0a:7320]) by BY5PR04MB6849.namprd04.prod.outlook.com
 ([fe80::b2a6:2bbf:ed0a:7320%7]) with mapi id 15.20.7828.024; Fri, 16 Aug 2024
 18:32:14 +0000
From: Kamaljit Singh <Kamaljit.Singh1@wdc.com>
To: Hannes Reinecke <hare@kernel.org>, hch <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Eric
 Biggers <ebiggers@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
Subject: Re: [PATCHv9 0/9] nvme: implement secure concatenation
Thread-Topic: [PATCHv9 0/9] nvme: implement secure concatenation
Thread-Index: AQHa7XJkx9IUgccPBEuakH4yu6nDrrIqOHeT
Date: Fri, 16 Aug 2024 18:32:14 +0000
Message-ID:
 <BY5PR04MB6849C928A957A4C549A94020BC812@BY5PR04MB6849.namprd04.prod.outlook.com>
References: <20240813111512.135634-1-hare@kernel.org>
In-Reply-To: <20240813111512.135634-1-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR04MB6849:EE_|CH2PR04MB6602:EE_
x-ms-office365-filtering-correlation-id: d5d46559-44b6-4157-edd0-08dcbe21bfe2
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?N0KnKE37/yK9TySF6sydIIEeKc7mBBEglnlbuzGJF8Q/kmprmE4bkMl0QapK?=
 =?us-ascii?Q?e6WjRrnRVbS+4qQvYd8+eRSTzLzY82vTVSVrv9DSKvhHDAngxB43EOZLH7ha?=
 =?us-ascii?Q?JzG7A+Xzh8qth5Qf+uFCkQVKwermIRItTiKWPsp1SgLrFcIIDKIfijK7OXEq?=
 =?us-ascii?Q?14VvR4ImMUrY0Z5sw6VYsgbgsZvGm4v7AC7tK+emJZA4VqzOLTso7qqq4TGP?=
 =?us-ascii?Q?Gvm0lJVKO2trqgFLmLSCw6h8xhPSYICEbYSeQ0rz/LxGm83MglSYev/1dfBx?=
 =?us-ascii?Q?OV/S6J4biREKkp0Qv4QfKL3wjeSOCKKzKYGIHzKYMhE4pdfqjDggRnF6iM+y?=
 =?us-ascii?Q?DRPYtZXKFRkthxpTiIFiXo9xaq6C30petKnblf9Gp4jbnaoNXFMT1a4Sq0sG?=
 =?us-ascii?Q?p6WgpOOmOSb3sPrAxmqHgs0gc01gJ2Hu3hOt4RRv9nQewjnQL6xZrZ2+x0zV?=
 =?us-ascii?Q?jXzFBvRG3HnWN6Yp089tpH9wq4gGZgGmxPUiNwX8ky6qD+jZMvfqeuJzIAbw?=
 =?us-ascii?Q?XGkUMsavS+9COP1SmkXJtRn9pOJlHD/xlo10SKa6OJ9JPm/BWC13verl18dd?=
 =?us-ascii?Q?Z+RHZxVhox8O+ASLsYuWUqmDRYD1Eb20MQmpJVVYLSSTgmtr8d4w/+kTSvTv?=
 =?us-ascii?Q?Y5yCUCPCWy7a3GZSiwUnjs1L24es9+EdLxfFwymBQz7hMK7HhNW8VCS06o82?=
 =?us-ascii?Q?kAmcssYJ7tCCnCYKIgHKbhIHIcsZuAoIU4FiyObanu3NKvoTV9uioMcHJJaz?=
 =?us-ascii?Q?/Y1VYuspxZqXi94kS+9a47SAXp1aPcBLFLznyRu1MwjYthRd7PYFleA0vBel?=
 =?us-ascii?Q?DArXKYKh5Rb0gZeXHseDJzQ1ODSHncA5r/SJ/Oy8RBRY+r4iFb8lwuox4FFd?=
 =?us-ascii?Q?46r40SKLhRVQIwP2iFbe5ZI9bdQBqCpc2EsQ23IZ7+ZWGSw+zh6XmNq7Zhhh?=
 =?us-ascii?Q?pfDDoY2bWfPWAilLOPVI/1AgAzHjA1oHHjar6BCtX5PeIdIo7Rg6How4VZQU?=
 =?us-ascii?Q?lMSirna/a6CrmCXvY28Xlyr3kPaPH7+dl5hxwctzcQgEJWM90ONlKMiVDd4u?=
 =?us-ascii?Q?OtLAFFFuiVutPQKMKGCGPbEtOx8SoML4ftJwojiPSBjOQDD0ZPgI1SMepyAj?=
 =?us-ascii?Q?eeBPg7m8qpmZROAVSggS2ZvjqJr2faPezosHQp01tJhgyBVxsl99aplI3WKT?=
 =?us-ascii?Q?wd8OtAtK9gakye/sCeLjhodFii1ArEAlLDyaGLE6MhH56b8k2LCuNtq2PLU1?=
 =?us-ascii?Q?OFjoCft2JI45R1PXecteOwR4S1mMXNZuhJplrk/p9Iw7K5Y/M/IFT+PX50rh?=
 =?us-ascii?Q?a17yzKEL56yFqLzmCYXNnbhZxcZMDzQj/sCm74SV4ioX9S5YaJqtlOnsLhr7?=
 =?us-ascii?Q?z13AKzlKSa4cfjbwG2D+6DFxn9UQo5VVDmBcuxOIKSBjc5dLow=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6849.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?jCFP15HFOz6vm5NRFoOtcP8HKkCPxQ/JJa4ei9A2RiJChlbZMDVIVe/FNdzD?=
 =?us-ascii?Q?hDVnhP776BravelqoQR7MpOIgNQuERq/yjBK+QVC7K89zaR9JyujTscg8Rog?=
 =?us-ascii?Q?ADwQ479BOibhvgaSNcsMzgpJmuVs7+ETlzzccHfT82W24H1xAOGIUxs7Vu3y?=
 =?us-ascii?Q?Ii0immwcoDchYgjxLEX/hqt1D14tdEu12J89K1Jx3i97Q4L/GTY8JqrQFLjO?=
 =?us-ascii?Q?5gTiADyS3WQgdYB1wtX9SBtC+/L9ZhfAYMYmoF8sCOR9xi5ylLuPwCCwNrYg?=
 =?us-ascii?Q?Sr1JPiOFUefdXw8aZZstpDYfY0AJkxxUR3fVFwtA+tImfdG0FzY31AWFcskq?=
 =?us-ascii?Q?glxsfcd7HmN8iudl8sdnPJ1al6hOSd74yghxgRsCR7rYVuTEYnkry4P/rpgR?=
 =?us-ascii?Q?Q1WK4xAq3iF3zDvoHsiHJSYIFCJeYK/l4aFvEUeAXua0Y3CeuB8e+jjxT77t?=
 =?us-ascii?Q?6zC6YzuRF4jiuM77PnLzLjLWFt4WazHYO6PiqMMPTUxES5F8wrjvQ1Wc0N4A?=
 =?us-ascii?Q?b8D2lma1Hw+EoWxBVpGpGJ31AUBxVN9FX7/BJM8ivEv21dhW6DvHwfUECkBj?=
 =?us-ascii?Q?AL6rDhsog5vGd59sGPlvHmyRpSzJMc3HbeT7kCcgfJlKMi9txEDQpmvFaLih?=
 =?us-ascii?Q?EIBSfzwBX4qsJ3HlXnEXF9LmRNHXKgt5WZR36yxQyinSAf5jX50AbxoVOsqg?=
 =?us-ascii?Q?vy5werTrx44nql+41M3oBuKyUabHh7XP6RgrdsD5er/V5BudaeWFUwVxONa+?=
 =?us-ascii?Q?UN7ht2vJJhAm8ECqHUngDZRgiTmBF3ZY+Kbt7qdAanzitutlYOR3ij6uj8ps?=
 =?us-ascii?Q?xRUnHvTUDc15oApvj8ozrhi5UmHoQWUrzKSrGdtxrCZ19p0Rv3bRLsaX99O/?=
 =?us-ascii?Q?PYnpBPNOK1rQAXS48qL9/TFRKQTnTlVrekchILmaHKGMR0KSsMNs3/vBoNhZ?=
 =?us-ascii?Q?Ek6Dpvp0DrZh9S4vU8vjlqQpMkvibOqmmiulbTwKKDkyvx5qlNkuYCXNMOU6?=
 =?us-ascii?Q?3Cn6gSrHJUgllEL4orK42C98AJtMqgWL88++a7T52AEawLB/4mXqNFcCsjNH?=
 =?us-ascii?Q?Rqi5n2NlDIrlRgjPlWizU9K8gWKDk5iqRBUZwWGg5zyjO2+V6WtmW4mqZbF8?=
 =?us-ascii?Q?ZMOiBcaerMz/AgXDVwPwuDvx5QoY1KopN3IX1uCTNOOw1L6qNtPL3kLN/1G9?=
 =?us-ascii?Q?jBq94D/zs5lnJrJD/L4Lc1/p6umRqw4ivPtvWv1egaXjj4DEKBnDsGgHTInw?=
 =?us-ascii?Q?9O/nyyv/scaQZ2alj5sZ3sOt9zDVvN7LqNGVfywSVto1Dk7q2hbuXg4OmgwW?=
 =?us-ascii?Q?Svc0Rm2Ly9qM7yNdMtSvyXLaZPVyg58oMa/MWbuSm9eJ/TugezrhmPnjh6Em?=
 =?us-ascii?Q?ZoD7n0WQrMThwwnlKX6qU+4GXx0sByy6t58sSq0VKHLnYJrcr5Yb84l/o8BP?=
 =?us-ascii?Q?Fjm7qx+J5XOVmwgekaMeKkqxyLwQDE8GbnMCnh4iVhJ5FLPHaAgfR+SLVk9x?=
 =?us-ascii?Q?k+pFusEyucUH3owFI8vS9Ep6obgg1KM+/pc71+xllKbY4gWe2DU7j6U25Zu0?=
 =?us-ascii?Q?KxmmHaElcxFlVeeCtG62m4eJLoih8EDs0MLHlRDb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mJGpYxq5dNc0VNVqii6MchIb9gX5FPLB/07PurT6deBmPMjWKt4cx3Tb8Bxhd8LaEcFnZp5DmVEZ4ttK21ns18bTuvOF8zXfygczY95iOGwhjwsdDKJpEeLGYWjVp2VROrgQXsZ0RadArR/frGcPKihDZ9hEr4169C1YbGYUycEeCOFivYMkgl8jPdj9cTaHBOfZqC0bY8TRuHoYpHhXqMYo42OPFlj2kqM56gi9DYyhMGmSVDfDrHZkzB0sTk6rDdXS9c7tBhXgDMii2r8GJ2PxMgueH9B+LdRTaClhFW4r3OmeLIr2+FIWhAGJmKHj0Bmzl8cSEmx/lo0ZaKEHtzOO/VdgRJplBpWVXbdJZadOxUDIZOEw6SzAv0K1aXPscfC67sRDKrry1W+vU6JpoUJ2a8q5JhGNk/8DAJlumFJCRv0OG0QZyYKN3dciRlDyQzhfyijtgIuSIiwXy7q6Es9pOuJziyBThtusXtCeXnkPvSS2iTosZRGGOPXnOs7CYdXwdVO2aLAgHppWk/RlxvZ6PH+u7MA9x0mD6RZiNYhfP0x/UFLMESGCb2O24CULGGQGXqbwaJ0Qv0RoGguQSXg1Pfb97/vL8BJQW6vBZMCSxvU8/qwkQD+Jdk/z4sbm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6849.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d46559-44b6-4157-edd0-08dcbe21bfe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2024 18:32:14.1762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vSDd1tRgmq/DM9DbcUeGK0Gb9bT8rCQeLhmVk7g7BgEaVLxMNaD8F7HQjrNoJw8sDXoGe5W9OHAvTKub1ohcqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6602

Hi Hannes,

>Patchset can be found at
>git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git
>branch secure-concat.v9
I don't see the .v9 branch under that repo. Did you mean secure-concat.v8 b=
ranch?

Thanks,
Kamaljit

________________________________________
From: Linux-nvme <linux-nvme-bounces@lists.infradead.org> on behalf of Hann=
es Reinecke <hare@kernel.org>
Sent: Tuesday, August 13, 2024 4:15 AM
To: hch
Cc: Keith Busch; Sagi Grimberg; linux-nvme@lists.infradead.org; Eric Bigger=
s; linux-crypto@vger.kernel.org; Hannes Reinecke
Subject: [PATCHv9 0/9] nvme: implement secure concatenation

CAUTION: This email originated from outside of Western Digital. Do not clic=
k on links or open attachments unless you recognize the sender and know tha=
t the content is safe.


Hi all,

here's my attempt to implement secure concatenation for NVMe-of TCP
as outlined in TP8018.
The original (v5) patchset had been split in two, the first part of
which has already been merged with nvme-6.11, and this is the second part
which actually implements secure concatenation.

Secure concatenation means that a TLS PSK is generated from the key
material negotiated by the DH-HMAC-CHAP protocol, and the TLS PSK
is then used for a subsequent TLS connection.
The difference between the original definition of secure concatenation
and the method outlined in TP8018 is that with TP8018 the connection
is reset after DH-HMAC-CHAP negotiation, and a new connection is setup
with the generated TLS PSK.

To implement that Sagi came up with the idea to directly reset the
admin queue once the DH-CHAP negotiation has completed; that way
it will be transparent to the upper layers and we don't have to
worry about exposing queues which should not be used.

As usual, comments and reviews are welcome.

Patchset can be found at
git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git
branch secure-concat.v9

Changes to v8:
- Include reviews from Eric Biggers
- Make hkdf a proper module
- Add testcases for hkdf

Changes to v7:
- Add patch to display nvme target TLS status in debugfs
- Include reviews from Sagi

Changes to v6:
- Rebase to nvme-6.11

Changes to v5:
- Include reviews from Sagi
- Split patchset in two parts

Changes to v4:
- Rework reset admin queue functionality based on an idea
  from Sagi (thanks!)
  - kbuild robot fixes
  - Fixup dhchap negotiation with non-empty C2 value

Changes to v3:
- Include reviews from Sagi
- Do not start I/O queues after DH-HMAC-CHAP negotiation
- Use bool to indicate TLS has been enabled on a queue
- Add 'tls_keyring' sysfs attribute
- Add 'tls_configured_key' sysfs attribute

Changes to v2:
- Fixup reset after dhchap negotiation
- Disable namespace scanning on I/O queues after
  dhchap negotiation
        - Reworked TLS key handling (again)

Changes to the original submission:
- Sanitize TLS key handling
- Fixup modconfig compilation

Hannes Reinecke (9):
  crypto,fs: Separate out hkdf_extract() and hkdf_expand()
  nvme: add nvme_auth_generate_psk()
  nvme: add nvme_auth_generate_digest()
  nvme: add nvme_auth_derive_tls_psk()
  nvme-keyring: add nvme_tls_psk_refresh()
  nvme-tcp: request secure channel concatenation
  nvme-fabrics: reset admin connection for secure concatenation
  nvmet-tcp: support secure channel concatenation
  nvmet: add tls_concat and tls_key debugfs entries

 crypto/Kconfig                         |   4 +
 crypto/Makefile                        |   1 +
 crypto/hkdf.c                          | 404 +++++++++++++++++++++++++
 drivers/nvme/common/Kconfig            |   1 +
 drivers/nvme/common/auth.c             | 344 +++++++++++++++++++++
 drivers/nvme/common/keyring.c          |  64 ++++
 drivers/nvme/host/auth.c               | 108 ++++++-
 drivers/nvme/host/fabrics.c            |  34 ++-
 drivers/nvme/host/fabrics.h            |   3 +
 drivers/nvme/host/nvme.h               |   2 +
 drivers/nvme/host/sysfs.c              |   4 +-
 drivers/nvme/host/tcp.c                |  56 +++-
 drivers/nvme/target/auth.c             |  72 ++++-
 drivers/nvme/target/debugfs.c          |  27 ++
 drivers/nvme/target/fabrics-cmd-auth.c |  49 ++-
 drivers/nvme/target/fabrics-cmd.c      |  33 +-
 drivers/nvme/target/nvmet.h            |  38 ++-
 drivers/nvme/target/tcp.c              |  23 +-
 fs/crypto/Kconfig                      |   1 +
 fs/crypto/hkdf.c                       |  87 +-----
 include/crypto/hkdf.h                  |  34 +++
 include/linux/nvme-auth.h              |   7 +
 include/linux/nvme-keyring.h           |   9 +
 include/linux/nvme.h                   |   7 +
 24 files changed, 1303 insertions(+), 109 deletions(-)
 create mode 100644 crypto/hkdf.c
 create mode 100644 include/crypto/hkdf.h

--
2.35.3


