Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD52701D0
	for <linux-crypto@vger.kernel.org>; Tue,  1 Jul 2025 10:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751364738; cv=fail; b=WdaNCK6be6Ev9V4IgpvL0vP9jnphh/QjopL4tqiYw5mpW8t0R/KDX/MejS/T+ZM3V+pYZlrFotLoVQdi9sX46YPa+0QZamgFnrQlbH2aP2Z10HsZlDeoVIwJs8nI7EV+ptwlNZBZE9KEkjf3aEsVsphX/VV6xVQBUEp0T+qz5M4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751364738; c=relaxed/simple;
	bh=kkAyLj929eT5Nj5ysEzkFJcrj5Ed0HjkYDoouDdvNJ8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=snaF8TVpkGPh3i0Uxpo47myuzAbxI0F5Sf8UDRtJDnHToWaFpa9CZJkEiBXn96Jp3Czh1q88usYGJSMMdDh1eJSjJkg7W3Bm+1qPBJrwlnuEvehTUmvo5TzSXmhF7SxVpEa0OVjc8pZ4Q+MXMz+92H3il9MFb6GiTdnJpeaCvy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mrLkYQCN; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mrLkYQCN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751364737; x=1782900737;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=kkAyLj929eT5Nj5ysEzkFJcrj5Ed0HjkYDoouDdvNJ8=;
  b=mrLkYQCNe/vSHVDabExEfv31I222saRnOClMYBWNOyVEALCnd7gS8BaJ
   hIGoSv+eINxamB96vfap2XruwEaMdCWV24kPy7qaE9lXE/b/LR7PlbE+L
   jqmMC/5b/m3ys5FFe5tFDvNGdOHWPjsQd8ctrvP6URbgi2APQI0GXv1b9
   DkMixz7QnTRpwrMXPyofqq5yCJZaUJfE+/4qytPfWgCBqUb/4s8CzDtqw
   g3smCWoF6l3z8R8QjBjVgcOFOgLzpVPcYt10bAJTV6AraJe4U32MXrgpu
   kM7e2dfECmRJqp9VrNYXnskdvkEPn2VlwotoG6nUSEHVamYc8mJL+9789
   A==;
