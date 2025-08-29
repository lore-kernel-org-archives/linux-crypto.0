Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8514B950;
	Fri, 29 Aug 2025 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756438802; cv=fail; b=uA59Nkw/F+9EW8aQxswim2OElWzjLiXjO5t7Ltra7SXpj38O1w7popycqUxRGCoucb3uo0xNAT6ydiWjechWZLGA876aymmNvKnEauOL+6afvPea988ZqfVlqNldi+d3vf3oTXou9ctrVHj5nSfOX4DGbELM71THJq7Fds1nuwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756438802; c=relaxed/simple;
	bh=FILO9Yvfxda/8vgUkkqrAN4Un/rNHF9GnHY1FrQm7mw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cK9YadWSN5sAKgFiGCezsqQ0my/I/W3cXmtknuUFQ/nvt/nzo/Cz2cDPWI60cShKpGspk5hwQUnFbglL2q3Vf5byIKAc3NWYydEEPVgAcIwUvsF1Y9AACOk8G6L2RUp2Hvmk+3lvdiIdooO7DH4aDjOY9IWswsu54s632Juh2FI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xl/8lPUn; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xl/8lPUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756438801; x=1787974801;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FILO9Yvfxda/8vgUkkqrAN4Un/rNHF9GnHY1FrQm7mw=;
  b=Xl/8lPUnzXakAdnt82RXN4uuDin4RTvnOdhOHGBUJ4eeZNdOCz0YATge
   0FU4IiEXiwOwLlq82wgWfeW73hP9bTpyNIrAZ+AgslVDN26EJWyBK5L7f
   N/4dvTjZpO/b5nzqtPhd2bB+HjcjMD5Agt3T2VqmNwQi7LOKGGrWxJ/F6
   YhvvkBsHMle7/pW1u39y3eg4Wr1yULTWWgQiqEt8W5h8KQLMtRBNflcRc
   lzgMQ6jR2zjCSdLGsUDR6b2WWDXBCQFOGIl3723PQsVdXjL+QTZ1UfEZZ
   pEpU/vuZXwDDoZLQmknMd/GmnVtSeyGM0/dSLurvoI46zWeT0Us242L5q
   g==;
