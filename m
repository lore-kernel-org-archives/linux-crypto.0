Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEA61A83F8;
	Fri, 29 Aug 2025 03:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756436703; cv=fail; b=lA71beFhv/8ktHikjsIw6YxKc1CLA0w9p/ToLKFaRl74iTPfeTjEpfADSHVveFxJhbrKAdgp/uPlTldaDezMt9sfLSdGUFeK5mj38oflQDP4Qi7OoBAKB/CJeHrJ1yHrZRBnhRbHHkZ/Tl7HpJqkhG5YgcOqBSKhkwPZ3dHIHIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756436703; c=relaxed/simple;
	bh=BKG5ipch0tMGg99EMtspWi3fNdQsxdEBp2D2T5iS7RQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sX7H0wqZ0KmY0Ac5TuoKn7FgWN+ksSxNijWM3xgOWhDuqne18Bn+400zlbDWMa05D5Jo0QbT7sfgk/4oitGNmlRLz+Ydeck6TbxsQKjkr1MEenZGyfWbxa9DQdUqfTVdmw0N1IrLPH47OmemlcqKIaCwshZ3SLVR156Cbns1RnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lNOgYBE0; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lNOgYBE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756436701; x=1787972701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BKG5ipch0tMGg99EMtspWi3fNdQsxdEBp2D2T5iS7RQ=;
  b=lNOgYBE0wCCMi3ziKNckx5eqQtZ/qXnyvmL6JtDZtXNJE9bEH5vg1PQY
   qUcxpPVUv0twjnO1I+i3mCkNJ726LsvSYvIvxR6hRiZLSyjNi34n8gt4v
   +zJd1OK424fe+Th7eEoCRdzyUt7I/pyV7Tgpidieb1qcynlh/ulpy4jmH
   eogQh17XNPogP8iDrqDxTbVgz4V8vBfO8rqiWeOwp0C/c/Gao5EMVAR/e
   jHZlVq5TnGpXT51BWd5i69a0JU7EY/vbXqyzRE+Jg7gEzjjZOLROClW/U
   nEkgjYCem1ys/8vuWcVI8aEKj4EMG9U9+Vx+twnkkxeWttWVYEpjnX+wR
   w==;
