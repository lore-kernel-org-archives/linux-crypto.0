Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55A01917D7;
	Wed,  4 Dec 2024 23:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733353975; cv=fail; b=AcmmNiqNDG/qmZRiP3t4KJTRb/l2LxIMLongsgYYDwa0vZ4U8aNMTezJ7RpjvcUi2QonYSs0Ef5yb6GxoQ1ZH2IyjR6wqDFM083eRG40pJTkNsiMTXL6kWB0XSAnMAOhSlRluRboMMUGqALmGyX6dpBwJTLVa95TWFuwNFbktIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733353975; c=relaxed/simple;
	bh=jOyv4ae4113tbzxbWUpmAJH0K5UiGWTaupAdYUHyGkc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mYmI7J5GJXEk3LfcL0mMio6Ag7fxBVUMJyCcNoauOrM/ZjrachLJhDRBVm8YRUIpEM0wnJiFX0RXv8BCqafDHbRfXsRWMaxHeDuscXSm5ZVoTLPD1quc2UzL8DEMuxDjDU2mLKbtsopqNxy1fU6oyOgXetLFnu54Ck3NN7KkZoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQJkdsMT; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQJkdsMT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733353974; x=1764889974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jOyv4ae4113tbzxbWUpmAJH0K5UiGWTaupAdYUHyGkc=;
  b=kQJkdsMTqLKWfginKrj1G5eAiRznCojHs0sTbhiI/E1sCxHhgdqR3zEx
   I8qgwquguBncioK13iTy/HHyEWe9b6U1H8bftUhCFimmLo7VTtVO7HnnB
   w24Eg1P+M1d8HuIc+blADUoOsLUlLtVNm2laaqjr1xtZ8/kslqv/3S0bc
   MSHa5SyFF0b17gjAy46EywZhtWZJiBuDErtO9rFpZs2KadBPLwIUtRYSX
   7ynQ67tbKktm47UzoPbKCknDL+0FZUq786Gvo7LfJQTWvVTRtId9ch0zZ
   BHHdmG2UrlT4vipWmnGBFHYNGTuQH4+QdgROxJJw0X9sGZ8OOzYspbq5g
   w==;
