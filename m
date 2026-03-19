Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D47E2F068C;
	Thu, 19 Mar 2026 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773942686; cv=fail; b=ZQBNx/6wM1kVQDP4Rn+eWvFcFU0szegRkU2f8RsCAGNsPhc/Fyl910JPI2fe0SZJ5a8MnpPxLuScaUe9sr7Xu6Wvto4ifqlc45BmwdIzPCjd8o2G1B6o6mJ8UM6ZfO7D2CYUisDKPOY0+6dKdGORycZtloRycBmsVe7OP+2w/8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773942686; c=relaxed/simple;
	bh=xg2RL3x7wFMUr3Gl6ewYE/KFX6Xewfw3S3pWY9gazv4=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=gScqNE/iFgtxVhaeI2x3WnKQT47VKN3dag4Q3cAi0GxhwpgtSTPUcAhNWz1YoLo48d08mnfNv5McMrujqIKhNWjw7pw669/IL3HCfOuTopZna1mRahElOIMAbF/e47X+gsSsgdLaHuD21qYBcPLFB1HtTt0c+AM19+974xrhpyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mx7O6Xsi; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mx7O6Xsi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773942681; x=1805478681;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=xg2RL3x7wFMUr3Gl6ewYE/KFX6Xewfw3S3pWY9gazv4=;
  b=mx7O6XsiJQw/oWh5U5U17NCLr9TlqWlr2IMV2vZxZSg7bKIS5EzJGpXo
   R3waklC32pgSPlfTFphE9rqj5tgb2Ic7h1RMw0sgQ55LUJN3BPZd9x7+h
   3Ld1loCv5jC0ecspra606qMdY/hjToRAZrTPdBFfJ+JSm+30jKvd339Ts
   ATpuPZp/oftTD0/BsLjBxrUS7jwyEHFZjg6WYu9HboQ9xexAVtD04q47U
   18VjpwuEAw1bJ4UIZnEKyw3yHY6xE5Ln9KryAc9tBzLhQD3VJpxQtv2+n
   eHJb4waTspET/Nr65v8ZUwBfO2v2jNAe+usuYzTuiT2H+otvDW2oGFwtA
   w==;
X-CSE-ConnectionGUID: /BCeQspOQjmNeqbaYaf7BQ==
X-CSE-MsgGUID: JkfRy2byRD2G7/Y3BaknaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="74934779"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="74934779"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 10:51:21 -0700
X-CSE-ConnectionGUID: 7jEKmyQfRYq3hdp/uwbcgw==
X-CSE-MsgGUID: iaUx02J7Ri+Pb3VhVguwGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="220441377"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 10:51:20 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 10:51:20 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 10:51:20 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.13) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 10:51:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oER5dtsAh9GyYnGufR5zklp5qAuUM7Rc2Z8TcbT8UPxt8NJgHlp8sydzBtWMX73UhgI2xlXwRc/oiJtlHCs7CTdqcwjFP085E0UkAPMYLiNVRVo/zJyTW//yKTRfnPbVOKQiulosC59vSyYVfkjMOZVWOpOBvDfHyO4iKnzCMorinr+rxT2pam3zE4zwEsqODm8ku0ysYjLW6tTL0LFS5ZJy0UmTijTaIaxasuhQzH5vsmvDLl5fyWqScoDJDoxIB8llw37BRx/lsa9v/0Fl7MpaESRllCb8UcMj+xpU1v0vaVqOIUIoqjvrKbZz4hDUsm1TMrzbWGsM+GfgapvbJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muaSgNMy5mJqo+/bIPAhH8Wot462QHNNw3Bj1ujaRhI=;
 b=iilNgMx4V80X+cqs/PSTL/LlML4XckhwCge9scatpLlf8jSIjD6tVSjelAQa+0C4HOfC5Ug+VjL06D9Hf//7qTLXLq4v4yRiQtiyaQlNYU3/VN/gwj23J6PW4ypX2/5EDHPSv/mKImLEuFkoAHiUTPBfNU/k0+Al8tAHI8QfBuu2eQGpzJajpikktnHy7N70G9/jvcjZqUOHoEvrrHxZV9dj2DNwM9kdiOYASa/13CKVZwnlk2Nez0JNxcHxUwo5oA+kw6E4adI/N2NzrKWvgQLmr8H9iu8aEjopqmVShU0OJCYFDcsykpJ0CP17HRbi2+jb47iprQ4ridRL5oDmWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7550.namprd11.prod.outlook.com (2603:10b6:510:27d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 17:51:14 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 17:51:13 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Mar 2026 10:51:10 -0700
