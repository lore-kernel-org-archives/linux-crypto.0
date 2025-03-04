Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947324DFE1;
	Tue,  4 Mar 2025 21:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122901; cv=fail; b=fThslk9IruE9YjHiJ883UMusVfGlgp4i4H2i0jdHTpmwhwvTQkrIPGF4J+zvR7SmRUAov5xTv4tYV58+HkQInWp4ONqHrPWXuIMAjwVF+363uqjOTPY0Ag4QgwgTOHPl5l61XeO+jiyEuWw+a2nvudT/MJgsdmDIeAnxREB7eJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122901; c=relaxed/simple;
	bh=2c9T0m0Gf6sY4ejPh7DEwJA2ghf3mxtt0qC6ml/EF/A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cTjdixaSAmz/6EzLcN7gLTE7LOCnvL55XhFV6prvx+9iNnh43oKL7EuQgJrlOB5VH6sJ3rxnZ2717hKnlJmBKXeS6zSzGQuGIZCIlGDffkBKKuje32UCguxaF54zBfR8bwA7j2VQAzpAcvKyqnsxd4NVfAEDtP2lSp0x3dH71p8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lZVbiJ2V; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lZVbiJ2V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741122900; x=1772658900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2c9T0m0Gf6sY4ejPh7DEwJA2ghf3mxtt0qC6ml/EF/A=;
  b=lZVbiJ2VEnaf/X1TKJY1fgERtbdzOLbBKUh04P28LseG008lszF2USIq
   oCbYo7grjKHawLvvHtd8bRZ4AcycgSRTVJ/Smz7adbDqg58jMr1LaHH39
   l73BXw9oeMQNbeUvnmBnEAePM9x6/h/NowFqZBwmINcz4+zuMg05l1Q99
   IJGg2wlQHCecOAIxVO+sjZayXO9SkoGJBUADThAwWozVTWeOKvHPoLbY0
   5+Y7g6gTHgBNZiYymkJYLrcNFopRYAiIImc1xHByMQQJ6lLO9LIq1CojD
   jD5oq/ki0UHEATKY4CCLmEl5Sl2r2PmUEh0LoIMuMCOxuGwK6LzXwzJMT
   w==;
X-CSE-ConnectionGUID: MAaAL1V8TR22pZKrSRlw6g==
X-CSE-MsgGUID: gI70i1VpSdyOFESmGUXGNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="44872928"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="44872928"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 13:14:59 -0800
X-CSE-ConnectionGUID: hCGssvDiQz+ISpr+0qw6Cg==
X-CSE-MsgGUID: DMey8MszQQOT2Q2fRTzgeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="118491993"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 13:14:58 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 4 Mar 2025 13:14:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 13:14:57 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 13:14:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CMCVP7OPtW8cqj1uUeJ32p+7/dP6A4HiqCQog0cekC1DD2J6cUrwluH5+e3dIxe4B2ww+AATBmb2MsZJ/cIj3hVLqq19aMj9xBZwnOLZceEByLrsaMs8NJto6GJL6BhjorJRtrshgY7Kj/CAXFOmItOdb1TflWFtkwiy0EHBnJpCkexaj5zZA4CwqKHcSHS0Y3rUvrjm4xkeWP2QUunaW4WvTMynaPh0tiZHxdOyZU2hN4sxgEgxlN7ozF6RRG+q7SNVmyXpTe2qVvIQNfVDY3uZG8wKS0moRvPznRYtn7XOSkdx5vBZA/29VgTWDO6wO0/rC803mbBHFS5k8Vk8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zIovk2SEcfyV4cpMNdJ89aCez+KbNEU6xgYCHdvakI=;
 b=Al05E8FVtBPzzbSrkiKinnyvGA6MlWOVfwJoSO6+HfrqtX9IHIEdRcEHGIz0cbtbswik6Kj1lCm49RhufzvaTl7+vKmF/ji4ZfPd6gsUDSwAki+GY2tPqpNQxJzSk5A3hzYpbkqj8JHz3k25FkfOgxdUfms3v6DfBGC3Muo+td7eElj5xQcaKVhuKhuYHbv4VZU/DBa7Aoetn6B2LNchq3cQN0Ez2hkJSI+UIHXuyMaiX9ymwP7OFL70c6ScAaVMQxxbk/Xr6A8YIgrt+49A6wX/WTaTwJVpPzCoIxMUTZQl9BqEtHQwu8PdOrvWSwCpsRQD6UHdF23AUX17ppH//w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by MN0PR11MB6183.namprd11.prod.outlook.com (2603:10b6:208:3c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 21:14:40 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 21:14:40 +0000
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
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v7 01/15] crypto: acomp - Add synchronous/asynchronous
 acomp request chaining.
