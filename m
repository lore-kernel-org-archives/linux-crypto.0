Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA1D329C63;
	Wed, 12 Nov 2025 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762966946; cv=fail; b=AN0tvujS62fmogQ/PfMaTvPVXTFOUiNZ0kqAS+9IawOzbqIlJ22Ce2izW1lSuM3c53GBMr1wt7Sj4zxdsZdYIaw50/LRjA9wLcqEerPI406IhJHXUAyM3/mLgorzsBwdlx1jU7R14F+Q+V14E3aWPZC2u5JTV3iqnEkwcfKppBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762966946; c=relaxed/simple;
	bh=IbgB6ges4qT9D4TltJSzM7OvgUD587LuerZN2ARIDPk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nKo17UjdRUVa1/epMSgQJHC1QMc6fGCS97zJo0EMVx8WG8sIeMBADkI3/PKZjF93/reVEVReGcydPelka+9lemxrmMJThr92LGHm/Xo7Ki45ODqqIqcYEDS3pb9eRleKCS5ITi3r1BuJfFZmkgfJv8XY9Wl/ftE9eEzUuh/8aWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HTi7GOpf; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HTi7GOpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762966945; x=1794502945;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IbgB6ges4qT9D4TltJSzM7OvgUD587LuerZN2ARIDPk=;
  b=HTi7GOpfVYJf336FJ2hUhIJNhFjiL97W+btYlvoTd0+nPZoIZvKbNcZ4
   oTtBl0HARhCi+e5q+VGJSlO6YvzTnsBASG0e0j7CDFda+KuuErh2U4tfC
   GYenbGnqdTtv8sqPdvFZAQeYBXdWC4ufOfSACMrqpp5jLIS8FElVMr8Vh
   1NkIjbplgYQG0SzSLo24kvvz+8RA2Y2HM9Bda4Ql+57SWVloNB+h7s6p4
   DkTJMgnS2gPOfQ2vUZFKl7HJVlOIqsQAgGrkUEXiQDpt8DmktQae7XSax
   1c5ddFeoU26pvshnwKk/vifdSP5aXRB7WTtMbV7DfEdVu1XTYvp18cSye
   A==;
X-CSE-ConnectionGUID: ZUQx5/xDSqeMyCscGDzx/A==
X-CSE-MsgGUID: fSn7G5q6Rw2+CtcT4wSnZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64242192"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="64242192"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 09:01:22 -0800
X-CSE-ConnectionGUID: L2u436aKQJqQYEdNiLVfQw==
X-CSE-MsgGUID: jas1khutS/2CDfgHbfS3fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189032336"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 09:01:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 09:01:20 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 09:01:20 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 09:01:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OH1MiDc1tvjg15esWAdeUhNHhp1mJL50wNAG2cJHVLqnoa4tuxo2eV2wtuziplDq+So35PDPsLCQHta0WSbOudoBh7ympiJIzrd8oUBnbegivngWIunWCFJlDrrJG5d1TIbJ2BQvszpg0ewtQSjiFGo+IrK1fVb4Ie4f2oIZjO5xD+61FjQsYvQ8ysQHDhcL/SilFyveD4BE/b0tNB04PA+FwJn1I3PXWWtAwNnjyCLo9zuX5Ki8IBX/wB4l4SGTi7GsqO1p1JTUoDecw7/GTk+otBgobIqu2VutMK399P/+F+0fRZhJQXW+hDGR//PoxGbTlemOCwFFR18qycQFCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=es8e/DTQuWBnoJAOj52knkpa9Q1OPd/bQymg3uFa8pc=;
 b=QDHN+Bnxd/S1w1LbwaHk5jzUGYMqIVfBBUfvpTt5gjZ/bxU5rKNXDtR1DSQbrT2qyMHj3IYSvVjhhsrDsC1a409YykVzDBYzy9cFXXRG23KW7ztiKBjPG2xJO27xSxNDhc47NN/vLWSkSqtNbrHrvikoARrybUTiPEtx1c/PFXoPsRr2aygsqGFAsskn0Kfv0LT27fTlkxFDpTc8xwTeK5IR0Hd7KT3CmqBRtOKWQQlVixe14sXulTEWdOJwT8vITc6r1kzNwWSCXCCMcYSRbBTzOf7KvOARO9gc9JnwvHTjqJoKL0xbO4+fTvmX2+OiPbsTJnHx8LFpeyhdCJluCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH3PR11MB8519.namprd11.prod.outlook.com (2603:10b6:610:1ba::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 17:01:18 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 17:01:18 +0000
Date: Wed, 12 Nov 2025 17:01:10 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Marco Crivellari <marco.crivellari@suse.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, Tejun Heo <tj@kernel.org>, Lai Jiangshan
	<jiangshanlai@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Michal Hocko
	<mhocko@suse.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S .
 Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: qat - add WQ_PERCPU to alloc_workqueue users
Message-ID: <aRS9Vk6yh1wEq614@gcabiddu-mobl.ger.corp.intel.com>
References: <20251107112354.144707-1-marco.crivellari@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251107112354.144707-1-marco.crivellari@suse.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0087.eurprd04.prod.outlook.com
 (2603:10a6:10:232::32) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH3PR11MB8519:EE_
X-MS-Office365-Filtering-Correlation-Id: f7111d8c-463e-4552-8b51-08de220d1923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bFBSMWNjZFlMV2NZdi9CVXVsTnVPVTNZWDJ1STRjSjRrek92b05ZZHJwRVcz?=
 =?utf-8?B?aklEcGE1YUo2Tm1GVnlyVlRiWTdDM3p1cDVTMFl5NEVCMU5MZUhnd1M4UVBn?=
 =?utf-8?B?ZWdFcnY2NndIUm9saWNSV2lxSjJiaDNSSjZYcXdtdjFGQmVSNzlLTWVzVC9M?=
 =?utf-8?B?NXdrMVd2d1dRL3ZncStpRkIrOXE0dTNjL0hUeTZOWEFBYnlEYTBIbFNlMlhW?=
 =?utf-8?B?SjR6c0lGNFpVOTVzN0hRYmxpbGxlNC82VUJZRnpaNFlMUjV0Yk96YnVGZnpV?=
 =?utf-8?B?MXpYak1wcndUcm1pSEtWelBpQmp6QS9kcnIxelBLSWFSUmRjbzNUNkFmRUg5?=
 =?utf-8?B?WjVtSE0rNTFmUlFxK1RBNDZva0VhbU5mVWZHUlNkdC96UWJUcUNHRDF5dTBJ?=
 =?utf-8?B?eTdZUGZaUHFsT1RyZEJiakxZZG5UdkhHUmhZOXNCU2RnRjhzK096c0U1NFJI?=
 =?utf-8?B?ajAvWlF4Y2EwZFkxelZsNk1qZERFbzZUcFV0ZWtSelg3YXRmVHA1cE9CbEhw?=
 =?utf-8?B?U0pMMHdiR3YwRTBTNitEV205dTh2S09TT09aUFZicXhtczNmYUtPRG1taHpG?=
 =?utf-8?B?MVFYeW1icEJHZE5qbHl4VjU4Wk9aL1pianZKZEd4dkNpMStTdVJpeWsxUlFE?=
 =?utf-8?B?L1JSczF6MUlnenNNN0crOER1MWxvbjJSc1YxZmZodTd0UW1JTkZzSlI5VFRV?=
 =?utf-8?B?MUQ2OGQ5NU1hS3czbFFId1kyOTluaVIxYlZqZ3ByYXlIbTFNaTNSYWJSZTNz?=
 =?utf-8?B?OHdsSmo0bEJZcUlnZjBaTWZwOXdmTnFxRXNCOXhPUWNNbVR5Qk0vamV2eTZD?=
 =?utf-8?B?a1JWT21VNk9JeHlrWS9SR0lIYldYMUNxUmhNRDRMcituTVNWdms0Q1NtVzg3?=
 =?utf-8?B?UTlPaW9VNldXK0NMSHBwdzl6SU5aOUtvLzVHL0xSTkMzT0hPcE15cEhnVjRv?=
 =?utf-8?B?ak1lSmVGdmgyMTRzT043d05hbWpzcjhBb0gxaGZXVk94MDZibHRuRURaTkJP?=
 =?utf-8?B?Kzk0Yzc4QU81cDZKZ0xJRkt1RG9aL0F1VUw2MSs2MHV0R2lVcEQ4cHk5c291?=
 =?utf-8?B?ZU9pSXh0cVRWaUdHeC96ekxhWnpUcE02d2hkRUZMaDBSajhGNkxrUytaczBk?=
 =?utf-8?B?aVJNM1FSckZYN2hTMWpVNDhlRXJ1cnNFUmI3bVlKU0FXZlZicHhGOEpzNTB6?=
 =?utf-8?B?ZlVwRE9HMFVkeXhBTXA5aDc1UmJUdEV5bHRaZkMvd3B4dksrZkQrREVTQmk5?=
 =?utf-8?B?KzcwMDNrQ3dPS0luWG5lM2UwbEpyYVl0VUxZZjlmWks0R2V4cy9GR2RLWEVU?=
 =?utf-8?B?WDI5ZFBldEdkaGp0ck4weGJMZGF2WjJHSk9ER09RSjFWdVZaOXZBcENxRXZt?=
 =?utf-8?B?OTdyVHRRSm9Hd2xuelcyS1A2UjJTT3pDMnVaNlAwVkJNVlJvUlErVmJtUEha?=
 =?utf-8?B?eFBCVGhvZFBkMjdpUUt4NmcvM1ZVZ3FlS1hPcWdNK3NLVEFNL2p0anl0a3Bm?=
 =?utf-8?B?Y2F2c3ZRakZVQUZVZ3NwOWwxTTRzcFVtb3pZTlNEQmkzUk9qb2NTWmMzYXBv?=
 =?utf-8?B?SVBUYmkwUDNLanNJNmI2U2wvSnVtd3QwQmRnSzVQSFZybDYyYWplSmNYSkRq?=
 =?utf-8?B?K2EyeUxGSUJZdnlYcGxxVFAzWURuWSs3M3N2WUFlclFpVjdYVHVrb0ZXRElw?=
 =?utf-8?B?TkNmOGZudjlPOHloSmVyVFRybnZhNCtVdzhQYmN5WmhkRkdIcjgrNUVjWDhs?=
 =?utf-8?B?NTFBL2F6UDJVU3plYU11V3VLck5pNk5SSHZnZzN2MUE2NmJ6VHFPaFdiWHVC?=
 =?utf-8?B?ZTBISi9MOVB1NXRVNHFqdDE0QmxnVzM4TXpobDl3WTFYUVY1dmNKcTMzbFdB?=
 =?utf-8?B?UCtKK1dTSCtET2FRbW5UMytET3RtNVhaVzNCUGY0bFNQdTdvclo3Qm82ckhS?=
 =?utf-8?Q?4P+x/uNOdtrsar3Yp/8qHXKpwNL4OZOc?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nkp5R2xnc0k4R3R5SmwzbTNkTXpkZHlqU2lLSTlRZi95SWUvd3VvU2d0Q2Nl?=
 =?utf-8?B?SVZ1YmM2QWlhN25DWWNVeXFQam1yeGs2Z21jc0tIZ0JGQzJQOWdhRDlvcVFM?=
 =?utf-8?B?WVlSbkd5eDlIbnNQOG5zTUZlY2hWNTV0TzhFbHAweFRrSW5RaHV5QTNsMUxE?=
 =?utf-8?B?SDE0cDc3N1JHdkRHaDZpWGFlYisrdXhzRkRadVZYT05ydWxuZlF4RUNsd0VR?=
 =?utf-8?B?MFFCOUd0YUNBenNCZTAwVjFwNVRLMzFwWGJDSjNyYXh6SmhWRm9wczlaTTBo?=
 =?utf-8?B?NnRXUHEzMy9lVkZrcnZPYmdiLzlDVjI3VnR5Ni9ST0cvYm93M0U2emdKM015?=
 =?utf-8?B?RE1Dcyt6Q2p1akdiVWxJRzFmMzRka3NsQjJ0bmJxM1FnRVZMUWxOcTBHQzRm?=
 =?utf-8?B?WE9BSXdNY0lTSDQ4cVhBRXJiazBRM0pSK0Y3S1pZT1VwL3VTNlFZQ25rVENP?=
 =?utf-8?B?UG1sRlVwN0RPNzlUcTNET1ZLT3NMN3NvRFBhQWpIZnlxYjVQNVRoeEVjaUlm?=
 =?utf-8?B?NStnSXJ5eXVJb2NMTHhjSWZvUDVJZUluNzFRZUxud0FyOVZPMmNBdFFHTWdL?=
 =?utf-8?B?VGpBektkc1g2YTZwSkliZWVUTXBrU0x5dHdtTTdYaU1BcFovSE8yVGJmWHJY?=
 =?utf-8?B?eks3ei9IUW1ibnRNV3lTZ0tKOHhLRERxOGFvZHlYZS9mMG9meDdEVXFLSE56?=
 =?utf-8?B?RFZLMmtpeDZLZEo4Nkh4ZitGYncxMWN0ZXR1TVZXYzUySy94VjNOOXRDK2Mz?=
 =?utf-8?B?dnlBbFhBcS90VzM5YWhhN1RQNHBCdWFzbWlRMHRZeWREY0dJcHBxVGdoNmNl?=
 =?utf-8?B?dTkvS1Z2SkF0dG50TzBmKzIybnZjc3d2dG4xWnp2NG1mU1FhcUpSalZGK3Vk?=
 =?utf-8?B?U3RscE9IMGVyVmZUZEpYUytWbHFWWGRTeXpoeU82RmZvN0szYkRZV01kMWlD?=
 =?utf-8?B?WHpmTUZLRU4yVW5hdlRybnV5V1BXK2pVS0NCb2R6V3hFbHdIMXRkaGNrcDlr?=
 =?utf-8?B?ak5FZ2NQMlR6T0dsb0pMblFVdi92UTY3WkUzdEx3dkJDbjBuMUF2WUl6ejZ1?=
 =?utf-8?B?UURCWHlLc1hhbk1vOEZrcWw4VDlmUi9PbmZ6ZDJNci9vZlhGcXRVTDRTWUZo?=
 =?utf-8?B?Y3B1NUVaZi94KzduNmtuUVFYUVJ4dzNvQnczVk9FNUlrZE80d09Hdy8xZXQz?=
 =?utf-8?B?KzJyTXRBeHBLcnREMkdSUk1CUndVUkgwZUJkd1ZIc1EwRlRoaDN2Q05QWUFN?=
 =?utf-8?B?dU5YbHUwOU1iZERxUUZPMjFBNU1ER0tPNDF3N0cvOHpXK0pmd3pXaHhjbG9z?=
 =?utf-8?B?L2FsUE85KzhIR0pSNStUbWQyRkpwdXBWajM1VmV6c29ydENGUVZtOUMyb3Q4?=
 =?utf-8?B?WGpBcmRBNDlrdFNvZ0EwbkhaNGNLN3I1TjJldERjVXNWQkVtR3Y5bDJlWnAx?=
 =?utf-8?B?WFBuOTdDZGh4L0RNdW1xalV4eEhxT3c0Yy90czAySXRtTk9tZFhUaTVDQjYx?=
 =?utf-8?B?bmU0VmNSRUJFbjlIOFhwZ29NdE5mZmtKczdMWnpEdUd3UjZtN0ltREV0RE5E?=
 =?utf-8?B?RnlwZE53UmxaYTVqQWtibzBqbEd6MjRKT3lhLzNJYkVKTURCNW5EVkQ4RGJH?=
 =?utf-8?B?dzRBT1dKSmtOQ05kdHRwU25FQ2NvZnVGNmdNSE5CMkhhc0NESndCSHVRMmkw?=
 =?utf-8?B?ejg5Q0x2MThyd0lDYXNLZnVQNU5iK2RQOTBtVis5NzlRSmF0WTJBaEt5UW1t?=
 =?utf-8?B?ZEROUGl1NWtjcGt0MWhndHg0bTE2K1ZsSGI2eWxhSFhieEFYUTh1bkRPSjJN?=
 =?utf-8?B?b21sT050eExtRlp1Yi8wd29BOXlOOExMSGprRGVYWUp1eXBUTElwVHRRSEF0?=
 =?utf-8?B?djVRZ0ZxVTQ3M3c4UVAzNDdGdGRlbEtPeHpVUERzSTJwaHh5Z0gzQWt1MGZZ?=
 =?utf-8?B?MXFUbENyMStaSmhFSmE0ZXcyL3k4MTFVK0lOUDlFNzV4RjFTZjRyU2dFNUpX?=
 =?utf-8?B?ZmhmMHJTMk9LYWNUS3pBc2JBV1Rnbk1HTFZUbnd0QVhSZmROMkRLY3R6bXk0?=
 =?utf-8?B?TWR5MHg4MkpjS2s0dXFId3NGOGY1UTExS3ZmQlk4a0RXZzFQOTZ4ZUpiOG1x?=
 =?utf-8?B?OTh0cjRGdFFTeU5icEpFK1ZLSXJ2SEs3SnZOUEZjYkJRM1dYb1F6NCtvRHdC?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7111d8c-463e-4552-8b51-08de220d1923
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 17:01:18.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHLkQMmqJydZbSpIGqLONPB7KdtZO1/XenVtdOz60TmIvVZS7uA481CALLDE2p/nGV4w4COa4QMpsdU6Xnbyhamj7lymoGvfwHtCOQOf6X8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8519
X-OriginatorOrg: intel.com

Hi Marco,

On Fri, Nov 07, 2025 at 12:23:54PM +0100, Marco Crivellari wrote:
> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
The reference to WORK_CPU_UNBOUND in this paragraph got me a bit
confused :-). As I understand it, if a workqueue is allocated with default
parameters (i.e., no flags), it is per-CPU, so using queue_work() or
queue_delayed_work() on such a queue would behave similarly to
schedule_work() or schedule_delayed_work() in terms of CPU affinity.

