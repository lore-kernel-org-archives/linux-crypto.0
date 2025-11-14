Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3E321CA13;
	Fri, 14 Nov 2025 06:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763102616; cv=fail; b=p2elUPoAVa9vAaBugBAOG5icdEkce5fV0s2F7ye69r8Z0WpmLva0O5NISQSJzeUO9iKeB9m64YXIQQtriOnNWttHOMzgKmmV030w3sY18M2j5tInlvsofTG9ra0NVfHWR0ooUw2sh3GcmUNQ4QDLdcROvN1P9yFiU+HS/OeYGmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763102616; c=relaxed/simple;
	bh=yQxnN+ugW2BSRx17j2ah6TIuY9/tWocy1/NfYJX9bp4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MFa16M9BRySeoVvYr+L0JibAc9TzE0itieRNf6L7KfoFrieLQeSjFA64epu6szgcIY8cqnZCblKgd3LBUXQt5hjJw3bGCgQ+Uq8010ZuQG9ZZbmvd1kh6qzS+ouRDuamebJNt4tMWvpGr/9fJsVq0yrlPxMfCOoH2zoGZxyqvGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnBSI1+b; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnBSI1+b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763102614; x=1794638614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yQxnN+ugW2BSRx17j2ah6TIuY9/tWocy1/NfYJX9bp4=;
  b=dnBSI1+bqxoSHGwaD8Ukk5G0ZaXTeHuWLHmY3iZrMr95JSrjEarcvtcr
   ht9RUokH1N2vQrRHypQLndh5S3KcY8pyvdj/72pDdt7Yc2h9FjS6Lh6K7
   SocBdhZX22KemNV5gWivDrmSpkIVtyRKWXoNbewWL0XagufhNOFSm5kst
   x3rjRaA2FwktJpZSNriGGy9+FIJsuUCmziCKYcdk+j9w2fsDlkitCuBPt
   Nxl9jHY3J/9S3MpLjcHFc0API//dCE/4Xtx/SoH8Drhhgd14tpjxpSuXQ
   ROACuOfdsx3DMTFFW00BReTF+2YiXkEE1Wll3PQg0A7BZppkuEQkjiVYS
   g==;
