Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B064723959B;
	Thu,  6 Feb 2025 19:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738869890; cv=fail; b=KK0y0b+4B9YRNQap4mM/kQKXMU76LRayeoG+rW5gCVg6ErQFP78XqVEWuq7RifFBoj9NvGmdIkVJXg0wNTFbxaHUvCC3ctoRForG6pXeV1v/qjC9mxAqkhC8Z2rE1LPCti/vR3nfAy/fRIGgZuLM1EwGRMNgZZ07OH3gmg043rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738869890; c=relaxed/simple;
	bh=4pY+ZwqJ9KRyeO8HPCogAezX6qGpMhYqMvaekIEr5Rc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A+RzFAZxgamZr6y8bxXIXSefny0If3AY1etHHuplJfk9j9cseKRvxiWohvMxHHvLOnH8t/9zubYW4MDDXzw/Af0RrNnEH6Of4NIMpXdPBZVuWgp8MXYcnesEg4SVs2eWf4GOPPsUXI2CTOZHl72DP1bP6P/z9mv/ECvlcDgt1mE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XPz8HgrN; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPz8HgrN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738869888; x=1770405888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4pY+ZwqJ9KRyeO8HPCogAezX6qGpMhYqMvaekIEr5Rc=;
  b=XPz8HgrNqx5g5yMhvyslvDz2L5o7Rvy5Od2UE+xgFvrZH8zfu0piQHVv
   daqH7b/STkKHS1YYFPqbXGD13kuWo4+0+THuIri7o6P/0uD93HOPf6Jqg
   YH5tJ6cbW10QsGDJqMq1paXMtU4xOisgH4pJGchTk21ZZvl7jwXCwLcnw
   TVdeHKRQGeYgdGiRrcZtIs1ujFJQYBlRmpGFSGQLXjFiSfIBEmwncrEPy
   k72tR6JHhZDmVPIQSQTspYI+hYBcw429Yh8G9IMw9i1zczocZRxMem2cu
   N0BO62lxSGVXK38NlJEkNCemZntAUp5VYPKUwupyy7LaEjBoMUT7B/Xxd
   Q==;
X-CSE-ConnectionGUID: ixNPMebxSImCQo1GqJImkg==
X-CSE-MsgGUID: du1iY0CYQYyWkkhRoN/KhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39399365"
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="39399365"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 11:24:47 -0800
X-CSE-ConnectionGUID: 89ghzegmTqeOLnMHDHkBvw==
X-CSE-MsgGUID: sKSMkvtgSg+zbRUOgXOGFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="111503017"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2025 11:24:46 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 6 Feb 2025 11:24:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 6 Feb 2025 11:24:45 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 6 Feb 2025 11:24:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UIeVWHsI/P9kwncM2BeZgXGsa9oEJTKp15kFuq75tbiaTxsKyuNVLFXCC+aH8mIfgIkEhL5txv8psSg7t9UkD84xbQAGnwJ57yA6HWFd0muFDkGENcPFcnIZCORMEX33SEzkaB6kL2mWYrDlfr35Fa3b0oVXXWt9/I01JTaX83vzVfma0sJFyrGc7+SIRzNl9Zgpmlq0oOeNA2OslrdNOnabep4fh89oCtzpNr6sof1iPA1UZOmeqBHkqqjj9dIR7lwqhS4xqDG2Aeb5tHx8b6J+JPo5FiVlCPGHbmgzlL8WfeYvNNWU0cwcNZpBpoor4bbTJ5MQ9zH+Bs/2kwKhyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhCmvfpOzRasG4Lp9SG0esnWtFfL45Frv7BnOHXX/ZQ=;
 b=gdzPSVFQKYi3VkqptPpE6JJol7lO9YxaifxFwyT5hTSAG9qr40jchwCgzmSEeUzZnG+4ro14Y/OT6PGM+r1D/CtcDxYTudzJaFoqy9IHaHU//RUR+M5H21bVoW8MnRWTMUs8kpVlRcCjnrJ7DApxE4RGM9GIc9mtGgae0h2TqV1DeI2vapf5bT85i8f4aR06NFMTSBtVivktI4Eqt7yoLIKXg95OU7+KqiNMwpZEoNcEUCEeFtnCggWjCtu9VkuPmCBkdOrjODKjhdUAZ7/s1rB11LbKVW/8n9CcmLoBP+D0ShBraXQbI4X+gi+A0afRkl5W3SsIRrq3w1XynvHaKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.26; Thu, 6 Feb
 2025 19:24:27 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8398.025; Thu, 6 Feb 2025
 19:24:27 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
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
Subject: RE: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Topic: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Index: AQHbeGfAjZbrwpkGjEqL/QTV2aedp7M6pMeAgAABk4A=
Date: Thu, 6 Feb 2025 19:24:27 +0000
Message-ID: <SA3PR11MB81203800298A246D7D6CB75EC9F62@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-16-kanchana.p.sridhar@intel.com>
 <Z6UJKTCkffZ93us5@google.com>
