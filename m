Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8715473477;
	Thu,  6 Jun 2024 08:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717662873; cv=fail; b=Kn21X8nFrN3JY4cvLRkenvPOdwuHDZpSqS4Z5+Zg5ZN1aNSwon4V8JRYlKsOBhTC+MXy0MAruCQMW9bIzuGyT6MAxNfsitbWRE+iII8I6n9s/+3CTqOU2oAUB5eIWDwOL5U2ZU5U87RxOxDhbvb32r+IWSTJua2kIGBnhOF9gvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717662873; c=relaxed/simple;
	bh=SDrB2PLLzIOEcKTeF44REN1xiInhsZyKEW2TTP1osWs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Aa+tJf0ExAMTpSd8iFhEbCA0pQPQ86I5YPBeZqzPuAtN1VypjJMSqjBqK6elhUsLp5EeCcD5m3GEOzgTEd6Odvi/PONlCY+zEfmwPWJR0BCA2zyyqx+AZLA6NFGFgvf0a+g5B0mlD6kccgq1CJY/oGqSctL8HtK/hfZdcCXXTOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FrPvCLyc; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrPvCLyc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717662871; x=1749198871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=SDrB2PLLzIOEcKTeF44REN1xiInhsZyKEW2TTP1osWs=;
  b=FrPvCLycUVBeS1IpDw8kAlE0dwH1nepjrFq0M31M4HbxCOT9lLZGI8YJ
   FjEasHqEvzZpk8wPinMWThP1FlMoVIPgkYKVklPkrPxL4mlfj3sFLGkTu
   dI9+TE9BmHWXP7hHKN+iEEH05kc5c0v/bpykuOkhLCxqWI8f/SJs4vssz
   5uH+frFb2CkTxgPNyDFWSPNCPZySjjcNLIKaadkfUS0jkC80i1P7LbjzQ
   Ro4l5vXghcyRZWnK+VbMLYyK2NJZcHmO0Gdgdiy8Al/GDBSAQkouUzWDk
   6Aq8yX+TJRCsG5uXsthU0Kkgr/N73ei6vCkyqTcwCf+ANQRktVh13yoOK
   g==;