X-CSE-ConnectionGUID: YXOxkUQgQM2WWpT2ANPRYA==
X-CSE-MsgGUID: 3H6FNoAgR7CRDdoveFvw4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65078956"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="65078956"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:43:32 -0800
X-CSE-ConnectionGUID: MbvVs1PtTd2dQgsM1sn+uQ==
X-CSE-MsgGUID: tMnEwFeyQM63/yB5Kniplg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="188993238"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:43:32 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 22:43:31 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 22:43:31 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 22:43:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fhzBsgHoBuKYZ+a+LQJ1bq7ysU3jwfft77Z41gG1rTwZEm/4uRZj0uuXF7k2Uhx3DybTjOJUfxAmC1NdzfJMdOM5qTYo1cLCncs/z5Ft0NRg8Dvun6/0PGUi8kAnViKKoSTXeCINNLyT/w4X7KgCPbf460IR1eakWRkjVrhO85boOiu6ypEcP/6p8ET6g8lvc/gio4ft/NYFSTSF51NGIFc1NuRUn+8fSFgB9WiV0ehB1gCKzH5Kv1L5EF7C7WWN9MPohvShGwVdKEt4D+dFm2h7/70Ltvkb5Ns0QUM8cmOqtVqJUSU6tNWq8kchVB/IhxtMzXFTDVgYhC+QOa5T+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiPOYWwM+59/4CJHlLZWNewV2Oexe8i7YzcBmtp3LXg=;
 b=l1uje/J4XBOiL4VTj5QdCdami8+5qqcC1Y6GYHTW85eaqLHVWZ6R6mjyN4tg2K9VcXix8jzAI6ul5DInGNBHJzLqHajP1cdxs73LH0dtNEpzhqRDt7qjrPU2ynn967nbRsAbnnMbQFDAPl/gUCgnwdZ8gSeXf9cVx1bXms9AOBqjPv2fx5CefFfBZhNYTbZEqtTByp4tpuYKJISwTbhJzSQBwXrypfTHQkA/rCnfNzCsp9VDu9ywXZg9Y4B5fACBW5HvJRhdUQrXncAYDdHOpY6xjaQw/p2nV52aDqgH9PtbgXkCPaQUYKWQCdsPgwFPpfmlT+eglqhj/NNacBDRyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by IA0PR11MB7379.namprd11.prod.outlook.com (2603:10b6:208:431::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Fri, 14 Nov
 2025 06:43:22 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb%4]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 06:43:21 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
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
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqA
Date: Fri, 14 Nov 2025 06:43:21 +0000
Message-ID: <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
In-Reply-To: <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|IA0PR11MB7379:EE_
x-ms-office365-filtering-correlation-id: 63fc8874-ff5f-4067-9fc7-08de23491a42
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?1Wso/Ox+7B5azExQKD07xrUh4J8iL5TMWXN3sGpEmbvNkS0733ru3nnlwhjK?=
 =?us-ascii?Q?bMEI2xFhfdZegnovpQI8YYYgM9M+nBWnTfzxeSkZ+4tjH9VBBBRckSSooOeF?=
 =?us-ascii?Q?cTvcDnhlMQCJEqRsP1fSSghLiY+FY7qj+1kpCmNo01VON3ocA5DyBDJ9sa7A?=
 =?us-ascii?Q?4CWd2a/Zz1xRlSivmDvCLyKfaZY/pb8lQIO/qcDTylQfDA0H4gFUE57xHYDS?=
 =?us-ascii?Q?v0m+vzNG68l6wNobU9vKNhheinM66nzahWPCKV/+kgGk2I9uSZ2jNaJNygc/?=
 =?us-ascii?Q?yFNjItYO9LKZY1eS9NYl0SLVxPuD/GR/o1b86PB5PLhVomGvodAnpqJQUDOW?=
 =?us-ascii?Q?6X/kXbjs1lPdq/mizeTfhdiDdRmpbDDPeej8mzDgA635nEB2sq8iviK2NHaL?=
 =?us-ascii?Q?4hdFapM6Z2LDzobOG9KRfzGUgYP58LZCiTXDMDyI3fegJlfs27yMzQDe6NR0?=
 =?us-ascii?Q?sUZ5c/MHDWU94o+EIfhefpl3yvR9oZeQi306HkOE37ZD5aspI52zgtHofdMD?=
 =?us-ascii?Q?dIiKT1X6cqw56ScXlw7Nbq/i1kb67EIDKoO8D6Hj0IQtMifBnuvrSYGf+arE?=
 =?us-ascii?Q?iraNAgJBk5+tHBkI1dVkeA1vknMJnTdZ4YMI4YPypvgRpmVMt56ns49z7Z3Z?=
 =?us-ascii?Q?y4DJJ+hv8bn+p2LoinRs5fTrsAmpb0DZGDYWZN5f0jTsmo0Sb3ETMsEkshxr?=
 =?us-ascii?Q?mdzgAd0omQpZ5mdHoTInIMluA0ZbsUz0V+5AShZ0d84fy9J5QuvOw/wS1I/4?=
 =?us-ascii?Q?btOdgV4u1WwDtAcVVyyLfJ1douoZj8E5zeq5RcECRlXI7wH2uxD0nkK1Pl19?=
 =?us-ascii?Q?4EZKRsYRQXAHoYuRClExZUEPJc4sm803RVOZhImMRokV0IAcN3XpYyuUgTzS?=
 =?us-ascii?Q?TcDhYgnMhY1+tN6KCGF32nfSfBAeU8xRpbgFFazcG8z144zE5nDBWRk+X0F2?=
 =?us-ascii?Q?IJ6+rtraKrkc5TA+ouyKhgjbw+JZofL4jMZl7d03RDCXVtCdHe2waL0Be3M6?=
 =?us-ascii?Q?/ga5ArfIB3sQwKomyIGC+P9DzRMfxpEiPhfkIi9CdK2zVI0HzGIWFEhPuhaf?=
 =?us-ascii?Q?1YVKhWrCHG5j3EUG2QbgsIEqY5nW6ILeEDZSoT4Pg5zvxdcnmlYb6cCCL7kS?=
 =?us-ascii?Q?PEwqcz3XEt3zOtzgn/YEacnnNAzLYObqXR/sATyE44C0ZCZFyXREXQoY504B?=
 =?us-ascii?Q?5ZPwaB47jrpC3vh7berotdj/mqephbylus2MymE77us8Jkk7oLDTxL0Vju0o?=
 =?us-ascii?Q?g/lq/S0Zbc0oUBWM9auEDvPL3ukcscK1CRS06FPjFXnAWpK1U7a4PUq9yWYt?=
 =?us-ascii?Q?AX+sGhE0e5AKnLh3T13dXnW0igSChs3hi1qj48Hg8rIW4Vy/NnY6Gs19KvvF?=
 =?us-ascii?Q?o7vlAMy1fWxTLRQYAJm1VTmO2jxm0Ya0HU+IpwDJ5n2sHJSe41Xs0xXP3NV0?=
 =?us-ascii?Q?QrD0Fto/5nN9YuA/Kgq4RfiCYhtKa54l+EVwx7HMqD/Ea+xdRDHNVk7h8H8P?=
 =?us-ascii?Q?8GMTb2ZZDWe2k62OEOxUlYIHLbN0D3bXGcmS?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8nm2JLcADdK2APqsFXGi1L5UbaaXW0yDz9a12+6+ijmV7bur9vTeFm823aCz?=
 =?us-ascii?Q?xrYcU5vNUUCzUmxGkve3q7pYWw9U09IpcNosXK0r3C5ngXGt2N3V4VkcdQ3O?=
 =?us-ascii?Q?J/DWA3/Jk9F397RwWA2Ye+IXqd2dTxcXnsJmd9nl0UWnlJa/ti5UGLeJwz+6?=
 =?us-ascii?Q?Jo2il/etKWhCxFRTapVC/5ewTgeOj5+H34dUflak67JL5vuKUozKeMuv2lMO?=
 =?us-ascii?Q?NjP90x4gzAzj3J/Jfpy1230uYf2Wn/3aTVEFic7w9UrCeEMkb1GKTnzQ0Vby?=
 =?us-ascii?Q?pz1ja4D4iJDlpXpDImYschle9Y9KWrvy0gx4O3ZQLrVvZk+eKFQvR8IZ+8dY?=
 =?us-ascii?Q?tC9WomsjZhnWlm6uO5oiBGvofdT/CSzclLfZeTjnsqirfOwvtJVUsCdKI5op?=
 =?us-ascii?Q?e+/BBYinakd2uXlEZcXnszF7Q5vYVT5orjTqVwMq8yfLK9Ucgs9XOd07OYX0?=
 =?us-ascii?Q?3D9xqmJUvuw5V+Yr2R3Fjvpjg3xZHWYfBfGk3X3IfO9SlUcUhXC5RA4if0lW?=
 =?us-ascii?Q?e7QqpqXfJwn1S332ONh8NZ2ECq2QC7AaPbS9zPspLFDbtxfMTjFLeBQkLu4B?=
 =?us-ascii?Q?JAL6B5+/GTRHVBNLj8iPpohHa5K923odgJ17eGKxIw10QM5h6gHP8Ez04Q2Z?=
 =?us-ascii?Q?e6IuHxRR3H7EpGt2okn+MpcST/kmJhDKmk3iJKfSEw16/c5jmDCahtWC5Myb?=
 =?us-ascii?Q?PsW20+/oBTc2/tnZtRre3XioKAywzYLf84xpZKG99vp/IOfTtF1eqRSKr82k?=
 =?us-ascii?Q?bSgr+DiFdiBPo4NJGMpWss6Xw3ZXztmO0yOj6AlCA3i+mR9XWcIzswr1fzmN?=
 =?us-ascii?Q?Ud31UNvQ3CTfkIit7G+uA16MromVqTxZyPGKd4R8/p9h3HCt2JK91CCX+SHl?=
 =?us-ascii?Q?lUvWRUEtOQHyWxzJCTHepyrFhupSkrb83zM2oJrE3PyqdB4gQEiDyDJzX07T?=
 =?us-ascii?Q?68fF4Ryoomw/ome7CDRd9M5qu6/TMhnfft2FnTR359XaOlys6H6X/mv1Kpi5?=
 =?us-ascii?Q?VgX3LzHeEkm6Zfnqs1csRKV4VZrO089jOJFEgS4dsnP/Mn/pUr67uElACgom?=
 =?us-ascii?Q?vZFUvOLX+72/viLxG5keDEPBfZXnQ864tEv3PjIpXclDoCEZQGVIbl9yE/AZ?=
 =?us-ascii?Q?32y30dxhIuJr+iaiofY0l1GgHuF6+EdG4C/t6B24X1m60TY2w3VlWjtz0Bb8?=
 =?us-ascii?Q?yI5BFzeont/hEAmFjBsl2ogpZuTNtStZE0//U7sd8amAiUH0LrmmijhF4UWf?=
 =?us-ascii?Q?B6rDcWvfiwcQnNpkC5VCLLReCIkHRsUefbEXwSFPLESw4hWkesOFhWvbaBIB?=
 =?us-ascii?Q?ew6XkA5yxoDSUFy1TVMrAZeY4xORRplALMOGIVPIjqhUksjAlYDJsqUNT/Re?=
 =?us-ascii?Q?hYNqBxgUa50pCKz0M6RcxHbHr+SIqme0ATocLVsM4JRlhfse4KnGY51df/ZI?=
 =?us-ascii?Q?uQzOza3lGAP3GCINx5fSi0PeoiLHXdMCu7YbWc0AL89wQ/HFo3Z5RoJ7Eysb?=
 =?us-ascii?Q?yTlWr2vxzRfQ5xU8Fw+sCzv5H9LT0hET1iE/Jx/dA9bWCQHywk6+7UgENI3F?=
 =?us-ascii?Q?o4Nydg0P7tENqR1GEIo5LEl/Ie8jL3a9wcM3NKjgZ3WLiH1kIaCHlH7Ych+0?=
 =?us-ascii?Q?Tw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 63fc8874-ff5f-4067-9fc7-08de23491a42
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 06:43:21.2945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CxT+woFb5YiGUMUiDzqICIgbN4sZEtdYS0wkdoKjql/H67zxzLlH3S/vyv56JwiGsB8d93jmQQaToYSx2UNz9jjGPBMMAlnpoONLhV3ZRoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7379
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 9:52 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Thu, Nov 13, 2025 at 11:55:10PM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Thursday, November 13, 2025 1:35 PM
> > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress()
> with
> > > compress batching of large folios.
> > >
> [..]
> > > > +		/*
> > > > +		 * If a page cannot be compressed into a size smaller than
> > > > +		 * PAGE_SIZE, save the content as is without a compression,
> > > to
> > > > +		 * keep the LRU order of writebacks.  If writeback is disabled,
> > > > +		 * reject the page since it only adds metadata overhead.
> > > > +		 * swap_writeout() will put the page back to the active LRU
> > > list
> > > > +		 * in the case.
> > > > +		 *
> > > > +		 * It is assumed that any compressor that sets the output
> > > length
> > > > +		 * to 0 or a value >=3D PAGE_SIZE will also return a negative
> > > > +		 * error status in @err; i.e, will not return a successful
> > > > +		 * compression status in @err in this case.
> > > > +		 */
> > >
> > > Ugh, checking the compression error and checking the compression leng=
th
> > > are now in separate places so we need to check if writeback is disabl=
ed
> > > in separate places and store the page as-is. It's ugly, and I think t=
he
> > > current code is not correct.
> >
> > The code is 100% correct. You need to spend more time understanding
> > the code. I have stated my assumption above in the comments to
> > help in understanding the "why".
> >
> > From a maintainer, I would expect more responsible statements than
> > this. A flippant remark made without understanding the code (and,
> > disparaging the comments intended to help you do this), can impact
> > someone's career. I am held accountable in my job based on your
> > comments.
> >
> > That said, I have worked tirelessly and innovated to make the code
> > compliant with Herbert's suggestions (which btw have enabled an
> > elegant batching implementation and code commonality for IAA and
> > software compressors), validated it thoroughly for IAA and ZSTD to
> > ensure that both demonstrate performance improvements, which
> > are crucial for memory savings. I am proud of this work.
> >
> >
> > >
> > > > +		if (err && !wb_enabled)
> > > > +			goto compress_error;
> > > > +
> > > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > > +			j =3D k + i;
> > >
> > > Please use meaningful iterator names rather than i, j, and k and the =
huge
> > > comment explaining what they are.
> >
> > I happen to have a different view: having longer iterator names firstly=
 makes