To: Eric Biggers <ebiggers@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: <linux-crypto@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>, "Dan
 Williams" <dan.j.williams@intel.com>, Dionna Amalie Glaze
	<dionnaglaze@google.com>, Cedric Xing <cedric.xing@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Zi Li <zi.li@linux.dev>, Masami Hiramatsu
	<mhiramat@kernel.org>, Lance Yang <lance.yang@linux.dev>, Zhou Yuhang
	<zhouyuhang@kylinos.cn>, Colin Ian King <colin.i.king@gmail.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Message-ID: <69bc378e8325b_7ee3100d1@dwillia2-mobl4.notmuch>
In-Reply-To: <20260319173222.GA10208@quark>
References: <20260318164233.19800-1-ebiggers@kernel.org>
 <dc124ea8-05b8-42d2-93ad-d265e0ecf585@app.fastmail.com>
 <20260319173222.GA10208@quark>
Subject: Re: [PATCH] sample/tsm-mr: Use SHA-2 library APIs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:303:16d::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dae1159-63ad-4ae9-2d3d-08de85e01ccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 7C+FCp+vOoI0Q/l+p45OZ22bIVU1BmlMz2denARn+cHdLI9/+Bh6p1B8T9QMFUVl9SUlpJltB1cqtfL47Lq1YgLOFQNebuwPVu5nK3PK98AuICBxG9PvA9oHLXVEnusbeWrEdcj2aL7iX9hr+nNbl+0DuuL4Kj/uSKb4VK5W/JsB+Q4U/Nvu7MnElpkrlcXWKWbDtICAfrWqIbGgd3NblH/e4PFRI+0OC6DDSFUJbS3Sa3l+Htp3/KIAPp2FXFdUB95c3dOP28GWvg1I8a6DHWnDu60zcFUKFDKhx9ve2/DVTMSKZ7p6rn7nyzBBeyoGhHs/H0I7zT+WiwLm3enysIuZWKhamGO0E+RvR8Ngv8Ml5Bu8MyPt5G11Fj3/pYHbvaDrBWwv8Ul7cu1eDtoUByQYRfM3tsxNZKr/QO2M91VunUtgNmbZxV8WiR3+OHBMQ+abkZBmPUTTa861fvRt/l9oG5vNgBuEdGsJOXsLCuSIrPIiJ8A/l8F9GBryWAv2U72q2xhBea7Q4SrcqVuiu6RAXdj0guk6eMynDqlM7iplnxpb9MewHW4CY1QjUlkBflf8bL3np+UWAlpHdExaZYpoY9Ox0mBJuDOiX9Hy0KCMDMCFOB86cb02I7ahEw9M33SjtPociIoVoVL2KlBlPNiAEX5fhZ6LoWyUqwPmeV1tTA8s0WJfWFpb4uaKnBSoIlfE3+P1E5BsOrp4iYA8t7BNpiMGh7ING3Y1LWFucX0qqm9sFEdX0mv+yGJYOcL7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djNucWhmbVp3OGduTHBmb1NkY1FhZGhrMkRjUHJyV3ExUHI0anYrRmNEVEVp?=
 =?utf-8?B?aFFaOVNHdERTKzhKSkMxc0RQSDJVcENUSjJSUEkwRWRxY0d3dnMvZTVENVRE?=
 =?utf-8?B?c1FsR2V0Ry90WGd4b1FGY0phTGEwbjRLNE9tYVFXMjcwZ1BTTnJpOUp3bnUy?=
 =?utf-8?B?eERUMHpOclMybzdob1piR2FsOE14dTBPV2pNUVVUMkZ1d25xMk1xSkUzSXRt?=
 =?utf-8?B?R2ZFT2MyWnQxQUhJd2dZdkUzVGlMZ3BYekFaUlc4ODhBYnhrRktHTEJLU0ky?=
 =?utf-8?B?RGdyc0taODVBU3JkcE1aenhtNHNNdkx2QjA3cEdjZTd5UUttVHVaY2gyTUl3?=
 =?utf-8?B?Yk5TTHZpL2RENDMwQnZYd2VVTkk2cTRmcHJOeWNCajJ2R2pYTC9TZ0NmajF4?=
 =?utf-8?B?UUNwTjNqd3dhck5RTmNpbXp1REJiUm83dUVMdS9rVXYzbXR5MExrWnBnaUVU?=
 =?utf-8?B?WXlGMmEvd1Y2b2Nzd01RMXJTSzhkTEFjWC9iemNQalY2Uko2ZVl5NllGZllU?=
 =?utf-8?B?bkNZdGRxWEtHMDVrQUxIVUJKNTRQK1M0bVpzZUp0NXIrYTM2Z3hmaEVKSWRs?=
 =?utf-8?B?U1VVOVp5aU5XaXZ3U2lDSyt5a1pER2VhL3dQZnZqR0packZtazZIRTVqY2s5?=
 =?utf-8?B?eFRhcHNsLzBSQm5iOU9RTmFnVThHQkxrbWhMWVdJYjd3WnB1NmJqTUVFbWJY?=
 =?utf-8?B?NE9ucGxpVTUwcmdDRHlOZ0JERnYxSDlMRTJORXV5c29kQVNyYzQwV3NPRTc1?=
 =?utf-8?B?bFRJUWFnNUh3cXJsbldCcUNxcU00RFJJc0IyNEMwSndxTW9HVGg5YTNvL0dN?=
 =?utf-8?B?QkJTYUtWNWdTU3Vjc3BxL0lUQ2l0RS9QSWtoYklFbEQ1d1FEUDh5YmhxWm9F?=
 =?utf-8?B?Q2pTMVlsOXFWTXJObWFxemIrcDRySzlWdkhjc3F4Wk5qTk56YStiRnJYRHZZ?=
 =?utf-8?B?MitNOXZVVW9RS1FBQWZnSkdaOTFTRVRJVWltR01VWjBBUml4ZVJCN2oweGlD?=
 =?utf-8?B?bTM1WXpYRGpPYnZhMDRtQm1wWWYvQURLL05LMWZXZDI3MitVZ2p5d1JsK01q?=
 =?utf-8?B?QXBoRG9KMGswQVZxS2M5TTdxenZWc0FxTkhKQWk0MjRqby80alg5SjU2dFlL?=
 =?utf-8?B?L2djRkNHUlFYQTNUbkdlS2NGMnV5MGFLZW9sNW9OZEhreUpGWUdYVEdFU0Fu?=
 =?utf-8?B?bi9TczRvYUhhZFNkTnEzbFZCU1Z6SFBjaitwSHNpWWpEL0RFQVRNdTJ3M3p3?=
 =?utf-8?B?blZFblg3SjQ2S0lwUm9JOUFrdC9md1pJd09PTllZNTdlRXRkZUgyb3lLQ2Jk?=
 =?utf-8?B?UGxqenNmQlFsaUY3QUh2OTNaVlZMWDQ5cUo3NmMwdXZuTEsxREcybEZFNVQv?=
 =?utf-8?B?NlZmNmY5OUpsUmppQVBPZXpuYXVFdWpGb1dBRDdCOGpFWXJpSkJnUU9IUldm?=
 =?utf-8?B?SjEzaG1TUDk2cUk2eFV6dkRlSmxyUXIyTjMxeERuRlRtVlpnNFBMQVdRT3pr?=
 =?utf-8?B?VmVTUkJ4Y2g1RUwrd0RqMGt2R3lGd0orNHdjNEFqZ0RoTExYZlJybzIwNm9m?=
 =?utf-8?B?UDkyMW1rNTJyOVpEODQ3emdyK013a3A1alFFL1NrTVJiVzdiVXVoWGZsWFZr?=
 =?utf-8?B?M01aeXZ0ek9jZ1gySGZkMUtucDF2RVdEVnFEUHZiLysxZTBvSnNjUHZMeXor?=
 =?utf-8?B?WE9LVG44N0xFOU9uMHJNeXBzYkIvM0U0aXk0azNhdTE0VU8xR1gxR3RnTHhE?=
 =?utf-8?B?U3ZCUTRGQ25BOENVTnVCand6Q0dsbDNnUlUvR21WZGoxUlMvZ3ovN1NpWGlT?=
 =?utf-8?B?ODYzWnRiL0VEYWNQZnhISnFnbzlLaDZDaFBVMUs5MnpZM0JkbkE1QkViTEtv?=
 =?utf-8?B?Nmo3Qm54UkZJY3lEZTBpZzM5czBMbDBhR1RuZFQ1WWVvdjdvWVY0V0t6bHRl?=
 =?utf-8?B?TFVENFNWNWNLQ2JOVDFsRDgrRGhlTXlxcVl2RFBwSm83d3VuZit6TzV5Tnhl?=
 =?utf-8?B?NVBrdWtWQnlwMUkyTjJuSXVpUktHTUhMQTVyYzlLSWNnZ090NmlYQUhRVnRF?=
 =?utf-8?B?eWVWN1k4RmRqUnd4cnZ6VUp2eGVXenRLbE8ydVVvNjE2L2JoOE90R0hkSVR5?=
 =?utf-8?B?RW1GQWNGSVFoM0RyclNFaFpCTUJHazRWSDFBam4xS3AyRXJpZlA1ZGRJdVpG?=
 =?utf-8?B?VG5oTEFPWXg5ajJFNkJCdmpXRWltMEhsTXNBZEtQcFBCVlFTdVc0ZmFaQ3RC?=
 =?utf-8?B?SS9CbnBFKzU3MWdEMU9OdGpWNmtNQXRDZnYrb2UzNWlFY0xjNFl3eGdPbkp4?=
 =?utf-8?B?Rml3VFhGMWtDcG5kOXVQR0JFQWs1eHZ2Y25MUlh0TkNTNGtpYkNxRjl1cmZU?=
 =?utf-8?Q?06ClJKnD3KzrqQtg=3D?=
