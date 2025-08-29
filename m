Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27A312DDA1;
	Fri, 29 Aug 2025 02:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756436228; cv=fail; b=Hy9RuGTn0EVx9WkBxYlTuH9bGb1t9WO0Jn7r+g0kXUrqqSszleAaY/nMEWvgAzfcVA43l10n71i+5X+5WPVkR+oCWaju1Tb9gG7zK/3Ic66oG+AfZfAvxcCleumXIvRdbBWcm1+w+7GYLtIkyaW4ri0ZNyX5leJEywjFrZ3iEuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756436228; c=relaxed/simple;
	bh=yZIRFcNkoDS8bLuioK0VanPW+1WYSHgqqkSxqddQGD4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d+pUE29ocVP5jUS1rSyYyNyzZD1VjTKW9stoVlmY/ahdM6R7ov52L6EBUQycmHyIO0KIFCHtYGw2tOp4KLUPGT+yVg6gFw2yUP8heWAXODpiOXyKK/KFccXPeF1nRncYcJUkqX87Zxu8AqDL2W9CGqXhw9A8fC7a/Nac348YUBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I6UiZ5AG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I6UiZ5AG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756436227; x=1787972227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yZIRFcNkoDS8bLuioK0VanPW+1WYSHgqqkSxqddQGD4=;
  b=I6UiZ5AGeICLGhj+0prAvRB2MusnE6AZ51b+rF4Bv58BmP9KL+O0Wpcp
   8f8kfzaB96S0e/E311GqV3YQr83iE6VQ34hos39sap6LZZSJIb150M58h
   LgB5UWHMuRq8gBh3Z3M4iSHtuMvgueMnmsPrzOw/9Dx1OxBrTG4fcESDB
   b1X4SwOx078Fu4nkePbf0Xdj0AD3tiz+z6P+uUxt8oH0+BuhoSkAKP8pE
   7j+yrTmsdK8hv0K6E8xQD+hjcPsXOXTn5F3qx1dW7WxtwXjENu6kS+kVF
   MgIyumdolXGlylSbpXDI+Xl+RgSCVRk9Oibb6KYpNRSXRIkNUmeX7wSBn
   A==;
