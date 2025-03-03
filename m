Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CFC1EE00F;
	Mon,  3 Mar 2025 08:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740992156; cv=fail; b=USoYo2udUUcNarC4G6vGkfnuKm9HWSRVtN+LOCqynna+Ib7p0A0tL0iSm2Zf0NyiaAGCk3EbpjCrJPG2InItHndf5AKjGo6bCYHZej9S2z9ru8dnLCJ/K36JyBO5ZnBTe2eRaQSiAtgbk+kbQnLm8J5G8emX7hwxPpzFlj5XKH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740992156; c=relaxed/simple;
	bh=Min+fjdbnCnlSVduUg5NKMz+Phjqb3Egf4pdzRpIz9s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DGxosY5O5RX/+IQtjJnGQHUPa0i3OzcB5eNomPQCXEC4FrvQlo+kJp/9VLC8b7x+t0Lqb8F4A3D282REzCAWeyj6FrpHVZOM9VyZH+vH5PGe39e+FgEkrXoHRAToTQ2kmPe4+9uaezuJJjSBIFihH9LZYg5p/cOdQcCwsw3wyQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CM6GTkZR; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CM6GTkZR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740992154; x=1772528154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Min+fjdbnCnlSVduUg5NKMz+Phjqb3Egf4pdzRpIz9s=;
  b=CM6GTkZRufc/C7Esqg5Or3Y+PiPZO72S7/Fc7weYDerNuEelIys/Y8LU
   1ZQmuVK5ExzXpcQGeg/NmP/kn87B13mjxAt/6ZHLqqTLaBrA67VkUzbvv
   qiE2JoFItkFdw2v8zdUh0thIToycoLoPZ+Z74lCXohnneycGofyNzUW2d
   eP8EgtdfIMzRJiul9oEoR6mS/uJr7mrQ+qSHvhR7vbg7p229LSU8N/I0q
   BmJNIsRpByA23R+IKyWJxcg7dLyT9Rkg/6ZXcKklyjSSmz81MDvna6W67
   KEryas6R/CFHYv/TUXJWwanpXB1i3pNhiZyncWGRHjN0xcFE1eQkm1XxE
   A==;
X-CSE-ConnectionGUID: e/jGNvbPTay0jtnWJqF1gg==
X-CSE-MsgGUID: y+uH5QZtTUurFB1LE12IZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41745095"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="41745095"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 00:55:53 -0800
X-CSE-ConnectionGUID: U/fo8U+UQ1mFZecIvYPCVg==
X-CSE-MsgGUID: tDuqug+oRTO77Y4fySBK2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="148749054"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Mar 2025 00:55:53 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 3 Mar 2025 00:55:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 3 Mar 2025 00:55:52 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 00:55:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SOoVt3RmpnsE/sjXGqoR8E+vRSyHIMG+JcgU1kWz3jAtOYKSytwXrJcV3HojBYi4ozXjP3OZm/UYttmWCV+OMCMgW2kI29lCK/WtcD3+syqhLlt65RgJCoxcm851Yj/KTjovRUjD0rCUYlmVmj2jfw8PppOC/aKka8uOUOVkUwsR6y+iqPWFsfDvgatog7KHWykwx/+tHlaxRfBxRgIuD66S3sCCYdAQUXNm48pk+udkox0QoMySzWlkqHzx1KT9j1V1QAGer5VWMaS7T47K6xsUixZRIjoBTR1HqX8GjmKxwZoI5hNg+j8V/GRTsMboNgBYbvkSDtGcBM2ohhr+aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kap8I7/1Wmf4BaNc0RE3N22xV0q4bEWw5n33+fBfggI=;
 b=g6ojZqpQS51YgRYryfw/B5yIy7755sBPjZEIJmTYwizRCPjthPmd8WOtQGBmAp/pDwnZhmpeSSOUzUVj0kedeDL3PbjPFkIhzaQGPbvtqZqQDnTeRZnFaGjJ3BkEPAn8Z6zH2Eu1uqaXR0d4u/RSN/ibeAzAdt/Kw/UMmg2j5aHW0ADAminFKpg66eCTGq/bnIGW/b5loY/lbNts2pVxV/aA9O8TeP65Z50Yztl2FTK0hdksaskvXqU7CJYraxK2AO6ymUVpj+gKfgfe1rMxzLoDYp0qzcd7RDmvxGG7LOMRCFBomWH0gnuK1Ju70hP09m4swtD9U3XKD0T+6U9eNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20)
 by MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 08:55:09 +0000