Is the `lack of consistency` you are referring in this paragraph about
developer expectations?  IOW developers might assume they're getting
unbound behavior?

> alloc_workqueue() treats all queues as per-CPU by default, while unbound
> workqueues must opt-in via WQ_UNBOUND.
> 
> This default is suboptimal: most workloads benefit from unbound queues,
> allowing the scheduler to place worker threads where they’re needed and
> reducing noise when CPUs are isolated.
> 
> This continues the effort to refactor workqueue APIs, which began with
> the introduction of new workqueues and a new alloc_workqueue flag in:
> 
> commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
> commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> This change adds a new WQ_PERCPU flag to explicitly request alloc_workqueue()
> to be per-cpu when WQ_UNBOUND has not been specified.
> 
> With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
> any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
> must now use WQ_PERCPU.
> 
> Once migration is complete, WQ_UNBOUND can be removed and unbound will
> become the implicit default.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c    | 4 ++--
>  drivers/crypto/intel/qat/qat_common/adf_isr.c    | 3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_sriov.c  | 3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_vf_isr.c | 3 ++-
>  4 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> index 35679b21ff63..667d5e320f50 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> @@ -276,11 +276,11 @@ int adf_notify_fatal_error(struct adf_accel_dev *accel_dev)
>  int adf_init_aer(void)
>  {
>  	device_reset_wq = alloc_workqueue("qat_device_reset_wq",
> -					  WQ_MEM_RECLAIM, 0);
> +					  WQ_MEM_RECLAIM | WQ_PERCPU, 0);
>  	if (!device_reset_wq)
>  		return -EFAULT;
>  
> -	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
> +	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", WQ_PERCPU, 0);
>  	if (!device_sriov_wq) {
>  		destroy_workqueue(device_reset_wq);
>  		device_reset_wq = NULL;
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
> index 12e565613661..4639d7fd93e6 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
> @@ -384,7 +384,8 @@ EXPORT_SYMBOL_GPL(adf_isr_resource_alloc);
>   */
>  int __init adf_init_misc_wq(void)
>  {
> -	adf_misc_wq = alloc_workqueue("qat_misc_wq", WQ_MEM_RECLAIM, 0);
> +	adf_misc_wq = alloc_workqueue("qat_misc_wq",
> +				      WQ_MEM_RECLAIM | WQ_PERCPU, 0);
>  
>  	return !adf_misc_wq ? -ENOMEM : 0;
>  }
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
> index 31d1ef0cb1f5..bb904ba4bf84 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
> @@ -299,7 +299,8 @@ EXPORT_SYMBOL_GPL(adf_sriov_configure);
>  int __init adf_init_pf_wq(void)
>  {
>  	/* Workqueue for PF2VF responses */
> -	pf2vf_resp_wq = alloc_workqueue("qat_pf2vf_resp_wq", WQ_MEM_RECLAIM, 0);
> +	pf2vf_resp_wq = alloc_workqueue("qat_pf2vf_resp_wq",
> +					WQ_MEM_RECLAIM | WQ_PERCPU, 0);
>  
>  	return !pf2vf_resp_wq ? -ENOMEM : 0;
>  }
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
> index a4636ec9f9ca..d0fef20a3df4 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
> @@ -299,7 +299,8 @@ EXPORT_SYMBOL_GPL(adf_flush_vf_wq);
>   */
>  int __init adf_init_vf_wq(void)
>  {
> -	adf_vf_stop_wq = alloc_workqueue("adf_vf_stop_wq", WQ_MEM_RECLAIM, 0);
> +	adf_vf_stop_wq = alloc_workqueue("adf_vf_stop_wq",
> +					 WQ_MEM_RECLAIM | WQ_PERCPU, 0);
>  
>  	return !adf_vf_stop_wq ? -EFAULT : 0;
>  }
> -- 
> 2.51.1
> 
