Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB9130F934;
	Fri, 31 Oct 2025 22:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761949103; cv=fail; b=Wz301bK9bTDME+NOsj7sGPEX3EdmqkgDRIlYxTbyW25QCQFehM07XRDbCxw122fpSNsg1NIKz0E74jmEM1ZEg2fnaz1I53TNdnryBmLrzt2ru3P9Z+oxiphAE25gsWdrNErA5u48OhhWn1EOk8sAvIddHsQZUbSZnPxx/4KXF9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761949103; c=relaxed/simple;
	bh=wYxOUGkwrT+F65by5cyOsLGKagEfk28rcTE3RU+B0RQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kjheik0lE+KMNxvrFsykU9aIye/xQBGgJ2J69jYLS3/WnWlRWGW630Vy9BOFWAR1FG3DbLyMc4EfJxKoiGmlwub5DM3JII1HOovhcPNrDY49umkKtZlrKIEcUUJsKTn5RZh/AasvGxRCMHO9VVGJVDmJqoNkxk+74HDOw793iic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ia65FlWv; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ia65FlWv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761949102; x=1793485102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wYxOUGkwrT+F65by5cyOsLGKagEfk28rcTE3RU+B0RQ=;
  b=ia65FlWvLFeBE7DMSgC3UzzLTLXzSMI8fdbUcRMZGM27grfB+TLNph8W
   cq5HGil2ZdO38dzB5QawRIxxyO7vfEyeuWUGKtn045TITgTVY/2IqF4Dt
   5o1HUbt8/d1O2kyk5nmmjw5lQmnoG7D9snOwijKoNCTEy71SmgYUIkpvY
   ntYhWIGPpMRff+VFIzNn72wrfr08mlsrSPmF/qiFRR+wGiDrFcjCE/7qE
   IEWb4ISnTAyiSGkyuXNjq+z2klo6TUZ/1SDqH0c+6WZJep1mVrb3d1hru
   V93/Xwbi+hwr0VPKey34KISypFk7marIrVAUUHLfsiA08W3Y4iAphhSZv
   A==;
X-CSE-ConnectionGUID: ONOKUezKQKyM6HrqbJF6Jw==
X-CSE-MsgGUID: SiBJpfFSSgWrh03GPmT7SA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="66731619"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="66731619"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:18:21 -0700
X-CSE-ConnectionGUID: sazW/QyaS6KvghdAP08OUQ==
X-CSE-MsgGUID: X2RXGO52SrSFAN9SQVxjkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="186008585"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 15:18:19 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 15:18:19 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 15:18:19 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.13) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 15:18:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9tpLP2vWnWd0qv0l9VR3hcCXuct7oySXCuoEfpv5Sb9ZZUufXC0JyoxeO259woD10XD3QmCKifYf7M3KtFwzRsQSlr5iVRnYD+sGyhMMNiikPE616lQ19n0E2+G2Cyw3qrnuzg7foRJS855zl/j4o0o9g5NG736MgzYXrjV3kMvB/++Z+DrndWRLqrCqzShJB45gklKhv5xAsresRkeJD7ZUGSTQ18m/OELHZIB6f0TaljPmDN0tD7tTr+kZj5YcOV23pl7YbZSA0HOwE9M//Dn8bEBaxCp3VE1is3PgGrJfp8bWbmTrbOlS4qucuOLaTvGclXGwJH5cxTVxKmlaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/R1qE0w9p9BeLKDozZH8/yd+YL4HC/gCZRscHHCFbY=;
 b=E1KesvBmKH25d8hNUrDXiz/AHGWlohz8oF8jOFdKAHBuU2zPAan6+kiX+XMu87r4qK66Ky9tIj9hns3zdva7gfnRZ51wF6DFrlp8ZI4hGcZutTY1vsbxA3kHMKxzliivYxC4z8mYbbhGvizSdAUk7OzBFd2iz9DtsP5Wp5PLs0cHJ+7SoD6C7QfI1AQEtyKAp7ImwzldqR9CGogp1EwWGwkO4QWvvRDbYTe/TgwPem8uZcQL8bO9DN6UpSPpgGLGMvskNhDF2IDkX1RRD+19pRyqLkv3/OdFaW5BH83mWryS7GsTId9eZtpqjfVyrMbU+lI2FLMbgoKOw8kUrxbL1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by CH3PR11MB8548.namprd11.prod.outlook.com (2603:10b6:610:1ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 22:18:16 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 22:18:16 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>,
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v12 23/23] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v12 23/23] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcLpaX/mj7hPY+6kiBJ5YxIIp/iLTNyUoAgA9BOsA=
Date: Fri, 31 Oct 2025 22:18:16 +0000
Message-ID: <PH7PR11MB8121A3DB59F5D00279D08218C9F8A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-24-kanchana.p.sridhar@intel.com>
 <aPhpCGz1dWoZsMeH@gondor.apana.org.au>