X-CSE-ConnectionGUID: Y9Z9R/TLSS+7B1hU6c57oA==
X-CSE-MsgGUID: lqs1/vTWTf2VXYDXje20jQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53713830"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53713830"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 03:12:16 -0700
X-CSE-ConnectionGUID: 6e0472VuSTmowsXpHnBU4g==
X-CSE-MsgGUID: qI4AV77kRs2z537BI47ZAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="158281568"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 03:12:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 03:12:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 03:12:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.45)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 03:12:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdX1FxobDOlWL+twywsQcAvxm2ODKUbzAgp5w5RNkJCuCm6Dp8ecm0ID2RXfFOrE0Rk38qF8JIuz7PrMCNxwotzX6NnV9MW2GyeMyBfWvY1blAuIJWmz70ZxwBReVEKh76Lk0UppOOufD504JCYRcmjtHyU07kl/Sg4b/1H58wWeDPl+my1oFWU2zJum8KSGV6kwFPGb7AC7u23NSccxL8pbZEc8z0rIp+sZGIzdqFxxvl2wyMfG2aCVFeUMRNZ52Xy5Wmuzcf1hIZule3iBWcvFsLTjHV6UqSVyB/TDA3egeV5UEwHShsJY/mQMhjzE9atYNj/PjIYQIdEfChQsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPdbDbri55cASGFDwKv0H3B+C8F2+nFFS4TJiz84gRE=;
 b=SWmZGA8YYmZA9Eccp3XWBYvE3eXihOt7IkryaPl/JlvUrnDRrKnMkWECqtJIwLWHNj+KvmiwnemhETqzqHEJtgCk7BFv70nXeXYt8Oh+t9QJPoekw2tZX6P0osKlSj3aXVwcgEWGIxqiL0Cj4ZkG0cLdPPzFivG1oFVlSnXUK3xNn/MJ2XVVrh/lKzHXRpIUg8q29/c3Ey900ScrMGN0FxqSkYrdDc63HKJNmAQXx6pqoz/bL/GS6IuyUqzln/AAwsfqK4mYC5vLgI6QG5mgEG6tJ3zVRuhI4Druf01dpg0l7qDMatVslxUDhZUY16l3UOcUAZ44UNIyFyNERNZPtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SN7PR11MB6773.namprd11.prod.outlook.com (2603:10b6:806:266::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.31; Tue, 1 Jul
 2025 10:12:13 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 10:12:13 +0000
Date: Tue, 1 Jul 2025 11:12:04 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
CC: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>
Subject: Re: [PATCH 0/5] crypto: qat - refactor and add live migration
 enablers for GEN6 devices
Message-ID: <aGO0dJKLcRs1NsD+@gcabiddu-mobl.ger.corp.intel.com>
References: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB7PR05CA0015.eurprd05.prod.outlook.com
 (2603:10a6:10:36::28) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SN7PR11MB6773:EE_
X-MS-Office365-Filtering-Correlation-Id: 850b972b-89b9-4e76-4ceb-08ddb887bfd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OTY0V3hMYkY2RlpTVVZPRGJqa1RtMWJIQ1FtN25xRm9yeXFNR081ODh1RGdv?=
 =?utf-8?B?SE9Ec0VzRlluWEtpZUZ5ZnZOMGRXVkcxRzlJOEM4aWVaaFBJMXhKYVhBMEtn?=
 =?utf-8?B?NTNLT1RZbnFKMituRzVXVG80WGRRdnI3ckZKQkNRNXA4SVdFUGF4enB1Vkp4?=
 =?utf-8?B?empWN3FBSEF1ZDNJOVRqVXd4a3ljMklrL3FHZGxVb1BiRFhGRkJtd0R0eW1H?=
 =?utf-8?B?eHlMR0JLSVJkUGRyRHNCTXNqMkRlMUNGRGdwOCtnREN1Tm8vMGdteE9JQkdk?=
 =?utf-8?B?RUNxS3ltNnhncnlPeHFjSnpoelk0VmhwNFp1QWQySlFTV2YvVG9Oam4rcW5W?=
 =?utf-8?B?OUl1dkxRcGVQNzMveFZSM1R1Q05PNkRtSlQwdWQxVDNaYlpXRmUraDY5RjNq?=
 =?utf-8?B?RDM1UXlrWEZ1ZkI2WFVSVkhFdTF1NzBkamUwQ2FIK0E2Q0RaeEt3V2dyRG1j?=
 =?utf-8?B?QlEzbXVkSjgyZVoxZGJBQ2hQR3JKTnpjUnpjVy92enBweDFaUjhmMVJJWnA0?=
 =?utf-8?B?cFNqcllyRGxjVjg3SWFxVEJhOGRuNlNYZUY4aGlkdXMyQlBubVJ0a0VMR016?=
 =?utf-8?B?bEdIWktNK2FVZHBJaGxvLzUxc1hHclRyR2lGcGgrTk1BQnNCQS9PbnlQdVh5?=
 =?utf-8?B?UkQ5czlremt6d2c4dmRuQWRjKzhvTW9WT29qSEVpMkRmMm1Gam4xOG5jTHNs?=
 =?utf-8?B?K3JBTTBUM1IwdWhTVU50U1AvZURpS1MremNzNHRSNVpRWkRCSlU5QmdyV3ZE?=
 =?utf-8?B?RWM1OVlEWTJWazZaN1RsS0E4QjJ3bUxKYkFZSVFLYjVKdGRja2V1djRBcE1u?=
 =?utf-8?B?SEc5OEp6cVcrSStteU10V2VqK3pJa3FCRU9SaUxaMGx4Rll0aVN6b0Q0ZDhU?=
 =?utf-8?B?M0VONmdsM1FQTWZHaXZuV0FGQlkwQlVHbER4OWRNTVhwT3MxWG8vWGxBTnJ4?=
 =?utf-8?B?WFZNbnUxa1Z3bWlicGs5N1FvVFNodXlROHVHUlFndDQ4K2pwSURwbXNIaVpj?=
 =?utf-8?B?Y2prWktjcHlQQmVPNW1qZ0dGNFc1TFdQVEcrb213Vy9hNjlrdW5QQkd0TS9q?=
 =?utf-8?B?OHRSN1VlZXpNRnhtdkhYakV1QlNxYjhaMVM5cit0dFNpYS8zVmhkZEVXcUNm?=
 =?utf-8?B?RUhEOFlZQlkzWjdvUktZZi9tcEVvMVZTTVVBQ3g4WkZaQ2lvSGUrR2prUUR5?=
 =?utf-8?B?ZDF3bDFWRldWMDFlU0JMUzFTbjMyQVRzU2JLU0hROXdrYzd0a2JFeEQwdVpm?=
 =?utf-8?B?Z0FmTlJZcjJlbEwzNUl6UDdTeXdzdVZVNFo5cDdVMm4wT2F6Ym53VFdGUllO?=
 =?utf-8?B?b2k4NUQ0TVV5aVJzaXNVMWk0dWNQdkppU1FYYzVjdDR4aGl1UGRkcXhIaXJn?=
 =?utf-8?B?N3ZjdFdWNU9IUCtKSjJvcHRmcHJ3aHhibVZQbDd4MHVJbXhwSmpla0hsODBx?=
 =?utf-8?B?YS8xYlJ3Y1V0OG9SVmo5bW9GUkRZc00wcU1XT2dHYzE4cEtkU09XeW9FNWJr?=
 =?utf-8?B?dkxMOUh0aVY3aWxkVCtOZDFNUDQrKytkaE9ZOElLVjFUdzNuWGtuYTJKcExD?=
 =?utf-8?B?bjVzUzhUSEl4RzB3MHk5Q2cwVkdQVG96QVdCT0YyT0JOK1EvVzFhL2QyQ0xr?=
 =?utf-8?B?TVdUY3pFcUZ1R09lQ2lVTGJUVVYzV1p1ektyYU54RncrSDJrWTB0ek0wRU96?=
 =?utf-8?B?Nk9KTFpJREppRCswV1VNZ1BlOEp5bG5HdkZKUkRBSVZ5S0dIRzJHclJjKzcw?=
 =?utf-8?B?QVMxekMyc0hxTnFqekFFZzB0ZG5QeXJrNDJ2dVh4Z2NBKzI4cFl2SU5UTGJm?=
 =?utf-8?B?NjBoMTV4VVNjSVlyWHM1T09kQlEvdnV0RHlpN2JiVEhwbmpFa1NFWUc4TUYy?=
 =?utf-8?B?dzVWRU9lenM1d04rTjZ5bGtUaCs5ampHRUhKYzNHdmRhd1pheWhIN2hDcWJk?=
 =?utf-8?Q?cCEikm7bs4c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0UrcXZyaEhtckdlYm9lSExiQTd5MFFNZDBxdXZMVys3WWw1SGNXcUZsK0Jh?=
 =?utf-8?B?RjQyRmc1OUdFWUEzUkV3VDFVRlJVWFFqcVFNL0FObHUrMlNNSU4yRk84UmZT?=
 =?utf-8?B?UVFOK01wODhZYUhTMHp0Tm9DcnVHcURJVkJJbWxYanBsbkovVU9kNlJOOC9Y?=
 =?utf-8?B?RVNmb0JuTlZ3Ny9NMHZ3V2dnQ3JmMVAxbkU3b3Q2OTNiTGM3c3dtMng5ODJy?=
 =?utf-8?B?Z3l4R21NV1NOQ3dqVXBCVW94U1VkZzdZMStuRmxGU2padDNGMEdJMk5wWHc3?=
 =?utf-8?B?M3hjM2ZnQktiaXE4UTJhZVdDajlBc3NNNTNPS0RwTWhDaUxHekdjaGNHQWFk?=
 =?utf-8?B?Tnc0bkJYU2xRQ2VvTWd1bFAvTWE0cC9IQVdnbjk3bnpLYUxUL1JhRG0xSkNJ?=
 =?utf-8?B?MlFFT1VINmk3cHNHSW05NGJ3RHF4YWdkd1EzZ3JFdlFULzRwQXhSYlNZS0xH?=
 =?utf-8?B?Tks0eFV4MURjUWg5VkJKVmlzV3d6TWZqWG44ZDFuenZjMEZ2UU5ob0NkOXI2?=
 =?utf-8?B?bkdmYUVzYmJjdEx4Ti9ETjhJUW1INmtPMmNJaHZUREtFbTZoelZUa2U4VmlG?=
 =?utf-8?B?MDRlQ1ZHN1Z0N3lVRWhacUFiWU1OY29tbG5kaEhwWHZmNzRFd1FlWHFFSmtP?=
 =?utf-8?B?TGxDVDRDV3FPczY1T290cnowZTZWWG1RM2VldFRYaXpSZ1pTaFZFcVliUzJ6?=
 =?utf-8?B?Z3VXZWJiaXlVT21CRVR0TzFhMTBBSldDejFFSFYvYnRYK0k4SStVeVBaQVo5?=
 =?utf-8?B?RUV3Z0xUMm1haTA2bVgxcXFhOG5DLy9rTVl1a2hQeXl0dXVxc2k5cUM4Z2tF?=
 =?utf-8?B?ajVFV2hzUitPUUZPZGltL0MxSEJhOWVqd3dNMkp2Q1pUa1AzWS9iT0s5S2VD?=
 =?utf-8?B?Vy9UOGNyNGJ4SEtSb0JVRXg5czIwZXhGVXVZVmk1Y0hQTytua1pEQTVZRkg1?=
 =?utf-8?B?NUZTZDVVUzRleXF0cjFuYTE3d2RpVktSaSsvV29rL0lvcU1ETHZQL0RKenBN?=
 =?utf-8?B?cEttb0h0Kzh5dUZ6dWsyK042Z0c3N2VQQ2l6T1ovbkZSbzZQOUhKSmR6WGwr?=
 =?utf-8?B?K1BPaTRGdHBIcGdCeGpoZGNkZ2hrN2JoQlJKZXR4bjZlSTkvR09qL2pkc2VI?=
 =?utf-8?B?K2hLT1pOKzJCTGJvYWl1NjVKZnN6SWFhMUFraVBwVENGUzhHcS8yeWcyUXV0?=
 =?utf-8?B?VG9iSVhmVjJ3UzRIRVR0TkVjTURldUgvYUpKSUNnMXUvd1pPVWFjVXZTNlN0?=
 =?utf-8?B?WjlNMDNzK3JEdzExR2taL0d0QkRWd3lrUXJCU1JqdUhPTG5pY212Vk9QNVBr?=
 =?utf-8?B?MXZnamtCcDZIQ0luNXh0ZVRWcGdYQmVHZUdnRGQzVU9pZ1hMN2tUdGNpcVdH?=
 =?utf-8?B?bWpvcndlZDIxUzZWbGVIelVsM0F4NitBVmpDb0d1ZitEd2c1ZzhYVkt2TFNL?=
 =?utf-8?B?Nkw2QncvU3Z0M3Y4c0oxSDZwVlFVMWdPSzFJQlV2dWRGMnFjSEMwNVJXbllt?=
 =?utf-8?B?VUpJamg2T2xUMFhkOWR4bEVuN2hwYXR6dENQaUdiYW9MOUVYajNrUXQ1RDFS?=
 =?utf-8?B?aGVnc1F5OTJzaVpKaWNtZHRZbWE2czRjL2hzS3hPU0Y4SXlnb05rYy9VNStl?=
 =?utf-8?B?ejhtTXRvRXI4V0Q0K2J4eG9QWjFwUGFPYk5kYnhIb0hlTTZVeXdFenpPNVY2?=
 =?utf-8?B?NmFxYkhFVmFjcjlSc0lOMWNIamdQd0FZaFoxSnI0Y0U1Nm12ZEgyMFVrSTlt?=
 =?utf-8?B?TXBoSlZkUlI3UWsvY2g0R1owTUw4QlB6bEdEdVlxV2l0YkpFS2hpV1lLNFJU?=
 =?utf-8?B?bWpCZ01KMDlWWWdycVp0Y25ZZ3dPOXUwRFJtUzJ6d0NFY2V1VFdSRUovdHdn?=
 =?utf-8?B?ckVkWUJIYzJGenVzZlMvUmVlSDR1blZZdXdDSTVCZG5kZndhQ0drNitpaC9F?=
 =?utf-8?B?WmlzT0o2eXl3QjBycExxZ0pXekl2YXF0QXhCd3lGNGhtTkNiUDM5b094Ynla?=
 =?utf-8?B?KzB5U0tmb2JEQVdCWU5zdFpDQ09TU0tqdDZCRGJDWE4yUlZaZXB4MmRPL2cx?=
 =?utf-8?B?VUFpeGZPekgrS3lCZi8wOHR1TWZZMWFPR2J3bExQMGpNNHh0VXpIZFMzT2Nn?=
 =?utf-8?B?RlhGbVFKN0h3czhqRnlWQ2tDUDFlUHdkZ1hzd1MrNHVneVpxdnVKQlEvSVNj?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 850b972b-89b9-4e76-4ceb-08ddb887bfd1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 10:12:13.7693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2a5ng2U9XvoMSxPZFzMmHruHedSUmltKJIdF6s/BTbJ3oqKFPPpRYtaEl65ASvtRk80gTiB/x20eImDdJcLqkKOcYfOYULnqJExSyhy5V0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6773
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 10:47:25AM +0100, Suman Kumar Chakraborty wrote:
> This patch series focuses on adding enablers required for live migration
> for QAT GEN6 devices and improving code reuse and maintainability across
> different QAT generations. The changes include refactoring shared logic,
> relocating reusable functionality, and improving code clarity and debugging
> support.
> 
> In detail:
> Patch #1 improves logging consistency.
> Patch #2 improves state checking logic.
> Patch #3 relocates bank state helper functions to a new file.
> Patch #4 relocates and renames the bank state structure
> Patch #5 add enablers for live migration for QAT GEN6 devices.
> 
> Małgorzata Mielnik (2):
>   crypto: qat - relocate bank state helper functions
>   crypto: qat - add live migration enablers for GEN6 devices
> 
> Suman Kumar Chakraborty (3):
>   crypto: qat - use pr_fmt() in adf_gen4_hw_data.c
>   crypto: qat - replace CHECK_STAT macro with static inline function
>   crypto: qat - relocate and rename bank state structure definition

This patchset was reviewed internally before submission.

For the entire set:
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni
