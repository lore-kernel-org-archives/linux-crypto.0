Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6E21767D;
	Wed, 30 Apr 2025 21:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047230; cv=fail; b=NNXB0jyM3NC/ZTOSdG3z2R0skxFfw+pxHjLHDgccJfEiEhBLaSnkYC7JKHjhBL2apcQhQluzRO9ec6gzx+taJY7lniCZ/+/9hlw5pgSc6es+VeBrMDXI9/eFLFmbpxxhcpJAEt4xz7dC33mHizZU2nxR1ZQx0HWi418yNxXDp4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047230; c=relaxed/simple;
	bh=hV2Xk6FnPJDcGrkM3udwFoRyNZtNP4klemNDWnbZ9zI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QJ3IUoIyJem5pfzEcxjrRFGWmXe3B+CmhTXovpY2Ed9GyVx6N0fEL8IZYE32ursvLaYnsCkqEz8rztiehcToX0T/2e51NKI2BuPldLwlvCp3sGDwhLbcDKaE7p9+vzIh+A+BQOQiGkynbF5+rSYnpWC/FLbH2Iog9Au/OAvbzd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PpySbY7m; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PpySbY7m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746047229; x=1777583229;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hV2Xk6FnPJDcGrkM3udwFoRyNZtNP4klemNDWnbZ9zI=;
  b=PpySbY7m6DuTWrnh0OESk8YTpvuNDpDoLjDc/eQF4vOicNvj+9O/qsXr
   eNnmFlNCwFhPMMw6eq7Ymz9mRV399+443mjo+MC6grHRMQd6xwL7c7uom
   LdJFlkn5SmDSwKQM28Yoslp9w3XI+KX1wZdiuZ49KUc8CSitW6aWPFriO
   pW5kg740MDkeJNFXDq3Hn/RhUN2ErbZDLZbWw+AkxXCl+E9cqmCCAiZ+5
   TMxU2JilD49xKQFFs+Lwj0m8SRkZTZ4SoIb+XmgoZdIm0+UjVEKXpLEGN
   Aii2U5W44DgzZf2yitAGHiXD+O7TvfCX1dMfFkFE0OY8aKb+oc/Q/E7mw
   g==;
X-CSE-ConnectionGUID: 070a+ETXTm6kPLaTZwrouA==
X-CSE-MsgGUID: V7DES/d4QjGCjUqeS9otmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51544435"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51544435"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 14:07:08 -0700
X-CSE-ConnectionGUID: c0EPixVrQ2+pPNKB6LvdOA==
X-CSE-MsgGUID: oeYVKEJYQreoJwKSST9MZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="134124043"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 14:07:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 14:07:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 14:07:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 14:07:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FyryZKhmhKUczvVMEXksPX/Glg5UI0Jt5A5TMhOR6Aq1fvK/FcAEvpiPCfIK3uMBtD7dxilq8TJA+b9+2ow3zNOe3r720MGWlK7zclbQr9fBVdPC4QPLYb9n00BV8kbpgNTaUlTqz8GEKxe4VByTTRCF3B0AxYXnyC90mQ/FRwXHFAAjUsAv7RQuh5gkceLya1+Ba98E+LLYZF/imJuAnj5/Hvot8d9gBfnF+SpzffxVw6nry4Jz+cyFBDkkzoojLO3VMbrhsaxGWBJaDpzd3hbsq1qz4sv6uqCAC+DhaErhUXRy4VtKvPlvoACybWroVrqzs97PjZJiX5ueb/XzxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hV2Xk6FnPJDcGrkM3udwFoRyNZtNP4klemNDWnbZ9zI=;
 b=sJ9QXZholvZh2BlUcAHQ+nRlpm/9TtksyKsOWeff+BmIQavoTGYIFqDuzHrCeBZ5r6ipJv9NoCnZMbRq5nlpKRxFrqm8uZRkaFEpkaUXd3wU10R53LOiEvcGSbJdRLILzqE++T4AxbrJx6VTpRuq0YHftnilhUFLtNpA8GPxdLB9TkrtsocYO7qXO9OQrxMDHvo/sVYAnYkcadlRsAAvRLFZXQ6c/FIsIGjZUpEXN/qLmW/fNSj7p39Grb95fCPs880FIOugPJdJHfGGkpYVZDIOcOi53mLIFPT3xPtJxMgfP9+4H2rWNe6B0qrr850KGwbWyJHnfs8W1d4E9w30tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by CO1PR11MB4819.namprd11.prod.outlook.com (2603:10b6:303:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Wed, 30 Apr
 2025 21:07:03 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%5]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 21:07:03 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: Nhat Pham <nphamcs@gmail.com>, lkp <lkp@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
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
Thread-Index: AQHbjBjvM/RpC9YLRU+yz1iNoK3rUrNhQKsAgAB5VICAACxo8IAEvKkAgFZsGVA=
Date: Wed, 30 Apr 2025 21:07:03 +0000
Message-ID: <PH7PR11MB812141865845E36F05DD388FC9832@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250303084724.6490-15-kanchana.p.sridhar@intel.com>
 <202503031847.j1iReOtf-lkp@intel.com>
 <CAKEwX=MgV22UBNi-2dNBDgNM2DRfrngk_4gO7z9t-O0KrpdPUw@mail.gmail.com>
 <SA3PR11MB8120445C8DBDBB9945231B66C9C92@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z8oRsGHmt2E4diKK@google.com>