In-Reply-To: <Z6UJKTCkffZ93us5@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|SA0PR11MB4736:EE_
x-ms-office365-filtering-correlation-id: 6a7ed0bb-84a5-46c6-464b-08dd46e3df22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?FkL7kfWTWFIEKDQ7ERoAsMKAmD6bBrpCQ+aB5Pqcyh4d3xXI6ulV2o2fKJma?=
 =?us-ascii?Q?3HuDlmG01GXEHgPVKfz1CJR85zGLy+bqbAlow4Nzko1RXnJGZj4WH5muJr/y?=
 =?us-ascii?Q?g/NI2uIVhCFjBhhPjoM60wzDIkxRUnaJA9AEMXvUmk1ZATsRT7yARU992OYX?=
 =?us-ascii?Q?BBrV7YpBhE9ksiByWoF5orR6jC8abDaeKLYY8Fm6Hunq9Eiv6n3GrZeKpiTl?=
 =?us-ascii?Q?8YBW6HwWIASkAVOEbo/tDv8Yqbsj6wrCJOX1qJuZ4D//jMyQZWyQXaqNNy5o?=
 =?us-ascii?Q?zv4WNRt/Cj7cj8WD3cevITHVDX49Y19DiOGlBX2i6gNjyBlWgAwKEv08bw6H?=
 =?us-ascii?Q?LiCOIZiuXgFWb8UCU9H9e9kvxIWuzHOWzFQeviJA4jqpTFQYl6EVXEdK1ASz?=
 =?us-ascii?Q?P2Lh2NRkLrEGooBaXbWt9zgUmO/nn8JTFBGwu//OITViOJIkVv5DjSnvRk9Q?=
 =?us-ascii?Q?twAVWP2RaVEEj4K+0BGv7TKlIPAtDvmJjy2LEWJlpyEpUiB604Usp9zYs9YA?=
 =?us-ascii?Q?5P1fBNGsV0g7DLSaPsgi32umuvHuYuwyAlUDWf+Owpbx74hbFvKbmfydK1AS?=
 =?us-ascii?Q?YuKH8qzy0/vV2fcUtrVof3gwf+LA/aBBl0ozuUqHnTcDvT7nAnk/eBk6n8hi?=
 =?us-ascii?Q?wtCCespVyVxV+yUzGgNuqBvtKGu2JfpVGApDfmizaOK+6kmt2q9pbWl3j1M+?=
 =?us-ascii?Q?7cElgR7KeY+4wX0k7EpCQl/blJsbvlcujmd+5na6rvUkPQl9FvS/++rAAU1t?=
 =?us-ascii?Q?irivN5V09Q4Vv6NHfJUCUUVkQH8Y6uX6H553LZYJgFV6hnaf7YzBy/gamP8n?=
 =?us-ascii?Q?hMrpGJj/0s0nJpi/Vost4LtZA5S9dAlaqnI7vEtCbUH0x/Ab27Yrt6vjTwbQ?=
 =?us-ascii?Q?LU45om0xcBKL0kn+uaViLNw19j0/mCwjYoMqmKu9pvATKcHi/AVmP33bxcBa?=
 =?us-ascii?Q?60OMxD+L1A7aZZKhkfEPbpeU5LZA3Urp6rfrUTrjcqa3P6ujHoHEWkg6Qth8?=
 =?us-ascii?Q?DxO4xLlQizwdSetaQHCr29Fe/lpaU6Kk3PmjIZDp8EYLGaaUnPhgOfR71Jjw?=
 =?us-ascii?Q?gdt+bBMjJuGAkwKinJYwVfWAwyB0nr6FfARjC/PMP429oSf7U6c8D2+hjy2h?=
 =?us-ascii?Q?Lbwolq4mLbEGhy+pOaUT2APcloMDE4WRBxMTjKS2uZeXJipuvKSkLaqj+FvR?=
 =?us-ascii?Q?DiQq+hDrVIrlhN4KbDmY3SVvSczp0S+bE+S8MgjvjH4zIPG+HerS/+VdpItx?=
 =?us-ascii?Q?QqpnK0oa/OZA/2hCV5YTD0mqNyRuW35iq0O0PV4+sa8/eQiCjYJaS7+0lb7+?=
 =?us-ascii?Q?JfJOoiE3hpRXtSD6LiIT3ZMpzllGtmTdUFPRx6dm9FatXvbQZrH9thuz1gan?=
 =?us-ascii?Q?fF3eDKW2ulvqB9Dox+7hGzxq7FwZGyFygf4jhiaa69v83pecixf9dk5QttYu?=
 =?us-ascii?Q?sIwhW63PyLn4eOTNdv+aTHzQJU9I90wF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OgzYIl/xvI4YioZ/szQXG5hU1XunRrCL0dqinkXQlM7CAu2OXcMmK5LfosQT?=
 =?us-ascii?Q?SYodTwJrH6BEE1Men+7nde9JPFjvibT0hZKVkK+wB87yQ+f5DgAdqB9tQDjG?=
 =?us-ascii?Q?Ge+dQxsgv20Y103RREgai4aeE+adHawVFvf7ZNdqTg7Bpg8k/xJbmxVhoERa?=
 =?us-ascii?Q?GbDdhfVhBnxDoTxrFqI8UfwvPIYC2tZRFPDxO0cyx0eY8S7SZS6tKO2XfRY0?=
 =?us-ascii?Q?HQVpNcYtvmoliM8zVm9+Vs39/eTrUIQx7MM+7W77JfmQa9xlf8P1iq2uG25Q?=
 =?us-ascii?Q?BojFVJgcLgLvKeDLKvST+fCFfWEDMuNB5wOP9X2BgmdiqWXpxHbb9+cSqLWR?=
 =?us-ascii?Q?mGgwjk2gE7Qe993nGLch6r9yeqEOH6ocPNz/bY3L+0OT9PGZO4lDw3/63vNX?=
 =?us-ascii?Q?5Oskf4okzzdMI0RSeDPZkulAxcvbQDw0gDb5j6sYv6LPY2CRFkyfU/WIVlFz?=
 =?us-ascii?Q?JnrPV0n52zW9g4b2h/REsTmk3bFr4ulxLgJi6vKsAkfAkFGRFFbJRee0myNW?=
 =?us-ascii?Q?QMS104Z2D8iiqhRT0q54uzypMUPyGRjo5vKevj0NUfekCJ2hR7rlVUrNw2hW?=
 =?us-ascii?Q?9AtxK2uFbx5PbUh9ZEgzxBkA35KHBizEV1tEtT4idOaBbLyLm6OIAyh0EFPv?=
 =?us-ascii?Q?nVol0KK8k9OHFTDx+glxqkVvca3RGZqqKVfZO0+31YlhbjP8OA++cTk29uew?=
 =?us-ascii?Q?VYV0LGEcIucNVd2QY3R5NDB0NGbvEQFZsmiQ3ETABUB+hQonLxE8EhQfPcme?=
 =?us-ascii?Q?nrC8cs3lnZtWizzf3R3BqZnstWvF3OnJf7a63m0ZEacN+KFtKd9umn++EVxv?=
 =?us-ascii?Q?o4ZGWp4hkxoSK7HrC/XYOMA+hoRymPEG68gWwME4I/D1GcewldUtP5xf7otU?=
 =?us-ascii?Q?HT/X4XWk54Y7YsvTJHOwbxcsF16JQIWKOSbFIQQONISTeFDJe1Xk5PaeiXFi?=
 =?us-ascii?Q?AHJbaThrhCB/Qb3stbOd5FKUQAwMfbExvGeN+4hSy6xp5700ewDKrqq07Mhg?=
 =?us-ascii?Q?zRePjBtdbZ6buLwcBly58lr6UxPCZUDpjoouYTYUDIql/Iv/zFCD/3c1/VxE?=
 =?us-ascii?Q?qIVjy5+6brJpAfe0pCL5SVerEeqPdQGl8BbYz4ZJOYDDpJMT633AZDozv+/8?=
 =?us-ascii?Q?kNp0wr8ZN1Y7Pz/jkVGJwUpWHop4sItWGWDk23Us+HscceCSC0XsbwjZd2zh?=
 =?us-ascii?Q?E9IJ+WDyOFAV5P6zy4jrFQa1zqX5JWlHKAeKQAUOBuKAPOC8ob1TM7a1V3ru?=
 =?us-ascii?Q?z1l/yYUDxCOt7/H0v4mBj60sE2mK+/OosWKxJ4O8nhGcqdgxE8K/UqsgWXXU?=
 =?us-ascii?Q?KUtNLBm6tYgONGpmkKNdoDPJtYJHwWqvCLMRGKcLXU8J5NIXLYuAe1k5qsU7?=
 =?us-ascii?Q?gcezEXu+9ekj0U9W4V6oGv36vc5ZlRsFwTgaBk8H9pNu3xCFM73fah7aMYNX?=
 =?us-ascii?Q?3BYI7w5K2a9KXq+xdywZ/Qp8bvkRRUpZnyf1OlBiPrSUisx9I7/9ui/LN0ct?=
 =?us-ascii?Q?k9OsdOIzt2BgUUhtkaH+ujzCkwk26KM69ZLw3wmqj1tp8EqTAEULMk7CTB/j?=
 =?us-ascii?Q?TqNRXcKhfNb24CpebYD28KckuzAT0neCnHWmvlTk4zU2pP+qGQNSY/rWiYvn?=
 =?us-ascii?Q?tA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7ed0bb-84a5-46c6-464b-08dd46e3df22
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2025 19:24:27.1423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h46ehVRFPo+FmTCXHFZCICzzsoZJ9SBHzPdrrMKhvm/27pO11/sNPSg64lqeosy5KuIGEkAdf8IuFbigvI0d7inUwiI+AD2QjSUkoBqwKW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, February 6, 2025 11:11 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net;
> clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v6 15/16] mm: zswap: Compress batching with Intel IAA
> in zswap_store() of large folios.
>=20
> On Wed, Feb 05, 2025 at 11:21:01PM -0800, Kanchana P Sridhar wrote:
> > zswap_compress_folio() is modified to detect if the pool's acomp_ctx ha=
s
> > more than one "nr_reqs", which will be the case if the cpu onlining cod=
e
> > has allocated multiple batching resources in the acomp_ctx. If so, it m=
eans
> > compress batching can be used with a batch-size of "acomp_ctx->nr_reqs"=
.
> >
> > If compress batching can be used, zswap_compress_folio() will invoke th=
e
> > newly added zswap_batch_compress() procedure to compress and store the
> > folio in batches of "acomp_ctx->nr_reqs" pages.
> >
> > With Intel IAA, the iaa_crypto driver will compress each batch of pages=
 in