Thread-Topic: [PATCH v7 01/15] crypto: acomp - Add synchronous/asynchronous
 acomp request chaining.
Thread-Index: AQHbiceipagPZZbS/Eew6cUUvSsjl7NidnWAgAEFWEA=
Date: Tue, 4 Mar 2025 21:14:40 +0000
Message-ID: <SA3PR11MB812018111A1903EC4889523EC9C82@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
 <20250228100024.332528-2-kanchana.p.sridhar@intel.com>
 <Z8aNY5TFj_-os4Fd@gondor.apana.org.au>
In-Reply-To: <Z8aNY5TFj_-os4Fd@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|MN0PR11MB6183:EE_
x-ms-office365-filtering-correlation-id: 27ac08ab-edd2-4b8d-3c84-08dd5b6193bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?MJjvCsVeZlDhSCgfH5aOBZN330P5L2FFXekk/NVDfM81OkFFdXL4MeENs3A4?=
 =?us-ascii?Q?fc56TU9yIKYEEwI3vRgyNVSkHTxe4tLy2X8x8l5y2Ae/crvpMNLmbIHGYwfy?=
 =?us-ascii?Q?oM5ABxdZJU9XWUk+FJnl+29lqZCQeG96d0k5uGuSxyZGXjQlu6sGKmVISrBg?=
 =?us-ascii?Q?MTLRv7GZX/YOcmfr24pEQOcR7ANi4PJ/iQ7H7aJjqIMUgyN/764eFv8XCnP+?=
 =?us-ascii?Q?FzqLpWWhaKamoTBUUK8ETeeNak8Dv4iu6Rlvk0Kx1agexRctNHycCkDYExx9?=
 =?us-ascii?Q?cNbRIwwaoFkv8N5ZeSSOBhcK0W7Cnz2XTBBxxqTJcZTindXjbT+gCKXcizh4?=
 =?us-ascii?Q?7aJRxqdsafTa/5SZ2ENlSGRNOnZGOohoT5g9hyYmSMrb49CAjxB1V8E52E5W?=
 =?us-ascii?Q?tEszlPkHmjME9MJoHSGvNgL2SgffzCWVaWiETDV9HkW7Sqsi5FQyrzP486Yz?=
 =?us-ascii?Q?sCp2RI3T+H74Unl5k0g/1WvREHsta32x8fOBLYAG8B688B0GnPJ3gQDTLQr8?=
 =?us-ascii?Q?O51ydQBC+MxdseQkii09z1SokA5VCoub+Oy2aCKZn+2D7kWalBLuny9YUboi?=
 =?us-ascii?Q?nSAi+0KnqkYsyqMJ1CDfJ18AFVkQ+sw6ZSMXtprKIEvqXqadFK4IVZ7f3MnS?=
 =?us-ascii?Q?pqjN4CeAPmKANqo2TJ4QeHk5oVdQ4BqdrIfaIBKKRgDKQCt91LIKAHh+re81?=
 =?us-ascii?Q?Hv3/+AlSl0hU0nnOzjHjRZ9g2Z/BJjzxA6YuqjKwqFcw/2vQ2OYdeFi29/pH?=
 =?us-ascii?Q?oZr4zs25kPbk78/hkqhr7HQQxhlg45RfnyftdpaC8BrAkebJmJRYZeOcEZjS?=
 =?us-ascii?Q?DAmBzcU098zGBUW3V8tKUqOgHfTt14qHUkvu+itAIDUSA0wn9O9z3aDeLrXr?=
 =?us-ascii?Q?QH/vIHYaj4WLFO7D1pLpMh1BHNpvfFeofKMolXkmIeVp5K7+3qyDGG4DlogO?=
 =?us-ascii?Q?NQWJAtNDFDqO16atWXYkxy3ohCwipXJW7SCaotSrAHMH+3XAyqXG0xoxjOmF?=
 =?us-ascii?Q?QokaHgg+6yTBrJQs1DrFLeclu1OXTrMbNzv5f31LGAn+FgbQFegYIw3u6bfU?=
 =?us-ascii?Q?0j9g4sYC7HthFxv+CSLJTlkLIK21MUK4NSBLXjoIGSUlwCHo0KTGHQPI2nXp?=
 =?us-ascii?Q?wWz1ndCt3WXHTTrO5M9hSGqOF2hvYe9h4a8UkAF2FO82xomIlHbmp/V9P2IB?=
 =?us-ascii?Q?zM1AuMMfWMuybQ9w6ebmeGASThdAlvlrbili8qmHjkGcDVso65+3L9aq7wFe?=
 =?us-ascii?Q?P2yc/MFlgROoJMfC7HxrWHuNCa2vs4murME71fl6qujmcr8k0XS/8ujir2Oo?=
 =?us-ascii?Q?F7qAJOMH82KQGH9tkkZJQ1exKCEg5DGVZi2AEi/HLW/Ri/9Cs2Hc8pjvGTbU?=
 =?us-ascii?Q?9TsFQ5qlE8z9+lxosRwf32sOlJlJxWA2vdySGmEtTbCoSuWSBA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?voMAy/gfSENYWqrcwhrKKllXRIveYNSKQW7ewzXiRNRm9QFY7D737GG0Oheu?=
 =?us-ascii?Q?GvxreN7t36qO4KXWwE6sbn3JZ1BgbLExesATpMi7rwqpCFsg61EeKH7DYIzm?=
 =?us-ascii?Q?DqNYYHzlV1Pnz8A5pypDu3an4fybukwOx2+drB/uSfi+zE4pKei99yjGNs6m?=
 =?us-ascii?Q?Tb1wthwB1h4D346ZSoWWT7YG3N0lFUxuyCKfey90wM46X/nDiv+A+vVJf/+Z?=
 =?us-ascii?Q?TpVp4jBYc3IjnAwUzz9YvWnK0cuIKwcWkQiSjIcmH84FFo/r4q3PjjnMexoH?=
 =?us-ascii?Q?wa+Fsdh7TCHIutr1D2RYIXcq9vPsVrkQRcZKQXmK7QlFPYy6HH+IlDcHWjPK?=
 =?us-ascii?Q?Fe1V2F0aQX1SN/Is0BVQ21DshCLgp4ADMN0I1kL7jn+1bNgarZk9SCB2cvIb?=
 =?us-ascii?Q?TKfbqBxS2kOsCt82ZczgMoP3F+Q0iNmvGcLAOy7z1GEwP44x11LQ1Bbe6cpy?=
 =?us-ascii?Q?MuSR2S7JurUIwcypo6Yw0Ih55ZnCNjvqroY0dJU+eIvoFjRq796tH7bVYO/v?=
 =?us-ascii?Q?jTULPanwQgc7UtjKrwt0H/rs2v0Lr4De6lsosMk6eCUsAIxFRQbWO2tabxbO?=
 =?us-ascii?Q?ZyKd78ppEQ2gC82sOE+pg2V5+jfi1w8y4zI7woySmxiuX7TmD9J/uJ1lTsqV?=
 =?us-ascii?Q?6gMGiNptxRnuJGalzo+kP2ciGOSL3x+U/xiPQbW9YQXVJK2vbtOmI+QYjvdN?=
 =?us-ascii?Q?Aw0XHY5dAptA8q82suLYISEUXDezVxCsz83Om2N65ai6O19FMJfKSy9NTk7u?=
 =?us-ascii?Q?TZvr043mdpd18e2ePMZAYwRiMgnIizrS8vt72IjJF7noKv3jPeFk+rD0kInx?=
 =?us-ascii?Q?Q2zW7+HE5EJrppWDdAQ17LhbFpVPGD3CFLCQlj+pKin+bHuD5zICokRcGKTO?=
 =?us-ascii?Q?M8HHAl3CCP8vRsavO1ilu4UKXIhkCtQgEWlym4Y3C+CkPfv8MFf/HsBFuMRN?=
 =?us-ascii?Q?ut+fbB6qwZIO2EHGuswQLBm0FnJI68UacCvd9vpuKekakTNYFDrJCep3JoI7?=
 =?us-ascii?Q?wJAhKGg7HyHu4Dimlhh43m0uFKLnyHBYhSO2YYDpt6MuHRJPb7r3SS+llRx0?=
 =?us-ascii?Q?odP2fXP8KvVBpdo/pStCn+EDMkxm/C1PqDCFPlTf9UjDnzNfp+Je6XbOVPiT?=
 =?us-ascii?Q?pbhC62TR8PCwc7EbY6IobxiiCMzKFNSrIHKXtNgDv7ptclg3GfRZjg4Ku3JV?=
 =?us-ascii?Q?P10qhiHfL/Z1utNR/Dtbt01oha6azQmBfPMfrRCIX/fgBoGIuWyMraHrlTjE?=
 =?us-ascii?Q?ohBV2zg+OMiB9a0jTiiXLQ+dnvK/IpKsvTTRwucLOBP1K8gIlthGvZjdgYov?=
 =?us-ascii?Q?+e3GOaBHS40SV04VDl/FUSHBRrbVNGfeaLGp0kw14vD9XB4Eiu4TedJgi7jI?=
 =?us-ascii?Q?OpEimgJppoVhnpaNcuNoOgdLzyBQYCPCiAa/zLCiI/6FnU/l9LSZaMYGK/Hp?=
 =?us-ascii?Q?vxq60hhu9ujpeA3hlKQeJDUa2l/AMWZ4W4JfgYrzvGIMXqHOmm634W+ec7gq?=
 =?us-ascii?Q?D1HxOAHw1nTyrm+Kg1/pDtnMS4dHeLYW1JeLnPBtPImhYe45sDam/eCsj/Vb?=
 =?us-ascii?Q?vc7gGKDcqHdbgEJaldLYy8fLIMZnug1PZyBqchWYj8wxj/7KSsob0/hsTHgi?=
 =?us-ascii?Q?tg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ac08ab-edd2-4b8d-3c84-08dd5b6193bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 21:14:40.4764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4iEYcJUc0azARWz45kmgrxCqViEKBBnorqcY5tFpQEDrMlXXLDU3+ZS1lwgFCaAfIJLXgvH+0SQewGJUQUC7axN5avCY5CzonadJbTMz+/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6183
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, March 3, 2025 9:20 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v7 01/15] crypto: acomp - Add
> synchronous/asynchronous acomp request chaining.
>=20
> On Fri, Feb 28, 2025 at 02:00:10AM -0800, Kanchana P Sridhar wrote:
> >
> >  Step 2: Process the request chain using the specified compress/decompr=
ess
> >          "op":
> >
> >   2.a) Synchronous: the chain of requests is processed in series:
> >
> >        int acomp_do_req_chain(struct acomp_req *req,
> >                               int (*op)(struct acomp_req *req));
> >
> >   2.b) Asynchronous: the chain of requests is processed in parallel usi=
ng a
> >        submit-poll paradigm:
> >
> >        int acomp_do_async_req_chain(struct acomp_req *req,
> >                                     int (*op_submit)(struct acomp_req *=
req),
> >                                     int (*op_poll)(struct acomp_req *re=
q));
> >
> > Request chaining will be used in subsequent patches to implement
> > compress/decompress batching in the iaa_crypto driver for the two
> supported
> > IAA driver sync_modes:
> >
> >   sync_mode =3D 'sync' will use (2.a),
> >   sync_mode =3D 'async' will use (2.b).
>=20
> There shouldn't be any sync/async toggle.  The whole zswap code is
> synchronous only and it makes zero sense to expose this to the user.
> Just do whatever is the fastest from the driver's point of view.