> > code seem "verbose" and detracts from readability, not to mention
> exceeding the
> > 80-character line limit. The comments are essential for code maintainab=
ility
> > and avoid out-of-bounds errors when the next zswap developer wants to
> > optimize the code.
> >
> > One drawback of i/j/k iterators is mis-typing errors which cannot be ca=
ught
> > at compile time. Let me think some more about how to strike a good
> balance.
> >
> > >
> > > > +			dst =3D acomp_ctx->buffers[k];
> > > > +			dlen =3D sg->length | *errp;
> > >
> > > Why are we doing this?
> > >
> > > > +
> > > > +			if (dlen < 0) {
> > >
> > > We should do the incompressible page handling also if dlen is PAGE_SI=
ZE,
> > > or if the compression failed (I guess that's the intention of bit OR'=
ing
> > > with *errp?)
> >
> > Yes, indeed: that's the intention of bit OR'ing with *errp.
>=20
> ..and you never really answered my question. In the exising code we
> store the page as incompressible if writeback is enabled AND
> crypto_wait_req() fails or dlen is zero or PAGE_SIZE. We check above
> if crypto_wait_req() fails and writeback is disabled, but what about the
> rest?

Let me explain this some more. The new code only relies on the assumption
that if dlen is zero or >=3D PAGE_SIZE, the compressor will not return a 0
("successful status"). In other words, the compressor will return an error =
status
in this case, which is expected to be a negative error code.

Under these (hopefully valid) assumptions, the code handles the simple case
of an error compression return status and writeback is disabled, by the
"goto compress_error".

The rest is handled by these:

1) First, I need to adapt the use of sg_outputs->sgl->length to represent t=
he
compress length for software compressors, so I do this after crypto_wait_re=
q()
returns:

                acomp_ctx->sg_outputs->sgl->length =3D acomp_ctx->req->dlen=
