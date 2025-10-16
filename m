Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6781643B;
	Thu, 16 Oct 2025 00:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760576231; cv=fail; b=PRZG4BO82e3Rr+qav0Yb0T/RIWp1xz0dOxo4gxfyuzzOsvoCuozuMgTR/m1JDNNK7GJ/PTcMTjzMfkt416Nyrx9qeQalgRdhsjEkfvDLMDPR0EAGrwknKxx0uSu6aBBJh2vr37njNIYQpXrI0xKozfUqlX0pM999cnAI2ldDU74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760576231; c=relaxed/simple;
	bh=HC+VKWnD7nIU5x4RwR4AtgzPo1nNiQUcXaKFBmoRgGQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BQv2wXCi/WagfCAGRiCyryVVghZfYZ8iM2jfnwXra8yga3vhmVmX1K3TwGLELYZcQlxobw9DedV4LtUWnxSvKB70NzQbA1lxbmtGLoQd5N1hnaKSDzN37/xbdXIQQ3xFpCuUtz+vBEkovn1doFEh7O37r53xHeJsHL3IEmGTv1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EwoG0tQu; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwoG0tQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760576230; x=1792112230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HC+VKWnD7nIU5x4RwR4AtgzPo1nNiQUcXaKFBmoRgGQ=;
  b=EwoG0tQui2YErhkfj4ItE79YOvqV+PlkST/+v1JEIVT1KjVz846u+mYi
   yE9//WWRFfZ1XpMK7QpK/INKve7YEBU6KvMDrQ69NZ4E6o6RnjEDfne09
   ulj62q2j6HFpCdP8IE7iyiSIYFvlT0/C82MpZ42/PPQ7V+WVNbIPqU+ib
   atNYj2tVXXUUJmOpA0BXwEMtCnMkGKFDWTcd6Wjonyt0J0cm7qE+M6tHi
   C5vyzYrZpGEaPqwjokhXFXn6n/j35416fkMUfdLpMEiBdSN5sDfCa2nEl
   9O46IL2TLzKk6fzy7jNae2Huam5umgLb3FbCTprKk0wH1H0rDEMKCjyRh
   w==;
X-CSE-ConnectionGUID: 4vDhRu0nRlSMwsZnwD8EiQ==
X-CSE-MsgGUID: AmD6v4fiTYa2rrHGCOn/lQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="62799953"
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="62799953"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 17:57:09 -0700
X-CSE-ConnectionGUID: 0QuYZiTQRi6zJ+85JK530g==
X-CSE-MsgGUID: sN+Yf0tkRTaFz14SZ6wdRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="181863979"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 17:57:08 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 17:57:07 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 17:57:07 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.70) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 17:57:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hxmgx+NNiGeh5GLUUB6tdiPWpUHeOtCsDpc4bIy682nsLPAqBDmmBN77UUqMhVL9b5D/Si3HkXxUZe7bQ8pG99NObxlXxQYAFr7FvIW99EkYnkwYfoKxnMRDdOArO9irRdbZ/roUwLedzDW3CbN2B959rwJqMpi+aenbWMDn8Ck2t+9Pvy7ReNvXtx+9KRMMIpfOnD9sYUhyry2hwSMdCi+DN6AzhP4G/h2RuQMw2j4LEYX1sv3UAJp4e1G3Zmxf/Dy9bf1MXyhN37G0daajHHJBTBZ0mr6h2ctT4Yg1bohrEkgWRY8ra/lMi44WEVE9kO4816PVs5ltZuOuepxz4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HC+VKWnD7nIU5x4RwR4AtgzPo1nNiQUcXaKFBmoRgGQ=;
 b=F/cyeYYWS77jxkfDALLygj5oKzCLdXvV6//HIcE5MvR7peaqX/n3cpyTUEg5mJ0OLUaFhJoPzWeeMkBasAID5n3kTbM1aM+K4tNFspLuhTeM/J1yDODx6SGYlwgYGsFxYUBhwaKByf0itcmeuD/ELZW4Bn8FqqK0xax44s8JuYSlO9cM2ti8szs+4wl2YbWVAPnjJWr5TqcCB5au7b21HOJw0V9HSMpCZx6ifA6i1x5bW/SCG/21mq4lKuws4Bph4+TP6E8vJKT3/M03pQT1TQXSH9fdNAy8VooDJZO2aB/U7nKtXOlAkO2t4CAbhW3b+n0wVLolsU2A+GvQ26fIEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DS0PR11MB7192.namprd11.prod.outlook.com (2603:10b6:8:13a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Thu, 16 Oct
 2025 00:57:00 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9228.009; Thu, 16 Oct 2025
 00:56:59 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcLpaY70ekQ7dio0CIg97nnm1fBLStgQgAgAAW5fCAFEmngIAAElMAgACww2CAAOmsAIAACgIwgABPXoCAAANOgIAAJp0g