Received: from BY1PR11MB8127.namprd11.prod.outlook.com
 ([fe80::6f9b:50de:e910:9aaa]) by BY1PR11MB8127.namprd11.prod.outlook.com
 ([fe80::6f9b:50de:e910:9aaa%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 08:55:08 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v7 00/15] zswap IAA compress batching
Thread-Topic: [PATCH v7 00/15] zswap IAA compress batching
Thread-Index: AQHbiceg39kI/20AU0W9GEohTPKAv7Ndd0cQgAADMYCAAAEzoIADo1XA
Date: Mon, 3 Mar 2025 08:55:08 +0000
Message-ID: <BY1PR11MB812777346DF1D0E693F9F9FAC9C92@BY1PR11MB8127.namprd11.prod.outlook.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
 <SA3PR11MB8120AD2AD0A9208BDA861580C9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z8JfA5eJa-HUbYO3@google.com>
 <SA3PR11MB81204DB5927750D24860FAEEC9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
In-Reply-To: <SA3PR11MB81204DB5927750D24860FAEEC9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR11MB8127:EE_|MW3PR11MB4665:EE_
x-ms-office365-filtering-correlation-id: 31e79eb6-e809-4b89-4244-08dd5a3119c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?wg654anvvubbk3infikckBkLS/hgM53qRIQS0lYZXHJmb+izvmJSR++HLMmF?=
 =?us-ascii?Q?YWUFEVztyy6zr4LEzdqO6V70c5XJXv7+gQ4gicC4P3bXeCCkOqxtmiuKEHpf?=
 =?us-ascii?Q?gKaV5kDbXJdrq7kM6qOq+bPVXvmOdnK1uJ0pgoC5wD49VEijbXZ12oHd7jjQ?=
 =?us-ascii?Q?AKXVQDWskHdGxp/0gLihFrgE8rIojn08RnHsTvYUwWu1z69NHj+3rNkkWB3i?=
 =?us-ascii?Q?viHgjbc5eI7YJtjAIA8aWRkQxIlF2JzDXpknori2qMMB2aHtnOpZjS8Q+Ld3?=
 =?us-ascii?Q?fn1XXlbWPjU9SF7kIgG5CFCryZ622kN+8mUPUDKHC8qq/Q+3F+sgfkDsg+ER?=
 =?us-ascii?Q?VMArOK8kihDCNhnROUSFWPVFDejzkfKXiSv7OYki5pN2Kl8POvVBSdDDrKDq?=
 =?us-ascii?Q?Qdnz7KZi2O7VzCZWJq5CBynEJWxB9u8x96UCtsG6tjK4DmFsXXdvZ5a0Bbu5?=
 =?us-ascii?Q?Eefj8BRRnIIV+4WyPdm+Q4vOHHsQcaYHoOrj30xyvO0bucZymBOJhW61G2Rm?=
 =?us-ascii?Q?mSXKj+lWL2mzud0E9CTrkEyay9Um/lxduUTbEVyrEx+tFs71K3FQm6Fgc86q?=
 =?us-ascii?Q?yvJez5OHSqea5RIE8pZ4NDQapfX4WdDBsRNTmqHRsoJiNVg6jeSVkMjl8mo1?=
 =?us-ascii?Q?1h7leODP3bOABusyHGsw3IjnCL9DqFn8IRo2UBFFhD3SngOb4VLGGl0CmZ20?=
 =?us-ascii?Q?66+Gf7KnFBgGOJfSHVQtaOoSkhSpIU59cHWQ+667+Rs0tc5eqwQPWLN3iaMD?=
 =?us-ascii?Q?rb0xP/R6XbL/pfS443osdEHREtmy2VtJMasq5fV1V3Rir1x/CIf+fgf739uG?=
 =?us-ascii?Q?johcvjpdzOGP88uwsuZrUMdt6QYWlx7VOVtp2Sy9fvxS9TQkxZgNIHzYH9es?=
 =?us-ascii?Q?96K6/VpQxjzqA+OWsBdOsX1jo6CJbuU+lKQ79Q/J1l2jVT2TW5CIf+9zXnTc?=
 =?us-ascii?Q?HcEMxOv9kh+ViwXZPRUhnG0s60/YghEmf/5nISeIBnxcMCMp4nnjbhqtjrRW?=
 =?us-ascii?Q?J6lpcWEnwODmSAo8w7A98lnwRLO+ppROWeNpI1U4gy7ZbAEFwUwzSzXcpZr+?=
 =?us-ascii?Q?6U+gsrU4YwLbqYKjaCfqmrHFvbjPL5paEwNNa4tYxI0nhOl7Ymqq2OTFnaob?=
 =?us-ascii?Q?QRVbRr6NbxEn7F0RHfOKo6ggOMqs3uwmoYaQ3aTK5KhuoY3n2hJx8Rvukn27?=
 =?us-ascii?Q?Zo6cTwV13QG+AfX7G9htVF0lBcDZn9fuOXdquVkWV4Go3bi8Wez1x4GLa0BA?=
 =?us-ascii?Q?/Fw5TGFNYuRjd323PFLGHJkBRWsznGL1estOIEjIh8WFl+riPUpbTUIt+uWR?=
 =?us-ascii?Q?O+HA65sbbGNEcrTW2VKEEBMTN3VSb1kCGiBgtqJiQZFU4o2f2LCLO9r5WW9b?=
 =?us-ascii?Q?45cS82ZBGl+NafMg2EEfFdQ92fmt7y8okx6IhNwpOwmQWlGznKYFSBjYCqls?=
 =?us-ascii?Q?KBW0nQZ296PIbMAAMDhlT5ZU3x9UJxiZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR11MB8127.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j6UP63OkORfEUGKAGAwHUIOtGWGUjsSCY4P5QSFqyxLqMehlVWboQsV6eOXx?=
 =?us-ascii?Q?P5fcqmY1VaQYeXMDzm9PUFUEEx8+lD9leJr1SlQ106CiojG9+vnEoAzdTJO6?=
 =?us-ascii?Q?iNdvmpYkeEOHy+W9tohz0c3jGEUqjhhbbaQAxhOZkjUPvtuiKeBmYfe1gSzg?=
 =?us-ascii?Q?WvS4ChtR+1/ebW9NopbX77U7iZOO9v6b2RqHaCN/KPMxN8PLjkhwlkZ+trAS?=
 =?us-ascii?Q?yA6JdHc/f1Mo+aqag0xaKb9JC+vg+advS95e22rQdiOIroiHK+pIHmJiHzpK?=
 =?us-ascii?Q?4fibtRcHSiC7+9guQ1TJ1v38Uz+MZe2SBzwfg6q8qLwqgHbW/OobWHxnRRjr?=
 =?us-ascii?Q?sre0O6Z1cN0Qod89/FST6hGy0sR9SHYHKaYXptZnvMGwVqDiDJnDuCi6fyTy?=
 =?us-ascii?Q?DaisJAFrAuAX6/FZlkiYf1CwI2t8W9Qb7mJAvR9ZRmNJcMVOXRNlCJRvWQOj?=
 =?us-ascii?Q?vUQqlcfDeNUA00DaLNCtCJTpawi2OfIV/jr/HD1MR1t9Vyw4ARzC0n4Pyiec?=
 =?us-ascii?Q?pyaF55PXIHGm9mRDf+YDu03MUK6uAdQ0b5npuskn9jGXv3Pr/rkUzG9D2/4B?=
 =?us-ascii?Q?OIAMs6hmvTqA1jVzKyKR/cK7uvtx+o6mMYvOJXJpqV2Moe4cu9qjY9QcmUJp?=
 =?us-ascii?Q?dubmQhDd/L28oknqlUO1+5XvjsxB6Ljtif3YSdq+5fjltjoaJs4Bzx1LCq7Y?=
 =?us-ascii?Q?qGJk82rN4GB28mjHb+1lt91vFwStinAaneVAv/MBrTh9dhj/ycI5RbHjVaXj?=
 =?us-ascii?Q?XfHNQY7Z1DGyaJg8sHZ3kE2ziZRw5COGBDjOBBHzqi+/lRVz+g3OiqBtSNPv?=
 =?us-ascii?Q?AgUx7CKNS4tTg66T86/J6zPYJmasZiLPMId8rzpPA2yjAdwzJM8WBA5g0qII?=
 =?us-ascii?Q?/gtvUvWbOb1Yf3pGAnQ7IwILao81yiqospYgMnSHDbirEHYZS5rMM04DBAvA?=
 =?us-ascii?Q?fE7KwDiY8BicTFbEV3pPfXNe/1w3bk1Nz20IXpLCd/nT/BB9ESd4kkyZG/Zb?=
 =?us-ascii?Q?BQ07lnGlXVYSG6xWVS4nnngu2PEdhMzViD920oEh+TA81lBM5lo25Qk/CAnL?=
 =?us-ascii?Q?nw9bdzlFABQOJ/I8DAhhcZGR49iYB3kgQuwUaAMh+l1Pc9W7WJWP2FDjsN3S?=
 =?us-ascii?Q?7plHwMwFywHoE8BdsjQYzddCZCBIxNWwIzqwbKWJUwAkiGaKanGfD0tjHpkx?=
 =?us-ascii?Q?lywg7xMTWA24T5s0rNgdShQLzUq+LOz/2BJbVmWZjUlGspbcsadd7PUl9mNJ?=
 =?us-ascii?Q?1fmt4wePEgQvNZAldrv/KE/gKm9skmPPvzO8GBGwZkK0fq70n9PRT33KYYIH?=
 =?us-ascii?Q?/ISARjjvl+FRG5c2A2Sm+xNqwkqLOInu7iLu8pWd4yC1biyXdYOQGgFVvLoI?=
 =?us-ascii?Q?q6BHrtXnfycz6y7lfPiNuOQhrtMsoZYJ6+zl5j4UpdF7ww+mJAuZKafX41uz?=
 =?us-ascii?Q?DnLCDEpsH26UPOcKO5qg5ETvFxKhGLN35mCJboTePEq95+S2cy6BM5/3lnSR?=
 =?us-ascii?Q?4zrYbdvo1vwoWqorMsq1hfSCBGNE/mGNRGUGiMdpC89UrIywXxrcI3iT0A9N?=
 =?us-ascii?Q?OMRzHjkrIBu8zUPJOUJdTmLQoBli/1lbsrtdPqm5vCVruYyWNtb3SbMJOlt4?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR11MB8127.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e79eb6-e809-4b89-4244-08dd5a3119c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2025 08:55:08.8360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBug32TYPJlfFjTcQgtEgyeSeRgfQOQ1IhVRFYJ1qHVGTYtauu9WG7ITn/tJ2dvjN7pEz6yfQL/zCOvgp5YL17IaU1ySE5V85YerCUsPS/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4665
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Friday, February 28, 2025 5:18 PM
> To: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH v7 00/15] zswap IAA compress batching
>=20
>=20
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Friday, February 28, 2025 5:13 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>;
> > Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v7 00/15] zswap IAA compress batching
> >
> > On Sat, Mar 01, 2025 at 01:09:22AM +0000, Sridhar, Kanchana P wrote:
> > > Hi All,
> > >
> > > > Performance testing (Kernel compilation, allmodconfig):
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > The experiments with kernel compilation test, 32 threads, in tmpfs =
use
> the
> > > > "allmodconfig" that takes ~12 minutes, and has considerable
> > swapout/swapin
> > > > activity. The cgroup's memory.max is set to 2G.
> > > >
> > > >
> > > >  64K folios: Kernel compilation/allmodconfig:
> > > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > >  ------------------------------------------------------------------=
-------------
> > > >                      mm-unstable               v7   mm-unstable    =
        v7