;

I did not want to propose any changes to crypto software compressors protoc=
ols.

2) After the check for the "if (err && !wb_enabled)" case, the new code has=
 this:

                for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
                        j =3D k + i;
                        dst =3D acomp_ctx->buffers[k];
                        dlen =3D sg->length | *errp;

                        if (dlen < 0) {
                                dlen =3D PAGE_SIZE;
                                dst =3D kmap_local_page(folio_page(folio, s=
tart + j));
                        }

For batching compressors, namely, iaa_crypto, the individual output SG
lists sg->length follows the requirements from Herbert: each sg->length
is the compressed length or the error status (a negative error code).

Then all I need to know whether to store the page as incompressible
is to either directly test if sg->length is negative (for batching compress=
ors),
or sg->length bit-OR'ed with the crypto_wait_req() return status ("err")
is negative. This is accomplished by the "dlen =3D sg->length | *errp;".

I believe this maintains backward compatibility with the existing code.
Please let me know if you agree.

>=20
> We don't check again if writeback is enabled before storing the page is
> incompressible, and we do not check if dlen is zero or PAGE_SIZE. Are
> these cases no longer possible?

Hope the above explanation clarifies things some more? These case
are possible, and as long as they return an error status, they should be
correctly handled by the new code.

>=20
> Also, why use errp, why not explicitly use the appropriate error code?
> It's also unclear to me why the error code is always zero with HW
> compression?

