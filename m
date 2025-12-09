Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315DA32862A;
	Tue,  9 Dec 2025 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300875; cv=fail; b=XsceDmuw4+T1YlzssJ6OrpabnHvn/pNX4ibLGtFkzYx3dx3U9J6qdCrJFgbWxRZm9VdkvYNm5gU3rysq9BwicASIDJ1g0OMVNpH14r/Bbqll2Js0kxqfgjh3S0yfl70qF7XO+YW4E+aTV4lP86W39l0tpY9yCpB1/GCeaDodkRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300875; c=relaxed/simple;
	bh=b6HYI82tBv6c+YGO4RsT2E5yz7kelWmy21YK1sRQneY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WPDvWuEsMyVyLrnNBFQnWHYfrIsu7dPZD+PzCcFVYwXvyRPq6BeO8BaQ7hIAr82JR8+DKxoGMYCgFHxD9Gib5+tQH5/Dat7tIrd/ieZFoXfzynRPmNRoHz1dPbfYBNKPjLcu8q9Av0sbrOkD60/UnGDEAyfIXchaN2DFp02mb/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NPxMJYLg; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NPxMJYLg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765300873; x=1796836873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b6HYI82tBv6c+YGO4RsT2E5yz7kelWmy21YK1sRQneY=;
  b=NPxMJYLg0KkdOt2cjOQkeUSB8DzsSjqgV0n7Su9IhEnHB0GWPNAONOdP
   OGG2PXSuAGG+g6g5HlpBGWSWc/qPhudtbIwdxZbbOT/n0ptbwhodxsDTe
   phnHikAvzrGMyKWwJF2La3SI2kfXcD+LSJt1cio/nboaXnvJI5/UMk3g1
   ld+C5ajluMNSYNwW4ULyFBNqOENN9rk7dyuKBBPV81+rA96NwYWpnB5H1
   QrkcJ37Qm3jc4dvASaybXa41qZZHYkJoHzzzSyZunazuitlR+fo0YaFJ4
   i/UoTt1NjdVgQGc0JQ3vBZf6wQiBIfY9zwfTSRm4gu9SBHylU41R2R0E1
   g==;
