Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDFA2907;
	Sat,  9 Nov 2024 01:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731114316; cv=fail; b=D6r8WBKGURORstTmUQE5OhfNxej+6e9USMiZjvYIhYDbvzhCIkx210/PG8JxQjvgi3RnYnHSbOBCgufEnL747w1nJoh6adwE5naE5jROPUJRw6u+G61GsjBtUagXUpV0+Q6IxTyOcORshcrfkkhahNRbvEjWHvcsCiIfPJgE424=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731114316; c=relaxed/simple;
	bh=JWN9XCJZxAWGPVSWdLoaKYclWEQuzdGNZiV7JLhEdI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C+/R4Pek/1pM6GBrdPwgo3E/2DnFjVJAjcor6Q4NchPWl3uJNoPHkMLP2eIbRkbRo7ZKqhsy605oGUaUCI2N84ZRPTWvlgQuZBLofG41HrnGJE/S/svo1Hmk5OSFEqthL2iM3xplfS7MVKi3KZOj2iCBFFBVpccyTxTFSFDd2pA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L5+u2yA0; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5+u2yA0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731114316; x=1762650316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JWN9XCJZxAWGPVSWdLoaKYclWEQuzdGNZiV7JLhEdI4=;
  b=L5+u2yA0MjVOjOgjqAv7M9gxo3DhJ2cR1oZUtky64O9yUL4jrykH6S6m
   1/GUrfq3pIAlNf9ikkF+QQUPXEc9p33GJdkQr4fivBaTtGSSkfaPIG+7P
   A90G0ZRJPQThqnZtqY+i2SBCVKK20wK3B/5jXtKwvsb2CaacdW4h7m+yH
   woxDetrYFh75ju6f5BvkPJjEWK0kv+xcNME9Wy3fM9UzmiiAUTKqzmZ0N
   hr81rk+X1+ufPhx6ZU9Cnzkg293ymmZClrIyslD0JJMoFkrQcHLFsPXhP
   qPni7rR4IrZbYoJoR6SOjl3zAZUcahAEGj9W/QbUhoPclsUxWEaiZxDtF
   Q==;
X-CSE-ConnectionGUID: 1y0RSeSBQxy3obXsUZHjvw==
X-CSE-MsgGUID: nA3tcU91RouBpWQPLR45pQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31169276"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31169276"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 17:05:15 -0800
X-CSE-ConnectionGUID: hsd2Hf+iRKa3OHnrwmzNpg==
X-CSE-MsgGUID: ssWsQQMtRKa6ow8AohzM6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,139,1728975600"; 
   d="scan'208";a="90661059"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2024 17:05:12 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 8 Nov 2024 17:05:11 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 8 Nov 2024 17:05:11 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 17:05:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TRNt9tiOEsfTUv6oabRCQJKmWPiHQ4d2HUrpqJSdtGLhUVez9cIYg0ASLfV0XnrMDuCWVgYgS00RRSxqJVt5RLuKBPURYk6ht/t5fjeuWrHjPWDnbH+zWTKHhvlLJ4IXK8QdkkQlTXMPNEnSves96LcO7rnVVUhufwYs3iQr5F3dRohsmd4KOJAGoLdNOaUjk7Ho4rEZTdSX0rIJxlINpREU8lAEcDnn3raCHxj9vXaJirlTso9U031S+qNG5dzO5aZm+VQ/L12OQm79djCjsW0/fdIkJMFDrCOdhGL9PeRCjkuq6/an744SI70wJIgkLs0SWWR2gEykER5p8rE3rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWN9XCJZxAWGPVSWdLoaKYclWEQuzdGNZiV7JLhEdI4=;
 b=QMuK3qwaJjCxGdvLeB8tP+iEN8dhKg9xoLcwccoUz9BEby/dexxyKIX/vRUYAHAwnNcC8QSBE7f1yxOx6O7uR1IecRirA+RKtHKQsBr1voxqS321pgqyjXkrmP4YGBKAiIq31Dk3MWsp11uv5dVmMgSMMU055e/jhZT1sJeNxiiOnNTgkyxBnVnHugh1XTXq7uvrH63zRDNYD4AKC+P9NIUe0CQ6ZAQrmox/qmIolp/LOsevizSt/IPtjsFPK3tPWh4k5+S4NfS0jw+N8yBVyiZnzmrV0y28R8fFGYTL//x7q2JeWFBeWvY826wGKj1X/pT9GNyJC1zNrpLJqA1PAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Sat, 9 Nov
 2024 01:05:08 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8137.019; Sat, 9 Nov 2024
 01:05:08 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Thread-Topic: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Thread-Index: AQHbMIESISE0FUMsYkiPsANVvfbhO7KsFYIAgAHBwICAAE5gcA==
