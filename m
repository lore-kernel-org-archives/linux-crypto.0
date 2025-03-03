Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C821E9B3D;
	Mon,  3 Mar 2025 21:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741037681; cv=fail; b=uZq5zqmZSnDiy26Q80SBnyeZUPwx36n8OGqr7F+EKIvTrMZEj6wKQd8WkZb2VNGscgQ8R7DBSzdmy9kljjLMkdE0dYUqltmUYXzxcXdTXDU0zTpdMr91547TG7pIhGN1gl2NVn+q1PFcF+dMCV2qrFAbd2oyGzsKUT294SwS7WM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741037681; c=relaxed/simple;
	bh=vzyCNUpBIY/qC4EnZB+v+SlK1ifjy1QGUTjnLPy+vco=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E8T8LiUHpA/f8FuWOLVCJ3ifpX7vT96NtwJN2xkuT1by3/nyu5ZYEJfDNTtp9jPDzqkPVwXuHl0dt4cYcGdz642EJt9A1/UxcKcozqRk2GwPVl/vTq4b1ZL00nOpVLoArflKm2TkDcdMRE4SdQp/iZ+q+m0ZdXM4p3dsU7gHcGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nbnBQG2N; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbnBQG2N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741037680; x=1772573680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vzyCNUpBIY/qC4EnZB+v+SlK1ifjy1QGUTjnLPy+vco=;
  b=nbnBQG2NeOKlwplyfNjWfJ6ubFBx2jbbEjWwR14f6XQnEA22wSWXCEV2
   rcsLvggat1KLY7b4azsu7wa+G4pGJtRida6VtrACAXTe8M/B1hpRuyXmH
   yCbmoni0Avn+a5K8QHrvGA7ikWcKIw2cDIfLuI0QgVH7cajF1MZzQ7Kaa
   wnBvaLDjod2wB1qR8xK4p6KpqaC9jc5naK3hAzaVrEyC5lZPYfEyXN2DZ
   DdJ4TKp2d1bkmTQRnjbsdhvm9b5flGyh6zn9F5etrtfcsrheiByPtfNIy
   eT5Kq/9CzHNQfYCkbFyJxGzjfPbSZIug5E3rXKemruCZV9zT3BtSWhzgV
   g==;
X-CSE-ConnectionGUID: mnzZMQXmR8ehTz+N+C50Kg==
X-CSE-MsgGUID: O8cuVbp1Sw6nz+RT6c6BAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="29519774"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="29519774"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 13:34:39 -0800
X-CSE-ConnectionGUID: NnHhYB4LSqSTQxAHjRhbSg==
X-CSE-MsgGUID: i9NakmhJTGGxdgCJnVdWZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="141391010"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Mar 2025 13:34:38 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 3 Mar 2025 13:34:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 3 Mar 2025 13:34:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 13:34:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2kzFN6E9RFbzofUqwr8dLs1W3yNvnOeHw+gAGI8iOwXph8nyMrC+6Pba4wm9xyfvOeQkXT/MP1+uvmJ0t0fbZH/OQLJPxKUayWlmpj77JXerqbqAIhljx2VqnPel+56sVIBpb3TksfeeQ7aECuPCFI+9rBFY/KlAk9qlJhsdxj1jIIauLgdcLz3PCBa/hst9lFzSKu2prB9rd04qFseVzd8bLbWo8AjcFnzWNcfoP3FLeXN/F8A63/MkLShAozjE7vJFlP8+UzhcS3YTu6ZPJhwc4+hq5WhCxsB/SgEKWBni/h04GEShkT6Dbq3kmh6VKwluYXV3j6s0hD/ZyCA3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzyCNUpBIY/qC4EnZB+v+SlK1ifjy1QGUTjnLPy+vco=;
 b=Vi+jKte2PrcasmCXlVJelLibp7BKGa9TuRB3NZWUihb7ULjfk4b27fLIk5//9siwp5yF50nf9d2xOaZVr/hG5rGXpEbOdMrHZX21VSh6gQ2RCO8QlqUQKsAqAiHRm3aSag2FZhK3vjCps3WezZHsjpUCqMsY1f0bTNdmxqkaeiFifriXEQksK91+IdGgISsezZPRidkuDSqKzLQpE5ukCN7Wxxsk0Ep7shBINf0Rv9NzUGtcRH5X8W3GaLiFG7rzxHDcjIeYEptBXJ8ZWtL4zitrKrgM/zQwxxF09HX0x33eUQhaH0b3JhkjgxzsUMHuzGpT/5xNKXQYO2EONEhyDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by CO1PR11MB5042.namprd11.prod.outlook.com (2603:10b6:303:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 21:34:04 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 21:34:04 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, lkp <lkp@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>, "Feghali,
 Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v8 14/14] mm: zswap: Compress batching with request
 chaining in zswap_store() of large folios.
