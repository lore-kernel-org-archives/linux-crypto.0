Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8752AC17;
	Fri,  4 Jul 2025 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751664952; cv=fail; b=UFdA5luhB1Z/NMWkZiCaoP9WRyWxwHNQUdKJ1MHZ1uOQFfJpSmwfkJnd3EQRgnfbK/F7SXuUUy/Buoq9aT1a6WZrXbCCq1vf2Ek1ZBdp63eU0p5vn+QeRPma7m5PDc9Vous1VJu8/vkYwPU6wD+BEFYopEgGVcu2aHCO81JDHjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751664952; c=relaxed/simple;
	bh=AvjqF2XnmBtzCX9IWp/brBaQPn2aegrAHQ8sScFsdFo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gTlypZWsL5VzdBQ7+Q56WsOZHVspp/3xQHOGyAgKs41ha8bT9HgGJrwBnprota0eAX8kTnqugFs2fIOjtZ5oRhXNxTq1TL7sR2YUH26ZMkzmykk3k8DSYdQQ43Ym5U+vHkiymyeQltspjKL6zH7coUEe0/1Nrd/YPLuTwe/N96M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dpWqWGIC; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dpWqWGIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751664950; x=1783200950;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AvjqF2XnmBtzCX9IWp/brBaQPn2aegrAHQ8sScFsdFo=;
  b=dpWqWGICwGjoy8NadfTh0MCXNQ94GfHQbMmDHsYnYMr0KI5f2nGujuv0
   jWYCLZ2jWI9kZjdLvQnAyduIL6jlpD3dWrzlN7NtCaLSTnP77+NleFx1V
   c9fgx1zhqU70yd6U1QAH5lrOqsvpeq5dJGkLj7mTCcaqNyChjElTM0dAc
   08OEg/gnrZjFWOtKUMdZHWn7ST1aJx5mN+DLQJYXFcxMQ35dnA5JHsLO9
   wZCoMx+w4MsATPVHpvZbORI7tzfh/okeL5dpzhqPmgx6Tw9Cv/9hae9xa
   ZdPavoR9bG47zlEBff3FobLFRNDB+CMN1VnU04Tg0JQFAw3Z+lxU4xdxz
   w==;
X-CSE-ConnectionGUID: vUYTEFTwSi27ft4b9d+hdA==
X-CSE-MsgGUID: dX+JhWzDTOSSbFvYlbFFlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11484"; a="64684454"
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="64684454"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 14:35:49 -0700
X-CSE-ConnectionGUID: fEbUaPULTVKMOJXseJHf4g==
X-CSE-MsgGUID: shrLLgH8RTO8rkb9Umyp+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="158982477"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 14:35:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 4 Jul 2025 14:35:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 4 Jul 2025 14:35:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 4 Jul 2025 14:35:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Al8ZD+VAV8OzeUdmZL3S1KOgbggMemjSZHDhh0LXeRkcscZQLpMJV1FqK3AUZP0shfZkRHfR40+jrvTt5KZYHzJnU0dIGbeq0zjIfjmWl/5rDqUPXiL6b3PKLTyl0fRd1IuSMCK0O8cQ03j+YsVG7roI/pIcIEIoRNu/OdklG4yihjQqlmZcCcdxTGQKRq78wE/iFPWsulDiOmEf4q5Q7337O+E7vAgp0k7w4Wf7gzSeM+vcc7Q8zf/HKy2FwYF1BHJN4XsrAPUbhIIkuHr4JD39xEA1vWOoduu0Qr4K+yEMdhAHWli3TrYb3JEdHb0RUEGXdlPuIPo/Nz+sORLu2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvjqF2XnmBtzCX9IWp/brBaQPn2aegrAHQ8sScFsdFo=;
 b=kTIgnlQOLIha7FnPFCfpVEgmRRm4MkMg80Gi/Jc/naHw+v/UZzI6AAPS5GKl1rTS/1RqdAHOD8oIeFdWPkIuxscNteaZB2lsI+8mwAqtj4pIvVJ06fWMmcLVTaxwAWaHO4uoxTxqteMfoVBykjkxvgHlSltKSzGy3UU4kvKhwqUqZz0TzJuK7MQZODxPNM89MYGDMDmVxVK+SuxILtBNhXT887bux1Erc9+Oe4FC9Nj5AfGYaCeEZg6mwLOT1GNhEYd8N9I+hGq1WMpSAzlA6nRZuvIzzFMuDjkPnfDcvpkp/VY4qZasz5ovEfghZqXnTVKuQbbq5yy5WesIDOIEqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by CO1PR11MB4866.namprd11.prod.outlook.com (2603:10b6:303:91::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Fri, 4 Jul
 2025 21:35:03 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%4]) with mapi id 15.20.8880.034; Fri, 4 Jul 2025
 21:35:03 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v10 20/25] mm: zswap: Move the CPU hotplug procedures
 under "pool functions".
Thread-Topic: [PATCH v10 20/25] mm: zswap: Move the CPU hotplug procedures
 under "pool functions".
Thread-Index: AQHb7Jtpjos3HeOkgke8yNmovnahzbQiTLsAgAAvMzA=
Date: Fri, 4 Jul 2025 21:35:03 +0000
Message-ID: <PH7PR11MB8121875CD899E434C81DAABEC942A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
 <20250704042323.10318-21-kanchana.p.sridhar@intel.com>
 <CAKEwX=PFJzc0pErjMcfeeheGL8u4GWMu2yr-iqWmFvYMKfT3fg@mail.gmail.com>
