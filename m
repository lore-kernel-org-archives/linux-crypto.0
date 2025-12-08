Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B33B8D53;
	Mon,  8 Dec 2025 04:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765168405; cv=fail; b=nDbAA5L99vrCxI9X18ICS7sjtetmqslvOYPSVGkSizDoW1gJGLWnqIX+oXqnl55H5dV2mv6cc21DvXZe7S/WoyGHxkP6dLELFbXVZFHBjH7gqGsc636TXrJfqGFRhk1SWyYkAyvBAB3i945y+n86bTMyk0cpmeutfsH7Z0m6Zkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765168405; c=relaxed/simple;
	bh=M8D0ktvVJuvHwzMwY4MRJ9ezbKtCBE2WpEVclxQ/uCw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MJTdSySqHJSmggTl7zSphrkt0QYtCAdCEuJnehr47Ta6KtW851oRc535yzZt7fW4IRiy91M+n6Hqv7LQduHe6s7O7CTt3SaC+D7RK3uoBHLIn0hGfDnrk4cBYTAu2pG0wVQJfGA4kmFfKHJmGeU9VPD1Fnct57HChp34z6Ay2mE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mBMFS9bK; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mBMFS9bK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765168404; x=1796704404;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M8D0ktvVJuvHwzMwY4MRJ9ezbKtCBE2WpEVclxQ/uCw=;
  b=mBMFS9bKt9sDfgVyJ48T+CywIPwr62Tf6J87+VFZq8B+vV5zpC86IB0Z
   Msk7O/eoTQwVs6E3KEKZzwtazVI6y4i9QIUGwdhETXqvOMWm2OQ5I8mOj
   YWtZ88RxhEpeB7IEuWw+Bh2g6sr3MgB6pp/dP97jxOMBUC8+AH9T+tdyF
   hNRAIP5HK7HGwyfQ0rIBbINd1KcZsKW3LCJyxmg6ZamkzBLsQngw8Ddlt
   oAEoElAedcsFTqYgxDyHgf8yYrlORqzoPS2zimRFnMmshaqgh4P/lil2J
   HjeUe6lXtRQuXaPtZdn0PLEGJ4fAmm5t6+77120LCwJovT6gnTtgWCTaD
   Q==;
X-CSE-ConnectionGUID: tRChEGC6TPe5tgeTIq8MgA==
X-CSE-MsgGUID: tVNGQrM5QsSGJY7x2IFM/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="78222544"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="78222544"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 20:33:23 -0800
X-CSE-ConnectionGUID: VXncSu9ERbCSXsU++oH7jg==
X-CSE-MsgGUID: 0qMhqGtKTviwgiqWVShKdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="195901420"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 20:33:23 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 20:33:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 7 Dec 2025 20:33:22 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 20:33:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szOch4xFE/FD/1fq6Itzch5UEypuajqXx4qC2zbUZT0SI335WADyBRy48W+rMRrvdfcMpCOUQ7jyTTby6fJGTAPs+J4VFUwyLCnAFxv/sd9vgL1j0UZ2SX/u+rlCiZZ4TUy0VTJIMmNdeMlU73ti4u3OPBkMntbJQdo4xX5JT2Br1xFuUTTkVlLNjVb0rYVJNMFEytJjAZY+LMdt+b4UEODi9CbxxyqDW0DacfHFOD8k+9l6YYng0rO14rqkPIzkJdBJgKBj0z7qk9aDJF5m/+//kKV4gFXwg5+AwP/cUyEqqGabAfv1FYyBKP24+rCZ47wOGUlLLJGtuZ0xkQ7saQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zTQd+g84Lbwi6wigSQTb79QADsGFP1kiSrwe9ipo4o=;
 b=RhZzros//Mu348jT+tErIGUpv/Fg6PmekLrr19tWRs2AX9Aw8ORL4hkHDsmSHsndAo8MrylefRHypduduUiWUx5BAq1SZbs7F3VsXbDS0wxp5w40oVIDq30j9ULCtRuiDbTIpeAdyZSBfv1Wy5nb0J7FPi6/UwwTEtd+NQbbWNJQrTQEtg7xM3WupOFj+GEdhy0LDqgb5FqGwZM1N/leHK5BJXQuihzrykFg5WUSkIFcZTYDZyXZ2OwSjvjti1GpPRZoB4gdquEcJsY9o8AODDonT9NHyO6EuVFlO9WoYrcV9EWXdGG5Y4VIkYnDYdS0m+b5UXI1VITQe08UZIlzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by CH3PR11MB8707.namprd11.prod.outlook.com (2603:10b6:610:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 04:33:19 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9388.012; Mon, 8 Dec 2025
 04:33:19 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Yosry Ahmed <yosry.ahmed@linux.dev>, SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0CAEcgegIAAC4yggAAFRoCAAACpAA==