X-CSE-ConnectionGUID: dpcd7/6QSYyTcnURnc10pg==
X-CSE-MsgGUID: u0UXTuoHRHKVbWinmQ0HWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81313110"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81313110"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:40:00 -0700
X-CSE-ConnectionGUID: 9vQJ1FQKShqWy1eFurponA==
X-CSE-MsgGUID: WkBqFtBZSRuVS9gwJDhQRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175558165"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 20:39:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:39:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 20:39:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.87)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 20:39:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGaFS/4Wd7xR2CUgEMGNX2GZ7wIL+v6QSoexVW+cvY10g44bLcqbnW/InY2AivTPn4FtxAe8jN1Zy8zsy8u1317w36/EE6X+1G684oeKYkr25kV6AXwpePwk+ILFkg5Jm9fWs30N8r3aQdi0x6GYZVRmHcmz5MFbcZBeKmUFQsc7KgiKSxtCghZQl9DZx4I05po6R4ExOqWUUZvxcKHTxM3weZDP7Uq2acTktJBP+sQHK6P5bczlZOSz4wsFHVmtLPENcvagQ72LUUk9O/Oy1Zz2vhIIUdAyPI1mrXDCVbFgugziokRaxmIVLUVLIevCidAehlSoae7CSHwU3VOoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FILO9Yvfxda/8vgUkkqrAN4Un/rNHF9GnHY1FrQm7mw=;
 b=xJkAwbwYDFXd4uuzq2ms6cnnvcxBNqm3Fg3fTJwsg0dt9mPfVy3Wx4w+DxSjbP8NG8whlgqe0HOQ3B7W0GYHLLxbGHKOdPUlCY7ejl+U3MseDt3fxYLB/0qvct8h2iRb576yRu8po8fqjxNxdFcU9BKDrd0J7l/K7/km+tozW1ucpNxH4Fdc+DWgkLPYTPxGo3FsYz0YnAvJddNn5w93VrQrvoxZLGaeiAwW9711H9fNhIuBs5RuwvarBQ0UsN3eKehNhKjwdUQkRSBzP1+lSgguhWLYwQnmw5+dQGiem50LQXfuWYdaIV69vnMsqy20HDmiLS/kP3nu0faI+qnKng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by BN9PR11MB5225.namprd11.prod.outlook.com (2603:10b6:408:132::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 29 Aug
 2025 03:39:51 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 03:39:51 +0000
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
Thread-Index: AQHcAp3rZa+v4TFKjkuil/Grf2UpDbR46OeAgAAzNsCAAAltgIAAASuQ
Date: Fri, 29 Aug 2025 03:39:51 +0000
Message-ID: <PH7PR11MB8121341E3B2C99C34F738B1EC93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xMYUHo_SRc=1jgP6jMNosA_NP3HCitSMKwx=5ScJ0Cng@mail.gmail.com>
 <PH7PR11MB81213032EE672C69B3FC3370C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xH7aU37w03-4MSJs7Bik6pShLfad8RY8TSzj37AcGwDg@mail.gmail.com>
In-Reply-To: <CAGsJ_4xH7aU37w03-4MSJs7Bik6pShLfad8RY8TSzj37AcGwDg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|BN9PR11MB5225:EE_
x-ms-office365-filtering-correlation-id: 83dd219c-472d-48b0-b470-08dde6adb620
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?eGdxS3J4eUMrTko4dm4wVGdGTnlTc3dJVWVHQnZIMHllVXllc2hZS3NmWGI4?=
 =?utf-8?B?QWNxNXBaSURuL3dNRmdpNmg3K01Ub1pBQmQ3dGlPb09TclNmNDVld0JmdTJB?=
 =?utf-8?B?emVqa3NLWDQvVllWUjhpTG1QQ1hjcU5wdEE0cXJzOHQycDM3MFV3UXY1MjdJ?=
 =?utf-8?B?QUtCVm1OUXVxM1lGMTExZDlhVXV5T2lNKytlejg5S0ptcXRjYUEranFYemxR?=
 =?utf-8?B?NVRGTjgza1lKR2xhNUdkT1lDcUROYkhrNEdnMG9OMWtZK3NralhRci96YVlC?=
 =?utf-8?B?REg0ZGFDUkQ1WDdGaVVIQ011UGl0TytRamE2NVQzZkNyMFE4cHhLVXo1Qzd1?=
 =?utf-8?B?aFIwMEMwZ3IyL0VwVWhGNlZORVRlSG82eC94N3BRSkI4SUhiZjhWc3NvazRs?=
 =?utf-8?B?a3RmMVE4L29ma1g2bEl2WG9oQ0ljdWxNM0hodEpReTNzY2dOODFhdjFpeHo3?=
 =?utf-8?B?WHJwYXlOa3dMM3B1MVpvSU5maTUyVzV2VFNZbTJFNm5WWEl2a0ZpdWV1WEd3?=
 =?utf-8?B?c25iSzZaSUVjbW5xbGl4NTNyaHdjdTRuZXgzYndNUjlEV0NqTUFtWUtsRFBo?=
 =?utf-8?B?RXFwaWd3bTVPSG1GWWd1Si9UR2xxMmpUaldPNnJrd2g1YWtIUUFhVkU1OERL?=
 =?utf-8?B?SjMxN0JoVDMxMFZOeDhjblBETFUrNUQvUlVnUzVTTlYwSkY0TkpvZnRvUlY1?=
 =?utf-8?B?MkVza3h1Rll2NStWZFM3ZHoxYXN3UTRIcUhWeDNGekFVQVNhSzY0QzYyTG5p?=
 =?utf-8?B?dTV0ZGNEb05YR0pLaERXUUFoKzdKdGVqZG9NM0ZXQjdFTStEcXlDM251cTdT?=
 =?utf-8?B?clJ3SVl2bnBXeXhsTndwc1huSnBoQ0tSMHBHNzNmenVBZkQrSVFTUnJHRm91?=
 =?utf-8?B?ZGhlZWpwd3drZGJpc1RvOEpwNmtwUWNHY3lJdjZjREUzaW1FZi9rNFFVOGs0?=
 =?utf-8?B?OExyUStJcVdkbE15UGVZNVVobGovbmNENUN5dWkyOTliVzNwcGxzV043Rnhi?=
 =?utf-8?B?TjVsSlRKNEZzTm5adHFiRDBmOFEvWlVKREZ0K0NqamZ0R0hBakR1N1AzRHB3?=
 =?utf-8?B?Q2tQNjdIVG1RMlRKT29kZUJob1NDYjJWbWI0VlowRFZiRVRnTlJ1ZWVVaG9h?=
 =?utf-8?B?bnVFZ012Szhsa3grYWdEcXpVZWVqSEc3WVByYUh1TklIUTBwRDllYzZrcWJW?=
 =?utf-8?B?WWRQYnhCT0wvYVYrYUpxclBwdEdiOUxqUlJZWGg0SjVsMnF3NGJDK0JJRzNJ?=
 =?utf-8?B?V1Z2aytFM0czZC9zNExER2lyVDl3enJndUFjM2ZFWEVpU3dtdDNsT014U2xP?=
 =?utf-8?B?Ym1XK2UxOGw0UVcxVERwMjZTemlKcjRsZEw1a1lNQjBvWStnZHBTVThMenpl?=
 =?utf-8?B?Q3RyNTl5Z0d2R293ZHFRSjJzb0JDeGs1eW4zSXZ5QjhEVmNuVWRiemI0V1Vs?=
 =?utf-8?B?eHFMMjNHYXFqTTNwWUJBVllqdkdDeTFjb1c0UlZEOEVVZnFTQzVnWG9KMWFo?=
 =?utf-8?B?NTlyYzJmbGFFZ2l6QUtzU0lTa1JrUitUSzBjZjZpaE55RlVZVFV5UXkyNG1o?=
 =?utf-8?B?bVNnR0tFRVR0MUdaU3lraWNVcVgwQllZYnVYdUQrSFdMWEhqNnZFUmtVa0pn?=
 =?utf-8?B?eUU4eU5VTS9qdnJObzNFNGZtbEdqVVFQQnlwVWFZNTM5SzVMR01ia2c0Rjdw?=
 =?utf-8?B?ajAxMWtTMkRJRUZZWHN2Z2Urdk1mbDBrMHpEME1iL0JIcDVPdFpqSG1sdzFl?=
 =?utf-8?B?TTkyT21jYWc2MVNMUDJMNGJTeUdwL2tZamhmbTQ3WExQMHZ6S09EY3Vyc2J5?=
 =?utf-8?B?SDMwUmRDRWhkUHlOdDlmOWdqOXp3aW5GaW9VdXJEWnpWNUdqK3hTNVpsWVhY?=
 =?utf-8?B?K1JoOGtFazFTRm5QWVRRYUtjTERPMkxabWhHSm5rS3FJUnk3eHY5OWhPMTJS?=
 =?utf-8?B?L1lvS1VwR2tyUmMrRUcwTXFLZEtTUDBQbjYyeWV5UnQxdURob2F3MjZZQ3ZP?=
 =?utf-8?B?SStWTnFSTnFRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RE8zMXlpVy9hOUZvS3Z3OFpaT0cya0VSd0IwZk84ZVdSaDArc290bGdEOXRB?=
 =?utf-8?B?Y09qS0xjVDFibVZwRDRlRkZISnI3cm4zZjA2Ukc3b3J6bFVwZW05REcxSi9n?=
 =?utf-8?B?T1k3cDFVTC9UQjBqSFpROXQ0ZDBiRXJxQmxBcjBqOHZwR0FieEtXMGlidzhQ?=
 =?utf-8?B?QUFFd0gwVnI4VXEyU0F1VGE5ekRJMUJrUjBNMnRCUm1WV2dPM2dsZGtnM3JX?=
 =?utf-8?B?aENEcEozLzZCMFZtVTZXMUpzK3dzYXIzMHhTRU53SHZQa2tPL2hnQi9MaEc5?=
 =?utf-8?B?WGZnV1FLMUJKWjc4UmVtSlBGbSs3azIzY2Q0Ulk4NnlweW51VVdlaVJQWGZq?=
 =?utf-8?B?S200dHBnSGNVR3ZKVC9yYWw1cDhMMG1pNjlYa083MG1ZZlZ1aGNYNkU1L3ZX?=
 =?utf-8?B?d1pOaXY1Zkp0cW5oS295TVptZWE1YzNoT2JTRXQvZU16WW1rYkNZZGtlejJp?=
 =?utf-8?B?RThrRDVRMGZyKy9hQWNhdFIxakpCZkUwY21KZDRhYzg4WDhtWnNJc2FSbGZk?=
 =?utf-8?B?YWlNNGU4dkJuMlE3TTZlUDJDY01jek5mWWV0WFJ2UzdyVzlnM0JOaFVxTlhC?=
 =?utf-8?B?LzBzWnlnSndSYVRJam44bWZvb1BmVnB6Wk0vODNTUGhFdnBhU1BNZGRoN2l1?=
 =?utf-8?B?NUkxWUlxUFphWGgyUlBpaTI4QVAzd21zcFdTTWVYWjNxOHgzME81SkttV3lJ?=
 =?utf-8?B?M2FxcmZKREs0SXhLV29oNkt2WlgvNkNabVkwcDVjOEg5UWJ3YUZmb2hwY2Jy?=
 =?utf-8?B?eWc3Z1Vhd1QxcmdQdWMvOXJpempJQyt2OEtrT3p4Tk1HaWZVZ1p0bVI0eUhp?=
 =?utf-8?B?cHZsdWtMeUg5SzBBRnAxQlhENTZRTXYrZnI2VTN0L0xwRXB3RnRFeEZJU085?=
 =?utf-8?B?aFFmV0trb01BZ1VEU2lrdXR4ekJQWEdwdWZzNENWRzU1dXRlam1KVENxa0pr?=
 =?utf-8?B?Q1FUbWRBbnUrU2JrcC85bWM0TFJib2hVU0dta3hkd3RnNko4b2RxRldIMldw?=
 =?utf-8?B?NmUwVW1yanczZlQ0aU9VZW5LNmtmdXR3dnlBTlJFOGkyeTErNXYvK0FZbUJn?=
 =?utf-8?B?TG9yTmJlbzQ3bUowa0tSa2lNZFhuelVEN3h6dWR5Ykp5WFlzK2ZsTkFKRTlh?=
 =?utf-8?B?R3hwallOd2c2d2pJUUcyZ1pZOEtDTXFYdVdERGR2Q0Nub3F3V1I4NG1ySFV1?=
 =?utf-8?B?cGM3alhqdlNyc2trZytoT2FJWGxtWDYwanh3OE1UNHUxeFluWlpNZXdXcHFQ?=
 =?utf-8?B?aWNsTjl4bTNlWVFzZDYwSU5PVHQ1S1B4Q0hKYnVMcXhCYjg5T09SbmNncDFU?=
 =?utf-8?B?dGVEbG5jcWhva2toM3hjYk1IbUtXaXlkU3FQRVc3RmE0dTR3Z1h2U1R6dzdv?=
 =?utf-8?B?am04R3Y5Y3ErT2p2MHFwMThMTWhtSmZGa0tLdVVzQWpBdXV5emR0T1pkUm44?=
 =?utf-8?B?TisrVEY0MjZJM3dhWXBETTJkRTFXRWRkSFlEMlUzd0tpcXdrU1pkZUpRNTZN?=
 =?utf-8?B?VTN6aWFUVnBKT3JsWFVJcEdMYW5LSkpqdlZrSU9jTmZuQUxpUm1XWnprRnBV?=
 =?utf-8?B?RmtMc2d1bnFVd1NGVm52OEhGbDFzS1VHaHM2NFJra0lwOVBkazZpV3RtSmo0?=
 =?utf-8?B?U2N2Z1JzRklsRnpJZG1uOFArZUIvMTY2UXhDdXdSTXdWQmdEZm5od2FOQTZT?=
 =?utf-8?B?cnU2am41T0RMZjM2b2VWQ0t0aHVYYldScUYyOGYwS3A0SGRUN1l1dGRwc0Zr?=
 =?utf-8?B?T2Q4UVJwYnY2cTVvSnlsVU10YmphMDdnMXhrc2hNT3VUR2lXZWlpVGVTSWVM?=
 =?utf-8?B?cUNLVklxcllYcXJSQXBteXJKMXRaK3BPQ0pPenpxZ3ZBV3N2NzBBK3ZSMTU5?=
 =?utf-8?B?ZERVdHJMZTVOSWt4anRyUVJCL2oyT05yWDcreWFWM2VidnJXR3pUdE1qRW9J?=
 =?utf-8?B?Z015em5ZOUs2Y0ZKUkY5UllLR1R1cG5leko1c0tPUjBXQnhxeHdyZjJXNFcy?=
 =?utf-8?B?LzhCZlVYcVVvMTgvL2hxeU5pYVlNcFFXT0hIcXBOVE4xdFpmMkQ3ZUo0T3Uw?=
 =?utf-8?B?RWFYVjVocm1ZWXBJL1A3cnpJV0ZBRUFJczI0c25LUXh1VWNIRklKeDRPUjc1?=
 =?utf-8?B?Unk0ci9DcDNqR28xbmtBcW05QkcxaTlrY0Y0ZWUrRDl2VDd6NVJYbk1MWDQ5?=
 =?utf-8?B?a1E9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 83dd219c-472d-48b0-b470-08dde6adb620
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 03:39:51.5555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4aBVGR6uN7tgbVvNkPAx9eI1JyyZCA7mhajVmxHU7X7fGDBb3MUvWRpVss3N101N9DwIeeuSBs/l+8v5qLvw/SdNUZK+bjjFT3P53zW4HAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5225
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI4LCAyMDI1IDg6MzEgUE0N
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
cmdlIGZvbGlvcy4NCj4gDQo+IE9uIEZyaSwgQXVnIDI5LCAyMDI1IGF0IDExOjA14oCvQU0gU3Jp
ZGhhciwgS2FuY2hhbmEgUA0KPiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206
IEJhcnJ5IFNvbmcgPDIxY25iYW9AZ21haWwuY29tPg0KPiA+ID4gU2VudDogVGh1cnNkYXksIEF1
Z3VzdCAyOCwgMjAyNSA0OjU0IFBNDQo+ID4gPiBUbzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2Fu
Y2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4gPiA+IENjOiBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+ID4gPiBoYW5uZXNAY21weGNoZy5vcmc7
IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgbnBoYW1jc0BnbWFpbC5jb207DQo+ID4gPiBjaGVuZ21p
bmcuemhvdUBsaW51eC5kZXY7IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207DQo+ID4gPiByeWFuLnJv
YmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNvbTsgYWtwbUBsaW51eC0N
Cj4gPiA+IGZvdW5kYXRpb24ub3JnOyBzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc7IGxpbnV4LQ0K
PiBjcnlwdG9Admdlci5rZXJuZWwub3JnOw0KPiA+ID4gaGVyYmVydEBnb25kb3IuYXBhbmEub3Jn
LmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+ID4gY2xhYmJlQGJheWxpYnJlLmNvbTsgYXJk
YkBrZXJuZWwub3JnOyBlYmlnZ2Vyc0Bnb29nbGUuY29tOw0KPiA+ID4gc3VyZW5iQGdvb2dsZS5j
b207IEFjY2FyZGksIEtyaXN0ZW4gQyA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsNCj4g
PiA+IEdvbWVzLCBWaW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwg
V2FqZGkgSw0KPiA+ID4gPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2Ro
IDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTEg
MjQvMjRdIG1tOiB6c3dhcDogQmF0Y2hlZCB6c3dhcF9jb21wcmVzcygpDQo+IHdpdGgNCj4gPiA+
IGNvbXByZXNzIGJhdGNoaW5nIG9mIGxhcmdlIGZvbGlvcy4NCj4gPiA+DQo+ID4gPiA+ICtzdGF0
aWMgYm9vbCB6c3dhcF9jb21wcmVzcyhzdHJ1Y3QgZm9saW8gKmZvbGlvLCBsb25nIHN0YXJ0LCB1
bnNpZ25lZCBpbnQNCj4gPiA+IG5yX3BhZ2VzLA0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICBzdHJ1Y3QgenN3YXBfZW50cnkgKmVudHJpZXNbXSwgc3RydWN0IHpzd2FwX3Bvb2wg
KnBvb2wsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBub2RlX2lkKQ0K
PiA+ID4gPiAgew0KPiA+ID4gPiAgICAgICAgIHN0cnVjdCBjcnlwdG9fYWNvbXBfY3R4ICphY29t
cF9jdHg7DQo+ID4gPiA+ICAgICAgICAgc3RydWN0IHNjYXR0ZXJsaXN0IGlucHV0LCBvdXRwdXQ7
DQo+ID4gPiA+IC0gICAgICAgaW50IGNvbXBfcmV0ID0gMCwgYWxsb2NfcmV0ID0gMDsNCj4gPiA+
ID4gLSAgICAgICB1bnNpZ25lZCBpbnQgZGxlbiA9IFBBR0VfU0laRTsNCj4gPiA+ID4gLSAgICAg
ICB1bnNpZ25lZCBsb25nIGhhbmRsZTsNCj4gPiA+ID4gLSAgICAgICBzdHJ1Y3QgenBvb2wgKnpw
b29sOw0KPiA+ID4gPiArICAgICAgIHN0cnVjdCB6cG9vbCAqenBvb2wgPSBwb29sLT56cG9vbDsN
Cj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgIHVuc2lnbmVkIGludCBkbGVuc1taU1dBUF9NQVhf
QkFUQ0hfU0laRV07DQo+ID4gPiA+ICsgICAgICAgaW50IGVycm9yc1taU1dBUF9NQVhfQkFUQ0hf
U0laRV07DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICB1bnNpZ25lZCBpbnQgbnJfY29tcHMg
PSBtaW4obnJfcGFnZXMsIHBvb2wtPmNvbXByX2JhdGNoX3NpemUpOw0KPiA+ID4gPiArICAgICAg
IHVuc2lnbmVkIGludCBpLCBqOw0KPiA+ID4gPiArICAgICAgIGludCBlcnI7DQo+ID4gPiA+ICAg
ICAgICAgZ2ZwX3QgZ2ZwOw0KPiA+ID4gPiAtICAgICAgIHU4ICpkc3Q7DQo+ID4gPiA+ICsNCj4g
PiA+ID4gKyAgICAgICBnZnAgPSBHRlBfTk9XQUlUIHwgX19HRlBfTk9SRVRSWSB8IF9fR0ZQX0hJ
R0hNRU0gfA0KPiA+ID4gX19HRlBfTU9WQUJMRTsNCj4gPiA+ID4NCj4gPiA+ID4gICAgICAgICBh
Y29tcF9jdHggPSByYXdfY3B1X3B0cihwb29sLT5hY29tcF9jdHgpOw0KPiA+ID4gPg0KPiA+ID4g
PiAgICAgICAgIG11dGV4X2xvY2soJmFjb21wX2N0eC0+bXV0ZXgpOw0KPiA+ID4gPg0KPiA+ID4g
PiAtICAgICAgIGRzdCA9IGFjb21wX2N0eC0+YnVmZmVyc1swXTsNCj4gPiA+ID4gLSAgICAgICBz
Z19pbml0X3RhYmxlKCZpbnB1dCwgMSk7DQo+ID4gPiA+IC0gICAgICAgc2dfc2V0X3BhZ2UoJmlu
cHV0LCBwYWdlLCBQQUdFX1NJWkUsIDApOw0KPiA+ID4gPiAtDQo+ID4gPiA+ICAgICAgICAgLyoN
Cj4gPiA+ID4gLSAgICAgICAgKiBXZSBuZWVkIFBBR0VfU0laRSAqIDIgaGVyZSBzaW5jZSB0aGVy
ZSBtYXliZSBvdmVyLQ0KPiBjb21wcmVzc2lvbg0KPiA+ID4gY2FzZSwNCj4gPiA+ID4gLSAgICAg
ICAgKiBhbmQgaGFyZHdhcmUtYWNjZWxlcmF0b3JzIG1heSB3b24ndCBjaGVjayB0aGUgZHN0IGJ1
ZmZlciBzaXplLA0KPiBzbw0KPiA+ID4gPiAtICAgICAgICAqIGdpdmluZyB0aGUgZHN0IGJ1ZmZl
ciB3aXRoIGVub3VnaCBsZW5ndGggdG8gYXZvaWQgYnVmZmVyIG92ZXJmbG93Lg0KPiA+ID4gPiAr
ICAgICAgICAqIE5vdGU6DQo+ID4gPiA+ICsgICAgICAgICogW2ldIHJlZmVycyB0byB0aGUgaW5j
b21pbmcgYmF0Y2ggc3BhY2UgYW5kIGlzIHVzZWQgdG8NCj4gPiA+ID4gKyAgICAgICAgKiAgICAg
aW5kZXggaW50byB0aGUgZm9saW8gcGFnZXMsIEBlbnRyaWVzIGFuZCBAZXJyb3JzLg0KPiA+ID4g
PiAgICAgICAgICAqLw0KPiA+ID4gPiAtICAgICAgIHNnX2luaXRfb25lKCZvdXRwdXQsIGRzdCwg
UEFHRV9TSVpFICogMik7DQo+ID4gPiA+IC0gICAgICAgYWNvbXBfcmVxdWVzdF9zZXRfcGFyYW1z
KGFjb21wX2N0eC0+cmVxLCAmaW5wdXQsICZvdXRwdXQsDQo+ID4gPiBQQUdFX1NJWkUsIGRsZW4p
Ow0KPiA+ID4gPiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBucl9wYWdlczsgaSArPSBucl9jb21w
cykgew0KPiA+ID4gPiArICAgICAgICAgICAgICAgaWYgKG5yX2NvbXBzID09IDEpIHsNCj4gPiA+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc2dfaW5pdF90YWJsZSgmaW5wdXQsIDEpOw0KPiA+
ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBzZ19zZXRfcGFnZSgmaW5wdXQsIGZvbGlvX3Bh
Z2UoZm9saW8sIHN0YXJ0ICsgaSksIFBBR0VfU0laRSwNCj4gMCk7DQo+ID4gPiA+DQo+ID4gPiA+
IC0gICAgICAgLyoNCj4gPiA+ID4gLSAgICAgICAgKiBpdCBtYXliZSBsb29rcyBhIGxpdHRsZSBi
aXQgc2lsbHkgdGhhdCB3ZSBzZW5kIGFuIGFzeW5jaHJvbm91cw0KPiByZXF1ZXN0LA0KPiA+ID4g
PiAtICAgICAgICAqIHRoZW4gd2FpdCBmb3IgaXRzIGNvbXBsZXRpb24gc3luY2hyb25vdXNseS4g
VGhpcyBtYWtlcyB0aGUNCj4gcHJvY2Vzcw0KPiA+ID4gbG9vaw0KPiA+ID4gPiAtICAgICAgICAq
IHN5bmNocm9ub3VzIGluIGZhY3QuDQo+ID4gPiA+IC0gICAgICAgICogVGhlb3JldGljYWxseSwg
YWNvbXAgc3VwcG9ydHMgdXNlcnMgc2VuZCBtdWx0aXBsZSBhY29tcA0KPiByZXF1ZXN0cyBpbg0K
PiA+ID4gb25lDQo+ID4gPiA+IC0gICAgICAgICogYWNvbXAgaW5zdGFuY2UsIHRoZW4gZ2V0IHRo
b3NlIHJlcXVlc3RzIGRvbmUgc2ltdWx0YW5lb3VzbHkuDQo+IGJ1dCBpbg0KPiA+ID4gdGhpcw0K
PiA+ID4gPiAtICAgICAgICAqIGNhc2UsIHpzd2FwIGFjdHVhbGx5IGRvZXMgc3RvcmUgYW5kIGxv
YWQgcGFnZSBieSBwYWdlLCB0aGVyZSBpcw0KPiBubw0KPiA+ID4gPiAtICAgICAgICAqIGV4aXN0
aW5nIG1ldGhvZCB0byBzZW5kIHRoZSBzZWNvbmQgcGFnZSBiZWZvcmUgdGhlIGZpcnN0IHBhZ2Ug
aXMNCj4gPiA+IGRvbmUNCj4gPiA+ID4gLSAgICAgICAgKiBpbiBvbmUgdGhyZWFkIGRvaW5nIHp3
YXAuDQo+ID4gPiA+IC0gICAgICAgICogYnV0IGluIGRpZmZlcmVudCB0aHJlYWRzIHJ1bm5pbmcg
b24gZGlmZmVyZW50IGNwdSwgd2UgaGF2ZQ0KPiBkaWZmZXJlbnQNCj4gPiA+ID4gLSAgICAgICAg
KiBhY29tcCBpbnN0YW5jZSwgc28gbXVsdGlwbGUgdGhyZWFkcyBjYW4gZG8gKGRlKWNvbXByZXNz
aW9uIGluDQo+ID4gPiBwYXJhbGxlbC4NCj4gPiA+ID4gLSAgICAgICAgKi8NCj4gPiA+ID4gLSAg
ICAgICBjb21wX3JldCA9IGNyeXB0b193YWl0X3JlcShjcnlwdG9fYWNvbXBfY29tcHJlc3MoYWNv
bXBfY3R4LQ0KPiA+ID4gPnJlcSksICZhY29tcF9jdHgtPndhaXQpOw0KPiA+ID4gPiAtICAgICAg
IGRsZW4gPSBhY29tcF9jdHgtPnJlcS0+ZGxlbjsNCj4gPiA+ID4gLSAgICAgICBpZiAoY29tcF9y
ZXQpDQo+ID4gPiA+IC0gICAgICAgICAgICAgICBnb3RvIHVubG9jazsNCj4gPiA+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgLyoNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICog
V2UgbmVlZCBQQUdFX1NJWkUgKiAyIGhlcmUgc2luY2UgdGhlcmUgbWF5YmUgb3Zlci0NCj4gPiA+
IGNvbXByZXNzaW9uIGNhc2UsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAqIGFu
ZCBoYXJkd2FyZS1hY2NlbGVyYXRvcnMgbWF5IHdvbid0IGNoZWNrIHRoZSBkc3QNCj4gYnVmZmVy
DQo+ID4gPiBzaXplLCBzbw0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgKiBnaXZp
bmcgdGhlIGRzdCBidWZmZXIgd2l0aCBlbm91Z2ggbGVuZ3RoIHRvIGF2b2lkIGJ1ZmZlcg0KPiA+
ID4gb3ZlcmZsb3cuDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAqLw0KPiA+ID4g
PiArICAgICAgICAgICAgICAgICAgICAgICBzZ19pbml0X29uZSgmb3V0cHV0LCBhY29tcF9jdHgt
PmJ1ZmZlcnNbMF0sIFBBR0VfU0laRSAqDQo+IDIpOw0KPiA+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgICBhY29tcF9yZXF1ZXN0X3NldF9wYXJhbXMoYWNvbXBfY3R4LT5yZXEsICZpbnB1dCwN
Cj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICZvdXRwdXQsIFBBR0VfU0laRSwgUEFHRV9TSVpFKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAg
ICAgICAgICAgICAgICAgICAgICBlcnJvcnNbaV0gPQ0KPiA+ID4gY3J5cHRvX3dhaXRfcmVxKGNy
eXB0b19hY29tcF9jb21wcmVzcyhhY29tcF9jdHgtPnJlcSksDQo+ID4gPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmYWNvbXBfY3R4LT53YWl0
KTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5KGVycm9yc1tp
XSkpDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBjb21wcmVz
c19lcnJvcjsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBkbGVu
c1tpXSA9IGFjb21wX2N0eC0+cmVxLT5kbGVuOw0KPiA+ID4gPiArICAgICAgICAgICAgICAgfSBl
bHNlIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHBhZ2UgKnBhZ2Vz
W1pTV0FQX01BWF9CQVRDSF9TSVpFXTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
dW5zaWduZWQgaW50IGs7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgZm9yIChrID0gMDsgayA8IG5yX3BhZ2VzOyArK2spDQo+ID4gPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcGFnZXNba10gPSBmb2xpb19wYWdlKGZvbGlvLCBzdGFydCArIGsp
Ow0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBzd2Fw
X2JhdGNoX2NvbXBfZGF0YSBiYXRjaF9jb21wX2RhdGEgPSB7DQo+ID4gPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgLnBhZ2VzID0gcGFnZXMsDQo+ID4gPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgLmRzdHMgPSBhY29tcF9jdHgtPmJ1ZmZlcnMsDQo+ID4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLmRsZW5zID0gZGxlbnMsDQo+ID4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLmVycm9ycyA9IGVycm9ycywNCj4gPiA+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAubnJfY29tcHMgPSBucl9wYWdlcywN
Cj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgfTsNCj4gPiA+DQo+ID4gPiBXaHkgd291
bGQgdGhpcyB3b3JrIGdpdmVuIHRoYXQgbnJfcGFnZXMgbWlnaHQgYmUgbGFyZ2VyIHRoYW4NCj4g
PiA+IHBvb2wtPmNvbXByX2JhdGNoX3NpemU/DQo+ID4NCj4gPiBZb3UgbWVhbiB0aGUgYmF0Y2hp
bmcgY2FsbD8gRm9yIGJhdGNoaW5nIGNvbXByZXNzb3JzLCBucl9wYWdlcw0KPiA+IGlzIGFsd2F5
cyA8PSBwb29sLT5iYXRjaF9zaXplLiBGb3IgYmF0Y2hpbmcgY29tcHJlc3NvcnMsIHBvb2wtPmJh
dGNoX3NpemUNCj4gPiBpcyB0aGUgcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZS4NCj4gDQo+IEnigJlt
IGFjdHVhbGx5IGNvbmZ1c2VkIHRoYXQgdGhpcyBmZWVscyBpbmNvbnNpc3RlbnQgd2l0aCB0aGUg
ZWFybGllcg0KPiANCj4gICAgIHVuc2lnbmVkIGludCBucl9jb21wcyA9IG1pbihucl9wYWdlcywg
cG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSk7DQo+IA0KPiBTbyB3aHkgbm90IGp1c3QgdXNlIG5yX2Nv
bXBzIGluc3RlYWQ/DQoNCkdvb2Qgb2JzZXJ2YXRpb24uLiBZZXMsIEkgdG9vIHJlYWxpemVkIHRo
aXMsIGFuZCBoYXZlIGJlZW4gdXNpbmcgbnJfY29tcHMNCmluIHRoZSBjb2RlIHNuaXBwZXRzIEkn
dmUgYmVlbiBzaGFyaW5nIHRoYXQgcHJvdG90eXBlIEhlcmJlcnQncyBTRyBsaXN0IHN1Z2dlc3Rp
b25zLg0KDQpUaGFua3MsDQpLYW5jaGFuYQ0KDQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gdW5zaWdu
ZWQgaW50IG5yX2NvbXBzID0gbWluKG5yX3BhZ2VzLCBwb29sLT5jb21wcl9iYXRjaF9zaXplKTsN
Cj4gPiA+DQo+ID4gPiBTbyB0aGlzIGFjdHVhbGx5IGRvZXNu4oCZdCBoYXBwZW4gdW5sZXNzIHBv
b2wtPmNvbXByX2JhdGNoX3NpemUgPT0gMSwNCj4gPiA+IGJ1dCB0aGUgY29kZSBpcyBjb25mdXNp
bmcsIHJpZ2h0Pw0KPiA+ID4NCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICBhY29tcF9jdHgtPnJlcS0+a2VybmVsX2RhdGEgPSAmYmF0Y2hfY29tcF9kYXRhOw0KPiA+
ID4NCj4gPiA+IENhbiB5b3UgYWN0dWFsbHkgcGFzcyBhIHJlcXVlc3QgbGFyZ2VyIHRoYW4gcG9v
bC0+Y29tcHJfYmF0Y2hfc2l6ZQ0KPiA+ID4gdG8gdGhlIGNyeXB0byBkcml2ZXI/DQo+ID4NCj4g
PiBDbGFyaWZpY2F0aW9uIGFib3ZlLi4NCj4gPg0KPiA+ID4NCj4gPiA+IEJ5IHRoZSB3YXksIHN3
YXBfYmF0Y2hfY29tcF9kYXRhIHNlZW1zIGxpa2UgYSBwb29yIG5hbWUuIFdoeSBzaG91bGQNCj4g
PiA+IGNyeXB0byBkcml2ZXJzIGtub3cgYW55dGhpbmcgYWJvdXQgc3dhcF8/IGtlcm5lbF9kYXRh
IGlzbuKAmXQgaWRlYWwgZWl0aGVyOw0KPiA+ID4gbWF5YmUgYmF0Y2hfZGF0YSB3b3VsZCBiZSBi
ZXR0ZXIgPw0KPiA+DQo+ID4gVGhpcyB3aWxsIGJlIGNoYW5naW5nIGluIHYxMiB0byB1c2UgYW4g
U0cgbGlzdCBiYXNlZCBvbiBIZXJiZXJ0J3Mgc3VnZ2VzdGlvbnMuDQo+ID4NCj4gDQo+IENvb2wu
IFRoYW5rcyENCj4gDQo+IFRoYW5rcw0KPiBCYXJyeQ0K
