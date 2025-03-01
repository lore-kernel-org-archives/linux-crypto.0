Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5761E23F378;
	Sat,  1 Mar 2025 01:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740791396; cv=fail; b=I/LXswZGvmuFGUCrShgxnRQi8b4UXOPF410ezn78uH19oXNu3fRGYyuADGOXZmRbGE8tOwaaQOUIeG/bMjXhMcpYTGCTfgoBvgTEVXgOypVTYS7wDpuAojekP8bF+oQoIsOThwWfeTTaJ6zCVhZmN6YSRHX6iHYSz2u2QUv4CdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740791396; c=relaxed/simple;
	bh=SNhHSi+BnrMFX2h5l/QGYEt1heUBKvdTZPJsKHkAB6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t4toPMcz3WYH05Rgs2sq4gdjwHngMNcnQ6tIY0Ow9wHjOcLUrqCwVdQ5JqXe4HG+rsUQ+QIW9SHIeTccUMOtynuHn84dfBCHn7nRVg6tdH4O3Y5uVhE7n358yWz+wpyno/0hhaAAnCnafWkDBseLJlWVpic4Uqta2nUmt13WjuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=El8j8T5M; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="El8j8T5M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740791394; x=1772327394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SNhHSi+BnrMFX2h5l/QGYEt1heUBKvdTZPJsKHkAB6c=;
  b=El8j8T5M8XW8lwW+cO+l6VCnEhcpIyVtKWjJ131EmrzWNlrZjSpAZ1mT
   Eyi+K1piP3sOqStzHKgBUe77HPpd9QQGVbfZVczUCE6855midy+p4VG0t
   KExCTPe3h36eYJusRb9bPAaAwVxcIPiDueKWJduqli06W6/Tov27eZrpU
   DHMvTXq/AXPCcQdkxkXN8czINY/0jU8iYZbvNuQe9senv0aYfFU+qTsNN
   qXirCSirhZF0XUw31ONI0hjMV45IWQJSPh1/oJtqzVDwA6D2lBOKzByFi
   ZnqdQfceT2OknozHCxwfqzC4kXym5kheTs1zrLXbCCCJWdnuQymRvcBiW
   w==;
X-CSE-ConnectionGUID: QltKuynnSQKEA5W4szKhmw==
X-CSE-MsgGUID: T//J+tT+TvunxJHvHWNOxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11359"; a="53122520"
X-IronPort-AV: E=Sophos;i="6.13,323,1732608000"; 
   d="scan'208";a="53122520"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 17:09:53 -0800
X-CSE-ConnectionGUID: DVsOtjmeSeeO6z+9Od4DnA==
X-CSE-MsgGUID: YhyEYmnbQlWSTI0hUaWWog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,323,1732608000"; 
   d="scan'208";a="117509207"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 17:09:53 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 28 Feb 2025 17:09:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Feb 2025 17:09:52 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 17:09:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4lD37LjIn2RWKIfJZ2H/XvWjrLw1WvuWXEqlhMv5mhBRJt6aE+s92mhSj7/9LOfEynshCfphF1EtRga+h+f2rsSpY2+DitSNul/ZRgx1cVRdAANOIHDFM6RkvoYPakU4cyUbiT5Jy27y4C8O0gkS+SHF0eUBJmDMvHHHWX3rLnIKf/i84RMF377TtC0Zohx/TAPERz2t3tYBMVtYXhpeppn90BPfzkuHFXbfXcxVGUmD5B85B6VgWfyaWEt435P5ya9iaH212ygiLuaB1B4LwuOpe6fFm5whT0onSHAnanasKxjnSEkGgGt2vPtxD664FDEbBQHalk3O92sfowgWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgpNtZADZiAVDy7U59uS6fzfMckiy5WrT++//YaverY=;
 b=oSsB8MYZeqBblv30VqLJlc7Vq9VoISQ55ggz+9JTzrobdU+n+tofMAA1JN29c58tXcRJb3vxhrmvtBKazHZSIup+M5xafbL39+/FCPXOumKgat1gxR74uUYnUf1vLNvWphaEyS5aC8dQWRxZcYyfQUsElbWn//HRmtt8OBhfD7OlkZ5a5CeUZbGr+WYmMCfgCumnyjcf+dBojvUr/3zi1+690VeCXeWyD3nTb5aemDHJi0MJfgcIzSZJx6XZN6V5bYC/JstfwtdXs6xu7zq4WH8iMmM8luSbAM7WUe30aajgWqouqnEOZxrdfMhoEDtNp1MfTf076yTCr00PauBr9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH7PR11MB6548.namprd11.prod.outlook.com (2603:10b6:510:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Sat, 1 Mar
 2025 01:09:22 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.021; Sat, 1 Mar 2025
 01:09:22 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