Date: Mon, 8 Dec 2025 04:33:19 +0000
Message-ID: <SJ2PR11MB84728C0DFE406F04EE7C617CC9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
In-Reply-To: <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|CH3PR11MB8707:EE_
x-ms-office365-filtering-correlation-id: 2d32c21f-2662-48d9-a4df-08de3612e9d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?HePIo7ggSLbjLf9aPsw7arP1BeS6dI+qS7pT0NQio2MSk+EYMwOWuSSq6M1N?=
 =?us-ascii?Q?+/VZa4oRJe8HsrGVJ7wvN9PXMXPL8RUouQywLSD6P71RzIR5u1dmzRBwtenX?=
 =?us-ascii?Q?bL9YbT0gUYePE5MCL2mwukZa9aAKzoN77wm04CBBt3h9O/5Abk/6fWYnwRE3?=
 =?us-ascii?Q?iQAa0u+Jv9UN58rFzkaoGF1aQjEehsswA5G64hBR0dHI87mphOCOkMfaWNQa?=
 =?us-ascii?Q?FJW/5tyQtbVYqf+1zjtC3xdsx9DMZF+W0/bNG3nEYIdY5SmWrWoiNbdqTTr7?=
 =?us-ascii?Q?Dr2kheMhTcZgoIwnp2wF15P9M5R/PYKEdumujSHWGIxAwuiAftwP5zFkLYjS?=
 =?us-ascii?Q?YnCqqfjOj/Im5qeC/xdSolSfXRZ2qifLCLgfAkd2vNJU/mREP56wd5EcRz7D?=
 =?us-ascii?Q?yNWhzZ5A+qhLOi84fPz6lr+NxnNyLHCWpBg8/BCWqJYjA/ePJm70F4swaCEz?=
 =?us-ascii?Q?7nocu+V4fJC17xHaLlnKkp9ZkChYkRtvflEYZd43vqALME3dpD7MDNlB0YTa?=
 =?us-ascii?Q?CfGYEicjydtwI/24jJjdw+C92M1oIrxUpnDtYo54AVraiMPalWnTTsKn/SCN?=
 =?us-ascii?Q?pR4WDBX8R9PSh/YCfAq7vARODB1SWt3K8eHdT3O5PfhNu8aIEAxCjI3VyG/9?=
 =?us-ascii?Q?LuWPdF3Go4TKU2pJiNzxpdyY4Ex32ibCrQFXTHyUpTjZl/W8cCVqKHcNCsWm?=
 =?us-ascii?Q?lPQ65p+Y4Af2G5yet76IiGu/aPLC4GuS08QRVYc7t2dzhmbI6JjYNuU+S3Tz?=
 =?us-ascii?Q?ddRD0URcU9Tq8ZD/aEu+7p9hxFUggfCSS9D5nu+RF9Oy3DSFWTlT6WDfv4QZ?=
 =?us-ascii?Q?ZOFp/YxUiZKif82pj00otXnNsJbCnx8TB9ytk9sxBfJAMYWssaI13N3BVO0b?=
 =?us-ascii?Q?GMUg1WHJhWL1yYeBPhkmlUdPiXRHPvdXapwb0prGuVd/73crOwsBC29t+iuZ?=
 =?us-ascii?Q?NU8PklKusmTjhdzl5OjkQx2fO/MeVVXn09W93UDSm8fqIAfKxVof8q2NbZHh?=
 =?us-ascii?Q?Bvi/GHEmyt5l5+FINMl65EVRsTvebWX49xNzzoRLLs79tlZqT9AtMJdSMQsr?=
 =?us-ascii?Q?wH82A0kJOfN/kTApZxFnZqPLedF7QCJ+ko2VtIcMccqxKqej+6rvzq4azmmQ?=
 =?us-ascii?Q?iFNa392PJp+YFouEz+gT37WGxH6C0pr81h48cSiY6iXVzszXVpXL01LlyPpI?=
 =?us-ascii?Q?8uxdchczFQdhXJGmQXkWezDcZK4RBTrCmhz1bRPB4wsbCq6aISNAylRrlB45?=
 =?us-ascii?Q?1Ma0PyFjT7Zh9xhLPPku63lHOLvm3ayL6qnFgFoB1MeA9pOI24cTQLnkLoLM?=
 =?us-ascii?Q?Qmj9zFKkpUl02jBrF/DBUH/m1yX0St1Hz3Q+u0RKtX3lm2xHMsAFNnGKDw3i?=
 =?us-ascii?Q?/s+7w131frYNUSUPIiYWwAGHgfW0vjmnP9nUVYk1NbseUbSwXAWV2W9dfPhe?=
 =?us-ascii?Q?T1e4XbkBbI7glrnzRy169GWWobiniAJvR0oDMMMTFtMn8eG1C/pULA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4Dp66Km21xz1XUcxyGAQ9QQsplaq/M1P0PuKxqlXeyinCdO0LswcXMXVqK9R?=
 =?us-ascii?Q?/hvjhyDdOgGbjAzm4RHuhygPI4gUqZA59VNOiiov1+7f09dGuXvRO91X959G?=
 =?us-ascii?Q?6KgnmU1V4JnMVLGIYwyUreUYcdOJrMgh7a5wAsdFx/tXJZ0kpMNv37lC9RVV?=
 =?us-ascii?Q?GSKMvf4nPwpVMsvo4pUvYMX7ln3vZ1TO3BgUyO4BwUTbqF6i3ryv0uB09ekl?=
 =?us-ascii?Q?vIx3WV1RgmXZiby2pe7rveA//Gbo8862Y/2Qdt8umEFDDDVBnTmEI4Sr6WOB?=
 =?us-ascii?Q?yEw3qWKqiegdW19rOAok7bKMeCOn0G9MgtOdJqg5Jp2enNVGcwz3TDi2RRF1?=
 =?us-ascii?Q?gzIgcJqSIfZPTx73nMhGzg+ga0++VcIvF9ig3sWGdwJbjTKWwZZ+m/xRvOSh?=
 =?us-ascii?Q?/g2ekcXzSPrvpW80sKHA4yV2BiVRd50hPNMA/pGdeGSTmGq0dI4rCjDJTJXE?=
 =?us-ascii?Q?/qlnZKP0U7YbMSBVllYylJaoefa71LbywQQ/Y5fCXG4fK7JKYbYaAy4dgO+t?=
 =?us-ascii?Q?VsJ2kgSgIT3vkI/KtTRUa7Q8t4cEKRQ8q26o3B3rHWn5UBh7T04kK0aE9AnQ?=
 =?us-ascii?Q?TwSp/TQAULOJgw31r/Ce9WpilgvqYLKBDQ4tT8OYOypvTXm1iCyMy4ZTsXb/?=
 =?us-ascii?Q?E8gjaUKaRBd0X/daq0nW3UKwIgg0+ii1ztJA8G3B8wydv74lTZFDo7JHH3LE?=
 =?us-ascii?Q?s2CLF1GPbUrlE06ZSxAxll8IjV46UFPJPwEwEDse5zpPxFALxZi4tdGkJdCI?=
 =?us-ascii?Q?aE8hBy4RYCCevLllsY/tSNtMctbDjawdjqvOFxF8By+0n0o+Ej+jjWsr+7vq?=
 =?us-ascii?Q?8yGIywchWHNdbNznyySHfW3Lgqg2Qa8tTAnhSNGy9SlRVwgJ8JYmsQAeONCi?=
 =?us-ascii?Q?xUmK79YTccQ/56O+0zDeQ1RqKXI7CmrDJzWEX/WS1l0bdZcsDmCLr/grxl28?=
 =?us-ascii?Q?2oTmnojQbyAwkh1FYDlRuNmM/JbAYt6i2Y7r74Fp7sWevLlnKwuW5ba18Yzv?=
 =?us-ascii?Q?LPdu5sxeCvK9QCtEW0yRk7CRBm8tnAN0kBx7O2Dd731rTiOEJBMTQ5NfwIr6?=
 =?us-ascii?Q?YP5Bj1agk+nEBJ89TJ8Fok/e+Qp7+jXRAfEOCeerQixBDNTqVEqZMA/B5Qha?=
 =?us-ascii?Q?dsjgQPB3+fzqSgayCDq7u1Kp3XiGaMaJKzpH9ULzokNCHl8o7CueDaR8T1H4?=
 =?us-ascii?Q?PnGJa54c2PwUZVrJG85aqWobvKrM53Z74YgcBGYgiaTcv3m3RoMBNXOR3TmI?=
 =?us-ascii?Q?q2cXxSvk6KsmDG6t2+u6tIqE2A3EIzt1oVCgKIteWq/MU3R0RHoHa0YZzeud?=
 =?us-ascii?Q?2bO+98QGkuyKUOeEJqwHW5Yn0Su87RNYEC8CF/q1mLWTXrnOGTQDtLorIX9p?=
 =?us-ascii?Q?JMR/uR5AubhA2bU7oE/mkSOXgKVnEunaU4Yih41X63Id4cK9YNMpZVVqJPxl?=
 =?us-ascii?Q?+ctcNWyAK+a9GVKg9QM0ZNZyitNRHOL7K+2bQz7sikkW1UOu6rSs/bvbgaVa?=
 =?us-ascii?Q?roXVorFcdc1kNBPcva0ooyRecDtL7WS1GdMUk1YAwqgHGbJurm1c1TqoF9z9?=
 =?us-ascii?Q?9V1PbWXymhGMSgVW8vPRdAILtZcuM2X70ZogYxqjGYQezHHFaLKEz55m4OUX?=
 =?us-ascii?Q?dQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d32c21f-2662-48d9-a4df-08de3612e9d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2025 04:33:19.2491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +xqif5TzP+caQgAzP7oNbhsrhIaHKxieQBm/kdpb+SbFAomGHE+e+goeShcz/gpfcwTvlMBcin+Cxvsukj6BiMfZgzW9Im4Qi6s5m0bh7n4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8707
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, December 7, 2025 8:24 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>; SeongJae Park <sj@kernel.org>;
> linux-kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Mon, Dec 08, 2025 at 04:17:38AM +0000, Sridhar, Kanchana P wrote:
> >
> > I see. So the way my patch-set tries to standardize batching in
> > zswap_compress() is to call it with a batch of 8 pages, regardless of b=
atching
> > or non-batching compressors. In zswap_compress(), I presently iterate
> > through each page in the batch for sequential processing for non-batchi=
ng
> > compressors whose batch size is 1. For batching compressors, the iterat=
ion
> > happens just once: the whole batch is compressed in one call to
> > crypto_acomp_compress().
>=20
> Oh I wasn't aware of this.  In that case there is no need for me
> to delay the next step and we can do it straight away.

Sure, makes sense, thanks!

>=20
> I had thought that the batch size was to limit the batching size
> to acomp.  But if it's not, perhaps we can remove the batch size
> exposure altogether.  IOW it would only be visible internally to
> the acomp API while the users such as zswap would simply batch
> things in whatever size that suits them.

Yes, I think this can be done. In case zswap sends a batch that is not
an integral multiple of the acomp algorithm's batch-size, we might
have to trade-off one sub-optimal batch (fewer pages than the alg's
batch-size) for a cleaner solution.

Thanks,
Kanchana

>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
