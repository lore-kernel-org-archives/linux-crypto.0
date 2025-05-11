Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF2B10F1;
	Sun, 11 May 2025 22:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747002104; cv=fail; b=ZlNQOHhRVgZ1wsaCx0fIVbCdPrmQrU/4vNnoy+v5eHZViiX6s1bEIrUI/9o3TXAWp1t5E0a1NGjLIx79HkBthfKzxRT702JXtFYPgf7LCeRb/OHKREf/6MTS7HvrPFG1WaKHnRHdGuPAa4NGmuWCxBSQ/5Wj0EZ7kboSYVsGGPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747002104; c=relaxed/simple;
	bh=y42wVzcAySMm7wdhk1x0qCEO09RiymXXO9+UR5Daks8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rqy2oMWgpbQ2P2BjBoF4/0oGvFYCEWURfISQ8jwxq8E1nWYq8Vlb8E4sLRoQq+EjXwV9NMn025BuDvGkGDaqE8nQUdMCtQuVs9fZhKEm3Fk0xj6iDjYc5v84uOoFElb0lcXnbF3Q/xlSbqnOmiJxZ5CCJIhr5Fx4NTbHbxjHZNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RHRQVFC1; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RHRQVFC1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747002102; x=1778538102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y42wVzcAySMm7wdhk1x0qCEO09RiymXXO9+UR5Daks8=;
  b=RHRQVFC1AZIEhz2WGC2MdMGiIDCKW+edLS6aFyLFzOhRsD4jp8P0GmQn
   Ts/sQIieHraEVMk5OS2J7JNd5IF4fmMcW9wzqela2DGj6M3CmmurO126r
   WPafmk63VVb+KxIMdEG0BXG2x0bm2jiFUJIwH1I8S9NtYJNs6XGA0Wd4I
   hmsteMM0C0/4MnfZpFj9B4Gx8SWsUd4wz40PdAsijWlCfX2ZyYvBM6EpX
   lG/PhIJ+dHezUf2/HZvM2O4IleP5bMDIFzVa2fuo7SGyK1EsJZ+UY2XkC
   QCjBZqOZ3aawnK45uiSNw2RcUv/EerDlt1oozA7Q3vnPojAKhMtKN1hJT
   Q==;
