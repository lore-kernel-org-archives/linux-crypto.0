Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4F3C0C;
	Wed, 27 Aug 2025 00:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253180; cv=fail; b=HDPTEbanbceF0K0ohtsbIcEqEYnL9OQ158r/rz/pBHYB3e1mH6TlcmJnXxOqU6916op1laVHGF+ipd0btiQHqlA9gUVadhIvkZ0RQxFC4KFkDfzV6Fnjj9/6kN9QT/VVFtHukAdPF/KBUIElM7yOoFw3HnTN10uAx/Evpxdafbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253180; c=relaxed/simple;
	bh=7vniUSzYM6r9LUSUyh32mGgAeoYpBnDp482f+tuHWJI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Iat5A+6HwbcFZgCwGTjLVmjTxKAXPXxlnJcyYla1QGOrdKDyWPwJxGt3XzFhRyDClcrClB6wYn6bI11SAkVkdOJvoEocA9pPMBC+uemiDV+jG7EU8YNfNRmx7fYv9a5Eed7WAc9cVB4jWM025zSM8hnwSg4srcj0JAGHL6j+oiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YsREuzCr; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YsREuzCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756253178; x=1787789178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7vniUSzYM6r9LUSUyh32mGgAeoYpBnDp482f+tuHWJI=;
  b=YsREuzCrrQHZQ9dN0dob7lP6fRoSXzOEbqbk7n8yKFWZmacm4UzhZqGn
   JRQGGfmTrm10CPQ4yFSEFK8gN9ve+e2aowc3vo0KwAONLYsyRsDbe+qKg
   VAJyricNUpLbtTiz52q6sRuBTR5+oIpk5GAASBjMcTU+jDCx2WUhmExkW
   Jop+zyR34ac/h0MdKAuHbeaM1zGGD2Yd9qC355kAgp2oX5YWFUNAxuFHZ
   fGCa3UMR3dCBPhXaVRqbVzACHgVVf2l+sblN6Dc3t6IZAvZPZPVag5ca1
   EPmxoaZBKbJZy0F71RDimwVxnvFRpb0Wg4BaWtDbXYJnRPncNKkhtmAjD
   g==;