In-Reply-To: <Z8oRsGHmt2E4diKK@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|CO1PR11MB4819:EE_
x-ms-office365-filtering-correlation-id: 6b0d46bb-571b-4a0b-ce74-08dd882af4fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TGNVSW96RGpJSTZFMG5zTXhlbHdJREpveTBzOURJbDNRZWgwK2ZJUEhEZGFl?=
 =?utf-8?B?RXN4K0ozbTM2cmxENG02SXRTaW1rYm1XWjlDU1NkM0hBL09yaFl4ZUc0STNT?=
 =?utf-8?B?S2NmWGgxOU5NN2pWNHdML2lUZXRvZEVDcGpva2xGS1JDMVNmbUhLMmt2L1Nq?=
 =?utf-8?B?SDNpMVRDZ3U5S0Qxc25kcnRmY3pOS2lxOW9Ta3pLdGpSYVVYQ1J5cFVtcTYw?=
 =?utf-8?B?S0NFS1BTTnFWWkR0T3FhTUtaaDdPY01yL2JnRFVxSE5lSmkyMEZwdmJJMUcy?=
 =?utf-8?B?UjliQXRVTGsxUmJKNTlHeE5SUlhkRUZtUXpxaHlBQnZzU0VpMzRjajgvR2s2?=
 =?utf-8?B?bVFoMGRKc2VmbjRYR1JDVVRsUThTVFJmSGdQaXg5SjlLZzY0cGlsVWlrcGQw?=
 =?utf-8?B?ZEJFUGRvQm9WUWpEejNjbUN6cEVVT3pvQk16ZWw5a0VYNGo0MmovMEF3ZWRq?=
 =?utf-8?B?Z0xoK1EzMzNSVjJ4aEJObFhmUnRnRWlLaXZ3R0hDbURlT3I0NGIwaFJrRHI1?=
 =?utf-8?B?am01amNLaGZzNHlKTWhHcDRISUlCbUtyOFhjbTRiZTVRWU0ySUM3NlMyR0NU?=
 =?utf-8?B?c1ZpcEhGSHRWMEQxOWd4clRQSDZ1Mmw2b3FOdWk2RWEwL3VnWUluRHJiVUx5?=
 =?utf-8?B?MnhTVkV3dk8yYlNVZ2szQ0I1UU5HWkxxN2c0bzgvMnFXemtkejRLcUoraG9X?=
 =?utf-8?B?aHJjdVJwZUgxaXY4bkFBUG5OS0JYNUd0c1lzWU1SekhlRlVXUzFkQVB4V2dx?=
 =?utf-8?B?YVg0NGlSV3liOGR1Yjlpc3Q5bCtpamlURExFSXlXM2ZwZmRIN28rR1Z0MllR?=
 =?utf-8?B?M2VPSXFIR1loMXZsRGJCMko0Vzh5dXo0Q2U0WjlhVWdZN0lvR1pSZUFHc3Rm?=
 =?utf-8?B?UGN0cWNqeXJubFBjWm1FR3VqV3p2Tlh6eUE0eEdsMmdzM3Q1SHo5RjlveDJC?=
 =?utf-8?B?UGpuMi9ZRE0yWEFzT3NmUEo2cDl5L1A0dUN0bWRxN2NCaDFyVVJsZ3FvYnhF?=
 =?utf-8?B?VlU3dzlqMEVzMGQxdTdoQk8yVEEwa3JSV3FNM2oxVFJucUJRY1FjcEMxdVZw?=
 =?utf-8?B?YkNDa3dJN2x5ck56MFVHUTE2N0xYSjl0aTFFeEx3RUlRSmNTZ1Z0akd0eXlU?=
 =?utf-8?B?cHEzTGFUOXJZZnl3eUJNaUZuR3B0bEROaHpvdk1PQ3dxbVpRL1VGN2orNVFL?=
 =?utf-8?B?akxnRmpLYmtLQ1gzUGIra3Y2Z2VuTUxnOC84ZG4xZDJud05ScHNyUWwwZFh6?=
 =?utf-8?B?MkJkNHVWR09xc1J2QVAvTDN2eWx3bEV0ZzdnRktQQ21rREZtQ245YjFxdjNV?=
 =?utf-8?B?ZXpnZGIxSTFvTG5aSUxrY3pyVHMybGJDc3Bkc1F0dGpEY0Nvb3l1cTNvdTZm?=
 =?utf-8?B?aUs1UzRkTDJpUDkzYlg2czJpdkwzNGxzUTVmMng1NjF1L0lyUmFEbGk2dGgy?=
 =?utf-8?B?SC9lUU5DRXplRTV6L0JpSTVyVXJza2NOMzI4QldIdVgxQ0IxSkdBNXExNHpC?=
 =?utf-8?B?bkowLzNJdnowNWorNm5DU2t4ZWl5aFcvaEVFZThaYUQySGRSK0o3QTA2Z1h3?=
 =?utf-8?B?UWRPRGdudkVHS0tGWTlSaVd4SjdZRDRNbVFwVVViRFFJaFp1OVdMaDlmemF1?=
 =?utf-8?B?VGpsWXlOdTdtTTdWK3Y1VTQ2clVsTkhSY3NNMnJBM1NJbXF4eGtuUm9CT0JR?=
 =?utf-8?B?T2tERXQ4eWxFeFVYWUhIQllycEYvZzMrdFFYSEV2U0swRnd0Z2hoaE9xek1i?=
 =?utf-8?B?aXVSdHgrZ3Z1SHRaeDFqaFUwajRLdWRQRmV5WHR2S2JDVjM5YWprRU52UnRG?=
 =?utf-8?B?OFZEbFprckVKbDJGeXpOK0NWQ3d5dU9oK0o5TkZpM2pKeGp5S2w0YWZRSFJy?=
 =?utf-8?B?bVhIWllMQVJkOW5mQy9naG93UnRJT0xLRjVtdlE4Q0h4QjdqbVRNRW4rNnJi?=
 =?utf-8?B?Y0lnaXBjSUVpd3pxTWZGZlRhR1lVT2d0NnlLZ1g1bWhsa2RSK3dKc1Fkcnhr?=
 =?utf-8?B?dk9JUHh0RzdnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGx3UHRhdm1OOEtBQ0JsVGdiVGM5aWcyVE1yQzdrRnVQblMwcXNMTUVIK1BX?=
 =?utf-8?B?aTRBd3RiWW55OG1ZTzVaaVN6cEhoT01PMUlXeUZocDZHdStoUmN4ZEVkRDVQ?=
 =?utf-8?B?ZG5GaWlkeFNQVVgwRnRGbTdlaW5Id0gyT2taazhMYnU0ck1SdWY2c3o3aXZr?=
 =?utf-8?B?YUNQUkRpK081eVVtU3I2aUdXZkFnaUNMMEFTYVNpU05GMUNwZGxUWUs2aVZW?=
 =?utf-8?B?MFF6VW14bCtMeEdMOE8xVHd1WCtONWhnYTJybGRqeEJYenN0STRlT2dvSkNp?=
 =?utf-8?B?TE1MR3JtWVByQnlpVnRQNkZUWWVVVEQvb01NMjdkMUdWTDhYc3JaUVo4bC9m?=
 =?utf-8?B?RFhNc3draDFTc3RCbmIxMFNVQWZJc2tRWWplZTdUM0ZDTTgwY0V2T2Zyem9s?=
 =?utf-8?B?bEdnWndjZmdRREQrU2xLVTIvVUFmSW91S2lwN2p2Q1EweWJNbkxYQS85SUg3?=
 =?utf-8?B?R0pyd2hvdTBRTWk1bll3KytNWlNjL1R5SVZ5NkdhM0JNb3pKaU9qYUhtbTZQ?=
 =?utf-8?B?QVZsd3gvT3ZjVFVhZFdLNEIxL2JoeHNzOVRNTU51d1dUWEYzdmxDMGp6bHRF?=
 =?utf-8?B?MGo5M0YxT3RSbHdCTVpEMXhKRmFuc2ZDUVh6dXlEc2VhY3BjY3NhTVZZN2xl?=
 =?utf-8?B?YjhCYU1uRk5Mc1J1TEhBalhseXBwQmRPdjdGUTZvajNKQUlURjFDd0M5NFpV?=
 =?utf-8?B?NVNXNmt5WWVqN1VjLzR4OWV3UHVpTmZHNEtubU5vbkJjZkxNdy9pSUFRZllr?=
 =?utf-8?B?bExMcDFKcnZRRDlXemVBL2hwV3RlOHYydEp6bzZ3aDRselBqaEJYSXdDNDBM?=
 =?utf-8?B?ZTQ0eE03WHNqdnp1MHM1c0x1WXJiMVA5Y1dyVEhneHBBaHN5aG8vRXhlQVFz?=
 =?utf-8?B?VlMzR0ZPRXpUU3k3T1l3d014eVRqMXNjZjJ2b2tVWlZjZEQydUtDNytoZ2RX?=
 =?utf-8?B?OTZHUVBvdldINGxyNjU2Y2FReEkxQno4YzlnbEpuZ3U3MXB0dS9xaEQ1MTFY?=
 =?utf-8?B?T1A0SW5jNmxjenI2cDdVajhDOWRLMEhqMnl0ZFZHNVBkN2hqQVV1RVNlZ0RQ?=
 =?utf-8?B?YlpkVS9wdnFtTXFqVStYUTMyTG9uZTE2clB2RGpjdlBOVjdQN1YvOG9uOWZh?=
 =?utf-8?B?a0pPRUx1aFZGbVk4aE0vUVRSclNYK3UrNlhJc2tNYmVhZmVjb1FNVmJIdHFR?=
 =?utf-8?B?YVBhWENSVmhKWmQ5eks3a3d4a1N6UlFLS05LUHNUWkdjV1VJQmdsYzFDWVhj?=
 =?utf-8?B?Wk1HYzg0L3NoMmdoNDNXbUhWSUR1UEtLdGhIMURTWVJEUSsxY25oVjV3SGw0?=
 =?utf-8?B?Nnc5S2RnRVo0WnhUWk03ZlZHUWpSelVJMTBMNmxQOFJsWStER0IyMEJCMTBm?=
 =?utf-8?B?QTBHV3VQMm9iK2JZN1B4ZGRTRCthTzg0Q0VTNVVoaTNwWTUyMjdSWi85OHYx?=
 =?utf-8?B?UmRhUktQS0xwSWtsMXhpcXl3Y1Z6ZWkvdDZoYlBCVndwN3Q2cjZiVmtKZEhN?=
 =?utf-8?B?ekhSZlFjNzd2ZFZxSW0rbCtNRGRkNHAzUk03VHRtM1JKZDdkMHVwc1Q2cDBB?=
 =?utf-8?B?K1BZUFMyM2lEb1MzeGY1WVN4YlZjanRDUWI1UGM2eWgxOGFINDFDZGJzdkUv?=
 =?utf-8?B?TUNySDRaNjUrWS84ZXlGb0R0cFl1K0thZ3RKcVRnVXRlTUpPdWhiTUx3Uy82?=
 =?utf-8?B?Tm9EVStxVnBUV2VTV2E0N1ZZSU92R0pXUXhFLzRya1pBYjFVb3VoNmd6YXFh?=
 =?utf-8?B?bnJXd0J6VUlmcVVWSHYrT3JRWUsrOWl3Z2Q4blZvYVVCcFBpVUJCQ0hGcUVt?=
 =?utf-8?B?T0FyZlRPS2xpeDkyN0lkWUVoT212eFl6eGdGd1FMdDlJQ3Nobm5mSTI5RUZ4?=
 =?utf-8?B?NU1ZQlA2OElQNDVTN1AvdHhDbkxwZThHbU1XL3R1RGliRFNZSzZkbDY5c0t5?=
 =?utf-8?B?aEZpdi9tMVZQd0ZxT0dyNU5VQjVLMDhueU9lQmVGdWJkNEhrV1BJL2VOUUho?=
 =?utf-8?B?MWNMNVBlZmRvblp0V0NkZ2F6czhyaHhoZTZzNFYrTkNNSlh3UE1uWlZQUU10?=
 =?utf-8?B?VzMxNkFMT1ZXV1FWQTYyd3kxMS95cEZoUlRUYzBrZjk1MzJtZEYxc01wSmE5?=
 =?utf-8?B?TnZPRHBXUXBvdHlyTmwyK0VFMnhNOWJlM2t3R2E5T2lKS3UxSDJ2WEx0WnBG?=
 =?utf-8?B?VlE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0d46bb-571b-4a0b-ce74-08dd882af4fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 21:07:03.6317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Np7KnP0q8mglDcxIls0Z+rNtTPr7H8mYbFqdry185n4B7wMqEnKdg/zN04BNKclUMq6yd7DwsSAHjDCzDw45cJJjhPqEtyYHosUoIv/oziQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4819
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eS5haG1lZEBsaW51eC5kZXY+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCA2LCAyMDI1IDE6MjEg
UE0NCj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5j
b20+DQo+IENjOiBOaGF0IFBoYW0gPG5waGFtY3NAZ21haWwuY29tPjsgbGtwIDxsa3BAaW50ZWwu
Y29tPjsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9y
ZzsgaGFubmVzQGNtcHhjaGcub3JnOw0KPiBjaGVuZ21pbmcuemhvdUBsaW51eC5kZXY7IHVzYW1h
YXJpZjY0MkBnbWFpbC5jb207DQo+IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyAyMWNuYmFvQGdtYWls
LmNvbTsNCj4geWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0
aW9uLm9yZzsgbGludXgtDQo+IGNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGhlcmJlcnRAZ29uZG9y
LmFwYW5hLm9yZy5hdTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgY2xhYmJlQGJheWxpYnJlLmNv
bTsgYXJkYkBrZXJuZWwub3JnOw0KPiBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xl
LmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+IDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+
OyBsbHZtQGxpc3RzLmxpbnV4LmRldjsgb2Uta2J1aWxkLQ0KPiBhbGxAbGlzdHMubGludXguZGV2
OyBGZWdoYWxpLCBXYWpkaSBLIDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29tPjsgR29wYWwsDQo+
IFZpbm9kaCA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2
OCAxNC8xNF0gbW06IHpzd2FwOiBDb21wcmVzcyBiYXRjaGluZyB3aXRoIHJlcXVlc3QNCj4gY2hh
aW5pbmcgaW4genN3YXBfc3RvcmUoKSBvZiBsYXJnZSBmb2xpb3MuDQo+IA0KPiBPbiBNb24sIE1h
ciAwMywgMjAyNSBhdCAwOTozNDowNFBNICswMDAwLCBTcmlkaGFyLCBLYW5jaGFuYSBQIHdyb3Rl
Og0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogTmhh
dCBQaGFtIDxucGhhbWNzQGdtYWlsLmNvbT4NCj4gPiA+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMywg
MjAyNSAxMDoyMiBBTQ0KPiA+ID4gVG86IGxrcCA8bGtwQGludGVsLmNvbT4NCj4gPiA+IENjOiBT
cmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPjsgbGludXgt
DQo+ID4gPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IGhhbm5l
c0BjbXB4Y2hnLm9yZzsNCj4gPiA+IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpo
b3VAbGludXguZGV2Ow0KPiA+ID4gdXNhbWFhcmlmNjQyQGdtYWlsLmNvbTsgcnlhbi5yb2JlcnRz
QGFybS5jb207IDIxY25iYW9AZ21haWwuY29tOw0KPiA+ID4geWluZy5odWFuZ0BsaW51eC5hbGli
YWJhLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgtDQo+ID4gPiBjcnlwdG9A
dmdlci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+ID4gPiBkYXZl
bUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7DQo+
ID4gPiBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwgS3Jp
c3RlbiBDDQo+ID4gPiA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgbGx2bUBsaXN0cy5s
aW51eC5kZXY7IG9lLWtidWlsZC0NCj4gPiA+IGFsbEBsaXN0cy5saW51eC5kZXY7IEZlZ2hhbGks
IFdhamRpIEsgPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwNCj4gPiA+IFZpbm9k
aCA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjgg
MTQvMTRdIG1tOiB6c3dhcDogQ29tcHJlc3MgYmF0Y2hpbmcgd2l0aA0KPiByZXF1ZXN0DQo+ID4g
PiBjaGFpbmluZyBpbiB6c3dhcF9zdG9yZSgpIG9mIGxhcmdlIGZvbGlvcy4NCj4gPiA+DQo+ID4g
PiBPbiBNb24sIE1hciAzLCAyMDI1IGF0IDM6MDfigK9BTSBrZXJuZWwgdGVzdCByb2JvdCA8bGtw
QGludGVsLmNvbT4NCj4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IEhpIEthbmNoYW5hLA0KPiA+
ID4gPg0KPiA+ID4gPiBrZXJuZWwgdGVzdCByb2JvdCBub3RpY2VkIHRoZSBmb2xsb3dpbmcgYnVp
bGQgZXJyb3JzOg0KPiA+ID4gPg0KPiA+ID4gPiA+IDExNjYgICAgICAgICAgICAgICAgICAgICAg
ICAgIHByZWZldGNodyhlbnRyaWVzW2pdKTsNCj4gPiA+ID4gLS0NCj4gPiA+DQo+ID4gPiBXaHkg
YXJlIHdlIGRvaW5nIHRoaXMgYW55d2F5PyBEb2VzIGl0IGhhdmUgYSBub3RhYmxlIHBlcmZvcm1h
bmNlDQo+ID4gPiBkaWZmZXJlbmNlPyBBdCB0aGUgdmVyeSBsZWFzdCwgbGVhdmUgYSBjb21tZW50
IGV4cGxhaW5pbmcgd2h5IHdlJ3JlDQo+ID4gPiBwcmVmZXRjaGluZyB0aGlzIChhbHRob3VnaCB0
aGUgYnVpbGQgZXJyb3Igc3VnZ2VzdHMgdGhhdCB3ZSBoYXZlIHRvDQo+ID4gPiByZW1vdmUgaXQg
YW55d2F5KS4NCj4gPg0KPiA+IEhpIE5oYXQsDQo+ID4NCj4gPiBZZXMsIGl0IGRvZXMuIFRoZSB1
c2Ugb2YgcHJlZmV0Y2h3IHJlZHVjZXMgc3lzIHRpbWUgYnkgfjEuNSUgYmVjYXVzZQ0KPiA+IGl0
IG1pbmltaXplcyBjYWNoZS1taXNzIGxhdGVuY3kgYnkgbW92aW5nIHRoZSB6c3dhcCBlbnRyeSB0
byB0aGUgY2FjaGUNCj4gPiBiZWZvcmUgaXQgaXMgd3JpdHRlbiB0by4NCj4gPg0KPiA+IFRoaXMg
aXMgZGF0YSB3aXRoIGtlcm5lbCBjb21waWxhdGlvbiB0ZXN0LCB2OCB3aXRob3V0IHByZWZldGNo
dyBhbmQgdjggYXMtaXM6DQo+ID4NCj4gPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBL
ZXJuZWwgY29tcGlsZSAgICAgICB2OCB3aXRob3V0ICAgICAgICAgICAgICAgdjggICAgICB2OCB3
aXRob3V0ICAgICAgICAgICAgICB2OA0KPiA+ICBhbGxtb2Rjb25maWcgICAgICAgICAgcHJlZmV0
Y2h3ICAgICAgICAgICAgICAgICAgICAgICAgcHJlZmV0Y2h3DQo+ID4gIDJNIGZvbGlvcw0KPiA+
ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICB6c3dhcCBjb21wcmVzc29yICAgIGRlZmxh
dGUtaWFhICAgICAgZGVmbGF0ZS1pYWEgICAgICAgICAgICB6c3RkICAgICAgICAgICAgenN0ZA0K
PiA+ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICByZWFsX3NlYyAgICAgICAgICAgICAg
ICAgNzMyLjg5ICAgICAgICAgICA3MzUuNjMgICAgICAgICAgNzY4LjUzICAgICAgICAgIDc1OC4y
MQ0KPiA+ICB1c2VyX3NlYyAgICAgICAgICAgICAgMTUsNzA4LjM3ICAgICAgICAxNSw2OTkuODQg
ICAgICAgMTUsNzAyLjY0ICAgICAgIDE1LDY3OC43Mw0KPiA+ICBzeXNfc2VjICAgICAgICAgICAg
ICAgIDQsNjMyLjU4ICAgICAgICAgNCw1NjMuNzAgICAgICAgIDUsNzM1LjA2ICAgICAgICA1LDYz
NS42OQ0KPiA+ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBNYXhfUmVzX1NldF9TaXpl
X0tCICAgMSw4NzQsNjcyICAgICAgICAxLDg2Nyw1MTYgICAgICAgMSw4NzQsNjg0DQo+IDEsODcy
LDg4OA0KPiA+ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBtZW1jZ19oaWdoICAgICAg
ICAgICAgICAgICAgICAwICAgICAgICAgICAgICAgIDAgICAgICAgICAgICAgICAwICAgICAgICAg
ICAgICAgMA0KPiA+ICBtZW1jZ19zd2FwX2ZhaWwgICAgICAgICAgICAgICAwICAgICAgICAgICAg
ICAgIDAgICAgICAgICAgICAgICAwICAgICAgICAgICAgICAgMA0KPiA+ICB6c3dwb3V0ICAgICAg
ICAgICAgIDExNCw3NDIsOTMwICAgICAgMTEyLDgzNiw3MjUgICAgICA5Miw5MDQsOTYxICAgICAg
ODksNTk2LDA4NQ0KPiA+ICB6c3dwaW4gICAgICAgICAgICAgICA0MSwxODQsODk3ICAgICAgIDM5
LDk4Myw3OTMgICAgICAzMSwwMTgsMTQ5ICAgICAgMjksMTYzLDkzMg0KPiA+ICBwc3dwb3V0ICAg
ICAgICAgICAgICAgICAgICAgNjI1ICAgICAgICAgICAgMSwwNjkgICAgICAgICAgICAgNTU4ICAg
ICAgICAgICAxLDA1OQ0KPiA+ICBwc3dwaW4gICAgICAgICAgICAgICAgICAgICAgNTk5ICAgICAg
ICAgICAgMSwwNTYgICAgICAgICAgICAgNTQwICAgICAgICAgICAxLDA1MQ0KPiA+ICB0aHBfc3dw
b3V0ICAgICAgICAgICAgICAgICAgICAxICAgICAgICAgICAgICAgIDIgICAgICAgICAgICAgICAx
ICAgICAgICAgICAgICAgMg0KPiA+ICB0aHBfc3dwb3V0X2ZhbGxiYWNrICAgICAgMTAsOTY3ICAg
ICAgICAgICAxMCwxOTUgICAgICAgICAgIDYsOTE4ICAgICAgICAgICA2LDE0MQ0KPiA+ICBwZ21h
amZhdWx0ICAgICAgICAgICA0Miw1ODgsMzMxICAgICAgIDQxLDM0OSwwNjkgICAgICAzMSw5MzEs
ODgyICAgICAgMzAsMDA2LDQyMg0KPiA+ICBaU1dQT1VULTIwNDhrQiAgICAgICAgICAgIDcsNjYx
ICAgICAgICAgICAgOCw3MTAgICAgICAgICAgIDYsNzk5ICAgICAgICAgICA3LDQ4MA0KPiA+ICBT
V1BPVVQtMjA0OGtCICAgICAgICAgICAgICAgICAxICAgICAgICAgICAgICAgIDIgICAgICAgICAg
ICAgICAxICAgICAgICAgICAgICAgMg0KPiA+ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+
DQo+ID4NCj4gPiBTdXJlLCBJIHdpbGwgYWRkIGEgY29tbWVudCwgYW5kIGFsc28gIiNpbmNsdWRl
IDxsaW51eC9wcmVmZXRjaC5oPiIgaW4NCj4genN3YXAuYw0KPiA+IHRoYXQgd2lsbCByZXNvbHZl
IHRoZSBidWlsZCBlcnJvci4gVGhpcyBpcyBzaW1pbGFyIHRvIGhvdyB0aGVzZSBmaWxlcyBoYW5k
bGUNCj4gcHJlZmV0Y2h3Og0KPiA+IG1tL3Ztc2Nhbi5jLCBrZXJuZWwvbG9ja2luZy9xc3Bpbmxv
Y2suYywgaW5jbHVkZS9hc20tZ2VuZXJpYy94b3IuaCwgZXRjLg0KPiANCj4gUGxlYXNlIGFsc28g
ZXhwbGljaXRseSBtZW50aW9uIHRoYXQgdGhlIHByZWZldGNoIGFuZCBsaWtlbHkvdW5saWtlbHkN
Cj4gYW5ub3RhdGlvbnMgcHJldmVudCByZWdyZXNzaW9ucyB3aXRoIHNvZnR3YXJlIGNvbXByZXNz
aW9uIGxpa2UgenN0ZCwgYW5kDQo+IGdlbmVyYWxseSBpbXByb3ZlIHRoZSBwZXJmb3JtYW5jZSB3
aXRoIHRoZSBiYXRjaGluZyBjb2RlIGJ5IH4xLjUlLg0KDQpZZXMsIEkgaGF2ZSBtZW50aW9uZWQg
dGhpcyBpbiB0aGUgY29tbWVudHMgYW5kIGNvbW1pdCBsb2cuIFNvIGFsc28gdGhlDQptdXRleCBs
b2NraW5nLg0KDQo+IA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IEthbmNoYW5hDQo+ID4NCg==
