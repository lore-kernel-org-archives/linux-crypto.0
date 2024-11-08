Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20A5233D90;
	Fri,  8 Nov 2024 21:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731101682; cv=fail; b=CKhM9nGm7EFJmD+UhKgLuWls6ccEXMych5EIw8weWwdMyJBAgtuDRYbAgbzkh+FSGdVNnhZluoZwTIne3oY1MMMfZYHwx9sZCUR95YLRh1/TyC52Jpyt8PBI1ElG8ncXP6zZ12BnVpQcuHv2VEF5F3PdpRYATNvaFLRdj+Ra1C0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731101682; c=relaxed/simple;
	bh=dvBD316syf/+YTQ0kPMqKUiXr/QwcR9O2niRrzJPx7s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SmxAcLe0lltntKrQrbBTukAyhuw6WQXX2e8joQIpSd4N8L7lJEAZ9gU5RWruNEZyu8fFdktZDEGSlatQhrlwuIH2/qDZrZM6f0OFjBj4J+0BwwqcitVkbs90UZxULml5YDXMJNGVdlKQYamQDTfIFUqAktLM7uqMFH9Nq+rzxFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OTDYVky+; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OTDYVky+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731101680; x=1762637680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dvBD316syf/+YTQ0kPMqKUiXr/QwcR9O2niRrzJPx7s=;
  b=OTDYVky+3vroE0Qf+u3JjzW8nzmqABIIBC7pHc9zcIbptqXPW5EIwDK1
   y44Vqgku4Zz+KvbCK9sEmwQHjm4T9NtMkJIIeohl6duBx8kpmjlttMUE2
   pKUXy7fe3iuShlUgFGLwWsISdV3/HF1oeiamwhBXa7FzZo3u//BblGEmg
   26AoaZF2J7WY5A4xE864xpSfAa0X5dazpIhDv2DaS97TctzxYi3K1nLxQ
   JGFsIXrdBvm9xWVgBx2ZEQyWPuWmUpnnzQ0cG67/1NRJdumuGNIJohc2c
   NzT1L04ZBK1ygZczx63v8in+XOJd9xMfw1ofH6Eomsgsa23nqQeFz2Y66
   Q==;
X-CSE-ConnectionGUID: UnMf6CY7S4ezzaaZGSgG/Q==
X-CSE-MsgGUID: wp1dwRwSTdacJLJFYu8fNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31164690"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31164690"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 13:34:39 -0800
X-CSE-ConnectionGUID: 6Bbkx8KwTfiaC8GC5ruqTA==
X-CSE-MsgGUID: fymWyvBEQJ6AwY9ukMi58Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,139,1728975600"; 
   d="scan'208";a="86535535"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Nov 2024 13:34:40 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 8 Nov 2024 13:34:38 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 8 Nov 2024 13:34:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 13:34:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Apy2roJ1f5qgH+LvS6wtiwWTQ+bP6fu51iG+aAKIzgOF+K53X8ZaW2kNkV3ZDUFQT+L6U7z84ubpRjhIXTh7j2fqjL/6KmdPESA4I1v/bZroR/Eeqm4XBc4n5mcdqKkh9UDKMYfZRZ9xC3/6/P7Q/tGVuul8T9rT+XAKvRzMNaaC/Yhv7jSxmD1iGMJO0LZV29+P7r2mo8xpHqL5VYFxllCkmXBcv99bDr9OH6Vo/f7zUc19cos5NcxgQBoEja9F9uSRfGCE7yTVKAS7xNalZp+Jo84ihLTKRCeMZp3YHdiks3x2pvCgwhcnzbN22SfFPV3wLi7yGS6NAp6uEHiN3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvBD316syf/+YTQ0kPMqKUiXr/QwcR9O2niRrzJPx7s=;
 b=zPUNDfEug8HQsCbG4Pdm4HAAlPcVRNIHi3ObDFTiQiT9QKd8+vPn2niRmrtIiLwJ5sYs0hoEMnuE4UdsFF3WZ4c+AzPE5SLvimeyGBoxi4Lf8fgHwZDUK+xMm+R4MRkwS6bvroG+CrhZaZp70pPrlXjkdpY8/N05HR+ofazKd3l+prPGBQwIm8iS02/n5uQ6sjMMWcedeZ4RQ1Ug5k1r2K7VuzC8d/KcdykpfZcC0g46cVXUrkOMkK/piOYUjjiy1Fk6erVlz416K0yD1b0ZRGyfLMqR4SuLnPaWyKVBQw/KQ/a6gphf2hbp+nh+seTd7KNFZ1MvSNgsbB8efB26Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by CH3PR11MB7392.namprd11.prod.outlook.com (2603:10b6:610:145::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 21:34:30 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Fri, 8 Nov 2024
 21:34:30 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosryahmed@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 08/13] mm: zswap: acomp_ctx mutex lock/unlock
 optimizations.
