Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5300B1F542C;
	Wed,  4 Dec 2024 22:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352565; cv=fail; b=OdMt5q69Bj/lEV5LqJRW/QsGaWq7y8jTlzNUBfKu8HBKm2xR3YEZ5WwtXi9LsWp4IURZu6B0hRjuAixO8hqOJOTZE12d9QAXl/2JTGABFVjiaSfm7w0LaDbgwbm6O2rfq3ltEoya4J9YQ65obJipeETU+JaEdfDud1s7Qa9DWsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352565; c=relaxed/simple;
	bh=9ilkxI0O4CTo3iDkQj3mkBQibAvVnU5UUwm0DWhu/jg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qe6DGRKn4fSQURPA60mVHYufpC3ySlHLic5VZLPQcTKo9nFoa0Pz84WxwhzxJOSw4heM0Gi/VAt6RP0ck6Wit3Bk1dHjPIRyLubHJaXHT2+2xYEpkRHeIsq56K9cPXUNiZye9FNOr3bPtSwaoMagzx/09vRfgK5/dxACdQlZF6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DcZURY0i; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DcZURY0i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733352563; x=1764888563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9ilkxI0O4CTo3iDkQj3mkBQibAvVnU5UUwm0DWhu/jg=;
  b=DcZURY0imwsmC3LvatH+zJjqvNQ8Hl8WORRI92Bv6Ss+2mKviPbwpi8n
   uM7u3Dl2wwRRAK7++aZnZRD9O5BW5wZ+P9lf7qcgiTFmMeRq1lF5w4uVh
   xhaau+/0UEPuy0tn8fKqvVp98s51kQpid02dEp/LjI/I5LfCqD+2xUMg7
   ggMunIW0r9FvKWA5XZ8n8w1LORuORpq/v5UESA2uQD2pqTt6EJgJmNU9A
   Vu03RBez1fTwjb7d4/Eq2kxBzF4/0U/0ySZ5QMc3NUgbHNfwAv3NAbJIL
   slNBokts5CItSHDGgMDj8K3wyyxKii8eQdKg1eMG3SlEwZhAMkn9I3RdB
   A==;