X-CSE-ConnectionGUID: e8nE0mfzSJ+ItWSyBA4eSw==
X-CSE-MsgGUID: PLoDBZ53RX+00nnlpIbgzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="36488177"
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="36488177"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 15:12:53 -0800
X-CSE-ConnectionGUID: k8ZAMTHCRn29HOINaxgkug==
X-CSE-MsgGUID: +pinsvyOSKab3NPq/4evZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="97967906"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2024 15:12:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Dec 2024 15:12:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Dec 2024 15:12:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Dec 2024 15:12:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gfN0BwAE8qt1n75pkkyd5lPD7SDMb/DDPh1WGdcaI27Pk/K/s76OqaZ3Jqg4LhLWvCgwc7juJjmYdiT/PX0oUKVg3Wn7EW6eHOM5k5XgdMVUe2riQt4p4MuSvkfBnOtHZq2mgwnVEkRnWp5nYzsZL8kulDGfqLFbPy1egZqU1R5Lir1U5Xi6/4rix75fy4NjwKmBd2uiqWMQmtFE5LbPRbWqvahQGbFwKNifBSY66duZIj8PZZIRhTHX3v2NPOn6hPtEBbI35FykrCPooFdzRFCyQ10nAn+ifgybpSJW70ZollWBWHJdmG29FkF5ZzmWHi2q0PtIUzIRwKxRYbWWBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOyv4ae4113tbzxbWUpmAJH0K5UiGWTaupAdYUHyGkc=;
 b=ghb2aab+uoATU1eOoTt3Nw2BJqhTDoPHQvY7ma1eNmADhO18gbL7WvL8EsA1EPduB8qDAppqRJB5EIrOvDgyHL/URfwrveK5u0VHYlXKbPM8nIxC3wicICCZr83aUh+HSXSGs9/9Hx9MppqkiXM+8ckVevb/JSsSHaTVgU8dA5W7IxXIXtM+WqJ3BXz574dFyClv/N1PzqHFCQyf7lrtzljB/XWfskozLDcmiZ+OQcKKIU5nUYbytpZQ85G/1iuSas3JyQvLtIPa9uU1MHI3EjiUQ8xnrBbfyNYSgafY2upxB8sSs2Z0lr6jmOEj1T0/sg7JOEIkU6x/uFnNE/KzCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by SJ2PR11MB7618.namprd11.prod.outlook.com (2603:10b6:a03:4cc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Wed, 4 Dec
 2024 23:12:45 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 23:12:45 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "ying.huang@intel.com" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Topic: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Index: AQHbPXWU4Gc6KD17CkKDJ7pv5ZtEYLLTYjKAgABKBaCAAIvAgIAA4a2QgAAEXQCAAEKGAIABXj8AgAABMeCAAAQ5gIAABDag
Date: Wed, 4 Dec 2024 23:12:45 +0000
Message-ID: <SJ0PR11MB56780FE68BA4F639C1261B13C9372@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z066p53LoISwqkmX@gondor.apana.org.au>
 <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>
 <Z0-zboLmrybOt8pv@gondor.apana.org.au>
 <CAJD7tkaJwti5vwUXP=T9MW4XXHmen+SCQXv=hWWN+-V3SJJSVA@mail.gmail.com>
 <SJ0PR11MB5678F2E6E78A2B74D2F6AB8AC9372@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbgaV-KjvAyLs5LXa95qb4f93QY4FxCzt7r-Juccq4z_Q@mail.gmail.com>
In-Reply-To: <CAJD7tkbgaV-KjvAyLs5LXa95qb4f93QY4FxCzt7r-Juccq4z_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|SJ2PR11MB7618:EE_
x-ms-office365-filtering-correlation-id: 8ffbb68e-ec28-4653-b12f-08dd14b929a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?amJwRkJJSHIvZUcwZmhxN00vZEllZDdjbGxrN2djNjFSbm82UHlJSEptam83?=
 =?utf-8?B?Q1NrVHd1Skh2NmlFZHBxQ3RFMFgvbk5PNE52ejFiaDlpOFdmb29yaUh3Rm5h?=
 =?utf-8?B?RzZwUTA3M3lKMzkxOWVUSWZxMXVDcWlOMTdINmZxUy9ITVVXU2xDVEl6SGpQ?=
 =?utf-8?B?MkQyZnZmZHIwRTgzWGRxaEl1NEZicXpFVHFMTUhia1hpYmhBbUhZMDFuN2xx?=
 =?utf-8?B?RUQzdklKMnE4UGtjcGZzS05zSnpEWTZ2b0paMXNkN2Yvc3Zab2lUT2dXdEtV?=
 =?utf-8?B?RElzZEpvSHg0RXk1VlcvUEhkbW55QzJ4RFlFYzBZVWxMWEhWZjFtZnppTEFC?=
 =?utf-8?B?ajdzWk45cVVJaC9nTHpWam5pZGdYaTV1dlZvaXFBRERrcXV3MjJ2eVd0aGQ0?=
 =?utf-8?B?ZnZ5czlpSjltZklXREd0dVZwMmFyU29zMTFsZTZPaVB5N3lOUFpVYWdDdFBF?=
 =?utf-8?B?OURJUGlPcUVaNlNZTnhHVEhETjdudGwwbHFTKzlBSitrWk1ibUdUbkhlSlpU?=
 =?utf-8?B?aFVMdmY2eHpSTlpLbHFHRFY0cEFmMWwza3N6anRvVGMyNUhxZW9ML1ZuV3Rj?=
 =?utf-8?B?LzQ4VUlwSkp6Z25IczBGT3pYUVB4WkJabmdnK3pXR1Q1a041Y0x6dWx0NGFa?=
 =?utf-8?B?NnEvbVBCMEx3clhsWjk5YVJHaVc1UkZlOHZkRWE0ajN1RE8rVXhxb0JNbC9P?=
 =?utf-8?B?MG5yZ25IREJtbFJsSkNCZ28vUjlIdURPbHQwbjVuM0hBSW0xTkkySnhnUW13?=
 =?utf-8?B?aTRtUnYxN0lzYWJsVkVzYnBOWGRZSklTYXFQKzN2TW04L3FkR0ROM0pPWHVG?=
 =?utf-8?B?K2RwRUJ6M0xSWHNJM29aOVBmYmFwZWFSMXpURGE4dGtDN0VkRFEyRWs0amlp?=
 =?utf-8?B?VlFtMWl5ZGVxRlBpUGZwS1VscHlQZ2xDVVV2K0pLaHFzZERaKzlIZkJQMXhG?=
 =?utf-8?B?ek1DOWUrOW84dWFyZXlQMW1qRkt4MitDNDZaT3haOUx3Q3Z2eStPNW15OWJU?=
 =?utf-8?B?UjArenVsWlV2anhYaEdnQU9HMVNPdjEvT09UZk5UaUJFaitON2JDelZTUUVQ?=
 =?utf-8?B?WFJ1MDZxc2R1Y2pWZzlmcGIraDZzNSszVFlzcklYcG1zbkhjMU5FNGpnSFVU?=
 =?utf-8?B?ek8rUkRJaVFrNENIc3hlREZ0VU1USHhhK2IzcFYxVWhsNmxqbStGdmtpdm1L?=
 =?utf-8?B?amNnWDMyN3ZPQmlZNXVKM21zSWlnUHZFQjkvcWh6N09aYjh4U2Nxbzg3UFNl?=
 =?utf-8?B?MmsvSlo0MW5uOHpYSkVDV1Z4MlRNWE15RHhGY0JybmxlRWlwU1BWNU5mQVky?=
 =?utf-8?B?SEJWbENScHBPUjg4UUkweDFDZWk2TmJ4Q01TMDhNeFNrNUNnU3VFZzR4OHU1?=
 =?utf-8?B?ZHNoNlJQUXZNWjRRZk5CTnhQWVZFazZWOWpZZnl5YXRtVFdHV1JtdHZoRUhM?=
 =?utf-8?B?MzVvdUpBQjlEZEdxcDk0OWZ3KzR0UHcvZXc4NU5PQStNQkxJWXl3d0RVdGNn?=
 =?utf-8?B?cy9jc3pYSTYvSEM4Zk5ING5mZm9YT2s1QS9zVEU3UWc2azVNMndaR2hWa01Z?=
 =?utf-8?B?b2pyVm1TbDk5UE5DT3B3ZFNhTUZuaWErTHVtSU84SDV5U3U4YlZIU21aV0Ey?=
 =?utf-8?B?WUJjQTdoQ0c0MHlaQitqd29zNWZWSXhIWEdmNzBmQkZkSExPellxdTFCbUdn?=
 =?utf-8?B?YU96WjRhRnVxc3ZuWG91SEJlV3oxVDEvQ2cxMkpBeUx1RFBzZlFYSjhXUEV5?=
 =?utf-8?B?YTNvTDMrc3BYeVdVdG9RMm1Oc1RiejJleVhwMktHZFJ4K2V1L2dHSHZadmwv?=
 =?utf-8?B?c0E2MEZWWHRSdE1hd1VOMzV2MFovTWFIeXRTZEEwTHkxQ045aWErRlRsMHk4?=
 =?utf-8?B?TDg1MlNJck9vclAwOVduL29ENzMyWlBSRjFvc1hZUFBoMEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnovZnVSeGJKRTczMzc1cjdUMk5nWUNHMStLbmVxemVyR0xWOWNNeVFJTDR5?=
 =?utf-8?B?SXpkY25aZGhOTFc2bWZiRlZMOEo0K2xaWFRQVEI5NnBXaVVoK1FkNm1BUFJG?=
 =?utf-8?B?NW1oQVFZc1V5R1F0N0dqaHhHM2JyeDlNK3loektQa0hsY0RPN2hUeUpzZ1Jk?=
 =?utf-8?B?K1BMM0Jod1JzL3JqcGh1QWZCNVFaOUcxeHBoT1VNK0pxK3ovQmozYUNLSElk?=
 =?utf-8?B?UFdxL2I1TFMva2lITUxEVm5WNTNKT2lKeDJUNVJ6b1hmcXVzTzFkOGxoMHFI?=
 =?utf-8?B?QWYvZmFGbUJUaTBUeWJQRUZmd0Y2dUIxMnBXejArUUNBdmJRTmFkcWRUd0hF?=
 =?utf-8?B?UFpTWW93eGVWMFdmVDV5Z1lOT0ZNeXJhbFR2Nkl4RmRiK3RQMDRjUXBqSWl1?=
 =?utf-8?B?VTZMWkFaNTlGNHZxV0txSFZsM1hpTmROUDRFUTdleDdaUUMzam9wL2RPZGFs?=
 =?utf-8?B?akp6Wk44clh4azliZ2VzRkhGRVhmMDlxMTRtREVKN0hxM0U1djZhWWZSUkdw?=
 =?utf-8?B?UkhqSVlxSVc4MXNyWk5vT3NqN3haaUVhaUtDRk5HQnMwdnA3Vm01aGdDekoz?=
 =?utf-8?B?THRxbHdiYUF5ZkcvclNhc2lLdmVRYkJGRm1FM3NQSGppT1VwNmliYmdDR2tt?=
 =?utf-8?B?VDZRUk8wV21Mdm54alIwL2VZbytKWXhnc0ZhZnh1ajlPNDlkU2VrT1JQSjZZ?=
 =?utf-8?B?NWZicFpsS1dnVzF2SnlEZlcyVnFzVFJsNnlqcTVxU3ZIU1RkTkRqVlg2WnNJ?=
 =?utf-8?B?bEZTc2REUjVNOW1UNXA2dmd1clVlWG1lWGhUcVlhbVpVZTMwMDJiYUpUYXJ3?=
 =?utf-8?B?VHhDOURPdnBVeDlyVEtpczNPaVdLaEZqVlk3b3h6WmI5b09IQVR6NWhWbFE1?=
 =?utf-8?B?SGRTZ0Fpcis2T2Z1eVRYSGZQcmVsUVZWMVFRQ1ZweGtrdXZwMHQ0K2dXUGRv?=
 =?utf-8?B?bXcyUWt3a3FxRm5JTkxEMmpFbkE2MTVEUUdKNVh4Z3hYZnN1ZXVjNUJackk4?=
 =?utf-8?B?OGpNbjFLdDQ3anVvNXgxSlJRU1djVG1Zazdkbk5mTmFkZDlVcTFiU1ZxTnM1?=
 =?utf-8?B?b3VMbjdNN1Y5K2s0VjFmOXhkdjFCUGd3Znl2dFdMOUxXYUtvdnZKSXlzeXNl?=
 =?utf-8?B?SnNNa0crMnZSaVo0ZjNKMU41TFZxTktVRGNlZ0lUcDZnRkRPaVhiSEgwelZP?=
 =?utf-8?B?SGdET3owOVJQMjJ5OCtSNmRsU1ZWTXFZRHB4dlI1TE4yWnc3eU4ya013Nmo1?=
 =?utf-8?B?ZXFQTnZQRWhuZDNkc001d3dHTmthektsbE9Db011SGdRSVk5SkZCc0JUQUN6?=
 =?utf-8?B?eUNaall6YXBCUkJQdmRveWtOU1dFWmZBZzB4ekZ4bFlDeE1qTEVOa21VSURw?=
 =?utf-8?B?WVlCTFlubDhPT0xpUW1yYVptc3FwU0dmM0NiK2ljeG1yVVZNNnRsbjQ1UWIz?=
 =?utf-8?B?bnh0SzVkeWFpbUtmQ1ZnREtPQklDRlpLYWN6WXhWZDd0YmlDNTVibWt0ZVph?=
 =?utf-8?B?QkNQZE5jSkdwR0E4Qng1cUdFRlkxa2NYaExXRmhHRTRBOWJjSkQyMXZjU1lm?=
 =?utf-8?B?SlVFRmUzQjRDK09qbk1ITlFDbHBXM0xjMHdud09EOThqY09EdTJVRkdNUFpH?=
 =?utf-8?B?Ly82Uys0M0RyazE1blAraTl2ZHRjWHFud0JtMU1FL1RKeUpSOHpkTnVlUExE?=
 =?utf-8?B?Sk12Q3FKWkxXUnVUekt5ZGtSbXVuZTJIZGhLYmI5RFUwam9USkpYSjBsdTVu?=
 =?utf-8?B?Q1lzSitvWWtQaXVmSHNVV1FQUnNmOWRBUzdqSmM5Zi9DaGhJTXAxTlpCa3NM?=
 =?utf-8?B?dzh3OUpBdjhNejNvWStpOXBaN3VRbUtGMDV3dVAzMjhZc2hnekthVjViNkt2?=
 =?utf-8?B?aytBSDZ1T2EzZHF5b3J6TWhGUlMvbnowbVRibWFFeUVDblJmQUlvR0c4Zkpt?=
 =?utf-8?B?Y2VpNmY2ZzNWUVBvVDltS2NkSUpybWg2Q0x5QjZ4QUFON0xFMjJoK0g0bjlz?=
 =?utf-8?B?ZXUrL1daeUd3Z3pTb2hCWWk1cWdQbE90U1NLa09nRmZPK2pJYllqSVpITTht?=
 =?utf-8?B?SmdacCtUZXVnZWhVdzhtcWhsS1A5RTNTdlBETUoySk5WbmRaM3RGcWg5bWE4?=
 =?utf-8?B?YkFXalF6SGcyV2NUWUc2bHJwRUlMMEZLZGJhUU5ReHFzeE1lRG1lZ0xMYldv?=
 =?utf-8?B?aWc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ffbb68e-ec28-4653-b12f-08dd14b929a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 23:12:45.6497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9zPll++o85k/vaHi9+VZD5QePPu3j/zoNNu1Gv3elJz+Z6PHErtHLSH1y0iahUhUHbOK8fST3awdJIVcj9NvaDoTfroGgLiOcBCiSryetV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7618
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eWFobWVkQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgNCwgMjAyNCAy
OjU1IFBNDQo+IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50
ZWwuY29tPg0KPiBDYzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pjsg
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
IHN1cHBvcnRzIGJhdGNoaW5nLg0KPiANCj4gT24gV2VkLCBEZWMgNCwgMjAyNCBhdCAyOjQ54oCv
UE0gU3JpZGhhciwgS2FuY2hhbmEgUA0KPiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4g
d3JvdGU6DQo+ID4NCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+
IEZyb206IFlvc3J5IEFobWVkIDx5b3NyeWFobWVkQGdvb2dsZS5jb20+DQo+ID4gPiBTZW50OiBX
ZWRuZXNkYXksIERlY2VtYmVyIDQsIDIwMjQgMjozNiBQTQ0KPiA+ID4gVG86IEhlcmJlcnQgWHUg
PGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gPiA+IENjOiBTcmlkaGFyLCBLYW5jaGFu
YSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPjsgTmhhdCBQaGFtDQo+ID4gPiA8bnBo
YW1jc0BnbWFpbC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4g
bW1Aa3ZhY2sub3JnOw0KPiA+ID4gaGFubmVzQGNtcHhjaGcub3JnOyBjaGVuZ21pbmcuemhvdUBs
aW51eC5kZXY7DQo+ID4gPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNAYXJt
LmNvbTsNCj4geWluZy5odWFuZ0BpbnRlbC5jb207DQo+ID4gPiAyMWNuYmFvQGdtYWlsLmNvbTsg
YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgtDQo+ID4gPiBjcnlwdG9Admdlci5rZXJu
ZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOw0KPiA+ID4g
YXJkYkBrZXJuZWwub3JnOyBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsg
QWNjYXJkaSwNCj4gPiA+IEtyaXN0ZW4gQyA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsg
RmVnaGFsaSwgV2FqZGkgSw0KPiA+ID4gPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3Bh
bCwgVmlub2RoIDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2NCAwOS8xMF0gbW06IHpzd2FwOiBBbGxvY2F0ZSBwb29sIGJhdGNoaW5nDQo+IHJlc291
cmNlcyBpZg0KPiA+ID4gdGhlIGNyeXB0b19hbGcgc3VwcG9ydHMgYmF0Y2hpbmcuDQo+ID4gPg0K
PiA+ID4gT24gVHVlLCBEZWMgMywgMjAyNCBhdCA1OjQy4oCvUE0gSGVyYmVydCBYdQ0KPiA8aGVy
YmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+
IE9uIFR1ZSwgRGVjIDAzLCAyMDI0IGF0IDAxOjQ0OjAwUE0gLTA4MDAsIFlvc3J5IEFobWVkIHdy
b3RlOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gRG9lcyB0aGlzIG1lYW4gdGhhdCBpbnN0ZWFkIG9m
IHpzd2FwIGJyZWFraW5nIGRvd24gdGhlIGZvbGlvIGludG8NCj4gPiA+ID4gPiBTV0FQX0NSWVBU
T19CQVRDSF9TSVpFIC1zaXplZCBiYXRjaGVzLCB3ZSBwYXNzIGFsbCB0aGUgcGFnZXMgdG8NCj4g
dGhlDQo+ID4gPiA+ID4gY3J5cHRvIGxheWVyIGFuZCBsZXQgaXQgZG8gdGhlIGJhdGNoaW5nIGFz
IGl0IHBsZWFzZXM/DQo+ID4gPiA+DQo+ID4gPiA+IFlvdSBwcm92aWRlIGFzIG11Y2ggKG9yIGxp
dHRsZSkgYXMgeW91J3JlIGNvbWZvcnRhYmxlIHdpdGguICBKdXN0DQo+ID4gPiA+IHRyZWF0IHRo
ZSBhY29tcCBBUEkgYXMgb25lIHRoYXQgY2FuIHRha2UgYXMgbXVjaCBhcyB5b3Ugd2FudCB0bw0K
PiA+ID4gPiBnaXZlIGl0Lg0KPiA+ID4NCj4gPiA+IEluIHRoaXMgY2FzZSwgaXQgc2VlbXMgbGlr
ZSB0aGUgYmF0Y2ggc2l6ZSBpcyBjb21wbGV0ZWx5IHVwIHRvIHpzd2FwLA0KPiA+ID4gYW5kIG5v
dCBuZWNlc3NhcmlseSBkZXBlbmRlbnQgb24gdGhlIGNvbXByZXNzb3IuIFRoYXQgYmVpbmcgc2Fp
ZCwNCj4gPiA+IEludGVsIElBQSB3aWxsIG5hdHVyYWxseSBwcmVmZXIgYSBiYXRjaCBzaXplIHRo
YXQgbWF4aW1pemVzIHRoZQ0KPiA+ID4gcGFyYWxsZWxpemF0aW9uLg0KPiA+ID4NCj4gPiA+IEhv
dyBhYm91dCB0aGlzLCB3ZSBjYW4gZGVmaW5lIGEgZml4ZWQgbWF4IGJhdGNoIHNpemUgaW4genN3
YXAsIHRvDQo+ID4gPiBwcm92aWRlIGEgaGFyZCBsaW1pdCBvbiB0aGUgbnVtYmVyIG9mIGJ1ZmZl
cnMgd2UgcHJlYWxsb2NhdGUgKGUuZy4NCj4gPiA+IE1BWF9CQVRDSF9TSVpFKS4gVGhlIGNvbXBy
ZXNzb3JzIGNhbiBwcm92aWRlIHpzd2FwIGEgaGludCB3aXRoIHRoZWlyDQo+ID4gPiBkZXNpcmVk
IGJhdGNoIHNpemUgKGUuZy4gOCBmb3IgSW50ZWwgSUFBKS4gVGhlbiB6c3dhcCBjYW4gYWxsb2Nh
dGUNCj4gPiA+IG1pbihNQVhfQkFUQ0hfU0laRSwgY29tcHJlc3Nvcl9iYXRjaF9zaXplKS4NCj4g
PiA+DQo+ID4gPiBBc3N1bWluZyBzb2Z0d2FyZSBjb21wcmVzc29ycyBwcm92aWRlIDEgZm9yIHRo
ZSBiYXRjaCBzaXplLCBpZg0KPiA+ID4gTUFYX0JBVENIX1NJWkUgaXMgPj0gOCwgSW50ZWwgSUFB
IGdldHMgdGhlIGJhdGNoaW5nIHJhdGUgaXQgd2FudHMsIGFuZA0KPiA+ID4gc29mdHdhcmUgY29t
cHJlc3NvcnMgZ2V0IHRoZSBzYW1lIGJlaGF2aW9yIGFzIHRvZGF5LiBUaGlzIGFic3RyYWN0cw0K
PiA+ID4gdGhlIGJhdGNoIHNpemUgbmVlZGVkIGJ5IHRoZSBjb21wcmVzc29yIHdoaWxlIG1ha2lu
ZyBzdXJlIHpzd2FwIGRvZXMNCj4gPiA+IG5vdCBwcmVhbGxvY2F0ZSBhIHJpZGljdWxvdXMgYW1v
dW50IG9mIG1lbW9yeS4NCj4gPiA+DQo+ID4gPiBEb2VzIHRoaXMgbWFrZSBzZW5zZSB0byBldmVy
eW9uZSBvciBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0KPiA+DQo+ID4gVGhhbmtzIFlvc3J5LCB0
aGlzIG1ha2VzIHBlcmZlY3Qgc2Vuc2UuIEkgY2FuIGRlY2xhcmUgYSBkZWZhdWx0DQo+ID4gQ1JZ
UFRPX0FDT01QX0JBVENIX1NJWkU9MSwgYW5kIGEgY3J5cHRvIEFQSSB0aGF0IHpzd2FwIGNhbg0K
PiA+IHF1ZXJ5LCBhY29tcF9nZXRfYmF0Y2hfc2l6ZShzdHJ1Y3QgY3J5cHRvX2Fjb21wICp0Zm0p
IHRoYXQNCj4gPiBjYW4gY2FsbCBhIGNyeXB0byBhbGdvcml0aG0gaW50ZXJmYWNlIGlmIGl0IGlz
IHJlZ2lzdGVyZWQsIGZvciBlLmcuDQo+ID4gY3J5cHRvX2dldF9iYXRjaF9zaXplKCkgdGhhdCBJ
QUEgY2FuIHJlZ2lzdGVyIHRvIHJldHVybiB0aGUgbWF4DQo+ID4gYmF0Y2ggc2l6ZSBmb3IgSUFB
LiBJZiBhIGNvbXByZXNzb3IgZG9lcyBub3QgcHJvdmlkZSBhbg0KPiA+IGltcGxlbWVudGF0aW9u
IGZvciBjcnlwdG9fZ2V0X2JhdGNoX3NpemUoKSwgd2Ugd291bGQgcmV0dXJuDQo+ID4gQ1JZUFRP
X0FDT01QX0JBVENIX1NJWkUuIFRoaXMgd2F5LCBub3RoaW5nIHNwZWNpZmljIHdpbGwNCj4gPiBu
ZWVkIHRvIGJlIGRvbmUgZm9yIHRoZSBzb2Z0d2FyZSBjb21wcmVzc29ycyBmb3Igbm93LiBVbmxl
c3MNCj4gPiB0aGV5IGRlZmluZSBhIHNwZWNpZmljIGJhdGNoX3NpemUgdmlhIHNheSwgYW5vdGhl
ciBpbnRlcmZhY2UsDQo+ID4gY3J5cHRvX3NldF9iYXRjaF9zaXplKCksIHRoZSBhY29tcF9nZXRf
YmF0Y2hfc2l6ZSgpIHdpbGwgcmV0dXJuIDEuDQo+IA0KPiBJIHN0aWxsIHRoaW5rIHpzd2FwIHNo
b3VsZCBkZWZpbmUgaXRzIG93biBtYXhpbXVtIHRvIGF2b2lkIGhhdmluZyB0aGUNCj4gY29tcHJl
c3NvcnMgaGF2ZSBjb21wbGV0ZSBjb250cm9sIG92ZXIgdGhlIGFtb3VudCBvZiBtZW1vcnkgdGhh
dCB6c3dhcA0KPiBwcmVhbGxvY2F0ZXMuDQoNCkZvciBzdXJlLCB6c3dhcCBzaG91bGQgc2V0IHRo
ZSBNQVhfQkFUQ0hfU0laRSBmb3IgdGhpcyBwdXJwb3NlLg0KDQo+IA0KPiBGb3IgdGhlIGFjb21w
IHN0dWZmIEkgd2lsbCBsZXQgSGVyYmVydCBkZWNpZGUgd2hhdCBoZSB0aGlua3MgaXMgYmVzdC4N
Cj4gRnJvbSB0aGUgenN3YXAgc2lkZSwgSSBqdXN0IHdhbnQ6DQo+IC0gQSBoYXJkIGxpbWl0IG9u
IHRoZSBhbW91bnQgb2YgbWVtb3J5IHdlIHByZWFsbG9jYXRlLg0KPiAtIE5vIGNoYW5nZSBmb3Ig
dGhlIHNvZnR3YXJlIGNvbXByZXNzb3JzLg0KDQpTb3VuZHMgZ29vZCENCg0KVGhhbmtzLA0KS2Fu
Y2hhbmENCg0KPiANCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBLYW5jaGFuYQ0K