These sync/async modes are mentioned here to distinguish between how=20
request chaining will be supported from the iaa_crypto driver's perspective=
.
As you are aware, the iaa_crypto driver supports a fully synchronous mode
(sync_mode =3D 'sync') and a fully asynchronous, non-irq mode (sync_mode =
=3D 'async').

As mentioned in the cover letter, from zswap's perspective, the calls to cr=
ypto
are exactly the same whether or not batching (with request chaining) or seq=
uential
compressions are used:

crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait=
);


>=20
> I've actually implemented acomp chaining in my tree and I will be
> reposting soon.

Thanks for the update. I took at look at your v2 [1], and will provide some
code review comments in [1]. My main open question is, how is this supposed
to work for iaa_crypto's submit-poll paradigm which is crucial to derive th=
e=20
benefits of hardware parallelism? IIUC, your v2 acomp request chaining only
works in fully synchronous mode, correct me if I am wrong.

In fact, at the start of "acomp_do_req_chain()", if the algorithm has opted=
 in to
request chaining, it returns after processing the first request, without pr=
ocessing
the chained requests. These are some of the issues I had to resolve when us=
ing
the ahash reference implementation you provided, to develop my version of
acomp_do_request_chain() and acomp_do_async_request_chain() in patch 1
of my series.

I see that in your v2, you have introduced support for virtual addresses. O=
ne
suggestion I have is, can you please incorporate my implementation of acomp
request chaining (for both the above APIs) in a v3 of your patch-series tha=
t
enables both, acomp_do_async_request_chain() and acomp_do_request_chain(),
fixes some of the issues I pointed out above, and adds in the virtual addre=
ss
support. Please let me know if this would be a good way for us to proceed i=
n
getting zswap to realize the benefits of IAA batch compressions.

[1] https://patchwork.kernel.org/project/linux-mm/patch/a11883ded326c4f4f80=
dcf0307ad05fd8e31abc7.1741080140.git.herbert@gondor.apana.org.au/

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
