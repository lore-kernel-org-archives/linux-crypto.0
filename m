Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A543C1CAA4
	for <linux-crypto@vger.kernel.org>; Sun, 31 Aug 2025 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669772; cv=fail; b=oDiAHDECt3yaXb4BCLOc7hFhle+3WgkMsXnqTlrhHzEpa8lFVd0ihFffdln9aPZwU3ngYi/mBYFABE9jWTlv8pl3p9kK5mbAdIBS9+5mrahd8NOLfJEx25il9xxAQ6whURGvowdE9Sc5kDf+oOdzx7FZJHG9MV39Bxx9njJ8BGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669772; c=relaxed/simple;
	bh=Sj1UMguUrSWO3SjWemnABkhgjws1YpGpnD00/ZQll8k=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=d6qaM2PYJxyvBaKsjvZ/XaetshN4lJVfzqyRPj8pYvuQIQ0F++0cVzSOO8D14PoXMWFQoefAmtul7u7zthnmXq4LI1tBSW2RnedWhmk0LpFe3JRKN1GDvMT3O4QSkvbXvKcROWMeuuYXt/hL8d2l4An47PJhe39eTv7Ujbc8a4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a8vGKgMY; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a8vGKgMY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756669771; x=1788205771;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=Sj1UMguUrSWO3SjWemnABkhgjws1YpGpnD00/ZQll8k=;
  b=a8vGKgMYQqUCrDSpcNc0qmInB97HlFFFLodIXbC82Puf97iCrKA95w9W
   HWC91UzldX9rB1/VORXgiAUfa6EbxcQVp9Afv/KV9rfHbS9TouVvmmZXL
   bkzwZ84iCki90O+v7XpVRRuOVnfI7FrLWEb2nBjoFRy09ftb7VQiQf1a9
   ZLM7i6ipHu0v81I+4ATNrVDxjDJ3EdMsQC/DwD88GUVC+C+QoB095gGZg
   WUjoIAgG6kJpT43WxIwK/RoGY/Oi0Hli4QChR/ADbY/MM3+d/NICw3S6c
   Gk/fB/rnuEmuUCMPp0ARHBuRKaVk1uxEw++cU4VqeitZD7q+9BCfMbSX9
   A==;
X-CSE-ConnectionGUID: NKyFL6xDT9+KK1G/Vnb/xw==
X-CSE-MsgGUID: duWPGHB/Ro62lBOo9eKrPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58800912"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58800912"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 12:49:30 -0700
X-CSE-ConnectionGUID: NZAI+/1STgSNU8Opxye6AQ==
X-CSE-MsgGUID: bqt1YqsNQ7+OfsHjDnrprg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170969321"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 12:49:30 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 12:49:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 31 Aug 2025 12:49:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.51)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 12:49:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TB4ShoY+65o7ctDnuqHVd6Yd2OUPb8MTbaw9pjq2E6UIE+I5eS4D+730lpv7Z/O7h5NboNHbsJ3wSw6zkZyzEH0SDGc/LCUR6makpB/T81QoWH8drmXu5qxQp4KZudskMgDHtGisAKvilQD09IuHQuZPZQy7sKWkPCY9AJ+1xS4tCULoTW7GuIWoNVwOdDVjqCgPnFCbh06i+iWbbgnXqUkLkuZdXl19I2RuWBLbfLHhjgLFN9IiM8cKxJzQmDQmfaPZTMUkHzH7chAkiKbcHF4nAMiYwNhXEebwn8nARe+LkaM34uhxO7ovHAdxxA3QKdD+Qcbkd0lR/ZxzKaHr3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtDHJLF4drIIyzctBlexJ8x+FoKuTMC50aB2VHGzC9w=;
 b=eDpxNeIjRHU0VNfMqK9HnSWR0qiuaBvOLPgT5YTvFgeiB+SbVi+aAmaZbAQouqsOO0hV4FIuQVSVZIaRDwXBOcLM+SbG9KO8h5vrax2F/nibTGBx7EK7Ppbeo8lvqPOK9qYYJA8MF516kuh8PL3yQZHRGa6w9rq8+OfRU+Kwqv7E2cD72m/qBqtgtzrM0Xi+p6p039m7fdgW+O1sbAtdtIuPMpF9KJ+wpwWn8aIDE6ZrOxvoXOvzNMQtDvgnJQMKk2waUhqGL+WGEPe0n9SDrifqVa+Uh1yJIakNrRJ00ddbwx7BchGbV9FOSvviQwDOjPm4FHKP+BeYFIzC+0L6aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM3PPFD5EE188BF.namprd11.prod.outlook.com (2603:10b6:f:fc00::f53) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Sun, 31 Aug
 2025 19:49:27 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 19:49:27 +0000