X-CSE-ConnectionGUID: tuKQo4h1TFObnXvNB0y66A==
X-CSE-MsgGUID: tvnrG6XbQsqxyv/R4n5zqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58420961"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58420961"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 17:06:18 -0700
X-CSE-ConnectionGUID: 8EduoxiuTr+ZEN2TkIG9Dg==
X-CSE-MsgGUID: vXW4ywd1SQyXGMdV3U2fUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="170532513"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 17:06:18 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 17:06:17 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 17:06:17 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.52)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 17:06:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ILy4hA2ZrovbEli6+egX6JWQH0IHZ4z91wI9L7C0+lllOrDtBlp1lEVL203LJ1IkQLhyS+Sv3PdNC77SvzZXKkQyCNCchV+KNT693gmGiDjT0BVw1UQujXwGxzq/WdPj8vkmKSN7iEMJuYd9uGMyPaX2xHKPRHJZ1s56Qw08m27iupcTr1QlMmTlagzgdcgB9d4x/w5L81TfOyQTv9r1YixBy5PJl0ZpZng/5pDeQr7fF7aeNanz/RnZ6CG8vSGgMH4x7TdTllImyR+r684a1jJQAqu28MsBzQBV674koZrrwarjPXxALVnAGmLbh+PRcX13fXLyslMstE6uBt/cLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vniUSzYM6r9LUSUyh32mGgAeoYpBnDp482f+tuHWJI=;
 b=oAkBluE+UL8HWdvCxNUdxhe1BgXW3azwru+xXZ19KpiF9kqVYTIjbpM/Y9WZpqt8jzsdALsl9lGrawYyGhbRQUFaD4OYP2arJiyvuDPm4wmF9vG6NE6zbw8DQgoQTCJbeo+/B5ZzM2cLWI9Yq474y1s7OepCWSctY3LBG3kKM4GOj5/2ErPDmPEQvsZD1mksRCfUD6xLyxpXz7CBjZJw6aajXv+jq7PmL5Jf4oG1mzC2lQt8rghrnTqcmiqmDd4igyolDpRsLt20YHbah0NgGK11oMwWolWpvmYMHRfP0y9tNMToTrp7A6wqzOZedeODPQmEZXhKhi+M+8+Ag6wLzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DS7PR11MB9476.namprd11.prod.outlook.com (2603:10b6:8:266::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 27 Aug
 2025 00:06:15 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 00:06:15 +0000
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
Thread-Index: AQHcAp3rCQGkKHFe602Ahq9v7LnzVLR0czwAgAAISGCAAAbQgIAAAQVggAAI1wCAATLsYA==
Date: Wed, 27 Aug 2025 00:06:15 +0000
Message-ID: <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DS7PR11MB9476:EE_
x-ms-office365-filtering-correlation-id: 66b94adb-6ee6-4b96-c47a-08dde4fd8a59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?amNiWGhFSkpObVBCTlFBS1ErMXd2S3phQlN2U1FjNVd0aFErdkhZdE1hN2Vo?=
 =?utf-8?B?TVU0V1pKb2w4QmordWlHaFByWi9HaEEwbzBadXBXMnNIb01ieU1tWUpFWXNn?=
 =?utf-8?B?S1locGpHR3pMMm5tMnhTOGN6N25ZeW5iQzFlc3oyUVJ5dGNYZjVmMUJCOE52?=
 =?utf-8?B?UUIwZjhrYkdmbDBoYUNiQzhpVVVXMDF1cDVtbXlMd0lOZTZKbi9rRU5WUm1r?=
 =?utf-8?B?YXFsVnBnQldkY3lMUk1RVjRaSzdtKzVqcVZiNWhnbHRUM21oazhHSS91eHF1?=
 =?utf-8?B?NlRzS0h4QXd2N3ZPa3hVOFExakpuaDloYm1KTzYrVkVPTDdtdTJQWEErWkYr?=
 =?utf-8?B?YlJRSFI5ZWhDVWRXbUgxM0JzMGR4aGxBZnZTK1NTbTJJbmI3OGFiNGkvdStJ?=
 =?utf-8?B?dTZYUnVCT1h4R01KdWRvSE0wRk5OSXNGNERZcy9pMXI3UG45bmJpUTIxeG9l?=
 =?utf-8?B?ZmJteWUwaHpWY1BSVkRTQktxdEZDZkF0cmVuQVN5T3BIaXhCemdkazUrN3Bj?=
 =?utf-8?B?UVdmeCtBNCtMK2wxNnZwZlFIRkgxR2ZlUGUxVGMrRUdDWXJVdlVGOU15emdK?=
 =?utf-8?B?UytuYmVUQlRGVi9WT3BWRlhDTjZieFk2c1Fpa3M5S3JicDhsZ2VmWERvQ0lL?=
 =?utf-8?B?WFMxRm5ISUlLZEM2UTdncVFKZzREZk90ekJsVWZjVzgwOElheG1kTndROFFt?=
 =?utf-8?B?S29MVU9qTlp1cGt4LzF3elorWkZsd3pqUlFzRnRSZnBiOE4zVThKdlRXVjVH?=
 =?utf-8?B?LzVQUXVQL1diSTlSRG54RGFDOGgxTEZJNHBHWTBYV0tIZWk0OHZCbEdmaFZt?=
 =?utf-8?B?aEtIbEg1WkxWSkNmRWw3QWRyOTN1em1na2Z6OTdFQWgvL3ptU08xclpvdDBX?=
 =?utf-8?B?b1hYOHFUTkxPWWQ3eTRjWWJRNzJDak5pbzFmM2lnZWRINUdncnpIRXQ3dGI3?=
 =?utf-8?B?NERJcnRZOS9Hb053VTBYbTZTSi9YK1R6UENGOVc0YitldE5aeWJhTVdYdnVt?=
 =?utf-8?B?MlY3RWFtMFovU3RDbXlUb1I4TlhaempHNGhmVzBRNUcyZTRWcFdYUlJMNlpE?=
 =?utf-8?B?QjNySWFZVDJzUGtHWFNHZ0lVbnJPNCttZ1FIMnh6blpMRGNINkRHM3Z0U2Vm?=
 =?utf-8?B?bVBpT3o3MUpPM05RdlBsZFBNNityYXNxbDZMc1VYUWFndE5icGc3THVja2Ex?=
 =?utf-8?B?RHRRWGprWnlUL1pOVDkydUlETlgrYmd1YXFVSFRiL2tVWFZpekxpZ3RjaExa?=
 =?utf-8?B?OFJ2RzdRK21Gb0dBZEM3WGUrYm1haW8xbUZISWkxMWViNjczazRYRk5vUzNk?=
 =?utf-8?B?K3hhRmVRelBXVVBIUXN2bVBPa0N4Tm9kNTM2MG1pdlI1eEo4N2c0a3Jqb2hX?=
 =?utf-8?B?aFAvVTVqVU9DQXVQbnFPNWNnVVN3Zjg1VHU2N0sxQXBoM3dLUWRhOFNUdkJD?=
 =?utf-8?B?bWE2dEZpTlE0ZXF5dEhCWkZaM1FOYWhMb25CZ3grYTdkcWtvNDRaeS9USXFt?=
 =?utf-8?B?UFlOaUJhS2VtS083OTdFbHZnWXhPRzNzR3YzNVdqOFJoRHVTZUJyRmRDL2N3?=
 =?utf-8?B?S1JlN1hZRE5EazhFSnQya3JFNXhqd2lwZ0xGcjVpNUJvcHYwd1NWZ21USlpa?=
 =?utf-8?B?UEp3eEdpRHp4VVZHQjduMU9SQlF2ckorcjFzUjh6MGUrSmJLSFFhakVINkR0?=
 =?utf-8?B?T3R1U2FXeWIxQ0VtVzNFdHZ1cEdjQTkyQ0ZCUWl6RE1YTEhBRE1JUXRRc01O?=
 =?utf-8?B?YnNIbTlFUW1JakRyc3ptWUZJMEZXQTFrdjdWZXZFZkRwQUsrUEdTMzFhM1BI?=
 =?utf-8?B?U2RqN0hBT2dPWUlUNGVpc0ZqUW04Q3k3djdwSDZrVytMSDBQUUd3UTVyaGJ3?=
 =?utf-8?B?Y1loWDltbWMxNHFORnJmWURBYVk1NUkxRFYzUkZZVWhzNnpBdFpteWlROXMz?=
 =?utf-8?B?aTJqeE41S3dWbDhtMWN6YlY5NGdrbm8rTldhRlJLM1ZaMTlZMnNxNTdubXNw?=
 =?utf-8?B?TENZQmIyb09RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUJMaUV1RmcrMXg5N3lITVRSQXZJVU5hOC93bU8yZURWSTgyYlFDZER3Ti91?=
 =?utf-8?B?TVpsZUVRY1BMMDZGTFJQakhEVzg0Y2szd3dWRVNvWG5sR0ZiTFpLV2VuaXJD?=
 =?utf-8?B?cGhXSTZSS0RSd2VYL3FKMU4zc0UzREdqblBiRWVQcDVhbnhjdi9PRXBQUUlD?=
 =?utf-8?B?UlRlK21HK0JnY0VBNlp1SkNYK0xiTWVrVEpNVWdCeDZra2doQnhNaFFDeDJO?=
 =?utf-8?B?eC9oSDkwNzVMc2JVM1hraVByMnVFK2ZlUFlIRjZDemN6L0s4QXBJOFZyVWVY?=
 =?utf-8?B?bGd0Uncyc2wwM09lcFNFNjVXOUZZTU0wVmI0VjdaSzNwR2R0M3BMeXVNS1VQ?=
 =?utf-8?B?SjlYQ1RLblZoRGVQRGJldklZTFpKTDg1UklqL3pmWkZvdWVWQ3l0blJGVDZP?=
 =?utf-8?B?M3NJNlBmYTJjeTZIZHl4U0xlVkhEbm5UbnVoRmQyZEVjcnlTVDBOVmMxZmdj?=
 =?utf-8?B?M05ZOVdFc09CT3k4VjAyM2dzVFAzemxSbXYyQXc4R0t5dm5ZM3RXclpFWHY5?=
 =?utf-8?B?am9CbXB3SjYxajBLZTQ2RlhjVXNIV0tJK3EwQys2eDR4d1dUcXlzT0I0L0xv?=
 =?utf-8?B?QmNSR1plRllWb0h4RTQvN2tnWGJGZDVyb3FnWW53UFl3WW1BR3JDazNVYlFU?=
 =?utf-8?B?dXU4OXE2WE1Ick42eXZWdWpoZHMxLzBiTFJDTjA1eG5PL0psb3Q3K3pOeUVV?=
 =?utf-8?B?alNLdGRCTC9qeXJDc3NPUHppck8xdzhycVRsbGRzMlh4NmF1dkxTZ2RBZXpL?=
 =?utf-8?B?Uytwcnd3QmZjNGFPaGxZcGdxemhsNUQ0VXZzY0FrRFo5UWc3cDI5NkMrRWtx?=
 =?utf-8?B?dXZYNm8vYkgzYkpIazFoSE5yckhpaXhsSXgxekpvZDZMU2hOV3RxOEkvdTJI?=
 =?utf-8?B?RjNWYXFIczloYmMyOVp0amhPT1hBeEU4ZGpKTysrMEJrS2xxVEFDV0dMYmFN?=
 =?utf-8?B?M2wwUEVLNml6N1U3Y3N0czBkWHVwVkVsWWtJNmpXbnJEalIydHNvbHJaNDNC?=
 =?utf-8?B?bU5KQXNrQVBMYlNMc2MwNXI0NmIwZC91OHlnL2JpSHlzNjl0TG5ncC9NeUJ4?=
 =?utf-8?B?K0d2cVpWTGJ1YW5BTTVheWtObkJ4cG9kY3g4YlFFRE43akZKeHlwOVNuTS9K?=
 =?utf-8?B?dlNvcjYxZkVrV1JGa0JIQjJwcEVtdUZvQjEwTldhVWEvcW9MSmVmc05ZUDNY?=
 =?utf-8?B?eUlwbTRJdlI4ZEh5RmRGQ3V4bGp3NjJwNit0dWl3WjFsRzFaQTN1TXpVaGl2?=
 =?utf-8?B?V3hKNkVNMjI4VGZsUFFLV3ozSUEzNnAwelRwTXcwVFUwcEJPNXhuMERyWVpq?=
 =?utf-8?B?SEIweFdmSVVLUjkxT0tFY1B4WEdQMjErbTljSXJsNlBDTlptSzZoOTNJZ2ZV?=
 =?utf-8?B?c2IyYkNkeW9pWGpBeUs4T056L2ZZeEsycGRaY1pRbExrL1JzM2ppanJ4SjRN?=
 =?utf-8?B?ME1HY09Zb0tyWEs0clRia01LKzlJWnNkdmp4Y1hpc1ppbG1YU2lWTnp5SC8z?=
 =?utf-8?B?QWowRUFVelFsL0ozQkFBOUNmMkEzaXczWitEdVJreXY2UWxGeWFyZFVwKzlB?=
 =?utf-8?B?Q09Da0grbXVjbEFDUFAzbFVIbEs2SzNqNlRDeDkvd2xuUXdtbTR4WnBwWURF?=
 =?utf-8?B?VUQwT0I1RWx5bzNWbHlhZmF4aGJDOHRiRW81d0hRMDRoNzBuYnFVdTdEbk5w?=
 =?utf-8?B?V1dITndWeE9XZnNkSnA3bXhXMkh4TmJ2RE5MNFFueE90THQ2VE4zbE5wc2FG?=
 =?utf-8?B?L0JtUUxkVEhlNHBLcnBrZzQrbGZBTmRwdzc0TU1oeThzeVJqdDB3RjNyUkxH?=
 =?utf-8?B?YjdzZHlnbW1HZWhkODhSVTF1QkRsR3Y3TWRDMm1sZ2RUN1ZFaUkwenhHZzN5?=
 =?utf-8?B?Vjk0VFB0V3Jkbkc3c2hzUFUwVEZtZVB4ZHRhczlSNG8ycGFISlhXQ2taSGpx?=
 =?utf-8?B?eGpLZHNLaU9NaEo3VDZUTC85ZU9FNlFtVjZkc3JmZnZLbWw4ZDVRWEhhdHZx?=
 =?utf-8?B?ekdGUjFDUDNzUk9rTnlZZGR6L1ZXQnNzNHNaS1I3SnpFT2w3TnlUbmZ1Tkhj?=
 =?utf-8?B?OWp4dzZTL3JwQkdrOUFMZXhENnUxbU5DWVcwUnlQRXpkOHRWVU4vS1B1eEEv?=
 =?utf-8?B?RGs0d0Y1RHduNUxncDJ3VkRTOCtubk9vbnlhb2szZ21xNlZ1TVY5T01HUjF6?=
 =?utf-8?B?akE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b94adb-6ee6-4b96-c47a-08dde4fd8a59
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2025 00:06:15.5427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++TAuDkiB0vKMZPar/qfXLPuhMTikY1bdwjsho94zkp+Gr57HvSXjT1/DTfYYLzAAvRtQD4qTuQ3/rg2vJmL5Uo95XiHZXlhFGgzna5/3zI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9476
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAyNSwgMjAyNSAxMDoxNyBQTQ0K
PiBUbzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4N
Cj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsN
Cj4gaGFubmVzQGNtcHhjaGcub3JnOyB5b3NyeS5haG1lZEBsaW51eC5kZXY7IG5waGFtY3NAZ21h
aWwuY29tOw0KPiBjaGVuZ21pbmcuemhvdUBsaW51eC5kZXY7IHVzYW1hYXJpZjY0MkBnbWFpbC5j
b207DQo+IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyB5aW5nLmh1YW5nQGxpbnV4LmFsaWJhYmEuY29t
OyBha3BtQGxpbnV4LQ0KPiBmb3VuZGF0aW9uLm9yZzsgc2Vub3poYXRza3lAY2hyb21pdW0ub3Jn
OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOw0KPiBoZXJiZXJ0QGdvbmRvci5hcGFuYS5v
cmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGNsYWJiZUBiYXlsaWJyZS5jb207IGFyZGJA
a2VybmVsLm9yZzsgZWJpZ2dlcnNAZ29vZ2xlLmNvbTsNCj4gc3VyZW5iQGdvb2dsZS5jb207IEFj
Y2FyZGksIEtyaXN0ZW4gQyA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsNCj4gR29tZXMs
IFZpbmljaXVzIDx2aW5pY2l1cy5nb21lc0BpbnRlbC5jb20+OyBGZWdoYWxpLCBXYWpkaSBLDQo+
IDx3YWpkaS5rLmZlZ2hhbGlAaW50ZWwuY29tPjsgR29wYWwsIFZpbm9kaCA8dmlub2RoLmdvcGFs
QGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTEgMjIvMjRdIG1tOiB6c3dhcDog
QWxsb2NhdGUgcG9vbCBiYXRjaGluZyByZXNvdXJjZXMNCj4gaWYgdGhlIGNvbXByZXNzb3Igc3Vw
cG9ydHMgYmF0Y2hpbmcuDQo+IA0KPiA+ID4gPiA+IFsuLi5dDQo+ID4gPiA+ID4gPg0KPiA+ID4g
PiA+ID4gKyAgICAgICAvKg0KPiA+ID4gPiA+ID4gKyAgICAgICAgKiBTZXQgdGhlIHVuaXQgb2Yg
Y29tcHJlc3MgYmF0Y2hpbmcgZm9yIGxhcmdlIGZvbGlvcywgZm9yIHF1aWNrDQo+ID4gPiA+ID4g
PiArICAgICAgICAqIHJldHJpZXZhbCBpbiB0aGUgenN3YXBfY29tcHJlc3MoKSBmYXN0IHBhdGg6
DQo+ID4gPiA+ID4gPiArICAgICAgICAqIElmIHRoZSBjb21wcmVzc29yIGlzIHNlcXVlbnRpYWwg
KEBwb29sLT5jb21wcl9iYXRjaF9zaXplIGlzDQo+IDEpLA0KPiA+ID4gPiA+ID4gKyAgICAgICAg
KiBsYXJnZSBmb2xpb3Mgd2lsbCBiZSBjb21wcmVzc2VkIGluIGJhdGNoZXMgb2YNCj4gPiA+ID4g
PiBaU1dBUF9NQVhfQkFUQ0hfU0laRQ0KPiA+ID4gPiA+ID4gKyAgICAgICAgKiBwYWdlcywgd2hl
cmUgZWFjaCBwYWdlIGluIHRoZSBiYXRjaCBpcyBjb21wcmVzc2VkDQo+IHNlcXVlbnRpYWxseS4N
Cj4gPiA+ID4gPiA+ICsgICAgICAgICogV2Ugc2VlIGJldHRlciBwZXJmb3JtYW5jZSBieSBwcm9j
ZXNzaW5nIHRoZSBmb2xpbyBpbiBiYXRjaGVzDQo+IG9mDQo+ID4gPiA+ID4gPiArICAgICAgICAq
IFpTV0FQX01BWF9CQVRDSF9TSVpFLCBkdWUgdG8gY2FjaGUgbG9jYWxpdHkgb2Ygd29ya2luZw0K
PiBzZXQNCj4gPiA+ID4gPiA+ICsgICAgICAgICogc3RydWN0dXJlcy4NCj4gPiA+ID4gPiA+ICsg
ICAgICAgICovDQo+ID4gPiA+ID4gPiArICAgICAgIHBvb2wtPmJhdGNoX3NpemUgPSAocG9vbC0+
Y29tcHJfYmF0Y2hfc2l6ZSA+IDEpID8NCj4gPiA+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSA6DQo+IFpTV0FQX01BWF9CQVRDSF9T
SVpFOw0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gICAgICAgICB6c3dhcF9wb29sX2RlYnVn
KCJjcmVhdGVkIiwgcG9vbCk7DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gICAgICAgICByZXR1
cm4gcG9vbDsNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJdOKAmXMgaGFyZCB0
byBmb2xsb3cg4oCUIHlvdSBhZGQgYmF0Y2hfc2l6ZSBhbmQgY29tcHJfYmF0Y2hfc2l6ZSBpbiB0
aGlzDQo+ID4gPiA+ID4gcGF0Y2gsIGJ1dCBvbmx5IHVzZSB0aGVtIGluIGFub3RoZXIuIENvdWxk
IHdlIG1lcmdlIHRoZSByZWxhdGVkDQo+IGNoYW5nZXMNCj4gPiA+ID4gPiBpbnRvIG9uZSBwYXRj
aCBpbnN0ZWFkIG9mIHNwbGl0dGluZyB0aGVtIGludG8gc2V2ZXJhbCB0aGF0IGRvbuKAmXQgd29y
aw0KPiA+ID4gPiA+IGluZGVwZW5kZW50bHk/DQo+ID4gPiA+DQo+ID4gPiA+IEhpIEJhcnJ5LA0K
PiA+ID4gPg0KPiA+ID4gPiBUaGFua3MgZm9yIHJldmlld2luZyB0aGUgY29kZSBhbmQgZm9yIHlv
dXIgY29tbWVudHMhIFN1cmUsIEkgY2FuIG1lcmdlDQo+ID4gPiA+IHRoaXMgcGF0Y2ggd2l0aCB0
aGUgbmV4dCBvbmUuIEkgd2FzIHRyeWluZyB0byBrZWVwIHRoZSBjaGFuZ2VzDQo+IG1vZHVsYXJp
emVkDQo+ID4gPiA+IHRvIGEpIHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKSwgYikgenN3YXBfc3Rv
cmUoKSBhbmQgYykNCj4gPiA+IHpzd2FwX2NvbXByZXNzKCkNCj4gPiA+ID4gc28gdGhlIGNoYW5n
ZXMgYXJlIGJyb2tlbiBpbnRvIHNtYWxsZXIgcGFydHMsIGJ1dCBJIGNhbiBzZWUgaG93IHRoaXMg
Y2FuDQo+ID4gPiA+IG1ha2UgdGhlIGNoYW5nZXMgYXBwZWFyIGRpc2pvaW50ZWQuDQo+ID4gPiA+
DQo+ID4gPiA+IE9uZSB0aGluZyB0aG91Z2g6IHRoZSBjb21taXQgbG9ncyBmb3IgZWFjaCBvZiB0
aGUgcGF0Y2hlcyB3aWxsDQo+ID4gPiA+IGFsc28gcHJvYmFibHkgbmVlZCB0byBiZSBtZXJnZWQs
IHNpbmNlIEkgaGF2ZSB0cmllZCB0byBleHBsYWluIHRoZQ0KPiA+ID4gPiBjaGFuZ2VzIGluIGRl
dGFpbC4NCj4gPiA+DQo+ID4gPiBJdOKAmXMgZmluZSB0byBtZXJnZSB0aGUgY2hhbmdlbG9nIGFu
ZCBwcmVzZW50IHRoZSBzdG9yeSBhcyBhIHdob2xlLiBEbyB3ZQ0KPiA+DQo+ID4gU3VyZS4NCj4g
Pg0KPiA+ID4gcmVhbGx5IG5lZWQgYm90aCBwb29sLT5iYXRjaF9zaXplIGFuZCBwb29sLT5jb21w
cl9iYXRjaF9zaXplPyBJIGFzc3VtZQ0KPiA+ID4gcG9vbC0+YmF0Y2hfc2l6ZSA9IHBvb2wtPmNv
bXByX2JhdGNoX3NpemUgaWYgSFcgc3VwcG9ydHMgYmF0Y2g7DQo+IG90aGVyd2lzZQ0KPiA+ID4g
cG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSA9IDEuDQo+ID4NCj4gPiBBY3R1YWxseSBub3QgZXhhY3Rs
eS4gV2UgaGF2ZSBmb3VuZCB2YWx1ZSBpbiBjb21wcmVzc2luZyBpbiBiYXRjaGVzIG9mDQo+ID4g
WlNXQVBfTUFYX0JBVENIX1NJWkUgZXZlbiBmb3Igc29mdHdhcmUgY29tcHJlc3NvcnMuIExhdGVu
Y3kgYmVuZWZpdHMNCj4gPiBmcm9tIGNhY2hlIGxvY2FsaXR5IG9mIHdvcmtpbmctc2V0IGRhdGEu
IEhlbmNlIHRoZSBhcHByb2FjaCB0aGF0IHdlIGhhdmUNCj4gPiBzZXR0bGVkIG9uIGlzIHBvb2wt
PmJhdGNoX3NpemUgPSBaU1dBUF9NQVhfQkFUQ0hfU0laRSBpZg0KPiA+IHRoZSBjb21wcmVzc29y
IGRvZXMgbm90IHN1cHBvcnQgYmF0Y2hpbmcgKGkuZS4sIGlmIHBvb2wtPmNvbXByX2JhdGNoX3Np
emUgaXMNCj4gMSkuDQo+ID4gSWYgaXQgZG9lcywgdGhlbiBwb29sLT5iYXRjaF9zaXplID0gcG9v
bC0+Y29tcHJfYmF0Y2hfc2l6ZS4NCj4gDQo+IEkgdW5kZXJzdGFuZCB0aGF0IGV2ZW4gd2l0aG91
dCBhIGhhcmR3YXJlIGJhdGNoLCB5b3UgY2FuIHN0aWxsDQo+IGhhdmUgc29tZSBzb2Z0d2FyZSBi
YXRjaGluZyB0aGF0IGV4Y2x1ZGVzIGNvbXByZXNzaW9uLg0KPiANCj4gSG93ZXZlciwgYmFzZWQg
b24gdGhlIGNvZGUgYmVsb3csIGl0IGxvb2tzIGxpa2UNCj4gcG9vbC0+Y29tcHJfYmF0Y2hfc2l6
ZSBpcyBhbG1vc3QgYWx3YXlzIGVpdGhlciBlcXVhbCB0bw0KPiBwb29sLT5iYXRjaF9zaXplIG9y
IDE6DQo+IA0KPiArICAgICAgIHBvb2wtPmNvbXByX2JhdGNoX3NpemUgPSBtaW4oWlNXQVBfTUFY
X0JBVENIX1NJWkUsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjcnlw
dG9fYWNvbXBfYmF0Y2hfc2l6ZShhY29tcF9jdHgtPmFjb21wKSk7DQoNCkkgd291bGQgbGlrZSB0
byBleHBsYWluIHNvbWUgb2YgdGhlIGNvbnNpZGVyYXRpb25zIGluIGNvbWluZyB1cCB3aXRoIHRo
aXMNCmFwcHJvYWNoOg0KDQoxKSBUaGUgY29tcHJlc3Npb24gYWxnb3JpdGhtIGdldHMgdG8gZGVj
aWRlIGFuIG9wdGltYWwgYmF0Y2gtc2l6ZS4NCiAgICBGb3IgYSBoYXJkd2FyZSBhY2NlbGVyYXRv
ciBzdWNoIGFzIElBQSwgdGhpcyB2YWx1ZSBjb3VsZCBiZSBkaWZmZXJlbnQNCiAgICB0aGFuIFpT
V0FQX01BWF9CQVRDSF9TSVpFLg0KDQoyKSBaU1dBUF9NQVhfQkFUQ0hfU0laRSBhY3RzIGFzIGEg
bGltaXRpbmcgZmFjdG9yIHRvIHRoZSAjIG9mIGFjb21wX2N0eA0KICAgIHBlci1DUFUgcmVzb3Vy
Y2VzIHRoYXQgd2lsbCBiZSBhbGxvY2F0ZWQgaW4genN3YXBfY3B1X2NvbXBfcHJlcGFyZSgpOw0K
ICAgIGFzIHBlciBZb3NyeSdzIHN1Z2dlc3Rpb24uIFRoaXMgaGVscHMgbGltaXQgdGhlIG1lbW9y
eSBvdmVyaGVhZCBmb3INCiAgICBiYXRjaGluZyBhbGdvcml0aG1zLg0KDQozKSBJZiBhIGJhdGNo
aW5nIGFsZ29yaXRobSB3b3JrcyB3aXRoIGEgYmF0Y2ggc2l6ZSAiWCIgLCB3aGVyZQ0KICAgICAx
IDwgWCA8IFpTV0FQX01BWF9CQVRDSF9TSVpFLCB0d28gdGhpbmdzIG5lZWQgdG8gaGFwcGVuOg0K
ICAgICBhKSBXZSB3YW50IHRvIG9ubHkgYWxsb2NhdGUgIlgiIHBlci1DUFUgcmVzb3VyY2VzLg0K
ICAgICBiKSBXZSB3YW50IHRvIHByb2Nlc3MgdGhlIGZvbGlvIGluIGJhdGNoZXMgb2YgIlgiLCBu
b3QgWlNXQVBfTUFYX0JBVENIX1NJWkUNCiAgICAgICAgICB0byBhdmFpbCBvZiB0aGUgYmVuZWZp
dHMgb2YgaGFyZHdhcmUgcGFyYWxsZWxpc20uIFRoaXMgaXMgdGhlIGNvbXByZXNzaW9uDQogICAg
ICAgICAgc3RlcCBzaXplIHlvdSBhbHNvIG1lbnRpb24uDQogICAgICAgICAgSW4gcGFydGljdWxh
ciwgd2UgY2Fubm90IHRyZWF0IGJhdGNoX3NpemUgYXMgWlNXQVBfTUFYX0JBVENIX1NJWkUsDQog
ICAgICAgICAgYW5kIHNlbmQgYSBiYXRjaCBvZiBaU1dBUF9NQVhfQkFUQ0hfU0laRSBwYWdlcyB0
byB6c3dhcF9jb21wcmVzcygpDQogICAgICAgICAgaW4gdGhpcyBjYXNlLiBGb3IgZS5nLiwgd2hh
dCBpZiB0aGUgY29tcHJlc3Mgc3RlcC1zaXplIGlzIDYsIGJ1dCB0aGUgbmV3DQogICAgICAgICAg
enN3YXBfc3RvcmVfcGFnZXMoKSBpbnRyb2R1Y2VkIGluIHBhdGNoIDIzIHNlbmRzIDggcGFnZXMg
dG8NCiAgICAgICAgICB6c3dhcF9jb21wcmVzcygpIGJlY2F1c2UgWlNXQVBfTUFYX0JBVENIX1NJ
WkUgaXMgc2V0IHRvIDg/DQogICAgICAgICAgVGhlIGNvZGUgaW4genN3YXBfY29tcHJlc3MoKSBj
b3VsZCBnZXQgcXVpdGUgbWVzc3ksIHdoaWNoIHdpbGwgaW1wYWN0DQogICAgICAgICAgbGF0ZW5j
eS4NCiAgICAgICAgDQoNCj4gDQo+ICsgICAgICAgcG9vbC0+YmF0Y2hfc2l6ZSA9IChwb29sLT5j
b21wcl9iYXRjaF9zaXplID4gMSkgPw0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHBvb2wtPmNvbXByX2JhdGNoX3NpemUgOiBaU1dBUF9NQVhfQkFUQ0hfU0laRTsNCj4gDQo+IA0K
PiBJdCBzZWVtcyBvbmUgb2YgdGhlc2UgdHdvIHZhcmlhYmxlcyBtYXkgYmUgcmVkdW5kYW50Lg0K
PiBGb3IgaW5zdGFuY2UsIG5vIG1hdHRlciBpZiBwb29sLT5jb21wcl9iYXRjaF9zaXplID4gMSwg
Y291bGQgd2UgYWx3YXlzIHRyZWF0DQo+IGJhdGNoX3NpemUgYXMgWlNXQVBfTUFYX0JBVENIX1NJ
WkU/ICBpZiB3ZSByZW1vdmUNCj4gcG9vbC0+YmF0Y2hfc2l6ZSwgY291bGQgd2UganVzdCB1c2Ug
cG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSBhcyB0aGUNCj4gc3RlcCBzaXplIGZvciBjb21wcmVzc2lv
biBubyBtYXR0ZXIgaWYgcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSA+IDEuDQoNClRvIGZ1cnRoZXIg
ZXhwbGFpbiB0aGUgcmF0aW9uYWxlIGZvciBrZWVwaW5nIHRoZXNlIHR3byBkaXN0aW5jdCwgd2UN
CnN0YXRpY2FsbHkgY29tcHV0ZSB0aGUgY29tcHJlc3Mgc3RlcC1zaXplIGJ5IHF1ZXJ5aW5nIHRo
ZSBhbGdvcml0aG0NCmluIHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKSBhZnRlciB0aGUgYWNvbXBf
Y3R4LT5hY29tcCBoYXMgYmVlbg0KY3JlYXRlZC4gV2Ugc3RvcmUgaXQgaW4gcG9vbC0+Y29tcHJf
YmF0Y2hfc2l6ZS4NCg0KTmV4dCwgaW4genN3YXBfcG9vbF9jcmVhdGUoKSwgd2UgZG8gYSBvbmUt
dGltZSBjb21wdXRhdGlvbiB0byBkZXRlcm1pbmUNCmlmIHRoZSBwb29sLT5iYXRjaF9zaXplIG5l
ZWRzIHRvIGFsaWduIHdpdGggYSBub24tMSBiYXRjaGluZyBhY29tcCdzDQpjb21wcl9iYXRjaF9z
aXplOyBvciwgaWYgaXQgaXMgYSBub24tYmF0Y2hpbmcgY29tcHJlc3NvciwgZm9yIHRoZQ0KcG9v
bC0+YmF0Y2hfc2l6ZSB0byBiZSBaU1dBUF9NQVhfQkFUQ0hfU0laRS4NCg0KVGhpcyBlbmFibGVz
IGZ1cnRoZXIgY29kZSBzaW1wbGlmaWNhdGlvbnMvdW5pZmljYXRpb24gaW4genN3YXBfY29tcHJl
c3MoKTsNCmFuZCBxdWljayByZXRyaWV2YWwgb2YgdGhlICMgb2YgYXZhaWxhYmxlIGFjb21wX2N0
eCBiYXRjaGluZyByZXNvdXJjZXMgdG8NCnNldCB1cCB0aGUgU0cgbGlzdHMgcGVyIGNhbGwgdG8g
Y3J5cHRvX2Fjb21wX2NvbXByZXNzKCkuIElPVywgbWVtby1pemF0aW9uDQpmb3IgbGF0ZW5jeSBn
YWlucyBhbmQgdW5pZmllZCBjb2RlIHBhdGhzLg0KDQpJIGhvcGUgdGhpcyBjbGFyaWZpZXMgdGhp
bmdzIGZ1cnRoZXIuIFRoYW5rcyBhZ2FpbiwgdGhlc2UgYXJlIGFsbCBnb29kIHF1ZXN0aW9ucy4N
Cg0KQmVzdCByZWdhcmRzLA0KS2FuY2hhbmENCg0KPiANCj4gZm9yIGV4YW1wbGU6DQo+ICAgICAg
ICBwb29sLT5jb21wcl9iYXRjaF9zaXplID0gbWluKFpTV0FQX01BWF9CQVRDSF9TSVpFLA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjcnlwdG9fYWNvbXBfYmF0Y2hfc2l6
ZShhY29tcF9jdHgtPmFjb21wKSk7DQo+IA0KPiBUaGVuIGJhdGNoIHRoZSB6c3dhcCBzdG9yZSB1
c2luZyBaU1dBUF9NQVhfQkFUQ0hfU0laRSwgYnV0IHNldCB0aGUNCj4gY29tcHJlc3Npb24gc3Rl
cCB0byBwb29sLT5jb21wcl9iYXRjaF9zaXplLg0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=