> > parallel in hardware.
> >
> > Hence, zswap_batch_compress() does the same computes for a batch, as
> > zswap_compress() does for a page; and returns true if the batch was
> > successfully compressed/stored, and false otherwise.
> >
> > If the pool does not support compress batching, or the folio has only o=
ne
> > page, zswap_compress_folio() calls zswap_compress() for each individual
> > page in the folio, as before.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 122
> +++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 113 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 6563d12e907b..f1cba77eda62 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -985,10 +985,11 @@ static void acomp_ctx_put_unlock(struct
> crypto_acomp_ctx *acomp_ctx)
> >  	mutex_unlock(&acomp_ctx->mutex);
> >  }
> >
> > +/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the
> caller. */
>=20
> Please use lockdep assertions rather than comments for internal locking r=
ules.

Sure. Thanks for the suggestion.

>=20
> >  static bool zswap_compress(struct page *page, struct zswap_entry *entr=
y,
> > -			   struct zswap_pool *pool)
> > +			   struct zswap_pool *pool,
> > +			   struct crypto_acomp_ctx *acomp_ctx)
> >  {
> > -	struct crypto_acomp_ctx *acomp_ctx;
> >  	struct scatterlist input, output;
> >  	int comp_ret =3D 0, alloc_ret =3D 0;
> >  	unsigned int dlen =3D PAGE_SIZE;
> > @@ -998,7 +999,6 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	gfp_t gfp;
> >  	u8 *dst;
> >
> > -	acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> >  	dst =3D acomp_ctx->buffers[0];
> >  	sg_init_table(&input, 1);
> >  	sg_set_page(&input, page, PAGE_SIZE, 0);
> > @@ -1051,7 +1051,6 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	else if (alloc_ret)
> >  		zswap_reject_alloc_fail++;
> >
> > -	acomp_ctx_put_unlock(acomp_ctx);
> >  	return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> >  }
> >
> > @@ -1509,20 +1508,125 @@ static void shrink_worker(struct work_struct
> *w)
> >  * main API
> >  **********************************/
> >
> > +/* The per-cpu @acomp_ctx mutex should be locked/unlocked in the
> caller. */
> > +static bool zswap_batch_compress(struct folio *folio,
> > +				 long index,
> > +				 unsigned int batch_size,
> > +				 struct zswap_entry *entries[],
> > +				 struct zswap_pool *pool,
> > +				 struct crypto_acomp_ctx *acomp_ctx)
> > +{
> > +	int comp_errors[ZSWAP_MAX_BATCH_SIZE] =3D { 0 };
> > +	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> > +	struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> > +	unsigned int i, nr_batch_pages;
> > +	bool ret =3D true;
> > +
> > +	nr_batch_pages =3D min((unsigned int)(folio_nr_pages(folio) - index),
> batch_size);
> > +
> > +	for (i =3D 0; i < nr_batch_pages; ++i) {
> > +		pages[i] =3D folio_page(folio, index + i);
> > +		dlens[i] =3D PAGE_SIZE;
> > +	}
> > +
> > +	/*
> > +	 * Batch compress @nr_batch_pages. If IAA is the compressor, the
> > +	 * hardware will compress @nr_batch_pages in parallel.
> > +	 */
>=20
> Please do not specifically mention IAA in zswap.c, as batching could be
> supported in the future by other compressors.

Ok.

>=20
> > +	ret =3D crypto_acomp_batch_compress(
> > +		acomp_ctx->reqs,
> > +		NULL,
> > +		pages,
> > +		acomp_ctx->buffers,
> > +		dlens,
> > +		comp_errors,
> > +		nr_batch_pages);
>=20
> Does crypto_acomp_batch_compress() not require calling
> crypto_wait_req()?

It actually doesn't. If the crypto_wait parameter is NULL, the API requires
the driver to provide a way to process request completions asynchronously,
as described in patch 2 that adds the crypto batching API.

>=20
> > +
> > +	if (ret) {
> > +		/*
> > +		 * All batch pages were successfully compressed.
> > +		 * Store the pages in zpool.
> > +		 */
> > +		struct zpool *zpool =3D pool->zpool;
> > +		gfp_t gfp =3D __GFP_NORETRY | __GFP_NOWARN |
> __GFP_KSWAPD_RECLAIM;
> > +
> > +		if (zpool_malloc_support_movable(zpool))
> > +			gfp |=3D __GFP_HIGHMEM | __GFP_MOVABLE;
> > +
> > +		for (i =3D 0; i < nr_batch_pages; ++i) {
> > +			unsigned long handle;
> > +			char *buf;
> > +			int err;
> > +
> > +			err =3D zpool_malloc(zpool, dlens[i], gfp, &handle);
> > +
> > +			if (err) {
> > +				if (err =3D=3D -ENOSPC)
> > +					zswap_reject_compress_poor++;
> > +				else
> > +					zswap_reject_alloc_fail++;
> > +
> > +				ret =3D false;
> > +				break;
> > +			}
> > +
> > +			buf =3D zpool_map_handle(zpool, handle,
> ZPOOL_MM_WO);
> > +			memcpy(buf, acomp_ctx->buffers[i], dlens[i]);
> > +			zpool_unmap_handle(zpool, handle);
> > +
> > +			entries[i]->handle =3D handle;
> > +			entries[i]->length =3D dlens[i];
> > +		}
> > +	} else {
> > +		/* Some batch pages had compression errors. */
> > +		for (i =3D 0; i < nr_batch_pages; ++i) {
> > +			if (comp_errors[i]) {
> > +				if (comp_errors[i] =3D=3D -ENOSPC)
> > +					zswap_reject_compress_poor++;
> > +				else
> > +					zswap_reject_compress_fail++;
> > +			}
> > +		}
> > +	}
>=20
> This function is awfully close to zswap_compress(). It's essentially a
> vectorized version and uses crypto_acomp_batch_compress() instead of
> crypto_acomp_compress().
>=20
> My questions are:
> - Can we use crypto_acomp_batch_compress() for the non-batched case as
>   well to unify the code? Does it cause any regressions?
>=20
> - If we have to use different compressions APIs, can we at least reuse
>   the rest of the code? We can abstract the compression call into a
>   helper that chooses the appropriate API based on the batch size. The
>   rest should be the same AFAICT.

All good ideas. Let me think about this some more, and gather some data.

Thanks,
Kanchana

>=20
> > +
> > +	return ret;
> > +}
> > +
> >  static bool zswap_compress_folio(struct folio *folio,
> >  				 struct zswap_entry *entries[],
> >  				 struct zswap_pool *pool)
> >  {
> >  	long index, nr_pages =3D folio_nr_pages(folio);
> > +	struct crypto_acomp_ctx *acomp_ctx;
> > +	unsigned int batch_size;
> > +	bool ret =3D true;
> >
> > -	for (index =3D 0; index < nr_pages; ++index) {
> > -		struct page *page =3D folio_page(folio, index);
> > +	acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> > +	batch_size =3D acomp_ctx->nr_reqs;
> > +
> > +	if ((batch_size > 1) && (nr_pages > 1)) {
> > +		for (index =3D 0; index < nr_pages; index +=3D batch_size) {
> > +
> > +			if (!zswap_batch_compress(folio, index, batch_size,
> > +						  &entries[index], pool,
> acomp_ctx)) {
> > +				ret =3D false;
> > +				goto unlock_acomp_ctx;
> > +			}
> > +		}
> > +	} else {
> > +		for (index =3D 0; index < nr_pages; ++index) {
> > +			struct page *page =3D folio_page(folio, index);
> >
> > -		if (!zswap_compress(page, entries[index], pool))
> > -			return false;
> > +			if (!zswap_compress(page, entries[index], pool,
> acomp_ctx)) {
> > +				ret =3D false;
> > +				goto unlock_acomp_ctx;
> > +			}
> > +		}
> >  	}
> >
> > -	return true;
> > +unlock_acomp_ctx:
> > +	acomp_ctx_put_unlock(acomp_ctx);
> > +	return ret;
> >  }
> >
> >  /*
> > --
> > 2.27.0
> >