Date: Thu, 16 Oct 2025 00:56:59 +0000
Message-ID: <PH7PR11MB8121663B9F5A2210B8431C9FC9E9A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
 <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com>
 <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAKEwX=NkaaCkoyULr4J+5-F+L5bRhM0F8JsV2DS0Mk=xYhncRw@mail.gmail.com>
 <PH7PR11MB812150A977B6F9F68ACDBCC9C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <wn6pnt2nm5pguceiquctilul6lrk3ckycypwnw2zfxqrlgi2cf@5qn32ewswfl7>
 <CAKEwX=NT_3QJSQGRgogGYmx_M262O+F4Hs9BtbCUqK3qbh+t8g@mail.gmail.com>
In-Reply-To: <CAKEwX=NT_3QJSQGRgogGYmx_M262O+F4Hs9BtbCUqK3qbh+t8g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DS0PR11MB7192:EE_
x-ms-office365-filtering-correlation-id: 7ba081b0-25a0-4be7-3166-08de0c4ee98e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MnBJejhUNmZLMTVpQUxvM2I0RzhhT0tnNW94dmkwOHkvSDE5cGd6Si9PcWNY?=
 =?utf-8?B?dDZ5UGJrczhJS3JUcXJuazZqUVQxQlpOY055d3AyQXgyYTVHZFZvK0lwTnNP?=
 =?utf-8?B?d3B0alNUR0ZaSG1yeThZS204VEhlbmk2VTdEbWtOWkdqb1FzdytJd0c2ZUE5?=
 =?utf-8?B?NG5JSmNHcFh5NTVvR1lISHJ2N1JwditzMGU4T3lnVnZoOXp3K3RKUW56SkJm?=
 =?utf-8?B?MFpXRUpUanVXZW5wK2lxUU5KTUQwREszMStGMzY2WFZlT1R4VU1iYkxuSURM?=
 =?utf-8?B?VHJUd3g1dGFIaVRTYzhQMnRoTDBEeGlFNkFya3dqU25aOFkvdHJMR3lDblMv?=
 =?utf-8?B?MFBTRkhGaVBLbHBuT2lkTS9lampUb0FmNUJHOTlUSllGSWp4UFBiM2t5Qi95?=
 =?utf-8?B?SlNYelp4bHJTWDhlWWordVhDL2JLMEJGL2xzU3Z2cGhSaFJwU1U1TnVNWTho?=
 =?utf-8?B?SnJ3NzVwM0taVnp3Mk1oYTk2ZVo2Q1BDQy8yMUNXVmVTQWF0QnFKUVhBUVc3?=
 =?utf-8?B?NUdGVEloV3FtMjJNWVFMMGZ6WEhwZ2R5akJURUszTFlRZExWelJTcC82NkVv?=
 =?utf-8?B?NmU4MEZZTFkrZzdLSUxSTXVDemRvbldEYkRnMVRMNkI2YmZFa3M2dVJ0OWJD?=
 =?utf-8?B?SWh5SkdlM0QwNkdMMWx3c2hJZWNhWVd0MENoblhPT1dLeTkxTHdGRFovVGhp?=
 =?utf-8?B?bEVwQ2hETWFlSXFDYytsMDA2OGFQRHFqZDFJV1lNcWZkRlE3ckhSaEVQU1Q4?=
 =?utf-8?B?SytDV1ludEtyS1kvRWVLN1AzekhvazJFMUtjeXU4STVOdjh3Q3dZeTNPWlZu?=
 =?utf-8?B?T0c3TUMvbCtXWlB1TjVGVmhFVnA0anF1VlVJOTBqS3JwOVhNbGtvM1V0cW84?=
 =?utf-8?B?aG5xUDFuaFJHdkdBUU1pWXpPeklxSlpzT3pXOXNac0FNTWdOcnFqZ0lJbURu?=
 =?utf-8?B?K2pNRmpadXltQm9PYVYzVFI5aURLdjc3ZlBMNW5mS0RxTEZBaTRVMnJCWUhu?=
 =?utf-8?B?YkcybSt3SGZ2UmoxbWtGWU1iWWtSVWxkR0F3azdkc21IMlRwaHF2ZjBQd3Ru?=
 =?utf-8?B?Nzk3WUphNTVMcGFrOStscXJPYStMelc4OTY1UXg2b25EbVdjT0IrVXZieWQ2?=
 =?utf-8?B?cjZkaDZpbDU3bTFFd2g5dmhQMzBVSTg5b2pqbE15bVBWRXFhNTcyMm9VNURL?=
 =?utf-8?B?ei9SbW1yc0VwOE5UclJPR2lVWHV4ei9XY2NDSlU0YytxcTVLbHNhbU9Tc29P?=
 =?utf-8?B?RXRtTERLQzZpeUpOVE5MMFNyRWhmS1VqNHJBbW90d3hJQk9UNGZRYktYY3di?=
 =?utf-8?B?Y0YzZjM0TVhqSitvL29WS0xIL2Z6RzgxWTMvUHpiaG8reXVrd3lyZnl2M0xO?=
 =?utf-8?B?ZzJCTjRHTWx2T1MvVzZJTlN1cURRT1ptSzJaV0tUSWVyNzkyTlRuNk1OMXQx?=
 =?utf-8?B?KzdRbHZoTXVrZ2lTb2RZTXVvR1U0Q3V5bnIwSVdQd1MzdFpqR0Z4bFpES1Y0?=
 =?utf-8?B?dkFVdUVYQ0gvSGNrQ25XK1ZZWElFRnZkWTRDREo1SVUyMU1KZEtlOXl6ZWpy?=
 =?utf-8?B?RjV1NU9XemxYTTJOd0NNNUFzcURpLzdqZjIxL1A0TnF5bDN6MWEvclZEOVl6?=
 =?utf-8?B?a2VDcjJuVDh5QWE0b0o5RVZONDNBQ0tiVFdCaytSWjFyOWVML0QzZzEzYnhz?=
 =?utf-8?B?a1F0anhoMHdKZldJU1JKZjFwcDhDRHZ4aDlRVW1Rc0RRYlJYLzNKWTJ2NmJt?=
 =?utf-8?B?NXo4eVdVaGNxM3k2eUUzM002bmduTnIzN0xRT2JRSHJ6OXRDbDlrdkVzOGVQ?=
 =?utf-8?B?OGd1RWFPTE16cmZLK2RQelg1Sk5Vc0FheGJIbmVYRlN2NzlmdmtaSXQyTDdo?=
 =?utf-8?B?dzVGQjEySkVxWHVucnd5V0ZTNkl2aHNXM2I4bGtSV3FhL3BOMnN4ZUV3SkNF?=
 =?utf-8?B?Qy9DQkt5NWVZZk5FZjl1aEFidnA5N2kwWk40S1RMMUppeHpUeEJ6RVRSS0JD?=
 =?utf-8?B?L2MzZXdNbGY3WGxRUnV2NEhENG1tYUNpY0tMNWRQZE9YNGFFeUhqN2dPZGJi?=
 =?utf-8?Q?YKfL3E?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bENCalJoRmdNMWNyOHR6TWQrU3B6dStMNGpBZE9KdC9WR05FRUVCQ3JoanRK?=
 =?utf-8?B?NDR5OCtoQWtyY3V1cUF5dGZlQjlPQXVVVmFTRjBUazFIbk9tTlZXRGpYdU1s?=
 =?utf-8?B?cHdEOXQ0Sm0xa2wvTVJHMzlTRUNsVHd0SmZLNE5TNzRqcFV2ZWR2WXArQi83?=
 =?utf-8?B?TGIyMklYcFB3NENVeDgrZ1VOVXVKenUwRmlDcUF4ZzdqdUtUYjFZbjNjamVC?=
 =?utf-8?B?eGsxRWZYY0FsN2hpVjhmZDdiZTB2ejkwYy9lSm9nNDVuV0JPdE90em5GYlJx?=
 =?utf-8?B?V2wvTURLcFE4VkF6N2VaZFJaRENUZXpNK1RmTkVJQkZqS1E0VDBNZS9nOW5Y?=
 =?utf-8?B?OU04K0REY3U5SCt3V1R2S0tRam5jdXVrK3VYc2g2YlpwLzVjNzl2eVF4eWFr?=
 =?utf-8?B?cURpbEtnYWdYZW1OaVI4c2VER3VaYUNrNmtuMXFzS2lCeHlSWkZ1U2NycmRR?=
 =?utf-8?B?azhiVTQwL3NVaUtiRDhGTzB1Sm1UbmpWZ1RBdWl2K01MZVVyRkJMRzZEcHlT?=
 =?utf-8?B?QlFJdy9MYW1nTVF6QlI4d0ZyTDZaVWY3M2xqS3V0cFFsL21kRVFxdEQ5b3Rr?=
 =?utf-8?B?NXJJZEpFYWEvejhDcDJjbUYrMEcyVEhPTEdCUXIvTUJDdnlibWZyWkNhQ0gy?=
 =?utf-8?B?b0FmdTdLMFp6Q1g5NEVQMUFNZCtrME8rNkllQ3VocWpiSk9oY0NnanJRdFla?=
 =?utf-8?B?VE82UDVMVnNIY0tNSzMxazloZ1poZC80Q3lGMVhUNHF3akdLVDFBRUxNTllx?=
 =?utf-8?B?dThSNmdjcjBkRng4dGJDQmlGOFNZWlJ2Wm5sVEtkNkY5N0ZOWkxpZnBZRElu?=
 =?utf-8?B?c0k5ZHhhMGpRbzVmanpYb0lIUk56OUt6bGN0RnhleDJ1YTF3QXBQcXJENG5o?=
 =?utf-8?B?dGttQ0d0elZiUFFvaGdZR3RPK29HbjQ3dFdOZ3RRZWRVbW5QZm43eXJwTTI3?=
 =?utf-8?B?bmNxOVpnZThEQ1N0RmNtdk55bmgrL3pDUnBUbVdlUVNOaGJKZ1FqcitSQnp2?=
 =?utf-8?B?Vm9RdnV4SUM2L2hFSFRtQXEvRTJSYnNhcHJ4OFdONzgrQ1luQUx3bXF6bG5C?=
 =?utf-8?B?SndLYUs4eDcyOWMzZHJnMEpDYzhnWnhDelM3OUk4bi9xZTBjV2tYUUg0YVMz?=
 =?utf-8?B?WTRZeG80UElyYTRoYXVCN0ZneDZVSVpWd3djZW5ENkJ3QUIrUStUNnNGc1Nu?=
 =?utf-8?B?cGw4UHNDMFJwOGV1aDJ3Q2pDckIrVXlBUndiOTV2NkszYWcrZnI4VzdRVVlQ?=
 =?utf-8?B?cnpYcWZkbE9OMXJKNlg3NmFCUG1LQzlZWHl5L2o5cVhET3h5MmpDSUVqazRk?=
 =?utf-8?B?Yy9RM2w2NE1zZFVnYlJUeTQ3MlllcFpGOTcxVnc5Yk15VUJFdXhPdThwdDBE?=
 =?utf-8?B?N091SkRZbmFpang4dUpjQUFBYWtBM2pJVkJNUmpRWVpBZ0NCSURTaktjZU04?=
 =?utf-8?B?ZGxUc21zTWxTeHBWejlzM3dadmlYOXovR2dOTkl3TkIwUnZzY2k5RHBtd1dv?=
 =?utf-8?B?d0lmQlI3Wmc4UjE5T2lCSVhMcDNuMzRGRUNUWEI5REMvTWxKT2Y0Q0QrN0xF?=
 =?utf-8?B?Z0QrN3NyUzE2a3d6Zys0U0RVRzh5OXVEN3d5L0g2L0FjeTltQXJaYS9EYVV1?=
 =?utf-8?B?VWlvek5ZZjdubDBMVTE0TXZpbnFlVkJvVjdNanJRSTk5bHpic0phMWloa0lO?=
 =?utf-8?B?SGl6WXlJQk5NTlVpaktpTTBMUGR1ZjlESDVuUEJQZmQyRFYvcCtCRGhWR0xo?=
 =?utf-8?B?eHpoYlZPd3Q0TjVUckRJTk5hL0ZwbEMvWUxRVXJoSlg5eDFNZk10OFJTa1lm?=
 =?utf-8?B?OHc1UUdObDFhekN1Q3VJMGVMcjFSMXFCK01ubXpqY3JHQVg0MCtpN0VDYzNk?=
 =?utf-8?B?S3ZHUnpWRjRVK3Zla3FleDJxYm5qamkvb0ltZ1FyUVBFRHVMRmt6QnpvbmNH?=
 =?utf-8?B?OFdxWlRweWFKWWw1UW1XWEpIbHh0bG5MQlcrZGdGT2dZbzRyTnFVY2gzNzlj?=
 =?utf-8?B?V1J3SzNYdE0xUTMzaG1Qb0ZBQzlkN0RsOGtmNS9iaHNqbVNaY21kWkh3eERX?=
 =?utf-8?B?bjFXUlRmS2NyT09pbHM5Uk5jRUNYU29kZkpZNHJuaWJIaGsxbjZudDhwN1Y1?=
 =?utf-8?B?YmF2aXJ4TU5FZTBGQ0FzNklkUHhZZkp2ZGVNRzBoZ1hDdEFFelZQcGVsUE5n?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba081b0-25a0-4be7-3166-08de0c4ee98e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 00:56:59.8537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvM6bQT7VzNmtMJTgUg29cZ/8brjeaM7VEJjSp0JZ11jDgTaxhghzxd+qzxRLrgUpmyqB/EBJPKdY6z1GDPM8gJexEedYp18STlYJ1pLaWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7192
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciAxNSwgMjAyNSAzOjM2IFBN
DQo+IFRvOiBZb3NyeSBBaG1lZCA8eW9zcnkuYWhtZWRAbGludXguZGV2Pg0KPiBDYzogU3JpZGhh
ciwgS2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT47IGxpbnV4LQ0KPiBr
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IGhhbm5lc0BjbXB4Y2hn
Lm9yZzsNCj4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2NDJAZ21haWwuY29t
Ow0KPiByeWFuLnJvYmVydHNAYXJtLmNvbTsgMjFjbmJhb0BnbWFpbC5jb207DQo+IHlpbmcuaHVh
bmdAbGludXguYWxpYmFiYS5jb207IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IHNlbm96
aGF0c2t5QGNocm9taXVtLm9yZzsgc2pAa2VybmVsLm9yZzsga2Fzb25nQHRlbmNlbnQuY29tOyBs
aW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEub3Jn
LmF1Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtl
cm5lbC5vcmc7DQo+IGViaWdnZXJzQGdvb2dsZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBBY2Nh
cmRpLCBLcmlzdGVuIEMNCj4gPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47IEdvbWVzLCBW
aW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsNCj4gRmVnaGFsaSwgV2FqZGkgSyA8
d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGgNCj4gPHZpbm9kaC5nb3Bh
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEyIDIyLzIzXSBtbTogenN3YXA6
IHpzd2FwX3N0b3JlKCkgd2lsbCBwcm9jZXNzIGENCj4gbGFyZ2UgZm9saW8gaW4gYmF0Y2hlcy4N
Cj4gDQo+IE9uIFdlZCwgT2N0IDE1LCAyMDI1IGF0IDM6MjTigK9QTSBZb3NyeSBBaG1lZCA8eW9z
cnkuYWhtZWRAbGludXguZGV2Pg0KPiB3cm90ZToNCj4gPg0KPiA+IE9uIFdlZCwgT2N0IDE1LCAy
MDI1IGF0IDEwOjE1OjEyUE0gKzAwMDAsIFNyaWRoYXIsIEthbmNoYW5hIFAgd3JvdGU6DQo+ID4N
Cj4gPiBJIGFtIGFnYWluc3QgaW5jcmVhc2luZyB0aGUgc2l6ZSBvZiBzdHJ1Y3QgenN3YXBfZW50
cnkuIE9uIHg4Nl82NCwgdGhlcmUNCj4gPiBpcyBhIDMgYnl0ZSBob2xlIGFmdGVyICdyZWZlcmVu
Y2VkJy4gV2UgY2FuIHRlY2huaWNhbGx5IHVzZSB0aGF0LA0KPiA+IGFsdGhvdWdoIHRoZSBub2Rl
IGlkIGlzIHVzdWFsbHkgYW4gaW50LCB3aGljaCBpcyA0IGJ5dGVzIG9uIHg4Nl82NC4NCj4gPg0K
PiA+IEluIHByYWN0aWNlLCBJIHRoaW5rIDIgYnl0ZXMgKGkuZS4gc2hvcnQpIHNob3VsZCBiZSBl
bm91Z2gsIGJ1dCBpdCB3aWxsDQo+ID4gYmUgdWdseSB0byBjYXN0IHRoZSBub2RlIGlkIHRvIGEg
c2hvcnQuIFdlIHNob3VsZCBhdCBsZWFzdCBXQVJOIG9uDQo+ID4gb3ZlcmZsb3cuDQo+IA0KPiBD
YW4gd2UgcGFjayBsZW5ndGggYW5kIHJlZmVyZW5jZWQgdXNpbmcgYml0IGZpZWxkcz8gSSBhc3N1
bWUNCj4gY29tcHJlc3NlZCBsZW5ndGggY2Fubm90IGV4Y2VlZCAyXjMxIC0gMT8gOikNCj4gDQo+
IFNvLCBzb21ldGhpbmcgYWxvbmcgdGhlIGxpbmUgb2Y6DQo+IA0KPiBzdHJ1Y3Qgew0KPiAgICAg
dW5zaWduZWQgaW50IGxlbmd0aDozMTsNCj4gICAgIGJvb2wgcmVmZXJlbmNlZDoxOw0KPiB9DQo+
IA0KPiBUaGF0IHdheSwgd2Ugc2F2ZSB1cCBhbm90aGVyIDQgYnl0ZXMgaG9sZSwgd2hpY2ggY2Fu
IGJlIHJlcHVycG9zZWQgZm9yDQo+IHRoZSBub2RlJ3MgaWQuDQo+IA0KPiBEb2VzIHRoYXQgd29y
az8gSSdtIG5vdCB2ZXJ5IGV4cGVyaWVuY2VkIHdpdGggdGhpcyBtYWdpY2tlcnkgLSBwbGVhc2UN
Cj4gZmFjdCBjaGVjayBtZSA6KQ0KPiANCj4gDQo+ID4NCj4gPiBPciB3ZSBjYW4gdGFrZSB0aGUg
c2ltcGxlIHJvdXRlIGFuZCBkcm9wIHRoZSBidWxrIGFsbG9jYXRpb24uDQo+IA0KPiBPciB0aGlz
IDopDQoNClRoYW5rcyBOaGF0IGFuZCBZb3NyeSwgZm9yIHNoYXJpbmcgdGhlc2UgY29uc3RyYWlu
dHMgYW5kIGlkZWFzLg0KU3VyZSwgSSB3aWxsIHNlZSBpZiBJIGNhbiB1c2UgdGhlIGJpdCBmaWVs
ZHMgYXBwcm9hY2ggYW5kIHdpbGwgbWFrZSBzdXJlDQp0byBub3QgaW5jcmVhc2UgdGhlIHNpemUg
b2Ygc3RydWN0IHpzd2FwX2VudHJ5LiBJZiB0aGlzIGRvZXNuJ3Qgd29yaw0KZm9yIHNvbWUgcmVh
c29uLCB3ZSBoYXZlIHRoZSBzaW1wbGUgcm91dGUuDQoNCkJlc3QgcmVnYXJkcywNCkthbmNoYW5h
DQo=