Thread-Topic: [PATCH v3 08/13] mm: zswap: acomp_ctx mutex lock/unlock
 optimizations.
Thread-Index: AQHbMIEQK42Pjne1UUqSzBL4eixTabKt1JqAgAAT/bA=
Date: Fri, 8 Nov 2024 21:34:30 +0000
Message-ID: <SJ0PR11MB56781832C11754C1ACFCD757C95D2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-9-kanchana.p.sridhar@intel.com>
 <CAJD7tkaWTW3FRJvf1ii19E3Yq0LuB=HxKftkQMB3GyrKUZe2-g@mail.gmail.com>
In-Reply-To: <CAJD7tkaWTW3FRJvf1ii19E3Yq0LuB=HxKftkQMB3GyrKUZe2-g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|CH3PR11MB7392:EE_
x-ms-office365-filtering-correlation-id: dc332164-c643-44a8-3119-08dd003d2107
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bWwyT2ZoOFR0d1RVTE02d2t0RHE1UWFDa2pSbmRTNzhtRzRCQlR1Z0N2UW9l?=
 =?utf-8?B?Wjl4aGJWRGR3ZEowc2R2VTdIMDRwVUo5UTV6UFUvYjNTN0JjaDZLRlQxS3BG?=
 =?utf-8?B?b0pmeFlKN1RJSkNacFZuWnY3dE4veXkrc3BtQ01oa2FKZW1DczVZeUNWSTRp?=
 =?utf-8?B?eGRyak5EVXRGa1VqVFVNcWFxVVo3cVk5VHdyU2dEbW9BQmN6WWNFNExZNGpC?=
 =?utf-8?B?bXpkMFVFN2QvMlB2dDRTQlYrai9oNXliYnNxSEFSNTRpR1pOWHJiMzNZdi83?=
 =?utf-8?B?MnRzd2FFeGdyRnZPTTBVdk9JQWgxaHJZSzRrekhIUnhRMG9XdjFleVJRSit4?=
 =?utf-8?B?U1F1d1NmRTVFRVpoWnhLemZOa2dYbTdlczZzdXE0T0E5bkNzbksvckt1MTJ2?=
 =?utf-8?B?UVdDdENVcHl2V21VNXJXdkppREZHRVAySytXQngxVVdpQkpJZkxmV29WVC83?=
 =?utf-8?B?bldpY01pUzVKMHRKZzJ5VGYzYUtydGx2VmJrUktPdGJqR0IwakptODA0QXR4?=
 =?utf-8?B?TG03bG9vakt3ZzdBbEdiMXdaQS9WOTFyM0VkbC9BdytVakxJVktQY0tZOGx2?=
 =?utf-8?B?YUphcHo0MGxKaUUybU1iNFhxaDBGVEN5dUJnV3FQKzhRWDJMTFpVckx2U3NJ?=
 =?utf-8?B?NjdKcUNPa2QwME1TWlRGMnhNVFVEeVNWVyszY3paMHRDRHpHWUUrSTJnV1hM?=
 =?utf-8?B?S3BmYTMvQTNMYU4rS0RKdkxwd3lEVWVRSUVRSDJDRzZkTy9DR0tRMEFGSVNU?=
 =?utf-8?B?ZG03NjFjY3dlZHFSd0d0cEk0ZVB3UkhyUGJqaVh1M1FOZ3UvUzdOQmtORGRH?=
 =?utf-8?B?RU92ZGNjcnFHQnpkMGtWV2h5Yi9rZW1DZE11MExFYkFYU2N0dzdEdnpCS01I?=
 =?utf-8?B?RzFHNmVnYi9pYm43aWpGNFl3TDJWandTejQ2VzkzdkFtWlIzbFdRZnE4VjZs?=
 =?utf-8?B?K1NvNGRWbXpkVUZwSjhzQ1I4RzZPamY4NEdkUllnaUpIN2VVVVIwNXJyMjBL?=
 =?utf-8?B?N3dsbjFZTUppNDFUMlF3aFNZR3p3Qitudk5hc05KZ2JZdVJ4RWpMQjlYRkJ6?=
 =?utf-8?B?c3RDb09VVFZicWZYVGxyeUxWMWJiTkN4d2xyZmNhWEM4UCtGcGo2Mkd6c0Rw?=
 =?utf-8?B?Q0YyNGUvYStuc1NjY1NqRkRNNlVPMkorb2xqVzl0Y0MxdlI1NUZtVVR6M004?=
 =?utf-8?B?TEFCRG5ocnJjUkpXdU0zWDJHRjN1bkhJRTd6UkNkYmpzYmlTSmI0U0c3R1p4?=
 =?utf-8?B?R3RjLys3dk1abVMxU2o4SWIxTGZQZzdTWW1meXo3c3FaaGxUWmJWeUJIZUp4?=
 =?utf-8?B?SWdZZEVQa0E0SkNlbThVYi9VTXV5ck0rei9aVnMwdnlTK2Y2ekdicWpQTEcv?=
 =?utf-8?B?TkpZOVF2Y0t3WnR5TkVBZ21RSC8rb2RBUW9FUUVCRTlHeDQyYWhKMmtIR3d4?=
 =?utf-8?B?TVc0cHhhWngxdjNRNHdFcS85bGlwMThiT0ZLWjVrbWtqTmhpVjRDaldyR2ww?=
 =?utf-8?B?REJxSkNVZEpmRElMQUl2UHdrOXdpSHlabjNSSWFzajg1WVRRZFBFSU9MYWYy?=
 =?utf-8?B?REdXc01vYUV5U1lTanhHVVpEbmd5bTN4cDVVRTdONjNMYllmZG1TLzEvelU1?=
 =?utf-8?B?c21oSGFYQkZvNG0rdXRrSXRrdmlRT0o5V2R0ZW4rdlpoRFZVVWszdnh6UW53?=
 =?utf-8?B?bW9RRDNDU3NmZVFmbFBvOVVKQjhkSDBtT2ZLZWlYc2gvcUpRVm56VTFObkZG?=
 =?utf-8?B?Tm1SRmV5TXhRamFudVMzVnVmdTFKdGtkVFpCWlI3SzN6bGFjSE1UMUQ3ZXdo?=
 =?utf-8?Q?5kaXHWSoN+kQh0xc9FcSWuKarWBcjsBhtfqlQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2tub05ReUNOekY4RXJhRDFkaEh6RFlXeERYY2s3YmljZStXNEgzOVJSV2dE?=
 =?utf-8?B?TWEwSTVmRkp3Y1IweE10SlgvV25rV1dnZWtlN3hCWE5acWZuMGs0TjVlVHNZ?=
 =?utf-8?B?a2ZUaUtpODJVR1BVQ1F5VnJpY0pPaFpiZjcyTmIralI5UURtTkd1QzF4VWxk?=
 =?utf-8?B?K0lvNnNVYW1NQ1U5UGVUa3JzaW1VSWdrTGFuRTdzOWh3ZFNQQkY0dVFGbWpJ?=
 =?utf-8?B?ZXRtTWc1R0tHRzFZVGVtWHhYdjZ6ZFhXZHlKcjFmcllzZHB2OUlRSzUrbFVX?=
 =?utf-8?B?K1hBRzBUODZQei9wRUNWYTdsOVVFd1JvdmFjM09CMHlGSDg4M1J3NGZFR0tI?=
 =?utf-8?B?RCs1UVY1QmxHbU9wTTdxZEZXRmFhMzJOY2VCQytaL1NDOTVvek9DS3VnYUp6?=
 =?utf-8?B?ZExLWW01MmxVV0xZRlZITEgvQkJIaXVYQXkwQnpQUUVlNkxKVmU2ZFBzTll6?=
 =?utf-8?B?WmtIcG1JTVVKYzNMMDZHcW9pMXJWMStma2hkRTRTTVR3T1Vlc3ZFaE5sUXQ4?=
 =?utf-8?B?eklabXVaVzhSL01valV4c0lLMCtaM1VvOHFZTmtPVyt6cDBwNytzMUF5SFJz?=
 =?utf-8?B?VTErS3dEcEQrbTNKU01uTUpTL0lRanNYZDdtbmJhYTBGTzdXOXAxbHQwU3c0?=
 =?utf-8?B?K3BaUnF6VEQ2aFBROWRqYmY1ZnR6ZXFrNWRYVnJTV2w4ai96L2UyQ2lERDFB?=
 =?utf-8?B?WUl4azJjR0RhbmhRSmRPSi9KT3UvODlwaDR2RGZrd2JRbENFdWd3dllpWmx1?=
 =?utf-8?B?NUcySWcxdE5TWlBGY2dpTE1TWnBjWERvc2RaUVFKUlJkUUtNakJ0TXZ3L29h?=
 =?utf-8?B?dWRaY3hWbW4wUEs3dzdQbEd0ZWhZNmlOT0diMFJRTFJMYVZpWWh5V1NadW5T?=
 =?utf-8?B?SWNpZXRqYlFsUUlsa0ttK2xpbWE4Ti9wSmdQd2haVEQvQ3dKeFdpZGZGeEdm?=
 =?utf-8?B?SzJIL2JQZ1VvVFZjUzlNYjBxM2dEd1E4ZlJRTmhYTngzd3Jtbnc1WEVsSkZi?=
 =?utf-8?B?L3AvbkJFWU9BWlMvS3A1aXRaV29mZWNRTndjbWlyRCtuUGdFZTZuUUdobEV6?=
 =?utf-8?B?UWM2c2pFL0JINGM0QTBJTEVhZ0VzU1FTQ1dES1IvM2RkLyswQ24zWHBFV0Fj?=
 =?utf-8?B?MkN0Uy9sNFZNQ0pXdDNab2pVbVMySVRlcWJ0ZGFDNVllNVhqOTRuVlo4NEFr?=
 =?utf-8?B?ZXBVUm1uMDlQelpPVG43c0hUQllLU0tnSklNclZSUVFrd1ZHeGdVL1FhZ0ly?=
 =?utf-8?B?STFmTE9TVi9vdXpwSElCMTRyb3JLY0RRRWVINnlWUmJPMUlwRGw4cVA2N211?=
 =?utf-8?B?L21UM0srWVVOTVdubHg1UE50TUxSc3lXZ052QjhDNG1DUnI2NXRFdk9KN3Vi?=
 =?utf-8?B?NE9zNFUvTHJUUXNBV2lLRXFLOHZEME5yY3ZSZ2tROHVvWVo0bnpCOEtkcUZ5?=
 =?utf-8?B?blowb0JwTGNMZjQyYS9QT2dNL1ZydnFMbWYvck1GeDdCazV6WHJWWklBRm9H?=
 =?utf-8?B?TGx3WmoveGw5MUxZMmw3c2NsYzJURnp2dkc3L3JiOU9KQXE4d2hxSzJlT2Uv?=
 =?utf-8?B?YlV4MFVsNDhjTWhWSWZ5ZVluakRNK1RlNUQremVnbkVpV1psTVRiYldIYzY0?=
 =?utf-8?B?dWRWQ05tcEV6cFBhdFAzVUFGd2xtU0dqRld0MlZPRU5NZE1aWVQ0Wkh3MEFD?=
 =?utf-8?B?OFV5MExuaEpJRkpYSURHaFAvZGZEUnB2RmtEcUVGTHJTcStwY29iamgxaENj?=
 =?utf-8?B?V2JKU0pkU2VBb3ZpTHdLdjViRSsxRDVnVGhaL2ZOak9Oc3JzQ3UyTExyTU1V?=
 =?utf-8?B?M2ppVDd5MjdPOVo2TUk4aUxubG1JdE5McGluMW5GVFhJcUxQYUJMMkNuMHNK?=
 =?utf-8?B?SmJaYUJ6cGhsNzBkcnZjbFpWYXBNVzdFaTF5SGxnQzFkRjI0c1VDRDlETmpH?=
 =?utf-8?B?ejRvWWdTMUYvZzB4bUswZTFNaE53RmNDek4zUk4rcUlRazN2bnJQL1M0RlBV?=
 =?utf-8?B?d01LUFYvUHB1VERPNHpKU3dPczROSHZZMTVqak15MGt4blkyQVp2K3Vqc1J6?=
 =?utf-8?B?OXhqeU80R3RBZUJia2R5Y2Z3S2llUm96R254c0phMGhoWjFjQUVReC9za2t0?=
 =?utf-8?B?WFlpSXUrMUpmUklXL3Vubnh3bDZ3MmFhNlhvdFNVOEMrMElBdzZNMWlEcWNT?=
 =?utf-8?B?Nmc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dc332164-c643-44a8-3119-08dd003d2107
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2024 21:34:30.3326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MmQatn5toTdfeDBBnPEGDP8OdFk2O7hMKJ7APhVfNHMqaK8V8u0D4AWdqH/hPRas7kUcwHyzxxOdXAGYsbhQeQ/kAtrvKOrxz2F7Y72byo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7392
X-OriginatorOrg: intel.com