Date: Sat, 9 Nov 2024 01:05:08 +0000
Message-ID: <SJ0PR11MB5678B2B7CF9ECE65D3A21B0EC95E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-13-kanchana.p.sridhar@intel.com>
 <20241107173412.GE1172372@cmpxchg.org>
 <CAJD7tkZGBcoREDCbjczdLUtDgYt1Dg06Wk=N=ZGVqRzVBmoPyg@mail.gmail.com>
In-Reply-To: <CAJD7tkZGBcoREDCbjczdLUtDgYt1Dg06Wk=N=ZGVqRzVBmoPyg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SN7PR11MB6680:EE_
x-ms-office365-filtering-correlation-id: 999406f4-3322-4a30-302b-08dd005a8e02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VkpPS1hxaGQyVXBIS3JaUUplL3dmY0tqdDROSlN1dUVJbmtwS2k2VSsxS1dN?=
 =?utf-8?B?OFpRbWlRN2FsRmtrZ0NPZ3dYcXovYU1Eemxqc2I3MGdLU1oxSFJaQ01XWVBv?=
 =?utf-8?B?ZFJ4ZlB6TFo1ZGhCWUc2akVyeXAyZDNQYm9PeEFyclBZaCtaRzhoUnlFZkRS?=
 =?utf-8?B?b2ZKUFlRZmpKcVhvZFRnSmRMUUt5c1kzQXZnMElXYjBmQVdtSW9ackh4N292?=
 =?utf-8?B?T25WV20wNGphN2RuZUVVUFNCa2JoekR6dmNyWklaVytvRU5ZN01DSUdRdVJQ?=
 =?utf-8?B?MHhkZEk0M3FZOGVyK2dyL1RUa1JJdXBIUE1wVk8vMW5CcW1jWUtSTk5OL1pa?=
 =?utf-8?B?VnZpQytlK0JYcUJzMitYbFNXcjgwRS9lTTR0TThYdzhlbVJsTWhhazNwVEVl?=
 =?utf-8?B?MWRiMGxmdHlLOXJiQklmSDY2M3hHRTlDNlNnS05TZ3VXcHFvWWRMZUFZSVUx?=
 =?utf-8?B?VDkzOTdZRWtWeHpDbkJSYWZvVk84a3lKdmxnVnh1VUNKaDl6WEMxc3hKWmtT?=
 =?utf-8?B?Y1BESWRmbFZLSyt4SEhRRHZRYTMzV1ZQVGVWTFNyUVpzWVJxbFhJc3dJYlRh?=
 =?utf-8?B?T2lOVGw3U3lkUXRWTWZzY1pxRmJuK1NPTW9ocUxTc2NhWERCWWZRS05JejJ3?=
 =?utf-8?B?Y25ybnZ1SlIyMERTTHA2dmdBK1hyWnkxb2xBOFZuYTlLRWFEUXZBWXRIK3Q3?=
 =?utf-8?B?MzhsN3FmQjBuOWlMOElKSE5EOHBueEkrOVUxQzlCaWdtdUJqYUZSQmp2NmZw?=
 =?utf-8?B?ZS9KMmRPWnZhYjhIYXp4ODdweUd0NUxBbDluejREbUZiN3A4VHphSjRQRDJF?=
 =?utf-8?B?WWtEakp5dXZqWFhkQ0NsdUpOMUpJbXIra3V6YitZK01vNUwrSDkwV041YUN4?=
 =?utf-8?B?MForL01Rd05WQ29kNVpOZGt4VmF1akxnbC9ZQUZQZWFGcWhuQS9iRzFQVFRK?=
 =?utf-8?B?bURVcUtxYjBOQURTYlZtMDVGSDdzYm1IajVxMXRWK0hyWkU2SFoxY1E2cEpH?=
 =?utf-8?B?MDQzUkhFYnFyQVNKSXdCUE1ncy9YLytnb1ZFSTcrVTJ4T1ZjbFEzbGxMcG1m?=
 =?utf-8?B?aWozV3BCTDFVMTl3dGs4VTBrVUM2TVZiUXh1eXNHT0dWK3dYeVpHUVoxOGVj?=
 =?utf-8?B?TSt4MlhnMTJtRXlteHhVR0c5MzBkenBMbVUrOGNiQlM3RENBenVvZ2tBSzBT?=
 =?utf-8?B?bXUyNXR6cXBROHRRblY3RVpGQnpBYkFKSzRCVnNVZlduLzQwZzFMUG9zMm1W?=
 =?utf-8?B?UGpzTFBmOGw2N1AweU5nSUNkUUxaaXRMcGl3STNjK1ZtWWpoR0VMdStPUSs2?=
 =?utf-8?B?NFdrK0RhZEQ0cFZvOXg5Q2o0a0NFNnM5UXUza011ejZUWit3SDNQdEk2d1Zk?=
 =?utf-8?B?eHhud1RBcG1CeTc2MENvTGpPVXhNNTZwaUU1amxGTjZkQWZkbTQ1TEpQTU95?=
 =?utf-8?B?ZmpGZW5lUFJ1MkJ0c1dHYlA2ckVBQWhDZ1B5aHR0dG1QTHFEUFo0TVUyUHVw?=
 =?utf-8?B?YUxZVzRHbzFIOFVLNlF3ZGtvZzNXanY5U1lXOFVBbGdJRVE5UFdSZ0pYTlNt?=
 =?utf-8?B?MlM4T1ZlTWU2SUcrVi9oYVF4cjNoa3RRd1ljRHhwVlFFNCtienc5aEJ3MDJN?=
 =?utf-8?B?SGUwaWMwWjE4SXNOcHJpK0xVejdXdi9WV3U4NDR4dWhMRHUxdExWSTY0cUR3?=
 =?utf-8?B?TWRmZ0dKNmtQQzA2a29TMHFqRDNtdjNMUUhuU3NDYjhUellicll1MURSajBP?=
 =?utf-8?B?SmdTWnl6eWpWZW12WlRGMDRMc25xTHZDeWQrVW9ObWhyVUpaTmFLV093RXlk?=
 =?utf-8?Q?1dYrERTH/5S5c4KHBvQk3goAqzPnpRwgWe+EI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2dPRjVpb3hRS21NdjJuOFpVNDQ0WXRLVEZ3ZnFHdEFvNDZRTENsV2Y2U0tM?=
 =?utf-8?B?VnVmeGpTR3lJcTNja2xmdUsxS3F3SkpKdUVLWmhkRWZwTXN1UTUwTC9uaGxq?=
 =?utf-8?B?azI4NFVmREFNcCs4cXhuTGRxNlRmRlpuazhScW44YjRCd1F5Z3dSM0xjYURC?=
 =?utf-8?B?YmUwT3A0NzViVlRSbXlMc0daQ3BHcXpHRmRGanNhRGNtWUF0bFloTnNOelRr?=
 =?utf-8?B?UzVRV3REUkFNZzJSSitka1hqbXptVTVHbGdZY2J5c3pScDhpaUdZSzR4cGRt?=
 =?utf-8?B?VmFCWGptRERqMW9DQllvQ3ZkaGNYcEhrYmcrY3FXUWpWNmZCVnZqbWl0THMr?=
 =?utf-8?B?UkxJNGNrbDZQVDJzdzB3Y2t0RGQxbndqWkVPQ3g0UENmbjR4eDNvT1pEUGhl?=
 =?utf-8?B?dG1uTTcreG1WZTJmZmY1K1VrcEVIalNjVGNNK1ZYa1RqckhMRFVrcHNOVys4?=
 =?utf-8?B?RHRlL1Y3dzBPSXR4V0k4ZjhuYTFkQ3ZmYXdyU2FxaDJndUlNcHBqR0VxQjdL?=
 =?utf-8?B?N1FvcHd5eThOR0FYeEh2QzYralY4S2xVa3hLaUNhQk9BNnk4MU42Q2F6cHQ5?=
 =?utf-8?B?bW82dThieW1OL3R6MTd3VjBJSGtsMGNpTG9NVmZ4S3Z3R3NSYnQ3bTc3M2RH?=
 =?utf-8?B?empJUCtoMXNGcFUrVy9iSEpGSS9UNWRpd2V3NlU4TnR6RnFUWEpNdWxHUmk0?=
 =?utf-8?B?WTJwZ3RKeFpoUkc1bVFnNnlzVXhLM25IOXdsMXEzSEQvemkzWTBpWlZaU0pr?=
 =?utf-8?B?VlRheCtCTWprK0V2Tmc2U21zWEhYNHdUeVcvS3ovanorU0NrY0RVMVJOc1pi?=
 =?utf-8?B?cDIreWlKMGxJZVpnRGpuNDdPaGwxWXdjb2ZJWERMSlJiK2hsTWM0eExETEFH?=
 =?utf-8?B?dHhGaUFiNnAxUzdaYmRyZHVlTFIzYmlnSWc4UlhIRzZXOFo0cWl0TElnSVVX?=
 =?utf-8?B?QS83V1V5T0wvS2wzbG5jRTErQ2E0cmo1KzdLeXArWDRxL2pFZEJlZGtKb0dH?=
 =?utf-8?B?dXJQRW1ET3piaXhKM09FbFZhNHRXaTE2SWo4SkNmQ1JHa2F2SlJuTjN1c0Ew?=
 =?utf-8?B?bUlkWkFzcWpoM254eS8zQWVqME8za1VyMCtiVW1CdU5UNjkyM0dETG9Zc1Fk?=
 =?utf-8?B?TjlIWWp5Q25mZGF0NjM1clZjUWs0NG1JaERKQnJBSEJpSVlyR2hLaEs2WHM4?=
 =?utf-8?B?SzhnNWhjbHhDM2pETWlPVkZiVTQvSDhVb0JvZUlPY2ZqQ2dUNzQxd3ZrTzRk?=
 =?utf-8?B?ZGJHT2dLcWxDa1ViMnRSTlVRb2hMM2IyUFlFa1NFQnl0SndSc0k3OFZkb0dQ?=
 =?utf-8?B?N1FlVU1leUJtL29xL1g0SVlyQStnbDRDdE1ndGM0YksyMjI4VDgzankxM3ZW?=
 =?utf-8?B?eFdJUEwrWG9ZN1IzRnhvbzlsTWJlUDh2M2w2ajNxOGZQMjVyd3M2VmZQUTNL?=
 =?utf-8?B?SXBWSjRsRjJYNTJucnlOVEN2bUZ4S3FnWVFwRkE2aDdDVGNIdndmV1Y3MUxN?=
 =?utf-8?B?SzRQMEI1YnNDK0N5bnNtV29MYWJPcFJ5RzhjUWRRY1FHcXRmTVBGU1FPWU1M?=
 =?utf-8?B?eTFUa1dUdU5NUXI1NnN4VE9ualRBcEhXaXp1N0QyU3NuSUZuZnMrTnVkYVQx?=
 =?utf-8?B?a0xOOWxZb1dBUGMxdGJwV2g4bGdKUXhwWkhFQk96QVJrS1I5NEdPc2ZTMkY4?=
 =?utf-8?B?T2xyOXl3TGVVTkoxeGZWbXFKaWFwNlNDOE1nSWJOL2VnS2dTZkpXakdON0d4?=
 =?utf-8?B?RitMYlVSd0dYbCs4NGdsMURZSXBpNDFaR2pCQzZrdmpCaktkdno3cHpBbGto?=
 =?utf-8?B?a0hqaGw2UFBSRzI4VURrM2NEUHlFNjlGbk9FTHlDUGVYLzVxNjRmMHczcTRi?=
 =?utf-8?B?Z0k4cTU3blRBN3p3WmU5aEZOL0J0UXRPTXJUV3BGUkJldHcyVFo4SVowREc0?=
 =?utf-8?B?S1hSYTZxRWVUTWt6bVh5QmcvRFNmcHdyYTZFRTNuVU0yMlB6TmdQRERUTTRD?=
 =?utf-8?B?Tmh0RVlYWEE4WVBRQ3JmRjQ4QVRtU3k5ay8wTGdKYWhSVm5USHRhd3dRN29J?=
 =?utf-8?B?c2ZWTVFmZUthS1JhNVJ1ZUVBdnlEd25pWStLNWxRTE9Uc0lzWjdZaVJZRnNV?=
 =?utf-8?B?dUlQUDlORkF6b2JJL2VGbThCbEY3aHl0Sk1hN0hFbkcyN0FQZVpVKzZYNExM?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5678.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999406f4-3322-4a30-302b-08dd005a8e02
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2024 01:05:08.5770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HvtRL0OqfHYZPHRznAuHNTF20C7GOTI25Wdc6GI1Oaohl3q9C+rnnRIdxOF+PmECx1orY/nzJN3RmgdAj2alPn5Jfv0y6NyzTieHG5Q4Gzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eWFobWVkQGdvb2dsZS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgOCwgMjAyNCAxMjoy
NCBQTQ0KPiBUbzogSm9oYW5uZXMgV2VpbmVyIDxoYW5uZXNAY21weGNoZy5vcmc+DQo+IENjOiBT
cmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPjsgbGludXgt
DQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgbnBoYW1jc0Bn
bWFpbC5jb207DQo+IGNoZW5nbWluZy56aG91QGxpbnV4LmRldjsgdXNhbWFhcmlmNjQyQGdtYWls
LmNvbTsNCj4gcnlhbi5yb2JlcnRzQGFybS5jb207IEh1YW5nLCBZaW5nIDx5aW5nLmh1YW5nQGlu
dGVsLmNvbT47DQo+IDIxY25iYW9AZ21haWwuY29tOyBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3Jn
OyBsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRi
QGtlcm5lbC5vcmc7DQo+IGViaWdnZXJzQGdvb2dsZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBB
Y2NhcmRpLCBLcmlzdGVuIEMNCj4gPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47IHphbnVz
c2lAa2VybmVsLm9yZzsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8d2FqZGkuay5mZWdoYWxpQGludGVs
LmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3BhbEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggdjMgMTIvMTNdIG1tOiBBZGQgc3lzY3RsIHZtLmNvbXByZXNzLWJhdGNoaW5n
IHN3aXRjaA0KPiBmb3IgY29tcHJlc3MgYmF0Y2hpbmcgZHVyaW5nIHN3YXBvdXQuDQo+IA0KPiBP
biBUaHUsIE5vdiA3LCAyMDI0IGF0IDk6MzTigK9BTSBKb2hhbm5lcyBXZWluZXIgPGhhbm5lc0Bj
bXB4Y2hnLm9yZz4NCj4gd3JvdGU6DQo+ID4NCj4gPiBPbiBXZWQsIE5vdiAwNiwgMjAyNCBhdCAx
MToyMTowNEFNIC0wODAwLCBLYW5jaGFuYSBQIFNyaWRoYXIgd3JvdGU6DQo+ID4gPiBUaGUgc3lz
Y3RsIHZtLmNvbXByZXNzLWJhdGNoaW5nIHBhcmFtZXRlciBpcyAwIGJ5IGRlZmF1bHQuIElmIHRo
ZSBwbGF0Zm9ybQ0KPiA+ID4gaGFzIEludGVsIElBQSwgdGhlIHVzZXIgY2FuIHJ1biBleHBlcmlt
ZW50cyB3aXRoIElBQSBjb21wcmVzcyBiYXRjaGluZyBvZg0KPiA+ID4gbGFyZ2UgZm9saW9zIGlu
IHpzd2FwX3N0b3JlKCkgYXMgZm9sbG93czoNCj4gPiA+DQo+ID4gPiBzeXNjdGwgdm0uY29tcHJl
c3MtYmF0Y2hpbmc9MQ0KPiA+ID4gZWNobyBkZWZsYXRlLWlhYSA+IC9zeXMvbW9kdWxlL3pzd2Fw
L3BhcmFtZXRlcnMvY29tcHJlc3Nvcg0KPiA+DQo+ID4gQSBzeXNjdGwgc2VlbXMgdW5jYWxsZWQg
Zm9yLiBDYW4ndCB0aGUgYmF0Y2hpbmcgY29kZSBiZSBnYXRlZCBvbg0KPiA+IGRlZmxhdGUtaWFh
IGJlaW5nIHRoZSBjb21wcmVzc29yPyBJdCBjYW4gc3RpbGwgYmUgZ2VuZXJhbGl6ZWQgbGF0ZXIg
aWYNCj4gPiBhbm90aGVyIGNvbXByZXNzb3IgaXMgc2hvd24gdG8gYmVuZWZpdCBmcm9tIGJhdGNo
aW5nLg0KPiANCj4gKzENCg0KVGhhbmtzIFlvc3J5ICYgSm9oYW5uZXMuIFdpbGwgcHJvY2VlZCBh
cyBzdWdnZXN0ZWQuDQoNClRoYW5rcywNCkthbmNoYW5hDQo=