CC: "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>
Subject: RE: [PATCH v7 00/15] zswap IAA compress batching
Thread-Topic: [PATCH v7 00/15] zswap IAA compress batching
Thread-Index: AQHbiceg39kI/20AU0W9GEohTPKAv7Ndd0cQ
Date: Sat, 1 Mar 2025 01:09:22 +0000
Message-ID: <SA3PR11MB8120AD2AD0A9208BDA861580C9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH7PR11MB6548:EE_
x-ms-office365-filtering-correlation-id: 1dad9328-49f3-415c-7da3-08dd585db364
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?zdxnVMUnqYOG+c3jXJLkzGojm8oqwAW2xvsoZ+lr9VgYGIECB8Lhu4y0wNZW?=
 =?us-ascii?Q?ZLTnOCCKAw7f4zSNncDlke2qwW6ruyudQ2Y0u/ydfc9vmYEhdObHTurLCvbJ?=
 =?us-ascii?Q?IkrQhSLLUU4dSeSRIgZVb/5ko9m4AnIdzvYmZphCqwI0bFqrhbvy48+ECdKN?=
 =?us-ascii?Q?0a3SfNNKgNjIXEg+cN2nlyjrhmJCsJWpTUQofqhBadp55CP35cOQcet5IsUg?=
 =?us-ascii?Q?NKTfVGgpxAm2TWybXbr4E2itDyLYLrm0OVfsHlwW9y2CYk7waX4HHhxS0xlU?=
 =?us-ascii?Q?wFpsu+jlnK0q8YdHtOMlPAgHv91hfqiTYffpFaHw5tgks62mSbm2evf4eEY6?=
 =?us-ascii?Q?kglTnaY2FJxO1bJnkZFEvGWfsPpoT2FdmyhHwmWS4pakU+2CfmCGVdx5MS5m?=
 =?us-ascii?Q?w2J53jiYa6Tl2mlKtPkA/tOhw5EFo+DLPwPePTdHwbNqrzfd2AQB87mSF4TJ?=
 =?us-ascii?Q?5HGzsIt4auRXo/0GIV3VaddMHR2DWs60j9r4y//zG25ns+itZsOKXNWO6frT?=
 =?us-ascii?Q?tpgBJK8uEdJPPDZLVD5bk40zG6CmIkOiUQXKq90RWdajT0KPXT7UqUxB4zjY?=
 =?us-ascii?Q?Zjv0h2TiVHUBJoLPjB4PYcmdsTL/FD2aFTqwZ0DzRnD+t/PV8ZMA77LNSc4C?=
 =?us-ascii?Q?V1tsu0WlCzvDr2kiP/1DdiBEljDkr2ai0LgHjGfo+5AXFhubRS0TUTK4Fy6c?=
 =?us-ascii?Q?cApHQ2ZLtIA5PGHqrErB49h8xMXr5AWuXVKkF+ZPC6YJZescMGmKWSqJMYdz?=
 =?us-ascii?Q?KNV+3xheZe5YAWDB2PSf5JbY31VZHkMljvbpEgejpSKuzypgNTrNq/FxzLIW?=
 =?us-ascii?Q?rnpJmM3cCtncAKFHtev6fU0ZaL1pPdmG4c736xw83HKXCt3fx1qBmHD6NVPN?=
 =?us-ascii?Q?ySQVM2ra5srozz9omn3VGeHlOLkCGM9balyajyXGOfRqdUlN9AT5Ezd7rsZM?=
 =?us-ascii?Q?F6OfVOcaJeXXmFLuOQyXqFYOAQ+5PYS2+lF2ZJOjHuhMkPU/SfMWMED5wHzZ?=
 =?us-ascii?Q?4rVs217FPa/0M5R7IZWcy9f3jGWmoVDTnIhpKKhfyVeZFYBWrPL5dvZ8rdgf?=
 =?us-ascii?Q?lqgb+xm9rdZuCo1GKmY0ELhMtCfJ4Il0HoxE0vL42DFWMjBa3EgYVMG1Tr5B?=
 =?us-ascii?Q?RnAX5Dz30FmjX+1weeQSO6rKwC1lf+n3sVytqI8raCXelxns1mdh/0/tGBou?=
 =?us-ascii?Q?AcCenJnKhjI9emuRvsT0PrM79falTfTsBirZBJIJiw5mkNQDL/bwL2EK2Bt+?=
 =?us-ascii?Q?nzVxv17rsk9WW44mTJpgFtYbNmnH4ElHwIUp3C7kfTdVDCdg0qgvERiRLvPf?=
 =?us-ascii?Q?JqXFIcPMrzC4E7nkNjc2oahokLbgGTkdXtdkXHyCJ3trK41XPk0PIHkgeNhB?=
 =?us-ascii?Q?KQ2xnOPooR6wwsqNLkXxSDWPo/De4/malNGumRRIBF23FX7x/I0xZqwPFicy?=
 =?us-ascii?Q?opjXRvaMrgPgJWqTvEpcgVJk0DKxn5W8?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HtUesOpdgm+huA8mgnDyp9v3xLgXgHEQUrfpaRthJykrdi+ZOTTotnj6ox15?=
 =?us-ascii?Q?HuuoUahjh5Yrf9YLS4+UgnT6AosSsXs+mhuNY3RVaXO5gbO5OOllXaeJy7k9?=
 =?us-ascii?Q?slJc6up7rckJcb98oaHFEjvB6BxNg+Hox++7ANn4BgcxWdExJhj+JfNYLkBZ?=
 =?us-ascii?Q?f9lm/Hfb+1jKBq9V+ibdbeLPBs+48I+7XHivxtkRC5Eaf5VrqH7nGmKQOQWg?=
 =?us-ascii?Q?C+40JfDBwaAwbsplg6uYBwTWFsdmiNq/o84OF1mfERWNBS5h3ZCVEQvgwKB+?=
 =?us-ascii?Q?bO9ahPZSyUIFGi9be3018RTYikoTXa8eF3LavZ/Vi9fC6mIQ5eWRc0sUQo6Z?=
 =?us-ascii?Q?a078We+4SywKo5sNduLO9QKwSi1wd10obIY7Sp62Bx7s8H8VF7pQEYqz9Zo/?=
 =?us-ascii?Q?3lhSt7N4iji+eSVjCDH/q1ebe/JUJgw9KQUcgIe+rZNcmiHnRnEgy30mwrQq?=
 =?us-ascii?Q?+TK21fOtMdRVHD3681Ovi1eQay1FArVzDLdzpLWo6YHhomNQQD1nL8wDnXBO?=
 =?us-ascii?Q?kiXt3aX9SWKB+iQ1uSlVCtQWq2MOCHfwIPfWd/kjgkS+j7sXfLwwfAIXFuKH?=
 =?us-ascii?Q?gbvVGhoOgamjsseIeGLy8qlI0lUL0wes7cVDUw7WdbvQ+4iLl5S5/ffRbBlA?=
 =?us-ascii?Q?wcKrl+S2QmCfJ+Vd/Rek5IKewUwEEKoK6kSklFMJlIOQOoDZXuyJNXgjUI/E?=
 =?us-ascii?Q?wXflUeo19velF6APLTa6qnZQ7qX7goK7JCLoj5iXzaA9ekdFVx8cfVyBy+rn?=
 =?us-ascii?Q?fn6w6jRqIcVOLBsp0DxfXB9miMTxd8UFh9dBdEKAGbpgkcgCo292Ws/faq8P?=
 =?us-ascii?Q?Qat6wlzLGnjpR3A2bo0xaG1WQgfxE2ZZz9uRd2nyQXREXA8l/FHOBHNuoqXx?=
 =?us-ascii?Q?KFmBc0SknVe2jBn84Wpukx0c2ZGpwr1RFISe562wDeVBFCIQ/Ha4l8DX1GTU?=
 =?us-ascii?Q?VSBLgfb7xoAgiIkDNKHnxZila8LaxSIpQmQ7eFkQ0gkMG2TxnoZwQyIQbtDy?=
 =?us-ascii?Q?qqX3mdyLaxhbgP+HGkhwNb0xv84nwgSOU8tXVHwh8/2SeB0ngUufA2L5xba8?=
 =?us-ascii?Q?Zz/tPBizeI69W4Pt2VHTqOGCNJK+H58YA6b4xymQLHWSpeosbh43JHiy0yM/?=
 =?us-ascii?Q?tCwe8NEcH0U+ydUnweeZDHA16dPT/7t1F2MmWW5c7TY5c8Ed8vKLbaqFgYmy?=
 =?us-ascii?Q?TkkOaOmYWpz/5/gPY3fVWkIPG7Ap5DIooP8cYRwDVq1GJOW2jDZZmGH2/pk2?=
 =?us-ascii?Q?WbZRNnlpkLTIyA4gEoC5gORj+YY9lITeUOkO4wbwnsTvYifgxpbmp/K4/TF4?=
 =?us-ascii?Q?oNm2iNj9wG1uqvOV+/GXSPb7B4qAjK9LOol7nz0VB34/9l2iQgyARqvAth2Z?=
 =?us-ascii?Q?yQjXNNJgbQUp5otcTtGz1WVRIC1KAPaGVTWYi8r6tQ30GCQ1TOucYlpgwWgf?=
 =?us-ascii?Q?rmGGsOGSurwrMnZ8Uxc6PQqW1mj69w7lHuk2vRWtxfHr5sOQmaJmWT9eG0oP?=
 =?us-ascii?Q?idbr/Qcn9h/4svg8egs4Iw1rTSArh/9znXJcEVsHR+MroWqCORnZp7J1CXhA?=
 =?us-ascii?Q?oqNajtqjrUFHe6FgwqlKMk/kC/U0DqBeZSvc90jR/oJKh0aKREaJUQgPc7p1?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dad9328-49f3-415c-7da3-08dd585db364
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2025 01:09:22.1238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mwzbqwpZ8fAA3htPwPLO38mTufDWsa+QEkWCjw4Sh2PddgELjI72RQK5v9FzKIPFV8Iwp4/Y4V47FEauEQAZflfK2zMPpCPFyDU1S5fElLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6548
X-OriginatorOrg: intel.com