X-CSE-ConnectionGUID: FfZHO8hyQLGos//d6IaHYA==
X-CSE-MsgGUID: m0XbNar9R4+zaN0AkRIOfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="14058204"
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="14058204"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 01:34:30 -0700
X-CSE-ConnectionGUID: KkN3Rx2+RvCg85xlzgodfg==
X-CSE-MsgGUID: 3GzBmcMHRReRTJympxmGAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="37955230"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 01:34:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 01:34:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 01:34:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 01:34:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 01:34:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0dh0FlYduR5Jf5qo7dq6Jp5p5ywB1HKHDaaGK3vlRdp5jPPm9pDYbjWDLlno7Ejh3yfOf2y7ZaquTACcGwzIM5otmWTamx1RKPkPKAhyoHE1VMmJVQ2eKfTYmSMydWq5B8v9LkCC3ck0V340gYZpUPae8qUzckVqL44C7xSKsx5s4f/aeGWrVl4KrgEZFPxS5MqMn3+G9NMSAD5O86sjIbL4wydS67rYT2xGRvc92rZUxHq1WdhWm47Ppqjzuba9Pyi8AszvBcOQr/j6zbDlUbRjJhUqvvUCn8noxgtpeeNRPII0yF65XjV0S1cWELbhmopcpbxkVI1WISH5Dqm9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYqaJjuyRrFVEIin46hA5l8oKW0tcY0U8jPPoAccnN4=;
 b=ha9UEf93MwQvndzk5sENy/xFLLxJZiRFngXsvUPOU/+8eqfj4s6sqbDWC3NMkpDOu+9FErlYd3ioYds/x912Buug6UhDvbbNvZKDaiSv5OjJ2F9MFD0ZSJxW+djxNwMv3D6bv3TikkxUkPfoYlJKHIFNg7IYw6Av4iylTOPSId+9ST16uJGCQbQg3bc4EDPxnc4HWpiZkL7DPmpLd7zbMHPJJK4KdLSFVCSrwWVWUbGYfEWFgSYIIRrVz8nG754RS2V2e67+hUUegsvPqldvp8TxUIs2k4LALh3rq3l/pQdnf5v7zy530q8mYRh55RMupkTUQk9tWqEDtdRjRIfU6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3251.namprd11.prod.outlook.com (2603:10b6:208:64::23)
 by IA1PR11MB7944.namprd11.prod.outlook.com (2603:10b6:208:3d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Thu, 6 Jun
 2024 08:34:27 +0000
Received: from BL0PR11MB3251.namprd11.prod.outlook.com
 ([fe80::b9c8:5a11:beca:d3d7]) by BL0PR11MB3251.namprd11.prod.outlook.com
 ([fe80::b9c8:5a11:beca:d3d7%4]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 08:34:27 +0000
From: "Murphy, Declan" <declan.murphy@intel.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>, "Alessandrelli, Daniele"
	<daniele.alessandrelli@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] crypto: keembay - add missing MODULE_DESCRIPTION() macro
Thread-Topic: [PATCH] crypto: keembay - add missing MODULE_DESCRIPTION() macro
Thread-Index: AQHatUEv35DnjsCIQ0SJI91tdS0fvLG6bf9g
Date: Thu, 6 Jun 2024 08:34:27 +0000
Message-ID: <BL0PR11MB325123B18DED87E39B8FF8EFEBFA2@BL0PR11MB3251.namprd11.prod.outlook.com>
References: <20240602-md-keembay-ocs-hcu-v1-1-22741e1c3d13@quicinc.com>
In-Reply-To: <20240602-md-keembay-ocs-hcu-v1-1-22741e1c3d13@quicinc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3251:EE_|IA1PR11MB7944:EE_
x-ms-office365-filtering-correlation-id: 399d7555-ad4f-4bec-1f80-08dc86037a3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cDI1YWpEd2c3RHByakJzU2NqcTVtazdxZmFyK0pjdkVvZzZCTHF6MDY5dFVw?=
 =?utf-8?B?c255TXJrUGNzeTJlU1cyY29jVVdLS0JrRmh4aVBUOHdYaWVHUERxTm5FeDJR?=
 =?utf-8?B?R3V5Slgwd2ZCbk5mQ0V6djc0OEowYkhaZCtNMXp2U1phZXFqT014c2JMYVpO?=
 =?utf-8?B?Z0d6eHdGNjB5cHpQS0s2MW5Mc1BpcmxsS2dQMnB6cG1FMnZ2c1ZIQ0pNSkJ3?=
 =?utf-8?B?cmlSSmNBS0lGaTQ2UVpwNm5SdGExdDVTR0JYMTZvUW1kNTdmWmhFUjRJdlZl?=
 =?utf-8?B?YmhDUXVRZi9Nekk0bVpOeUNLMmF5am0rWU1WcFYyUDhtVzJPUzY5b0pvTStN?=
 =?utf-8?B?azNobFhwcnFSS1JmeDlZNUNvOUJ6cVZTMGk0SVI2bGp6cEJqK2xWU3NLZERL?=
 =?utf-8?B?M05CSmphdEZ5T245cEVZNW5kVzJQdVlkM21adGRlOFhSMENPOUNZN1huOTBS?=
 =?utf-8?B?WndHdVVuU1NMSEVhdVJzMUxwSTV0NVFPM2FBR1FScVJnNDhlODJ4RCsrVDBk?=
 =?utf-8?B?cHgvUmZUZ05nS0ZoZ20wbldibkEvQjdJbkhrVEExNHByQjI0Q0U2OGRXeDNm?=
 =?utf-8?B?MDhDZTQ0THpheEJIK1Q1ZVo4WThBWjAxNUZUNUdoUWFaREgwcFNOcjRqQWh4?=
 =?utf-8?B?bjVOQnUwd2NCaVZUaXlhbHZhWWpKUmdIc0tCSlRKL1QrbzNKejViVEp2TjNw?=
 =?utf-8?B?aTFCajZMaXdOSGJwRGVxMG1ScUd3TFUwWjlESmtBTkFKcmxBN3YyVExmaGNl?=
 =?utf-8?B?QS9zL3dOekJhb25IVGtDYWVXVlhRbytXRlNOWmNadDNyMXNrVVFick5ia3pB?=
 =?utf-8?B?bm5mR0cvM1M0VkJRVStWQkVVODlJTExRRzk0QjJCemlEV0U0TXRvamR2dlpC?=
 =?utf-8?B?KzdlVUVKTmloR20xVmFuL2cxSmFlMWtOOXpzam9YeW9wa004bGltWERxMXZ1?=
 =?utf-8?B?cW1NV3dsbTFNc1lLZFlOMWN3ZHRaNW5pTnlmVkg0bkkyVlExL2w0ZlVqZ3JG?=
 =?utf-8?B?MitKSGZmTUFGM1NzVFh4MWpqK0J2eEdHNk5oeDVUSmhHUHN2QVgveHpzanpw?=
 =?utf-8?B?SXpScTBQYjQvOUVPQkNKSnRkTUk2SGVtVWRFOWlIOHhNM0txUllWU29xVXdl?=
 =?utf-8?B?dVRKYktVdTdxajRDcTNldnIwa2tNdjl1N1hIQ2Z4dm00MEpNL2phT0k3dllr?=
 =?utf-8?B?OFphS1pSdUJsbFpwbUxyUWVXTVRMcW1GS2dwOGhaaEMwSXY2RDd1L2YwUERi?=
 =?utf-8?B?ZGpRMDcyNENIZ0RDTWVWU2xUWjgyOUFKekM3d3ZVQi82WExuQ2YvS3RiNys4?=
 =?utf-8?B?TENOaTU3M3BnRUFYNENibzJKMFZab0hGT1BUR3paZXIrMmRaTUVZa2g0RnIz?=
 =?utf-8?B?NlVtN0pJV1F3TFhNaUFER3gvUkJidXJXRUlPS3NvVndlM0J3TGQ5SHFKUEx5?=
 =?utf-8?B?TVZNNHFleGxIRkVHOU5uNWpON2hHbjZVaDJEanNiamZnTlNVNk1FVkQ3Y2RP?=
 =?utf-8?B?c2ZFeWxKamRCSmsya01pa0MyVXpCZHhsaXhVa0ljL0hDdzdLL3ZUZEQxR29k?=
 =?utf-8?B?QTFGYldwN28xOWhUNk16K0VnTWdCMElEK1dFaldiOUhuWElsaktGZGNBbGlF?=
 =?utf-8?B?d3VmVmIwM2h2Si9WVFJ3TktmWTJJY2gwdzlNWWFMNnF2QWttMmJpa0p4S3N4?=
 =?utf-8?B?WVgrdEU0bUtVWnBFOEpkd0tGVjBDQjc4a2F6MVNiM2Fucm9KcWJDWmJvWHEy?=
 =?utf-8?B?bloydFdvTSs0VTFVQUZ2T3Jhb2l1OVAwb0pzMUtuZHIwb2tocElnVlNDN1Zr?=
 =?utf-8?Q?pWpKXefe2SfpBt1CpJiNxeAYxw3YBUZeM93qw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3251.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWZmeWRzNGJDeThTaG1rc0JVSXRTblM0bDhNL1E1MHZNVTNjNTAvMkN3QjVT?=
 =?utf-8?B?QXFiN2E1T1NkWmJqMEd2b3VBbnVrRnBKKzNYb2U5ZWdpRHZLa3JFTFM3ZCtp?=
 =?utf-8?B?RjZBZVpuOU1YVnRRQXRBTm1qV3F5R2NqNGhSZGlRN29kUmdTaGwzbW50VjM3?=
 =?utf-8?B?NElxN3hJMFNsTGxjdDhxNDhFV2NBUEhxL0phWHlFcWhXT1l3Q2dOSm0reGFU?=
 =?utf-8?B?S1YwdlNsQnVSUy96SUpBOGJpTEpRVXlqbnI2MXZPajNpTVdSRmMxRWcyVzdW?=
 =?utf-8?B?ckpvZDlONG5teFoxeXpZUnpuNFZZY3hYZTRRbnkyNVhJTnFlZVhqSk80NGFG?=
 =?utf-8?B?cEZiRUYzL0c2QnRlYVA1WitiRlRNa0xQc2tiTG9oR1Btd3lqRkpGSERGL1hO?=
 =?utf-8?B?RVMrWUFoelVic3Z5VncvUldjdmtQUXRzZTJLV29iN0FqQmhuYmVHVUlFUm10?=
 =?utf-8?B?b2xhNG1uZ3lmdmxVd1lFZmtqZTg5ODIzSS9pZlB0R2QwYTVoTkdzRjdYeGRQ?=
 =?utf-8?B?em5xbnRTVnVxN1FoSUN6MHlZQ1lCWnQ4NEtoNkVZUjVzanRLdU8rcGp1V2tS?=
 =?utf-8?B?akZzeU1RVGFmTEVrTU9HTHRYbmNNQUZEemdUMHRxNlBiamVCZm5aZC9SQWxk?=
 =?utf-8?B?MTRjNFVGN3A0Y2c3Y3dkMmhiaklTWk9oeThYKzRjZkg1TlJwSmRmcldLYlA3?=
 =?utf-8?B?eFpQdENSM2NCcWJXRVgzck5GOXFoZVR3eldtOHFpb2hLMlJtb21yUnAweVJG?=
 =?utf-8?B?QkhVR3BHUlU1MkdEVDUvRzFmS2ZCWnV4a0lkaC9iYWtBWVBzUGM3aUU0d0lo?=
 =?utf-8?B?a3hzT3BnZzF2Wmk1YXNTbzNKS1VnWTZFYUpxK1Jpa0tySUNaRnBWMENWKzdP?=
 =?utf-8?B?RGlpVTFYd1p4NkRDNmpGNHpCV0xvN3NVZmd2V0FUQ29LMUxRZGxXTjRVRWxl?=
 =?utf-8?B?U2FYQ1cyeng5SXJSWVExRVlqZTJBNDhJVEc2TDN2eUxNZEZ0Y2ZQSnkya1Bs?=
 =?utf-8?B?VTlxL2ZVMkljeDBLdnQ0Tm9VY1dGTmllQjJQaEprYnVSV2wzWTZBNys0OEQv?=
 =?utf-8?B?SDdIQXg5UGtRdEppZUdRSno5ZXRDT0lVTTlCK2RUN1VVNm1KRDllaS9RS0Vo?=
 =?utf-8?B?SUw3bFVhYlBKVm5tc2NYWnhXbDl5QzFJdXN3ZDdyNmpwZVFzWlB4cDVwSlU5?=
 =?utf-8?B?R0VxZnZja0JXN2RtMGFMbUh3T2d5Q2NTSHJlbFQzaTI2NTlxWmZnVlpNTFFr?=
 =?utf-8?B?ZXcxbDVPelhjYkN3UXU4ZVRIV0VHR1NHVnNrTFBIRDJoTHUweTJqTk9ZaENX?=
 =?utf-8?B?NS9DZVNpWG8yZTcra1owNHVObjhJcUVBMHFZenV6dHlLOHk1NWpqc013TnVz?=
 =?utf-8?B?TlJST2pMOGhTSTJ5bVZGZHoreDlXV1A5aGEvWFhQcDhKaXl2Vk1FUjNlTjJU?=
 =?utf-8?B?SHZ6d0dZVGRpK3orVXZmVG1iL0hrUDFYS015VlRZS2orSTQ0OW1QaFlYaXBu?=
 =?utf-8?B?N0Fvcm9uZjM1WktBRHYwSXg1ckZ4ZHFyVDhHWC85TXd5OTlXbGhoWlFacnRY?=
 =?utf-8?B?clM4dk1DUkUvTU1JSXJSVGtvY0Jzd2JYdE55Z2RsT0pvcTBsTE9CQ1krOU1W?=
 =?utf-8?B?QWdJVkpWSlBmT05OWHR5Uk5UNllvay83dFBPOExTODRRVFFGVGhKK2tEcTRR?=
 =?utf-8?B?bVVReUlxUExuUmNvZE9ESllsTzVWSDFYc0w0OEo0Y1R5S0hxdldveWIvdml2?=
 =?utf-8?B?UGpaSk0zMGN1enpuQTB3Sk9Td083bmFHMkh4dGRRWjJaMUttVnpDZHM1cnhX?=
 =?utf-8?B?N0s1N1htU0JHbmVjRWRtaThKR004MG9RamdBN2FVeWVUUU1hSnVGZ3Zpa3k5?=
 =?utf-8?B?eDFEbUx3WHI0b0NqTitFc1VIQlZGRVBqb2R3UGpjUEZnY2lWR21uelVPL1Rs?=
 =?utf-8?B?dGczUE5DbCsxbVJNUGpBanNSbTM2dWtWL3d2Z2crYVI5Ync2MDFLdS91T25U?=
 =?utf-8?B?ZUNucWpnS2k3eVRZSzFFK0xSdzg4R3VxeEJXSWVPMGYrR01ZanVFTGJaVGd6?=
 =?utf-8?B?T1NUaWtaTFdnVlBWdXMzdVNnMkFJQllic21zOGVhQ1VtMFRpc0w3VEFhQ0h3?=
 =?utf-8?Q?LQbGI1J/SJzoXVpHdVeCS6vI+?=
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3251.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399d7555-ad4f-4bec-1f80-08dc86037a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 08:34:27.3349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PrbY1HpvT0mHoNbmEREh6VJoWqtOEBAZfZK/CqQh3Ne0GpkmXjNkogc4UUBkVLJMLLRmBtB+GL+6CEjOQta8Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7944
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: base64

TG9va3MgR29vZCBUbyBNZSwNCg0KVGhhbmtzLA0KRGVjbGFuDQoNCi0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQpGcm9tOiBKZWZmIEpvaG5zb24gPHF1aWNfampvaG5zb25AcXVpY2luYy5jb20+
IA0KU2VudDogTW9uZGF5LCBKdW5lIDMsIDIwMjQgMTI6MDQgQU0NClRvOiBBbGVzc2FuZHJlbGxp
LCBEYW5pZWxlIDxkYW5pZWxlLmFsZXNzYW5kcmVsbGlAaW50ZWwuY29tPjsgTXVycGh5LCBEZWNs
YW4gPGRlY2xhbi5tdXJwaHlAaW50ZWwuY29tPjsgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3Iu
YXBhbmEub3JnLmF1PjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KQ2M6
IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGtlcm5lbC1qYW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IEplZmYgSm9obnNvbiA8cXVpY19q
am9obnNvbkBxdWljaW5jLmNvbT4NClN1YmplY3Q6IFtQQVRDSF0gY3J5cHRvOiBrZWVtYmF5IC0g
YWRkIG1pc3NpbmcgTU9EVUxFX0RFU0NSSVBUSU9OKCkgbWFjcm8NCg0KbWFrZSBhbGxtb2Rjb25m
aWcgJiYgbWFrZSBXPTEgQz0xIHJlcG9ydHM6DQpXQVJOSU5HOiBtb2Rwb3N0OiBtaXNzaW5nIE1P
RFVMRV9ERVNDUklQVElPTigpIGluIGRyaXZlcnMvY3J5cHRvL2ludGVsL2tlZW1iYXkva2VlbWJh
eS1vY3MtaGN1Lm8NCg0KQWRkIHRoZSBtaXNzaW5nIGludm9jYXRpb24gb2YgdGhlIE1PRFVMRV9E
RVNDUklQVElPTigpIG1hY3JvLg0KDQpTaWduZWQtb2ZmLWJ5OiBKZWZmIEpvaG5zb24gPHF1aWNf
ampvaG5zb25AcXVpY2luYy5jb20+DQotLS0NCiBkcml2ZXJzL2NyeXB0by9pbnRlbC9rZWVtYmF5
L29jcy1oY3UuYyB8IDEgKw0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaW50ZWwva2VlbWJheS9vY3MtaGN1LmMgYi9kcml2ZXJz
L2NyeXB0by9pbnRlbC9rZWVtYmF5L29jcy1oY3UuYw0KaW5kZXggZGViOWJkNDYwZWU2Li41NWE0
MWU2YWIxMDMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9pbnRlbC9rZWVtYmF5L29jcy1o
Y3UuYw0KKysrIGIvZHJpdmVycy9jcnlwdG8vaW50ZWwva2VlbWJheS9vY3MtaGN1LmMNCkBAIC04
MzcsNCArODM3LDUgQEAgaXJxcmV0dXJuX3Qgb2NzX2hjdV9pcnFfaGFuZGxlcihpbnQgaXJxLCB2
b2lkICpkZXZfaWQpDQogCXJldHVybiBJUlFfSEFORExFRDsNCiB9DQogDQorTU9EVUxFX0RFU0NS
SVBUSU9OKCJJbnRlbCBLZWVtIEJheSBPQ1MgSENVIENyeXB0byBEcml2ZXIiKTsNCiBNT0RVTEVf
TElDRU5TRSgiR1BMIik7DQoNCi0tLQ0KYmFzZS1jb21taXQ6IGE2OTNiOWM5NWFiZDQ5NDdjMmQw
NmUwNTczM2RlNWQ0NzBhYjY1ODYNCmNoYW5nZS1pZDogMjAyNDA2MDItbWQta2VlbWJheS1vY3Mt
aGN1LWY0MTc5YWZlYTM0YQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpJbnRlbCBSZXNlYXJjaCBhbmQgRGV2ZWxvcG1lbnQg
SXJlbGFuZCBMaW1pdGVkClJlZ2lzdGVyZWQgaW4gSXJlbGFuZApSZWdpc3RlcmVkIE9mZmljZTog
Q29sbGluc3Rvd24gSW5kdXN0cmlhbCBQYXJrLCBMZWl4bGlwLCBDb3VudHkgS2lsZGFyZQpSZWdp
c3RlcmVkIE51bWJlcjogMzA4MjYzCgoKVGhpcyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBt
YXkgY29udGFpbiBjb25maWRlbnRpYWwgbWF0ZXJpYWwgZm9yIHRoZSBzb2xlCnVzZSBvZiB0aGUg
aW50ZW5kZWQgcmVjaXBpZW50KHMpLiBBbnkgcmV2aWV3IG9yIGRpc3RyaWJ1dGlvbiBieSBvdGhl
cnMgaXMKc3RyaWN0bHkgcHJvaGliaXRlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJl
Y2lwaWVudCwgcGxlYXNlIGNvbnRhY3QgdGhlCnNlbmRlciBhbmQgZGVsZXRlIGFsbCBjb3BpZXMu
Cg==