X-CSE-ConnectionGUID: mE/MTWjMRd2dQJDqLfmqog==
X-CSE-MsgGUID: a3KC/T5XSYaJmPlH/Xzekw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="57915501"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57915501"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:04:56 -0700
X-CSE-ConnectionGUID: 60F+0DQcQi6XGJfJ3i95bw==
X-CSE-MsgGUID: ES342RPxRc6Khhc34T8x0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170657905"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:04:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:04:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 20:04:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.55)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:04:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Li02KhU2oBcrjedWTaSKKKYx8lVRf1X8X9KNN/5SQhoZ1/xeii/FC5BXK1/2ggNHEwBxDp81wfT7hgJ3vPI6PctAwTVdeSD7Jt85zlD+CNEHzUgW5YITu5yxBc0ybHot4DI24QuJ2fot+CgDi+2EtEOJqW4D89p6HiCzBFhhDFPPMqMhYaNd3BSzisoq8DTgs4EbkyeKWi2HM1YWpZdJ4JqDnj6WBOUTg+THAKOp3lEdsp+2W/kVwfLZ9jFbe+gzigd8yv8a0E+nOvDEbYy3xMGQ31h6dRCt/IQar+zGcmsjN8I9gAyPXLOxpSt2x6My6Pqc7dBU9osVyCuywoWzJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKG5ipch0tMGg99EMtspWi3fNdQsxdEBp2D2T5iS7RQ=;
 b=tBKj3vIrX2mmJ+pjLs60lBEKQeFB2Y3O3/a7xcFSRG85Upd5hxwQ5wVLrIXY5v97SlxditZIIlalCTD7gtla9Vosukk3dLCrfALv2GWHlAyNl+YbRK4rrO98GFkcxcgQND4F6gcHw7AN9WtWgSGYqJECItwT2+AHVDNdFNb6n1edQfVzVZ0CiINiGnBoNykufQWCeHutLzUmlIhCZG81/B9oRRZ5Ossu5cj175JNBSF9jZthxYcUPkcJfmTha84IfBxQ9PLV5x0yvF7UvvAvIj1l5mddv9fQ1kaUz6WroiwGocNkrUMYtcc6JDq4Q0xGpIGAJ8H4auAi5O9Y8NIK9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 03:04:52 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 03:04:52 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Barry Song <21cnbao@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
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
Subject: RE: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcAp3rZa+v4TFKjkuil/Grf2UpDbR46OeAgAAzNsA=
Date: Fri, 29 Aug 2025 03:04:52 +0000
Message-ID: <PH7PR11MB81213032EE672C69B3FC3370C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xMYUHo_SRc=1jgP6jMNosA_NP3HCitSMKwx=5ScJ0Cng@mail.gmail.com>
In-Reply-To: <CAGsJ_4xMYUHo_SRc=1jgP6jMNosA_NP3HCitSMKwx=5ScJ0Cng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|PH8PR11MB6779:EE_
x-ms-office365-filtering-correlation-id: 7516ff93-f1fc-4f71-8e5e-08dde6a8d2d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?ZnJiaXZnSXRkQkRVUWY0VlJZQWxuYm95TC9PejVNbWwxeUo5WG9GbmVmUFBU?=
 =?utf-8?B?WUsxbnFqVnNTTm9UTEppKzBlVVYva3pDbkFCcGQxOTYvVnI1OFYyd2ZhV1kz?=
 =?utf-8?B?cXozSEhJU2ptYmRuMXgrVFdUbllsanNhUW9Vd0tYTEo0ZzQ3a3B3TEtMeVhS?=
 =?utf-8?B?dkRwM1ZpM2tvRFpmbVREVm9DRHp5ZUJaNGZIeUJmcDVOcXNwRndXU2ExVHRR?=
 =?utf-8?B?cklpTU5XS0JmdlBVUkVuRElLQXdWa3lNWFhBQitYYU56ME5xZkp4SHp5R1Bk?=
 =?utf-8?B?UGo3U3ozakNEWld4N3pzSHdhQTdZbkF2K21lU2Y4TjRRZ3NGeVBxN0hqWTlP?=
 =?utf-8?B?L2p0aHN6ano4MEJQa000NnIzZStveHhXb01obFlZY0FCSWJBSm13ZUNBbG04?=
 =?utf-8?B?YkR1dkpabmo0TE92T3NzUytKcTdUcmVGczhJb2RZUWJyWllla2tTNm4wVUN2?=
 =?utf-8?B?cjh3RklaTjRZc2dYd1MvaHJCcjNjS0VpZGFIenBOTm04d3hGZmpOR2lIYmp1?=
 =?utf-8?B?V3ZPd052cWJpUjM5NW9PTlhwYW1mbnpMTVNTZGZGVEJyY0I2ZUxLYWkwZ2Fx?=
 =?utf-8?B?akxDM3VxQXhwU2tjQ053UDlEUjJzTXpNdGMrQXF4WmIzbkdpdDNNZVBvWlAy?=
 =?utf-8?B?dFUzUE84RDZSMU1mWG5heWw1YmhMYXJlb2dlYzFvTG9aMVlidjJLV0UyVWwr?=
 =?utf-8?B?YUJMa3pZZzJOWU5IZkFCQ0VENmdZaEprT2VDTE0xT1RoMFl0UEdpcnhPdWcr?=
 =?utf-8?B?Y3JPTGNUY3NQQ2VWOGs3WlRCcG43aDJZRVFTR0grbTViclFHZzdtaW5pb0lp?=
 =?utf-8?B?dm5VakpJZHhhWERpdS9VQXhKR3IyRkhYbGtsNlFiZnZmSjEwY3dUaWU1eFV2?=
 =?utf-8?B?d0d6TkN2dWNMbnErMGVSYURrWWovY1JvUjgvTDhFVGczZzhEUmRXVXVyMkl3?=
 =?utf-8?B?YUlQOERVRHByV3E0TXZOV2hLaW5GdFFOc1JXL04wMm5ra215Q1Yzek4rMEtO?=
 =?utf-8?B?Wm94LzRhbERFbGV3NVk1eStBeW1UaVNRTTRHb0Fic2phbEEyQUd3RWJuMXlV?=
 =?utf-8?B?YzJGemRYQTJtckIvWGc3K2VVa3JOb3A4ZHgrTFN6Q0FTTDVyd040a2xZVlVt?=
 =?utf-8?B?K2V0ODVJRFFmWTQyWUtQOGZ5ZUk0dytUaUVwVW1ZZy9uQXB2eUhKRytaR0NX?=
 =?utf-8?B?cEdSL2cweEZ3Z2JDeDlSdnpXaElnV2ZsOW55c1RHWFVXQWl4RllYeGxLOHdj?=
 =?utf-8?B?aW5SSCt0NFYyWFdjWXJtbDJhMkgwT3NUWGY2TFJjeGt2UjFaTXI3NlQwekVC?=
 =?utf-8?B?UllvMlNCemFaVkNIaVRRcWVDaXpwZjB2b0g4TFNkUitBazMrZUF0a1p3V3Av?=
 =?utf-8?B?dVQxZk1TTEh0UFFhSzVQLzEwMjdRd0xmY0tXY1dsd21walVwZjB6UVQwT0JF?=
 =?utf-8?B?bmFVTlBkK0tOcDE1WENaS3UxaU83NVVrOC9RcytKc0JjSm1LNDZLdjFwaGps?=
 =?utf-8?B?VGU1SFkwdEU0L2k3Z21CSms4eVdRR1dVempuVWZIeitxRDJJcVUrdWIyL0dm?=
 =?utf-8?B?SWVUcExORXFlOTVPM3FWZHp4L2J0a0Q3MkRPZmx5OFhCcXlNNWRKSXRXNzlY?=
 =?utf-8?B?OFp4M2Raa3ZBbHR3dmhOSlBUODFZUk5CZWNEbm1rdmZMVkRCaTFsZEM2SGNV?=
 =?utf-8?B?d2FKUncvVjQ4Z2NLNllldG5rMmVoVWFKZ0hsUlJQc0FTOHY2N3V3M0FtQ3d5?=
 =?utf-8?B?V2Znc296RDVYVnhySlhrQm0zaEpxV25WbjhDd2o2UTVFV2s0SUVzNjg1N2JX?=
 =?utf-8?B?UnRsV2srTTczZGNnOS9UdHpxdW1kV2dBVzRrY3JJSGt6bXlLUkwrVlpBNFky?=
 =?utf-8?B?L01BelNhUEc0VFB6MkVvTzFrSS9CY2oydFd3cXBibE5WditxMzMzdzRpMGs2?=
 =?utf-8?B?TzY4aXVzL0R6YWh1ZHdrNXRtaVdwb3JqcFhCMElZSitGWTM4Um5xYlRoQWFO?=
 =?utf-8?B?WlBPb080NHV3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTBMenRwTnE0QjJkTHFhZEFvemRNem1wNitFTW81ZHB5Z2syeEVSTnJ6R3hj?=
 =?utf-8?B?MHlCc2JURHNsS1RhZ3lXSERzb1hpQU5pSHBoZW1GMEE4TGtGbXZGNnhNMGZp?=
 =?utf-8?B?ajFES3dRaUlzWjBBaGpjeTFFUUd0VkZhVjJ5MnNQRm1BREpub2ViL3E1NVlI?=
 =?utf-8?B?MEpBZENOK1J2QnVScXViRGl6dlNkYW5NT3dVaWEvdHBBVEcwSWdwcS9qOXBR?=
 =?utf-8?B?TmxOWVdLTnl4SWY2d3RCTDQ2YUdxTmg1dUxtN1k1RWxIczNDbXY5UzEzSlpi?=
 =?utf-8?B?ZnNOQWtpbCtYVEp0blpjZlNCTVYvR0xBK1pBNzRxNEgxL1B4NnFLeEg1dEp4?=
 =?utf-8?B?dEttYnlraDVWbEZDM3I5MmlHMXpxOW9iMUNPM0REOSt0eElwZEk3SjFkdUho?=
 =?utf-8?B?R0xJZFUvWm80NjN2dlczdC9ZaEZYTkJHN1FoaUFlTmg0MCtKZURhYlZSRXdq?=
 =?utf-8?B?enUvRDBkM1p6MlViOVRlQmxQbGw2MEU4Sm9RcjA1NzkzcmxxWEZkYkdkblZ4?=
 =?utf-8?B?NWlpblNBeTNXb1cvdXZPOE9MS2V1WTRqbUUvZ01pc2ZlbnhIbGs4LzRUS0to?=
 =?utf-8?B?enFzNnhTNlY4THVXM0tRVUJMNDdPSkpIU1pjcWJOZGxMbkVndmd4WlprOStm?=
 =?utf-8?B?MHpkL2pFRnl0dHB0dFBrc1NwSGVGbHYzc2l1dFBRYXRLcFpXVnpqNEd6eTVY?=
 =?utf-8?B?S0pUQlN0Rjhnd3J6M3NKMnFiUlZhNmNaaDY2RWduWDhtQ3lraE1ZMXFUNTNZ?=
 =?utf-8?B?dzdueVlIQTcxUDgwbUhkODkyK0RqSUVyZW9tbFoxR0M0aFNLQmdlaGx0UlNy?=
 =?utf-8?B?aWlPcm9tQ3RQVXdscnNlUURoam1jeU80ZmRmdENIYXgxTnIwSjQ1dEtmR1pK?=
 =?utf-8?B?dSs4VkF6b1E1bi94VzRrdUhXVXl6SGFpZTZGekU2VWM5bkhzZEdnSWp5dEdJ?=
 =?utf-8?B?TmowZTRPK013Y1J6b0pHQmlzY2RMdFVlN0NKNlZCNThHelAwaWNCRUdDaEpW?=
 =?utf-8?B?a3B4TlE0Nm5zNkhUYVdPTVZGQnlkQmdXc3M3Qm55Ry94YktxejExakp2cVlP?=
 =?utf-8?B?UVgwdlNzOXkyUmUvSWRncERLUFZ0UXBZREVOLzlvL2NJM0lRa2dEVUllbjFD?=
 =?utf-8?B?Uk1lUncybC9ReUVRRFg5U3liTEN4Q0FSRHY2UDd3YThrVWZ5WWxNZVkwWU5t?=
 =?utf-8?B?cEFlR2htZzhVaHJXZXlJeWREMHVoTDgxUWVLOHRZWk1ibVhUeSsyYVoyYWpD?=
 =?utf-8?B?N082dWdqZ1FUVTdOd2lPUG5tSWFRRkY3R1ZnQ1JJMFNpV0hpV1J6bjViZEJ0?=
 =?utf-8?B?Y043ZGg5YTdqZjVzMm92dkd3c0tnTnB3d21KVkhCMGliOGo2cSt3TW9YMVBa?=
 =?utf-8?B?YU1XT2o5SXk5eHVrcFJ4K0tYcktURU5lYjg0MmN6dHUvbCt0VW50SWwvbkRr?=
 =?utf-8?B?dkJmc2wxUTZhSWVpZzNTZTA2RWgvdXQ2bmg2WDdWbUdySzNWT2pONGUyM2xa?=
 =?utf-8?B?d0VVc2tWTmhLNnI0V25NcWNjRkI5QmEwVmtxRlM4VjRmbTd5dkVEVXpUWVUv?=
 =?utf-8?B?VjRvRmROQzZkVnNwU1EyZHRHUXUxQm5pZFFHdmVMdUdaaXZsTkRvakQyWEc4?=
 =?utf-8?B?K09qWlJmVFVFWkFITWI2a1BjcDFpTU9hN0Y4N2dVc0ZqQWNucHhtSXZVOE0r?=
 =?utf-8?B?eCtoS3ZhT1plbFZQK0hoVGRISjRFRFI3V2V2VkQ5ZHZ6UE1tcVZUYWhrMHpi?=
 =?utf-8?B?bWw5QWwwcXQ5d21vLzlySkFHY1VLc2g4bVl6K1prL3NzaWVKMzBhUTdWQzlM?=
 =?utf-8?B?ZGc4K2JGSERqQnVqMG1KQTlVRGxWSG1Ga2FpeElpRWswMzFPRTd5UmZwVDhT?=
 =?utf-8?B?eUdaUEMyQlV5bU05ZWdBdUZXcDNCQVBheVdQNVBoZ3dpdmVETnFkejc1SkR6?=
 =?utf-8?B?Nzc3dWtsLzNNNDZ5a1drNk5hNXgyUmdOMGc0RUl2SDFFeEhMTkFGQ0hWUUpT?=
 =?utf-8?B?QmlrOXl3dUljdEU1c21OdFRBd1JJblZGbnIwREFsMmovUU80U1FIMllxR0gr?=
 =?utf-8?B?Sm12OVlDT1B6djU4U2Y5NG5MQWNGR0pKd1BXZ3RaeGdITUFTNzhCKyt2Q2Jm?=
 =?utf-8?B?RlRTeGljbGJIKzdIZytVUEpqYms3bmFpY3RWdC9sRVkzWkZXdUx4bVpRN0Ru?=
 =?utf-8?B?M1E9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7516ff93-f1fc-4f71-8e5e-08dde6a8d2d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 03:04:52.2024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saFq1/GyrirujvPxlM4dbf8aaitPSCAeavRW2iU3EF3WtDEFEX+eMW45Lzfn2lve/Far0I9+Q1bQcHfDKI7sv6DlLnDdmP1Mj3uo+TkAjYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6779
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI4LCAyMDI1IDQ6NTQgUE0N
Cj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBucGhhbWNzQGdt
YWlsLmNvbTsNCj4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2NDJAZ21haWwu
Y29tOw0KPiByeWFuLnJvYmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNv
bTsgYWtwbUBsaW51eC0NCj4gZm91bmRhdGlvbi5vcmc7IHNlbm96aGF0c2t5QGNocm9taXVtLm9y
ZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRi
QGtlcm5lbC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBB
Y2NhcmRpLCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEdvbWVz
LCBWaW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0K
PiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3Bh
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDI0LzI0XSBtbTogenN3YXA6
IEJhdGNoZWQgenN3YXBfY29tcHJlc3MoKSB3aXRoDQo+IGNvbXByZXNzIGJhdGNoaW5nIG9mIGxh
cmdlIGZvbGlvcy4NCj4gDQo+ID4gK3N0YXRpYyBib29sIHpzd2FwX2NvbXByZXNzKHN0cnVjdCBm
b2xpbyAqZm9saW8sIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGludA0KPiBucl9wYWdlcywNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgenN3YXBfZW50cnkgKmVudHJpZXNbXSwg
c3RydWN0IHpzd2FwX3Bvb2wgKnBvb2wsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
aW50IG5vZGVfaWQpDQo+ID4gIHsNCj4gPiAgICAgICAgIHN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4
ICphY29tcF9jdHg7DQo+ID4gICAgICAgICBzdHJ1Y3Qgc2NhdHRlcmxpc3QgaW5wdXQsIG91dHB1
dDsNCj4gPiAtICAgICAgIGludCBjb21wX3JldCA9IDAsIGFsbG9jX3JldCA9IDA7DQo+ID4gLSAg
ICAgICB1bnNpZ25lZCBpbnQgZGxlbiA9IFBBR0VfU0laRTsNCj4gPiAtICAgICAgIHVuc2lnbmVk
IGxvbmcgaGFuZGxlOw0KPiA+IC0gICAgICAgc3RydWN0IHpwb29sICp6cG9vbDsNCj4gPiArICAg
ICAgIHN0cnVjdCB6cG9vbCAqenBvb2wgPSBwb29sLT56cG9vbDsNCj4gPiArDQo+ID4gKyAgICAg
ICB1bnNpZ25lZCBpbnQgZGxlbnNbWlNXQVBfTUFYX0JBVENIX1NJWkVdOw0KPiA+ICsgICAgICAg
aW50IGVycm9yc1taU1dBUF9NQVhfQkFUQ0hfU0laRV07DQo+ID4gKw0KPiA+ICsgICAgICAgdW5z
aWduZWQgaW50IG5yX2NvbXBzID0gbWluKG5yX3BhZ2VzLCBwb29sLT5jb21wcl9iYXRjaF9zaXpl
KTsNCj4gPiArICAgICAgIHVuc2lnbmVkIGludCBpLCBqOw0KPiA+ICsgICAgICAgaW50IGVycjsN
Cj4gPiAgICAgICAgIGdmcF90IGdmcDsNCj4gPiAtICAgICAgIHU4ICpkc3Q7DQo+ID4gKw0KPiA+
ICsgICAgICAgZ2ZwID0gR0ZQX05PV0FJVCB8IF9fR0ZQX05PUkVUUlkgfCBfX0dGUF9ISUdITUVN
IHwNCj4gX19HRlBfTU9WQUJMRTsNCj4gPg0KPiA+ICAgICAgICAgYWNvbXBfY3R4ID0gcmF3X2Nw
dV9wdHIocG9vbC0+YWNvbXBfY3R4KTsNCj4gPg0KPiA+ICAgICAgICAgbXV0ZXhfbG9jaygmYWNv
bXBfY3R4LT5tdXRleCk7DQo+ID4NCj4gPiAtICAgICAgIGRzdCA9IGFjb21wX2N0eC0+YnVmZmVy
c1swXTsNCj4gPiAtICAgICAgIHNnX2luaXRfdGFibGUoJmlucHV0LCAxKTsNCj4gPiAtICAgICAg
IHNnX3NldF9wYWdlKCZpbnB1dCwgcGFnZSwgUEFHRV9TSVpFLCAwKTsNCj4gPiAtDQo+ID4gICAg
ICAgICAvKg0KPiA+IC0gICAgICAgICogV2UgbmVlZCBQQUdFX1NJWkUgKiAyIGhlcmUgc2luY2Ug
dGhlcmUgbWF5YmUgb3Zlci1jb21wcmVzc2lvbg0KPiBjYXNlLA0KPiA+IC0gICAgICAgICogYW5k
IGhhcmR3YXJlLWFjY2VsZXJhdG9ycyBtYXkgd29uJ3QgY2hlY2sgdGhlIGRzdCBidWZmZXIgc2l6
ZSwgc28NCj4gPiAtICAgICAgICAqIGdpdmluZyB0aGUgZHN0IGJ1ZmZlciB3aXRoIGVub3VnaCBs
ZW5ndGggdG8gYXZvaWQgYnVmZmVyIG92ZXJmbG93Lg0KPiA+ICsgICAgICAgICogTm90ZToNCj4g
PiArICAgICAgICAqIFtpXSByZWZlcnMgdG8gdGhlIGluY29taW5nIGJhdGNoIHNwYWNlIGFuZCBp
cyB1c2VkIHRvDQo+ID4gKyAgICAgICAgKiAgICAgaW5kZXggaW50byB0aGUgZm9saW8gcGFnZXMs
IEBlbnRyaWVzIGFuZCBAZXJyb3JzLg0KPiA+ICAgICAgICAgICovDQo+ID4gLSAgICAgICBzZ19p
bml0X29uZSgmb3V0cHV0LCBkc3QsIFBBR0VfU0laRSAqIDIpOw0KPiA+IC0gICAgICAgYWNvbXBf
cmVxdWVzdF9zZXRfcGFyYW1zKGFjb21wX2N0eC0+cmVxLCAmaW5wdXQsICZvdXRwdXQsDQo+IFBB
R0VfU0laRSwgZGxlbik7DQo+ID4gKyAgICAgICBmb3IgKGkgPSAwOyBpIDwgbnJfcGFnZXM7IGkg
Kz0gbnJfY29tcHMpIHsNCj4gPiArICAgICAgICAgICAgICAgaWYgKG5yX2NvbXBzID09IDEpIHsN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICBzZ19pbml0X3RhYmxlKCZpbnB1dCwgMSk7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc2dfc2V0X3BhZ2UoJmlucHV0LCBmb2xpb19wYWdl
KGZvbGlvLCBzdGFydCArIGkpLCBQQUdFX1NJWkUsIDApOw0KPiA+DQo+ID4gLSAgICAgICAvKg0K
PiA+IC0gICAgICAgICogaXQgbWF5YmUgbG9va3MgYSBsaXR0bGUgYml0IHNpbGx5IHRoYXQgd2Ug
c2VuZCBhbiBhc3luY2hyb25vdXMgcmVxdWVzdCwNCj4gPiAtICAgICAgICAqIHRoZW4gd2FpdCBm
b3IgaXRzIGNvbXBsZXRpb24gc3luY2hyb25vdXNseS4gVGhpcyBtYWtlcyB0aGUgcHJvY2Vzcw0K
PiBsb29rDQo+ID4gLSAgICAgICAgKiBzeW5jaHJvbm91cyBpbiBmYWN0Lg0KPiA+IC0gICAgICAg
ICogVGhlb3JldGljYWxseSwgYWNvbXAgc3VwcG9ydHMgdXNlcnMgc2VuZCBtdWx0aXBsZSBhY29t
cCByZXF1ZXN0cyBpbg0KPiBvbmUNCj4gPiAtICAgICAgICAqIGFjb21wIGluc3RhbmNlLCB0aGVu
IGdldCB0aG9zZSByZXF1ZXN0cyBkb25lIHNpbXVsdGFuZW91c2x5LiBidXQgaW4NCj4gdGhpcw0K
PiA+IC0gICAgICAgICogY2FzZSwgenN3YXAgYWN0dWFsbHkgZG9lcyBzdG9yZSBhbmQgbG9hZCBw
YWdlIGJ5IHBhZ2UsIHRoZXJlIGlzIG5vDQo+ID4gLSAgICAgICAgKiBleGlzdGluZyBtZXRob2Qg
dG8gc2VuZCB0aGUgc2Vjb25kIHBhZ2UgYmVmb3JlIHRoZSBmaXJzdCBwYWdlIGlzDQo+IGRvbmUN
Cj4gPiAtICAgICAgICAqIGluIG9uZSB0aHJlYWQgZG9pbmcgendhcC4NCj4gPiAtICAgICAgICAq
IGJ1dCBpbiBkaWZmZXJlbnQgdGhyZWFkcyBydW5uaW5nIG9uIGRpZmZlcmVudCBjcHUsIHdlIGhh
dmUgZGlmZmVyZW50DQo+ID4gLSAgICAgICAgKiBhY29tcCBpbnN0YW5jZSwgc28gbXVsdGlwbGUg
dGhyZWFkcyBjYW4gZG8gKGRlKWNvbXByZXNzaW9uIGluDQo+IHBhcmFsbGVsLg0KPiA+IC0gICAg
ICAgICovDQo+ID4gLSAgICAgICBjb21wX3JldCA9IGNyeXB0b193YWl0X3JlcShjcnlwdG9fYWNv
bXBfY29tcHJlc3MoYWNvbXBfY3R4LQ0KPiA+cmVxKSwgJmFjb21wX2N0eC0+d2FpdCk7DQo+ID4g
LSAgICAgICBkbGVuID0gYWNvbXBfY3R4LT5yZXEtPmRsZW47DQo+ID4gLSAgICAgICBpZiAoY29t
cF9yZXQpDQo+ID4gLSAgICAgICAgICAgICAgIGdvdG8gdW5sb2NrOw0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgIC8qDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICogV2UgbmVlZCBQ
QUdFX1NJWkUgKiAyIGhlcmUgc2luY2UgdGhlcmUgbWF5YmUgb3Zlci0NCj4gY29tcHJlc3Npb24g
Y2FzZSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgKiBhbmQgaGFyZHdhcmUtYWNjZWxl
cmF0b3JzIG1heSB3b24ndCBjaGVjayB0aGUgZHN0IGJ1ZmZlcg0KPiBzaXplLCBzbw0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAqIGdpdmluZyB0aGUgZHN0IGJ1ZmZlciB3aXRoIGVub3Vn
aCBsZW5ndGggdG8gYXZvaWQgYnVmZmVyDQo+IG92ZXJmbG93Lg0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAqLw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHNnX2luaXRfb25lKCZv
dXRwdXQsIGFjb21wX2N0eC0+YnVmZmVyc1swXSwgUEFHRV9TSVpFICogMik7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgYWNvbXBfcmVxdWVzdF9zZXRfcGFyYW1zKGFjb21wX2N0eC0+cmVx
LCAmaW5wdXQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICZvdXRwdXQsIFBBR0VfU0laRSwgUEFHRV9TSVpFKTsNCj4gPiArDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgZXJyb3JzW2ldID0NCj4gY3J5cHRvX3dhaXRfcmVxKGNyeXB0b19h
Y29tcF9jb21wcmVzcyhhY29tcF9jdHgtPnJlcSksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZhY29tcF9jdHgtPndhaXQpOw0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGlmICh1bmxpa2VseShlcnJvcnNbaV0pKQ0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBjb21wcmVzc19lcnJvcjsNCj4gPiArDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZGxlbnNbaV0gPSBhY29tcF9jdHgtPnJlcS0+ZGxl
bjsNCj4gPiArICAgICAgICAgICAgICAgfSBlbHNlIHsNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICBzdHJ1Y3QgcGFnZSAqcGFnZXNbWlNXQVBfTUFYX0JBVENIX1NJWkVdOw0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBrOw0KPiA+ICsNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICBmb3IgKGsgPSAwOyBrIDwgbnJfcGFnZXM7ICsraykNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHBhZ2VzW2tdID0gZm9saW9fcGFnZShmb2xpbywgc3Rh
cnQgKyBrKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHN3YXBf
YmF0Y2hfY29tcF9kYXRhIGJhdGNoX2NvbXBfZGF0YSA9IHsNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIC5wYWdlcyA9IHBhZ2VzLA0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgLmRzdHMgPSBhY29tcF9jdHgtPmJ1ZmZlcnMsDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAuZGxlbnMgPSBkbGVucywNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIC5lcnJvcnMgPSBlcnJvcnMsDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAubnJfY29tcHMgPSBucl9wYWdlcywNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICB9Ow0KPiANCj4gV2h5IHdvdWxkIHRoaXMgd29yayBnaXZlbiB0aGF0IG5yX3BhZ2Vz
IG1pZ2h0IGJlIGxhcmdlciB0aGFuDQo+IHBvb2wtPmNvbXByX2JhdGNoX3NpemU/DQoNCllvdSBt
ZWFuIHRoZSBiYXRjaGluZyBjYWxsPyBGb3IgYmF0Y2hpbmcgY29tcHJlc3NvcnMsIG5yX3BhZ2Vz
IA0KaXMgYWx3YXlzIDw9IHBvb2wtPmJhdGNoX3NpemUuIEZvciBiYXRjaGluZyBjb21wcmVzc29y
cywgcG9vbC0+YmF0Y2hfc2l6ZQ0KaXMgdGhlIHBvb2wtPmNvbXByX2JhdGNoX3NpemUuDQoNCj4g
DQo+IHVuc2lnbmVkIGludCBucl9jb21wcyA9IG1pbihucl9wYWdlcywgcG9vbC0+Y29tcHJfYmF0
Y2hfc2l6ZSk7DQo+IA0KPiBTbyB0aGlzIGFjdHVhbGx5IGRvZXNu4oCZdCBoYXBwZW4gdW5sZXNz
IHBvb2wtPmNvbXByX2JhdGNoX3NpemUgPT0gMSwNCj4gYnV0IHRoZSBjb2RlIGlzIGNvbmZ1c2lu
ZywgcmlnaHQ/DQo+IA0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBhY29tcF9j
dHgtPnJlcS0+a2VybmVsX2RhdGEgPSAmYmF0Y2hfY29tcF9kYXRhOw0KPiANCj4gQ2FuIHlvdSBh
Y3R1YWxseSBwYXNzIGEgcmVxdWVzdCBsYXJnZXIgdGhhbiBwb29sLT5jb21wcl9iYXRjaF9zaXpl
DQo+IHRvIHRoZSBjcnlwdG8gZHJpdmVyPw0KDQpDbGFyaWZpY2F0aW9uIGFib3ZlLi4NCg0KPiAN
Cj4gQnkgdGhlIHdheSwgc3dhcF9iYXRjaF9jb21wX2RhdGEgc2VlbXMgbGlrZSBhIHBvb3IgbmFt
ZS4gV2h5IHNob3VsZA0KPiBjcnlwdG8gZHJpdmVycyBrbm93IGFueXRoaW5nIGFib3V0IHN3YXBf
PyBrZXJuZWxfZGF0YSBpc27igJl0IGlkZWFsIGVpdGhlcjsNCj4gbWF5YmUgYmF0Y2hfZGF0YSB3
b3VsZCBiZSBiZXR0ZXIgPw0KDQpUaGlzIHdpbGwgYmUgY2hhbmdpbmcgaW4gdjEyIHRvIHVzZSBh
biBTRyBsaXN0IGJhc2VkIG9uIEhlcmJlcnQncyBzdWdnZXN0aW9ucy4NCg0KVGhhbmtzLA0KS2Fu
Y2hhbmENCg0KPiANCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKHVubGlr
ZWx5KGNyeXB0b19hY29tcF9jb21wcmVzcyhhY29tcF9jdHgtPnJlcSkpKQ0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgZ290byBjb21wcmVzc19lcnJvcjsNCj4gPiArICAgICAg
ICAgICAgICAgfQ0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=