In-Reply-To: <CAKEwX=PFJzc0pErjMcfeeheGL8u4GWMu2yr-iqWmFvYMKfT3fg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|CO1PR11MB4866:EE_
x-ms-office365-filtering-correlation-id: 01e52b6f-1ee7-4838-deed-08ddbb42a2eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a1k1NkV0b3dPclhlNU84WVdxZnh2Uk1zWGNWZEwwOXAvcW5tZ2dnUFhuTll4?=
 =?utf-8?B?VENBRHNsdTVnWTFnZTc0Um9wRU5JUkpkeU9CVWtJK1ZTV0lCeFQ3aExRZGlH?=
 =?utf-8?B?QXVQWHE3WkJRcGw1dE5udzJIM3Y1NnFqd3VqSVdNUUd4d0hkMkxXT3BtcFA3?=
 =?utf-8?B?RnFueGRQQlk0U0ZKSXA0ZzVQaEZWNzhobit2OXlvRjZkU084RW1OYUljNkF3?=
 =?utf-8?B?ZWszb3hNbER6cUtwZS9SbHcyY0s0VFpSb0FieW85Z3dzNGc2ZURQT0JURXBu?=
 =?utf-8?B?ZlpXNFJ6YU8xa2tadmFhL2dDYllzYnMyaUNRR3VEYmZqdDAwUVNHMTZFeTdR?=
 =?utf-8?B?bDFjb21FNzludmlPaGkva3pmS090ZHNiM2wwMVN0Y29XTGlJRDQ0akt5STVT?=
 =?utf-8?B?ZUhGVURZdklnOWxxZmRPa1VyYTBLTkFvL1krUk9HYThIVnFjOHIwcjh3TVAr?=
 =?utf-8?B?SjVLaWFZUzBiTlYwVlZvK3hnN2FOVU45cHIySnV1UHhyRXREZ3hxc2tFYnh6?=
 =?utf-8?B?clk5cXRlSmhYTFJGMldKR1k1ODF2QU1rTTlmMjZHTW0vT2pKSTc3WkJrdXVQ?=
 =?utf-8?B?d3VSS1ZqRENqZFdNeWZEVUNKUTBZcUJVeEtSSkZkdlozV05IOUg3bnhNT2tU?=
 =?utf-8?B?NVFMekVWYVJRTVQxRkhONXhzNjdSMUxEb3oxZEFGK1RySktzYjZFV0NhRXlT?=
 =?utf-8?B?RDR2Y3BHczQyTzlQUytOWTBvK2pxYzBoV0pEN0tqZG03N3k4YTdTVUs2dlFp?=
 =?utf-8?B?Z2Riazl3NURVSkMxSmRYTVRjTG02L2hJVHBDV3FIeUMyTUE1Yi94d3FUb2xq?=
 =?utf-8?B?blJCSlB3OGxFQWgrL0ZVVEJaTDNuQld1MVhoUjBjT2FjTXpsN3czSGJPaWdh?=
 =?utf-8?B?WEROaWExdjZFOERmTHdmeVVyZjRMN21wOVR1YnhGd2RTYzN0NlV5VEgxRlN6?=
 =?utf-8?B?TVJiWXNZWUVkWG5MV2pheEF5b08wVjR0c2hudVN0dXFadHpWb1pCMElsVE4r?=
 =?utf-8?B?dWwyd3QxdVVBd1lmanpwQjBwbzlGcXN0TlJieUx6ek5vSDk0bHkzY3kxa0xE?=
 =?utf-8?B?OFJYd29rRG5LTHVsSnZ3WnJBMWk2S3IrUFVSOUJFMGxDRXRKZUlJSUxHcE1W?=
 =?utf-8?B?VmM3VGpiMVF5ZFhjS09kemdiSHNPY044RnF3akZEaHloSjRiNTR4YTMrOHU3?=
 =?utf-8?B?VlZ1dUJqb3BNM21IRkZ3UG94a25jeXBBUWg4OTQ4RTVKTDNscnhJcEhaQVJp?=
 =?utf-8?B?VDlyVk1lRTRKK01rejhQRUJvUERraXFOUGdxQlMxbzdib3N1dlR4a2xDNWxK?=
 =?utf-8?B?VStITXdSRi95eXg0YVZYRDFxbE80RmtocWNDTk55Y1Q2QmVGejgrTXFmeEhn?=
 =?utf-8?B?b1RmcW8wWmdwOHBaeUp4cDhLclB4QllxQjdGMEhQdmFjWlorbFJaRy81a0c3?=
 =?utf-8?B?NHRaZnlrUXh6TTVpME1TT2ZOcURLb2lzT1JwcTFENTN6Z3RqY2MyZFhjQi9B?=
 =?utf-8?B?dnJGQ2liZUpqTjRKblF2NGtjenZqU24zVHA5TEppc0l6N3Y1Y01xenRMdTVp?=
 =?utf-8?B?T1ZMenBXNXpqSkhFc0pZbU90ekYxNXY1OS94RkRhTjVVTFhIK3VtYUNJUGtR?=
 =?utf-8?B?V2wzenE5RFFTeFFRYU1BRDNBM01jUUJtZTRyOTBFUGlOY2g3UXZNUmFvVzZM?=
 =?utf-8?B?bE85U3dOTFNuYUg2dFpzV2FaUFdMMC9DSlVqSlNMLzZhdVYvYmNkMHdOb3du?=
 =?utf-8?B?Nk1VR0dmVGV0Zi9hc1VrMDJ1SnA4Z2toaHdVWjA2VlliUTNDTkQ3NzNLR29h?=
 =?utf-8?B?Q2xVdGNncTRTSWlhdklBUmZkMGwrSlc0VTJqMm54SFNleWxOZGJVdjdaQStE?=
 =?utf-8?B?ejVHUHBKRmFMQTNQNDR5N1RuUXBTazlGRTZpRmxPeHVNTUFkOHhXTlVWK0dT?=
 =?utf-8?B?aWkzc25pUDIvdXFWUUZacUFQRnRjejU4OWVKN3d1eEo5ZVRlN09KSnp2eXp1?=
 =?utf-8?B?Mkx0NXF4QUxRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0Z0OFVJcnkrRzJ4V0ovVkJVam45ZWpxcXk4eFgxbDRaVFFQenp0S1JZL2pI?=
 =?utf-8?B?VnE3UmxZYVcrczBFN1BnUXVRKzZmVVBJck1IV0hBMVVrN0g3ZzVDVU5nUEdq?=
 =?utf-8?B?N1NPektiQ3F2R0FOVDNoaEFCS1NLd2xNTXVoTEduaVZxeFNVaXV1SXlkRGNM?=
 =?utf-8?B?NWRIanVVLzRiSVpwNy9idXBYcFAxMFN0UFNGSHRBd0Rjc0s0bi9uSVNYRFZs?=
 =?utf-8?B?K2ZLak4vZmZSYWE5TThzMVJRV1d6ckx5SFI1bzVDVDRaOTJEeXZpSUsxZEpI?=
 =?utf-8?B?TXBuMXpoQ25PV2p3eWxXcVIyZFBaT0d2aVFsbzVJNFlCNmdFbC9NUlovWmhr?=
 =?utf-8?B?WEdEUWhhaXJwM3RINVhmVmdMb1R5UG15dHZXYjlMcFRaL0Y2M2NxM3VQenpn?=
 =?utf-8?B?TEdGTnZBVlNKR0tuelJOK0d5ay9jcDl3endJNk16dFE4czNqTm5NRTYzcTdX?=
 =?utf-8?B?NU5qd0R6YnlDa25QdTJ0TFI3SGthYzIyR3U2em9BVHJDa2JtYlNKelRBY2Zx?=
 =?utf-8?B?Y212Wm1CTUNZYVRQU25OeTJ4bzF2OFNsU1pnZTFYbnFRQXpucnFQZC9SWUN3?=
 =?utf-8?B?M2Y1ajlhM0IxbWNxd3Zzekh1QzVFbE1icG5rL0FlTEpQbERNcFRwaU9DN1Nj?=
 =?utf-8?B?cElmU2ZoMnl2KzZnb2tKVFJIblhkQXgxMWVmY3JVUExMcWlFVWNCQ0FmZmNj?=
 =?utf-8?B?YlJrSUN5c0NoUEkvUVYvRXMwVFpKNzRlNXZYZDRuTnZlemdNcVZTYUgzZTZq?=
 =?utf-8?B?MTJoVEZmbS9IZThUd3Zhdml4Q2F5V1E5b1FoQ2pwZTdielU1aE9uVFN1SDJK?=
 =?utf-8?B?UFJwN2RKNlpNNENXRmU0azdWcVZVWW85THl4ZTVXSEp0UkEvMFhlbU03SmFn?=
 =?utf-8?B?dGs1K2c4amcrcVRTb2FvVDVBNzExaDIyaTJlU1FibWtweG1MWjA2UDZqWVR3?=
 =?utf-8?B?RTFXMUFpRnNzdmNpcTBCWElIeXhSZ3pVSFp2dEJWSUtybU5HQUQ0bnlVUjRz?=
 =?utf-8?B?UDR5bW90cVBNZ2h1Y2J5bEl5TXVUZ1VBR0YyeVhXT21nWmZHYTZ4YWZ1cUMx?=
 =?utf-8?B?alRmbG9URVptZUhKV09WNllVQXIvSSswem5QMnFLQ0tRZDRqYkVnZE9kQ3Z3?=
 =?utf-8?B?aDNnUHFpY0ZPS0RzZ0dld09DQ1FDTnJ6YkYrUkg3Z1AzR1pEVUROYXJRZEIx?=
 =?utf-8?B?QnhhUDkrQnVnUEFvSzFkbU51aytDREJ6NFRYN05oOWM4NUNQRWZUcXd2Rklt?=
 =?utf-8?B?Qi9WdEo3S3FTa050ZFZ2cCtnZ1RORkkyMy9EdVNPb0RqVEFDM3VZU3dLZ283?=
 =?utf-8?B?c2YxbWQ2QWQ5eFJiUGRRMGFMRDM5VXBsLy9YdXRSV2xjcjRENjhhbHRnK0hQ?=
 =?utf-8?B?VWxyK052Zmo2L09kWkpaeVlKM3drbURROHF4bXd0UUk5d2ZRTElOZUhWL3VZ?=
 =?utf-8?B?eDlEM25aRitMUDZ5QXpSUEVmcWV3a0l1dUpnUW9GOTBNemR5Mm9iSzk0Z2ZN?=
 =?utf-8?B?OFpJTEd5eS9jK0NycE5aa1QveU9Lei9vL3hlUmdKdGFXMUR6c3J3NGc2d1hN?=
 =?utf-8?B?LzlDUXk2bkZ4VlU2ZmJQOEF5Nm13VEFWTWtCTks3WDlHTjdjM09qLzZURVp6?=
 =?utf-8?B?d1JsUUpldWZ0WjJab05DTVNIQU1ocG55NzExMThOSTRWamhNY0VjbkRoWlNx?=
 =?utf-8?B?MDFPQkJmbWRMMzN0SkNGVEdmeXlRR2s0ME1MSmhXUm5oQ3BsWjdtMWdLdXNv?=
 =?utf-8?B?dTBPbHJueWdZTlEvdDA2cUxjMnoxc0RiN3VPOFhRajFvb0xKU0VER3pEMnoz?=
 =?utf-8?B?bEhKeVJhZkdHbitOUWlqclh1STBwTkZFeUpiMHBOak11SUdzeUJUQkpzallz?=
 =?utf-8?B?RWJqYmlaSVQxb0xSV3Fudm8wNEMwWlRBTHhOamJxTHVEWExxaUxiS3luejI3?=
 =?utf-8?B?VnRJM0F4Zm5VN2N1a2IxTFpLTUxWTVZSN3ZZT3h1OWZ5VmVIaUJCRHJPOVNJ?=
 =?utf-8?B?eWlVOGNXdVBMM09kMTQ0czRaMU9oOGFkSlJuUTREK2lsb1RKaVN6NXFZWFl5?=
 =?utf-8?B?TldPNk8yejZpN2VzL012WVNySkljeGRqVXpNdTI4SkxBWkVVYzRKOVM1cVM3?=
 =?utf-8?B?OE1rQmE5Y1pXUUpDT2dZSDdoSTA2U1pBTEtSSDd5Z3lIb3p4QXFhM0w3em5L?=
 =?utf-8?B?bm5YbVU4OU5rUXowYy9uWlV6emU1NUk0VmtJNDZpMHlQdmZCZ0pqN1lNUE82?=
 =?utf-8?B?MzIyTUFXaHZYRXNhSEtLUWo0T0NBPT0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e52b6f-1ee7-4838-deed-08ddbb42a2eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2025 21:35:03.1944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wp2p+5Ubdv1GE2MKuJR/RJi2uhLzP0U3KC7C27c9myb0spdZ4v2h/epPE+4RVC7IaPmjfyUWGVYsqumtrpNMuBF1sAj1g8hoyaLiXAYo8f4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4866
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSnVseSA0LCAyMDI1IDExOjM5IEFNDQo+IFRv
OiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0KPiBD
YzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0KPiBo
YW5uZXNAY21weGNoZy5vcmc7IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpob3VA
bGludXguZGV2Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNAYXJtLmNv
bTsgMjFjbmJhb0BnbWFpbC5jb207DQo+IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207IGFr
cG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGlu
dXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5l
bC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRp
LCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEdvbWVzLCBWaW5p
Y2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8d2Fq
ZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3BhbEBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEwIDIwLzI1XSBtbTogenN3YXA6IE1vdmUg
dGhlIENQVSBob3RwbHVnDQo+IHByb2NlZHVyZXMgdW5kZXIgInBvb2wgZnVuY3Rpb25zIi4NCj4g
DQo+IE9uIFRodSwgSnVsIDMsIDIwMjUgYXQgOToyM+KAr1BNIEthbmNoYW5hIFAgU3JpZGhhcg0K
PiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBUaGlzIHBh
dGNoIG1lcmVseSBtb3ZlcyB6c3dhcF9jcHVfY29tcF9wcmVwYXJlKCkgYW5kDQo+ID4genN3YXBf
Y3B1X2NvbXBfZGVhZCgpIHRvIGJlIGluIHRoZSAicG9vbCBmdW5jdGlvbnMiIHNlY3Rpb24gYmVj
YXVzZQ0KPiA+IHRoZXNlIGZ1bmN0aW9ucyBhcmUgaW52b2tlZCB1cG9uIHBvb2wgY3JlYXRpb24v
ZGVsZXRpb24uDQo+IA0KPiBIbW0gaWRrLCAiY29tcHJlc3NlZCBzdG9yYWdlIiBzZWN0aW9uIHNl
ZW1zIGZpdHRpbmcgZm9yDQo+IHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKSBhbmQgenN3YXBfY3B1
X2NvbXBfZGVhZCgpLg0KPiANCj4gSXMgdGhpcyBwYXRjaCBuZWNlc3Nhcnk/DQoNCk5vdCB0b28g
c3VyZS4gSSB3YXMgbW92aW5nIGl0IHRvIGJlIGluICJwb29sIGZ1bmN0aW9ucyIgYmVjYXVzZSB0
aGUNCm5leHQgcGF0Y2ggIzIxIG1ha2VzIHRoZSBhc3NvY2lhdGlvbiBiZXR3ZWVuIHRoZSBhY29t
cF9jdHggcmVzb3VyY2VzJw0KbGlmZXRpbWUgdG8gYmUgZnJvbSBwb29sIGNyZWF0aW9uIHRvIGRl
bGV0aW9uLCBhbmQgYWxzbyBkb2VzIG5vdCByZWdpc3Rlcg0KYSB0ZWFyZG93biBjYWxsYmFjay4g
SSBjYW4gbW92ZSB0aGUgenN3YXBfY3B1X2NvbXBfcHJlcGFyZSgpDQphbmQgbW9kaWZpY2F0aW9u
cyBiYWNrIHRvICJjb21wcmVzc2VkIHN0b3JhZ2UiIGlmIHlvdSB0aGluayB0aGF0J3MNCndoZXJl
IGl0IGJlbG9uZ3MuDQoNClRoYW5rcywNCkthbmNoYW5hDQoNCj4gDQo+ID4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBLYW5jaGFuYSBQIFNyaWRoYXIgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+ID4gLS0tDQo+ID4gIG1tL3pzd2FwLmMgfCAxODggKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDk0IGlu
c2VydGlvbnMoKyksIDk0IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL21tL3pz
d2FwLmMgYi9tbS96c3dhcC5jDQo+ID4gaW5kZXggM2MwZmQ4YTEzNzE4Mi4uMzUzOGVjYWVkNWUx
NiAxMDA2NDQNCj4gPiAtLS0gYS9tbS96c3dhcC5jDQo+ID4gKysrIGIvbW0venN3YXAuYw0KPiA+
IEBAIC0yNDgsNiArMjQ4LDEwMCBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCB4YXJyYXkNCj4gKnN3
YXBfenN3YXBfdHJlZShzd3BfZW50cnlfdCBzd3ApDQo+ID4gICoqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKiovDQo+ID4gIHN0YXRpYyB2b2lkIF9fenN3YXBfcG9vbF9lbXB0eShzdHJ1
Y3QgcGVyY3B1X3JlZiAqcmVmKTsNCj4gPg0KPiA+ICtzdGF0aWMgaW50IHpzd2FwX2NwdV9jb21w
X3ByZXBhcmUodW5zaWduZWQgaW50IGNwdSwgc3RydWN0IGhsaXN0X25vZGUNCj4gKm5vZGUpDQo+
ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCB6c3dhcF9wb29sICpwb29sID0gaGxpc3RfZW50cnko
bm9kZSwgc3RydWN0IHpzd2FwX3Bvb2wsIG5vZGUpOw0KPiA+ICsgICAgICAgc3RydWN0IGNyeXB0
b19hY29tcF9jdHggKmFjb21wX2N0eCA9IHBlcl9jcHVfcHRyKHBvb2wtDQo+ID5hY29tcF9jdHgs
IGNwdSk7DQo+ID4gKyAgICAgICBzdHJ1Y3QgY3J5cHRvX2Fjb21wICphY29tcCA9IE5VTEw7DQo+
ID4gKyAgICAgICBzdHJ1Y3QgYWNvbXBfcmVxICpyZXEgPSBOVUxMOw0KPiA+ICsgICAgICAgdTgg
KmJ1ZmZlciA9IE5VTEw7DQo+ID4gKyAgICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICAg
IGJ1ZmZlciA9IGttYWxsb2Nfbm9kZShQQUdFX1NJWkUgKiAyLCBHRlBfS0VSTkVMLA0KPiBjcHVf
dG9fbm9kZShjcHUpKTsNCj4gPiArICAgICAgIGlmICghYnVmZmVyKSB7DQo+ID4gKyAgICAgICAg
ICAgICAgIHJldCA9IC1FTk9NRU07DQo+ID4gKyAgICAgICAgICAgICAgIGdvdG8gZmFpbDsNCj4g
PiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICBhY29tcCA9IGNyeXB0b19hbGxvY19hY29t
cF9ub2RlKHBvb2wtPnRmbV9uYW1lLCAwLCAwLA0KPiBjcHVfdG9fbm9kZShjcHUpKTsNCj4gPiAr
ICAgICAgIGlmIChJU19FUlIoYWNvbXApKSB7DQo+ID4gKyAgICAgICAgICAgICAgIHByX2Vycigi
Y291bGQgbm90IGFsbG9jIGNyeXB0byBhY29tcCAlcyA6ICVsZFxuIiwNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHBvb2wtPnRmbV9uYW1lLCBQVFJfRVJSKGFjb21wKSk7DQo+
ID4gKyAgICAgICAgICAgICAgIHJldCA9IFBUUl9FUlIoYWNvbXApOw0KPiA+ICsgICAgICAgICAg
ICAgICBnb3RvIGZhaWw7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgcmVxID0g
YWNvbXBfcmVxdWVzdF9hbGxvYyhhY29tcCk7DQo+ID4gKyAgICAgICBpZiAoIXJlcSkgew0KPiA+
ICsgICAgICAgICAgICAgICBwcl9lcnIoImNvdWxkIG5vdCBhbGxvYyBjcnlwdG8gYWNvbXBfcmVx
dWVzdCAlc1xuIiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgIHBvb2wtPnRmbV9uYW1lKTsN
Cj4gPiArICAgICAgICAgICAgICAgcmV0ID0gLUVOT01FTTsNCj4gPiArICAgICAgICAgICAgICAg
Z290byBmYWlsOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgIC8qDQo+ID4gKyAg
ICAgICAgKiBPbmx5IGhvbGQgdGhlIG11dGV4IGFmdGVyIGNvbXBsZXRpbmcgYWxsb2NhdGlvbnMs
IG90aGVyd2lzZSB3ZSBtYXkNCj4gPiArICAgICAgICAqIHJlY3Vyc2UgaW50byB6c3dhcCB0aHJv
dWdoIHJlY2xhaW0gYW5kIGF0dGVtcHQgdG8gaG9sZCB0aGUgbXV0ZXgNCj4gPiArICAgICAgICAq
IGFnYWluIHJlc3VsdGluZyBpbiBhIGRlYWRsb2NrLg0KPiA+ICsgICAgICAgICovDQo+ID4gKyAg
ICAgICBtdXRleF9sb2NrKCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPiArICAgICAgIGNyeXB0b19p
bml0X3dhaXQoJmFjb21wX2N0eC0+d2FpdCk7DQo+ID4gKw0KPiA+ICsgICAgICAgLyoNCj4gPiAr
ICAgICAgICAqIGlmIHRoZSBiYWNrZW5kIG9mIGFjb21wIGlzIGFzeW5jIHppcCwgY3J5cHRvX3Jl
cV9kb25lKCkgd2lsbCB3YWtldXANCj4gPiArICAgICAgICAqIGNyeXB0b193YWl0X3JlcSgpOyBp
ZiB0aGUgYmFja2VuZCBvZiBhY29tcCBpcyBzY29tcCwgdGhlIGNhbGxiYWNrDQo+ID4gKyAgICAg
ICAgKiB3b24ndCBiZSBjYWxsZWQsIGNyeXB0b193YWl0X3JlcSgpIHdpbGwgcmV0dXJuIHdpdGhv
dXQgYmxvY2tpbmcuDQo+ID4gKyAgICAgICAgKi8NCj4gPiArICAgICAgIGFjb21wX3JlcXVlc3Rf
c2V0X2NhbGxiYWNrKHJlcSwgQ1JZUFRPX1RGTV9SRVFfTUFZX0JBQ0tMT0csDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjcnlwdG9fcmVxX2RvbmUsICZhY29tcF9jdHgt
PndhaXQpOw0KPiA+ICsNCj4gPiArICAgICAgIGFjb21wX2N0eC0+YnVmZmVyID0gYnVmZmVyOw0K
PiA+ICsgICAgICAgYWNvbXBfY3R4LT5hY29tcCA9IGFjb21wOw0KPiA+ICsgICAgICAgYWNvbXBf
Y3R4LT5pc19zbGVlcGFibGUgPSBhY29tcF9pc19hc3luYyhhY29tcCk7DQo+ID4gKyAgICAgICBh
Y29tcF9jdHgtPnJlcSA9IHJlcTsNCj4gPiArICAgICAgIG11dGV4X3VubG9jaygmYWNvbXBfY3R4
LT5tdXRleCk7DQo+ID4gKyAgICAgICByZXR1cm4gMDsNCj4gPiArDQo+ID4gK2ZhaWw6DQo+ID4g
KyAgICAgICBpZiAoYWNvbXApDQo+ID4gKyAgICAgICAgICAgICAgIGNyeXB0b19mcmVlX2Fjb21w
KGFjb21wKTsNCj4gPiArICAgICAgIGtmcmVlKGJ1ZmZlcik7DQo+ID4gKyAgICAgICByZXR1cm4g
cmV0Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHpzd2FwX2NwdV9jb21wX2RlYWQo
dW5zaWduZWQgaW50IGNwdSwgc3RydWN0IGhsaXN0X25vZGUNCj4gKm5vZGUpDQo+ID4gK3sNCj4g
PiArICAgICAgIHN0cnVjdCB6c3dhcF9wb29sICpwb29sID0gaGxpc3RfZW50cnkobm9kZSwgc3Ry
dWN0IHpzd2FwX3Bvb2wsIG5vZGUpOw0KPiA+ICsgICAgICAgc3RydWN0IGNyeXB0b19hY29tcF9j
dHggKmFjb21wX2N0eCA9IHBlcl9jcHVfcHRyKHBvb2wtDQo+ID5hY29tcF9jdHgsIGNwdSk7DQo+
ID4gKyAgICAgICBzdHJ1Y3QgYWNvbXBfcmVxICpyZXE7DQo+ID4gKyAgICAgICBzdHJ1Y3QgY3J5
cHRvX2Fjb21wICphY29tcDsNCj4gPiArICAgICAgIHU4ICpidWZmZXI7DQo+ID4gKw0KPiA+ICsg
ICAgICAgaWYgKElTX0VSUl9PUl9OVUxMKGFjb21wX2N0eCkpDQo+ID4gKyAgICAgICAgICAgICAg
IHJldHVybiAwOw0KPiA+ICsNCj4gPiArICAgICAgIG11dGV4X2xvY2soJmFjb21wX2N0eC0+bXV0
ZXgpOw0KPiA+ICsgICAgICAgcmVxID0gYWNvbXBfY3R4LT5yZXE7DQo+ID4gKyAgICAgICBhY29t
cCA9IGFjb21wX2N0eC0+YWNvbXA7DQo+ID4gKyAgICAgICBidWZmZXIgPSBhY29tcF9jdHgtPmJ1
ZmZlcjsNCj4gPiArICAgICAgIGFjb21wX2N0eC0+cmVxID0gTlVMTDsNCj4gPiArICAgICAgIGFj
b21wX2N0eC0+YWNvbXAgPSBOVUxMOw0KPiA+ICsgICAgICAgYWNvbXBfY3R4LT5idWZmZXIgPSBO
VUxMOw0KPiA+ICsgICAgICAgbXV0ZXhfdW5sb2NrKCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPiAr
DQo+ID4gKyAgICAgICAvKg0KPiA+ICsgICAgICAgICogRG8gdGhlIGFjdHVhbCBmcmVlaW5nIGFm
dGVyIHJlbGVhc2luZyB0aGUgbXV0ZXggdG8gYXZvaWQgc3VidGxlDQo+ID4gKyAgICAgICAgKiBs
b2NraW5nIGRlcGVuZGVuY2llcyBjYXVzaW5nIGRlYWRsb2Nrcy4NCj4gPiArICAgICAgICAqLw0K
PiA+ICsgICAgICAgaWYgKCFJU19FUlJfT1JfTlVMTChyZXEpKQ0KPiA+ICsgICAgICAgICAgICAg
ICBhY29tcF9yZXF1ZXN0X2ZyZWUocmVxKTsNCj4gPiArICAgICAgIGlmICghSVNfRVJSX09SX05V
TEwoYWNvbXApKQ0KPiA+ICsgICAgICAgICAgICAgICBjcnlwdG9fZnJlZV9hY29tcChhY29tcCk7
DQo+ID4gKyAgICAgICBrZnJlZShidWZmZXIpOw0KPiA+ICsNCj4gPiArICAgICAgIHJldHVybiAw
Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgc3RydWN0IHpzd2FwX3Bvb2wgKnpzd2FwX3Bv
b2xfY3JlYXRlKGNoYXIgKnR5cGUsIGNoYXINCj4gKmNvbXByZXNzb3IpDQo+ID4gIHsNCj4gPiAg
ICAgICAgIHN0cnVjdCB6c3dhcF9wb29sICpwb29sOw0KPiA+IEBAIC04MTgsMTAwICs5MTIsNiBA
QCBzdGF0aWMgdm9pZCB6c3dhcF9lbnRyeV9mcmVlKHN0cnVjdCB6c3dhcF9lbnRyeQ0KPiAqZW50
cnkpDQo+ID4gIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCj4gPiAgKiBjb21w
cmVzc2VkIHN0b3JhZ2UgZnVuY3Rpb25zDQo+ID4gICoqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKiovDQo+ID4gLXN0YXRpYyBpbnQgenN3YXBfY3B1X2NvbXBfcHJlcGFyZSh1bnNpZ25l
ZCBpbnQgY3B1LCBzdHJ1Y3QgaGxpc3Rfbm9kZQ0KPiAqbm9kZSkNCj4gPiAtew0KPiA+IC0gICAg
ICAgc3RydWN0IHpzd2FwX3Bvb2wgKnBvb2wgPSBobGlzdF9lbnRyeShub2RlLCBzdHJ1Y3QgenN3
YXBfcG9vbCwgbm9kZSk7DQo+ID4gLSAgICAgICBzdHJ1Y3QgY3J5cHRvX2Fjb21wX2N0eCAqYWNv
bXBfY3R4ID0gcGVyX2NwdV9wdHIocG9vbC0+YWNvbXBfY3R4LA0KPiBjcHUpOw0KPiA+IC0gICAg
ICAgc3RydWN0IGNyeXB0b19hY29tcCAqYWNvbXAgPSBOVUxMOw0KPiA+IC0gICAgICAgc3RydWN0
IGFjb21wX3JlcSAqcmVxID0gTlVMTDsNCj4gPiAtICAgICAgIHU4ICpidWZmZXIgPSBOVUxMOw0K
PiA+IC0gICAgICAgaW50IHJldDsNCj4gPiAtDQo+ID4gLSAgICAgICBidWZmZXIgPSBrbWFsbG9j
X25vZGUoUEFHRV9TSVpFICogMiwgR0ZQX0tFUk5FTCwNCj4gY3B1X3RvX25vZGUoY3B1KSk7DQo+
ID4gLSAgICAgICBpZiAoIWJ1ZmZlcikgew0KPiA+IC0gICAgICAgICAgICAgICByZXQgPSAtRU5P
TUVNOw0KPiA+IC0gICAgICAgICAgICAgICBnb3RvIGZhaWw7DQo+ID4gLSAgICAgICB9DQo+ID4g
LQ0KPiA+IC0gICAgICAgYWNvbXAgPSBjcnlwdG9fYWxsb2NfYWNvbXBfbm9kZShwb29sLT50Zm1f
bmFtZSwgMCwgMCwNCj4gY3B1X3RvX25vZGUoY3B1KSk7DQo+ID4gLSAgICAgICBpZiAoSVNfRVJS
KGFjb21wKSkgew0KPiA+IC0gICAgICAgICAgICAgICBwcl9lcnIoImNvdWxkIG5vdCBhbGxvYyBj
cnlwdG8gYWNvbXAgJXMgOiAlbGRcbiIsDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBwb29sLT50Zm1fbmFtZSwgUFRSX0VSUihhY29tcCkpOw0KPiA+IC0gICAgICAgICAgICAg
ICByZXQgPSBQVFJfRVJSKGFjb21wKTsNCj4gPiAtICAgICAgICAgICAgICAgZ290byBmYWlsOw0K
PiA+IC0gICAgICAgfQ0KPiA+IC0NCj4gPiAtICAgICAgIHJlcSA9IGFjb21wX3JlcXVlc3RfYWxs
b2MoYWNvbXApOw0KPiA+IC0gICAgICAgaWYgKCFyZXEpIHsNCj4gPiAtICAgICAgICAgICAgICAg
cHJfZXJyKCJjb3VsZCBub3QgYWxsb2MgY3J5cHRvIGFjb21wX3JlcXVlc3QgJXNcbiIsDQo+ID4g
LSAgICAgICAgICAgICAgICAgICAgICBwb29sLT50Zm1fbmFtZSk7DQo+ID4gLSAgICAgICAgICAg
ICAgIHJldCA9IC1FTk9NRU07DQo+ID4gLSAgICAgICAgICAgICAgIGdvdG8gZmFpbDsNCj4gPiAt
ICAgICAgIH0NCj4gPiAtDQo+ID4gLSAgICAgICAvKg0KPiA+IC0gICAgICAgICogT25seSBob2xk
IHRoZSBtdXRleCBhZnRlciBjb21wbGV0aW5nIGFsbG9jYXRpb25zLCBvdGhlcndpc2Ugd2UgbWF5
DQo+ID4gLSAgICAgICAgKiByZWN1cnNlIGludG8genN3YXAgdGhyb3VnaCByZWNsYWltIGFuZCBh
dHRlbXB0IHRvIGhvbGQgdGhlIG11dGV4DQo+ID4gLSAgICAgICAgKiBhZ2FpbiByZXN1bHRpbmcg
aW4gYSBkZWFkbG9jay4NCj4gPiAtICAgICAgICAqLw0KPiA+IC0gICAgICAgbXV0ZXhfbG9jaygm
YWNvbXBfY3R4LT5tdXRleCk7DQo+ID4gLSAgICAgICBjcnlwdG9faW5pdF93YWl0KCZhY29tcF9j
dHgtPndhaXQpOw0KPiA+IC0NCj4gPiAtICAgICAgIC8qDQo+ID4gLSAgICAgICAgKiBpZiB0aGUg
YmFja2VuZCBvZiBhY29tcCBpcyBhc3luYyB6aXAsIGNyeXB0b19yZXFfZG9uZSgpIHdpbGwgd2Fr
ZXVwDQo+ID4gLSAgICAgICAgKiBjcnlwdG9fd2FpdF9yZXEoKTsgaWYgdGhlIGJhY2tlbmQgb2Yg
YWNvbXAgaXMgc2NvbXAsIHRoZSBjYWxsYmFjaw0KPiA+IC0gICAgICAgICogd29uJ3QgYmUgY2Fs
bGVkLCBjcnlwdG9fd2FpdF9yZXEoKSB3aWxsIHJldHVybiB3aXRob3V0IGJsb2NraW5nLg0KPiA+
IC0gICAgICAgICovDQo+ID4gLSAgICAgICBhY29tcF9yZXF1ZXN0X3NldF9jYWxsYmFjayhyZXEs
IENSWVBUT19URk1fUkVRX01BWV9CQUNLTE9HLA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgY3J5cHRvX3JlcV9kb25lLCAmYWNvbXBfY3R4LT53YWl0KTsNCj4gPiAtDQo+
ID4gLSAgICAgICBhY29tcF9jdHgtPmJ1ZmZlciA9IGJ1ZmZlcjsNCj4gPiAtICAgICAgIGFjb21w
X2N0eC0+YWNvbXAgPSBhY29tcDsNCj4gPiAtICAgICAgIGFjb21wX2N0eC0+aXNfc2xlZXBhYmxl
ID0gYWNvbXBfaXNfYXN5bmMoYWNvbXApOw0KPiA+IC0gICAgICAgYWNvbXBfY3R4LT5yZXEgPSBy
ZXE7DQo+ID4gLSAgICAgICBtdXRleF91bmxvY2soJmFjb21wX2N0eC0+bXV0ZXgpOw0KPiA+IC0g
ICAgICAgcmV0dXJuIDA7DQo+ID4gLQ0KPiA+IC1mYWlsOg0KPiA+IC0gICAgICAgaWYgKGFjb21w
KQ0KPiA+IC0gICAgICAgICAgICAgICBjcnlwdG9fZnJlZV9hY29tcChhY29tcCk7DQo+ID4gLSAg
ICAgICBrZnJlZShidWZmZXIpOw0KPiA+IC0gICAgICAgcmV0dXJuIHJldDsNCj4gPiAtfQ0KPiA+
IC0NCj4gPiAtc3RhdGljIGludCB6c3dhcF9jcHVfY29tcF9kZWFkKHVuc2lnbmVkIGludCBjcHUs
IHN0cnVjdCBobGlzdF9ub2RlDQo+ICpub2RlKQ0KPiA+IC17DQo+ID4gLSAgICAgICBzdHJ1Y3Qg
enN3YXBfcG9vbCAqcG9vbCA9IGhsaXN0X2VudHJ5KG5vZGUsIHN0cnVjdCB6c3dhcF9wb29sLCBu
b2RlKTsNCj4gPiAtICAgICAgIHN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4ICphY29tcF9jdHggPSBw
ZXJfY3B1X3B0cihwb29sLT5hY29tcF9jdHgsDQo+IGNwdSk7DQo+ID4gLSAgICAgICBzdHJ1Y3Qg
YWNvbXBfcmVxICpyZXE7DQo+ID4gLSAgICAgICBzdHJ1Y3QgY3J5cHRvX2Fjb21wICphY29tcDsN
Cj4gPiAtICAgICAgIHU4ICpidWZmZXI7DQo+ID4gLQ0KPiA+IC0gICAgICAgaWYgKElTX0VSUl9P
Ul9OVUxMKGFjb21wX2N0eCkpDQo+ID4gLSAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+IC0N
Cj4gPiAtICAgICAgIG11dGV4X2xvY2soJmFjb21wX2N0eC0+bXV0ZXgpOw0KPiA+IC0gICAgICAg
cmVxID0gYWNvbXBfY3R4LT5yZXE7DQo+ID4gLSAgICAgICBhY29tcCA9IGFjb21wX2N0eC0+YWNv
bXA7DQo+ID4gLSAgICAgICBidWZmZXIgPSBhY29tcF9jdHgtPmJ1ZmZlcjsNCj4gPiAtICAgICAg
IGFjb21wX2N0eC0+cmVxID0gTlVMTDsNCj4gPiAtICAgICAgIGFjb21wX2N0eC0+YWNvbXAgPSBO
VUxMOw0KPiA+IC0gICAgICAgYWNvbXBfY3R4LT5idWZmZXIgPSBOVUxMOw0KPiA+IC0gICAgICAg
bXV0ZXhfdW5sb2NrKCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPiAtDQo+ID4gLSAgICAgICAvKg0K
PiA+IC0gICAgICAgICogRG8gdGhlIGFjdHVhbCBmcmVlaW5nIGFmdGVyIHJlbGVhc2luZyB0aGUg
bXV0ZXggdG8gYXZvaWQgc3VidGxlDQo+ID4gLSAgICAgICAgKiBsb2NraW5nIGRlcGVuZGVuY2ll
cyBjYXVzaW5nIGRlYWRsb2Nrcy4NCj4gPiAtICAgICAgICAqLw0KPiA+IC0gICAgICAgaWYgKCFJ
U19FUlJfT1JfTlVMTChyZXEpKQ0KPiA+IC0gICAgICAgICAgICAgICBhY29tcF9yZXF1ZXN0X2Zy
ZWUocmVxKTsNCj4gPiAtICAgICAgIGlmICghSVNfRVJSX09SX05VTEwoYWNvbXApKQ0KPiA+IC0g
ICAgICAgICAgICAgICBjcnlwdG9fZnJlZV9hY29tcChhY29tcCk7DQo+ID4gLSAgICAgICBrZnJl
ZShidWZmZXIpOw0KPiA+IC0NCj4gPiAtICAgICAgIHJldHVybiAwOw0KPiA+IC19DQo+ID4gLQ0K
PiA+ICBzdGF0aWMgc3RydWN0IGNyeXB0b19hY29tcF9jdHggKmFjb21wX2N0eF9nZXRfY3B1X2xv
Y2soc3RydWN0DQo+IHpzd2FwX3Bvb2wgKnBvb2wpDQo+ID4gIHsNCj4gPiAgICAgICAgIHN0cnVj
dCBjcnlwdG9fYWNvbXBfY3R4ICphY29tcF9jdHg7DQo+ID4gLS0NCj4gPiAyLjI3LjANCj4gPg0K