X-CSE-ConnectionGUID: /LuY3IPmQfWbiS2CeKxHag==
X-CSE-MsgGUID: 9aoTYTV5QMC3DVYo184T0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67340243"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67340243"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 09:21:12 -0800
X-CSE-ConnectionGUID: 1p7Pi1HcRritCK5VqbcXSA==
X-CSE-MsgGUID: 0pAwIWOMSL6iZMfvWVlGhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196037389"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 09:21:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 09:21:11 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 09:21:11 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.31) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 09:21:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mdFVbVnwW6ts6H+KJ6zGmSeORxP14pQ8t34nWBwuh35uBq/16LQfSWrJTv9U9aOIqjQci/+ja+tte43elCTpiVDhtWLWLLsFUsecvEMmzMKI9sVKsC1jaz0hK+DT+pWg/xHYReUjT+mOQUU5MXXUPZQhJZpwl0yXb7g4s9qccT0IxB/aw+Iy7PXmVLF8zUs4YIEuzsSwzV3fSMHvI5cEqzvD9Loa/gRUg4+nm6nWku8QDMePdjoRkzYNVnEOOodP0IjlSJYZ0SQxGyye8S75K714DnVdKYWo4Kj0IDUyBC/nqLNqy3oR5nYHGAAfCsMxaJ/VoD8/zuPer2mCDZ4CCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mApKG2aFt7WyHSxB3tGpzXy5ejsbaFajrtkk4AxjnVw=;
 b=nw/qXNJ2GnZUc8xC9UAUHq8JFvxr4n1AJnSbvVqL9jurNwONQeJk3wNgJAw99+02+48gl70mAeUi4H6rUu8+zpFuTSk6D9q9MRuIgKk7aCVo9pMVxpcxLdeug7Cu7fdQjl+SakjcDY6b4hURs7hcSRj2jJglsiM52q6uPqwqRZWP2oWFOZKh3Mb97AJooh7k7OJcYXtES1WAvpRpcl+7cUyLFsti9WHiu0vJOcLmxcbF5wLvrcAYdDbkH/AHn7y3u+HWuhOUzptqNiPuvFCJdSGVokQOf5rYLBaVeA/MVvd6uZnA+MfZIo6Fn/uj1UEUqNpA5AFDSGxw2GHohwMxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DS7PR11MB7835.namprd11.prod.outlook.com (2603:10b6:8:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 17:21:07 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 17:21:07 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
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
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0CAEcgegIAAC4yggAAFRoCAAV2IAIAAFZkAgADxCICAAAPuIA==
Date: Tue, 9 Dec 2025 17:21:06 +0000
Message-ID: <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
In-Reply-To: <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DS7PR11MB7835:EE_
x-ms-office365-filtering-correlation-id: 10a56716-336c-4452-16dd-08de374756c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?1zQixbh9Y6FissEH5OOl/ks7EA7F5tOmTv5lBu8g/e+kzol4iKXGTTDsDm5y?=
 =?us-ascii?Q?FH7MOUwDVMxpnVdDqkQ9+AGvJ2AEuhtXFoM+AaBGZ6YRfGOGpfy17z9KoQAI?=
 =?us-ascii?Q?MjxM6W/H+CWjkTQpmLORLwf4tOCW++b51WVjR8nHgck5ljtD28nOdJxZ3HFd?=
 =?us-ascii?Q?l3/Scg0PHl2hkhdVgwc6+yi44KKUDOsjvMwf/1AQdHgvU808rGA4K4oje6sm?=
 =?us-ascii?Q?Q+hVqZtinQJJQnC9kS2QmL12fQPgqxuQhGLzZSLIcy9aLFtmKS4SrLwj4tyN?=
 =?us-ascii?Q?AfaJRtNW6A6BGgZPfwIJthrTlmW7iCqXkm6qqXOmYwR97DwiAkOBrD+9rQ6V?=
 =?us-ascii?Q?ZbZ7Jlh8LJtOKGmXX6My/8NhZQfnp/wMPmwq37tXww+OdvUyQ8ILw82TlGkr?=
 =?us-ascii?Q?PQiZcAvwXUcTYgY9qvoRjHOzHFPTdUTA0RgCFKqHBaYHFGyxFg7rGYDFuEFd?=
 =?us-ascii?Q?Zf19A0zLc94lyZltkApbHsS64GiwOE8kkbXDDKQxy+cQCCZpBgJeo1q4JG/O?=
 =?us-ascii?Q?2BvcmdbiWWt3OYbu1ZDYlS0bmgihlR2Jy9s61U53O4Ei8ngJ6bVFUCmC2Zv/?=
 =?us-ascii?Q?bR2MWya/KYqNZS6CJAT72+rYQzaiX44r1vrFUCXLtTpQFPlmusQlvgCvJYvN?=
 =?us-ascii?Q?b7YQ2VDI3NQ/1EvdmYGwpGVfr+mPicai+novulq4oc92ZRrv32HxwljwncNl?=
 =?us-ascii?Q?przH5+bwwii1RWmHPZSCesJB2ykaG/LXb+ImoOtSczJYNZEZ/HPUx14aAbjA?=
 =?us-ascii?Q?lv228YdpqvdAe3afSqABSqE4U0tt/LxxDthMiM6bRimymI4W76G7xbwsq893?=
 =?us-ascii?Q?PbIRImv/62Qk+Xh+3bz8CWTIrBBmwI6oZlmawfA4D63ufNBikfD9hrIq9wy7?=
 =?us-ascii?Q?177Y2ttuu6KUhNTJUUCSvO3TNHedEq2++qd5hig/wjKa7Jbrj/TyuG+PrWhM?=
 =?us-ascii?Q?HUujqYZkBmEVKMlGsL2np0XLTxl9vTUw6gfxfwS3Srfb9k17DlXz9gDHaddG?=
 =?us-ascii?Q?CDAKsEwZh6g1YJ2rDCJ0fbjsdNLb3Lnd9wMcQeEuACJ7r++J98lo6iUCsnfv?=
 =?us-ascii?Q?NC4Itfn12Uua4khtEqW7MdFyZTK5WBVPQ5yn1kDQ/4spYOvK1FkDbUyrYV+s?=
 =?us-ascii?Q?dc5pZNvzd26CEFkF6ueII0xOHaydxZDeEil4lrHnA8rAxFxJYkwQXUvKCr+O?=
 =?us-ascii?Q?Qmd6XF4XNyfuMaF19lX7pnnIlBwviBz+50RLODprEoQIYZUHPgmJxclcNZjF?=
 =?us-ascii?Q?j7pVX+N3p0HUfG2cSfMNIp42elnVm5J6Hr01sWuL1IA4RRsES67MM9mkr2bu?=
 =?us-ascii?Q?t8ruls8eTHRrV/Zi3HlrnaOGgxvbWBwnoED8VQeouU/WjjzjzYOsOAPVK57c?=
 =?us-ascii?Q?Ee9rOAB3H+Dldew742NcUBnawV7K/hHiY8CtT8EHIrUGQCVc9+H9IsluUHoY?=
 =?us-ascii?Q?BVE675ch/atfcSgFmh6U43bu3TThF7DglyuYucsK775nzcPRhMWKYg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H/TrONTq0xzx4Saa/WO+1Sh13UEBWV7D1NnyNuZneghrAEc4OQZ/1bUM4Qh8?=
 =?us-ascii?Q?bM5KATpWuzd6faxN9Hqb+bY0T6EGze/di4OdFQpSSYlJF41z1oEvHFwbdnX5?=
 =?us-ascii?Q?oflkoLp2+J9/nGIwE0xFlBQcuYl5Jipra+KmCs1jpKSkbWd5wFQp1GHQux/I?=
 =?us-ascii?Q?c3MiO+iJdesKeJVDFY5e0VAYmcUk+e2nsTndAHKbyZdU26bnkMA5pzdTRLIB?=
 =?us-ascii?Q?m7XD1kOb82JcPvGxDDNfWWDgUyVZrYDf05qVg7M0rXlNDIzrs1d4a6p7RYVr?=
 =?us-ascii?Q?HLcpLEsGvrGpLumtqGhByrUn0VfWdghE4f+ngG+4E4BGWhb2WcnhNfYTiHlP?=
 =?us-ascii?Q?KscmfgiLcqaVrYKSdPB3dTM3N4krkiGgghxkcT0XnUmzbIsrP3G7lwxDqrg0?=
 =?us-ascii?Q?VDskGdLaGM6AUrXq8GvXi1HcRkhejTOBhwN1mSy5Amwb6qB11OrjnsJ0bv7T?=
 =?us-ascii?Q?6qibfB6hYGUq2oxJ8M94yDSgEEOM9voQI+GdSgUEHtBfvi8lI5AB7Fj3TBus?=
 =?us-ascii?Q?58bG9E6BmK8u2muckYv4JwhhROEanUVLDylpv5i2XpM9biTcPOcyd+RkErCA?=
 =?us-ascii?Q?DJgCJ2HKYoJfPxVqpLlEHAG5iIbbJD8WCk92RzmxGSVWEJfIzYPBYrVT2yDQ?=
 =?us-ascii?Q?D7ngaNdndGHQoW4g6axMehv3u9E04cyy7SOqbeGvrsf3sRV24g4RrR5wykYp?=
 =?us-ascii?Q?oAR732vE0CFdWE5eyiMKos8nuPXA/NJfn6ocpdsG6qxPw/G//vT9jynGVikT?=
 =?us-ascii?Q?74Q6aFtwEaAnZVsTUYpFHQUhk7wD/Ln4E4fBIsbJls6DcMaswAy7YffHSKP3?=
 =?us-ascii?Q?RL2UDAuC0mTMNAvWbOq100GgGa9SkJX2nAnppIui5UOd8jixHq/LeH4nV1Ed?=
 =?us-ascii?Q?6KOEs5u+WGYcpm1FDEXB+y6Ozc2p2Ee4HToLdQHM/tr1PTz0OT05B6hikejp?=
 =?us-ascii?Q?lu+Y/2VM+xdd5IudirHOfvnB9ZX2IsL/a5JP54JT8fBTJv7YzpKEzVOBsMJN?=
 =?us-ascii?Q?03OxrawLXUNEcSiXu8uDzgZPkfOk3TT/VpHX7TH8iwziqHjB8evydiSYFrnD?=
 =?us-ascii?Q?x9GmdsFPzVZl/9EWp4AUuxMME5OCfIR/FlJFY9ZOZLgLLwn0qS0DCnmeeSYV?=
 =?us-ascii?Q?VL2m7J9sLp/sc0XL9vjNlL4W3tUZylHAnTyY7ZBEgwpB5L/6je7KxX3JY1aR?=
 =?us-ascii?Q?AxHNBH9/7DSkXb240wqA2KbbDligxM03OSjnBt9FB7K1GMZuYSN6z9lgtalM?=
 =?us-ascii?Q?xKQupW5ZXk2HH/P/dW3NI1fAsJ1Zqlqrr5++aqq2HZrdzXv0RCr9UL3bGd6m?=
 =?us-ascii?Q?sx0FnVNdIGVRMe3h4BiudvEoD0lx/uTHpMGEmbvdjgzO6VKM6sKE4Xi/6kpl?=
 =?us-ascii?Q?rI9fNcN9FBzewDptMF0jf4vMCv9gNfoMcHuZMw3RiBtl2vzM9CBBe0oLDR4c?=
 =?us-ascii?Q?IkC+5EAY7SbZLwByccVbH/8TZFblgFW1LiCvO5b/5PouQ3lLISpmsjoDEeth?=
 =?us-ascii?Q?a3HQtdMRLmXP8AfA3+51a8HOUPnWWqTIC/bdNQES8GQEFjMYDzCvKPE6d7o/?=
 =?us-ascii?Q?rEldm5xQRmlHZR7aquB/wKOS5BmvoM+O4T1BQ5gmFP59A8Cd24UHOE0XLUWO?=
 =?us-ascii?Q?eQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a56716-336c-4452-16dd-08de374756c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2025 17:21:07.0613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TUVSHxTojBJkPEZ6S9K4814WKbPAshKI48Z0jGWNOhJA9CO6soQt7wXcnG5Pt/PVJ0FGF5QXO+HymzKb14Fgb7+seWTaZriTY9ffswmLf6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7835
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, December 9, 2025 8:55 AM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
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
> On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > >
> > > Just to clarify, does this mean that zswap can pass a batch of (eight=
)
> > > pages to the acomp API, and get the results for the batch uniformly
> > > whether or not the underlying compressor supports batching?
> >
> > Correct.  In fact I'd like to remove the batch size exposure to zswap
> > altogether.  zswap should just pass along whatever maximum number of
> > pages that is convenient to itself.
>=20
> I think exposing the batch size is still useful as a hint for zswap. In
> the current series, zswap allocates as many per-CPU buffers as the
> compressor's batch size, so no extra buffers for non-batching
> compressors (including SW compressors).
>=20
> If we use the same batch size regardless, we'll have to always allocate
> 8 (or N) per-CPU buffers, for little to no benefit on non-batching
> compressors.
>=20
> So we still want the batch size on the zswap side, but we want the
> crypto API to be uniform whether or not the compressor supports
> batching.

Thanks Yosry, you bring up a good point. I currently have the outer for
loop in zswap_compress() due to the above constraint. For non-batching
compressors, we allocate only one per-CPU buffer. Hence, we need to
call crypto_acomp_compress() and write the compressed data to the
zs_poll for each page in the batch. Wouldn't we need to allocate
8 per-CPU buffers for non-batching compressors if we want zswap to
send a batch of 8 pages uniformly to the crypto API, so that
zswap_compress() can store the 8 pages in zs_pool after the crypto
API returns?

Thanks,
Kanchana

>=20
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