SGkgWW9zcnksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWW9zcnkg
QWhtZWQgPHlvc3J5YWhtZWRAZ29vZ2xlLmNvbT4NCj4gU2VudDogRnJpZGF5LCBOb3ZlbWJlciA4
LCAyMDI0IDEyOjE0IFBNDQo+IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNy
aWRoYXJAaW50ZWwuY29tPg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGlu
dXgtbW1Aa3ZhY2sub3JnOw0KPiBoYW5uZXNAY21weGNoZy5vcmc7IG5waGFtY3NAZ21haWwuY29t
OyBjaGVuZ21pbmcuemhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207IHJ5
YW4ucm9iZXJ0c0Bhcm0uY29tOyBIdWFuZywgWWluZw0KPiA8eWluZy5odWFuZ0BpbnRlbC5jb20+
OyAyMWNuYmFvQGdtYWlsLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gbGludXgt
Y3J5cHRvQHZnZXIua2VybmVsLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Ow0KPiBk
YXZlbUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7
DQo+IGViaWdnZXJzQGdvb2dsZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLCBLcmlz
dGVuIEMNCj4gPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47IHphbnVzc2lAa2VybmVsLm9y
ZzsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFs
LCBWaW5vZGggPHZpbm9kaC5nb3BhbEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djMgMDgvMTNdIG1tOiB6c3dhcDogYWNvbXBfY3R4IG11dGV4IGxvY2svdW5sb2NrDQo+IG9wdGlt
aXphdGlvbnMuDQo+IA0KPiBPbiBXZWQsIE5vdiA2LCAyMDI0IGF0IDExOjIx4oCvQU0gS2FuY2hh
bmEgUCBTcmlkaGFyDQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3cm90ZToNCj4g
Pg0KPiA+IFRoaXMgcGF0Y2ggaW1wbGVtZW50cyB0d28gY2hhbmdlcyB3aXRoIHJlc3BlY3QgdG8g
dGhlIGFjb21wX2N0eCBtdXRleA0KPiBsb2NrOg0KPiANCj4gVGhlIGNvbW1pdCBzdWJqZWN0IGlz
IG1pc2xlYWRpbmcsIG9uZSBvZiB0aGVzZSBpcyBkZWZpbml0ZWx5IG5vdCBhbg0KPiBvcHRpbWl6
YXRpb24uDQo+IA0KPiBBbHNvLCBpZiB3ZSBhcmUgZG9pbmcgdHdvIHVucmVsYXRlZCB0aGluZ3Mg
d2Ugc2hvdWxkIGRvIHRoZW0gaW4gdHdvDQo+IHNlcGFyYXRlIGNvbW1pdHMuDQoNClRoYW5rcyBm
b3IgdGhlIGNvZGUgcmV2aWV3IGNvbW1lbnRzLiBJIGFncmVlLCB0aGVzZSBzaG91bGQgYmUgdHdv
DQpzZXBhcmF0ZSBjb21taXRzLg0KDQo+IA0KPiA+DQo+ID4gMSkgVGhlIG11dGV4IGxvY2sgaXMg
bm90IGFjcXVpcmVkL3JlbGVhc2VkIGluIHpzd2FwX2NvbXByZXNzKCkuIEluc3RlYWQsDQo+ID4g
ICAgenN3YXBfc3RvcmUoKSBhY3F1aXJlcyB0aGUgbXV0ZXggbG9jayBvbmNlIGJlZm9yZSBjb21w
cmVzc2luZyBlYWNoDQo+IHBhZ2UNCj4gPiAgICBpbiBhIGxhcmdlIGZvbGlvLCBhbmQgcmVsZWFz
ZXMgdGhlIGxvY2sgb25jZSBhbGwgcGFnZXMgaW4gdGhlIGZvbGlvIGhhdmUNCj4gPiAgICBiZWVu
IGNvbXByZXNzZWQuIFRoaXMgc2hvdWxkIHJlZHVjZSBzb21lIGNvbXB1dGUgY3ljbGVzIGluIGNh
c2Ugb2YNCj4gbGFyZ2UNCj4gPiAgICBmb2xpbyBzdG9yZXMuDQo+IA0KPiBJIHVuZGVyc3RhbmQg
aG93IGJvdW5jaW5nIHRoZSBtdXRleCBhcm91bmQgY2FuIHJlZ3Jlc3MgcGVyZm9ybWFuY2UsDQo+
IGJ1dCBJIGV4cGVjdCB0aGlzIHRvIGJlIG1vcmUgZHVlIHRvIHRoaW5ncyBsaWtlIGNhY2hlbGlu
ZSBib3VuY2luZyBhbmQNCj4gYWxsb3dpbmcgcmVjbGFpbSB0byBtYWtlIG1lYW5pbmdmdWwgcHJv
Z3Jlc3MgYmVmb3JlIGdpdmluZyB1cCB0aGUNCj4gbXV0ZXgsIHJhdGhlciB0aGFuIHRoZSBhY3R1
YWwgY3ljbGVzIHNwZW50IGFjcXVpcmluZyB0aGUgbXV0ZXguDQo+IA0KPiBEbyB5b3UgaGF2ZSBh
bnkgbnVtYmVycyB0byBzdXBwb3J0IHRoYXQgdGhpcyBpcyBhIG5ldCBpbXByb3ZlbWVudD8gV2UN
Cj4gdXN1YWxseSBiYXNlIG9wdGltaXphdGlvbnMgb24gZGF0YS4NCg0KTWFrZXMgc2Vuc2UuIEkg
d2lsbCBnYXRoZXIgdGhlIGRhdGEgdG8gbW90aXZhdGUgdGhpcy4gSW4gbXkgaW50ZXJuYWwgdmFs
aWRhdGlvbiwNCkkgaGF2ZSBiZWVuIHJlLWV2YWx1YXRpbmcgaWYgdGhpcyBhY3F1aXJlL3JlbGVh
c2Ugb25jZSBwZXIgbGFyZ2UgZm9saW8gc3RvcmUNCnN0aWxsIG1ha2VzIHNlbnNlLCBiZWNhdXNl
IGl0IHJ1bnMgdGhlIHJpc2sgb2YgaW50cm9kdWNpbmcgbG9uZyBsYXRlbmN5IHBhdGhzDQp3aXRo
aW4gYSBzbGVlcGluZyBtdXRleC4gSSB3aWxsIHF1YW50aWZ5IHRoZSBiZW5lZml0cyBvZiB0aGlz
IChpZiBhdCBhbGwpIGFuZCB1cGRhdGUuDQoNCj4gDQo+ID4gMikgSW4genN3YXBfZGVjb21wcmVz
cygpLCB0aGUgbXV0ZXggbG9jayBpcyByZWxlYXNlZCBhZnRlciB0aGUgY29uZGl0aW9uYWwNCj4g
PiAgICB6cG9vbF91bm1hcF9oYW5kbGUoKSBiYXNlZCBvbiAic3JjICE9IGFjb21wX2N0eC0+YnVm
ZmVyIiByYXRoZXIgdGhhbg0KPiA+ICAgIGJlZm9yZS4gVGhpcyBlbnN1cmVzIHRoYXQgdGhlIHZh
bHVlIG9mICJzcmMiIG9idGFpbmVkIGVhcmxpZXIgZG9lcyBub3QNCj4gPiAgICBjaGFuZ2UuIElm
IHRoZSBtdXRleCBsb2NrIGlzIHJlbGVhc2VkIGJlZm9yZSB0aGUgY29tcGFyaXNvbiBvZiAic3Jj
IiBpdA0KPiA+ICAgIGlzIHBvc3NpYmxlIHRoYXQgYW5vdGhlciBjYWxsIHRvIHJlY2xhaW0gYnkg
dGhlIHNhbWUgcHJvY2VzcyBjb3VsZA0KPiA+ICAgIG9idGFpbiB0aGUgbXV0ZXggbG9jayBhbmQg
b3Zlci13cml0ZSB0aGUgdmFsdWUgb2YgInNyYyIuDQo+IA0KPiBUaGlzIHNlZW1zIGxpa2UgYSBi
dWcgZml4IGZvciA5YzUwMDgzNWYyNzkgKCJtbTogenN3YXA6IGZpeCBrZXJuZWwgQlVHDQo+IGlu
IHNnX2luaXRfb25lIikuIFRoYXQgY29tbWl0IGNoYW5nZWQgY2hlY2tpbmcgYWNvbXBfY3R4LT5p
c19zbGVlcGFibGUNCj4gb3V0c2lkZSB0aGUgbXV0ZXgsIHdoaWNoIHNlZW1zIHRvIGJlIHNhZmUs
IHRvIGNoZWNraW5nDQo+IGFjb21wX2N0eC0+YnVmZmVyLg0KPiANCj4gSWYgbXkgdW5kZXJzdGFu
ZGluZyBpcyBjb3JyZWN0LCB0aGlzIG5lZWRzIHRvIGJlIHNlbnQgc2VwYXJhdGVseSBhcyBhDQo+
IGhvdGZpeCwgd2l0aCBhIHByb3BlciBGaXhlcyB0YWcgYW5kIENDIHN0YWJsZS4gVGhlIHNpZGUg
ZWZmZWN0IHdvdWxkDQo+IGJlIHRoYXQgd2UgbmV2ZXIgdW5tYXAgdGhlIHpwb29sIGhhbmRsZSBh
bmQgZXNzZW50aWFsbHkgbGVhayB0aGUNCj4gbWVtb3J5LCByaWdodD8NCg0KU3VyZSwgSSB3aWxs
IHNlbmQgdGhpcyBzZXBhcmF0ZWx5IGFzIGEgaG90Zml4LiBZZXMsIHRoZSBzaWRlIGVmZmVjdCB5
b3UNCmRlc2NyaWJlIGlzIGNvcnJlY3QuDQoNClRoYW5rcywNCkthbmNoYW5hDQoNCj4gDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBLYW5jaGFuYSBQIFNyaWRoYXIgPGthbmNoYW5hLnAuc3JpZGhh
ckBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIG1tL3pzd2FwLmMgfCAxOSArKysrKysrKysrKysr
KystLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL21tL3pzd2FwLmMgYi9tbS96c3dhcC5jDQo+ID4g
aW5kZXggZjYzMTZiNjZmYjIzLi4zZTg5OWZhNjE0NDUgMTAwNjQ0DQo+ID4gLS0tIGEvbW0venN3
YXAuYw0KPiA+ICsrKyBiL21tL3pzd2FwLmMNCj4gPiBAQCAtODgwLDYgKzg4MCw5IEBAIHN0YXRp
YyBpbnQgenN3YXBfY3B1X2NvbXBfZGVhZCh1bnNpZ25lZCBpbnQgY3B1LA0KPiBzdHJ1Y3QgaGxp
c3Rfbm9kZSAqbm9kZSkNCj4gPiAgICAgICAgIHJldHVybiAwOw0KPiA+ICB9DQo+ID4NCj4gPiAr
LyoNCj4gPiArICogVGhlIGFjb21wX2N0eC0+bXV0ZXggbXVzdCBiZSBsb2NrZWQvdW5sb2NrZWQg
aW4gdGhlIGNhbGxpbmcNCj4gcHJvY2VkdXJlLg0KPiA+ICsgKi8NCj4gPiAgc3RhdGljIGJvb2wg
enN3YXBfY29tcHJlc3Moc3RydWN0IHBhZ2UgKnBhZ2UsIHN0cnVjdCB6c3dhcF9lbnRyeSAqZW50
cnksDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHpzd2FwX3Bvb2wgKnBv
b2wpDQo+ID4gIHsNCj4gPiBAQCAtODk1LDggKzg5OCw2IEBAIHN0YXRpYyBib29sIHpzd2FwX2Nv
bXByZXNzKHN0cnVjdCBwYWdlICpwYWdlLA0KPiBzdHJ1Y3QgenN3YXBfZW50cnkgKmVudHJ5LA0K
PiA+DQo+ID4gICAgICAgICBhY29tcF9jdHggPSByYXdfY3B1X3B0cihwb29sLT5hY29tcF9jdHgp
Ow0KPiA+DQo+ID4gLSAgICAgICBtdXRleF9sb2NrKCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPiAt
DQo+ID4gICAgICAgICBkc3QgPSBhY29tcF9jdHgtPmJ1ZmZlcjsNCj4gPiAgICAgICAgIHNnX2lu
aXRfdGFibGUoJmlucHV0LCAxKTsNCj4gPiAgICAgICAgIHNnX3NldF9wYWdlKCZpbnB1dCwgcGFn
ZSwgUEFHRV9TSVpFLCAwKTsNCj4gPiBAQCAtOTQ5LDcgKzk1MCw2IEBAIHN0YXRpYyBib29sIHpz
d2FwX2NvbXByZXNzKHN0cnVjdCBwYWdlICpwYWdlLA0KPiBzdHJ1Y3QgenN3YXBfZW50cnkgKmVu
dHJ5LA0KPiA+ICAgICAgICAgZWxzZSBpZiAoYWxsb2NfcmV0KQ0KPiA+ICAgICAgICAgICAgICAg
ICB6c3dhcF9yZWplY3RfYWxsb2NfZmFpbCsrOw0KPiA+DQo+ID4gLSAgICAgICBtdXRleF91bmxv
Y2soJmFjb21wX2N0eC0+bXV0ZXgpOw0KPiA+ICAgICAgICAgcmV0dXJuIGNvbXBfcmV0ID09IDAg
JiYgYWxsb2NfcmV0ID09IDA7DQo+ID4gIH0NCj4gPg0KPiA+IEBAIC05ODYsMTAgKzk4NiwxNiBA
QCBzdGF0aWMgdm9pZCB6c3dhcF9kZWNvbXByZXNzKHN0cnVjdA0KPiB6c3dhcF9lbnRyeSAqZW50
cnksIHN0cnVjdCBmb2xpbyAqZm9saW8pDQo+ID4gICAgICAgICBhY29tcF9yZXF1ZXN0X3NldF9w
YXJhbXMoYWNvbXBfY3R4LT5yZXEsICZpbnB1dCwgJm91dHB1dCwgZW50cnktDQo+ID5sZW5ndGgs
IFBBR0VfU0laRSk7DQo+ID4gICAgICAgICBCVUdfT04oY3J5cHRvX3dhaXRfcmVxKGNyeXB0b19h
Y29tcF9kZWNvbXByZXNzKGFjb21wX2N0eC0NCj4gPnJlcSksICZhY29tcF9jdHgtPndhaXQpKTsN
Cj4gPiAgICAgICAgIEJVR19PTihhY29tcF9jdHgtPnJlcS0+ZGxlbiAhPSBQQUdFX1NJWkUpOw0K
PiA+IC0gICAgICAgbXV0ZXhfdW5sb2NrKCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPg0KPiA+ICAg
ICAgICAgaWYgKHNyYyAhPSBhY29tcF9jdHgtPmJ1ZmZlcikNCj4gPiAgICAgICAgICAgICAgICAg
enBvb2xfdW5tYXBfaGFuZGxlKHpwb29sLCBlbnRyeS0+aGFuZGxlKTsNCj4gPiArDQo+ID4gKyAg
ICAgICAvKg0KPiA+ICsgICAgICAgICogSXQgaXMgc2FmZXIgdG8gdW5sb2NrIHRoZSBtdXRleCBh
ZnRlciB0aGUgY2hlY2sgZm9yDQo+ID4gKyAgICAgICAgKiAic3JjICE9IGFjb21wX2N0eC0+YnVm
ZmVyIiBzbyB0aGF0IHRoZSB2YWx1ZSBvZiAic3JjIg0KPiA+ICsgICAgICAgICogZG9lcyBub3Qg
Y2hhbmdlLg0KPiA+ICsgICAgICAgICovDQo+IA0KPiBUaGlzIGNvbW1lbnQgaXMgdW5uZWNlc3Nh
cnksIHdlIHNob3VsZCBvbmx5IHJlbGVhc2UgdGhlIGxvY2sgYWZ0ZXIgd2UNCj4gYXJlIGRvbmUg
YWNjZXNzaW5nIHByb3RlY3RlZCBmaWVsZHMuDQo+IA0KPiA+ICsgICAgICAgbXV0ZXhfdW5sb2Nr
KCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPiAgfQ0KPiA+DQo+ID4gIC8qKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioNCj4gPiBAQCAtMTQ4Nyw2ICsxNDkzLDcgQEAgYm9vbCB6c3dhcF9z
dG9yZShzdHJ1Y3QgZm9saW8gKmZvbGlvKQ0KPiA+ICB7DQo+ID4gICAgICAgICBsb25nIG5yX3Bh
Z2VzID0gZm9saW9fbnJfcGFnZXMoZm9saW8pOw0KPiA+ICAgICAgICAgc3dwX2VudHJ5X3Qgc3dw
ID0gZm9saW8tPnN3YXA7DQo+ID4gKyAgICAgICBzdHJ1Y3QgY3J5cHRvX2Fjb21wX2N0eCAqYWNv
bXBfY3R4Ow0KPiA+ICAgICAgICAgc3RydWN0IG9ial9jZ3JvdXAgKm9iamNnID0gTlVMTDsNCj4g
PiAgICAgICAgIHN0cnVjdCBtZW1fY2dyb3VwICptZW1jZyA9IE5VTEw7DQo+ID4gICAgICAgICBz
dHJ1Y3QgenN3YXBfcG9vbCAqcG9vbDsNCj4gPiBAQCAtMTUyNiw2ICsxNTMzLDkgQEAgYm9vbCB6
c3dhcF9zdG9yZShzdHJ1Y3QgZm9saW8gKmZvbGlvKQ0KPiA+ICAgICAgICAgICAgICAgICBtZW1f
Y2dyb3VwX3B1dChtZW1jZyk7DQo+ID4gICAgICAgICB9DQo+ID4NCj4gPiArICAgICAgIGFjb21w
X2N0eCA9IHJhd19jcHVfcHRyKHBvb2wtPmFjb21wX2N0eCk7DQo+ID4gKyAgICAgICBtdXRleF9s
b2NrKCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPiArDQo+ID4gICAgICAgICBmb3IgKGluZGV4ID0g
MDsgaW5kZXggPCBucl9wYWdlczsgKytpbmRleCkgew0KPiA+ICAgICAgICAgICAgICAgICBzdHJ1
Y3QgcGFnZSAqcGFnZSA9IGZvbGlvX3BhZ2UoZm9saW8sIGluZGV4KTsNCj4gPiAgICAgICAgICAg
ICAgICAgc3NpemVfdCBieXRlczsNCj4gPiBAQCAtMTU0Nyw2ICsxNTU3LDcgQEAgYm9vbCB6c3dh
cF9zdG9yZShzdHJ1Y3QgZm9saW8gKmZvbGlvKQ0KPiA+ICAgICAgICAgcmV0ID0gdHJ1ZTsNCj4g
Pg0KPiA+ICBwdXRfcG9vbDoNCj4gPiArICAgICAgIG11dGV4X3VubG9jaygmYWNvbXBfY3R4LT5t
dXRleCk7DQo+ID4gICAgICAgICB6c3dhcF9wb29sX3B1dChwb29sKTsNCj4gPiAgcHV0X29iamNn
Og0KPiA+ICAgICAgICAgb2JqX2Nncm91cF9wdXQob2JqY2cpOw0KPiA+IC0tDQo+ID4gMi4yNy4w
DQo+ID4NCg==