X-Exchange-RoutingPolicyChecked: HjBv99vpRtQf+PSwa6BarqUMJlcpt7lO6cJXzKnckwEWgVcLaEIj4KCULaD0A0j5/V28pPrUWo5xKdy0NRwpWnFBdBvWue5buUxO4aJlaMarBya2ZkXcmr7uSL/oM8tP0/UGlXRxr6hG12ojJd0h+M7Aqe93OW0dbDzKIEdfLuSQ8Fnb2TytxJ8RljEr5uQCPUWKtsZXLRMWvaOrImJDCmzHp2pA7MopI6TJujexy1VHDtRh6FibCCcE0hXjYZKFGkggRb3WMgc8iAoby2EM426AYVW8LgLiCNJl6x55z5+i2YkRhdftALUT1Rjk0cK1mZ9THwCURcuAG4Vp/cdHjA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dae1159-63ad-4ae9-2d3d-08de85e01ccf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 17:51:13.7230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12PTK4KfyadSjIOJZKUZb5LArOex9PlUlw4kKze3J/D6h7ganeifqH8GKVcrffTWc+y/vIJuvAiuwWqFi7ylQ88ZblhuU+cuEnmAaH9XDEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7550
X-OriginatorOrg: intel.com

Eric Biggers wrote:
> On Wed, Mar 18, 2026 at 08:57:01PM +0100, Arnd Bergmann wrote:
> > On Wed, Mar 18, 2026, at 17:42, Eric Biggers wrote:
> > > Given that tsm_mr_sample has a particular set of algorithms that it
> > > wants, just use the library APIs for those algorithms rather than
> > > crypto_shash.  This is more straightforward and a bit more efficient.
> > >
> > > This fixes an issue where this module failed to build due to the kconfig
> > > options CRYPTO and CRYPTO_HASH not being selected.  Also, even if it
> > > built, crypto_alloc_shash() could fail at runtime due to the needed
> > > algorithms not being available.
> > >
> > > The library functions simply use direct linking.  So if it builds, which
> > > it will due to the kconfig options being enabled, they are available.
> > >
> > > Fixes: f6953f1f9ec4 ("tsm-mr: Add tsm-mr sample code")
> > > Fixes: 44a3873df811 ("coco/guest: Remove unneeded selection of CRYPTO")
> > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > > ---
> > >
> > > I'd like to take this via libcrypto-next, as that is where
> > > "coco/guest: Remove unneeded selection of CRYPTO" is.
> > 
> > Thanks for fixing this! It is indeed nicer than the fix
> > I sent earlier today.
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Thanks.  Additional acks from the people owning this code (Dan, Cedric?)
> would be appreciated.  But since this fixes a build error and is related
> to the crypto library, I went ahead and applied this to
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
> 
> I also found that the build error is pre-existing, as CRYPTO_HASH was
> not being selected.  "coco/guest: Remove unneeded selection of CRYPTO"
> just made it a bit easier to encounter, by not selecting CRYPTO either.
> 
> So I updated the second paragraph of the commit message to:
> 
>     This also fixes a bug where this module failed to build if it was
>     enabled without CRYPTO_HASH happening to be set elsewhere in the
>     kconfig.  (With the concurrent change to make TSM_MEASUREMENTS stop
>     selecting CRYPTO, this existing build error would have become easier to
>     encounter, as well.)  Also, even if it built, crypto_alloc_shash() could
>     fail at runtime due to the needed algorithms not being available.
> 
> I also put this commit before "coco/guest: Remove unneeded selection of
> CRYPTO" and dropped the Fixes reference to that.  So now it just has:
> 
>     Fixes: f6953f1f9ec4 ("tsm-mr: Add tsm-mr sample code")


It looks good to me:

Acked-by: Dan Williams <dan.j.williams@intel.com>

Feel free to take it through your tree since I have nothing immediately
pending for tsm.git.