Date: Sun, 31 Aug 2025 20:48:25 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: <herbert@gondor.apana.org.au>, <ebiggers@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: [BUG] crypto: shash =?utf-8?B?4oCTIGNyeXB0?=
 =?utf-8?Q?o=5Fshash=5Fexport=5Fcore=28?= =?utf-8?Q?=29?= fails with -ENOSYS
 after libcrypto updates merge
Message-ID: <aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB8PR06CA0029.eurprd06.prod.outlook.com
 (2603:10a6:10:100::42) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM3PPFD5EE188BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 4549d025-57fc-4833-b316-08dde8c77e32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VXVVaWdYSHBuc2NNR3V6Z1pKTUwvdmxRd3JES2NJcjEzUGFIS1RkbU1nRmV3?=
 =?utf-8?B?Wi9HeVoveHEwaWVBRi8zVHM0a0Z4dFZsYmUwbWRVT0dtWmFCRUtKZ1haZDBp?=
 =?utf-8?B?c1RDbWcveXY3TkdBSFpmbFRhRnVWZDhORUhHMW1nTVBZSXA3QWhKUFZGUmcr?=
 =?utf-8?B?M293YmR1UnVPSkdBbWk1OEJDeGJ1UFQ1M0crOTJTSWZzSTZKS3FWcExuRFh3?=
 =?utf-8?B?b0RMeGJhNG5DR0drYXFpb3VLci93ZmN0Q0t3WXhIV2pKVnQrU3dydDZBUDcz?=
 =?utf-8?B?QWREbUNTRkVkUGthR3MyTnZaUElselQ0WnlvV2xuTXgyeHNFeUtzK2lJL0dE?=
 =?utf-8?B?TU1jNjNnQjVWdmw0bXNhU2RkZUVERkpLVFpabE1lTy9iSHZuaFNoQUc5OHl5?=
 =?utf-8?B?SGQ2Zy9leFpJY3M0dVVPRnpoelFVMVZncXdOMnVxbUdEYzRIUzd5SXA1L2Rw?=
 =?utf-8?B?aDVmb1Y0MkRINkJLK3NMYmROcGo2V3pscnk3VFMrZGtuSk5VMHMwbFlpaEpF?=
 =?utf-8?B?ZWFnOTlRWk15SmU4SC8yWDIvREIyUDYvL01jM2tkMCt2S2NDWmswTWF2aXZ2?=
 =?utf-8?B?YTgwbllDQkdpWkZjS3kxYjVxbUpHa09YNWJmZzEwZGFjK0UveFQrZzRrQzhF?=
 =?utf-8?B?MkpOMktpOEcxRDZueGZVWmFKU0E0dVd2SlBwdStlNmxrK3RDVEo3SHhDZ3JR?=
 =?utf-8?B?alM3TlpldHYzY3VxeUNqY3BwMXY0TGdveTB4N2FIUmVkMEJhZzVpSy9OYzBo?=
 =?utf-8?B?T0Q1bjViSmVwNEhZWUdRbXpXMFpYRFUwZndSa3ZaaUs0bkVSdjREdzJKV1Mx?=
 =?utf-8?B?T0hQUEQ4OFM5R2ZZVENVMUg3TmxzcklDcWVSRm9CSWY1UDFaQkZtQ1IxR09S?=
 =?utf-8?B?YnRORmRHcVBIRGhnNTMvWXBXZ3dpenVobTBubEpaN0hMOXJBalJza2QzdXJ3?=
 =?utf-8?B?RUFJcGZVOEZTS2NVYTBhR2ZKNFVyQ3hYc0dMc0lWbjVkclQvbkNzVTZuSUpm?=
 =?utf-8?B?cnpSSlFqNitOMDBQYUV6cXFNRDkyRFBxY2VtSXpKUnNiRGF6UXk2RFFGdlBP?=
 =?utf-8?B?UWR3cW5IeWVvU1hHQXQwcWdhZzdHcXhKS2ZRYnhqWWRCSnllWm93d2JUTC9z?=
 =?utf-8?B?czVvczgvQ2wwdzRsdDU0K25hOG16KzBjRGZPRjRqeW9vdmhyczE0dytmSWV3?=
 =?utf-8?B?MHZRVE94N0lFRzFUbENUblYwZzU1ZGpiYWRwdkwvcmFSV3UvMkFsWHZkYmln?=
 =?utf-8?B?WkxkZnpoTFdwT2dTSWFUQURsZTZzWFFJV3FwcTY4UXJWbnBJSkpLMStzeFFs?=
 =?utf-8?B?RGNLaEhZdm5LVHdvMnlQZ0tGeFBHUXI0NnAxL2pJM2FuQzlJdDNCNTM3ajhC?=
 =?utf-8?B?RFpMcWN4NURCNHdrdm55YlBCR1dzQ3JhcGlXdTZjWThoZ0pZWmVmekNzdW1R?=
 =?utf-8?B?cHlWSFNaSCtjSDhjNnVSSlZSUGpPSHFmWmlkMmY2S2VDU2NTcUUrUmFrOFFl?=
 =?utf-8?B?SG5sbGZJaGJWSCtvdDNOMHdiWnhOenY5VEl0dzhwRXBhWDJyL0pCNHVrT1dx?=
 =?utf-8?B?dnZkNzNrSFR4VVZrV2VXWTBjUXF5bzV5WXlodmhMYmcvRzRQRTRvQUJEaGt4?=
 =?utf-8?B?b0hkSTRmajhrZmJJbmZPVERwU2VnWWMvUE5WeWo4SC91WE5hNVBzWGZiRlJp?=
 =?utf-8?B?K1ZWTi9iUWQxbk03R2pDMXEyVFpZaEtTK3g3RnNDZG9ObzZZU2tGaGk1MXRw?=
 =?utf-8?B?RGF3RWtPT1lCY0hRUzVqbkNQNjh0WVBVdXR4Mmxna09QK2ltcTZ0b01FU3pR?=
 =?utf-8?B?a1NvT3RnYmZMRnJ2enBZM0VGcm1YWW1sTjFZVE8vS3A5akppdHZKUnAzN3E3?=
 =?utf-8?B?SkZPMGRDdnJBMW9QaXJqa1hlekp1NTM5WUdxRjFZdkw3c1VhbmJCSUl5YUZl?=
 =?utf-8?Q?qtOm3Amn53E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUxsem1yUGR0c1JVWXNJaFExVml2NURFWlZua255c0JNUHVXT1dOSFR2Y3BU?=
 =?utf-8?B?OElWVmZUUzBBeUovTDlMbFc3emRDc3VVYUhidTM4NXZFcmcvNEVZMmxCOHIv?=
 =?utf-8?B?RmdLSG5aKzhRR3huRXhVdEdOYVk1UkxVRnYwaGFtbnF4c1l5UThZaWs0WHFH?=
 =?utf-8?B?RkIwbE8xMU9SMjR3YXYwbU1DSW1tVkJPU3JjVmlEemxkL1JLZWZhTUZpSExv?=
 =?utf-8?B?M3RnSDJ4VCtYRWFzeE42bHdGS1g0WU9pTEdWcDNaZURScTJlWjI1dHdxQXVj?=
 =?utf-8?B?ZWdDWm1kYWlSWmdSTU5OREtCZkxJWHJjZFBMYzE4NnZBNENBNUJTN0YweEk5?=
 =?utf-8?B?K3NaYkV6WXo0bGdZanpCVDFtcmx4V2lLL2tLTXZVd1hPTmphU3VISkhrbk9l?=
 =?utf-8?B?YWF0c1c5b1p6RERQN09jSHQxTlJ4R0ZYc2tkOG1PcUNKc1p1czJDcTJadGFO?=
 =?utf-8?B?ZzhCbm5Cd1kzTVBLN3R5cWx0a0lHVm9CYk1sTlFIdWxsQXN4RmkreklYK3BX?=
 =?utf-8?B?NlhaMUhSQ0lGMS9MbXBNai9MQ3AyaGFQeis0UHhtS3N0c2Q2TnVGRXJQbmhw?=
 =?utf-8?B?UWZ4ZWcyMDRsVGhSYklLaVpSUzN6MFoybkhPOGpMbmd1STJSUk5Od2JmMVo1?=
 =?utf-8?B?YUd4WTRxam1NdW5iWXpFeGpFcWl3WEJJcmVxZ3dienlzeHpxMjBXSVJTRDA2?=
 =?utf-8?B?THQ5bWRuRTZ6cWZNTllBY3RTc1o3aHVWVzBkNmlxajZDY0w1V3FsVHRhYkFy?=
 =?utf-8?B?NWVTbVhKM1BKenZzZW5nN1lrWUVPTVNyUGdwdDhmb0Z2R2E3Z1NCMC9PMm80?=
 =?utf-8?B?S0M3TlFYYlMzRkJRQmxMaStJc3N1SzNuSWJQd2ZlYUNyZTBLbHEwUnp3YzhT?=
 =?utf-8?B?MFlSV0tRdU11UDEwdWNkdnhoRlU3MXdvREQzUFE3MElaelM0MEt4UWVJWFBt?=
 =?utf-8?B?Mk1kdEhWMXhhS0lBYUpPWXRMZ2dxRUJJSkt6WVNsZ0x4Y2djeGFFRk1NV3dV?=
 =?utf-8?B?NzF3bW5KVERPTHd1MkE3d1RMN0Zac3pvbitEeWpzemZHL1NrMlE2R3BZYU1z?=
 =?utf-8?B?TDhZVktkVHllcnEvWE5zTHBrVUVyNHRBMDJQN09SNElkUWpFVCtkM0NHbUtB?=
 =?utf-8?B?azY4WUw3SEhLdHRaMHY0S09KUEEzVmxHSi9hOEhKZGZLM05wR0VmT2YxUm0w?=
 =?utf-8?B?NFZSaE9MTHAxUm1oRElpVjlBRDVSZTZ1dlBYR1h5SnhLMzZKNzFwUS8xaGdO?=
 =?utf-8?B?UEVCcTZpSGxqaXBnbk9RcXlJSWRpR1FBTWV6VXVyZmJjaUJhR1hTZVlIcE5j?=
 =?utf-8?B?cFZMdGRSdlAxZWZhUGpWVE5tL0kxaVhQY0JpdzhVaGVxYnZuSmtDbk9LVTVN?=
 =?utf-8?B?SlVFcFdoQktNTDJmZUVSZDQxRUhxeEZnL2o3V1NoYTM1eUpDb3VQM29GUzUw?=
 =?utf-8?B?Mm5FZnVFWmk1bG5vdGdIMURtcVdSTEloSjJPNUZKcW5ZUFphU2lzVW0zL0xt?=
 =?utf-8?B?aG1nTy9ORmV1eXBBZDZ4Rzh6TC9CVnNnNGhmaSt4cFNyMWU0YkNnRndsLzQ1?=
 =?utf-8?B?cHpSV25leGh4eUFnSWFHMGFwTE8za2VoOHQ2WE00b3NtbTdkVEVjVnplNnN6?=
 =?utf-8?B?TnlGZnRaNFlBWHJac3p4ZzdLZGxVYU1hajVkVW9WTHRRdUhDSFExRjBFYVV2?=
 =?utf-8?B?VTljYUM1T3krZnFlWUEvMGRRMzN3NDFBSlBWc3JIL3hWaW9Ndy9UZnVvaENJ?=
 =?utf-8?B?ZU14Z1pKTTVFU1RlZXMvS2sxZHpSeThNT0F0SXpKay9xNmUxZjBKZXhSRnRU?=
 =?utf-8?B?YkVjMlI3N0g5TmhEa0RBekZUaGFnd3U1V2hMZ05qMzJvM3N2anVIU05taXVM?=
 =?utf-8?B?VUt2RG1WTWNGQ0ZwRll5M1h5MTRGNVhrWXVOaFJMeGIremhVckl2dGFLZ1Rk?=
 =?utf-8?B?d1c3RHZ5RmdTRWdJL0VCUkV4M3hRWDdXeHVObW1MMk5DajNucG9IQ2ltSllP?=
 =?utf-8?B?M0xpM0lEempZSHl0bnBOenc5ZVQ1L0NMZVNTRVExaDRuWDhpUFpCamFzR2ht?=
 =?utf-8?B?U0J0QVRrTXljNFNqeDJQbnlrUmhIUTJMcVZxQWRQRSt0MHRtdEpYakVKMTEz?=
 =?utf-8?B?N3VUVUFweTQ4aXVONjMwdUxjYlJMK2pJS2htdGdjYnNyQy9uYkJKWlNIOCtT?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4549d025-57fc-4833-b316-08dde8c77e32
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 19:49:27.1540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwig/4Ari2vjMCSfaMx/1z/cqQ0peprnaQkax19b+ftZ42ORUb/Xsl630c8Pb5oDcK1f7zYKO6sXcGthL6FxJOJftcUXj33dvIWQEREs2yM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD5EE188BF
X-OriginatorOrg: intel.com

