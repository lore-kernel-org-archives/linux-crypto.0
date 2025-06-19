Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F76242923;
	Thu, 19 Jun 2025 20:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750364526; cv=fail; b=UNQ4AJ0casCmLhRwVT4H9ZjXmpQiGGg+LSayQc/QFhsZVhQwfYOGAb6Csfnw/1ke3gGQTcJNWAhA5heJjcM9HwNYZTWVpSzacDRijPYHhBjT9CYUfz1B8YfZjZmNyYOK+AS7CjAmmv/JcukW5m0RSp0S5nCBdZ3XSKsMTkhI1CA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750364526; c=relaxed/simple;
	bh=LUnnCKjFK1XAtC4qkk0FduA3GLvaMpoSmugb1Zt+2WM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jxtLfibayhWMX+6qg1cMtanYo/m4enr8qE8y1pm5fccGY+8JMrNAZI4h9DfKbJmNKc+eQR2aLsurn06dncrkCRiZ+vkUizwRqs7JMgScNIpmXwpYei55XCNgO+ESPDTYivCOpUpPwJrkIuPyAbwo5QeL0D2VnaQGY/a5GiWF2e4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OQx1MtdF; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OQx1MtdF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750364524; x=1781900524;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=LUnnCKjFK1XAtC4qkk0FduA3GLvaMpoSmugb1Zt+2WM=;
  b=OQx1MtdF6JCwbhUo9bsCBrtWvrTg4iCeeJG0qx0vAAzCN2cuXKl/q9T3
   nxESc4Sa8WFBbjLrwQJ2Cm/dlzjeiYAJwKOXgsKTV2eWTV+OKg0/jIHY+
   k8p2jJ4wjYQvuWmGNMFAXIBjMtqxNhmxk59mkAgS1CYWudfVV51Dj1E/5
   wNcGs436rXd0Brp3bFFf5lEbAKLKmMnBg54svKzcWbHGUzxsLmMq9ylL2
   UgYGHs10Lr9miNJPrEknQK2w+Sf/AF3UwmsbzCJoYGYdbXW37ukt23wUB
   waItiwb82y7GWBlebuXZiZ48jR7FOaxrQjMA5EOVJhvW14VOsJE2hhsYO
   Q==;
X-CSE-ConnectionGUID: brv9/zl0SiyE96P5INTGYw==
X-CSE-MsgGUID: 6BNv6WQKQ86HknF7L4iJ3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="70189289"
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="70189289"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 13:22:00 -0700
X-CSE-ConnectionGUID: X1HldhNHSV+jmxKVIZr1xA==
X-CSE-MsgGUID: ZgVpkpP3T3arqlBjXp1a4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="154742856"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 13:22:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 13:21:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 13:21:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.53)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 13:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/a68s/dhThlme7SN27E8LQnYz+xFoOYe+sU/MLQt/BBT51EzuU6cWDD/k4BrQy2NEqo1cy4CamgF92rPQYkUqxXnXEaEQ+NlSiWxsfr1WgIR1MMplSNyvigqtu/aIJs5NNBV+NQc1WcckJN1FvAbUoiTjAlfjVV9WYV6p4//f8TUVbyTjMh3QuBX/KCqBCauQi6OLpx9BU1zUulRp/vBh0wH0DgoZDjcS0i9b6mkPPfiY/43D7obHoqNUlfLj/KoJPbWFwf9yvLsAL6LzbF8KlOgbEkoOgvsW7WZDEch9ZZ7BieX9uuFFkHhNNzCOanD/3jwayj1KoINCq5IxcN4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hr1t1pKU3Dy20aC8kONdRZKSEOVWh3s4EDjk4gTsxrg=;
 b=xuCrArDVVRj995cYCvbVxuM50SrJoKVdzpyD9HuFl7agcfAWs3htCtVuyUcuH6G9bIofEDNEaPl2rBjP4APH5uW2YfDoBeH5MJD5EmE6boxyBunqtiU9nSf0tqnQUmHHWjB4QQcHVtkZ4x11TtsbW1RPerjXpNcjZNw3F8Gw3fDLB7r9jdVSWVqMya8xozzuQpJl9lnGBUMoJEQZ1qXlimojlVazXx1OZjJJanpA5iXoznugQDjzGA1F03lWTnBatRAVY+kgKxR22WkKPOYrgkkf8Ubz+CvRIKqnbGJM5Odp4WDfHI3/WpTejA17jvsONXrbrTSP5ODgWOfbX0onCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA3PR11MB9350.namprd11.prod.outlook.com (2603:10b6:208:574::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.35; Thu, 19 Jun
 2025 20:21:53 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8857.021; Thu, 19 Jun 2025
 20:21:53 +0000
Date: Thu, 19 Jun 2025 21:21:46 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <aFRxWsDS6sIMFgIy@gcabiddu-mobl.ger.corp.intel.com>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
 <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
 <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>
 <aFD1obs5rQaMLA4u@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aFD1obs5rQaMLA4u@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:550::6) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA3PR11MB9350:EE_
X-MS-Office365-Filtering-Correlation-Id: c6863a4a-55e3-4592-d436-08ddaf6eee2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2tudEg1Z2NFMlVoRlNQREVnNnNVRXJRMlptSjVsZjFYTjA5Q1Mrcm55QW1O?=
 =?utf-8?B?ZzlQWjNtc2NPT0NGN2JTOUFBQ2V4NjlrN1R6bTBSZ1MwcVk0ZW1EUnJwTmZD?=
 =?utf-8?B?U0c1Zm4yZlhDMnMvZW5zSlMrRzcvaEtseEVXcjJ5MTJVUzRhUTFvZGdac3h5?=
 =?utf-8?B?YjVKY3cvZ1JMVmwvWDdpZ2w2OUNaSG1TdWQzSzJKUVpCWnVRZlZYdUc2QkRs?=
 =?utf-8?B?R0VTbHdYR2JzcWpCZjlVVVpTSXB2SUVnOGYzR3oxRzU5QWhFOWo0TXMyQUZI?=
 =?utf-8?B?bml1YUtOci91aEFtZi85eDJGTUx3TXU3ODFTYkk5ajF3dlZLZEdqRVFpRWZr?=
 =?utf-8?B?ZlJkVjVKNHhwdW9WSEFOYmlOUFFkZFptbUg0SkoyTjY5VmJMazBjU0ZYVnZO?=
 =?utf-8?B?UW9rRWZmMENOc3ZzVHBUWE5od1c0SkhWZUV0MkpCcWwzbVRjTzZhNW1OQU53?=
 =?utf-8?B?NmF3M0dCVVFXWU5LSDBpWmFDdFNGU1VWMFNKL2hIM01GaWcyRzlldlU3V0F3?=
 =?utf-8?B?ZlhDeTBUS0pNSnJJSWFSVmxIWFF6T3NMSGxSbWRWRXE1OXlWUFFmNFlKcEcy?=
 =?utf-8?B?VldFaGQrYmNlb2hIZWxiMW00cmhFRFB3UkRZWUdJKys3WWVWdUFLaEFjdDZt?=
 =?utf-8?B?dnlHaE1vMER6clVzcTFjMkJ1d2dGOEkycHZXc0I3bWl0L1pMckNMUzU5alVi?=
 =?utf-8?B?dWthMEU5ZERsYkZPRVpNcmZyc3pOODdPRHlDd0JCRmM2Q0NERlNYWm43dGRh?=
 =?utf-8?B?d0V5NzdwSDRUYkNRcFFKZnFnUk5UVGtYbG9GbUhRc3kvZzBHbGppU0NjY2sw?=
 =?utf-8?B?TkNzU3gwMEh0QU95dDFCbDIzQnRvWE1WcGZtNXdwL1hUa3ZFRnBDSytSdStT?=
 =?utf-8?B?ZWc5bk93UzBVcGNrZHEvbGMvb0wrUE1zYUNsR3QvWjFQQlR2ZUw4YStxUkhw?=
 =?utf-8?B?UnFweEgySWprTER0ZHBnNDJqQ0pIOWVKMHNVYjhlaWxSa25XNSs2aFljeGhr?=
 =?utf-8?B?ajZDTFdpbmE3LzZid2g2cnkwUVluT3BTZCthUjYwS29HWStLNytkN3BPSzh4?=
 =?utf-8?B?R05lYTdjcWdnTXhlSzMyRFJuOElWQTFuSEpEV2dOeEJHTyt1Q0k4YVJIZmI3?=
 =?utf-8?B?eVJoSEU5Slhvb0NBQmxPS2FXUVdYLzFkWlZJTVNIak1VUTVFOWRpUS9OZGFs?=
 =?utf-8?B?RnhPZExxTFZra1dPZUg2ZDE3T21DUWpqZVU5WTdzSzZjZlA5b3R3MWtkNG5v?=
 =?utf-8?B?c2ZEQ2hsWXN5ZzZIdWV0U3pOdklVYnZpOENEWXJzeHlrT0k0Z0xNVG9wYUdq?=
 =?utf-8?B?T2RyTjFMaEFkNlNRUU04SWRrd1dHTExSNzBFWGtjU2NOamFRK0RCdTRIaU81?=
 =?utf-8?B?QUdqZVlSdTNlL0JOamM3U2t1R3RSZGZmSnprMVpyS3Vpd2Z6b3FJQit5dng3?=
 =?utf-8?B?dkhwQnV6cmxTVVRvNGFTczZKZFlkZWJyemNESnpRRzZoVEdxWHVEMnEvUkhh?=
 =?utf-8?B?VUdTRzk2WS94dGVGL0R4d1U2YTlrQXJkcjhaRTVGWGVROVNLN2RpU0MvSTYy?=
 =?utf-8?B?RTduenVpNnhvZ2NUSkYxMXVlUExLTnpSdHIvL2FaY3ZweU9VaEUrQ3djT2FO?=
 =?utf-8?B?YnY0WFQxVjZJb1daSUR3WWExeVc2Y2JEb3FGQnlyR24rMXI5MlpUUmFxZFZL?=
 =?utf-8?B?YWdneHUwYm43Zm4zSXJ3ZzVERnpiTzNMSzljYUxRVjhQTm9VSThxaS91WVZR?=
 =?utf-8?B?eEhKVXNncWNsTGRYb0JyY1FZd2tRZGc0Y1dRU1JmK2IxMmN3VFJKcW5Fa01Z?=
 =?utf-8?B?dkRzbERDeE1hL2pWek9TNVZFaHE1cHlLellmZTllRzJiR1ovMUE0TkxkU2N4?=
 =?utf-8?B?ZHB5SUhyVkdIbEtacElNMTdlV05USkxJMkNwZmswVnlzS0V5R3c1bENZWGRU?=
 =?utf-8?Q?P3FqdMCQaKU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TExWcmptcjE2VUNNWUNEZEk0R0c3N0FFYnh3aFN5TWd2c2lPVzNhT1JOblMv?=
 =?utf-8?B?YUdCZjBZcFNkMHRBMVdtNEpSNExCNEx0bWxtVFdrejBGM1d6Y05XR1c2ZG5h?=
 =?utf-8?B?U2d5cnV5ajFZMTFmQkpYa2RvY3U2OUJqRmZEdnllNkN4dUtleWwvVVBrNHVz?=
 =?utf-8?B?NEtZUW15ZGFNWHVldWFBWndlRXRDcHhwK3ZIYmZjZlF1YU8zUWNBSjZRSzEz?=
 =?utf-8?B?bWlTYUxXd3Y0dnBqbXFXNTl3enh1K3BNOXpjS3V4NGplcmVRMFRBd2JkdSt4?=
 =?utf-8?B?SnB5RHlTclhYRjdnUVVRbllCR1Nya3dwdHlLb2dIeHdsR3BRWVFPZUtJaW9s?=
 =?utf-8?B?Z09kZ2lzSWR4eXB5Ym9MOU1pUXU3NnNKNnNhYWtIZzNCMnBFU1MzVXBLRi96?=
 =?utf-8?B?RWY5WGMwLzlDLzMrL2ROdnRkUkdDdGRibkVzblhkVkI3WmNLdS9Qc1pwN3h3?=
 =?utf-8?B?OVFQUlBmMlNndTlsbVR0eGUxRUkzRTFpL05PbG9DYUllcUp0MUNJUmFzZ1E1?=
 =?utf-8?B?SGE0YzNZQTlxU3BBbmxHRHV3Uk00M0FIRXFuN095Um9NWjVzc0gwU1ZEbWty?=
 =?utf-8?B?emdCdExGRUIxLzNzVm5jODdwN0JLaXMzSDRkb0hHU1g4ZXRQcGFiNExzN1Yy?=
 =?utf-8?B?Y2paYWtXa0YyQ3ZRa245dTlIR3N4b2FQK3N6UUtUVGF1cDZtaitSbk5IYW03?=
 =?utf-8?B?aUpXaEZ4WlAvYUlRY1BNMlpWWXRnNUZuYncxQmVWUUFEb01uOU8wOHRSN1hL?=
 =?utf-8?B?UkRUZjRhVjUwQVliSkFzS2tpR1hPd2swVU5EWXZ6NkZyQ2NlZkh5OVpDaXZL?=
 =?utf-8?B?NlRUZFByTDBxdzMxbm40c3pDOWZZblpaN1Bua3h1eGdvOGJwQStHeFQ0SnFr?=
 =?utf-8?B?R0VtZkFJWVppeVRUdHBzdjZzVVAzT1FFUVdXNFQ2bUtyUE13S0hwdGlETXZM?=
 =?utf-8?B?UUVKTUt2dWpzb2NPcm9yQWFpR1hBd1A1WFlMc3NXMkE4QU4veWk4VVdrdWNz?=
 =?utf-8?B?ajR3VGJUd0lQc2pUdTdxOXlGR05UNDJSc1p6aWI4UDdpSWwveHIwcEJQNm5a?=
 =?utf-8?B?M1B3emVnbVA0aFl6cTJQd2t3Smo4NGdOVkNNTHJEczYzRjAzN29reDcwRnd4?=
 =?utf-8?B?RnF3WDFRV0d0TG5ReXdnZDN4ZEc2bmhFajFEM1pRaEhoT3I2SGltT2xmWU1G?=
 =?utf-8?B?L1lTSzRxM3pwNzVLRDZ5U0poWG9wYjNURHMwOE04RWwvclQ1NUlnR2p4cFJ5?=
 =?utf-8?B?L2FNWFd4aVZIYlFpMjIwT1JaNnZWSk8ySmtkWkFTbEpnb1gvcG9UWlV6d3Zl?=
 =?utf-8?B?akg0NDJSNm5DNXAybWpKcnllaksreEFnRE9ZSEU4bWcyMXVlV0lJKzZrK1d0?=
 =?utf-8?B?S2tJVEVFeVQ2b2VuWXM0ODNTSFNXOFZXTXMvVEZkN2FmNnJrVkFnR2kvOERH?=
 =?utf-8?B?OUpjUEJVQXRWY2JYUzFHc0VCN1hmSEFpTG0xTHl4aUlCRS96aTJUYkVPUHpF?=
 =?utf-8?B?TU1BemFiTWg4aU1jU1pyK1JPM21udk5jN1pSQUFxcjBSMytmc0d0dzk4MVdV?=
 =?utf-8?B?aEdSM29ScU4ySjRJVTh2QVJUTVhMMVB2Vm5xRzROYnhLSTBKd1RsVjI1Wk9M?=
 =?utf-8?B?THZnQWw3VTN3RWVBdkQ5SVl2eGppTGpnYVF4UzcvZUYyUVJ6c2R5K3d0MmJS?=
 =?utf-8?B?R0RRUlhhMGlSRlFJOS96dE83RHl5ZThuSnJMWTE2OTMxTzZGdy9VMGxma2h5?=
 =?utf-8?B?elNIbHRmT3RFNVhmZityaHNQbWdBME5NblRzczRZWndocDFGME0xRTM1QjlF?=
 =?utf-8?B?T0hiYzEvbVJJMUNycE1TT2RQMGFhQ2xNTEcwbXFFaVhZK0dBT0xkWlZ4aVBh?=
 =?utf-8?B?YkFxRUk2MGdvR3hSSkhsVEExYlFBaEMrNjl4ekFScTE0Vjc2UzdkWXpwc2Qy?=
 =?utf-8?B?ZHFnV25rcUVXVHoxYlBuSnpLc2FuT2hvWnAzK0dDSHJrejhEclNVVTViMjY1?=
 =?utf-8?B?K012NUdMa2lOZVNlYVhqTTdEZEczOTd2ZFJwbHVZY0Q3aTJ0TDRjczhUNlAw?=
 =?utf-8?B?VUF0WThId3RaN2NXNFM2dVVVZyt5MnF4b3NzOHcxdkNRdkI1MStpTUdtZ005?=
 =?utf-8?B?YmQxRTJ5ZWsyTFFWcVYvajZHbG51SDdzUkZkZmJDaE8rT0dYSVZZNHdkUTRH?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6863a4a-55e3-4592-d436-08ddaf6eee2d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 20:21:53.5883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVmuL/paJPAEF0NO6uKFHfYdqMG+93VclAoVxy9/+x2K5864WbbfCNIe0egz784iELQ2izs6cP7fsJO6BlaU3qTEC8vbfQZspRiXII7yJVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9350
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 12:57:05PM +0800, Herbert Xu wrote:
> On Mon, Jun 16, 2025 at 04:02:30PM +0100, Giovanni Cabiddu wrote:
> >
> > This level of performance is observed in userspace, where it is possible
> > to (1) batch requests to amortize MMIO overhead (e.g., multiple requests
> > per write), (2) submit requests asynchronously, (3) use flat buffers
> > instead of scatter-gather lists, and (4) rely on polling rather than
> > interrupts.
> 
> So is batching a large number of 4K requests requests sufficient
> to achieve the maximum throughput? Or does it require physically
> contiguous memory much greater than 4K in size?

Yes, batching a large number of 4KiB requests is sufficient to achieve
near-maximum throughput.

In an experiment using the skcipher APIs in asynchronous mode, I was
able to reach approximately 11 GB/s throughput with 4KiB buffers. To
achieve this, I had to increase the request queue depth and adjust the
interrupt coalescing timer, which is set quite high by default.

I'm continuing to experiment. For example, I modified the code to send a
direct pointer to the device when the source and destination scatterlist
entries each contain only a single segment. This should reduce I/O
overhead by avoiding the need to read the scatter-gather list
descriptors.

Regarding the synchronous use case, preliminary analysis shows that the
main bottlenecks are: (1) interrupt handling — particularly the overhead
of completion handling, with significant time spent in the tasklet
executing crypto_req_done() and (2) latency waiting on the device. I'm
exploring ways to improve these.

While this work might seem moot given that AES is faster in the core,
the same optimizations are applicable to the compression service, where
QAT can still provide benefits.

Regards,

-- 
Giovanni