> > > >  ------------------------------------------------------------------=
-------------
> > > >  zswap compressor    deflate-iaa      deflate-iaa          zstd    =
      zstd
> > > >  ------------------------------------------------------------------=
-------------
> > > >  real_sec                 775.83           765.90        769.39    =
    772.63
> > > >  user_sec              15,659.10        15,659.14     15,666.28    =
 15,665.98
> > > >  sys_sec                4,209.69         4,040.44      5,277.86    =
  5,358.61
> > > >  ------------------------------------------------------------------=
-------------
> > > >  Max_Res_Set_Size_KB   1,871,116        1,874,128     1,873,200
> 1,873,488
> > > >  ------------------------------------------------------------------=
-------------
> > > >  memcg_high                    0                0             0    =
         0
> > > >  memcg_swap_fail               0                0             0    =
         0
> > > >  zswpout             107,305,181      106,985,511    86,621,912    =
89,355,274
> > > >  zswpin               32,418,991       32,184,517    25,337,514    =
26,522,042
> > > >  pswpout                     272               80            94    =
        16
> > > >  pswpin                      274               69            54    =
        16
> > > >  thp_swpout                    0                0             0    =
         0
> > > >  thp_swpout_fallback           0                0             0    =
         0
> > > >  64kB_swpout_fallback        494                0             0    =
         0
