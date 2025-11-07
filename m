Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF776282F5;
	Fri,  7 Nov 2025 02:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762482510; cv=fail; b=o3nt+R0DE6l2TCYUZZqQahRqeaigrPoFHUKQtPEiF8qKr5xcJy+lk7BE8POnfWpE9KNvdn+NRmt8iq9FBNUoeLsWDqsUqzZCCLR3oL+VA4pWS1CQppcNaRBpMBF58tQb63SPIc57xkjVHPYwxZT2t5wrQlmrj67MUGAoa3harAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762482510; c=relaxed/simple;
	bh=4Ko9NpwY87dAY99VSv2P1BhTuA5W6/LzZ7cZL7tHgyo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pv67CuYyqQVkSds1ryVJqQCwuuuuvUK+yfjJAyUAIFzfxqhHM0rjx6tyoFr47JG3GrFPQotXtTdoCZGowt+l+oVCGUoAKK6pQBzgunbvg9sx93bVbuWIAui4R9QPe2tyrFEEggod6Ci+ZNKIQpw6SsJ8P6vvrLaqJVtU4FLkNh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SYZnXRBv; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SYZnXRBv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762482508; x=1794018508;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Ko9NpwY87dAY99VSv2P1BhTuA5W6/LzZ7cZL7tHgyo=;
  b=SYZnXRBvfkw3IX9yL0m9iHMo9zYIzt1QN3T39pfk3qmQBE8FBvUQhSr3
   68hk64qgD3305jPkSzo2IjGiKnHbFGA1vUpDNapT4M4wX41CA1fL/q9Lo
   3PZiRUf0fozjde/yZRACiaQxwycMIrOhlsEjoDGSEcvCr04U2rQw5oUba
   bAqKOTlc13yDvH+Akam4NoiqMY45daWvB2poW4qZemALMqR/YJPShS7Nf
   jSByT0pcKVuE7wEREMM4Lh+CUsZtxZvctQKZWQlDwt6fhF4G+zu/bxzZL
   OgMerd5vjM2vO3ap+vv23vvUtntR0qeF51Hg7YFckpSPXthdcSEf5yWBb
   w==;