X-CSE-ConnectionGUID: gCtfI8qeQRSpwbZBWJpdNg==
X-CSE-MsgGUID: ieT9mHjVSneE0FZB2wT2Ag==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="33704144"
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="33704144"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 14:49:21 -0800
X-CSE-ConnectionGUID: G4h2yOhBTF2FCeaL7E6t+Q==
X-CSE-MsgGUID: uYRkW915Rcm9hTtSz+RVIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="93801204"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2024 14:49:20 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Dec 2024 14:49:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Dec 2024 14:49:19 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Dec 2024 14:49:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sfcvjhEmxcwN58klT97q6zmvwiFX5hrqhOjvdeOO0HgWXd8q3ywP4NeoahLmeL+B/vmz8uLgX79cc+fSB/ciJ/lnC5K/tFHYsAFt6G2HWS0JPvzSUJX6e9Uw7ZV+4fq4yRcSJ1ZPlrxWsTidwdA7186/ojmndXpgUtbo/XRDvHZyphujgDTT3aKxfxK93TZVKiAI9i32sr5uD/RsVuwPo9pti4FXpo76Vv7QPxnLvOKqnWwctPsvmkr9yGwJ5DnI72flcjVVR5QWl4e7VynlOzFWy2MDPzz34vKFtWkwVim06po3IgRCCPMPAYgrCJVUgNlmmfjY7Qiy7kS9mU1meg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ilkxI0O4CTo3iDkQj3mkBQibAvVnU5UUwm0DWhu/jg=;
 b=oSV6RVhoM5lCIkuON+OVYeQ/cLx2b/rEWmu70NHm09+g8c00ayLRDWoTokzjKYJKVr45RmrqDoBuVsDCviTP1hr8RGj1NStM98cWf61x0JqOjorYPHoHiEBOjV3oht8x+GC0rXu3K271BrWWOiLsANDu9MUX0SvOpXZStRupXR4fifkwJNaNx5y9JpiPeSkajCooTjnH2GF7iXOMEatn0EaCL3smtcdx6f7P32+M3E3WG3P3fzAiQLk/77/axS6TXFg4AehwLpvXgGA7QwSjhL0Mo0j28hGiJRHvi7qk1bDnI+Zw2F8c/y1SOjmXp4DjAJ1+JubMajbLqGhtLofTnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by CO1PR11MB5121.namprd11.prod.outlook.com (2603:10b6:303:98::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 22:49:17 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 22:49:16 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Nhat Pham <nphamcs@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@intel.com" <ying.huang@intel.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Topic: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Index: AQHbPXWU4Gc6KD17CkKDJ7pv5ZtEYLLTYjKAgABKBaCAAIvAgIAA4a2QgAAEXQCAAEKGAIABXj8AgAABMeA=
Date: Wed, 4 Dec 2024 22:49:16 +0000
Message-ID: <SJ0PR11MB5678F2E6E78A2B74D2F6AB8AC9372@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z066p53LoISwqkmX@gondor.apana.org.au>
 <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>
 <Z0-zboLmrybOt8pv@gondor.apana.org.au>
 <CAJD7tkaJwti5vwUXP=T9MW4XXHmen+SCQXv=hWWN+-V3SJJSVA@mail.gmail.com>
In-Reply-To: <CAJD7tkaJwti5vwUXP=T9MW4XXHmen+SCQXv=hWWN+-V3SJJSVA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|CO1PR11MB5121:EE_
x-ms-office365-filtering-correlation-id: 641e73e6-b170-404c-2858-08dd14b5e1d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VlF3Sll4aHE1Z3k5QVRyNTFhRXliaTgxWW4xQXFnWU1aMjVva2l1TW5oVUZy?=
 =?utf-8?B?ZHZzdWs3U3dmM1JLRnJoNGN5RkFIbHpvdG1vTkZwV09zQjhSOHU2OUtTVnJY?=
 =?utf-8?B?TTdjY01Id3Rwc2NWVGNQTGFwSzdiQmxJVnVscU1PaUkvNkVhOE8zSzNjSytM?=
 =?utf-8?B?ZXgwb2toNzR0dE8yMGNadmp4cTNpcHFibEQrUDFObkFaY2I2Yk9YVml3VnYy?=
 =?utf-8?B?dmt5ajU0aFNpbW0wQXQ0dmxsNGRGT1BCV3A5Y0lPSXd4YjZyM1RIU3E5eXBE?=
 =?utf-8?B?ZXF0ZTdFRllIVElSSlpYMll2Z2dlRUNPNEoydFdUNFFnZXR4bDVRWEduMHlw?=
 =?utf-8?B?c2FkRERVb1lpNlpBQmFjb1FnSHF5c0I4ZVRGK0d0RTF3cUJxeHg1WWZJYndR?=
 =?utf-8?B?ck1kUzNCbGo2UUQzdDF0TDkwSmw0V0M3T3BXTzFpOXVXOTBmblpzZUJaZEdz?=
 =?utf-8?B?YTF5MktROTlEd0JCcy82TjBaMTBENjJsSHQzSEZWcmNYNUI1R0xCZVZ1MU5w?=
 =?utf-8?B?eDBUZGhCWlN5Ympxb0ZDa1VrM0tuY2FiNUh1eGw1V00wUHBtQlJSamk2Y0Np?=
 =?utf-8?B?akRrRW9qZXptSTYzaHhRdlpaSlVqaG9YTkUwWDI3blVHanZRcGtRcFlFdHRj?=
 =?utf-8?B?QzArQWdnOEo1emJmbzRXdFhSdTlKWUFUMkFZUHU5WWpLVzhlYjFpbVNXTkM4?=
 =?utf-8?B?NTVSUjc2RlhQSnZrdXA5RldOWUR1a29TSFRJb29tZmwyUkw4cGdIT2MxN1NS?=
 =?utf-8?B?bTg0VDlsQkpuQk43YVlXL0VIeUh0eUtlb1o1WXNYL0d4b1RCVzQ0cnl2bUJR?=
 =?utf-8?B?a3RRT2FIRkp2Vi95ZFAwQWNiUTlaVi9kMGt6M3phQytHT0EwdGRTandtVzd4?=
 =?utf-8?B?dHpBSmpmT0VvVytmZmtFTDlacmZGenlRUDlOSWFFSURvS0VFL09XbVViYmll?=
 =?utf-8?B?SGtFWFZZREdrM2REV0w0WlIwRFBUZnNLMGtCa0hGMTk4aFdpSjZYR2V1RjJC?=
 =?utf-8?B?clVOMXJ2Q1RjbkVSK0hpR1l1N1h2TUNRRU05dlpCRW5qNldaVEpQMktxTjhJ?=
 =?utf-8?B?YThESHhmVVowb1d3QlNEV2d5R2VBMXRjdGNOL3BvRHowZ00xNUZrQmlKQ1dI?=
 =?utf-8?B?cEtrZGcyYWRqd0JibXZoditUckVQOXpudHNDQTBJVkEyYmxHNFUrVS9FUDNF?=
 =?utf-8?B?ZjZtd0VLb0JNWjBza2xyaXI0eE04enhUYm9YYTRFNnA0ZzhzeVRyQjhwekxK?=
 =?utf-8?B?alRIaHZYa1NVL1ZlT0p3d0FBLzZYVm0zU25hWkhKWHV2VVRnRmtPeThnVHpW?=
 =?utf-8?B?ZjBqUkNhSUcrQnVhSC9RTU83RnVvUkNPS1hkc1dFQWN0TDBIb3V1Y3haaGJL?=
 =?utf-8?B?VDE4U3p2MHhYbHMrYkd2UDJVeFEyM0x5Nk1NRVc1R2VLZmdTSjc4Y3F3eXYv?=
 =?utf-8?B?KzRkVVJQbmdrOWtpUTVNVDRzM0RBcXlpNXZMcVRlQ0NObmo0L0dOQW9nOG1B?=
 =?utf-8?B?ZnQ4ZDNFTEl2TkFXT2h2U25kSVVWdFRZNG5ubG1ObU9aaXlFbHJod1pKQmx4?=
 =?utf-8?B?WmhOQmFmYTBDSjhTNW5zTDQ4b0ptNDhvdFhvRGQvQVVCaWR6bGxvLzNVYUVN?=
 =?utf-8?B?YnhmaXdpem4xVHVFZDJwRStOVjdETVl4cHhwMUtuK2M0MDljMXRyNkg1RnNa?=
 =?utf-8?B?Um1sS1pnaGNmbzI0UHBxRXU2Nng2YXdKNW9kK3dDSjZ0dGNGcVJNZTR2enI4?=
 =?utf-8?B?SHhqUU42Um8wK1o4L3BKMXdYRkRHcHUwZjBFLzgxT3dJUUtkdnFDbnA0dVhF?=
 =?utf-8?B?OXJGcDIyZVoxRnBSdmQ5cmtIZElsK2FqaGZkSTFETlE4VWRueGVBcDgwTWU2?=
 =?utf-8?B?V3JZV3dNZTQ0V0dvTWRIQWJlNFp5M0FDa0JnQmUwMzBhS3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjFIbnNNbTJXWW5HNnh6VTBmVVBNdStmeWRvTzBScWxYKzh0K2JzZExJeFJn?=
 =?utf-8?B?cEx1NEg3dnhtSkx2ZXRndWlZVWdJN2l2Mmw5SGw3QVhkanRJY0hJdHduZ2Ez?=
 =?utf-8?B?U09wZi9YWDRUWndxRmQ1QSsybkNuamNCTTFyUFlnTVBYb1BqU0ZaNXV6c0lC?=
 =?utf-8?B?bW5SNzhqOVRzYkhpcVh2REkvRFUxaVZZbEFvQUMwV0ZyUjdNbWsrbUNRdjJU?=
 =?utf-8?B?RDI5REFCa2ZsbXR2ZjczMHAvYklnY2pOZ2VyOHVqdDc4UFZpa1dNQ2Y0eFRt?=
 =?utf-8?B?Ykt1T2pLYVBIeGdWOXlzSkxEM2RwWUo4aE5PMFVGTnRFZXE0dld1ekxHdGdx?=
 =?utf-8?B?aWNmYjVQaDYyZUk4eVpiWTVNUXpZVkNqc1huRDBvUjNpeWE2SzUvelFWcEtX?=
 =?utf-8?B?djVrVm1Fc0Vhb2ZjZmU5Y1VmUzFURzlwem82cmRvcHBsenZlaHNhV3Z2QVJ2?=
 =?utf-8?B?MC85Vko1UFhyWTRWOWEwV1lLQnBVVnplKzdrakZDZGM1ZmRtZmlmcXFCRHln?=
 =?utf-8?B?NDFIbXJVcTIxN01NQ0VRTGNSZXhHQkdoWW9xd2lBTFA1Zjl2OFB3YmtpaW05?=
 =?utf-8?B?QS9CaE0xMTI3NEpEUmQ4cFZkOXE2YmpiWjJPWmVrai9mS29TN01zcHFBVnlm?=
 =?utf-8?B?TG1ocE9zTWdoQktSTXZtS3NrR2JOOFREWHdwaUhsSnJDUWVia0FYYXpycEFG?=
 =?utf-8?B?WDNWbmpSem9RbzRUSnpuZnFocjN5ajBmVGM1SzM3UWRsUDhvSkNKa0lmektQ?=
 =?utf-8?B?ZjVZMW1DQU0rKzlmSzB6MVJQcjgrTHZnTS9lNlVsdGN4ZUZaVSt5SVpNSm9n?=
 =?utf-8?B?dXl2QkUzcFkvNXoyaGRuZXFQMHIrUFFjYzEraUduU3RPTHNIWG5CaWFoSEx3?=
 =?utf-8?B?VHF4ZjdaeDRQZGoyZ0dYZlhUbXNIS2c1VDFaeCtRTHRYWFlHeU91bVQyc1pF?=
 =?utf-8?B?ay9JMkc2bGs4ajNRSWJMdFVGL2xHRklzeWo1Q0JWbG50NDhkVy9MdEd2aUtm?=
 =?utf-8?B?SThrZ3M5T2M3cEIvNHhFMk1mQ1R0UjVqY0NEemZMaFZEZXpBczJLL1ZZVlZi?=
 =?utf-8?B?QmhwM29Ecnd3U2NRaklLV09xUCtqZVptaEtEdy85dm4xWitETlVVWTBGNDg1?=
 =?utf-8?B?aTlRNkswVzkzWmg3ZDBPZ1BUYnVsNDJZc0hCbWlZNXBPSElROXZiSXM0MUhv?=
 =?utf-8?B?V2FadkI3RmtSVFRvYmRJVFdxYmpqam1HK1l3bHBlcEJoVE1qbDNmYzJMUS9G?=
 =?utf-8?B?KzdLc1JmWFF0MEhjODkrQnUvRDNjRVFHWXpzcDZUQXBjRmVFL3A3ZlF0d21B?=
 =?utf-8?B?U1JmTVJlVkJQU1VLY3ZJZFdxSW1pZFM0VGpSTkJXT281WEdWV0RpNTczZnN5?=
 =?utf-8?B?WTk1czJuR2R3emFTeE1MM3B3S004Z3lZc1NXbzVrbVlvcU9LVjNNcS9oWlNh?=
 =?utf-8?B?TDdKN2NIMmhHak5taFZ1Y3QrZWFpZFBJRTRHYms3dlltTHFhQVpLRUdFSmhX?=
 =?utf-8?B?MmJBWG9CRkxEZFZrVWFqQVdvb1ZtZW82bnJwQnBFQ24vcnZFekg4Nis1Rzdo?=
 =?utf-8?B?cFNVSHgwMmVYbjVlenQzN1FablZLc2dwL3F3TjFGZnRNTWNxUFNEMVpGdVNr?=
 =?utf-8?B?R2tZUGg4YXN4a3FwODBsOXZwdWViSEVjY05rOTJmOG1qYVcxRTBLL1lLRzAz?=
 =?utf-8?B?M3dPc3h2VFVxQnhpcEZNdEJHTVZYZytnTVRLeWp1NDUwdEp2K05uc256WDBE?=
 =?utf-8?B?ZU85cHhlTjlMZmhQNDZRY1lGOWExNGhPMXVMU2l4ZklaZ3JsdDBzdUVYRHdI?=
 =?utf-8?B?Ly9kTU5UcjRxckdNc3VnTU40bnRTcDQwR05CV2sxZHFsWmFZU1lObkdrWmNR?=
 =?utf-8?B?QTJ0ZDBuTmZrdjVKdHoxVVJZT2x0aVcyL1c4TXhuSTZxWE5ML1ZBbGhESDlQ?=
 =?utf-8?B?NlNXeHk0N1RsYmZxUDRRVzg4ajJhNU5MMXY2TXBsVXZ1aTd2dk00cUFEN0tu?=
 =?utf-8?B?amlxRFdjUVVTT2hmRkpCZEdlMm85SWNYYThZQWR1djVya2U0Sk93WDU1Z0cr?=
 =?utf-8?B?eXE3MDNLek10b3VuR21tbU1DbWxackJSS1UwdWF6MUpPV2NRUEpDZmVTdExl?=
 =?utf-8?B?ZnphbWNsbjJrWTJIUmo4ZE9qdU1DbEhOYll3UEFkSm84ZGxKTE9VMllONlh2?=
 =?utf-8?B?UlE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 641e73e6-b170-404c-2858-08dd14b5e1d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 22:49:16.6513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCZpMzIEU6NjOSL9UTmJcrqX6MjhgLMQh+VAGdAc0IcOtRHJTgXV5JG2FV1p+POCUkp3IAo2HrmxAyoqs9SqP1gIQ8CPltOe33Hs+dZyRqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5121
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eWFobWVkQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgNCwgMjAyNCAy
OjM2IFBNDQo+IFRvOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+
IENjOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPjsg
TmhhdCBQaGFtDQo+IDxucGhhbWNzQGdtYWlsLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsNCj4gaGFubmVzQGNtcHhjaGcub3JnOyBjaGVuZ21p
bmcuemhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207IHJ5YW4ucm9iZXJ0
c0Bhcm0uY29tOyB5aW5nLmh1YW5nQGludGVsLmNvbTsNCj4gMjFjbmJhb0BnbWFpbC5jb207IGFr
cG1AbGludXgtZm91bmRhdGlvbi5vcmc7IGxpbnV4LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3Jn
OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOw0KPiBhcmRiQGtlcm5l
bC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLA0K
PiBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47IEZlZ2hhbGksIFdhamRp
IEsNCj4gPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoIDx2aW5vZGgu
Z29wYWxAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDA5LzEwXSBtbTogenN3
YXA6IEFsbG9jYXRlIHBvb2wgYmF0Y2hpbmcgcmVzb3VyY2VzIGlmDQo+IHRoZSBjcnlwdG9fYWxn
IHN1cHBvcnRzIGJhdGNoaW5nLg0KPiANCj4gT24gVHVlLCBEZWMgMywgMjAyNCBhdCA1OjQy4oCv
UE0gSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiB3cm90ZToNCj4g
Pg0KPiA+IE9uIFR1ZSwgRGVjIDAzLCAyMDI0IGF0IDAxOjQ0OjAwUE0gLTA4MDAsIFlvc3J5IEFo
bWVkIHdyb3RlOg0KPiA+ID4NCj4gPiA+IERvZXMgdGhpcyBtZWFuIHRoYXQgaW5zdGVhZCBvZiB6
c3dhcCBicmVha2luZyBkb3duIHRoZSBmb2xpbyBpbnRvDQo+ID4gPiBTV0FQX0NSWVBUT19CQVRD
SF9TSVpFIC1zaXplZCBiYXRjaGVzLCB3ZSBwYXNzIGFsbCB0aGUgcGFnZXMgdG8gdGhlDQo+ID4g
PiBjcnlwdG8gbGF5ZXIgYW5kIGxldCBpdCBkbyB0aGUgYmF0Y2hpbmcgYXMgaXQgcGxlYXNlcz8N
Cj4gPg0KPiA+IFlvdSBwcm92aWRlIGFzIG11Y2ggKG9yIGxpdHRsZSkgYXMgeW91J3JlIGNvbWZv
cnRhYmxlIHdpdGguICBKdXN0DQo+ID4gdHJlYXQgdGhlIGFjb21wIEFQSSBhcyBvbmUgdGhhdCBj
YW4gdGFrZSBhcyBtdWNoIGFzIHlvdSB3YW50IHRvDQo+ID4gZ2l2ZSBpdC4NCj4gDQo+IEluIHRo
aXMgY2FzZSwgaXQgc2VlbXMgbGlrZSB0aGUgYmF0Y2ggc2l6ZSBpcyBjb21wbGV0ZWx5IHVwIHRv
IHpzd2FwLA0KPiBhbmQgbm90IG5lY2Vzc2FyaWx5IGRlcGVuZGVudCBvbiB0aGUgY29tcHJlc3Nv
ci4gVGhhdCBiZWluZyBzYWlkLA0KPiBJbnRlbCBJQUEgd2lsbCBuYXR1cmFsbHkgcHJlZmVyIGEg
YmF0Y2ggc2l6ZSB0aGF0IG1heGltaXplcyB0aGUNCj4gcGFyYWxsZWxpemF0aW9uLg0KPiANCj4g
SG93IGFib3V0IHRoaXMsIHdlIGNhbiBkZWZpbmUgYSBmaXhlZCBtYXggYmF0Y2ggc2l6ZSBpbiB6
c3dhcCwgdG8NCj4gcHJvdmlkZSBhIGhhcmQgbGltaXQgb24gdGhlIG51bWJlciBvZiBidWZmZXJz
IHdlIHByZWFsbG9jYXRlIChlLmcuDQo+IE1BWF9CQVRDSF9TSVpFKS4gVGhlIGNvbXByZXNzb3Jz
IGNhbiBwcm92aWRlIHpzd2FwIGEgaGludCB3aXRoIHRoZWlyDQo+IGRlc2lyZWQgYmF0Y2ggc2l6
ZSAoZS5nLiA4IGZvciBJbnRlbCBJQUEpLiBUaGVuIHpzd2FwIGNhbiBhbGxvY2F0ZQ0KPiBtaW4o
TUFYX0JBVENIX1NJWkUsIGNvbXByZXNzb3JfYmF0Y2hfc2l6ZSkuDQo+IA0KPiBBc3N1bWluZyBz
b2Z0d2FyZSBjb21wcmVzc29ycyBwcm92aWRlIDEgZm9yIHRoZSBiYXRjaCBzaXplLCBpZg0KPiBN
QVhfQkFUQ0hfU0laRSBpcyA+PSA4LCBJbnRlbCBJQUEgZ2V0cyB0aGUgYmF0Y2hpbmcgcmF0ZSBp
dCB3YW50cywgYW5kDQo+IHNvZnR3YXJlIGNvbXByZXNzb3JzIGdldCB0aGUgc2FtZSBiZWhhdmlv
ciBhcyB0b2RheS4gVGhpcyBhYnN0cmFjdHMNCj4gdGhlIGJhdGNoIHNpemUgbmVlZGVkIGJ5IHRo
ZSBjb21wcmVzc29yIHdoaWxlIG1ha2luZyBzdXJlIHpzd2FwIGRvZXMNCj4gbm90IHByZWFsbG9j
YXRlIGEgcmlkaWN1bG91cyBhbW91bnQgb2YgbWVtb3J5Lg0KPiANCj4gRG9lcyB0aGlzIG1ha2Ug
c2Vuc2UgdG8gZXZlcnlvbmUgb3IgYW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCg0KVGhhbmtzIFlv
c3J5LCB0aGlzIG1ha2VzIHBlcmZlY3Qgc2Vuc2UuIEkgY2FuIGRlY2xhcmUgYSBkZWZhdWx0DQpD
UllQVE9fQUNPTVBfQkFUQ0hfU0laRT0xLCBhbmQgYSBjcnlwdG8gQVBJIHRoYXQgenN3YXAgY2Fu
DQpxdWVyeSwgYWNvbXBfZ2V0X2JhdGNoX3NpemUoc3RydWN0IGNyeXB0b19hY29tcCAqdGZtKSB0
aGF0DQpjYW4gY2FsbCBhIGNyeXB0byBhbGdvcml0aG0gaW50ZXJmYWNlIGlmIGl0IGlzIHJlZ2lz
dGVyZWQsIGZvciBlLmcuDQpjcnlwdG9fZ2V0X2JhdGNoX3NpemUoKSB0aGF0IElBQSBjYW4gcmVn
aXN0ZXIgdG8gcmV0dXJuIHRoZSBtYXgNCmJhdGNoIHNpemUgZm9yIElBQS4gSWYgYSBjb21wcmVz
c29yIGRvZXMgbm90IHByb3ZpZGUgYW4NCmltcGxlbWVudGF0aW9uIGZvciBjcnlwdG9fZ2V0X2Jh
dGNoX3NpemUoKSwgd2Ugd291bGQgcmV0dXJuDQpDUllQVE9fQUNPTVBfQkFUQ0hfU0laRS4gVGhp
cyB3YXksIG5vdGhpbmcgc3BlY2lmaWMgd2lsbA0KbmVlZCB0byBiZSBkb25lIGZvciB0aGUgc29m
dHdhcmUgY29tcHJlc3NvcnMgZm9yIG5vdy4gVW5sZXNzDQp0aGV5IGRlZmluZSBhIHNwZWNpZmlj
IGJhdGNoX3NpemUgdmlhIHNheSwgYW5vdGhlciBpbnRlcmZhY2UsDQpjcnlwdG9fc2V0X2JhdGNo
X3NpemUoKSwgdGhlIGFjb21wX2dldF9iYXRjaF9zaXplKCkgd2lsbCByZXR1cm4gMS4NCg0KVGhh
bmtzLA0KS2FuY2hhbmENCg==