> > > >  pgmajfault           34,577,545       34,333,290    26,892,991    =
28,132,682
> > > >  ZSWPOUT-64kB          3,498,796        3,460,751     2,737,544    =
 2,823,211
> > > >  SWPOUT-64kB                  17                4             4    =
         1
> > > >  ------------------------------------------------------------------=
-------------
> > > >
> > > > [...]
> > > >
> > > > Summary:
> > > > =3D=3D=3D=3D=3D=3D=3D=3D
> > > > The performance testing data with usemem 30 processes and kernel
> > > > compilation test show 61%-73% throughput gains and 27%-37% sys time
> > > > reduction (usemem30) and 4% sys time reduction (kernel compilation)
> > with
> > > > zswap_store() large folios using IAA compress batching as compared =
to
> > > > IAA sequential. There is no performance regression for zstd/usemem3=
0
> > and a
> > > > slight 1.5% sys time zstd regression with kernel compilation allmod
> > > > config.
> > >
> > > I think I know why kernel_compilation with zstd shows a regression
> whereas
> > > usemem30 does not. It is because I lock/unlock the acomp_ctx mutex
> once
> > > per folio. This can cause decomp jobs to wait for the mutex, which ca=
n
> cause
> > > more compressions, and this repeats. kernel_compilation has 25M+
> > decomps
> > > with zstd, whereas usemem30 has practically no decomps, but is
> > > compression-intensive, because of which it benefits the once-per-foli=
o
> lock
> > > acquire/release.
> > >
> > > I am testing a fix where I return zswap_compress() to do the mutex
> > lock/unlock,
> > > and expect to post v8 by end of the day. I would appreciate it if you=
 can
> hold
> > off
> > > on reviewing only the zswap patches [14, 15] in my v7 and instead rev=
iew
> > the v8
> > > versions of these two patches.
> >
> > I was planning to take a look at v7 next week, so take your time, no
> > rush to post it on a Friday afternoon.
> >
> > Anyway, thanks for the heads up, I appreciate you trying to save
> > everyone's time.
>=20
> Thanks Yosry!

Hi Yosry, All,

I posted a v8 of this patch-series with a fix for the zstd kernel compilati=
on regression,
and consolidation of common code between non-batching and batching
compressors, to follow up on suggestions from Yosry, Chengming, Nhat and Jo=
hannes.

You can disregard v7 and review v8 instead.

Thanks,
Kanchana