X-CSE-ConnectionGUID: DuGuxZFKTjW5iUj3V4AsPQ==
X-CSE-MsgGUID: RSgRR7ppSe6ZmKXg+yH48Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="74183634"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="74183634"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 15:21:41 -0700
X-CSE-ConnectionGUID: E35VrL3LTk6dvBVezqdRyw==
X-CSE-MsgGUID: Kks7PTkwTnWqL/h96eH0Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="142164776"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 15:21:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 11 May 2025 15:21:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 11 May 2025 15:21:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 11 May 2025 15:21:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rZaTHSJK2S5h76mBJFU60z9xmXP9kEX/5ly+jvUdbb6Y99FLk5/RDgdLBy2+04sOHyAtWgT9hKNN+43TGHU7AdFTET405PzjGLMr37MjbGxryTynGo2B+Se36Z4CtGq0S/SXKGbCas5GIe9ANbCXBerGN9MXvc3ofhjNKKx+7GO2P4oXc54XUAqd3U/0jgwGrEIpimtiI64YsJaS+YdzoXq4xFV6pPEazrHgWBPePP4gvQ3ZWbUTz2wPhCFreCptcbM4LTDN4fdKU3qaABUUc6tmFjw0n+0MsTH1bWII8ISaePNWxHTL1GuQQe4aiZxzv5JF61qeoqi+4fPKmSHKnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y42wVzcAySMm7wdhk1x0qCEO09RiymXXO9+UR5Daks8=;
 b=IYrQ1df8+x+9h9zVwEOXkB4jUNvtfveNXAA29yRUxcrq0R69QlkHRxpE1+EXYvrTShRMt6JaxxgpKCwPSrF21BNORT+urx+2IeAFQOfWOk4TLi/hPhQPbzCAKaiyL7T61TFPGUrS3QMnLwS/2p73GpI5eGRE2DZkqEKEUhJY+R8PFbCfvyMhW9uFs1Y/YpiF209ouKvNs60hkAG6n4ezIoGSOnZzak/KUfOkKsMEhoDd7BSV3djy3XjQJ2hHG/BWm0cMb5lGhPEj/siQ2ilFX95gZNUqUsAwyp59j+rVGdOPDDyj47ESbuX1dUq3Ssvhb857LRXICFwWOjMNhstVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ0PR11MB5117.namprd11.prod.outlook.com (2603:10b6:a03:2d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Sun, 11 May
 2025 22:21:23 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8722.027; Sun, 11 May 2025
 22:21:23 +0000
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
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v9 00/19] zswap compression batching
Thread-Topic: [PATCH v9 00/19] zswap compression batching
Thread-Index: AQHbuhHkPoir1/4ImUuqCyXQmSE43bPN+SmAgAAV9nA=
Date: Sun, 11 May 2025 22:21:22 +0000
Message-ID: <PH7PR11MB812188C91B6FFE04C742FDD4C994A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=PSOCKNtX0LXHytMwU67eJ=9-d17T62UMBDMpAeoFb76A@mail.gmail.com>
In-Reply-To: <CAKEwX=PSOCKNtX0LXHytMwU67eJ=9-d17T62UMBDMpAeoFb76A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ0PR11MB5117:EE_
x-ms-office365-filtering-correlation-id: db244fac-291e-4d5c-25e8-08dd90da2987
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NnFLZXdoSmN3QmtIR01ibHVrRGxkM2VyQXo3ZU9tZ0REVzdvd01MMFZvMmdr?=
 =?utf-8?B?TkVOU2ViZFp0OXZEcytPYkhzenFyZU9zdlFYYjFVdXFoM3VlY2tINmlEeXd3?=
 =?utf-8?B?NTVuazlJQVM4QUJKUWtKOUxDcm9adnNCYTJsaGs1R2J0cjkva0lxSXZaMEZC?=
 =?utf-8?B?c1dzOUpTL3ljNm4xa2g2TlJOTHV4VzF0Y0VlVnViTmIwRjJmbUhjY1VuNVNI?=
 =?utf-8?B?N204UTNBTkVhZFdDWWZreFZEQjdnM0pSUlMwSEsrKzBTZndWNVQ0Qk1yWjZJ?=
 =?utf-8?B?YldqdThvZjVtNlY4bnNwd1V0R3JRb20wa1FiczBJZVdPNTd3UzBoNzA1aEJ2?=
 =?utf-8?B?OHdXdnozY1N2M1ZmNzM1ei9aMDBUdFE4S0ErelVkY0NOYjU0ZUptQkIwWTdx?=
 =?utf-8?B?ZGdDUlpQTjIrSjNYK1N6bStzTWU5ak5YcnU5Q2tUUFJWZGNCR1IrR1JFdFQ1?=
 =?utf-8?B?UGtSdTlxaGVBYWhjOTdITEthbFA2QUlaTExhQm5jejFJNmdGcGNSWlg4STF6?=
 =?utf-8?B?aEIrYzdtNUovQ0x6S2NNWHgyMDQvQXZ3S1IxdGgvZnRYZ3ZTNGV6a0ZIY0Nv?=
 =?utf-8?B?WVZjbFlVUEYvTVlZUnRkZHk2SEFLYkVqcE1wNGY1YjdEenNjY2tJWmtUS1d4?=
 =?utf-8?B?VEFXQ1JCVktZTjRPcWNDSUdHSTd5eklWdXhRMkVPd2xTcTl3UzJBSE9iUHZ5?=
 =?utf-8?B?c2l5Y05VK2QzdlY3b3FNN1F2OUpoK3dBeTIyQ2Vpb3RselhvejhtWkduUnJ6?=
 =?utf-8?B?VGpDaElra0EvLzJLSU84MUYzZFZ2UWM5TXV0UlRFbG91RGlRVTB3ZnRaN0t1?=
 =?utf-8?B?MW04NnRYTDh4b3ROaitDR0U3aGtlY3B5a3lOV3FUVVh0bE4wcm5RWXQzVHN1?=
 =?utf-8?B?cTNQUzlDSC9VM1YzKzduMGVxM1Z5NHExTzV6dm9mWHdFWnM0Q1gyK3dYaCtw?=
 =?utf-8?B?clQxN3owZU9QZnlqenljejFpSSszb2l1Y2hUUDdlTmc4Q1F1MU9uRCtNNXd5?=
 =?utf-8?B?OTFrVmtmZ3RaUVUzbDN4QVRRdm5WbDNUY2MvdlFaRG1Dd1orZ2FsTnE4d0tJ?=
 =?utf-8?B?MFpvSStRb3h4R0QxK0RqUTBlUDBTeDJmdHZiWDRXSXJxcVQzTEl4YlRWVHkx?=
 =?utf-8?B?TjJrRTRmMFdmdEFUS1czRVpnTDEvTUlkd2NBcFVRTERvT0RZSndRQ25KMnJy?=
 =?utf-8?B?VElESlJabXR4QmUxeEU1NlhUWXZIaUFvQkNHKytYOXBDeWh2YVNNc0hBRHlD?=
 =?utf-8?B?eStaVlNwcitSOG1sRmFUak1SRExsV3lyWXp3OElNN0VyUTJ4S1ZFaG8zQVFX?=
 =?utf-8?B?OWhEa2RCejBLQ2hkQkZXMENUUkQ2eGw1dEtpU1lFZmZ3RktpUjRtOHgzbW41?=
 =?utf-8?B?WHpadnYySlZuSWZ0SGh0c1NYS0RzTTlYYjFjYVhHa0Y4UW95WWlxOVk4Sjkw?=
 =?utf-8?B?L1d4Y3NUemErT2JiSzBvNTFlcjdXUHM1bVhjMzdNVkdLTlJRNWtHSjcvS2Jr?=
 =?utf-8?B?SmFaaDYwaXo0TEtGV2hFMWN1Y2pHMDE2c3M1VFY4ano1TVN4WnNOR2p5Nkla?=
 =?utf-8?B?dXlBQ3RyaDhtQlFnVGw2T2w4UGRWZEc1bVdnMlJmMWMyeXB0TnhRRGtFQmQ1?=
 =?utf-8?B?K2g2dVl0aXJtWFFhd3ZQakwzM2lFS1pLRDhJRllNcmt0UWJ1T09ZOWtvOS9p?=
 =?utf-8?B?ZFRteXhwNFdsUDRWSTdDcHduZUxVaE9mV0RqK1ZYa3h0VUtSdlNFZldrYzhG?=
 =?utf-8?B?TnZ1b3ZWc3lsWDZsaUZQSlB4NzlXTnFRMFE0Vzc3YXBHeTB6bit3eFBUU0Zk?=
 =?utf-8?B?OWFHaVlLUUY5QU5aVnpQRzhkVmpFdWNxQUFnOGVEaWNDcFhuVVdzdkk2Q3pq?=
 =?utf-8?B?cVhHMU5pL3JtTmlrOHh6S0lsdkNkbUdmcjliOXkxTFJaUjRhZDBhMmZrRUNw?=
 =?utf-8?B?Q21zWkUrMnplTEJFYWtEQnFaeDdGZ3VnSXA5c2JCSllpczJrbk02a01LVGZD?=
 =?utf-8?B?aGZqaTltNzBRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cE4vejZlcUtReGVhaXhqeGFVM1MzZXZiN1pkSENmanRweUpCd0h1YnNyVUYx?=
 =?utf-8?B?QUNRbUQ5NlJ6UkJkQXk1WW1sYkY5V3J4MG5mN0hWOWwrZ081em9qSzJDZzcy?=
 =?utf-8?B?SGRGaW4vUnp0eXZTN3pJcXdSUnRMOEVaOW81V0RCeG9MYW9yU1FsRU1jSC9O?=
 =?utf-8?B?cDZuelZMMHFGR2MweHYwTVAyT3B3VzVXZUl4Ui9lSXVEbVVvUmg3N01KcHJi?=
 =?utf-8?B?clRVTzhFdmVMbFBKZWp1eFlLWmhNcVd4bmFpVW5ZanJyWVpERDFvMzQzWkxZ?=
 =?utf-8?B?OGFnREc3TmJobDJTdDgvMDRvbDdPYlRBZzRrcUJoU29ERHg0dnJjSCtXdzlo?=
 =?utf-8?B?bGZKaVA3VGorUW85TDBvcjM4SDFlZC9VZDJ2cCtCMXZZVFFXQ1k4QS9qRTNK?=
 =?utf-8?B?L2VpVm5iS3YveStaTVpJc2xNeXkwYnRQWUp3N1A1QTJJUS9WaER6YkVwYU9Z?=
 =?utf-8?B?dTFJMk9UWDhaa2JrSUNxazVkaXNZbXdCQW9Zc2xnRVU2ZVQwaHVQWlYwRVRG?=
 =?utf-8?B?R3NmeFNMT3Q5bFJsbFh5WjZNS2V5VVJQYmF2ZFBEZTJYMWYyaFI0VTBtekIx?=
 =?utf-8?B?bUNpaWNZWXMwbmFOZ0xVUmY4N3pCUTl4U0tNT2ZTSFVaZjRKbkpJdnZDbVdU?=
 =?utf-8?B?VUxzOTlzVGN3Q2k2S1JXZmFUY1NtSm11VHNtNE5YMUdta2hLVWJybU1QYmhj?=
 =?utf-8?B?QmNpZktJbStkeTlJMFFzZ1FGaDJVSk1wb3puSUMwa1ptanVyQ2crbklLbnlt?=
 =?utf-8?B?RHhiT1dLTkxYN2RoNm9YbExlNWF2LzdEQXozR1JOdzc0eFM1dHg3aGVvN3Nu?=
 =?utf-8?B?YkYwTWVjbUMySEJmRXg3Q3ZsSm9ZK3p6NnRzOG5iZElFdFFsRlpCemJqYmxk?=
 =?utf-8?B?MUVUN09na09SaEJGblUvK3F1OGR1WTNGYWlFMGZydVA4ZHF5MGlaaXJFb21U?=
 =?utf-8?B?TG9ubG9FOFQvOWhwb3FyQlltY0wvM3RLRmc5ZkM2SW9PeDl5M2NQMUcrTGdr?=
 =?utf-8?B?UDJuaDUxNEZVWGVMbUxKMnZERnF2QkUyT3ZEY3BKM3FNNGt5elM1K3F0aUtx?=
 =?utf-8?B?TGozM1kyM1RjUzUxN2pWVUoyQ05wZEtZdzFXV2lqTEw0cnFhWTJSTE5IV1pP?=
 =?utf-8?B?Z3p0Vi9Lby9WY2c3TE5TRTE0WElJZ0kxRUJSOFBiTU0xY3FDbHNQODlma2dj?=
 =?utf-8?B?bWlGREpEdWpZNktVdzg1VDMyRHNHVlIrU0xML3V5ZE1uMEQwa2pTTUYwVW15?=
 =?utf-8?B?YXpOKzNBRzhwNmoyZmRmSnd0ZHlEKzFWRzdBVWRYaGpvWG5yMWNGNFhhb2hJ?=
 =?utf-8?B?aFNrQ01UZlM2WDhmcExlMnpyNXZSaU9QWXdDY1htQ1R0V3RJVy8reXhaR1or?=
 =?utf-8?B?K1RwYkk3T293em1YWlp3SWoza1FNVTFRb3JreWRoQUpxS0xKQ0ZnY1V0WGJr?=
 =?utf-8?B?cUFKWUdXRkhyR2RhanV2VWF0cEZOWmJmN2t5VjdGSGhTWWlJUWFEZFZSQjR2?=
 =?utf-8?B?ai9iSW5raEVIYVF5czB5K0diSWFIVE1WaDkrTnM2cGhjMUVoaWVkWTZDTkdr?=
 =?utf-8?B?cDF3aGRkUG5hdHhkQ1lNaCtneThZZG9EZFZLSDE5bTZJWFRnZkRIS0FJRHlG?=
 =?utf-8?B?eFVwSC90RHRlbkdRNnBPK2YyckY2S3JEdW4zZ0FRQURHTC9mNTE5OHZJYURs?=
 =?utf-8?B?QzRnSk96WnN6dm5waUt6ZHZUMGlJanFRRVJkR29xY2NFbTNJYnlPUFRSZ3B0?=
 =?utf-8?B?NGxjM0paV2p1dEJSZzhJdHY2T1VaRkJvZWRPNTdUMGNOdVdEcnN3U2p3Tyt0?=
 =?utf-8?B?RFhiZ05NQWxsV0pLYW1GdjBLanRBWXRZU1NUZWw3ZG8rYmNLMDkxdlJxRWVZ?=
 =?utf-8?B?L1oraE01R3lrNFNSZEJXY1V1Y0hpZzZLOStxWUZ0VUFKZ3JaVjR1SFB5N3pr?=
 =?utf-8?B?ai9LMXNrYjZqcTNyNnVQSnZJVkVFODJXdmlUUFVmWTRJaHNyMzNGbC83M3Rr?=
 =?utf-8?B?M3lHM1IvaEx0RjlnSEhSbnRTQ0VsUmJOMkxHQmFCR0lEMmwyZ1R0YWNPcVln?=
 =?utf-8?B?aHlLc2kxY2xZZlBnZnZMaVI1ZlVMazk4NzBGQi8zQk1Fdk55ZlVCVTlHWVpT?=
 =?utf-8?B?ZUwwb1IwSXJweXRBVEtnQTFrVVczODA4QWh3MWozY09UcjV2bVBDazB1N2Jo?=
 =?utf-8?B?MXE1UWYwQ2RWbXJqak9HNyt6ZHBSTnVudmtzdERXS3J0NG5yMEl2TnRXSmkr?=
 =?utf-8?B?bzlOM1BlMVdja3RNWFJrbUV4NFNRPT0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: db244fac-291e-4d5c-25e8-08dd90da2987
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2025 22:21:23.0082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b+UMn7NTpQSL+cVd092bNkSMvn9ZPgKNLvT/bM7eyHl/tviRIKzRzo1oIL4pNGMyuWT9pwS232RUnWcRT8TB/WoxROg1yrvCchtiZRIV/f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IFN1bmRheSwgTWF5IDExLCAyMDI1IDE6NTMgUE0NCj4gVG86
IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+IENj
OiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IGhh
bm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBjaGVuZ21pbmcuemhvdUBs
aW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207IHJ5YW4ucm9iZXJ0c0Bhcm0uY29t
OyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4geWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNvbTsgYWtw
bUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgbGludXgtDQo+IGNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7
IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgY2xh
YmJlQGJheWxpYnJlLmNvbTsgYXJkYkBrZXJuZWwub3JnOw0KPiBlYmlnZ2Vyc0Bnb29nbGUuY29t
OyBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+IDxrcmlzdGVuLmMuYWNj
YXJkaUBpbnRlbC5jb20+OyBGZWdoYWxpLCBXYWpkaSBLIDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwu
Y29tPjsNCj4gR29wYWwsIFZpbm9kaCA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4NCj4gU3ViamVj
dDogUmU6IFtQQVRDSCB2OSAwMC8xOV0genN3YXAgY29tcHJlc3Npb24gYmF0Y2hpbmcNCj4gDQo+
IE9uIFdlZCwgQXByIDMwLCAyMDI1IGF0IDQ6NTPigK9QTSBLYW5jaGFuYSBQIFNyaWRoYXINCj4g
PGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gQ2hhbmdlcyBz
aW5jZSB2ODoNCj4gPiA9PT09PT09PT09PT09PT09PQ0KPiA+IDEpIFJlYmFzZWQgdG8gbW0tdW5z
dGFibGUgYXMgb2YgNC0yMS0yMDI1LCBjb21taXQgMmMwMWQ5ZjNjNjExLg0KPiA+IDIpIEJhY2tw
b3J0ZWQgY29tbWl0cyBmb3IgcmV2ZXJ0aW5nIHJlcXVlc3QgY2hhaW5pbmcsIHNpbmNlIHRoZXNl
IGFyZQ0KPiA+ICAgIGluIGNyeXB0b2Rldi0yLjYgYnV0IG5vdCB5ZXQgaW4gbW0tdW5zdGFibGU6
IHdpdGhvdXQgdGhlc2UgYmFja3BvcnRzLA0KPiA+ICAgIGRlZmxhdGUtaWFhIGlzIG5vbi1mdW5j
dGlvbmFsIGluIG1tLXVuc3RhYmxlOg0KPiA+ICAgIGNvbW1pdCA2NDkyOWZlOGMwYTQgKCJjcnlw
dG86IGFjb21wIC0gUmVtb3ZlIHJlcXVlc3QgY2hhaW5pbmciKQ0KPiA+ICAgIGNvbW1pdCA1OTc2
ZmUxOWUyNDAgKCJSZXZlcnQgImNyeXB0bzogdGVzdG1nciAtIEFkZCBtdWx0aWJ1ZmZlciBhY29t
cA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICB0ZXN0aW5nIiIpDQo+ID4gICAgQmFja3Bv
cnRlZCB0aGlzIGhvdGZpeCBhcyB3ZWxsOg0KPiA+ICAgIGNvbW1pdCAwMDJiYTM0NmUzZDcgKCJj
cnlwdG86IHNjb21wIC0gRml4IG9mZi1ieS1vbmUgYnVnIHdoZW4NCj4gPiAgICBjYWxjdWxhdGlu
ZyBsYXN0IHBhZ2UiKS4NCj4gPiAzKSBjcnlwdG9fYWNvbXBfW2RlXWNvbXByZXNzKCkgcmVzdG9y
ZWQgdG8gbm9uLXJlcXVlc3QgY2hhaW5lZA0KPiA+ICAgIGltcGxlbWVudGF0aW9ucyBzaW5jZSBy
ZXF1ZXN0IGNoYWluaW5nIGhhcyBiZWVuIHJlbW92ZWQgZnJvbSBhY29tcCBpbg0KPiA+ICAgIGNv
bW1pdCA2NDkyOWZlOGMwYTQgKCJjcnlwdG86IGFjb21wIC0gUmVtb3ZlIHJlcXVlc3QgY2hhaW5p
bmciKS4NCj4gDQo+IEknbSBhIGJpdCBjb25mdXNlZC4gV2hpY2ggcGF0Y2hlcyBvbiB0b3Agb2Yg
bW0tdW5zdGFibGUgZG8gSSBuZWVkIGZyb20NCj4gdGhlIGNyeXB0byB0cmVlIGFzIHByZS1yZXF1
aXNpdGUgZm9yIHRoaXMgcGF0Y2ggc2VyaWVzPyBBbmQgaW4gd2hpY2gNCj4gb3JkZXI/DQoNCkhp
IE5oYXQsDQoNCkFzIG9mIHRvZGF5J3MgbW0tdW5zdGFibGUgKGNvbW1pdCAiYzY4Y2ZiYzUwNDhl
IiksIHlvdSBjYW4gYXBwbHkNCnBhdGNoZXMgaW4gdGhpcyBvcmRlcjoNCg0KMSkgY29tbWl0IDY0
OTI5ZmU4YzBhNCAoImNyeXB0bzogYWNvbXAgLSBSZW1vdmUgcmVxdWVzdCBjaGFpbmluZyIpDQog
ICAgIGZyb20gdGhlIGNyeXB0b2Rldi0yLjYgdHJlZS4gT3IsIFBhdGNoIDAwMDEgaW4gdGhpcyBz
ZXJpZXMgdGhhdCBkb2VzDQogICAgIHRoZSBzYW1lLg0KMikgUGF0Y2ggMDAwMiBpbiB0aGlzIHNl
cmllcy4NCjMpIFNraXAgUGF0Y2hlcyAwMDAzIGFuZCAwMDA0IGluIHRoaXMgc2VyaWVzLCBzaW5j
ZSB0aGV5IHdlcmUgbm90IGluDQogICAgIG1tLXVuc3RhYmxlIHdoZW4gSSBjcmVhdGVkIHRoaXMg
cGF0Y2ggc2VyaWVzLiBUaGV5IGFyZSBub3cgaW4NCiAgICAgbW0tdW5zdGFibGUuDQo0KSBBcHBs
eSBQYXRjaGVzIDAwMDUtMDAxOSBpbiB0aGlzIHNlcmllcy4NCg0KVGhhbmtzLA0KS2FuY2hhbmEN
Cg0K
