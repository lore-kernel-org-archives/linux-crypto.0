Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556EE2594B2;
	Tue,  7 Jan 2025 01:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736213886; cv=fail; b=oI1ovqJu4VXvhybVNzaAy5gpA43/8eN4TIx1tpM7Jeyj3n0QSADbm8/jUOyjSOITNqMfqm1QwxzfJztUtHv69KQwe9OsT2tjVOWtNbqKY9o4XCCpnQmZ0OHDKgRs7VNrbl4KtkGoR1PxcQO5FnVEtGxB1EndPTvVfFFMxjMZwcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736213886; c=relaxed/simple;
	bh=iZreOPNf65Zay8NgjWFuDvqtDBgmznMUnH8OhylstEo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eBA6DNdYl6PoAuyXPOuN99irUgJgSv1t+YmKaupe6bFYhJA6NuPeqtky6jr1JnlwPK1bh0fXhQBsFJjkA6cGZ8a1ykh2Y65tbXfjt0iZf7oasecHauuxGXPnGsjqJkxHV2Bth6sw17qkzWGpyW59iZZ6TNnYDf7Js7XZOC577f8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=edSFPkm3; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="edSFPkm3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736213884; x=1767749884;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iZreOPNf65Zay8NgjWFuDvqtDBgmznMUnH8OhylstEo=;
  b=edSFPkm3kZhb37KnywizuPNpfn/tdDCjgfKM/pJHQ0ll1Z15dqhCqLJZ
   uQZZwjg9cB1IdpasWzKdPq8zak+z+Hv2vRy3zquWwswpecJiTgqI2YWyv
   xcEgeQwbU2/F1KEnMQgYt5MfEtzzSpS6esegCGKKJlnqryUFT+byIyXU0
   lcthVK3GpmheUa/0b5oo1tAX0TrkXgqhP2ddA9liPL1t/BFbdWHEuxoxj
   FCNjmkX77t3ohgExWybme09jZInv5yXmKJar7ZA+6Meb8Qd7a4SyR+J53
   BnT81jY5zKzmmO7lN27niCGI5UkbCHDBmIHvCiCowZSSffikRM33RYQpI
   w==;
X-CSE-ConnectionGUID: kLibwc2ATsWCG2+0+b7LCQ==
X-CSE-MsgGUID: SuS+V7WuTwumaFOxUk18AA==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="47734833"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="47734833"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 17:37:31 -0800
X-CSE-ConnectionGUID: fOf6CcVOTXeb1yMU7gd53w==
X-CSE-MsgGUID: Xj6S33MCTAKBMcpcvfuL4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="107578619"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 17:37:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 17:37:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 17:37:30 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 17:37:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQqhNXP7g31vkHD2kxJMCb5rbf3QAW4wXofTR/gplkeXWTKi1EXH/xMya10OPiqXwzPGN52nydxG1qUDYFUlSrlytUx2fx3E3t1DRAl9s4ehuQ7cQCT22UxVVz+jV72i9wSsnjjc5lVerES8MMmUKsGgzs3Ji4p8phlCkBbl8KlAGkOYcsTY01gB/Rx1GHjsuRtvHZKEoW1z12NZ6T2qkgs0fbJkP/gnVMvstZiLhQQuHzSw7wBlpi5dxl9HRbuhyoZk720zTPbyENzm+izwyFR4ienqjsgSayhoh4XKpIl7/lPCH+P3f5+TNrOMjkgwcMza4wR0cLk/vPkbePaSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZreOPNf65Zay8NgjWFuDvqtDBgmznMUnH8OhylstEo=;
 b=pygh6LRz0ZLgJI2A4Et034m7fVT3yXw+HhG9PHWnkydbTSZKf6sTN/NigYMiAcXPuMC9KHWXVBk8jSaRCZsBSLH6t6nyI/RDD7e/uueypTFjuBrnaIahsTq3t0s3R6LU9R0CalhHii0uIRQtH8zQAK/J0CJg7QMLUstgGgqij8DuAmtstS4BSgaNJfpZKCJpRXRJ+YCeWpH159bCIQZYzLdIHDGJ60Wd+bx3FOBMYpse9Wt7Xu8KMPSe6mT+1Fx6Y9uhuDH/mmIw/MXfMID4INtxWOTCYJ5Mo7+UzfkxiUwaSHPCeHWXMiAgmjpsoesLOxbBnmX5hDiafUhhCHwz1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by MW4PR11MB6665.namprd11.prod.outlook.com (2603:10b6:303:1ec::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 01:36:47 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%6]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 01:36:47 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Thread-Topic: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Thread-Index: AQHbU3H2SqTrZiGQHkmN4NbyUE5ZLrL7lUYAgA58frCAAGuLgIAAHj/g
Date: Tue, 7 Jan 2025 01:36:47 +0000
Message-ID: <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
 <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
In-Reply-To: <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|MW4PR11MB6665:EE_
x-ms-office365-filtering-correlation-id: 25652307-2f69-4ea7-1395-08dd2ebbc02b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?TWlIcFhxR1NoeVl4WENJdGwwcWFtOTZHTTNiREVVeHJYOGhCQVl5SW9sOHpl?=
 =?utf-8?B?MlEvaG5PTVFsYVJ4bjdRMHFEMWtzU0NHcnNpeU9sWUtMZ0tzNnhtWUo5aGhP?=
 =?utf-8?B?QTErQXlmd1R1V0xvM1R3QVlNdExWcTlOVlJ3ZElnYzBzYUUyQzh3ckNUQVdK?=
 =?utf-8?B?cXQxMjRBMzlTcEtmMDVmM0lrbGY1VDIyZWluWlFROTJreC9JRU1UZ3JFczZs?=
 =?utf-8?B?VGRydERYa25BWXFmYlRMcVFIRVZYZVE5ZmFNK0RZZ1poSUdtdmxIMG1MeXkv?=
 =?utf-8?B?LzZRWHU1NllVR2JZM3pqNkVkaFpkMGtFaXB0eGNMeHhMQ0d1OVpmOUVDMkda?=
 =?utf-8?B?cWdDYmU2VVNoYXREVkVMTEVDOExmb2tXSmROM2k5VXJrTGczVXY3UmIwUkFk?=
 =?utf-8?B?aS9KUlZhQkJKam5pR01Kd1FzU1M4RXFWNlNBS2M3UHBRSG16K0pvMUV1UExR?=
 =?utf-8?B?bEVMbmNxb2ZBRHpYTm1wcXNsenoybDRCc3M1TnlBa1dicFNuUmhQMGdhaDhi?=
 =?utf-8?B?N2FoWFV6TFUvRmpTYWlQeDFGMzR5TFl4NThHRDRyWVhlR0JYQ1IxZGZMbkpy?=
 =?utf-8?B?Mk9DK2dNSE0vQ3RucE00eG5vcnJicDZWeVJaRWU3RnBjdHVsTEJOR2Y3bi9C?=
 =?utf-8?B?a0RFRlNzRG1jU0w2NlJPUVZzeXRveWZMTVA0eW9yNDNVaDUvSFhmb2U0WVUv?=
 =?utf-8?B?ak83d1owQWJ3a1M1SlM0TDNKRTU5RlhYejQ0bDVQcFJmTVc3TnFpTnYvT0xp?=
 =?utf-8?B?c0V3eDRQQmpoRDl4eDJUS3BjeWNNNzQ3SUVPczN4bW1lUjdwNXprcHBxdkh1?=
 =?utf-8?B?SUJpQU5GdU9Fckx3WElCL3NtMm53QXFHYjVkNGNqTUc3Ty9OYXFlUzhrcGp6?=
 =?utf-8?B?RFdEc1Ywckxyb3ZZMWlrNllieUZVVHM5VjhmWGZ2MDJPVFNYb1FweDBYcnVI?=
 =?utf-8?B?VWVWaG5hWEh0dTBMd2I5YmhFeWptWlNWczdqRlQ4SXl1Y2p6R3dETVUrWE8v?=
 =?utf-8?B?ZUFoYWQ1Mnc0ZkR1NXRVVGFQd0h2YVhiR016NWJ3UVlNTVFnMkZxdW1MOTk0?=
 =?utf-8?B?cHJ2M09PYlZvSEhLT0hTKzNtOE0zZ3NWMkZZYXZLazA1dzhRUkgvanpuY2Uz?=
 =?utf-8?B?L2c2S0h0aVRYOXdZaDdLVlpGS25hOUFyenlmSWVZTVM2MkE1UzR2TzhZV09r?=
 =?utf-8?B?K1VITWd5RXVhbmhGWnNYMHRpU3dwYXhwUEN1eU9qcUN1R3AybldudHpGZ3k2?=
 =?utf-8?B?cytOTndHVHNqNG5ZV0lQZVN2R3BWWDVoVGQwS0RsRGZ0dHNLU1dPVURBZlpM?=
 =?utf-8?B?WjZTZDRDSlBhbjVpUXhJQ2ozNEJYRE1JSncya3dYYWNMTDBnOFkvVGNkSzlF?=
 =?utf-8?B?VGpEZFVCcEluMnhEOVJMRHVrc0JudDNJVGUrRTV6MlRwbTI3SXIvRStMRUln?=
 =?utf-8?B?dlFtdVQzcGJUclZNNkVibytqSlM2SmpGbThRYlVvQU1sMlNNZ0JvOE5TU3lQ?=
 =?utf-8?B?eVpMRXhtWExTSDRNcUhYL0dJSlpweUtteFFMU3hiQkFNeVFNUngyZGRKOHdM?=
 =?utf-8?B?NUljMFpGMSs3bXpXNVpjMmExK3orcndoWC9yZ0NqQmlwWFczSVpEa2lHbVhL?=
 =?utf-8?B?VW1adjU1eGVXM0c2U1J6OEVPenRnaXRQQnEvWE1KdHJjelBBNmNpeHBua0NQ?=
 =?utf-8?B?WWs0dkQyTnNydDF4d2lubTFqYVBJR0FZWktsTjlJdkdTNFFDZHVNNVREUEpH?=
 =?utf-8?B?bmk0Q3hqbHYza280UDl0VDJrYkQzeWFZbURNRXlQZWM5SmlrcjlYTUNkTFRk?=
 =?utf-8?B?QitYaXlySSthSmp1ZjREVmhxNFlUUWRUa1VvUkJBdENqSzJHK3RWNFlqWkNj?=
 =?utf-8?B?aUNLbGVRUEgvVUFpS3RuanROQU80WFFqbEpzak00QmdrTkxWMk5iUjkyN1ZR?=
 =?utf-8?Q?EvIXM8ydy6Xvd85sgfBxQmfQLDdFMuBx?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHVrQy8wVTlYTDBweXdxWXh2ZEZSYWorTXZXQXhHUnRCSHdSV0Q0YmQwTUNF?=
 =?utf-8?B?WlUrY000NFNvTndkRnJnV2M0NmVzWXV1ZmZNU1BYamxHQkJtdGhSaG5MTE9q?=
 =?utf-8?B?TzNxSVRIU1NVcEhYeDY1UjVpdng5bEgybjczaWZIWXdTVVRpMHROUXhLSzh4?=
 =?utf-8?B?K2ppRkdOb1hJalNib2s0NEhlUjJSMUV3R3NaUFlNK3JzMFNEbFZxTkhacjZH?=
 =?utf-8?B?VVNBdkc2Zkc4N1JlS0M4RnEvZy8wK0VEa2tncGRIWmh2bHdsTWRmbkE4dXEw?=
 =?utf-8?B?WE0vWHRPVDFDc1VpRUtpNTBBajlqS3lpckFOakNHWE5kNmlxOUZjWDFnd09E?=
 =?utf-8?B?cXgwdk9ONjNQN0JYblJIWGxqV0o4TUVTQ21nakduS3dOSUdvK2dJb3ZDRGpt?=
 =?utf-8?B?RnNvQ1dZUUkwU3NsbFAvQVV5MG1GblEwUFo2cC90Zy9EeWtPZDJVNHVvMUxM?=
 =?utf-8?B?WUlQZVhPQ3RqbnpjWkJwbzgzMFZDb2VPUjlXeDdvM1hwZGJyVFNLbG43dkRu?=
 =?utf-8?B?UjBTSkExa3RVQVVlREwxUHYxdnRYWnRvcFE0OWlNeGlwR0JIZXJXcjRHN1E1?=
 =?utf-8?B?WFYramRTdHJiSGwyQzFnS3g5b0tjWlE3MmkxMXlOV1cvVXo3L2ZOTmZrcyth?=
 =?utf-8?B?Sll3M3kvd05rSy9TbzkwU1FpQzR6Z1RIRVhGYVdvZkZrMEtUblBPY20vMWdX?=
 =?utf-8?B?Qkt1SXgrQWVSQUN3Zno1UzA2T2laVWp1T2UvRitIOUxsNHNRMUIyVHFETkx6?=
 =?utf-8?B?SjN4MnBWdzVPcEtsVCtwUmhCSXdKSDNGR0VlNjFnQ3FVSmF1VWpPUkFhOFlv?=
 =?utf-8?B?Q2JrK3o1b0lleDN4dGMzNlZiWC9iWmM4U3ptL2Z1TG5TOXRIUVpSdHdpQ0dD?=
 =?utf-8?B?V2RRaDE3Z2dqbzdZbjZBZVRrWFlnTTc4VmdzSVM4Q2JWcFl2UHB4eFdLanI1?=
 =?utf-8?B?dXo2Qm1kZWNJY3NBWThrSWJzK1p5V0R3QnQ3VGNXK0tGTDRCWnBoWlFCWkV4?=
 =?utf-8?B?VWN2cTRpL3lWTjQ5WjkwWmtsejMrVFoyWXI4R0o0cXNaQlJ6Tk9TbEZEK3hW?=
 =?utf-8?B?c3R0NEFtcEVUM3FPMGpES20rV2hLdVVCWUNZMCs1anZQSFUyTlBGb0dPMDlT?=
 =?utf-8?B?R3krUkxMa0MzN28wamZoMWlNZ2I4MlVFdkhHUFo5RGl1a2JjUmIwVTdkblNI?=
 =?utf-8?B?TXdacHRxV21KUnpocE5jNEZabkh6dGw4RUZRQ1BIVVpQOUZIdVFUMS9kWnZS?=
 =?utf-8?B?RytlbExwU2VRdjEzV1VQZWdwZnRJSlorZi9TckptZXJTdzdWRWNKNm96ekVn?=
 =?utf-8?B?WTdtU3R0NGJkTW1SQkFBVVFzUGdvalZ0MUxJS2ZNcEV2b3h4NWFZQnZTcHhI?=
 =?utf-8?B?d0xDUmNoYy94T1BMTCsxNUhycTFvZHZTNzJ5R0thNUlKYmViM2ltZnFSaE5q?=
 =?utf-8?B?QXFLS2t2dHM2Q0hsOGZtdWpNV20wTGsrWDEzOUlqajBoQm9WNS83emlmSHN3?=
 =?utf-8?B?UjgxQ1lyc0FTRDBVTTlTNUVsWHFITk5idW1lKzdJTGhjeUdUWlMzbFVpTkdj?=
 =?utf-8?B?dVpqaG9Rd2ZSNjhyYkVHZDdTSnFtdXcwV3V1aGppUm9vQ0diOWxNTUtubVR5?=
 =?utf-8?B?ZTJTN3M1a2hsQlo4czJpa0ZnL0JvR3RLZU13UmdVOEVhMGFKNlEzTFFpQXlT?=
 =?utf-8?B?MmthQTdkVkJndUlDR0FKa2dmOG14WE81Zmo0UjVkSGtHdng5SlBoTVp6cVdI?=
 =?utf-8?B?bkRvTWV3ZUhYRlNLOHdTcU82bk5CN0JOSklSa2VLR2dVU09lMWNWWkVNTTJi?=
 =?utf-8?B?cnRzOVF3UncrRlpoWFVzUVVMcHRkaVk2eld3TWFGbXFrM3QzcGNPdXhlbmVW?=
 =?utf-8?B?d0lxRkIweGhZQjM3Y1cxOXhKVnVJang3MXFIUFMvZ0pEZEhrOWVKSWNoT0Za?=
 =?utf-8?B?ZnNoWUV6Ym9OTDFzZDBadkozbWZQK21TTHRlRHBjR2lXSFhEemwzM0lIelNq?=
 =?utf-8?B?QXd6TDZ5VVEwMG1wRzI1Rjl1eGtiVlFuNkw3Q3M5VFk5eGFFZnRuMmkxSllK?=
 =?utf-8?B?cVpSU0IxUW9ld2oxMlQ0RVF5WFZxNG0zckl5RlltSjVXdFJTMnY2NVl1S3JL?=
 =?utf-8?B?b0JrMlF6RnlYN2JIRlAwOWpWZnVYWFBrdGk2OG00NmE4S2M2S29idk02YVdp?=
 =?utf-8?B?WlE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 25652307-2f69-4ea7-1395-08dd2ebbc02b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2025 01:36:47.4000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mMQTpC5w+oCqPBqV+MHYK9SVShzEzfNuegABwK18sZP0eq5jXVVQm76H+UXlw6Kz65bXZ0CZ1MVH+ET0/sG79T0OyrpfL369+H5wuHKoMlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6665
X-OriginatorOrg: intel.com

SGkgWW9zcnksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWW9zcnkg
QWhtZWQgPHlvc3J5YWhtZWRAZ29vZ2xlLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDYs
IDIwMjUgMzoyNCBQTQ0KPiBUbzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlk
aGFyQGludGVsLmNvbT4NCj4gQ2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9y
Zy5hdT47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5v
cmc7IGhhbm5lc0BjbXB4Y2hnLm9yZzsNCj4gbnBoYW1jc0BnbWFpbC5jb207IGNoZW5nbWluZy56
aG91QGxpbnV4LmRldjsNCj4gdXNhbWFhcmlmNjQyQGdtYWlsLmNvbTsgcnlhbi5yb2JlcnRzQGFy
bS5jb207IDIxY25iYW9AZ21haWwuY29tOw0KPiBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOyBs
aW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFi
YmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7DQo+IGViaWdnZXJzQGdvb2dsZS5jb207
IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLCBLcmlzdGVuIEMNCj4gPGtyaXN0ZW4uYy5hY2Nh
cmRpQGludGVsLmNvbT47IEZlZ2hhbGksIFdhamRpIEsgPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5j
b20+Ow0KPiBHb3BhbCwgVmlub2RoIDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPg0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIHY1IDAyLzEyXSBjcnlwdG86IGFjb21wIC0gRGVmaW5lIG5ldyBpbnRlcmZh
Y2VzIGZvcg0KPiBjb21wcmVzcy9kZWNvbXByZXNzIGJhdGNoaW5nLg0KPiANCj4gT24gTW9uLCBK
YW4gNiwgMjAyNSBhdCA5OjM34oCvQU0gU3JpZGhhciwgS2FuY2hhbmEgUA0KPiA8a2FuY2hhbmEu
cC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBIaSBIZXJiZXJ0LA0KPiA+DQo+
ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogSGVyYmVydCBYdSA8
aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiA+ID4gU2VudDogU2F0dXJkYXksIERlY2Vt
YmVyIDI4LCAyMDI0IDM6NDYgQU0NCj4gPiA+IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5j
aGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0KPiA+ID4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsNCj4gPiA+IGhhbm5lc0BjbXB4Y2hnLm9yZzsg
eW9zcnlhaG1lZEBnb29nbGUuY29tOyBucGhhbWNzQGdtYWlsLmNvbTsNCj4gPiA+IGNoZW5nbWlu
Zy56aG91QGxpbnV4LmRldjsgdXNhbWFhcmlmNjQyQGdtYWlsLmNvbTsNCj4gPiA+IHJ5YW4ucm9i
ZXJ0c0Bhcm0uY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsgYWtwbUBsaW51eC0NCj4gZm91bmRhdGlv
bi5vcmc7DQo+ID4gPiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxv
ZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOw0KPiA+ID4gYXJkYkBrZXJuZWwub3JnOyBl
YmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwNCj4gPiA+IEty
aXN0ZW4gQyA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0K
PiA+ID4gPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoIDx2aW5vZGgu
Z29wYWxAaW50ZWwuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCB2NSAwMi8xMl0gY3J5
cHRvOiBhY29tcCAtIERlZmluZSBuZXcgaW50ZXJmYWNlcyBmb3INCj4gPiA+IGNvbXByZXNzL2Rl
Y29tcHJlc3MgYmF0Y2hpbmcuDQo+ID4gPg0KPiA+ID4gT24gRnJpLCBEZWMgMjAsIDIwMjQgYXQg
MTA6MzE6MDlQTSAtMDgwMCwgS2FuY2hhbmEgUCBTcmlkaGFyIHdyb3RlOg0KPiA+ID4gPiBUaGlz
IGNvbW1pdCBhZGRzIGdldF9iYXRjaF9zaXplKCksIGJhdGNoX2NvbXByZXNzKCkgYW5kDQo+ID4g
PiBiYXRjaF9kZWNvbXByZXNzKCkNCj4gPiA+ID4gaW50ZXJmYWNlcyB0bzoNCj4gPiA+DQo+ID4g
PiBGaXJzdCBvZiBhbGwgd2UgZG9uJ3QgbmVlZCBhIGJhdGNoIGNvbXByZXNzL2RlY29tcHJlc3Mg
aW50ZXJmYWNlDQo+ID4gPiBiZWNhdXNlIHRoZSB3aG9sZSBwb2ludCBvZiByZXF1ZXN0IGNoYWlu
aW5nIGlzIHRvIHN1cHBseSB0aGUgZGF0YQ0KPiA+ID4gaW4gYmF0Y2hlcy4NCj4gPiA+DQo+ID4g
PiBJJ20gYWxzbyBhZ2FpbnN0IGhhdmluZyBhIGdldF9iYXRjaF9zaXplIGJlY2F1c2UgdGhlIHVz
ZXIgc2hvdWxkDQo+ID4gPiBiZSBzdXBwbHlpbmcgYXMgbXVjaCBkYXRhIGFzIHRoZXkncmUgY29t
Zm9ydGFibGUgd2l0aC4gIEluIG90aGVyDQo+ID4gPiB3b3JkcyBpZiB0aGUgdXNlciBpcyBoYXBw
eSB0byBnaXZlIHVzIDggcmVxdWVzdHMgZm9yIGlhYSB0aGVuIGl0DQo+ID4gPiBzaG91bGQgYmUg
aGFwcHkgdG8gZ2l2ZSB1cyA4IHJlcXVlc3RzIGZvciBldmVyeSBpbXBsZW1lbnRhdGlvbi4NCj4g
PiA+DQo+ID4gPiBUaGUgcmVxdWVzdCBjaGFpbmluZyBpbnRlcmZhY2Ugc2hvdWxkIGJlIHN1Y2gg
dGhhdCBwcm9jZXNzaW5nDQo+ID4gPiA4IHJlcXVlc3RzIGlzIGFsd2F5cyBiZXR0ZXIgdGhhbiBk
b2luZyAxIHJlcXVlc3QgYXQgYSB0aW1lIGFzDQo+ID4gPiB0aGUgY29zdCBpcyBhbW9ydGlzZWQu
DQo+ID4NCj4gPiBUaGFua3MgZm9yIHlvdXIgY29tbWVudHMuIENhbiB5b3UgcGxlYXNlIGVsYWJv
cmF0ZSBvbiBob3cNCj4gPiByZXF1ZXN0IGNoYWluaW5nIHdvdWxkIGVuYWJsZSBjb3N0IGFtb3J0
aXphdGlvbiBmb3Igc29mdHdhcmUNCj4gPiBjb21wcmVzc29ycz8gV2l0aCB0aGUgY3VycmVudCBp
bXBsZW1lbnRhdGlvbiwgYSBtb2R1bGUgbGlrZQ0KPiA+IHpzd2FwIHdvdWxkIG5lZWQgdG8gZG8g
dGhlIGZvbGxvd2luZyB0byBpbnZva2UgcmVxdWVzdCBjaGFpbmluZw0KPiA+IGZvciBzb2Z0d2Fy
ZSBjb21wcmVzc29ycyAoaW4gYWRkaXRpb24gdG8gcHVzaGluZyB0aGUgY2hhaW5pbmcNCj4gPiB0
byB0aGUgdXNlciBsYXllciBmb3IgSUFBLCBhcyBwZXIgeW91ciBzdWdnZXN0aW9uIG9uIG5vdCBu
ZWVkaW5nIGENCj4gPiBiYXRjaCBjb21wcmVzcy9kZWNvbXByZXNzIGludGVyZmFjZSk6DQo+ID4N
Cj4gPiB6c3dhcF9iYXRjaF9jb21wcmVzcygpOg0KPiA+ICAgIGZvciAoaSA9IDA7IGkgPCBucl9w
YWdlc19pbl9iYXRjaDsgKytpKSB7DQo+ID4gICAgICAgLyogc2V0IHVwIHRoZSBhY29tcF9yZXEg
InJlcXNbaV0iLiAqLw0KPiA+ICAgICAgIFsgLi4uIF0NCj4gPiAgICAgICBpZiAoaSkNCj4gPiAg
ICAgICAgIGFjb21wX3JlcXVlc3RfY2hhaW4ocmVxc1tpXSwgcmVxc1swXSk7DQo+ID4gICAgICAg
ZWxzZQ0KPiA+ICAgICAgICAgYWNvbXBfcmVxY2hhaW5faW5pdChyZXFzWzBdLCAwLCBjcnlwdG9f
cmVxX2RvbmUsIGNyeXB0b193YWl0KTsNCj4gPiAgICB9DQo+ID4NCj4gPiAgICAvKiBQcm9jZXNz
IHRoZSByZXF1ZXN0IGNoYWluIGluIHNlcmllcy4gKi8NCj4gPiAgICBlcnIgPSBjcnlwdG9fd2Fp
dF9yZXEoYWNvbXBfZG9fcmVxX2NoYWluKHJlcXNbMF0sDQo+IGNyeXB0b19hY29tcF9jb21wcmVz
cyksIGNyeXB0b193YWl0KTsNCj4gPg0KPiA+IEludGVybmFsbHksIGFjb21wX2RvX3JlcV9jaGFp
bigpIHdvdWxkIHNlcXVlbnRpYWxseSBwcm9jZXNzIHRoZQ0KPiA+IHJlcXVlc3QgY2hhaW4gYnk6
DQo+ID4gMSkgYWRkaW5nIGFsbCByZXF1ZXN0cyB0byBhIGxpc3QgInN0YXRlIg0KPiA+IDIpIGNh
bGwgImNyeXB0b19hY29tcF9jb21wcmVzcygpIiBmb3IgdGhlIG5leHQgbGlzdCBlbGVtZW50DQo+
ID4gMykgd2hlbiB0aGlzIHJlcXVlc3QgY29tcGxldGVzLCBkZXF1ZXVlIGl0IGZyb20gdGhlIGxp
c3QgInN0YXRlIg0KPiA+IDQpIHJlcGVhdCBmb3IgYWxsIHJlcXVlc3RzIGluICJzdGF0ZSINCj4g
PiA1KSBXaGVuIHRoZSBsYXN0IHJlcXVlc3QgaW4gInN0YXRlIiBjb21wbGV0ZXMsIGNhbGwgInJl
cXNbMF0tDQo+ID5iYXNlLmNvbXBsZXRlKCkiLA0KPiA+ICAgICB3aGljaCBub3RpZmllcyBjcnlw
dG9fd2FpdC4NCj4gPg0KPiA+IEZyb20gd2hhdCBJIGNhbiB1bmRlcnN0YW5kLCB0aGUgbGF0ZW5j
eSBjb3N0IHNob3VsZCBiZSB0aGUgc2FtZSBmb3INCj4gPiBwcm9jZXNzaW5nIGEgcmVxdWVzdCBj
aGFpbiBpbiBzZXJpZXMgdnMuIHByb2Nlc3NpbmcgZWFjaCByZXF1ZXN0IGFzIGl0IGlzDQo+ID4g
ZG9uZSB0b2RheSBpbiB6c3dhcCwgYnkgY2FsbGluZzoNCj4gPg0KPiA+ICAgY29tcF9yZXQgPSBj
cnlwdG9fd2FpdF9yZXEoY3J5cHRvX2Fjb21wX2NvbXByZXNzKGFjb21wX2N0eC0NCj4gPnJlcXNb
MF0pLCAmYWNvbXBfY3R4LT53YWl0KTsNCj4gPg0KPiA+IEl0IGlzIG5vdCBjbGVhciB0byBtZSBp
ZiB0aGVyZSBpcyBhIGNvc3QgYW1vcnRpemF0aW9uIGJlbmVmaXQgZm9yIHNvZnR3YXJlDQo+ID4g
Y29tcHJlc3NvcnMuIE9uZSBvZiB0aGUgcmVxdWlyZW1lbnRzIGZyb20gWW9zcnkgd2FzIHRoYXQg
dGhlcmUgc2hvdWxkDQo+ID4gYmUgbm8gY2hhbmdlIGZvciB0aGUgc29mdHdhcmUgY29tcHJlc3Nv
cnMsIHdoaWNoIGlzIHdoYXQgSSBoYXZlDQo+ID4gYXR0ZW1wdGVkIHRvIGRvIGluIHY1Lg0KPiA+
DQo+ID4gQ2FuIHlvdSBwbGVhc2UgaGVscCB1cyB1bmRlcnN0YW5kIGlmIHRoZXJlIGlzIGEgcm9v
bSBmb3Igb3B0aW1pemluZw0KPiA+IHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgc3luY2hyb25v
dXMgImFjb21wX2RvX3JlcV9jaGFpbigpIiBBUEk/DQo+ID4gSSB3b3VsZCBhbHNvIGxpa2UgdG8g
Z2V0IGlucHV0cyBmcm9tIHRoZSB6c3dhcCBtYWludGFpbmVycyBvbiB1c2luZw0KPiA+IHJlcXVl
c3QgY2hhaW5pbmcgZm9yIGEgYmF0Y2hpbmcgaW1wbGVtZW50YXRpb24gZm9yIHNvZnR3YXJlIGNv
bXByZXNzb3JzLg0KPiANCj4gSXMgdGhlcmUgYSBmdW5jdGlvbmFsIGNoYW5nZSBpbiBkb2luZyBz
bywgb3IganVzdCB1c2luZyBkaWZmZXJlbnQNCj4gaW50ZXJmYWNlcyB0byBhY2NvbXBsaXNoIHRo
ZSBzYW1lIHRoaW5nIHdlIGRvIHRvZGF5Pw0KDQpUaGUgY29kZSBwYXRocyBmb3Igc29mdHdhcmUg
Y29tcHJlc3NvcnMgYXJlIGNvbnNpZGVyYWJseSBkaWZmZXJlbnQgYmV0d2Vlbg0KdGhlc2UgdHdv
IHNjZW5hcmlvczoNCg0KMSkgR2l2ZW4gYSBiYXRjaCBvZiA4IHBhZ2VzOiBmb3IgZWFjaCBwYWdl
LCBjYWxsIHpzd2FwX2NvbXByZXNzKCkgdGhhdCBkb2VzIHRoaXM6DQoNCiAgICAJY29tcF9yZXQg
PSBjcnlwdG9fd2FpdF9yZXEoY3J5cHRvX2Fjb21wX2NvbXByZXNzKGFjb21wX2N0eC0+cmVxc1sw
XSksICZhY29tcF9jdHgtPndhaXQpOw0KDQoyKSBHaXZlbiBhIGJhdGNoIG9mIDggcGFnZXM6DQog
ICAgIGEpIENyZWF0ZSBhIHJlcXVlc3QgY2hhaW4gb2YgOCBhY29tcF9yZXFzLCBzdGFydGluZyB3
aXRoIHJlcXNbMF0sIGFzDQogICAgICAgICBkZXNjcmliZWQgZWFybGllci4NCiAgICAgYikgUHJv
Y2VzcyB0aGUgcmVxdWVzdCBjaGFpbiBieSBjYWxsaW5nOg0KDQogICAgICAgICAgICAgIGVyciA9
IGNyeXB0b193YWl0X3JlcShhY29tcF9kb19yZXFfY2hhaW4ocmVxc1swXSwgY3J5cHRvX2Fjb21w
X2NvbXByZXNzKSwgJmFjb21wX2N0eC0+d2FpdCk7DQoJLyogR2V0IGVhY2ggcmVxJ3MgZXJyb3Ig
c3RhdHVzLiAqLw0KCWZvciAoaSA9IDA7IGkgPCBucl9wYWdlczsgKytpKSB7DQoJCWVycm9yc1tp
XSA9IGFjb21wX3JlcXVlc3RfZXJyKHJlcXNbaV0pOw0KCQlpZiAoZXJyb3JzW2ldKSB7DQoJCQlw
cl9kZWJ1ZygiUmVxdWVzdCBjaGFpbmluZyByZXEgJWQgY29tcHJlc3MgZXJyb3IgJWRcbiIsIGks
IGVycm9yc1tpXSk7DQoJCX0gZWxzZSB7DQoJCQlkbGVuc1tpXSA9IHJlcXNbaV0tPmRsZW47DQoJ
CX0NCgl9DQoNCldoYXQgSSBtZWFuIGJ5IGNvbnNpZGVyYWJseSBkaWZmZXJlbnQgY29kZSBwYXRo
cyBpcyB0aGF0IHJlcXVlc3QgY2hhaW5pbmcNCmludGVybmFsbHkgb3ZlcndyaXRlcyB0aGUgcmVx
J3MgYmFzZS5jb21wbGV0ZSBhbmQgYmFzZS5kYXRhIChhZnRlciBzYXZpbmcgdGhlDQpvcmlnaW5h
bCB2YWx1ZXMpIHRvIGltcGxlbWVudCB0aGUgYWxnb3JpdGhtIGRlc2NyaWJlZCBlYXJsaWVyLiBC
YXNpY2FsbHksIHRoZQ0KY2hhaW4gaXMgcHJvY2Vzc2VkIGluIHNlcmllcyBieSBnZXR0aW5nIHRo
ZSBuZXh0IHJlcSBpbiB0aGUgY2hhaW4sIHNldHRpbmcgaXQncw0KY29tcGxldGlvbiBmdW5jdGlv
biB0byAiYWNvbXBfcmVxY2hhaW5fZG9uZSgpIiwgd2hpY2ggZ2V0cyBjYWxsZWQgd2hlbg0KdGhl
ICJvcCIgKGNyeXB0b19hY29tcF9jb21wcmVzcygpKSBpcyBjb21wbGV0ZWQgZm9yIHRoYXQgcmVx
Lg0KYWNvbXBfcmVxY2hhaW5fZG9uZSgpIHdpbGwgY2F1c2UgdGhlIG5leHQgcmVxIHRvIGJlIHBy
b2Nlc3NlZCBpbiB0aGUNCnNhbWUgbWFubmVyLiBJZiB0aGlzIG5leHQgcmVxIGhhcHBlbnMgdG8g
YmUgdGhlIGxhc3QgcmVxIHRvIGJlIHByb2Nlc3NlZCwNCml0IHdpbGwgbm90aWZ5IHRoZSBvcmln
aW5hbCBjb21wbGV0aW9uIGZ1bmN0aW9uIG9mIHJlcXNbMF0sIHdpdGggdGhlIGNyeXB0b193YWl0
DQp0aGF0IHpzd2FwIHNldHMgdXAgaW4genN3YXBfY3B1X2NvbXBfcHJlcGFyZSgpOg0KDQoJYWNv
bXBfcmVxdWVzdF9zZXRfY2FsbGJhY2soYWNvbXBfY3R4LT5yZXFzWzBdLCBDUllQVE9fVEZNX1JF
UV9NQVlfQkFDS0xPRywNCgkJCQkgICBjcnlwdG9fcmVxX2RvbmUsICZhY29tcF9jdHgtPndhaXQp
Ow0KDQpQYXRjaCBbMV0gaW4gdjUgb2YgdGhpcyBzZXJpZXMgaGFzIHRoZSBmdWxsIGltcGxlbWVu
dGF0aW9uIG9mIGFjb21wX2RvX3JlcV9jaGFpbigpDQppbiBjYXNlIHlvdSB3YW50IHRvIHVuZGVy
c3RhbmQgdGhpcyBpbiBtb3JlIGRldGFpbC4NCg0KVGhlICJmdW5jdGlvbmFsIGNoYW5nZSIgd3J0
IHJlcXVlc3QgY2hhaW5pbmcgaXMgbGltaXRlZCB0byB0aGUgYWJvdmUuDQoNClsxXTogaHR0cHM6
Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LW1tL3BhdGNoLzIwMjQxMjIxMDYz
MTE5LjI5MTQwLTIta2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbS8NCg0KVGhhbmtzLA0KS2Fu
Y2hhbmENCg0K