Hi All,

> Performance testing (Kernel compilation, allmodconfig):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
> The experiments with kernel compilation test, 32 threads, in tmpfs use th=
e
> "allmodconfig" that takes ~12 minutes, and has considerable swapout/swapi=
n
> activity. The cgroup's memory.max is set to 2G.
>=20
>=20
>  64K folios: Kernel compilation/allmodconfig:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  ------------------------------------------------------------------------=
-------
>                      mm-unstable               v7   mm-unstable          =
  v7
>  ------------------------------------------------------------------------=
-------
>  zswap compressor    deflate-iaa      deflate-iaa          zstd          =
zstd
>  ------------------------------------------------------------------------=
-------
>  real_sec                 775.83           765.90        769.39        77=
2.63
>  user_sec              15,659.10        15,659.14     15,666.28     15,66=
5.98
>  sys_sec                4,209.69         4,040.44      5,277.86      5,35=
8.61
>  ------------------------------------------------------------------------=
-------
>  Max_Res_Set_Size_KB   1,871,116        1,874,128     1,873,200     1,873=
,488
>  ------------------------------------------------------------------------=
-------
>  memcg_high                    0                0             0          =
   0
>  memcg_swap_fail               0                0             0          =
   0
>  zswpout             107,305,181      106,985,511    86,621,912    89,355=
,274
>  zswpin               32,418,991       32,184,517    25,337,514    26,522=
,042
>  pswpout                     272               80            94          =
  16
