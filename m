Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA447E1;
	Thu, 22 May 2025 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747921554; cv=fail; b=U6VIn1eA6t1i5efiGAWDEsDQZy0W8X794QSDqlegNnyJMv8zmHZx7szYJSMxZm1V5i2Zb+qZY28PlmSnEJBzEyCLHkXB57iTiE0aN2LcrIwVFIIEekKhRVxcPKcEbPFcgbE4EADaHyerH+UPD/cRwSO4BUlAseRpZJoFm7AKVfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747921554; c=relaxed/simple;
	bh=fi8Gq0ORR+lxFE5A1DGw4hfiiDKhHkiFWce7449cA5U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tep5XJR1lR72otoC4zjDSdyUs65sORFO1filO2ci1e9wd1uLnhlf9EmdhxWKGcZreqkxNXT4YccLDzFlos+N4FrpU/YI3yKfS9Qe9LFXdk5zApTQcMVhY6ZVZ+PfiDZ5Bvii7ocqseKVgV4y2uceBv8/iUFZVgLQRvqrCHEBki0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OWsDnS/h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T/RREHHK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OWsDnS/h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T/RREHHK"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54MDb0V3032618;
	Thu, 22 May 2025 13:44:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fi8Gq0ORR+lxFE5A1DGw4hfiiDKhHkiFWce7449cA5U=; b=
	OWsDnS/hddxsbmHbVi48D+ggHjPEiIPuFxv2c3SOdKO1RtHsR092OmeyNwcRJHH7
	mFHlZTwMZGQ790tmHtZtinskGqiVkBs3SHkzjEhKKeQDoqO4pvvCeE856NRvOgHa
	kCudrg6TxApFVroe8wQcbIoRR+eZceaGsYSshJFslB6qnD4xLV9cCagnWy647Fj7
	Y7Y6k0sLqkp91DBXPWEApXJ8Eon6YW2U+YCNL+eGF3WMpFoNw0S02lcrvCVoQ68n
	kzYWlnybx/PQ2eLLR6HQT5Wch7RC5z1H9NhjEmdvsGI1nVr5tuoht7483pRh18ig
	S6DrZzSVreo9e6htGo5T+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46t4ya00k3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:44:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54MCUoUw034530;
	Thu, 22 May 2025 13:44:32 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11010071.outbound.protection.outlook.com [40.93.198.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwer6ge9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:44:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fs3Hm9FdzdCigc2ol/5LMof5+JDpOM+8Ity6k2lzeLrLPW6YhdQtIqYuzB40xxetrshJW5pBuKSZ31PVRKcx4qO4ieQO8QfA3VBmmZQ9mPG1gqtTxnnYS8vs2VLt9PReDLyJOUEkF//zpbtCA8tnryE8flghh5ZQLATmn9tbFluhqyhnw0ttSbMCsz1veTTRcyzwQLujWoKGilsBoxkiRSKxI+skTStkENN9oK62JZi4qgWjMJoQ3Mxy+ugom81ORajhBpFXDsmszSKJNPH4UT45kXNAHdR8ovabnP26hBP2GumbJ8iyhcjVZzqLadtwz8BC8Hk0jYTwQrvxGziK/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fi8Gq0ORR+lxFE5A1DGw4hfiiDKhHkiFWce7449cA5U=;
 b=Zv39Y8aF3lsAO6WWQbpWvkGx9HOm2hN0WG0JNEW6vwBwWa7t7vcAOoh2+V0smfk8Q9tiGYsdVJJVwgZ00dNTg8ZOBCrTWFhjowPy0LtyOvtKtVfs1S+5Hsy9tkyWmeduZavgEZS3UFi9wD82O0I/oIOgMf2U9maJhbwST9K2WExO57bAj7qGFabz6GoXIzmAgkhe5ji0qt2fQTsv7uyrQ2vLEzYo5y8F9vv0KwJA0Ysanaqp5TEYkkBMsLAdgDV0wl9u74QrUCphmgRvJ5XIfYKBsO1KTXECMqPA7dTdQCpeJdF0QTmnfYVgDOx8yiEfUd3V6Fqc1MmfIXFcmtP0cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fi8Gq0ORR+lxFE5A1DGw4hfiiDKhHkiFWce7449cA5U=;
 b=T/RREHHKOpN++z32KVwxD3RbdSVuxMZnffaOWj9A19cOI/Q+74eO5WLg2uqbHeodzuyYKwJIZpiW+4r+5hsVfKFl2oTCDgiKuNu+I2Jeu4agwnSBqTyiIIw7gm2PEM9oMDp5KAbMPLVuDc8rOI/fwcIEks0q+kevax1QZE18h6M=
Received: from DM6PR10MB2939.namprd10.prod.outlook.com (2603:10b6:5:6d::33) by
 SJ0PR10MB4734.namprd10.prod.outlook.com (2603:10b6:a03:2d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Thu, 22 May
 2025 13:44:29 +0000
Received: from DM6PR10MB2939.namprd10.prod.outlook.com
 ([fe80::3583:2675:5213:714a]) by DM6PR10MB2939.namprd10.prod.outlook.com
 ([fe80::3583:2675:5213:714a%7]) with mapi id 15.20.8746.031; Thu, 22 May 2025
 13:44:29 +0000
From: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
To: "aishwarya.tcv@arm.com" <aishwarya.tcv@arm.com>
CC: "chenridong@huawei.com" <chenridong@huawei.com>,
        "broonie@kernel.org"
	<broonie@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
Thread-Topic: [PATCH] padata: do not leak refcount in reorder_work
Thread-Index: AQHbyBzG8YZTDergaEC1EuGadhnZELPepZyAgAAJcAA=
Date: Thu, 22 May 2025 13:44:29 +0000
Message-ID: <afc8bfdaf9f14fa1f77c62f2969c4a5403ad771d.camel@oracle.com>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
	 <20250522131041.8917-1-aishwarya.tcv@arm.com>
In-Reply-To: <20250522131041.8917-1-aishwarya.tcv@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR10MB2939:EE_|SJ0PR10MB4734:EE_
x-ms-office365-filtering-correlation-id: e1a5a23d-eecf-4db0-ec86-08dd9936c687
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Wjd4aExhTnRiWmhqSEpudFBQWTRRMCs5VWQzTmVST1JJUkRxVWhGL2hjNFZn?=
 =?utf-8?B?b1hWMEpNeDl4WjE0T2FlR25tbmpnWmVrU3FEbjl3RkE2UWJxNWpNcnJPcHJP?=
 =?utf-8?B?UFBaT0E3SUYwM1lQaUVYRW1lSm5ZR2Z4V0NlaFFVY01YYXZUMklkSWZHOGRI?=
 =?utf-8?B?MW1lUGhRRGF2bVNBTlA5T0F3MGZzV24rRCtDc1g1aFlmdTBPZFJiSjRQMmsy?=
 =?utf-8?B?VDdNRSs1dXpZSDlMN29MZHlnQjg5MTFlOWNzTXpXK25nb0Q3REhKRk1MZEpM?=
 =?utf-8?B?TDQ4Qm9XTmpzNHZ1TEdza3JCZWhUSEMrV1VDVjA4VDlEUXo1eUQ5ZU0vQnky?=
 =?utf-8?B?YXhzWUpHVUhJaFhUaytqSjRYeUlXVFIyOXFUd2NscW1OQ3YrQVVwbG9hVm8v?=
 =?utf-8?B?U0dSeWdIZmR3bVZZdGh1UXdnU0lrUUVUcGFQaWF1cGtXNmNCZWk4Rm9HTnNl?=
 =?utf-8?B?aEZ2dkFMMnRBQlorc1U2aUdRSm5USnNUaTk4ZGVTUFBzS0NGeGdtTnpnY3g4?=
 =?utf-8?B?dDA4YWM3aDVjR3JvQVBsZjYraFlHZXZOUyt1ZkhVMm93a1J5VjZuNUpYNmwx?=
 =?utf-8?B?Z0JWUUJUMGtxbEw2cm12U3NHK3NwQy90d2F3bEhaNmV5NWI4cmxndkNQZ3NU?=
 =?utf-8?B?WVZFREdkWjhCZ0xHZHpYenNBMlNUVGtPK01BM2ZjRms1TGp6QTdmVGtidHN3?=
 =?utf-8?B?ZGxKTWNId3pZYVhqeHp1M2l2RDIvdStYWHphTytvY3lLR0RqV0tzU3ZudVQy?=
 =?utf-8?B?blRhT2c3STF5ZzBoZE9KcnJuNWhjc3ZyeWJsUnZuVHMyUWdNOHdlZkpDNUVT?=
 =?utf-8?B?RGIzS0JnU0hXais1YjJNNVYzbzF4SzZGRi9BamVYZVlNR1JHSXJZc3EyclA5?=
 =?utf-8?B?NXphdUZDU3A4dHUxNDlIVmRxMU45Z1dxenJXWlhIN21idEJQYjBXeCtEdlFt?=
 =?utf-8?B?bUllQ0xCQUR4OUNNYy9UbDBLNklNUnBpYkRmbUhrYm53MzQvdzZiTlErQUl0?=
 =?utf-8?B?MXJJTWxnUW40Tm5yM3czWHFDc096Z05QS2N5RmRSc1FiSHdWUkhaYS9janQ3?=
 =?utf-8?B?bGJqZEkrWHAvc1oxTGtIZXo3ZDZvNktVTE1WeGFZdGd1eUI4ajZ1Zm1sWFhB?=
 =?utf-8?B?ak1aY1ZRVGtPTkZxamg1WVpPeEFSQ2lybVJKZ0RnQWd6RUZoamZCSXRCeDBk?=
 =?utf-8?B?LzNJamF3VlJLU2IvWTl0dEFSRTA1dXh2VTJmVk5KRVV3eXhxY3U2WFZWbnJ2?=
 =?utf-8?B?blc0cWNIalAvaDB3TEpiblBya1JUb216VXk2RnVteGppNjhEckFPUHhVazNz?=
 =?utf-8?B?UkRHQmRiT1oxK2xxdXNIZkJtLzV1UkMxV1R0QmJ0ZGlpbVNmWk5IKzJadVll?=
 =?utf-8?B?b2RDY3FYMi9CYTM0ZytzUjdYL01JZDcrN0JQWUdmcEgxTmNYUXBpemY3VnRS?=
 =?utf-8?B?ZVpwY1M4OEJxR2prdVVURjM5ODdZVHhUS2pUa2R3K3FXd1BZMmtPMHZ5MG0r?=
 =?utf-8?B?UGhaY1UzbWpCS2lsclpTeXpBbmJBZlVBOWRuTEM0RkU5OVJYTklnekVnNVNZ?=
 =?utf-8?B?UVVNQzdTVzdvSTRKSGRHVk9HUElUM0dXd2prbFZVWjJrSGF4bGl1cmpLcmoz?=
 =?utf-8?B?RFNrOVQ5cXcxbFZrY3dXN3pjOGpIdVZLTmFKUzM5b25PK0VMTzFZYmdzdG45?=
 =?utf-8?B?QkR4K2g4K2RGNE04UkVNUGNqNzJtMlNpTlBwZHRRZ2RVOFlFVWVwYzdQdDdJ?=
 =?utf-8?B?WG16bXRKYmR0RnFRc1Y4RW9mbHF1cXpjZnhOKzNHdWhwWVFscW9pS2ZMb3Rn?=
 =?utf-8?B?SHl4Qi9QOHVhWUtIRmE1cnNTa1BCdVRtYmJ3aUsyb2puOVJheGtvT2FWUE5D?=
 =?utf-8?B?WFkvTTB2Sm5EVmFZZTVoZXNBQ2VSYUNUZENDazgvU2wxS3JsRndPN1Z3bUEx?=
 =?utf-8?B?U0dPOWxpaWFqdDRFUTNIbndNM3MrbnczeVcxUnBJVjZKVFhGekhsanJyK2xI?=
 =?utf-8?Q?dZPYsBmEgVzbVFpCMICBMVMyefie0c=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2939.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RVhFVERpSjlqeklsQWlnSGdOVHp0R3ZxaXI1Ulk0VzZPYzRrakJxUXI5ekJj?=
 =?utf-8?B?TUZQUnU5SjR1VGdJTDk4NlhZam1QSEpoUG1TQUt0aVU4eVFXRHRMVnczVFVE?=
 =?utf-8?B?ZThkbk1CUzAzbkdCMWpheStTVlJOQk16b3V5c1RBd1J4bEZSK1JLbWRMY29L?=
 =?utf-8?B?MWE2bkNZQ3lya3dZVHR0RDRvR0NiajRDeEQ0and1aHR3a3FUVUhuK3FTMGhJ?=
 =?utf-8?B?em1pTFZockJPZ0t0QW4rbGUwREpSd3V3ZVJlTDNLcUZmUG5QM3JtUStnVDZu?=
 =?utf-8?B?VEtTbk02Y0ZDY2pYNVBGTVl0K0lPMkdxdFFKSk4wemtSWmxaTVVHMk9mUFZY?=
 =?utf-8?B?RVdnNnVUM3lCWFNOUUlVYnlUMUxqNGdBTjNGbzZsMFFXL1puNVVQQ2NCcUQz?=
 =?utf-8?B?ZzlseFFwQnFKRWdvYVFOVWIyd01LTmNrN1NPNGFXd3pKMG1mUHFxM2V1Y1Mx?=
 =?utf-8?B?Ym5POU5UWnZaTlVUYTFISzhYaTg3TjkzS1ErNjZiekF5UUR2NkFGMnovaTdW?=
 =?utf-8?B?QWxaMU1RUmJwa1FGck51T2ltUHo0YnhkOEdJY05hZ29vcU5ZVWdiY2t3VlZ1?=
 =?utf-8?B?VnVLOElkNlFreGhFVmpXVlBHWmNub3RhcDF0aGRnNkgrM1gzbUVTM2JqQnpr?=
 =?utf-8?B?WW0xVHZjWkZGOEt1Zyt5ZlBZcTZjWStsVC9JZlFzb3ByQ1FWaVZOZm1jeFo1?=
 =?utf-8?B?c1VJaVloMWM2bkVMYVQ1QnYzOTNQQnJ2SmNzMUtLZW1sampIbWduMUVZU1g5?=
 =?utf-8?B?N3NMd2hpTHJ0S1ZJWU5iOTZiMVUrekxGT3JwSW16dmozbzZhVmYzenRIeTcz?=
 =?utf-8?B?YVRGT1dRNFp5NVp5dWJ0Z3Z2andHdUVSTUZ6MGNPMGw1SUJVbGRjRHRXWFlh?=
 =?utf-8?B?VlcvRTRPWXJiK1RaVHJsbStvQnp0VW1RL0RIdnlyQVpMRVpkWk9Sb3Y5a1pz?=
 =?utf-8?B?b2xnK2NxTGFYUll5cDVwYlNGUG9mUm53Z0p2ZnpqVHhydkFFMFVOMnFTRXE4?=
 =?utf-8?B?UXFWZWdsOFVlYXUzTjNiaGZQS011WTM1Q25maXRIWEdsTEpXSHBQalJWZlJE?=
 =?utf-8?B?NDRhbWhZczQ5MEVMbk41UjJ6cEtRU29OSTJIM01kUzJOVkxZMFo0dG9xV01H?=
 =?utf-8?B?dHlwVmlJVjk0NGgyci8yTE5TYVBXQzc0MGxrM1VGRDNoam1NYXpoczFia2pL?=
 =?utf-8?B?VEZlTFhsRWc4ZXZGT0FIQVZTMjhoVk5kcjRHY1VwOEVHMzZrckdRUlJTNzl4?=
 =?utf-8?B?b1I0V3dtVDU4Ym5iRmxpTUxSbGU1ZERjbnMveUxpTFRYVjJWQUV2YmZtRVZj?=
 =?utf-8?B?OWJ0c2NLU2h1SCtRNE9zd09wTlpUdEgwVGxISDZPSG9BUngrR2VqZkdBRjlU?=
 =?utf-8?B?UzFHUlYzSThuYXJPc3c5NmlqQXVLTVlZcnVaZE0wVzlGQnRQbCtUdjE0U3Rw?=
 =?utf-8?B?T0xOQWYyNVNINGQyVC9PNFhxTHBRUU1LamN1Q3FVQVNob3pzR0hrLzBpdjlI?=
 =?utf-8?B?ZE9LSzRaWFcrcnFORnBManZleWRFOE1HLzB5SGt6RlhUVFcrdGZ2bmRQdG5j?=
 =?utf-8?B?cmpySnpEM0Q4bUYvdjVpQmtzNzU2NEF0ZE1kcHVuaHhBcFg4WG9ZRHdRZUxL?=
 =?utf-8?B?bi85VnZFd1N6TWEwcTc4TmpEYUlsd0h5Mjg1NXkzVXhLZE9zWGFGNm5yN1Zv?=
 =?utf-8?B?ME4zVXVWalltUEovbTk5cWI2dDB6M0tKUjgycTdXTCtEOXBSVmJCWjltMCtX?=
 =?utf-8?B?cXJ6RE9Xb1lGKzNuMjNuUzJkdWR4WHA3b2ZmQXJ3bWdTQk8wVm5XcDFOVWh4?=
 =?utf-8?B?QUV6dnBtVGlPdDVxMG9qYmptclRCeFhSUFk1NGRqNUI1bFptdjNpdFFwK0Vm?=
 =?utf-8?B?VWFwcUsvNm43Um1QV2d6MUZaUkJ2cTR4WDVVZGg0NG15cWFsZjJTbkVWMmt2?=
 =?utf-8?B?VDBycVBsV0NvSzJ5Z3pzSE9SMzJTTWFOekZoUlR1TXQ0RHVUUHhLcDZYazNE?=
 =?utf-8?B?VmZLblNmUldUMFArM3ZxT1ZCdXZSYW1nQWFsZVl6cU0yam54dmZTdHRMUzND?=
 =?utf-8?B?aFpsKzRkMzFXRUZRek9vem80STFzU3hNZTh6Nng0ZnRzQ3NvRDcweDFQNXlh?=
 =?utf-8?B?Qy9VM2d4SGlRa0d5UytsWlkxdGtqcllYc1I3WUxmOGVXeWI4QTNnNFEvUHNW?=
 =?utf-8?Q?KuQVAgF0HsKZtC3Xa5B0lao=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76301AB1D30329428B5846ED750EB6AD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RiOPpq17pJMoVSN84eVFUvAKML3wNh0zTMzDktHbhjTNd0Oe/SmW+P/fNEcYncC21dvHaGouGRqr9kq+YhD5x5wdGHQMtIK3u41oCtHNMQMZMX9t0x1ezPReVTVPur9ENi1rKVGVdguk4rFv86KtwB3kTJrD/sHnwiK1mAH7uAQ95ylOeBgruFqxe1X3MAu4xNr1oEAhKWseJ6ELCIYILskUoF5C8TnvH4EA+VE0zS+/HZtg4perszppXJSThb/rXqv3TgUNjR6b1Wp/qHjwEYrTqmNO1uTkV42bJ489dthNA9hUmKSsjaoQWLmOqefBlcLGbMnpZPyTtbys66KhNmoYEHnYd5smIiBV6UFrAS/SxQFdDUHXWSlpVRfqhirxpFEtUmmm73w1LC1MQXDkJDj0Jkoe0tiPMdgnGe09O+yAZOeAmH1Q9vqzoK4qY3Lc5LmGHLKjcl4YAJKdavgWUg9DfUSAWRkK2wmOJlyh09tCNxHF2bqqQl3oTFNR72+Q/vBSbMQ/8E/NtFjyvQyc/WOpatONe8baaS7fzL2357jPtc0TkEHL9Ar4byiPlmrS4jh8c2IimHBGPXwMaRhY/bSJ9U8JX11tsqBUreni3IU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2939.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a5a23d-eecf-4db0-ec86-08dd9936c687
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2025 13:44:29.4337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /W90jpA936KWhG3ktR8S2mPLG2ECjatVdU6xTwvjdtycjwPzrmsKlHTY5sIkUROCl8506t/xCUR3/Idip5oLTuC1zULby6aBvtAyi6tNfqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4734
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505220139
X-Authority-Analysis: v=2.4 cv=WugrMcfv c=1 sm=1 tr=0 ts=682f2a41 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=DuBMkiAWZkss6Ydtu0EA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206
X-Proofpoint-GUID: yYGX-FwIdBxwTPum8HPxOfqhDRDyc6-k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzOSBTYWx0ZWRfXyUuEWHA/tOTp 6r2ShYPaCOR/ncZ0lpnjTqD8UD7MwTVH0ELHy/7ILi8fPBNaBfyQd/jIXBViMupedr1hoglt96+ OxoD0OKlYOjDgdzHZUxCkuvg0NT4J2O+TmobvPFhlpm3mTztatvHy6umD3PeZyZp4UXRLwo9Gfv
 yGt57fG+yQF8IZxtAIQDVDDm8/8Hu7tgy9dcGmWu9FSYAsTXaCEyp9VL/OtOFq07fsVSSeirWHi ePyVUg+RKTO1G94NSlTRWsJMQjMwv/yRIPI5f4YWkmW8e2lCfLQdUxjOKsMp6DiRw+mC8gqip54 PBG8Bs6D6VEXqWwpvdzG0D+pQmcPjPrdMe+hd9JFgl/NAajb3S7s+epGl43tpyZNvQ09xoWXfl8
 CHienVRCQY4E+5O5AxY6nmyUCN6PWbhKu8S4BipviYmoqhA3hNJAIFM6NVTqvguA26zkzxRM
X-Proofpoint-ORIG-GUID: yYGX-FwIdBxwTPum8HPxOfqhDRDyc6-k

T24gVGh1LCAyMDI1LTA1LTIyIGF0IDE0OjEwICswMTAwLCBBaXNod2FyeWEgd3JvdGU6DQo+IEhp
IERvbWluaWssDQo+IA0KPiBJIHdhbnRlZCB0byByZXBvcnQgYSByZWdyZXNzaW9uIG9ic2VydmVk
IHdoaWxlIHJ1bm5pbmcgdGhlDQo+IGBrc2VsZnRlc3QtbW1gIHN1aXRlLCBzcGVjaWZpY2FsbHkg
dGhlDQo+IGBtbV9ydW5fdm10ZXN0c19zaF9taWdyYXRpb25fbWlncmF0aW9uX3NoYXJlZF9hbm9u
YCB0ZXN0LCBvbiBhbg0KPiBBcm02NCBNYXJ2ZWxsIFRodW5kZXIgWDIgKFRYMikgc3lzdGVtLg0K
PiANCj4gVGhlIGtlcm5lbCB3YXMgYnVpbHQgdXNpbmcgZGVmY29uZmlnIHdpdGggdGhlIGFkZGl0
aW9uYWwgY29uZmlnDQo+IGZyYWdtZW50IGZyb206DQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL3Rvb2xzLw0K
PiB0ZXN0aW5nL3NlbGZ0ZXN0cy9tbS9jb25maWcNCj4gDQo+IFRoaXMgd29ya3MgZmluZSBvbiB2
Ni4xNS1yYzcuDQo+IA0KPiBBIGJpc2VjdCBpZGVudGlmaWVkIHRoaXMgcGF0Y2ggYXMgaW50cm9k
dWNpbmcgdGhlIGZhaWx1cmUuIEJpc2VjdGVkDQo+IGl0IG9uIHRoZSB0YWcgInY2LjE1LXJjNy03
LWc0YTk1YmMxMjFjY2QiIGF0IHJlcG86DQo+IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQNCj4gDQo+IEZhaWx1cmUgbG9nOg0K
PiAxMTE5MyAwMzoyOToxNC44MDY1MDLCoCAjICMgcnVubmluZyAuL21pZ3JhdGlvbg0KPiAxMTE5
NCAwMzoyOToxNC44MDY4NzbCoCAjICMgLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAxMTE5NSAwMzoy
OToxNC44MjA5MznCoCAjICMgVEFQIHZlcnNpb24gMTMNCj4gMTExOTYgMDM6Mjk6MTQuODIxMjM2
wqAgIyAjIDEuLjYNCj4gMTExOTcgMDM6Mjk6MTQuODIxNTE5wqAgIyAjICMgU3RhcnRpbmcgNiB0
ZXN0cyBmcm9tIDEgdGVzdCBjYXNlcy4NCj4gMTExOTggMDM6Mjk6MTQuODIxNzczwqAgIyAjICPC
oCBSVU7CoMKgwqDCoMKgwqDCoMKgwqDCoCBtaWdyYXRpb24ucHJpdmF0ZV9hbm9uIC4uLg0KPiAx
MTE5OSAwMzoyOTozNC42MDI5NjTCoCAjICMgI8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgT0vCoCBt
aWdyYXRpb24ucHJpdmF0ZV9hbm9uDQo+IDExMjAwIDAzOjI5OjM0LjYwMzQxOMKgICMgIyBvayAx
IG1pZ3JhdGlvbi5wcml2YXRlX2Fub24NCj4gMTEyMDEgMDM6Mjk6MzQuNjAzNjg3wqAgIyAjICPC
oCBSVU7CoMKgwqDCoMKgwqDCoMKgwqDCoCBtaWdyYXRpb24uc2hhcmVkX2Fub24gLi4uDQo+IDEx
MjAyIDAzOjI5OjM0Ljk3MzQ3OcKgICMgIyBEaWRuJ3QgbWlncmF0ZSAxIHBhZ2VzDQo+IDExMjAz
IDAzOjI5OjM0Ljk3Mzg1NcKgICMgIyAjIG1pZ3JhdGlvbi5jOjE3NTpzaGFyZWRfYW5vbjpFeHBl
Y3RlZCBtaWdyYXRlKHB0ciwNCj4gc2VsZi0+bjEsIHNlbGYtPm4yKSAoLTIpID09IDAgKDApDQo+
IDExMjA0IDAzOjI5OjM0Ljk4NDc4N8KgICMgIyAjIHNoYXJlZF9hbm9uOiBUZXN0IHRlcm1pbmF0
ZWQgYnkgYXNzZXJ0aW9uDQo+IDExMjA1IDAzOjI5OjM0Ljk4NTEwNcKgICMgIyAjwqDCoMKgwqDC
oMKgwqDCoMKgIEZBSUzCoCBtaWdyYXRpb24uc2hhcmVkX2Fub24NCj4gMTEyMDYgMDM6Mjk6MzQu
OTg1MzY1wqAgIyAjIG5vdCBvayAyIG1pZ3JhdGlvbi5zaGFyZWRfYW5vbg0KPiAxMTIwNyAwMzoy
OTozNC45ODg1NjjCoCAjICMgI8KgIFJVTsKgwqDCoMKgwqDCoMKgwqDCoMKgIG1pZ3JhdGlvbi5w
cml2YXRlX2Fub25fdGhwIC4uLg0KPiAxMTIwOCAwMzoyOTo1NC41OTc1NzLCoCAjICMgI8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgT0vCoCBtaWdyYXRpb24ucHJpdmF0ZV9hbm9uX3RocA0KPiAxMTIw
OSAwMzoyOTo1NC41OTc5NTHCoCAjICMgb2sgMyBtaWdyYXRpb24ucHJpdmF0ZV9hbm9uX3RocA0K
PiAxMTIxMCAwMzoyOTo1NC41OTg0ODfCoCAjICMgI8KgIFJVTsKgwqDCoMKgwqDCoMKgwqDCoMKg
IG1pZ3JhdGlvbi5zaGFyZWRfYW5vbl90aHAgLi4uDQo+IDExMjExIDAzOjI5OjU1LjAxMTE4M8Kg
ICMgIyBEaWRuJ3QgbWlncmF0ZSAxIHBhZ2VzDQo+IDExMjEyIDAzOjI5OjU1LjAxMTUyNMKgICMg
IyAjIG1pZ3JhdGlvbi5jOjI0MTpzaGFyZWRfYW5vbl90aHA6RXhwZWN0ZWQNCj4gbWlncmF0ZShw
dHIsDQo+IHNlbGYtPm4xLCBzZWxmLT5uMikgKC0yKSA9PSAwICgwKQ0KPiAxMTIxMyAwMzoyOTo1
NS4wMjI1MTnCoCAjICMgIyBzaGFyZWRfYW5vbl90aHA6IFRlc3QgdGVybWluYXRlZCBieSBhc3Nl
cnRpb24NCj4gMTEyMTQgMDM6Mjk6NTUuMDIyODM0wqAgIyAjICPCoMKgwqDCoMKgwqDCoMKgwqAg
RkFJTMKgIG1pZ3JhdGlvbi5zaGFyZWRfYW5vbl90aHANCj4gMTEyMTUgMDM6Mjk6NTUuMDI3ODY0
wqAgIyAjIG5vdCBvayA0IG1pZ3JhdGlvbi5zaGFyZWRfYW5vbl90aHANCj4gMTEyMTYgMDM6Mjk6
NTUuMDI4MTU2wqAgIyAjICPCoCBSVU7CoMKgwqDCoMKgwqDCoMKgwqDCoCBtaWdyYXRpb24ucHJp
dmF0ZV9hbm9uX2h0bGIgLi4uDQo+IDExMjE3IDAzOjMwOjE0LjU5NTMyN8KgICMgIyAjwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBPS8KgIG1pZ3JhdGlvbi5wcml2YXRlX2Fub25faHRsYg0KPiAxMTIx
OCAwMzozMDoxNC41OTU3NzfCoCAjICMgb2sgNSBtaWdyYXRpb24ucHJpdmF0ZV9hbm9uX2h0bGIN
Cj4gMTEyMTkgMDM6MzA6MTQuNTk2Mzk4wqAgIyAjICPCoCBSVU7CoMKgwqDCoMKgwqDCoMKgwqDC
oCBtaWdyYXRpb24uc2hhcmVkX2Fub25faHRsYiAuLi4NCj4gMTEyMjAgMDM6MzA6MzQuNTk1MjM5
wqAgIyAjICPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE9LwqAgbWlncmF0aW9uLnNoYXJlZF9hbm9u
X2h0bGINCj4gMTEyMjEgMDM6MzA6MzQuNTk1NjIzwqAgIyAjIG9rIDYgbWlncmF0aW9uLnNoYXJl
ZF9hbm9uX2h0bGINCj4gMTEyMjIgMDM6MzA6MzQuNTk1ODU5wqAgIyAjICMgRkFJTEVEOiA0IC8g
NiB0ZXN0cyBwYXNzZWQuDQo+IDExMjIzIDAzOjMwOjM0LjYwMzgxNsKgICMgIyAjIFRvdGFsczog
cGFzczo0IGZhaWw6MiB4ZmFpbDowIHhwYXNzOjAgc2tpcDowDQo+IGVycm9yOjANCj4gMTEyMjQg
MDM6MzA6MzQuNjA0MTEwwqAgIyAjIFtGQUlMXQ0KPiAxMTIyNSAwMzozMDozNC42MDQzNDLCoCAj
IG5vdCBvayA1NSBtaWdyYXRpb24gIyBleGl0PTENCj4gDQo+IFRoYW5rcywNCj4gQWlzaHdhcnlh
DQoNCkhpLCANCg0KTG9va2luZyBhdCB0aGUgdGVzdCwgSSBkb24ndCB0aGluayB0aGlzIGlzIHJl
bGF0ZWQuIFRoZSB0ZXN0IGFsbG9jYXRlcyBzb21lDQpwYWdlcyBhbmQgYXR0ZW1wdHMgdG8gbWln
cmF0ZSB0aGVtIGJldHdlZW4gdHdvIE5VTUEgbm9kZXMuIEl0IHNlZW1zIHRvIGJlIGENCnNlbGZ0
ZXN0IGZvciBtZW1vcnkgbWFuYWdlbWVudCBjb2RlLCBhbmQgSSBkb24ndCBzZWUgaG93IHRoaXMg
cGF0Y2ggY291bGQgYWZmZWN0DQppdHMgb3V0Y29tZS4NCg0KRG8geW91IHNlZSB0aGlzIGZhaWx1
cmUgY29uc2lzdGVudGx5LCBvciBpcyBpdCBvbmx5IGhhcHBlbmluZyBvY2Nhc2lvbmFsbHk/DQpJ
J20gd29uZGVyaW5nIGlmIGl0IG1pZ2h0IGhhdmUgcGFzc2VkIGJ5IGNoYW5jZSB3aGVuIHRlc3Rp
bmcgdGhlIHJlYWwgY3VscHJpdA0KZHVyaW5nIHRoZSBiaXNlY3QuDQoNClJlZ2FyZHMsIA0KRG9t
aW5paw0K