X-CSE-ConnectionGUID: HKxnKUVtQlmqf8uEFAqi9g==
X-CSE-MsgGUID: bOhrGkiFRLOduEteuNp5yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64539702"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64539702"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 18:28:27 -0800
X-CSE-ConnectionGUID: y9l1undaQ5qqRnlJ0/AcFQ==
X-CSE-MsgGUID: N7fYH5gpTTCYilamNb/cdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="218581244"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 18:28:27 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 18:28:26 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 18:28:26 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.39) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 18:28:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrpB+nlOM+vK8zIu1B98FoKrwIjRzL8GdQHmLyN/7z9kTN9VObz1c4Nxjdkpnaz++xM0AOBFuW8fwbhvjjrZ9pTlaFB7WeUPYShtrlYVJpyOBNiLho8HuAY7YQZXSamNC8i3YansFaU/I/NvwmlHoJzv7CSZytqa0jn/KxW3M0D1lcO2bmAsczy26rFebJMBVVznZk5lu+8iYYgjyjzwOyqSQVWHkHVdSpaaMlD7pwkGYfhvTOR90r9d52Mr4Kt8e9S5EHS2IAKhhT37eU48c+ydVGDce2GQ0qwsr5vbgV0Kc3ypixA0WlrHUvZAgjaiF3wa1l0vG2jA+bJYDfSqCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ko9NpwY87dAY99VSv2P1BhTuA5W6/LzZ7cZL7tHgyo=;
 b=OKSFJaWxm3a+MEmBXoYbtJMBGcuR5qHTrKyqKMe+OG1nUiMhm40MeYyKEBhW7UPmuyESVaBMpG4EWiPLzB0aNTBsGq7yNOjk3bFrtktYaLxRqLCo56Gx0XtP6yGtmYO9OZblduqTUm67Pd1sCD7GyXDqwg60MkxZrXzyMManwdyQ13Qm5ovHjYFoYxwS5HSehporaEC4JtWNQ37kucy3Z3R9i4jw2gn34NZceOTcf5UXX2PWQk3LKddXnEgdI2TK8RVehbc0t7H31FVFvOFGyAEEByKywb/kdJy5slkfJMjV4DSPjHoAK6Al8j2DJwck5ffsFulhilU3j3Aky1oxUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by IA1PR11MB6347.namprd11.prod.outlook.com (2603:10b6:208:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 02:28:23 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb%4]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 02:28:23 +0000
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
Subject: RE: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcTWsxfEPA0eGp6kWYA/H17miOhLTl748AgACN9ZA=
Date: Fri, 7 Nov 2025 02:28:23 +0000
Message-ID: <SJ2PR11MB84726D144013B971838DC0DEC9C3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmJcsQy5foaS6HecqLyF1gKBhbLvbw6kM9bZmJ7UMBFw@mail.gmail.com>
In-Reply-To: <CAKEwX=PmJcsQy5foaS6HecqLyF1gKBhbLvbw6kM9bZmJ7UMBFw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|IA1PR11MB6347:EE_
x-ms-office365-filtering-correlation-id: 3e47b8a2-d86b-4f9e-96ef-08de1da552f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NnJzVWthVlRCSG9zbXZYSFhvS2FCZjZSazJQTVlQUWVwTXBKcWJvUjI4SEZN?=
 =?utf-8?B?dVBiSGc4czU0eW8yZTZCQ3pDMEJPQUo3RWxtWHp5d1ZEUTVnMzVKNSsxSm83?=
 =?utf-8?B?SlNkZHlhQlhVc2Z3b3pWakNHY21ERUZSMWNhQWQ3b3dRK3JKZWsrcU84bnJz?=
 =?utf-8?B?WWlkWThac0doUFBiL2dBR3lHUndvV3VHaEhFRTd1QnJMcmZpcGZmNEhhMFNw?=
 =?utf-8?B?REo0ZGUxYnR4SEM2MjUrV0NCeFFWT1Npcy9VVEZNeGlhZGxhU1k3bW9CZ0Zh?=
 =?utf-8?B?VkM5eWpXZDN2ZUxvelhLQUFqS2hWOGdKLy8vS1BpL0pVNU0zbXVFSDJPa2Za?=
 =?utf-8?B?ckNMMWhpSTAzQjRvbmRhL29jV0JRWlEzai91MzNDTzFPdkhYZldHU1ovWG9o?=
 =?utf-8?B?YzdlWHdoZWphWjBLeUZpaEJEanBRVHBtOThsYSt1a05YRkRUK2tqR3F5d1BL?=
 =?utf-8?B?QTVKY0s0VUZrY1lVWWNNS2N6OGFmWmRMdURJUm05dHREbFkyRmlqOFh1aURZ?=
 =?utf-8?B?cWRjU0RraU5od2xIazU1TjdOM251STFuSGNLUlRIVXh4TmJJTmM3bkJKSHlG?=
 =?utf-8?B?Z2o3eXUvNVUrT2dQQjJsTUhuYld1OUxFL3VzRk12bnVNUG8vSERYQ0RsbEMy?=
 =?utf-8?B?RWxaTWhxV3FJRnBXQ1NJdmhwZ3hKTjhFUWNtVWo3MmpZQTlBbmNNT01acnlk?=
 =?utf-8?B?T3BST2s2eWZwOFI2RWd2a3RodnNoS0E3TnA2cEJJa3ZXam1FQ2ZleUdqd3RQ?=
 =?utf-8?B?bkZaRmNGQVFWdWpUa3UrSWhkc3hMYlU4Q3F5VFVMcGtrMWxCZ3NtekFBVUZj?=
 =?utf-8?B?Z3VIVjNScVZWck5VY0VjbjQwMEMxMkNBUUVqcHlTaEx5UjgyVEFZbTRWeFdN?=
 =?utf-8?B?R0hWSHVoS1pxNDZqaEtWQU92bGlPRDQ4eGdLSzhzNUE0NVRmRkNrYzFidS9u?=
 =?utf-8?B?aVNjYjRpckc3NGJNZjlQd3NZQUs5Q2IybXlTVGJodURma0xleU56ME56cHUx?=
 =?utf-8?B?bmVNbWdockdLVTk3M2M5Ym81Nm5mSDBOakFIOVRmeTNYTmFPMythRTdocGRU?=
 =?utf-8?B?aWp3NFVRdFV3TmtiQ1EzNGJ4TUdGbGplbkxXdGVFT2ZPYWtHdUpVZVJSWEo3?=
 =?utf-8?B?TFozRzJrOG1KTHNrOC9HTktaY0tVL21mWGMrOUNmai93RkJsZmt3eDhjbXo2?=
 =?utf-8?B?SkZaT0s2ZFNJVEtJR1JYQmt5KzAzZHpYb2FPOXFlSkFsanNpWkVHNkNtMUdy?=
 =?utf-8?B?UlBsc2RTVEpMU0VLb3gxYkFmUW1LMTErckY0ZDdaWnNEcjF5ZFcrdG1EVGxw?=
 =?utf-8?B?SXkwamVQMDFCSWpkZXovUXQwNmE0Q0RNYUFXRjBIb1cwUldZM0V0cURQV3lB?=
 =?utf-8?B?Nlc4M2Y4MGowL0ZsK1k3TDUrWDh3ekRQSWkzcUltYmNlaVh4ZUxJZTlkU0VM?=
 =?utf-8?B?dXdZNXE1dDJrTG0wdUlsTFVZSGxaVWMwa2xoNlR4dWc1eENZRmtJa2F2ZnBN?=
 =?utf-8?B?TVozQlEzQm50RjQvL0JrckVld01wTGZLV2NBK25TSTNSWXNkVDN3UFdHMytX?=
 =?utf-8?B?SFdqbHViWlZ0YWk5dTUybzRzVG1hY0M4WnBTZkxWRVUxZE5ORW5iczhtdm96?=
 =?utf-8?B?amgrTWcxVk4xb3NwREQ1VUhPRXdBWC9RNkp1Q3E5K2dhQzRUWnVueXdFc3hx?=
 =?utf-8?B?aTQyVzZjT0ExL2lXUjgyekFRU2EydGI5bWh1Zlo3aWlValZYY2lnbmJPVVo5?=
 =?utf-8?B?LzJLNVZKVnIreFJQYmxyeU5kUFlOYnJoWndCVGZvMU4vVWFRcHFaRFNIeFZl?=
 =?utf-8?B?UitxZGxVb0F0Y085TWNrY0VuY0xuM2FIamV4NHhXeG9Ha0FQRkVqWS9XQWtx?=
 =?utf-8?B?MTJFb21pMEE3emFTNFdMTEQwdDlYS000OE9FK09KdHJFNkZiOEpOTi85b0ZC?=
 =?utf-8?B?bEJzUHBhbDI4WDJNYkxYZXFZYVVaVzY1ZWI4Y1FDbG9aZU1aeXRvdUVwMzZ5?=
 =?utf-8?B?KzNGSUR4S3R5b041QTBWNitmSkp2bGVDd1NSNm9TUFoycWlFMWRKMElSdlBK?=
 =?utf-8?Q?znKgme?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXNBTVU5OFhYVStFdVF5aENSUGZUcUFseGNzcmh4eklMbHRpY0RQZHRZUWJo?=
 =?utf-8?B?UEIvZHJCQlN5bkNDMEI2SFZYUkJ1MVh1eTdjaVREWkNuTWVWc3BRam1DNUhM?=
 =?utf-8?B?RXlsZW5XcUZJcHBIejJCK2QzUEJxOXlZQnVHS252Wjk5SDhMdTlxdndBRThY?=
 =?utf-8?B?NXdMaHpFVkZtNEJRd1VNM0lqeHIyb3ZCdVZmYXBWSG9TQk45VTlRbDlkRG9J?=
 =?utf-8?B?UmNFVmFjRGpObXVzTFl1WWV3UUxNWXZvYUc2WEFuZVExdnB4TG1TZ2hZS1Ar?=
 =?utf-8?B?WWxLejd6eGgrOFpTVExyVkN1RHRlNWpnNER1L092SCs3OGJ5UE5LdmdFeEN0?=
 =?utf-8?B?NU5DRnJjYkpzRkREaXE0QnZYaVdyWkJZOGk4d2d2REMzdmkwbjNreXhDeWFy?=
 =?utf-8?B?b05CYlV2RGNOelI1Z1R6ZG9udkRWazZMWGRVdEZRMXBXUmVZaDFtRytVc0N5?=
 =?utf-8?B?WFoxWU1UTkdUemxHeThJQ283NmlseWxnVUhjTjdMYlU5dkdRTXlBUHN1TjlT?=
 =?utf-8?B?NGEzTDhOUkZzVk1pb2RaZkhGWkdMUmFlQS85b3huS01FaUh2QUhETGhKdm1L?=
 =?utf-8?B?cm1obTUwVlhJbHpjNmtUdEFKNjBGWWhDUksrVS9ORGpLZFB2cVFPRWVEUjQz?=
 =?utf-8?B?NjZNcXVyd0JQeFBpNjloVGNLenFmaE1wSlowckRoWThPQkE4Y2xveTRoc1hL?=
 =?utf-8?B?MHE3ZmZTdFdOaE42RUdlVENVUFRjYjluSHBqa2FtMnhBeXQ1elFFeHNqVWdU?=
 =?utf-8?B?YTA0TCtuaC81aWJKRWV2UHVnWmorQnlRSW90MC9GREdCTzVsVEt0c2V4eUlU?=
 =?utf-8?B?M1pzWUtyZlF0L2NNTDNtbXpnVXdRNFc2dlByZEphbUhWSWNpTHpveWV3YjVt?=
 =?utf-8?B?ZlRtWEJZanlBRzgzU25LWVowUFJOL2lEdkZmdHYxUU1JUlI2M2JZWGdQVmNh?=
 =?utf-8?B?VGhtYll5c1Y2NVh4bDJUZEdnTXNXWWh0ZGVYQURuVWZNOURHMGtjcUg0Ukhj?=
 =?utf-8?B?Y3lYbFZxYlhTVlVCY1JvYm9BVzFHekY1cHlteEtjdGNpMy9ZUWVWU1J6RGtY?=
 =?utf-8?B?Q1A3Yndob0NSMGsrNWEySFhHejB6TVVBZVdQM1FtTjdiZzVLWmVLWmZQdWpn?=
 =?utf-8?B?NU10YVBFUWZtMVc0QkJzdnBCdHl2QWExT2NEaFZVeUVuK3I3ZlgvMHpjWTg1?=
 =?utf-8?B?WFlacmlubDJxT01UQ01YdVFDeXBpdDI2d245OURIcDdGWEFrM0xaYjBkdDdi?=
 =?utf-8?B?WmFSWGNaWVFGdWRrdy96OFVjbTM5NmU0RGFKeGdnempPb2g4K1p3TzVvZmxk?=
 =?utf-8?B?ZXpRa0lDTmdYNllyZnpUM09aNFIvWHN2MkQ1UmlhaTNFbnVVRmprbU90dlFX?=
 =?utf-8?B?bTh4c1ZYZ0FUNzdTVzU1dFhYLy9rZ1dCeGI4YTZWSGQ2SzBRVlBUSnltbSt6?=
 =?utf-8?B?Ly9qZ1hybmpiS3A4NFRYYThVQk1KbE9UdG1PQTM3UzhUUkFwSjluTytWbkZh?=
 =?utf-8?B?RDJXb3hTOGJsY1Q5eHRmaEk2SGIyM0FnZUdMay9pbmY4akVhV001TkV6aC9Y?=
 =?utf-8?B?RXR5QnFyakptTGJVdFR4bStpMkxlN3UrMzB0THpubkM0MlhSWVFlMnZCQlh3?=
 =?utf-8?B?S29icmZBeUhjRUpzcEZnVnhVUCtsT2F5MzMwZy9RNGZIcUdpZ3pheWhCT3F5?=
 =?utf-8?B?TmNXT3lLRm51RlBSM2phQTJJNUhiTVhPd01CMC9ZZEpqaWwvbHpnLzIwZG1a?=
 =?utf-8?B?dHNSb0g4UDhpcTNzWHF1L2g1b1p5bXQ1MlpCRHBjWHg5V3pLNHVvOW1xcjgw?=
 =?utf-8?B?bEN2YUxOVFJzd2RBS1Z1UGxZUStaWlQ4aFkvYzNkRVQ2akZlbmovVVpyWW9j?=
 =?utf-8?B?VmRLbURhTENGU0UydkkvcUhia2t4TGlTWkpleDhsM2U4bTcxSXFtRkdlQXlz?=
 =?utf-8?B?M1Q0anN0WHI4MHBKbHUvdHYzMy9FM3FOZmlHblAwdkxuWkgvUmtsMFdwZ0t2?=
 =?utf-8?B?VVRXSFhmaXRPbzF5MG5FWG9jZ3d5cDJTWlhjOE1NSTlKMXpwbnNNdkZqZFht?=
 =?utf-8?B?THZ2OG5QYk11bDV4SEhFMElzVVNKbzlUYzNSd1RNVGcrYU9QdTdyT1FUUFBW?=
 =?utf-8?B?QWxFQnR1Q1dLem03cWF3VzVsUnZ0UFBUTzl3NUVBY2FuOHNLTGlpWG1nSFlB?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e47b8a2-d86b-4f9e-96ef-08de1da552f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2025 02:28:23.1397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eNe8OQQGnsWn/lfse86fWhWqDWr58NwCc2m3XvOkNVZ5u0gxPW56BASLIghutKPxVd4iYulJIDe2I5tATjKhYGHhnkQlR+FR2f3t6jqdHS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6347
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJlciA2LCAyMDI1IDk6NDYgQU0N
Cj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBjaGVuZ21pbmcu
emhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207IHJ5YW4ucm9iZXJ0c0Bh
cm0uY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4geWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNv
bTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gc2Vub3poYXRza3lAY2hyb21pdW0ub3Jn
OyBzakBrZXJuZWwub3JnOyBrYXNvbmdAdGVuY2VudC5jb207IGxpbnV4LQ0KPiBjcnlwdG9Admdl
ci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IGNsYWJiZUBiYXlsaWJyZS5jb207IGFyZGJAa2VybmVsLm9yZzsNCj4gZWJpZ2dl
cnNAZ29vZ2xlLmNvbTsgc3VyZW5iQGdvb2dsZS5jb207IEFjY2FyZGksIEtyaXN0ZW4gQw0KPiA8
a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgR29tZXMsIFZpbmljaXVzIDx2aW5pY2l1cy5n
b21lc0BpbnRlbC5jb20+Ow0KPiBGZWdoYWxpLCBXYWpkaSBLIDx3YWpkaS5rLmZlZ2hhbGlAaW50
ZWwuY29tPjsgR29wYWwsIFZpbm9kaA0KPiA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCB2MTMgMjEvMjJdIG1tOiB6c3dhcDogenN3YXBfc3RvcmUoKSB3aWxs
IHByb2Nlc3MgYQ0KPiBsYXJnZSBmb2xpbyBpbiBiYXRjaGVzLg0KPiANCj4gT24gVHVlLCBOb3Yg
NCwgMjAyNSBhdCAxOjEy4oCvQU0gS2FuY2hhbmEgUCBTcmlkaGFyDQo+IDxrYW5jaGFuYS5wLnNy
aWRoYXJAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IFRoaXMgcGF0Y2ggbWFrZXMgdHdvIG1h
am9yIGNoYW5nZXM6DQo+ID4NCj4gPiBGaXJzdCwgd2UgYWxsb2NhdGUgcG9vbCBiYXRjaGluZyBy
ZXNvdXJjZXMgaWYgdGhlIGNvbXByZXNzb3Igc3VwcG9ydHMNCj4gPiBiYXRjaGluZzoNCj4gPg0K
PiA+ICAgVGhpcyBwYXRjaCBzZXRzIHVwIHpzd2FwIGZvciBhbGxvY2F0aW5nIHBlci1DUFUgcmVz
b3VyY2VzIG9wdGltYWxseQ0KPiA+ICAgZm9yIG5vbi1iYXRjaGluZyBhbmQgYmF0Y2hpbmcgY29t
cHJlc3NvcnMuDQo+ID4NCj4gPiAgIEEgbmV3IFpTV0FQX01BWF9CQVRDSF9TSVpFIGNvbnN0YW50
IGlzIGRlZmluZWQgYXMgOFUsIHRvIHNldCBhbiB1cHBlcg0KPiA+ICAgbGltaXQgb24gdGhlIG51
bWJlciBvZiBwYWdlcyBpbiBsYXJnZSBmb2xpb3MgdGhhdCB3aWxsIGJlIGJhdGNoDQo+ID4gICBj
b21wcmVzc2VkLg0KPiA+DQo+ID4gICBJdCBpcyB1cCB0byB0aGUgY29tcHJlc3NvciB0byBtYW5h
Z2UgbXVsdGlwbGUgcmVxdWVzdHMsIGFzIG5lZWRlZCwgdG8NCj4gPiAgIGFjY29tcGxpc2ggYmF0
Y2ggcGFyYWxsZWxpc20uIHpzd2FwIG9ubHkgbmVlZHMgdG8gYWxsb2NhdGUgdGhlIHBlci1DUFUN
Cj4gPiAgIGRzdCBidWZmZXJzIGFjY29yZGluZyB0byB0aGUgYmF0Y2ggc2l6ZSBzdXBwb3J0ZWQg
YnkgdGhlIGNvbXByZXNzb3IuDQo+ID4NCj4gPiAgIEEgInU4IGNvbXByX2JhdGNoX3NpemUiIG1l
bWJlciBpcyBhZGRlZCB0byAic3RydWN0IHpzd2FwX3Bvb2wiLCBhcyBwZXINCj4gPiAgIFlvc3J5
J3Mgc3VnZ2VzdGlvbi4gcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSBpcyBzZXQgYXMgdGhlIG1pbmlt
dW0gb2YNCj4gPiAgIHRoZSBjb21wcmVzc29yJ3MgbWF4IGJhdGNoLXNpemUgYW5kIFpTV0FQX01B
WF9CQVRDSF9TSVpFLg0KPiBBY2NvcmRpbmdseSwNCj4gPiAgIHBvb2wtPmNvbXByX2JhdGNoX3Np
emUgY29tcHJlc3Npb24gZHN0IGJ1ZmZlcnMgYXJlIGFsbG9jYXRlZCBpbiB0aGUNCj4gPiAgIHBl
ci1DUFUgYWNvbXBfY3R4Lg0KPiA+DQo+ID4gICB6c3dhcCBkb2VzIG5vdCB1c2UgbW9yZSB0aGFu
IG9uZSBkc3QgYnVmZmVyIHlldC4gRm9sbG93LXVwIHBhdGNoZXMNCj4gPiAgIHdpbGwgYWN0dWFs
bHkgdXRpbGl6ZSB0aGUgbXVsdGlwbGUgYWNvbXBfY3R4IGJ1ZmZlcnMgZm9yIGJhdGNoDQo+ID4g
ICBjb21wcmVzc2lvbi9kZWNvbXByZXNzaW9uIG9mIG11bHRpcGxlIHBhZ2VzLg0KPiA+DQo+ID4g
ICBUaHVzLCBaU1dBUF9NQVhfQkFUQ0hfU0laRSBsaW1pdHMgdGhlIGFtb3VudCBvZiBleHRyYSBt
ZW1vcnkgdXNlZA0KPiBmb3INCj4gPiAgIGJhdGNoaW5nLiBUaGVyZSBpcyBhIHNtYWxsIGV4dHJh
IG1lbW9yeSBvdmVyaGVhZCBvZiBhbGxvY2F0aW5nDQo+ID4gICB0aGUgYWNvbXBfY3R4LT5idWZm
ZXJzIGFycmF5IGZvciBjb21wcmVzc29ycyB0aGF0IGRvIG5vdCBzdXBwb3J0DQo+ID4gICBiYXRj
aGluZzogT24geDg2XzY0LCB0aGUgb3ZlcmhlYWQgaXMgMSBwb2ludGVyIHBlci1DUFUgKGkuZS4g
OCBieXRlcykuDQo+ID4NCj4gPiBOZXh0LCB3ZSBzdG9yZSB0aGUgZm9saW8gaW4gYmF0Y2hlczoN
Cj4gPg0KPiA+ICAgVGhpcyBwYXRjaCBtb2RpZmllcyB6c3dhcF9zdG9yZSgpIHRvIHN0b3JlIGEg
YmF0Y2ggb2YgcGFnZXMgaW4gbGFyZ2UNCj4gPiAgIGZvbGlvcyBhdCBhIHRpbWUsIGluc3RlYWQg
b2Ygc3RvcmluZyBvbmUgcGFnZSBhdCBhIHRpbWUuIEl0IGRvZXMgdGhpcyBieQ0KPiA+ICAgY2Fs
bGluZyBhIG5ldyBwcm9jZWR1cmUgenN3YXBfc3RvcmVfcGFnZXMoKSB3aXRoIGEgcmFuZ2Ugb2Yg
aW5kaWNlcyBpbg0KPiA+ICAgdGhlIGZvbGlvOiBmb3IgYmF0Y2hpbmcgY29tcHJlc3NvcnMsIHRo
aXMgcmFuZ2UgY29udGFpbnMgdXAgdG8NCj4gPiAgIHBvb2wtPmNvbXByX2JhdGNoX3NpemUgcGFn
ZXMuIEZvciBub24tYmF0Y2hpbmcgY29tcHJlc3NvcnMsIHdlIHNlbmQgdXANCj4gPiAgIHRvIFpT
V0FQX01BWF9CQVRDSF9TSVpFIHBhZ2VzIHRvIGJlIHNlcXVlbnRpYWxseSBjb21wcmVzc2VkIGFu
ZA0KPiBzdG9yZWQNCj4gPiAgIGluIHpzd2FwX3N0b3JlX3BhZ2VzKCkuDQo+ID4NCj4gPiAgIHpz
d2FwX3N0b3JlX3BhZ2VzKCkgaW1wbGVtZW50cyBhbGwgdGhlIGNvbXB1dGVzIGRvbmUgZWFybGll
ciBpbg0KPiA+ICAgenN3YXBfc3RvcmVfcGFnZSgpIGZvciBhIHNpbmdsZS1wYWdlLCBmb3IgbXVs
dGlwbGUgcGFnZXMgaW4gYSBmb2xpbywNCj4gPiAgIG5hbWVseSB0aGUgImJhdGNoIjoNCj4gPg0K
PiA+ICAgMSkgSXQgc3RhcnRzIGJ5IGFsbG9jYXRpbmcgYWxsIHpzd2FwIGVudHJpZXMgcmVxdWly
ZWQgdG8gc3RvcmUgdGhlDQo+ID4gICAgICBiYXRjaC4gTmV3IHByb2NlZHVyZXMsIHpzd2FwX2Vu
dHJpZXNfY2FjaGVfYWxsb2NfYmF0Y2goKSBhbmQNCj4gPiAgICAgIHpzd2FwX2VudHJpZXNfY2Fj
aGVfZnJlZV9iYXRjaCgpIGNhbGwga21lbV9jYWNoZV9bZnJlZV1hbGxvY19idWxrKCkNCj4gPiAg
ICAgIHRvIG9wdGltaXplIHRoZSBwZXJmb3JtYW5jZSBvZiB0aGlzIHN0ZXAuDQo+ID4NCj4gPiAg
IDIpIFRoZSBlbnRyeSBkb2Vzbid0IGhhdmUgdG8gYmUgYWxsb2NhdGVkIG9uIHRoZSBzYW1lIG5v
ZGUgYXMgdGhlIHBhZ2UNCj4gPiAgICAgIGJlaW5nIHN0b3JlZCBpbiB6c3dhcDogd2UgbGV0IHRo
ZSBzbGFiIGFsbG9jYXRvciBkZWNpZGUgdGhpcyBpbg0KPiA+ICAgICAga21lbV9jYWNoZV9hbGxv
Y19idWxrKCkuIEhvd2V2ZXIsIHRvIG1ha2Ugc3VyZSB0aGUgY3VycmVudCB6c3dhcA0KPiA+ICAg
ICAgTFJVIGxpc3Qvc2hyaW5rZXIgYmVoYXZpb3IgaXMgcHJlc2VydmVkLCB3ZSBzdG9yZSB0aGUg
Zm9saW8ncyBuaWQgYXMNCj4gPiAgICAgIGEgbmV3IEBuaWQgbWVtYmVyIGluIHRoZSBlbnRyeSB0
byBlbmFibGUgYWRkaW5nIGl0IHRvIHRoZSBjb3JyZWN0DQo+ID4gICAgICBMUlUgbGlzdCAoYW5k
IGRlbGV0aW5nIGl0IGZyb20gdGhlIHJpZ2h0IExSVSBsaXN0KS4gVGhpcyBlbnN1cmVzDQo+ID4g
ICAgICB0aGF0IHdoZW4gdGhlIGZvbGlvJ3MgYWxsb2NhdGluZyBOVU1BIG5vZGUgaXMgdW5kZXIg
bWVtb3J5DQo+ID4gICAgICBwcmVzc3VyZSwgdGhlIGVudHJpZXMgY29ycmVzcG9uZGluZyB0byBp
dHMgcGFnZXMgYXJlIHdyaXR0ZW4gYmFjay4NCj4gPg0KPiA+ICAgICAgVGhlIG1lbW9yeSBmb290
cHJpbnQgb2Ygc3RydWN0IHpzd2FwX2VudHJ5IHJlbWFpbnMgdW5jaGFuZ2VkIGF0DQo+ID4gICAg
ICA1NiBieXRlcyB3aXRoIHRoZSBhZGRpdGlvbiBvZiB0aGUgImludCBuaWQiIG1lbWJlciBieSBj
b25kZW5zaW5nDQo+ID4gICAgICAibGVuZ3RoIiBhbmQgInJlZmVyZW5jZWQiIGludG8gNCBieXRl
cyB1c2luZyBiaXQgZmllbGRzIGFuZCB1c2luZw0KPiA+ICAgICAgdGhlIDQgYnl0ZXMgYXZhaWxh
YmxlIGFmdGVyICJyZWZlcmVuY2VkIiBmb3IgdGhlICJpbnQgbmlkIi4gVGhhbmtzDQo+ID4gICAg
ICB0byBOaGF0IGFuZCBZb3NyeSBmb3IgdGhlc2Ugc3VnZ2VzdGlvbnMhDQo+ID4NCj4gPiAgIDMp
IE5leHQsIHRoZSBlbnRyaWVzIGZpZWxkcyBhcmUgd3JpdHRlbiwgY29tcHV0ZXMgdGhhdCBuZWVk
IHRvIGJlIGhhcHBlbg0KPiA+ICAgICAgYW55d2F5LCB3aXRob3V0IG1vZGlmeWluZyB0aGUgenN3
YXAgeGFycmF5L0xSVSBwdWJsaXNoaW5nIG9yZGVyLiBUaGlzDQo+ID4gICAgICBhdm9pZHMgYnJp
bmdpbmcgdGhlIGVudHJpZXMgaW50byB0aGUgY2FjaGUgZm9yIHdyaXRpbmcgaW4gZGlmZmVyZW50
DQo+ID4gICAgICBjb2RlIGJsb2NrcyB3aXRoaW4gdGhpcyBwcm9jZWR1cmUsIGhlbmNlIGltcHJv
dmVzIGxhdGVuY3kuDQo+ID4NCj4gPiAgIDQpIE5leHQsIGl0IGNhbGxzIHpzd2FwX2NvbXByZXNz
KCkgdG8gc2VxdWVudGlhbGx5IGNvbXByZXNzIGVhY2ggcGFnZSBpbg0KPiA+ICAgICAgdGhlIGJh
dGNoLg0KPiA+DQo+ID4gICA1KSBGaW5hbGx5LCBpdCBhZGRzIHRoZSBiYXRjaCdzIHpzd2FwIGVu
dHJpZXMgdG8gdGhlIHhhcnJheSBhbmQgTFJVLA0KPiA+ICAgICAgY2hhcmdlcyB6c3dhcCBtZW1v
cnkgYW5kIGluY3JlbWVudHMgenN3YXAgc3RhdHMuDQo+ID4NCj4gPiAgIDYpIFRoZSBlcnJvciBo
YW5kbGluZyBhbmQgY2xlYW51cCByZXF1aXJlZCBmb3IgYWxsIGZhaWx1cmUgc2NlbmFyaW9zDQo+
ID4gICAgICB0aGF0IGNhbiBvY2N1ciB3aGlsZSBzdG9yaW5nIGEgYmF0Y2ggaW4genN3YXAgYXJl
IGNvbnNvbGlkYXRlZCB0byBhDQo+ID4gICAgICBzaW5nbGUgInN0b3JlX3BhZ2VzX2ZhaWxlZCIg
bGFiZWwgaW4genN3YXBfc3RvcmVfcGFnZXMoKS4gSGVyZSBhZ2FpbiwNCj4gPiAgICAgIHdlIG9w
dGltaXplIHBlcmZvcm1hbmNlIGJ5IGNhbGxpbmcga21lbV9jYWNoZV9mcmVlX2J1bGsoKS4NCj4g
Pg0KPiA+IFRoaXMgY29tbWl0IGFsc28gbWFrZXMgYSBtaW5vciBvcHRpbWl6YXRpb24gaW4genN3
YXBfY29tcHJlc3MoKSwgdGhhdA0KPiA+IHRha2VzIGEgImJvb2wgd2JfZW5hYmxlZCIgYXJndW1l
bnQ7IGNvbXB1dGVkIG9uY2UgaW4genN3YXBfc3RvcmUoKQ0KPiA+IHJhdGhlciB0aGFuIGZvciBl
YWNoIHBhZ2UgaW4gdGhlIGZvbGlvLg0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBOaGF0IFBoYW0g
PG5waGFtY3NAZ21haWwuY29tPg0KPiA+IFN1Z2dlc3RlZC1ieTogWW9zcnkgQWhtZWQgPHlvc3J5
LmFobWVkQGxpbnV4LmRldj4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYW5jaGFuYSBQIFNyaWRoYXIg
PGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIG1tL3pzd2FwLmMg
fCAzMzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQ0K
PiAtLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMzIgaW5zZXJ0aW9ucygrKSwgMTA0IGRlbGV0
aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL21tL3pzd2FwLmMgYi9tbS96c3dhcC5jDQo+
ID4gaW5kZXggY2IzODRlYjdjODE1Li4yNTc1NjdlZGM1ODcgMTAwNjQ0DQo+ID4gLS0tIGEvbW0v
enN3YXAuYw0KPiA+ICsrKyBiL21tL3pzd2FwLmMNCj4gPiBAQCAtODIsNiArODIsOSBAQCBzdGF0
aWMgYm9vbCB6c3dhcF9wb29sX3JlYWNoZWRfZnVsbDsNCj4gPg0KPiA+ICAjZGVmaW5lIFpTV0FQ
X1BBUkFNX1VOU0VUICIiDQo+ID4NCj4gPiArLyogTGltaXQgdGhlIGJhdGNoIHNpemUgdG8gbGlt
aXQgcGVyLUNQVSBtZW1vcnkgdXNhZ2UgZm9yIGRzdCBidWZmZXJzLiAqLw0KPiA+ICsjZGVmaW5l
IFpTV0FQX01BWF9CQVRDSF9TSVpFIDhVDQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IHpzd2FwX3Nl
dHVwKHZvaWQpOw0KPiA+DQo+ID4gIC8qIEVuYWJsZS9kaXNhYmxlIHpzd2FwICovDQo+ID4gQEAg
LTEzOSw3ICsxNDIsNyBAQCBzdHJ1Y3QgY3J5cHRvX2Fjb21wX2N0eCB7DQo+ID4gICAgICAgICBz
dHJ1Y3QgY3J5cHRvX2Fjb21wICphY29tcDsNCj4gPiAgICAgICAgIHN0cnVjdCBhY29tcF9yZXEg
KnJlcTsNCj4gPiAgICAgICAgIHN0cnVjdCBjcnlwdG9fd2FpdCB3YWl0Ow0KPiA+IC0gICAgICAg
dTggKmJ1ZmZlcjsNCj4gPiArICAgICAgIHU4ICoqYnVmZmVyczsNCj4gPiAgICAgICAgIHN0cnVj
dCBtdXRleCBtdXRleDsNCj4gPiAgICAgICAgIGJvb2wgaXNfc2xlZXBhYmxlOw0KPiA+ICB9Ow0K
PiA+IEBAIC0xNDksNiArMTUyLDkgQEAgc3RydWN0IGNyeXB0b19hY29tcF9jdHggew0KPiA+ICAg
KiBUaGUgb25seSBjYXNlIHdoZXJlIGxydV9sb2NrIGlzIG5vdCBhY3F1aXJlZCB3aGlsZSBob2xk
aW5nIHRyZWUubG9jayBpcw0KPiA+ICAgKiB3aGVuIGEgenN3YXBfZW50cnkgaXMgdGFrZW4gb2Zm
IHRoZSBscnUgZm9yIHdyaXRlYmFjaywgaW4gdGhhdCBjYXNlIGl0DQo+ID4gICAqIG5lZWRzIHRv
IGJlIHZlcmlmaWVkIHRoYXQgaXQncyBzdGlsbCB2YWxpZCBpbiB0aGUgdHJlZS4NCj4gPiArICoN
Cj4gPiArICogQGNvbXByX2JhdGNoX3NpemU6IFRoZSBtYXggYmF0Y2ggc2l6ZSBvZiB0aGUgY29t
cHJlc3Npb24gYWxnb3JpdGhtLA0KPiA+ICsgKiAgICAgICAgICAgICAgICAgICAgYm91bmRlZCBi
eSBaU1dBUF9NQVhfQkFUQ0hfU0laRS4NCj4gPiAgICovDQo+ID4gIHN0cnVjdCB6c3dhcF9wb29s
IHsNCj4gPiAgICAgICAgIHN0cnVjdCB6c19wb29sICp6c19wb29sOw0KPiA+IEBAIC0xNTgsNiAr
MTY0LDcgQEAgc3RydWN0IHpzd2FwX3Bvb2wgew0KPiA+ICAgICAgICAgc3RydWN0IHdvcmtfc3Ry
dWN0IHJlbGVhc2Vfd29yazsNCj4gPiAgICAgICAgIHN0cnVjdCBobGlzdF9ub2RlIG5vZGU7DQo+
ID4gICAgICAgICBjaGFyIHRmbV9uYW1lW0NSWVBUT19NQVhfQUxHX05BTUVdOw0KPiA+ICsgICAg
ICAgdTggY29tcHJfYmF0Y2hfc2l6ZTsNCj4gPiAgfTsNCj4gPg0KPiA+ICAvKiBHbG9iYWwgTFJV
IGxpc3RzIHNoYXJlZCBieSBhbGwgenN3YXAgcG9vbHMuICovDQo+ID4gQEAgLTE4Miw2ICsxODks
NyBAQCBzdGF0aWMgc3RydWN0IHNocmlua2VyICp6c3dhcF9zaHJpbmtlcjsNCj4gPiAgICogICAg
ICAgICAgICAgIHdyaXRlYmFjayBsb2dpYy4gVGhlIGVudHJ5IGlzIG9ubHkgcmVjbGFpbWVkIGJ5
IHRoZSB3cml0ZWJhY2sNCj4gPiAgICogICAgICAgICAgICAgIGxvZ2ljIGlmIHJlZmVyZW5jZWQg
aXMgdW5zZXQuIFNlZSBjb21tZW50cyBpbiB0aGUgc2hyaW5rZXINCj4gPiAgICogICAgICAgICAg
ICAgIHNlY3Rpb24gZm9yIGNvbnRleHQuDQo+ID4gKyAqIG5pZCAtIE5VTUEgbm9kZSBpZCBvZiB0
aGUgcGFnZSBmb3Igd2hpY2ggdGhpcyBpcyB0aGUgenN3YXAgZW50cnkuDQo+ID4gICAqIHBvb2wg
LSB0aGUgenN3YXBfcG9vbCB0aGUgZW50cnkncyBkYXRhIGlzIGluDQo+ID4gICAqIGhhbmRsZSAt
IHpzbWFsbG9jIGFsbG9jYXRpb24gaGFuZGxlIHRoYXQgc3RvcmVzIHRoZSBjb21wcmVzc2VkIHBh
Z2UgZGF0YQ0KPiA+ICAgKiBvYmpjZyAtIHRoZSBvYmpfY2dyb3VwIHRoYXQgdGhlIGNvbXByZXNz
ZWQgbWVtb3J5IGlzIGNoYXJnZWQgdG8NCj4gPiBAQCAtMTg5LDggKzE5NywxMSBAQCBzdGF0aWMg
c3RydWN0IHNocmlua2VyICp6c3dhcF9zaHJpbmtlcjsNCj4gPiAgICovDQo+ID4gIHN0cnVjdCB6
c3dhcF9lbnRyeSB7DQo+ID4gICAgICAgICBzd3BfZW50cnlfdCBzd3BlbnRyeTsNCj4gPiAtICAg
ICAgIHVuc2lnbmVkIGludCBsZW5ndGg7DQo+ID4gLSAgICAgICBib29sIHJlZmVyZW5jZWQ7DQo+
ID4gKyAgICAgICBzdHJ1Y3Qgew0KPiA+ICsgICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQgbGVu
Z3RoOjMxOw0KPiA+ICsgICAgICAgICAgICAgICBib29sIHJlZmVyZW5jZWQ6MTsNCj4gPiArICAg
ICAgIH07DQo+IA0KPiBNYXliZSBtYWtlIHRoZXNlIG1hY3JvLWRlZmluZWQgY29uc3RhbnRzPw0K
PiANCj4gQ29kZSBtb3N0bHkgTEdUTSBvdGhlcndpc2UuDQoNClRoYW5rcywgTmhhdCEgV2l0aCBy
ZXNwZWN0IHRvIHRoZSBzdWdnZXN0aW9uIHRvIG1ha2UgdGhlIGJpdC1maWVsZHMNCmFzIG1hY3Jv
LWRlZmluZWQgY29uc3RhbnRzLCBJIHdhcyBicm93c2luZyB0aHJvdWdoIGtlcm5lbCBoZWFkZXJz
DQp0aGF0IHVzZSBiaXQtZmllbGRzLCBhbmQgaXQgYXBwZWFycyB0aGUgY29udmVudGlvbiBpcyB0
byB1c2UgaW50ZWdlcnMNCnJhdGhlciB0aGFuIGNvbnN0YW50cy4NCg0KSSB0aGVuIHN0YXJ0ZWQg
YnJvd3NpbmcgbW0gY29kZSBhbmQgc2F3IHRoZSBzdHJ1Y3QgenNwYWdlIHsgLi4gfSBkZWZpbml0
aW9uDQppbiB6c21hbGxvYy5jIHRoYXQgdXNlcyBtYWNyby1kZWZpbmVkIGNvbnN0YW50cy4gQnV0
IHRoYXQgc2VlbXMgdG8gYmUNCnRoZSBleGNlcHRpb24uIHZtc2Nhbi5jIHVzZXMgaW50ZWdlciB2
YWx1ZWQgYml0LWZpZWxkcyBpbg0Kc3RydWN0IHNjYW5fY29udHJvbCB7IC4uIH0uIA0KDQpJZiB5
b3Ugd291bGQgc3RpbGwgbGlrZSB0aGUgYml0LWZpZWxkcyB0byBiZSBjb25zdGFudHMsIEkgYW0g
aGFwcHkgdG8gbWFrZQ0KdGhlIGNoYW5nZSBidXQganVzdCB3YW50ZWQgdG8gc2hhcmUgdGhlc2Ug
b2JzZXJ2YXRpb25zLg0KDQpUaGFua3MsDQpLYW5jaGFuYQ0KDQoNCg==