X-CSE-ConnectionGUID: i1HgPybwSZG+8vtCJ93noQ==
X-CSE-MsgGUID: kturplKKTE6kUdTZeGtB5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81310399"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81310399"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 19:57:07 -0700
X-CSE-ConnectionGUID: jWxGRBuISzCGmoUwl5TGYg==
X-CSE-MsgGUID: 9bBPHadrQV6m6j/ETVmzqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175552243"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 19:57:06 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 19:57:05 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 19:57:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.83) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 19:57:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kYTfJLiJ0R4Vj46JtwMUnFuJ1ov4uHxwcGmbnTAx1Q/q7Elu3vrscmdwoSq+1lFz92QylTlVF+941jxWzYi3WMPEIKe7wmAia65DIenvYgLs1sXYj2ujIdu8tx5eWj4QZgQMxFIcvLicVoUasUddvnKmXE9uoYjOLhGbEY9S1ewaj5O8yZ77IlrzCMNAzqMNXObm6YECIJMUZcCBRSFiPpCJyL8bJSMJNQGpEJt/Sm5q+wKohIpcQRHP4M/boqMZtvlL0ddwKBYtIEZOkDOEbKyMKDdZ279MM8/7SV7se33xMjAFY/tWz4XbM3/TqvuGyEViMVjI0pajbNPP0fNdCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZIRFcNkoDS8bLuioK0VanPW+1WYSHgqqkSxqddQGD4=;
 b=pFewBLiNjgycRr/Q42TftAWy9vG30HdX9lhrJN3NyQyBhekCw4+HEkv+UOpK2B25iLiIln6hLKurPw5LeuAK272Dn5eruS8E9MkVtHRcoPv+cTg2U99bliFtpnpWxg1n4pdz3aasVKzs4puyxOLO0zg9Kl4AoDF+IRjX3mNdPwVc8iTaFi9JMQCGQJQzkasGJavkkcnzHqJY2G5awOA1ivEaBsC/MEWEMW2VTxHYtTZx8eU+zK5Y5eL13FNTRC+PU1n9299F60L+Bh/dEaderi86fsdhfOwAh9dQdVdTF7Nq3qxugOrUjzDZ0bYt9J0QPsimX8v+8U4U2KmLEq4E0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by PH7PR11MB7146.namprd11.prod.outlook.com (2603:10b6:510:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Fri, 29 Aug
 2025 02:56:53 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 02:56:53 +0000
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
Subject: RE: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHcAp3rCQGkKHFe602Ahq9v7LnzVLR0czwAgAAISGCAAAbQgIAAAQVggAAI1wCAATLsYIADBCAAgAAKX0CAABQZgIAANf6Q
Date: Fri, 29 Aug 2025 02:56:53 +0000
Message-ID: <PH7PR11MB81216DFB4CA6F22E0ED76026C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
 <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
 <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
In-Reply-To: <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|PH7PR11MB7146:EE_
x-ms-office365-filtering-correlation-id: acd3d57b-ff42-4c5e-a580-08dde6a7b53a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?amtmUCtzV1hlb3Y5SzNyS0lzWDhCdEp2YUlYb1c1SXVmUUt5VWlmZml1QUQ1?=
 =?utf-8?B?VjFOZUVlTVpJRTVPMzNQVWVyUW54VWp5bDFSU3hya3M3MjFEWTJxd0I3dVVu?=
 =?utf-8?B?WGZxVkZYdHUxdDdRTnlWUGVDQzhnK3lORDNINGtmdW5oWEFJRU1EdUhlTnY3?=
 =?utf-8?B?YTIzSW5mOGtsQWR5OXptSEFRRFFjcE1UZXhOck1iV1FSSTNXc29JbFArYUg5?=
 =?utf-8?B?TFRFRThjNG1iUWdXZVhvTktSRmEzcXZNQVdoVDRneXNjNkYzajlCZzhraXFy?=
 =?utf-8?B?WnFJR3U0SStwK1l3S0VvZU1TeFIxeGYvSk4xTTFMdWZERjZSNmc4cTZmQk1R?=
 =?utf-8?B?MlQ0WkdQTEkzS04xUTFmUVVlaGJ0ZW9tRzNwcVlFYVBSbkw1R0x4Vi83Wjh1?=
 =?utf-8?B?ZHl6NHcwRzV2V1d2MmFKR25KVGZMbzUrcVY5NmZLWXBxczgvaWRQbkFkZ0Vz?=
 =?utf-8?B?MHBrWGVhTWhqc3FybUxJQVd2eGx2ckhoejJycURUN0V4Y0t6bzVmV2Jzd1hK?=
 =?utf-8?B?WEhHVjRKWjNrRFJDUVBXME1hYnlabmorUkNqSmgrL3JXYVdXWmZyWWExSGUz?=
 =?utf-8?B?c3l5eXFIMnVpdWNwS0NGcWxMQy9uZ0htWEl3YmpOV3BvOVhRYjJVWktweGZM?=
 =?utf-8?B?NS9CQ1JHWEZtbjhCcFZGV0l2TG93R1E2U1hUUHp0L2R0b3VUbzV5aThDZWlE?=
 =?utf-8?B?ZGRqTytLejdXcjZnKzBSUTB1UTdxNVY1SExMZ0dTZlZHV1lHaloxa3N6YjNV?=
 =?utf-8?B?TEE1RlVQaXdRRkxGT1JXV3JndVNtMDdaQThsaUNJVkYzZkdSMHJBNXFSUTJ2?=
 =?utf-8?B?RTlrdTJjdUhGclhucnptQTQ4VVlBa2JtY1IySlNYeTZldnRLd29QUDhGZncx?=
 =?utf-8?B?ZDNsdGJvNDYwZmVDOCtFL1pqRGZ2YzVpdEN5YWpCaTdDMmV4UCtUYWg1ZGds?=
 =?utf-8?B?ZENSWEtKSlVqWHhoM0tmQTNpWmFZK0JYdDlvOXViaHlITlhPRFh6T3pPYVhN?=
 =?utf-8?B?a3RZOEZDUzBIbzdTK1Q5UUUzVjNsZTl3bnIzYzBoUWpaUXd3MHhjZkQycnFs?=
 =?utf-8?B?YzFzL3ZMd3kyWWVZcjRNNEJjMm1PaDlOcWMxTnZwWERiL1Z4ZzBrelJ4N2Zx?=
 =?utf-8?B?TzBDYW54OGpoeGRiVEhoL212b05uK2FndVpMaHZkZXE5a1JEcFlVdVZaVEhX?=
 =?utf-8?B?a3hoaldRTHRuTjcvWXA3T0tsVnh4RjR1UHU5NXRWdGtPT0l3YlhBNFNFcU1G?=
 =?utf-8?B?RE1VQnlibmVhWk9Yb0c2VG01Y0N4dFZjNlRkVUsyODV1K1VxZGcvUzNmeVhn?=
 =?utf-8?B?ZTJYTzdCRThJY2dKOXZ1NGtCcEJVem13M2FpTkQ0VTVtdlcyTEV1TkZXQUpY?=
 =?utf-8?B?UnExUjJqVEp5TnhENHNWcUtmeEkvVmZYNUw5eG1FWExUMWxPZGgwQmZsZjRQ?=
 =?utf-8?B?UXNIV0VSbnZmaEtpOW55NTF1eW1xMjRZdC8rRTlpamd4OURZSHp3ODNmNGRv?=
 =?utf-8?B?UW1OL2ZkWkZNd29kWDRYckpaUCthME12VUZwbUhaeXJSRjJNVStYMHl0L1Rq?=
 =?utf-8?B?ZXR2UEVPdEZFQ2tsd3Fldml2UkFWVjQreWtKeDI1bHpzYW45S2Vya2hOVDhP?=
 =?utf-8?B?QURLV1ZsTmczaFRoOE1zYVU2azJhYmNhNWRZSk5lSkxBZnprU245UnFWd3BP?=
 =?utf-8?B?NU5CVk5jWDV4YXJha3AzeTRxbWlOUEFYYWVybnUrMm1BT0JWVEMyTEQ1bkk5?=
 =?utf-8?B?TXYyV2lUMDNPVE1mSzNHSDVQdHp4Vk81eFhxbUM4cm5MSlk3N2JJQlB2M1F3?=
 =?utf-8?B?bk51S2JiNnkxQ1pJSHFUajZ5M1M4TjNVUmlNdXhpS051RlFDZGJXaDVrRkNE?=
 =?utf-8?B?VGx1TGI0YUJpejFtU1gyWFBYNXh2M2o1S3FiaXgwcDRmTFBaa2JhZERSYWF5?=
 =?utf-8?B?bThCOHBMNm5lSnJKaElwblRWNzJmdTlUZlFrV3oxR0tLYlBXZmtrWVRLTC9h?=
 =?utf-8?B?RmJQdzNnbHdnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjFha1J0cDJ4MzhxVHRJSTdXZ2x3SVo1U1NUMENETkR3a29Pb0x0UzFXeDcz?=
 =?utf-8?B?VUwyVWo4VE5BK3NOVitMcXhRVkdSb05OVFFaeXFXUE05R3pEZTQwT2xpRUto?=
 =?utf-8?B?K2lhUDM3enlOYU91QzQ4TCs1NzRPQ3RYZzJNQWh6ZzlYbFJwSVpmK09iaVJl?=
 =?utf-8?B?UUp6bFp3bml0Umh2QUtvQ2xldlcxOTM2RVJsdFNSSitpNnhWdkVMTUtHTXpC?=
 =?utf-8?B?b2V0QmZxNHlpTk1sRkFDQWEwcm5nTDZIMXgyTE9GZVQ2Q29pSzRabHgrYndD?=
 =?utf-8?B?TXpGY3hvWUhmcmc5Y1g0WU1rTVR5ZVF6bDgrOVdZcVVkVHVhZHllOHFkK2NT?=
 =?utf-8?B?YzkxUU5VVU51QTFIL3cvbDVjaGdTT0U0RGtIc3dTVXN1ZnF3Qkh6dkRReUZ3?=
 =?utf-8?B?MjQybm50RmRid1kvR28yZXRtMDlET2ZvbDZrYmNrTVZqenIrQVNPb3EvYmo4?=
 =?utf-8?B?NWxiWTlZZEpuZEh4WmVuL1FHK3hhVHJVWGFJalpPMjFudDA2Tk9weVdtOU5G?=
 =?utf-8?B?aEx3M25jVnJPYllFdjJFY0JCdDhWU1NjOWV6L2U5QmxRczNuZlAyRlg5TFNQ?=
 =?utf-8?B?VisvVHUwZkpBSWZxS0xsU1IzWjl4R0xoS1oyRlVyUk5KYnd5eGtzcDc2QUZL?=
 =?utf-8?B?VmtvdzE5L3h6NGo3QzdiNGFaR1M3d3ZVNmdJckdnUlBSbHRaTkhnTmRHdHY0?=
 =?utf-8?B?cXdFT3pTSFpqMWtTTkI5ekk1UXpsRm14NW1Rd3dHa2pXekJNdUhxMDY4VktX?=
 =?utf-8?B?WFp3bEJaeklOR0pJd2lFcTYvU0xmRFA2Y1VCV2F0MG56YVlURTdNcVN3VUFx?=
 =?utf-8?B?ZDlQYkZqbTRnOUVNeTdxSFJrRFRKRjE0KzdQZjZCa2lKNlJPWVhMK01mc0Nt?=
 =?utf-8?B?TUFiZFRUa2RyclVRUEJEZWl0NnRGT0QxTnp3YXpwTUhJaTRRTUhreGlwQWxa?=
 =?utf-8?B?NzRqRWlkTWZPcnVnbWJWd1c5ZW8vSERnSWJyMjd6T2NyU3FyR2t2Vmo1RG1p?=
 =?utf-8?B?ZmlpTDBZcFRVZk55UW80cU5IaTFGQkh6YTRPNTNMREgxTk9SZGlRalFraHRj?=
 =?utf-8?B?RlYvZlkxQWRyL0RrTVdqUjhESjY2SEdwQi9PSUZvaVRWc0lFZEZkSk1JR0RS?=
 =?utf-8?B?M2FjcWpGT0Rrc0JjT1Nrc0YxQ3EyVnZjUVJXK015TVF4YnpDUzdxQTdQL21l?=
 =?utf-8?B?NU9aQUJnaDFYQVFjM2hDRnhrR1VyVW03MnA4T3NtZGtXRGNZT2x6bkJLUlBF?=
 =?utf-8?B?Q2F6YjlmL0NKV1ZpTGJ5TXhjdENQUWl3K1JadVhlbFU2ellVR3JDTDl3MmNV?=
 =?utf-8?B?RW1vVFg4cCsyanBCTEV1U0lCakFHYmFobzdCcXAycEtvckc0dXd5UFR5dzVS?=
 =?utf-8?B?dFFUTXFsT2Vza01pdVRTR1g5dzA4eWVYUTZiUmJscXJyaFgvdWNMREVwYlZB?=
 =?utf-8?B?UndoSGtkYUpCWk44djhaVFVLTS9mYU9ldjdWVXgwQUNSemJNQ1V1cVllcTY1?=
 =?utf-8?B?S1FzOVhJOEUvMG93UVVWZC9YNzRDWlJUNFduN3Y5YmJDN25YT2ZNTXB2b2Js?=
 =?utf-8?B?djRqZFBkblkzUm80K2ozVnVVOFQ3djJ3K0dxdWphSEJUYTBoRTdUMTl4VEJK?=
 =?utf-8?B?UHJRTUR2YVg2NWZML1U1aUlOWHg5WXhJNmFMQjZHUmh4VnRsNlRsME9Vby9s?=
 =?utf-8?B?c205L3FEYzhZWHlvQkRnRWpJQlVxN0JlU0N2K0ExZWpHNGkxTnJ5RXg3K0w3?=
 =?utf-8?B?dHZJSEtjcURTcjdFMGZjbFRmSUFHZFBUWTBtaXp4ZGtXTlZDWklFbXYzUk8w?=
 =?utf-8?B?a2pTekd0NGdySXJrN1lPWjFmQ1ZSRVBXWlA0dWFuYmlLYWlHSldaOTdkR3hN?=
 =?utf-8?B?bTNJOFphNW1tRVIvZ25UeWh4LzJQcUNjZjZXcW9kRlJhRFloZjFqVGNyNUtR?=
 =?utf-8?B?QnJRZ3dtUHREWmNWUlNnUW85QU90N1huMythcTNJNmxGUy9rQ3ZFSTB1WEJ6?=
 =?utf-8?B?SlpwNXhoOHdvcm54VGNjQTY2VksrcXpLbVo3UHFsdE1ENVIxMmFSaVhuVE1v?=
 =?utf-8?B?Q3VBQVdBVjRVUUlJdWZZUVNmVXkrTncwaUNESUlNQlZJQjNNaHowUDNKbThh?=
 =?utf-8?B?TEJzSVczM1FZV0NpQ3U5NjRzNHdaenFSY1hWaXRGYXg4elIzek1GaU84SFlK?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd3d57b-ff42-4c5e-a580-08dde6a7b53a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 02:56:53.0366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rjse+K6oOclq7hqrneKvC4SeHKJiZFsI/Knu5pGqO325zuusSulDSaCqTWka/OcmDOH2YWSeGbbRTpj8Siby49ThvxYILbhc5fWEV7Bn3zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7146
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDI4LCAyMDI1IDQ6MjkgUE0N
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
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDIyLzI0XSBtbTogenN3YXA6
IEFsbG9jYXRlIHBvb2wgYmF0Y2hpbmcgcmVzb3VyY2VzDQo+IGlmIHRoZSBjb21wcmVzc29yIHN1
cHBvcnRzIGJhdGNoaW5nLg0KPiANCj4gPiA+DQo+ID4gPiBJZiBaU1dBUF9NQVhfQkFUQ0hfU0la
RSBpcyBzZXQgdG8gOCBhbmQgdGhlcmUgaXMgbm8gaGFyZHdhcmUgYmF0Y2hpbmcsDQo+ID4gPiBj
b21wcmVzc2lvbiBpcyBkb25lIHdpdGggYSBzdGVwIHNpemUgb2YgMS4gSWYgdGhlIGhhcmR3YXJl
IHN0ZXAgc2l6ZSBpcyA0LA0KPiA+ID4gY29tcHJlc3Npb24gb2NjdXJzIGluIHR3byBzdGVwcy4g
SWYgdGhlIGhhcmR3YXJlIHN0ZXAgc2l6ZSBpcyA2LCB0aGUgZmlyc3QNCj4gPiA+IGNvbXByZXNz
aW9uIHVzZXMgYSBzdGVwIHNpemUgb2YgNiwgYW5kIHRoZSBzZWNvbmQgdXNlcyBhIHN0ZXAgc2l6
ZSBvZiAyLg0KPiA+ID4gRG8geW91IHRoaW5rIHRoaXMgd2lsbCB3b3JrPw0KPiA+DQo+ID4gSGkg
QmFycnksDQo+ID4NCj4gPiBUaGlzIHdvdWxkIGJlIG5vbi1vcHRpbWFsIGZyb20gY29kZSBzaW1w
bGljaXR5IGFuZCBsYXRlbmN5IHBlcnNwZWN0aXZlcy4NCj4gPiBPbmUgb2YgdGhlIGJlbmVmaXRz
IG9mIHVzaW5nIHRoZSBoYXJkd2FyZSBhY2NlbGVyYXRvcidzICJiYXRjaCBwYXJhbGxlbGlzbSIN
Cj4gPiBpcyBjb3N0IGFtb3J0aXphdGlvbiBhY3Jvc3MgdGhlIGJhdGNoLiBXZSBtaWdodCBsb3Nl
IHRoaXMgYmVuZWZpdCBpZiB3ZSBtYWtlDQo+ID4gbXVsdGlwbGUgY2FsbHMgdG8genN3YXBfY29t
cHJlc3MoKSB0byBhc2sgdGhlIGhhcmR3YXJlIGFjY2VsZXJhdG9yIHRvDQo+ID4gYmF0Y2ggY29t
cHJlc3MgaW4gc21hbGxlciBiYXRjaGVzLiBDb21wcmVzc2lvbiB0aHJvdWdocHV0IHdvdWxkIGFs
c28NCj4gPiBiZSBzdWItb3B0aW1hbC4NCj4gDQo+IEkgZ3Vlc3MgaXQgd291bGRu4oCZdCBiZSBh
biBpc3N1ZSBpZiBib3RoIFpTV0FQX01BWF9CQVRDSF9TSVpFIGFuZA0KPiBwb29sLT5jb21wcl9i
YXRjaF9zaXplIGFyZSBwb3dlcnMgb2YgdHdvLiBBcyB5b3UgbWVudGlvbmVkLCB3ZSBzdGlsbA0K
PiBnYWluIGltcHJvdmVtZW50IHdpdGggWlNXQVBfTUFYX0JBVENIX1NJWkUgYmF0Y2hpbmcgZXZl
biB3aGVuDQo+IHBvb2wtPmNvbXByX2JhdGNoX3NpemUgPT0gMSwgYnkgY29tcHJlc3NpbmcgcGFn
ZXMgb25lIGJ5IG9uZSBidXQNCj4gYmF0Y2hpbmcgb3RoZXIgd29yayBzdWNoIGFzIHpzd2FwX2Vu
dHJpZXNfY2FjaGVfYWxsb2NfYmF0Y2goKSA/DQo+IA0KPiA+DQo+ID4gSW4gbXkgcGF0Y2gtc2Vy
aWVzLCB0aGUgcnVsZSBpcyBzaW1wbGU6IGlmIGFuIGFsZ29yaXRobSBoYXMgc3BlY2lmaWVkIGEN
Cj4gPiBiYXRjaC1zaXplLCBjYXJ2ZSBvdXQgdGhlIGZvbGlvIGJ5IHRoYXQgImJhdGNoLXNpemUi
ICMgb2YgcGFnZXMgdG8gYmUNCj4gPiBjb21wcmVzc2VkIGFzIGEgYmF0Y2ggaW4genN3YXBfY29t
cHJlc3MoKS4gVGhpcyBjdXN0b20gYmF0Y2gtc2l6ZQ0KPiA+IGlzIGNhcHBlZCBhdCBaU1dBUF9N
QVhfQkFUQ0hfU0laRS4NCj4gPg0KPiA+IElmIGFuIGFsZ29yaXRobSBoYXMgbm90IHNwZWNpZmll
ZCBhIGJhdGNoLXNpemUsIHRoZSBkZWZhdWx0IGJhdGNoLXNpemUNCj4gPiBpcyAxLiBJbiB0aGlz
IGNhc2UsIGNhcnZlIG91dCB0aGUgZm9saW8gYnkgWlNXQVBfTUFYX0JBVENIX1NJWkUNCj4gPiAj
IG9mIHBhZ2VzIHRvIGJlIGNvbXByZXNzZWQgYXMgYSBiYXRjaCBpbiB6c3dhcF9jb21wcmVzcygp
Lg0KPiANCj4gWWVzLCBJIHVuZGVyc3RhbmQgeW91ciBydWxlLiBIb3dldmVyLCBoYXZpbmcgdHdv
IGdsb2JhbCB2YXJpYWJsZXMgaXMgc3RpbGwNCj4gc29tZXdoYXQgY29uZnVzaW5nLiBJdCBtaWdo
dCBiZSBjbGVhcmVyIHRvIHVzZSBhIHNpbmdsZSB2YXJpYWJsZSB3aXRoIGENCj4gY29tbWVudCwg
c2luY2Ugb25lIHZhcmlhYmxlIGNhbiBjbGVhcmx5IGRldGVybWluZSB0aGUgdmFsdWUgb2YgdGhl
IG90aGVyLg0KPiANCj4gQ2FuIHdlIGdldCB0aGUgYmF0Y2hfc2l6ZSBhdCBydW50aW1lIGJhc2Vk
IG9uIHBvb2wtPmNvbXByX2JhdGNoX3NpemU/DQo+IA0KPiAvKg0KPiAgKiBJZiBoYXJkd2FyZSBj
b21wcmVzc2lvbiBzdXBwb3J0cyBiYXRjaGluZywgd2UgdXNlIHRoZSBoYXJkd2FyZSBzdGVwIHNp
emUuDQo+ICAqIE90aGVyd2lzZSwgd2UgdXNlIFpTV0FQX01BWF9CQVRDSF9TSVpFIGZvciBiYXRj
aGluZywgYnV0IHN0aWxsDQo+IGNvbXByZXNzDQo+ICAqIG9uZSBwYWdlIGF0IGEgdGltZS4NCj4g
ICovDQo+IGJhdGNoX3NpemUgPSBwb29sLT5jb21wcl9iYXRjaF9zaXplID4gMSA/IHBvb2wtPmNv
bXByX2JhdGNoX3NpemUgOg0KPiAgICAgICAgICAgICAgWlNXQVBfTUFYX0JBVENIX1NJWkU7DQo+
IA0KPiBXZSBwcm9iYWJseSBkb27igJl0IG5lZWQgdGhpcyBpZiBib3RoIHBvb2wtPmNvbXByX2Jh
dGNoX3NpemUgYW5kDQo+IFpTV0FQX01BWF9CQVRDSF9TSVpFIGFyZSBwb3dlcnMgb2YgdHdvPw0K
DQpJIGFtIG5vdCBzdXJlIEkgdW5kZXJzdGFuZCB0aGlzIHJhdGlvbmFsZSwgYnV0IEkgZG8gd2Fu
dCB0byByZWl0ZXJhdGUNCnRoYXQgdGhlIHBhdGNoLXNldCBpbXBsZW1lbnRzIGEgc2ltcGxlIHNl
dCBvZiBydWxlcy9kZXNpZ24gY2hvaWNlcw0KdG8gcHJvdmlkZSBhIGJhdGNoaW5nIGZyYW1ld29y
ayBmb3Igc29mdHdhcmUgYW5kIGhhcmR3YXJlIGNvbXByZXNzb3JzLA0KdGhhdCBoYXMgc2hvd24g
Z29vZCBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudHMgd2l0aCBib3RoLCB3aGlsZQ0KdW5pZnlpbmcg
enN3YXBfc3RvcmUoKS96c3dhcF9jb21wcmVzcygpIGNvZGUgcGF0aHMgZm9yIGJvdGguDQoNCkFz
IGV4cGxhaW5lZCBiZWZvcmUsIGtlZXBpbmcgdGhlIHR3byB2YXJpYWJsZXMgYXMgZGlzdGluY3Qg
dTggbWVtYmVycw0Kb2Ygc3RydWN0IHpzd2FwX3Bvb2wgaXMgYSBkZXNpZ24gY2hvaWNlIHdpdGgg
dGhlc2UgYmVuZWZpdHM6DQoNCjEpIFNhdmVzIGNvbXB1dGVzIGJ5IGF2b2lkaW5nIGNvbXB1dGlu
ZyB0aGlzIGluIHBlcmZvcm1hbmNlLWNyaXRpY2FsDQogICAgenN3YXBfc3RvcmUoKSBjb2RlLiBJ
IGhhdmUgdmVyaWZpZWQgdGhhdCBkeW5hbWljYWxseSBjb21wdXRpbmcgdGhlDQogICAgYmF0Y2hf
c2l6ZSBiYXNlZCBvbiBwb29sLT5jb21wcl9iYXRjaF9zaXplIGltcGFjdHMgbGF0ZW5jeS4NCg0K
MikgVGhlIG1lbW9yeSBvdmVyaGVhZCBpcyBtaW5pbWFsOiB0aGVyZSBpcyBhdCBtb3N0IG9uZSB6
c3dhcF9wb29sDQogICAgIGFjdGl2ZSBhdCBhbnkgZ2l2ZW4gdGltZSwgb3RoZXIgdGhhbiBhdCBj
b21wcmVzc29yIHRyYW5zaXRpb25zLiBUaGUNCiAgICAgYWRkaXRpb25hbCBvdmVyaGVhZCBpcyBv
bmUgdTgsIGkuZS4sIDEgYnl0ZSBmb3IgMSBydW50aW1lIHN0cnVjdC4NCg0KPiANCj4gPg0KPiA+
ID4NCj4gPiA+IEkgZG9u4oCZdCBxdWl0ZSB1bmRlcnN0YW5kIHdoeSB5b3Ugd2FudCB0byBzYXZl
DQo+ID4gPiBaU1dBUF9NQVhfQkFUQ0hfU0laRSAtIFggcmVzb3VyY2VzLCBzaW5jZSBldmVuIHdp
dGhvdXQgaGFyZHdhcmUNCj4gPiA+IGJhdGNoaW5nDQo+ID4gPiB5b3UgYXJlIHN0aWxsIGFsbG9j
YXRpbmcgYWxsIFpTV0FQX01BWF9CQVRDSF9TSVpFIHJlc291cmNlcy4gVGhpcyBpcyB0aGUNCj4g
PiA+IGNhc2UgZm9yIGFsbCBwbGF0Zm9ybXMgZXhjZXB0IHlvdXJzLg0KPiA+DQo+ID4gTm90IHN1
cmUgSSB1bmRlcnN0YW5kLi4gSnVzdCB0byBjbGFyaWZ5LCB0aGlzIGlzIG5vdCBkb25lIHRvIHNh
dmUgb24gcmVzb3VyY2VzLA0KPiA+IHJhdGhlciBmb3IgdGhlIHJlYXNvbnMgc3RhdGVkIGFib3Zl
Lg0KPiA+DQo+ID4gV2UgYXJlIGFscmVhZHkgc2F2aW5nIG9uIHJlc291cmNlcyBieSBvbmx5IGFs
bG9jYXRpbmcgb25seQ0KPiA+ICJwb29sLT5jb21wcl9iYXRjaF9zaXplIiBudW1iZXIgb2YgcmVz
b3VyY2VzDQo+ID4gKCpub3QqIFpTV0FQX01BWF9CQVRDSF9TSVpFIHJlc291cmNlcyk6DQo+ID4N
Cj4gPiAgICAgICAgIHBvb2wtPmNvbXByX2JhdGNoX3NpemUgPSBtaW4oWlNXQVBfTUFYX0JBVENI
X1NJWkUsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNyeXB0b19h
Y29tcF9iYXRjaF9zaXplKGFjb21wX2N0eC0+YWNvbXApKTsNCj4gPg0KPiA+IEZvciBub24tSW50
ZWwgcGxhdGZvcm1zLCB0aGlzIG1lYW5zIG9ubHkgMSBkc3QgYnVmZmVyIGlzIGFsbG9jYXRlZCwg
YXMNCj4gPiBleHBsYWluZWQgaW4gdGhlIGNvbW1pdCBsb2cgZm9yIHRoaXMgcGF0Y2guDQo+IA0K
PiB5b3UgYXJlIHJpZ2h0LiBJIG1pc3VuZGVyc3Rvb2QgeW91ciBjb2RlIDotKQ0KPiANCj4gPg0K
PiA+ICIgQSAidTggY29tcHJfYmF0Y2hfc2l6ZSIgbWVtYmVyIGlzIGFkZGVkIHRvICJzdHJ1Y3Qg
enN3YXBfcG9vbCIsIGFzIHBlcg0KPiA+IFlvc3J5J3Mgc3VnZ2VzdGlvbi4gcG9vbC0+Y29tcHJf
YmF0Y2hfc2l6ZSBpcyBzZXQgYXMgdGhlIG1pbmltdW0gb2YgdGhlDQo+ID4gY29tcHJlc3Nvcidz
IG1heCBiYXRjaC1zaXplIGFuZCBaU1dBUF9NQVhfQkFUQ0hfU0laRS4gQWNjb3JkaW5nbHksIGl0
DQo+ID4gcHJvY2VlZHMgdG8gYWxsb2NhdGUgdGhlIG5lY2Vzc2FyeSBjb21wcmVzc2lvbiBkc3Qg
YnVmZmVycyBpbiB0aGUNCj4gPiBwZXItQ1BVIGFjb21wX2N0eC4iDQo+IA0KPiBUaGlzIGlzIGZp
bmUsIGJ1dCBpdCBzdGlsbCBkb2VzbuKAmXQgcHJvdmlkZSBhIHN0cm9uZyByZWFzb24gZm9yIGhh
dmluZw0KPiB0d28gZ2xvYmFsIHZhcmlhYmxlcyB3aGVuIG9uZSBjYW4gZnVsbHkgZGV0ZXJtaW5l
IHRoZSB2YWx1ZSBvZiB0aGUgb3RoZXIuDQoNCkhvcGVmdWxseSB0aGUgYWJvdmUgcHJvdmlkZXMg
Y2xhcml0eS4NCg0KVGhhbmtzLA0KS2FuY2hhbmENCg0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=