In-Reply-To: <aPhpCGz1dWoZsMeH@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|CH3PR11MB8548:EE_
x-ms-office365-filtering-correlation-id: 52acf3c3-c9ed-42d5-bedb-08de18cb6400
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?hcaot2ysx1DeaP127+I2x8XmqepYf8Gl3PQReo0e2cjo8gxbvKOGuH2vCyiw?=
 =?us-ascii?Q?1C3cyHaUTAHQgv9lIWjPN8U2q6ZWnPVu8X4pIchPUldFs+ZiNefPQyqzkXLs?=
 =?us-ascii?Q?I+zdCQooIxaNb7HJGPNrNpsJ1w0uLEXw8LWC/f/JSN8XU1bPHBp+gdqiCY5o?=
 =?us-ascii?Q?zm9C3z/13DyZPkUPcoZhLLQ7KnEI/ahHpJKSYdCXw+DHddH/vDSBHZ5iqC50?=
 =?us-ascii?Q?/O6dPlMh2MCD9zgIr2SlpqwL9Ww0fGHfCu5ay4n1AHTUYIMYSYBRfMkDvPWV?=
 =?us-ascii?Q?i8LVB1Bv2AyigEG2uXJ9V3lxTcVK9QGAh+K0bPJv6IF9qpBKi2MLJ4xAtzoe?=
 =?us-ascii?Q?968JnSqEMQX53Azct3/ZW6q0ZXBwTFpxLGeYZkrz9geXch3hU9hQQjfPu++F?=
 =?us-ascii?Q?RxS/zC+0XIfUJeTQm+L/sbk4pPx5NUEUda+121B201d/mKFb74bNeiDLHpXX?=
 =?us-ascii?Q?WT6H2U0SWkAdT3MHOd7PDs0Hu7EhZYAqTR7OUtH0FsvOJhgjjnbY+hplcHg7?=
 =?us-ascii?Q?wxzXS2p+EdcwEPnh61ENQsTu1sLhG5RMvSDuNrIs73bOCa5U4UFx9ZpTOWjm?=
 =?us-ascii?Q?TC2KzFV9IIKlEvSCedBphtYspQljYUWdq/F7UlQ44KjES1YZZHpNqE8xMLya?=
 =?us-ascii?Q?3hR03udLzRQwAu3uO/ZXbdlnt8mmTMRFTuu03poNlMMrjvk8c6kh38QxD1P+?=
 =?us-ascii?Q?CzRp1mpcmFlmkQ5ntwW8lEd1MipzEWN/kx2eZaCulc2sUNBXqibEHPt3HccY?=
 =?us-ascii?Q?kgI7T4ez1ONEsMBka+7KSfzUR29emT+g5w9VUfERSHAbUMMlX6pwogaPhCyP?=
 =?us-ascii?Q?XlIkMHvfr3RdP2ydwgszCctG1j4d7OpfA2K58GsykaWrCVYoEHEMTGdbx0HH?=
 =?us-ascii?Q?1gnbU/Wlvx4tX4uSZRuxYGpS42/ihW/8xA3kqclqGvLpbpOBSohZ/+upq1wV?=
 =?us-ascii?Q?YE7mekh2bvCCsSy+Fy6cgtSepY3KeuRBJR+M9DrKFF9aLo4tnk60bQBEbfc+?=
 =?us-ascii?Q?qYqONFamJrjFncOQkKcvChhVCkR/jQseaAf64vu6tYF/rTAMwJjNvpknuC+f?=
 =?us-ascii?Q?j23hMVy9d3L4rWCMumSOWsfZ2JSG/IRtXHkflLMTX3aY347grY6edc/18t1K?=
 =?us-ascii?Q?1ykNUW1cUR7Xe87SFXAudI4Rf72aGjaAyk+VOyxzCdv1hwUkECXJ7g58eLC/?=
 =?us-ascii?Q?QZCiADhRe+ayK9Io3ieya44UrLWpSyAqKhf4+YNkpTsLhQIG63QBUZ7VigXI?=
 =?us-ascii?Q?11XQ1CnmvEVjn1BmX1YP068erAkJc6mCzv+pcpVPm+2N2+Lh65uQ9CEhvzNe?=
 =?us-ascii?Q?7eu9HyfxhS3cU7K1dZlJqcxa0PPwbGTyfduWTeD+NYf0vqcpie1TK/pRaoBi?=
 =?us-ascii?Q?SeQga5ulzajoYBD0e3RgWf1LCUQg5ITYzbQ0I6vBY2XEPFWfTDQW25Kv55U8?=
 =?us-ascii?Q?UfyDTzNcm9Gb6+nHONVM65xAokZcwus4PS2zTzYY1/1Jek2m23Dmlw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DOpVHW/pYWwb1zkQjpQYYZwsRXich9czn10vcXjqbGFf/OvImegDApTZI4qn?=
 =?us-ascii?Q?V1IlwBZQVgmx2/hdvMc3/8OmmW7uOeLLPJ4U+HengjHbqZCrRwBpGj3nDmKi?=
 =?us-ascii?Q?jY3tZo/u5H5Kp31O5KCRLUp8pegWDZkpjVOnqhbKtG9BQxK2DPZet1CWTNEG?=
 =?us-ascii?Q?fH53LKb1ufM1ZCgEsMGXMrFXCMkZo7oMwDU26MQa+cyV0tXq/e6YdQn2ywgv?=
 =?us-ascii?Q?QIDrPcdtCPyT7koTRyPeChsYnEaSSImsuvIppysPHCIImZJSC3fMb5v0w34R?=
 =?us-ascii?Q?fm+RwAqROuBssTZFLql3r6gOOj+mRwV5XHZtgFPFC+WqtkkTTjGimN5pvTom?=
 =?us-ascii?Q?CfFeJlaLZp4cl7UOuqgCt7Ve1BOB1EabEOOtySUhHYqxgY3qmoDkwUhlRh7w?=
 =?us-ascii?Q?mBl2NLRO5VA58YqhAzAP2vWg/0X1j/2IYoPmgxcOeTdvgAEkoyOODLLnAjKU?=
 =?us-ascii?Q?as4tYWpXXQ/S1GGOAuzAwa+XXMAiBwPLmuQygEg+QTtH3RifCVX7UVS3WHjK?=
 =?us-ascii?Q?NYB6MDWkiObX870KRnPmhWFy1rxKoilGc0MCV12z3H+6xwoHhh0IcUcQGzxY?=
 =?us-ascii?Q?I4ahNvlRPGx7PSza/LTaHyM/Rbn8H/JJYHOcrezNOuJhjRI0DJD7DJElLtBP?=
 =?us-ascii?Q?5OBHIAPfFlWwJh6FLemfE9cQP/DmCSKgqTk+MIAoQug8T+NBivGZFQgJCS6X?=
 =?us-ascii?Q?h0dXwrd0vFD3+xuOl8AW0qfvH43rqh0DEQv9QVQc3yfLgRGs9YqG7er4SLYl?=
 =?us-ascii?Q?8rwYR4PGxuXni+ONegHWqYRYZMy9IRRV3ZPHcU8GMgVYZky5S0LJQSLOIPTQ?=
 =?us-ascii?Q?x0DhRYV3EcyqYnt/zi+buBKJT30Zbb5DINi3aTNPkMzwXukNydeZvFNdPuBS?=
 =?us-ascii?Q?2E1S+hVINzVhKd7787kgis6+LgZ1Ev3DS8T1K53xDUqeIDnvJBK0QyPat2on?=
 =?us-ascii?Q?AIByhaYkX9okKSOvqYeD7LTiLoIaSIvO/81M6SpL5IKwSmsH26lJqG9PlAmO?=
 =?us-ascii?Q?egKzs5g33BKf4Irru0E843lmQDkiJk6qQK820xp6xZo6Mg528FRg6Xc8ZXAK?=
 =?us-ascii?Q?wNNpd9PNh89TnBxV2zBjJ3fHV1o/IkgXZTtV/AzmDAHVQxVerZYkoRmd8xnD?=
 =?us-ascii?Q?vjvpLoYvFVkVB2L0ErGJZBeXnAUAXCQTyLKHI2+TTSgnHJ8ZxsKJwlGJJNBL?=
 =?us-ascii?Q?492zKuZnnd1B5JZU8Kd0oN8G9erwq2Cc8lXXXLg/ilyvPzo9QDVDuPUE8HoN?=
 =?us-ascii?Q?CFvY3uygH/AF9DQ3C69Q/UA+Ohxor7z0bQcoppX2ck2tTHHbD+lOMlXNJ2DH?=
 =?us-ascii?Q?4mI7V5hMh8spCKCTr7q3d1Seex3tnNUAU5kn4TAz7kQdRNDOVYBvqMQt0tvJ?=
 =?us-ascii?Q?IzqN+T62PtS3oMcT2c2KUAvY81aatXxbbG1WTEgSCNRMdUmakw4QjdFUgVZU?=
 =?us-ascii?Q?8q/mjPev+85EKNrwdDropiiJ8xFdk+qGPxONwSm4XB4tRcG5bVvsKjghdSpj?=
 =?us-ascii?Q?P7Iu/bXtTwoYrYMULipsTc2MaDBQfSPnFhSeJzUuFbJl+iVj+RWnRl3yraw+?=
 =?us-ascii?Q?wAe17kP5uM+nJYRS7Kat8b8tR6jNl0fULkgyHgw+8EGYJbHkhAJFGcigFBlR?=
 =?us-ascii?Q?iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52acf3c3-c9ed-42d5-bedb-08de18cb6400
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 22:18:16.8332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0K5TDpG3+TH8grTr2XTO72/zzZvqg3sarUDRfum9+nqAxYfwUBlNxpTPHVfQcg2YtWhJRZNPEzB5+79OQferBWFVRE/8wHQri+JwypTLUQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8548
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, October 21, 2025 10:18 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v12 23/23] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Thu, Sep 25, 2025 at 08:35:02PM -0700, Kanchana P Sridhar wrote:
> >
> > Another initialization level optimization that happens in
> > zswap_cpu_comp_prepare() is, only for batching compressors, we allocate
> > extra memory for "batch-size" int pointers in the
> > @acomp_ctx->req->__ctx[] that are statically set to track the output SG
> > lists' lengths. This optimization was necessary to avoid the latency
>=20
> There is no need for this allocation.  Just store the output lengths
> in each destination scatterlist entry.

Thanks Herbert, for this suggestion. I have included this in the v13 code
that I am currently validating and expect to post an updated patch-set
within a couple of days.

>=20
> Before the call to acomp, the destination SG list should contain as
> many elements as the number of units.  On return, the dst lengths
> should be stored in each destination SG entry.

Yes, confirming that this is the case.

Best regards,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