Thread-Topic: [PATCH v8 14/14] mm: zswap: Compress batching with request
 chaining in zswap_store() of large folios.
Thread-Index: AQHbjBjvM/RpC9YLRU+yz1iNoK3rUrNhQKsAgAB5VICAACxo8A==
Date: Mon, 3 Mar 2025 21:34:04 +0000
Message-ID: <SA3PR11MB8120445C8DBDBB9945231B66C9C92@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250303084724.6490-15-kanchana.p.sridhar@intel.com>
 <202503031847.j1iReOtf-lkp@intel.com>
 <CAKEwX=MgV22UBNi-2dNBDgNM2DRfrngk_4gO7z9t-O0KrpdPUw@mail.gmail.com>
In-Reply-To: <CAKEwX=MgV22UBNi-2dNBDgNM2DRfrngk_4gO7z9t-O0KrpdPUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|CO1PR11MB5042:EE_
x-ms-office365-filtering-correlation-id: 9027a114-9ac0-47ee-3573-08dd5a9b1ee8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VHE2SWs0SkhLRCtybjZuVGZSVzJVdFhPUHU0WHF6VGNWQmtFbGIyVkk5enFS?=
 =?utf-8?B?amlqYkFmYlFPNDc2dVFKbTVETWhkaG5oWFR3cVVHdjE1THdJUE93V01vOEJp?=
 =?utf-8?B?amRLaXd2SS9IWkxoN0NlcUZGbE4yOUFyNlhDaTVNUDJ2cm1GNjVGVmo4WVJp?=
 =?utf-8?B?VG90TkxWdVpOY2c0QU1rYW1lVGp2RXZQMDVBOTdIWnJtMlUzZUpKNEZpTEQx?=
 =?utf-8?B?QUFtNWdjbHEzRWdWekRQQk9vRGN0c3BtczAzRnhlbWZ5RmMycnVhemNFMzFK?=
 =?utf-8?B?VzJUSFA5czFWZEdGWkdRbHYxMGN1T1NXY0QrVTZzcUFLb2RTbXRGQlFZb1Ju?=
 =?utf-8?B?d3JRUVk0QmZ1c1RuZS96Zk5sUW9jK1BJWERMWmsyS3d1N0dCT2F1WmwrcmVi?=
 =?utf-8?B?Unh5ajBNZjJFM1lsQUVjOXJqLzRYRVNGS0VndFIzb0hScHluK05ueUU4cWx6?=
 =?utf-8?B?N0VsdndrNTlMRUxVOUFOMmZhWFFabEJVb0JrcXdjNGtnMTd4d2ZQeEJsaHFp?=
 =?utf-8?B?U2FXYUM0eU4yV2JnekVsREJKemRvK2s5VDJtbm9VNGYremNycFBoeGJIdHRq?=
 =?utf-8?B?UWc5ckNMQlZEUzNmR3dYSHp6U0o1YjBaVmRqZlBIQVJTN01YTlJBTVRxWWVl?=
 =?utf-8?B?OFVFaUV1WkxnWGNkWVBYRGJUOTN2MGxGS0Y1Y2t1RHZVQ0x5SEdrUklGNUZw?=
 =?utf-8?B?WWQ1UkEwNHlYVFBzS1JjQzBmU3VBcEFhZVFaWUdMeXgraHUvZ3NzOS84aVhL?=
 =?utf-8?B?VEUzWlpjWHNDaDUzbzUxR3ZGWFcvK1B3Zk9DWWN3aGdORURUZkIrTUxYdTgr?=
 =?utf-8?B?ejRQalBsMTVYM1FURkhEaTRrbDlYQ3BKbXJNWkRaellFdEdkVnZURTVlMmp6?=
 =?utf-8?B?TXVSNUZmM29EM2VIdnBjZnhNdmtkOUZSWVJ0eUdrREpvVTYxS2t2QjI1YldF?=
 =?utf-8?B?Vm5pL3lzUzVyU2FCTHVPTlkxc3ZvZWdUMkhFNFgxTWVWR0x0VnQ0aDR4T2Z4?=
 =?utf-8?B?SDRiRU9IclJ6ZGJJRnczdS8rUU91QkZYZm0yN3U2L3FaeFVDMzdiRzQzZXla?=
 =?utf-8?B?aUlsNVVVcWxoeThNdGp6QVlTRmxSa04rdUtJcW9WQXpnTW1ESWd4UUdNMmVR?=
 =?utf-8?B?bUhCei93QjdDQk1meENOOFd4Sys5Y3hqYnZFR245THE0TCt6N29yKytnWVVU?=
 =?utf-8?B?TFE3VEFQREs1L3FMYWRUdUJFMm5QWWhsUjNadG1tSjhYWW9lYytHSFRxWW0r?=
 =?utf-8?B?MkNqdlZ4YlM4am9iOURRYkdjTlVwK3lJNTlQZHh5RGxhVDB6RDZibWpqNGJR?=
 =?utf-8?B?N254Yi8vcVEyNUY5ZGw3c2ZPSG9YZGUzYmdUQmtLdkovcEdmOUdUeWZOT0ZB?=
 =?utf-8?B?Tk5jS3ZhVVpaTDdZZjJmblBqSXgxWk91NERFUVdLTlRXWjh3WnJLS2ZWOW9h?=
 =?utf-8?B?L1NyQTNDaGNnU2Y2TmdnZk1LV2RMSzN1ZjlJazUwQ0V4SHpKYUVucU93akc0?=
 =?utf-8?B?ZSs5amRHR3FualhuczBGTEFBZGo4VDVDcjJiTUFyK25oQmJXUkdmdXg5S2tx?=
 =?utf-8?B?UWNLNjVRQVV2dlRLOVhLb1R0RGpndzdVWTl6Nkc5R1hROWs1NnRSTlFrdFRu?=
 =?utf-8?B?STFzZ1IxT0RMY3V3TFE2QXcyNzZBM0hDcWNqUEJOOTRRTDJST1prWXd3cGE3?=
 =?utf-8?B?ZklsNWdGQW1sMS8yWVRLWDk1WEo5NlZlSjVoUUQxMDF3SXl2LzZ1emN3dE8v?=
 =?utf-8?B?M3l4VG9sOGVmSXNPY1BNNXNtVkMvOFQ3YlNFZ1Z5VzBUUEFNVDJKSTFRbi9k?=
 =?utf-8?B?Y3hkSzR4Zzc0LzJzUmJCR3MyNjdQOWpuaTZWWXNRL0NFSkNSaVVEVWtoTGxH?=
 =?utf-8?B?c3crT0tuN3BxOGp3RXlyclhLbDUxU2YrdzdEL3JhQXZDYktFbkdpRThkMU5J?=
 =?utf-8?Q?06WASNkxmQPJAgUf8tcX41LJ/6/OrZYB?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2o3eVpweXZNVVh1SzR4UklhS2c2Q0VybXVsVVVhSy96SGV4YXVMRHVqM1Nl?=
 =?utf-8?B?OWxVUnk3WHRRQllBNGdDbXM0RlNnVDNjSWhSOXBiMFRzeGZ3ak5YS0c3R0kr?=
 =?utf-8?B?NllxK0ltQTg3R2t4Tk5hUGd0NS9kTUJlV2tzQ0J3MUNjZ0phVjNOb1ozbHV5?=
 =?utf-8?B?b3VTQmt3SldpNlVXeHhrTVpOeFc4TWJjbXZOZkFqb1k5dUoyM0dxNWxaTDNs?=
 =?utf-8?B?bytyeUF0STBFbDlUeDQwMDZhOStFaEFWdXNQQTBId1YxZ0g4MzA1TjdORzNz?=
 =?utf-8?B?RkFIR2lrbnFhcDNqK0h1Q0hsdmFNK2NQRlBTNE5GS0dsVmpkUzR1MWk3RWdR?=
 =?utf-8?B?SVlTb3UzazZFcmwxT2U4QVJPeEE1b1RaTTFNQXBhd2Q4YnJkaFhJL250OUtU?=
 =?utf-8?B?dGtrakx4ZEN4b1Y1c0RxMGZScmxxZTQwMkZFQTBjRjdaZzY2TWRQeGRMTDFK?=
 =?utf-8?B?cTRLdXorejRsNjMwVmFjbFlrb3F5Q21ZMGdKZzI0cmFsTHhFQmNrKzJ6aVQ3?=
 =?utf-8?B?c3ROR2VMSjg4ckxYRkN6dFRJVnIyN0Q2a0J6cEpyMm1aUElSL0hxWTZIZnhQ?=
 =?utf-8?B?d2NBTWVGeDBSS2d5MTE3VlNiODB4OWpOVGpBSTRUWlY1SHdQNWNNVVY1UUw1?=
 =?utf-8?B?VWM1Y05IanZYMGYxalhkNzdaYnBEaldlWnVMRTlyL0wyNG9RZFFsSkd6bmly?=
 =?utf-8?B?M2RtZjVVaFoyQjBSNEZYeEl2M0x1MDFTTm9aMVJENG1zODdncUhmbitWclhP?=
 =?utf-8?B?S2o4a1B4OCthckNpTTFTQ1pUMGxMeTRWZmZmYmdUdFJDNzdrc2MxUE14Vk9h?=
 =?utf-8?B?QTAvcmV6Q3ZhQXFPRzk1Y3k0Ny9VRXFBR3dzNFE2enpEU2lvY0I0d3B0WmxC?=
 =?utf-8?B?bWk5a0NtMTJ3aE1wS0ViQktieUwzOXhER2Q0ZGNCL1ZKbUllVnhFU05jbU1Y?=
 =?utf-8?B?K0t3bk5XbklMVkJ1Q2ZoR0E2d3dVSGRIdithazFyZDZ4V05yL2ZYRkpIZTN3?=
 =?utf-8?B?YndFdFlSWUZaUkVVeXdMSWkybi9VaCtOaUJwbWd6Zm9scGFWY0RmdTJwZEZl?=
 =?utf-8?B?TWUvcVE5R0YxOEJjYU85SVhIY0kwNzJUc0JVM0tvOUxuc1lYd3UweFNlYVVa?=
 =?utf-8?B?Y0RMNWFJMVVkcXp5NVQvc2dwZ3JHek9xQmZSMXhLUThGT0MwSG5HSHRpWmR5?=
 =?utf-8?B?TDJKMGlNME9nMkZjeHEyMHlmSXJYS3REVnF5QldRNXF6aHptcDkrY2s3WXgw?=
 =?utf-8?B?a1MxZGdtK3ZTbjdPVWpyeHFNWTFSZVFxU1ZzRUo2R2xMRmU1djZCYXVWaUQr?=
 =?utf-8?B?S3FSV2wwMG5iUmN0aWRpMWNuVWtTdzArQ29mWnc2M0xneEx4MWZXeDFKU3hm?=
 =?utf-8?B?RzJZNHU5YzIzZjF6NzhHcnRKdE5kUjVOVjAwbklvd044c09XNDFtempMaFRO?=
 =?utf-8?B?QVMrVnRkaUpSQkNUM3ZmRGk0VWtlL2EwSkpnc1lEdDJXWHRLQTZYeXBwdS9U?=
 =?utf-8?B?ZHRrUFUzS2RYc0VrUzc3dmVXWmVBQzRRdElmYTExcE5vYnlCNS9ZNEw2NTJR?=
 =?utf-8?B?OWRBSDc5eHpMUVlzTGxoSUZORTdqM08rbkplSVBsOVhHMVRGQUdSdW9OVWJ3?=
 =?utf-8?B?dC80cG5Gb2FEYWx2S1pBRXhYUzVEcEcwM2RHV2ZGWko3dFd1Rmh5NXBNRE4x?=
 =?utf-8?B?bDIyZlQyR1UvM3hxMmxCeEpFVnZyVzdyTDVmUlZaYU5IM1ErNXdkWkVXY1B6?=
 =?utf-8?B?ajEvc2RFblB5ZS9MSWg5U0phSzhGd21nVVZUcmxqQk9Venprdnp1TVZLaXBU?=
 =?utf-8?B?MmtQT3ZhczZ0NkUxcGNpMlN2Nm9JQm1IR1IzcHpVVDd6ZjhqbE5JY1JrTmlS?=
 =?utf-8?B?MEl4Ukg4UlYvM2dIbHJxVUttblR4T2h0ZGRHdDY3QXFWL01zK2FqdHFOWDNt?=
 =?utf-8?B?bHVrNVJHRW9UL21VbFpyMWRHUlIxSHZScFVQYTlHNlJvbUtUbzV1ajZ5cFdK?=
 =?utf-8?B?MlppcElxV1B5bXJpSHNTTmVrcitzOWRBUWp2cHRpaGdMRXZ6Zlh6SW1Femd5?=
 =?utf-8?B?Z3FWSTFhK0RvaXZMekRuNytqenhyL3VJTnBIby9wKzRVekRFWVp3andjUW5F?=
 =?utf-8?B?aHZ6cUlBZmgzdzRmNW8xQzdyRTRQQkNZYzdOZkcySU4xdnFxenhFazBZR1Iv?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9027a114-9ac0-47ee-3573-08dd5a9b1ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2025 21:34:04.0901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nii3aZoeEqbAV3jbEfH6InH98r2uVZmVXCFyAwyh7PM69yFRzH6+fulM76pk7axrYSpYUcEvNEm5X9DX6lNSc6HsXDoCsXGVaA8jvrtCu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5042
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMywgMjAyNSAxMDoyMiBBTQ0KPiBU
bzogbGtwIDxsa3BAaW50ZWwuY29tPg0KPiBDYzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2FuY2hh
bmEucC5zcmlkaGFyQGludGVsLmNvbT47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1tbUBrdmFjay5vcmc7IGhhbm5lc0BjbXB4Y2hnLm9yZzsNCj4geW9zcnkuYWhtZWRA
bGludXguZGV2OyBjaGVuZ21pbmcuemhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFp
bC5jb207IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4geWluZy5o
dWFuZ0BsaW51eC5hbGliYWJhLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgt
DQo+IGNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsN
Cj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgY2xhYmJlQGJheWxpYnJlLmNvbTsgYXJkYkBrZXJuZWwu
b3JnOw0KPiBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwg
S3Jpc3RlbiBDDQo+IDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+OyBsbHZtQGxpc3RzLmxp
bnV4LmRldjsgb2Uta2J1aWxkLQ0KPiBhbGxAbGlzdHMubGludXguZGV2OyBGZWdoYWxpLCBXYWpk
aSBLIDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29tPjsgR29wYWwsDQo+IFZpbm9kaCA8dmlub2Ro
LmdvcGFsQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2OCAxNC8xNF0gbW06IHpz
d2FwOiBDb21wcmVzcyBiYXRjaGluZyB3aXRoIHJlcXVlc3QNCj4gY2hhaW5pbmcgaW4genN3YXBf
c3RvcmUoKSBvZiBsYXJnZSBmb2xpb3MuDQo+IA0KPiBPbiBNb24sIE1hciAzLCAyMDI1IGF0IDM6
MDfigK9BTSBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4g
PiBIaSBLYW5jaGFuYSwNCj4gPg0KPiA+IGtlcm5lbCB0ZXN0IHJvYm90IG5vdGljZWQgdGhlIGZv
bGxvd2luZyBidWlsZCBlcnJvcnM6DQo+ID4NCj4gPiA+IDExNjYgICAgICAgICAgICAgICAgICAg
ICAgICAgIHByZWZldGNodyhlbnRyaWVzW2pdKTsNCj4gPiAtLQ0KPiANCj4gV2h5IGFyZSB3ZSBk
b2luZyB0aGlzIGFueXdheT8gRG9lcyBpdCBoYXZlIGEgbm90YWJsZSBwZXJmb3JtYW5jZQ0KPiBk
aWZmZXJlbmNlPyBBdCB0aGUgdmVyeSBsZWFzdCwgbGVhdmUgYSBjb21tZW50IGV4cGxhaW5pbmcg
d2h5IHdlJ3JlDQo+IHByZWZldGNoaW5nIHRoaXMgKGFsdGhvdWdoIHRoZSBidWlsZCBlcnJvciBz
dWdnZXN0cyB0aGF0IHdlIGhhdmUgdG8NCj4gcmVtb3ZlIGl0IGFueXdheSkuDQoNCkhpIE5oYXQs
DQoNClllcywgaXQgZG9lcy4gVGhlIHVzZSBvZiBwcmVmZXRjaHcgcmVkdWNlcyBzeXMgdGltZSBi
eSB+MS41JSBiZWNhdXNlDQppdCBtaW5pbWl6ZXMgY2FjaGUtbWlzcyBsYXRlbmN5IGJ5IG1vdmlu
ZyB0aGUgenN3YXAgZW50cnkgdG8gdGhlIGNhY2hlDQpiZWZvcmUgaXQgaXMgd3JpdHRlbiB0by4g
DQoNClRoaXMgaXMgZGF0YSB3aXRoIGtlcm5lbCBjb21waWxhdGlvbiB0ZXN0LCB2OCB3aXRob3V0
IHByZWZldGNodyBhbmQgdjggYXMtaXM6DQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogS2Vy
bmVsIGNvbXBpbGUgICAgICAgdjggd2l0aG91dCAgICAgICAgICAgICAgIHY4ICAgICAgdjggd2l0
aG91dCAgICAgICAgICAgICAgdjgNCiBhbGxtb2Rjb25maWcgICAgICAgICAgcHJlZmV0Y2h3ICAg
ICAgICAgICAgICAgICAgICAgICAgcHJlZmV0Y2h3DQogMk0gZm9saW9zDQogLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCiB6c3dhcCBjb21wcmVzc29yICAgIGRlZmxhdGUtaWFhICAgICAgZGVmbGF0
ZS1pYWEgICAgICAgICAgICB6c3RkICAgICAgICAgICAgenN0ZCAgIA0KIC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQogcmVhbF9zZWMgICAgICAgICAgICAgICAgIDczMi44OSAgICAgICAgICAgNzM1
LjYzICAgICAgICAgIDc2OC41MyAgICAgICAgICA3NTguMjENCiB1c2VyX3NlYyAgICAgICAgICAg
ICAgMTUsNzA4LjM3ICAgICAgICAxNSw2OTkuODQgICAgICAgMTUsNzAyLjY0ICAgICAgIDE1LDY3
OC43Mw0KIHN5c19zZWMgICAgICAgICAgICAgICAgNCw2MzIuNTggICAgICAgICA0LDU2My43MCAg
ICAgICAgNSw3MzUuMDYgICAgICAgIDUsNjM1LjY5DQogLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
CiBNYXhfUmVzX1NldF9TaXplX0tCICAgMSw4NzQsNjcyICAgICAgICAxLDg2Nyw1MTYgICAgICAg
MSw4NzQsNjg0ICAgICAgIDEsODcyLDg4OA0KIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogbWVt
Y2dfaGlnaCAgICAgICAgICAgICAgICAgICAgMCAgICAgICAgICAgICAgICAwICAgICAgICAgICAg
ICAgMCAgICAgICAgICAgICAgIDANCiBtZW1jZ19zd2FwX2ZhaWwgICAgICAgICAgICAgICAwICAg
ICAgICAgICAgICAgIDAgICAgICAgICAgICAgICAwICAgICAgICAgICAgICAgMA0KIHpzd3BvdXQg
ICAgICAgICAgICAgMTE0LDc0Miw5MzAgICAgICAxMTIsODM2LDcyNSAgICAgIDkyLDkwNCw5NjEg
ICAgICA4OSw1OTYsMDg1DQogenN3cGluICAgICAgICAgICAgICAgNDEsMTg0LDg5NyAgICAgICAz
OSw5ODMsNzkzICAgICAgMzEsMDE4LDE0OSAgICAgIDI5LDE2Myw5MzINCiBwc3dwb3V0ICAgICAg
ICAgICAgICAgICAgICAgNjI1ICAgICAgICAgICAgMSwwNjkgICAgICAgICAgICAgNTU4ICAgICAg
ICAgICAxLDA1OQ0KIHBzd3BpbiAgICAgICAgICAgICAgICAgICAgICA1OTkgICAgICAgICAgICAx
LDA1NiAgICAgICAgICAgICA1NDAgICAgICAgICAgIDEsMDUxDQogdGhwX3N3cG91dCAgICAgICAg
ICAgICAgICAgICAgMSAgICAgICAgICAgICAgICAyICAgICAgICAgICAgICAgMSAgICAgICAgICAg
ICAgIDINCiB0aHBfc3dwb3V0X2ZhbGxiYWNrICAgICAgMTAsOTY3ICAgICAgICAgICAxMCwxOTUg
ICAgICAgICAgIDYsOTE4ICAgICAgICAgICA2LDE0MQ0KIHBnbWFqZmF1bHQgICAgICAgICAgIDQy
LDU4OCwzMzEgICAgICAgNDEsMzQ5LDA2OSAgICAgIDMxLDkzMSw4ODIgICAgICAzMCwwMDYsNDIy
DQogWlNXUE9VVC0yMDQ4a0IgICAgICAgICAgICA3LDY2MSAgICAgICAgICAgIDgsNzEwICAgICAg
ICAgICA2LDc5OSAgICAgICAgICAgNyw0ODANCiBTV1BPVVQtMjA0OGtCICAgICAgICAgICAgICAg
ICAxICAgICAgICAgICAgICAgIDIgICAgICAgICAgICAgICAxICAgICAgICAgICAgICAgMg0KIC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCg0KU3VyZSwgSSB3aWxsIGFkZCBhIGNvbW1lbnQsIGFu
ZCBhbHNvICIjaW5jbHVkZSA8bGludXgvcHJlZmV0Y2guaD4iIGluIHpzd2FwLmMNCnRoYXQgd2ls
bCByZXNvbHZlIHRoZSBidWlsZCBlcnJvci4gVGhpcyBpcyBzaW1pbGFyIHRvIGhvdyB0aGVzZSBm
aWxlcyBoYW5kbGUgcHJlZmV0Y2h3Og0KbW0vdm1zY2FuLmMsIGtlcm5lbC9sb2NraW5nL3FzcGlu
bG9jay5jLCBpbmNsdWRlL2FzbS1nZW5lcmljL3hvci5oLCBldGMuDQoNClRoYW5rcywNCkthbmNo
YW5hDQoNCg==
