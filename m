Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0381392;
	Mon, 23 Sep 2024 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727101494; cv=fail; b=Kj5z0/joVwbyRn/cUN9RessxKX6J+NOKIDMZYxpV2itW+8TV0vSWe2+PhOsRR6T74ENOgCzHSuuWbteq06QZdkzra4Q6OkrQJs4y32y3Rw5saNvyC8EvJH50r4ATrrRs2gNxw5J2qrd3rirCy2tXGD4J3hi51acuQj0PYwEZOBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727101494; c=relaxed/simple;
	bh=VCoBr97c/Mcig98dIdJbiCiaqN6g63HyD/3Fe5WUfDQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eWwUa9LI4FnVyj0hEnPC+OudJWs2P72CNYC6uXG/bKYNfxm2303BrFXZfOAfpEOazoFQEI2iSPOZp6H4bmKIUE1h4BNRGMveCaqkCZGx+xRouJJW9dHqWdOCITE53MrkFqok8gjXW2Plx4ZDZ+x3+Yu7J//MKXlyLJsua3tgPzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AT97x898; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AT97x898"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727101493; x=1758637493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VCoBr97c/Mcig98dIdJbiCiaqN6g63HyD/3Fe5WUfDQ=;
  b=AT97x898cBxlwWG+vRbLDuCecw7piJ22GXHqfv0zs2YHz5s3XB6gyNCx
   5M6wVYtneEqprk7euj6xwnQ5S86ZnOzQeZfdhm8BRn6vdQbXamwiBkYKm
   JcSVBNWEXC6za5iFINnpuX5I7x45+PhKABvjUdP+GorOMmqFzRTtWhvgT
   i9gMdm/HNCxejxSSdCM5tfjWEgSJOXPl4Aelj1U8HNa2EUWsIivaNyiVO
   mfYrtFCnU/9e1gzI/6H/0xmOpL80c7Kua/a7SXHwbrmDoZhMbOmc52s5Y
   AOlrUoHv1q/94jdF537L2b5GhcX38uibZpyi0oqofy8Q7Z8cyZFI3IR+k
   Q==;
X-CSE-ConnectionGUID: vFV6awE3TVGprdCWd0C0og==
X-CSE-MsgGUID: UVBgKeM0RPSAFl9HbJtf9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="25931795"
X-IronPort-AV: E=Sophos;i="6.10,251,1719903600"; 
   d="scan'208";a="25931795"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 07:24:52 -0700