>  pswpin                      274               69            54          =
  16
>  thp_swpout                    0                0             0          =
   0
>  thp_swpout_fallback           0                0             0          =
   0
>  64kB_swpout_fallback        494                0             0          =
   0
>  pgmajfault           34,577,545       34,333,290    26,892,991    28,132=
,682
>  ZSWPOUT-64kB          3,498,796        3,460,751     2,737,544     2,823=
,211
>  SWPOUT-64kB                  17                4             4          =
   1
>  ------------------------------------------------------------------------=
-------
>=20
> [...]
>
> Summary:
> =3D=3D=3D=3D=3D=3D=3D=3D
> The performance testing data with usemem 30 processes and kernel
> compilation test show 61%-73% throughput gains and 27%-37% sys time
> reduction (usemem30) and 4% sys time reduction (kernel compilation) with
> zswap_store() large folios using IAA compress batching as compared to
> IAA sequential. There is no performance regression for zstd/usemem30 and =
a
> slight 1.5% sys time zstd regression with kernel compilation allmod
> config.

I think I know why kernel_compilation with zstd shows a regression whereas
usemem30 does not. It is because I lock/unlock the acomp_ctx mutex once
per folio. This can cause decomp jobs to wait for the mutex, which can caus=
e
more compressions, and this repeats. kernel_compilation has 25M+ decomps
with zstd, whereas usemem30 has practically no decomps, but is
compression-intensive, because of which it benefits the once-per-folio lock
acquire/release.

I am testing a fix where I return zswap_compress() to do the mutex lock/unl=
ock,
and expect to post v8 by end of the day. I would appreciate it if you can h=
old off
on reviewing only the zswap patches [14, 15] in my v7 and instead review th=
e v8
versions of these two patches.

Thanks!
Kanchana