This is because of the sg->length requirements (compressed length/error)
for the batching interface suggested by Herbert. Hence, I upfront define
err_sg to 0, and, set errp to &err_sg for batching compressors. For softwar=
e
compressors, errp is set to &err, namely, the above check will always apply
the software compressor's error status to the compressed length via
the bit-OR to determine if the page needs to be stored uncompressed.


>=20
> >
> > >
> > > > +				dlen =3D PAGE_SIZE;
> > > > +				dst =3D kmap_local_page(folio_page(folio, start
> > > + j));
> > > > +			}
> > > > +
> > > > +			handle =3D zs_malloc(pool->zs_pool, dlen, gfp, nid);
> > > >
> > > > -	zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > > > -	entry->handle =3D handle;
> > > > -	entry->length =3D dlen;
> > > > +			if (IS_ERR_VALUE(handle)) {
> > > > +				if (PTR_ERR((void *)handle) =3D=3D -ENOSPC)
> > > > +					zswap_reject_compress_poor++;
> > > > +				else
> > > > +					zswap_reject_alloc_fail++;
> > > >
> > > > -unlock:
> > > > -	if (mapped)
> > > > -		kunmap_local(dst);
> > > > -	if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
> > > > -		zswap_reject_compress_poor++;
> > > > -	else if (comp_ret)
> > > > -		zswap_reject_compress_fail++;
> > > > -	else if (alloc_ret)
> > > > -		zswap_reject_alloc_fail++;
> > > > +				goto err_unlock;
> > > > +			}
> > > > +
> > > > +			zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > > > +			entries[j]->handle =3D handle;
> > > > +			entries[j]->length =3D dlen;
> > > > +			if (dst !=3D acomp_ctx->buffers[k])
> > > > +				kunmap_local(dst);
> > > > +		}
> > > > +	} /* finished compress and store nr_pages. */
> > > > +
> > > > +	mutex_unlock(&acomp_ctx->mutex);
> > > > +	return true;
> > > > +
> > > > +compress_error:
> > > > +	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > > +		if ((int)sg->length < 0) {
> > > > +			if ((int)sg->length =3D=3D -ENOSPC)
> > > > +				zswap_reject_compress_poor++;
> > > > +			else
> > > > +				zswap_reject_compress_fail++;
> > > > +		}
> > > > +	}
> > > >
> > > > +err_unlock:
> > > >  	mutex_unlock(&acomp_ctx->mutex);
> > > > -	return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> > > > +	return false;
> > > >  }
> > > >
> > > >  static bool zswap_decompress(struct zswap_entry *entry, struct fol=
io
> > > *folio)
> > > > @@ -1488,12 +1604,9 @@ static bool zswap_store_pages(struct folio
> > > *folio,
> > > >  		INIT_LIST_HEAD(&entries[i]->lru);
> > > >  	}
> > > >
> > > > -	for (i =3D 0; i < nr_pages; ++i) {
> > > > -		struct page *page =3D folio_page(folio, start + i);
> > > > -
> > > > -		if (!zswap_compress(page, entries[i], pool, wb_enabled))
> > > > -			goto store_pages_failed;
> > > > -	}
> > > > +	if (unlikely(!zswap_compress(folio, start, nr_pages, entries, poo=
l,
> > > > +				     nid, wb_enabled)))
> > > > +		goto store_pages_failed;
> > > >
> > > >  	for (i =3D 0; i < nr_pages; ++i) {
> > > >  		struct zswap_entry *old, *entry =3D entries[i];
> > > > --
> > > > 2.27.0
> > > >