X-CSE-ConnectionGUID: LKEe0gkfSZOdt2HgMNJRtQ==
X-CSE-MsgGUID: On5/uV3pR1atL55G09R1CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,251,1719903600"; 
   d="scan'208";a="94412775"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 07:24:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 07:24:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 07:24:51 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 07:24:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJ6HWgJ8YkSVkLUT6vA+XFOTJqpykEazWFBEU+O4zH477vRb8GSwB+sxEISgn8KZyXLyawDNmPq1F284DNWsne4Dzf7JgNvjBT+sZk0zdfF/xiVZS09r1iIkWBHRGaKB4wdMbfN1RWl8B/AEF0A3/vrgNZQt/UXuxYjItGn0QYboSX/ZTRSmK+J/wLxV27W7821oUu59t7T1LnpFxaFvZuWJA3Iyz9SdYJ4hRNR6LpOomdrCJcvxg1nVoRuyduXAw0r+6CDZaLWveOXmg6S+MvpyTSPfwA6BZBIhY0MsuXCdASMyWWgdh3uLN3rUP80Vfm6FYwMZ23FJwsqSnLfkCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCoBr97c/Mcig98dIdJbiCiaqN6g63HyD/3Fe5WUfDQ=;
 b=w/cZbnw9GUaGdmwREMumN9RvNebS5yb3MJM7UjZoKgt73j2IWyIlDJ5f5MIGSjygQdKfh6kdPLqLNOY0LTv3ilQEbUKAkR6b7mY44tYYGweV54nflRWG1sq5z69qhcMf2jZHX4wtxZLsaImte2lHDITMFwoUnJvNzeeVoGj4x+bEJacnq7DDWmY3NjkpoyVvnau3tpT8wcA/azEvb0UXML2OYl+wSbrtmnH4pHukLqePRhsaPVN8lYmIGCCwdTaprh2zsnXm1GxAn4c8yJjwhKc8Y81TyuxOESPMLOlZ5gKjSN9LVsMlcemC5LxCiW/8TCg/mJ1kcp/Ca2FLHIsmTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MN6PR11MB8101.namprd11.prod.outlook.com (2603:10b6:208:46e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 14:24:48 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 14:24:48 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: WangYuli <wangyuli@uniontech.com>
CC: qat-linux <qat-linux@intel.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Cui, Bo" <bo.cui@intel.com>, "Xiang, Karen"
	<karen.xiang@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"Wang, Jie" <jie.wang@intel.com>, "Xie, Dong" <dong.xie@intel.com>, "Cabiddu,
 Giovanni" <giovanni.cabiddu@intel.com>
Subject: RE: [PATCH 1/3] crypto: qat - Correct the typo 'accelaration'
Thread-Topic: [PATCH 1/3] crypto: qat - Correct the typo 'accelaration'
Thread-Index: AQHbDOHxRJjTMhGfEEq7AFJVYXB63bJlbhKw
Date: Mon, 23 Sep 2024 14:24:48 +0000
Message-ID: <CY5PR11MB6366671D2010C2EF0B293324826F2@CY5PR11MB6366.namprd11.prod.outlook.com>
References: <7BF34BF48048052E+20240922111832.441807-1-wangyuli@uniontech.com>
 <FAD000B9FEA4D995+64bdb13a-3a7e-4e9f-bc15-199f8bbeae06@uniontech.com>
In-Reply-To: <FAD000B9FEA4D995+64bdb13a-3a7e-4e9f-bc15-199f8bbeae06@uniontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6366:EE_|MN6PR11MB8101:EE_
x-ms-office365-filtering-correlation-id: e9a4d283-77fe-473f-dbd6-08dcdbdb7ade
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eU5uM2lIbGc5V3BIQmZUVThMK2pmbWxrVlNzMEVTL0VDUVI4S2gydEk5Q3Fi?=
 =?utf-8?B?NUg4dHlxN0RUOGlwNFNpR0QyUm1yeWxTVG1INStlbnFIYmVtSkNkd1U0bTlD?=
 =?utf-8?B?WVBPanQ5YnJTbFppMlI5M1VpbVV4VTBKLzVCK0djdGdZM28zN1U2U1o1OUpx?=
 =?utf-8?B?VWk1VEdEZVR0a01wOXhwZVlWSE1ZeUNWVEU3RHNuVFZVNkNhUzQ4dTdham0v?=
 =?utf-8?B?WStwdTBneGxSejR0RlVNYk0ycldZeGlCQlBUbkxsdHZKbWxDSjhFZUcxbzJF?=
 =?utf-8?B?SlBJM3ZaZlBWL3hkQXE5L2hhTHVXekpYY2RYV2Z4MUkwVzNHZVZ2MEwvT01Y?=
 =?utf-8?B?WXZMdW5nOHJxZCtIZVBOU09pbUxwWFpVN1JXNEQ5UDJyV1h2NTREam1kckhs?=
 =?utf-8?B?ZnVMT0tkUFViZm9jL0JtbjZRTnlhLzVBSTJZNFkvQTdNcURNRWkvTnB3TW45?=
 =?utf-8?B?RlpBQ3BSQlBkQWU4K1o2U01VZlo5N3BxZUFSNmVOUENORFYvWVBJdGc5b1BG?=
 =?utf-8?B?Q1NDNTVFRjlHYkFmODJkNUsrc2hYcnhCT0t2RjdHZmhCRGg3cys3cGFsUVh3?=
 =?utf-8?B?ZloyN0h4ampYbnlwR1o5WU5wc2Y3TXRxMmIvYVVPNW5lckZVVllEZFpBZDcv?=
 =?utf-8?B?WmRnQmRQTmFlRTBJV3JLSnRhNHRkb2trVmE3eTFlWW1qNlVoaEpDb0VFV3JW?=
 =?utf-8?B?cjZlY1prNUVrdjRYZkU2VlRmdWVtOWEwTXJKQlk3VU1LOXZ0bnNkc3J6ei81?=
 =?utf-8?B?bUNOVk5BZStEU3h4Z3BGOWE2K3pZS1Fxa2E0V3pIalJqaVc2V1RSNENkNjBk?=
 =?utf-8?B?TWxsNmI0K1N5RHB6VkVGbHAzaFQ4WjBaY1E0U3VOd1VEOTdVOHREa1VtaWc2?=
 =?utf-8?B?QzM2Mk1vV3JOUm90MTRVNHQyQ25wdEJwVXpBUXZOT0hYMWl2NTJMSG50V21J?=
 =?utf-8?B?TzlRSWtvUUhidXNtWjFFaGZSZHY3M3lraGpCWGN0V3hhdzhSenNtc1hCZEk4?=
 =?utf-8?B?N2xEZGRaTitWWWRleEpaUEV6S1NPamgrUDhVNy9VYVN3WXpOclFqUEpqSTdK?=
 =?utf-8?B?ZUZmQTRIeUVEaGw0L3hYaHRKR3ExcjNjNnJYVGhCb2hjeHdjK3ZvV0tBVVB6?=
 =?utf-8?B?T3RYRUQrOWZ2eitxaG9pb21OaDFsZXd3VWVlNTJtTEVHYjNudFZleDJocHB0?=
 =?utf-8?B?UlM3R0dCTko5UVB1RVZKYWExVUJYSzdlZFQ5ckp5U3JzdnprWE9jWEdYOG8y?=
 =?utf-8?B?VEYzYXJnOFExVkYzUDJJQi9wNitieWllTy9MTng2UDBZM2hjeWNueHJ6TDdK?=
 =?utf-8?B?Vlk3T2ZFWXB2MHF2REU3WEpoVDBaclBTUWd5SE1GaTZmem5rN0ZTU293MVFL?=
 =?utf-8?B?WVhxTXY2dk9BNXJlVTgyQTNzRzVRczdnWUtMdG14NTBzOGN4TGJIeEtIVkIz?=
 =?utf-8?B?VHZQLzIwOU1Iay9zT1BVOWJNK29uZ0RtVWo2V0o2WVhOdmVCV3JuVFhubHB1?=
 =?utf-8?B?WW5NYmtFUGVvOW9WdG1JTzIxVG1MTE1xeURZRG1DdldKV0RlZmMzaWhOT1ND?=
 =?utf-8?B?S2MxZitnSHVKbHBQekhHVi8xTFFLaElhUGx4QlVDODdHOFBVY1lCMHcvTlF6?=
 =?utf-8?B?ZDUrNlZyVjNldkxUVlJtWlpkVXVoc1JoOEs1cngvUGo2cnNlVFA4RVY1VTBt?=
 =?utf-8?B?MmJLalA0aUVFdFQxM2VCU0pDay8vWTFXN2hGUm54MTJmVDFVUHdQaGphQmJp?=
 =?utf-8?B?bUlkR2UwWHpaMHVOeDloU0V1UGZOSXYyVjVaV2NQdjRVMklZajM4NCszWXdN?=
 =?utf-8?B?TDlsZ3VYQmFTNkZ1cHl4QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVJYRWtNTmp3MGR3ckljYXNGMW02UWhOT0N0OW9aVmlMTmYrM1ZTNGxhV0NW?=
 =?utf-8?B?THorNGRDVTFQb1JDcjlsV3NGZFpJN2p0RHdlNzRFUVlUSkIzLzBIaERmb0lP?=
 =?utf-8?B?dXoyTTNBSiszWVhOUGJaQnU1aWEzQzJ3RmhBeWUwR0tqT0xrWTNSSXI3ZGs0?=
 =?utf-8?B?YnplaEpqOHY1ZlM0M0RXOFhETSsvL2dJSG9xMnlxbGFMdGJyNE1oYXladUEz?=
 =?utf-8?B?L290czlPVWZ3ZkpVeHI5TmJNNU80TXhYOFVkR2JnTkxST0x1a005Unp3bmtz?=
 =?utf-8?B?V2RPK3IyVHE5S1lOZVZTWGJYTnYwbitPdXBpSTN1R3JDR1JNSnpmRVlIbTlq?=
 =?utf-8?B?a1VWRGpRYWhIOEdPZ2Yzbml2OWRsSnk3cnlVWldzZW83K3czUlRsRTNaczJB?=
 =?utf-8?B?ZE8zTWx2Ylcxd0Nwa0pHcVNMZE8xSkJrV296NVpOSDVhWDBSMVNPYXpoZTNF?=
 =?utf-8?B?RmlSZ3pqTlFJaTFIemVDUG9uNVpubXV0cm9GOUhJUktUWjhlKzhKYmZmbi9r?=
 =?utf-8?B?N2t5V2JzZElpN3dIdVhDekE4WXZuRmtLUHQyY0ZObjFlK2RvcHlRNlVlZmNO?=
 =?utf-8?B?cVgwa2w2Umsrajhmdk03RVppNXZyUmFCNE5QQ1lTM1pIaVhWZkNMWHd0UW80?=
 =?utf-8?B?ZnRrVVd3eklSamJWeUgzWjFUSldrYTlncytuckIwQ09xYWVVL1FVRWVwYW9W?=
 =?utf-8?B?M0dHZXpsS1NoZFpXc3FDUDFESlh4WTBNVlJOVnY5aGRNY2ZYWHQ1VWdFL1Z5?=
 =?utf-8?B?NTZCekMwMGNGQTUrY2RmaWcrSWpjMXFKbzBINUdPUStYNForMGEvRSsyUFdZ?=
 =?utf-8?B?UDBoTGM2L2FrRDRkMU01UjZRODd5ek1MUi82aFZLR2hXa215eWU2Q1ZqcWdT?=
 =?utf-8?B?M2tYUjh6L3Y2bU52Y3RhejA0TTFBbENqb2IxV2VyOHkxSkxQUCs5QldNSU40?=
 =?utf-8?B?eUl1WVlEQ3liV0VNc1cxSm02ZVVhSlgraDRWY3A4TEdpUE5SNk9jTm5wT0N4?=
 =?utf-8?B?MWdaNE80ZDVkOWNaMjFveTg4U1RGUkwxUFhOWjZja1M3REFtY0k2OStKbnkw?=
 =?utf-8?B?UlM3RmFFd0hMYXV3M0NJZ2cvcUZQMmdQMVdRT3VHamlSNnBuYnR6Q0hTTm9T?=
 =?utf-8?B?Yld4Z3BIMWkyZEVodkdnYlF4cXc5dlZ1N2Y0K1JFV1hTbURSY2d3S3NEekpM?=
 =?utf-8?B?UkFDbGc5NWFWSm41RlJ3ekxobHYxM0gvRlJpaG4yVm82VlpsS3RWUGxPVkk5?=
 =?utf-8?B?RmZGVXFrc1hKaDNydUxwNThEaW9lZDR0ZVFRVE5MZVBFRlFvSlZGVHV6czJv?=
 =?utf-8?B?ZTRMZmlFaVRsN2N1dVBsZ050OVEzdUtwbnJoaWtHTlRQMXFFWk5MeVJzMzY4?=
 =?utf-8?B?UDk5VEVYNkNkWjB1dnlwR1V5V1E0Rk9kL3ZOeFNMZEpCb0VMaXJRY1ovMEdl?=
 =?utf-8?B?MUJNR0NqQkgxcjZ6MG9mVURCMlM4SnU2VWUycHFZeVBPK09UTVp0UE9Bempi?=
 =?utf-8?B?US9ncVcyOEdHRW9GM2RUTWpIVHpGeHZuOWlzSkNSRkxKT2tqUmw2N1g1cEc3?=
 =?utf-8?B?UnlVQUNWSFlDZVo2KzREdnJRL0t6OFN3SUNSTWE4SWtCYlcwSys0NDRtdmRF?=
 =?utf-8?B?L1ZUK0ZyUWRIb0l3cmRRbjF5L0M3YXJqbk1FQkNQWXBwMjRrNWsydGhkSjRK?=
 =?utf-8?B?L25FOHpESnJTenQ5elgrRDVtMWsyYk1RRTE3VmpEVHgzVmxnM0pvNFJYOUJC?=
 =?utf-8?B?Zm5CTDNJR0Ewc0c0UkUxQzAxTU14V2lWTXhpc2owRHhKRkpEZDJabGQ3ZGJR?=
 =?utf-8?B?NUNicm1vTENLclBETlNjN0MyVDdIc2ZGd04xa25sdkd6WlZGYnRmeTdoQ0lW?=
 =?utf-8?B?UE1zak1jSGxXdFRPTG5XS29DWjQ1dFQ2bGpJWnpRQ3hGOHRxQnlYaTZrNVBs?=
 =?utf-8?B?TnhFSUVORVpSdjQ3ZXZSYTU4aHFoWmp5RlRZZGZEeERQOG9oV1l1TS9iNHA4?=
 =?utf-8?B?VXkwN3pDVWQ0NFdKc0NyODkzUDJNbU1abG40aHRJVWw5bWtrMDI1Rzl6UFBz?=
 =?utf-8?B?ajRqSnR1ZXlPR29sTTdZMDB0ZHJRakhCVEtwYUhPazM1RzBuQ2ZDUmQxR0gy?=
 =?utf-8?B?NStvTW1WWG1UNjkzSGk5aXAxSng0MzRKalJaMHNiNWx0N1RVTTIrY0xpUGll?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a4d283-77fe-473f-dbd6-08dcdbdb7ade
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 14:24:48.5058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CLJoemGsvFK3R/21REV6f17ZY8KoXXD8//GAV+VjDfJVBidsH6WSqvsV+I4Dudf61AGGQxtqXk+oaipHFLBFftY+P0/h/YAAyCFzDfr4JqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8101
X-OriginatorOrg: intel.com

TG9va3MgbGlrZSB0aGVyZSBpcyBzb21ldGhpbmcgd3Jvbmcgd2l0aCB0aGlzIHBhdGNo4oCmDQpQ
bGVhc2UgcmVmZXIgdG8gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvcHJv
Y2Vzcy9zdWJtaXR0aW5nLXBhdGNoZXMuaHRtbCNuby1taW1lLW5vLWxpbmtzLW5vLWNvbXByZXNz
aW9uLW5vLWF0dGFjaG1lbnRzLWp1c3QtcGxhaW4tdGV4dA0KDQpSZWdhcmRzLA0KDQotLSANCkdp
b3Zhbm5pDQoNCkZyb206IFdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPiANClNlbnQ6
IFN1bmRheSwgU2VwdGVtYmVyIDIyLCAyMDI0IDEyOjI0IFBNDQpUbzogV2FuZ1l1bGkgPHdhbmd5
dWxpQHVuaW9udGVjaC5jb20+OyBDYWJpZGR1LCBHaW92YW5uaSA8Z2lvdmFubmkuY2FiaWRkdUBp
bnRlbC5jb20+OyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IFdhbmcsIEppZSA8amllLndhbmdAaW50ZWwuY29tPjsgWGllLCBEb25nIDxkb25nLnhpZUBp
bnRlbC5jb20+DQpDYzogcWF0LWxpbnV4IDxxYXQtbGludXhAaW50ZWwuY29tPjsgbGludXgtY3J5
cHRvQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgQ3VpLCBC
byA8Ym8uY3VpQGludGVsLmNvbT47IGJydWNlLncuYWxsYW5AaW50ZWwuY29tOyBYaWFuZywgS2Fy
ZW4gPGthcmVuLnhpYW5nQGludGVsLmNvbT47IHBpbmdjaGFveC55YW5nQGludGVsLmNvbQ0KU3Vi
amVjdDogW1BBVENIIDEvM10gY3J5cHRvOiBxYXQgLSBDb3JyZWN0IHRoZSB0eXBvICdhY2NlbGFy
YXRpb24nDQoNCkZyb20gZjUzNWRiMmQyYTMzMjc4ZGE5Mjg3NjdhMTQwZGQwZWQyYWRiOGZkZSBN
b24gU2VwIDE3IDAwOjAwOjAwIDIwMDEgRnJvbTogV2FuZ1l1bGkgbWFpbHRvOndhbmd5dWxpQHVu
aW9udGVjaC5jb20gRGF0ZTogU3VuLCAyMiBTZXAgMjAyNCAxODo0MTozNiArMDgwMCBTdWJqZWN0
OiBbUEFUQ0ggMS8zXSBjcnlwdG86IHFhdCAtIENvcnJlY3QgdGhlIHR5cG8gJ2FjY2VsYXJhdGlv
bicgVGhlcmUgaXMgYSBzcGVsbGluZyBtaXN0YWtlIG9mICdhY2NlbGFyYXRpb24nIHdoaWNoIHNo
b3VsZCBiZSAnYWNjZWxlcmF0aW9uJy4gU2lnbmVkLW9mZi1ieTogV2FuZ1l1bGkgbWFpbHRvOndh
bmd5dWxpQHVuaW9udGVjaC5jb20gLS0tIGRyaXZlcnMvY3J5cHRvL2ludGVsL3FhdC9xYXRfY29t
bW9uL3FhdF9oYWwuYyB8IDIgKy0gMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pIGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9pbnRlbC9xYXQvcWF0X2NvbW1v
bi9xYXRfaGFsLmMgYi9kcml2ZXJzL2NyeXB0by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9xYXRfaGFs
LmMgaW5kZXggMzE3Y2FmYTlkMTFmLi5lZjhhOWNmNzRmMGMgMTAwNjQ0IC0tLSBhL2RyaXZlcnMv
Y3J5cHRvL2ludGVsL3FhdC9xYXRfY29tbW9uL3FhdF9oYWwuYyArKysgYi9kcml2ZXJzL2NyeXB0
by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9xYXRfaGFsLmMgQEAgLTE2Myw3ICsxNjMsNyBAQCBpbnQg
cWF0X2hhbF9zZXRfYWVfY3R4X21vZGUoc3RydWN0IGljcF9xYXRfZndfbG9hZGVyX2hhbmRsZSAq
aGFuZGxlLCByZXR1cm4gLUVJTlZBTDsgfSAtIC8qIFNldHMgdGhlIGFjY2VsYXJhdGlvbiBlbmdp
bmUgY29udGV4dCBtb2RlIHRvIGVpdGhlciBmb3VyIG9yIGVpZ2h0ICovICsgLyogU2V0cyB0aGUg
YWNjZWxlcmF0aW9uIGVuZ2luZSBjb250ZXh0IG1vZGUgdG8gZWl0aGVyIGZvdXIgb3IgZWlnaHQg
Ki8gY3NyID0gcWF0X2hhbF9yZF9hZV9jc3IoaGFuZGxlLCBhZSwgQ1RYX0VOQUJMRVMpOyBjc3Ig
PSBJR05PUkVfVzFDX01BU0sgJiBjc3I7IG5ld19jc3IgPSAobW9kZSA9PSA0KSA/IC0tIDIuNDMu
MA0K