After commit 13150742b09e ("Merge tag 'libcrypto-updates-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux"),
crypto_shash_export_core() fails with -ENOSYS for all SHA algorithms
registered via shash.

The failure originates from shash_default_export_core(), which is now
being used as the default export function. However, this function is not
implemented, resulting in -ENOSYS.

Before the merge, SHA shash implementations were setting the
CRYPTO_AHASH_ALG_BLOCK_ONLY flag. This caused alg->export_core to be
assigned to alg->export, enabling proper state export. It seems the
removal of CRYPTO_AHASH_ALG_BLOCK_ONLY from the SHA implementations was
intentional, is this correct?

This issue breaks all aead implementations in the QAT driver, which
since commit ccafe2821cfa ("crypto: qat – Use crypto_shash_export_core")
rely on crypto_shash_export_core() to retrieve the initial state for
HMAC (i.e., H(K' xor opad) and H(K' xor ipad)).

It’s likely that the Chelsio driver is also affected, as it uses the
same API.

What is the recommended way to move forward?  Should the SHA
implementations reintroduce CRYPTO_AHASH_ALG_BLOCK_ONLY?  Should
shash_default_export_core() be properly implemented?  Should drivers
like QAT switch to using the software library directly to export the SHA
state?  Or is there another preferred approach?

Thanks,

-- 
Giovanni
