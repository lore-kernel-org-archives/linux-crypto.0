Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2DC2F508D;
	Wed, 16 Jul 2025 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668717; cv=fail; b=Z71sR491MrTOFsSFRLoZHiGbZk3ZJBCo5BBoFXnxr/KyYa1TkV5Vf575Ut1VbM1jt9DjutHpjqoW0NrtxplNcss8aUKfZWCuLpWDKX1QWDAlu39lB02AzWMdPqgZ2vOgCHYGMKaqaSyrztUaDMK+tNp7LyKeu+0+JzhRrxp0zI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668717; c=relaxed/simple;
	bh=CRTswaFn1gZszUeBnkJ5k5ossAkNzhUi+QKZ81+poiQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oZiynWuOWOpOG2MYx0e5RSULLCzOGUUQ0i327CJHiyX8Dddm2OJ9rLgAhpFr7qo8SMM/G1TK+3Ycsb9UUoMXu4N38K+gd1dhTls0b7x79/c2M4D1cYR8C1N22U+glyTubWtMcOjLWEcldvMsslorFRyv6vp8+GXlNYprDvcnXdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iArxWdI3; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iArxWdI3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752668716; x=1784204716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=CRTswaFn1gZszUeBnkJ5k5ossAkNzhUi+QKZ81+poiQ=;
  b=iArxWdI3wj6bzSwgRTLQX8AoYpm9bIfmAFWM8uMA5xfuidnagIKVdWeC
   2hwBD0m5KnlGUbOdQRP3s0fCBxMXKS4sldkXJWLoRDIQT6JBeSqHKW/hc
   L8uwqLcO7yfOLmpwm2WumHg7VallTs3RoX1jtQVpSCT6rn2PK75CFugcI
   e7CsofJjdNX13RFoBjd/lWRICYmhe2Billl5lAIloqSORvctjI1bthO13
   MhHN0wZJ/1uB+gz3UFlPn4Y1uG1te5uK7fpMizJArijBLbM3auIkecvcb
   a3Kk9+2+8DCnsm4DfrQtM+evQohiBKVTlBOGWJtXXdwB7w3ZAdc3/kWr/
   A==;
X-CSE-ConnectionGUID: Z8kX9SkkTQK3M2hAx7/cXA==
X-CSE-MsgGUID: BIe62JjbShOnoPTsxRuOWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="42543088"
X-IronPort-AV: E=Sophos;i="6.16,316,1744095600"; 
   d="scan'208";a="42543088"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 05:25:15 -0700
X-CSE-ConnectionGUID: lSpmDBHzTkC2D8WHxnQrZg==
X-CSE-MsgGUID: n9EFVL3NT+2Ehlb33I00IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,316,1744095600"; 
   d="scan'208";a="156883025"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 05:25:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 16 Jul 2025 05:25:14 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 16 Jul 2025 05:25:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 16 Jul 2025 05:25:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Stt38539uvul1i8U3D4jGmObkU+X0LHK/qeeq9v5QijiPgVOmQPmq5gN9Sepd81deCdLskXDzlk0O04YiELESXtwAbTiMd6MMajpvKjEouaVk8P/aU7Y3OFsxTObSXyZQ2WmoZKONqMi+oSESqJaZ9h3kB8auwX69NSi+tiM6/jYj63a/2h6MdgaYX7ZMZ87UmllUka+ykyJ6VPPCU23Ko/KY25hWyN/1hhOLdA/gV1Q9D6LoCmLU3aQ9fUspF1awvt5QQLt7tXSkCkTPXZkoNR9WC3UJjA5k2QiuztTh26OkG5GCDYQo5drQPXOGCoAOVx0Bp1nEBGizkRconslhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4EcHMgAJ0/xOiFHTMHDgtVWntJVCpG7OhjS4boTUcg=;
 b=Qg9CCvLtxyDHpLDBmSpopP+SiJXpVJD09ErU9TvVzX9EH0xx6vUJRZPdwlzIpk/TJ+odtDefOUMoqlPB3jtArELI/jj6jZuyGtMzVMdCQswgHR41osHjIsmXwnpIYsGS9wRdnz63T2Qu77Gfg5/pmfA4yS1NmU38xsaPKk1d8q7dxJROH/fT6aICs8KyiIYr3Tc7GQofT7w14kc1IPn/ZJvgzcoSi6N3RLpxs0IAJesaqsjTGGFF3eHP5Fnqt3J5mdWeGWLYKjiGMyqR+GrDo5a+blxpZzxPyCOzf9o4dGEgvkpjGyRQVX40bm7l9BylxNvFPPzjr7UhVgvGVYtNDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY1PR11MB7983.namprd11.prod.outlook.com (2603:10b6:a03:52b::8)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 12:25:12 +0000
Received: from BY1PR11MB7983.namprd11.prod.outlook.com
 ([fe80::1d46:fec5:53f9:9db8]) by BY1PR11MB7983.namprd11.prod.outlook.com
 ([fe80::1d46:fec5:53f9:9db8%5]) with mapi id 15.20.8922.035; Wed, 16 Jul 2025
 12:25:12 +0000
From: "Murphy, Declan" <declan.murphy@intel.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
CC: "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Mark
 Gross" <mgross@linux.intel.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: keembay - Add missing check after
 sg_nents_for_len()
Thread-Topic: [PATCH] crypto: keembay - Add missing check after
 sg_nents_for_len()
Thread-Index: AQHb9kwcmPvOHoPyN06csK0OUFArs7Q0rJ1Q
Date: Wed, 16 Jul 2025 12:25:12 +0000
Message-ID: <BY1PR11MB7983BC06882ABC5D8B471F2FEB56A@BY1PR11MB7983.namprd11.prod.outlook.com>
References: <20250716122023.67129-2-fourier.thomas@gmail.com>
In-Reply-To: <20250716122023.67129-2-fourier.thomas@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR11MB7983:EE_|SJ0PR11MB4846:EE_
x-ms-office365-filtering-correlation-id: cbe5b475-bea6-45ab-a19c-08ddc463cfdd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?ghnx9cbt+NAhh6CHGaOOPEEGBLuuPlHw6pkn8t6SGGYcZ+Qw670f53UxCsVP?=
 =?us-ascii?Q?l0ZwUK8+3lcZODjanJwNuErj82UnOywFtqTZxEKhP5yuYGyLGuIrowi36IUb?=
 =?us-ascii?Q?l23W6D4Sp/+np6R2t8LJ2OAt65OO0keS8USJk2AZjGURggtf5NXThbSq2kq4?=
 =?us-ascii?Q?uwTrcXIiHCU9wX/JDTVw0j4Gq7PiadRSbvRogRdLAQg1lu296KEOzcR/vSQ8?=
 =?us-ascii?Q?8Uuz+Mwh4662q38uSGpcCg37WLQqNKl1pEWwrTgph2NIF/vJrOI0XZZVdsgG?=
 =?us-ascii?Q?Ne8NonOb7xlkcR5LxVNYBzLOgA5k8B1VhqrPGdNKSWE2QdZp4WWQ0dYat6T7?=
 =?us-ascii?Q?lxBluMMgsnGpQz3XTvsw0XzkdJWhsFfAkX8gsYPaonAqk/7aFHDXf1KLFwuF?=
 =?us-ascii?Q?H6KWjkXsU5dslWsDnw6iV25WEJo0zjORHLScLdZLu5O10Am9VgdDo7j8KQOz?=
 =?us-ascii?Q?NDypYkJJ2J1JL4VfI0/Kk73uc4oxwdA6ntjdY1Y5A69IbIVtUvJga4tDOK3V?=
 =?us-ascii?Q?swMs47P7h9xNyD8ww1Ut/ZQ/eFcuVPbTi6mUoZJTBFUF9m95/dNcEZxOrI2q?=
 =?us-ascii?Q?VpXI5diPVAY/N/VJl+4Pdlk6UBkOTZ+i/WQOQ2HdkttZ4sn+EzawbyNb+YZN?=
 =?us-ascii?Q?Uv/pn+YZiY2Nqx77riyOdOSiYUjdk4vqNYJFlKo0zJJVFEfkvYMfftt1fxgU?=
 =?us-ascii?Q?vkRkkrrgRj+SQ9QbLecgby2/hnrf121FGnzamPwjaX1/D+RRHt+CcmjTDcTd?=
 =?us-ascii?Q?ti7cHoeOARWexPSUY80k1eGpvDi21WRZgC6ikMtQw1GASRyh5dqajB5TzsXs?=
 =?us-ascii?Q?VBA40WmzJQ0H3kHku1HTqcSKBQZBC3z/mgPZgHLXvvKr5OVGcsAru22vtbBe?=
 =?us-ascii?Q?dNyL5aUY/5GVIFLz4WVffZ126d62aHlcknUhSYOllyqPhaeeUaAw0woFkspV?=
 =?us-ascii?Q?EW2GYoteCYDeD21ohqCvFXz9Dg1DecYlxixn+cLUeMvz7imedK/Nf+TPuFj6?=
 =?us-ascii?Q?Zl0vLJLwM/F/dnwyJ5fJpSXk6ZLzmp4WdOe2GlDHEk/XcoMHNQca6DgdIrDg?=
 =?us-ascii?Q?IsqyCKF2FK61CLfsNDHK8Gw4ZD2ZpqLuN7i9J1RpiqwFa7hwnFpCBznHxMAw?=
 =?us-ascii?Q?KPpAy0pRWVwuWfi2YORJ4NpTobpT5oOOqwxGA6fxEsgmRzLmDTP6eAU1KyxG?=
 =?us-ascii?Q?/wafB72zJ/itPy3Mu4jtC8kJTrvpJ08fGIS5yysrFczjwJlxOBTzLUfRmOMC?=
 =?us-ascii?Q?71SVHaQsIamu7w9VCQDc0bgGqIm7zb7RzlB1vumP8SEDp1gxwxZOMReQMOEy?=
 =?us-ascii?Q?K+Gx9P+CA76tPFg0USCDlvmOBfA3dU7NogUwCpPMXA8xP1VVP9kaNKR3a/JK?=
 =?us-ascii?Q?GQLc63ivgMKJa46DoKMhOL3HK/rhB305/u92XjqZI+dQsLlfm30et9wYzId+?=
 =?us-ascii?Q?xzS2YiT6f9Rf2/YLrHi3lJy9uyITYO2TnTtv6w/pOqoqJBy/tnQ8jw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR11MB7983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vHSrL4+zT/sy0vUcZ9ZLIOf1gk6k1os2SXFaC0RcloL4zgbgSM6VDrEFlVWi?=
 =?us-ascii?Q?ytFSL39YKgn83eTNPXhdVI7QoLmG4Bc463vgiSQepwf6iN8l5UZmPTBJkAcn?=
 =?us-ascii?Q?yTMDoP83YKN678Q0WGLf1PXoukYFcYgkEpDVf9pVQVCdGQu0XP2YZHlz3Ust?=
 =?us-ascii?Q?eTavmjEJ6J7u11Uf8dtylc5RKqLEdYM1xztoT84yYHQY7PFctpkiJx1NC87s?=
 =?us-ascii?Q?qUyLzf+fhVrWunmuEvuV1mHJXT9DFLYjnTJJAGuYhx5oBs/HM80sPyKOHSyn?=
 =?us-ascii?Q?k8K3hFiYh6ehtMclNWMEufgmJXx3lNwU0lfxfNerrRO4swWutP1doq5htEDy?=
 =?us-ascii?Q?K/x9s5NPIucaPwSdLn/Rp3MSSvFmIgIvh5ePY/uLS53pPU1k3rBxTZ7BzbxZ?=
 =?us-ascii?Q?L1hXVCkGsuBWm+WsujEhB5APuoyZBw4y5sE6M6quC97OkpPF0W0mrYl0I1Vi?=
 =?us-ascii?Q?13LID0xZRoBt0cmcLe0KWGHvfhhXLNPiIgtjkpZ6bJD1+h3yN+VNKNF2nyOU?=
 =?us-ascii?Q?JCzWq6UPYFBMt7KboKVsWRY00IWNbIX9zxNvcZsGhihl5Uqe1Aw+U1/8K8NV?=
 =?us-ascii?Q?wPk2wAQps1bwgMlgYTLLJQZHZAADgT+WupxDcKEHQMbyAckQUhP19Pje1yOK?=
 =?us-ascii?Q?6ojZY4Y0s0YAP+NIsnvH1+G5f3IM2Eua/f49296GnngTemH0ENpr8+D/84oS?=
 =?us-ascii?Q?DOjh8n3ohNHhPM/XB6D3g+teA8RPw/oMrG0kauleScMOhX1R/3ecGNxfVI+i?=
 =?us-ascii?Q?+HnMNVzf9zu1+THMdOt1WtTF6tooXrwZID89Xi736RnxvS+foWTrh5FcEQHK?=
 =?us-ascii?Q?sx4ItLo9TDh1l2vBPelR9eOuDHHbwbczM8CViyBky3ewOECkgE0leriESFtM?=
 =?us-ascii?Q?/NIvqdktds025Y9LpQuA0l9GaUPZZ1rdvxnRlCmRZjYKsEV8g7fnphehn3kB?=
 =?us-ascii?Q?19TluDpoN6MKgaYRVexvi54RMPPmso0plDsVbtbvrROUGH9DAL/XAD1rvDcF?=
 =?us-ascii?Q?6L/6Ybr7umwt/S5USMiXi93SFR1JKa8k9yCHXB9Ic69tglZIFQ7NJQNHITEQ?=
 =?us-ascii?Q?XH6/dpjo6YPxdir+D7+DDZbHxhVK1ExxznwPnWduVnu+pMbwTM5Vs08hvUZV?=
 =?us-ascii?Q?H2sNumGzIHUcxH/GOqBe+cF3gn9eqOjKt5LQyX1xF9FVKTCjNJTvGuKyZCel?=
 =?us-ascii?Q?jG98KkJ+VzGFZh8IICzyaq8ta02nIFMwTKW4W/PLcgacU4rEuIJff2gWacmT?=
 =?us-ascii?Q?FtuCZ9MWO6eEsmiTTgALRb9qoXrPbOTJlPaEjvGRe1jind63ilRPMcZpk8yr?=
 =?us-ascii?Q?jsFHDw75aB6jirv6vI4Iqf0WIluqcNvk+AzfbzATM/BQkTOr1l6UTOpTx7mW?=
 =?us-ascii?Q?iLcVPuC2m/e6rUhMkrkFNMM7pOJqXO0K6tDwMNEpoFGAf4+UcNg3rfLUfQLn?=
 =?us-ascii?Q?ee1gdZxNz5aEMKhYqYH6ZtgdQOuQaYrUQjrtB4H29fQ33jQP/sqtMSPblf1B?=
 =?us-ascii?Q?pEFkg4ohNut/Na7F7NjvxypY4T4jV6//xAm7/VdcuYoWq7hgf98j8WGofZp7?=
 =?us-ascii?Q?QacHuhS+5XB+b8+1qiGo+adjmt0MktDI7RkIPCNv?=
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR11MB7983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe5b475-bea6-45ab-a19c-08ddc463cfdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2025 12:25:12.4605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sxlW19Cr1MV88j3cLFchOS6urU1ad3aFG55WEYoi5Zra43+N3AGJhdODwl5PrOfxf69nTFh4hv2O9DPLtJgV3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable

Looks Good To Me.

Thank you for the fix,
Declan

-----Original Message-----
From: Thomas Fourier <fourier.thomas@gmail.com> =

Sent: Wednesday, July 16, 2025 1:20 PM
Cc: Thomas Fourier <fourier.thomas@gmail.com>; Alessandrelli, Daniele <dani=
ele.alessandrelli@intel.com>; Murphy, Declan <declan.murphy@intel.com>; Her=
bert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net=
>; Mark Gross <mgross@linux.intel.com>; linux-crypto@vger.kernel.org; linux=
-kernel@vger.kernel.org
Subject: [PATCH] crypto: keembay - Add missing check after sg_nents_for_len=
()

sg_nents_for_len() returns an int which is negative in case of error.

Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/=
crypto/intel/keembay/keembay-ocs-hcu-core.c
index 8f9e21ced0fe..c75fd7c68fd7 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -232,7 +232,7 @@ static int kmb_ocs_dma_prepare(struct ahash_request *re=
q)
 	struct device *dev =3D rctx->hcu_dev->dev;
 	unsigned int remainder =3D 0;
 	unsigned int total;
-	size_t nents;
+	int nents;
 	size_t count;
 	int rc;
 	int i;
@@ -253,6 +253,9 @@ static int kmb_ocs_dma_prepare(struct ahash_request *re=
q)
 	/* Determine the number of scatter gather list entries to process. */
 	nents =3D sg_nents_for_len(req->src, rctx->sg_data_total - remainder);
 =

+	if (nents < 0)
+		return -nents;
+
 	/* If there are entries to process, map them. */
 	if (nents) {
 		rctx->sg_dma_nents =3D dma_map_sg(dev, req->src, nents,
-- =

2.43.0

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the s=
ole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact =
the
sender and delete all copies.

