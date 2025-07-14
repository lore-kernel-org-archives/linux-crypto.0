Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D01944F
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 07:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752478796; cv=fail; b=UhU6lfJ2cwojqUGwQP9wZ2syuonDtDv2E4mya8WpGUe9jbNjhGadxaqsYL9nmb3iGETV+JPQ4cN8qbP6kscN+GbQqUNawxZMBKhlmxddy9tqP3YZuwAxA49jHXr9aVTV7hgqk2VX25z7cVrbHisDrJg/TwDS1RHq8reZiglvTTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752478796; c=relaxed/simple;
	bh=ecOHlLfsguhDYNHdfGTj2pyrreunq31h22VQG7L0DTc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IVX+bUYKYdGBPTA+YmCpKdPI1oE3Guj3bAmTynlAWxl9S3iTrBlzwaQm/E/4q3sx51zoa6AbHh88l3ayW/2c02apAMhSsjyG1djcpymA9NYQBALmW8m5G+hnZFVdgugjXALLh5OBfuW4tjAtcyWjZivRt7z5I0HMHPCe9k11WgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rcfqb2Wi; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rcfqb2Wi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752478796; x=1784014796;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ecOHlLfsguhDYNHdfGTj2pyrreunq31h22VQG7L0DTc=;
  b=Rcfqb2WifMagKBDWmwCEbeMQCdlJFn4s0cEojSot8N/MZs76TBDGt61G
   wlJyXKPKkYgHloMDz1nvX6q4Ccqf+9ERdSHtgQOtQBtNW0m+7adBZB6rL
   ZyC+zYOQ9ISxhkPsdKR9cORpbWFZ21uXRQ936Arbx91zN30/Dg8bm/z8D
   5mgrb2afvuPslrxs9pSOqmdPvEN+fyTzxdpqKUNC55DsxVJ0VqyMvnyiI
   WMiTYOusWpLh94mc802HDvO6BUEsukyhnpFhCt8+Zhd5jTV58qLxaXnHt
   IDTu3pgPdfQr6mKo8SDh+s3PVJ5m9MQk+5TlQgJP+pKS4TakhOFxk75vd
   A==;
X-CSE-ConnectionGUID: HuQdBJLMRD66Blm90BRECg==
X-CSE-MsgGUID: KCFUQba7Si+wzCmjJM8iJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72110831"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="72110831"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:39:53 -0700
X-CSE-ConnectionGUID: 8cDeIvQjQieQwk2kOR8Sug==
X-CSE-MsgGUID: uZpMNLrrTRu9+j7cYgdBkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="194072722"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:39:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 00:39:51 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 00:39:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.60)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 00:39:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seFew87NXgAvq3GRn4HF92MnKrf6YHheUmmqHGfnZfmJrfwbRs4fGz0PHRxAHKPQLm9dClR3tLX93GjFOMpI9bw50TLNL1VMlN0CBvVz0MnJ91n0pxj5EvX9WO3S0pdPGXFXZ/dRkxWpNiOyzf78Fi2vNUEd+2kFgNVywZO9qBidkb+VdwrT58CkxLjm0kP1Yrl4e7P30+TquH2y3xupEvtOIwX7E1da5TtuRwMgf8bgV1xl76Ykg9kqzHmpI2xkuzNjd2TON2ksGq5pUcpLm6XGgmUrjenH9QSw/PIn3VSzdtcILKBULUkDKS4ksiUYMRHHmTrPJ4YtEV9JyEq5XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McC8UGSCBjkuIEdWxKmN54vCNhYwpQzb6HLr2ZTrJD4=;
 b=c54xj7L5inrE+C0WsWCspsklNMoGa0GLauRinTCbu9xuQA9dZ1yR1QCgxe+jN74HrjrqdgWpTT11AP90V4FML64aOzBZQaUNpKoJoWWOKFg5L5ec66ynXIEzCgzSUNR0eF5Oqqm1knuzD3IbOM7C2WCcOY+6nbejBBg5WwPHKACYUwb0CYRkL/9CKq7fUEgg5fkvXVKRvIFlbyb/3zVdBEIK5S6gz8uzDqAM9uEZcB0LWc+7MfT9jqs0a6PgGUiNJT3QWG8MmZ9m2JZmXmgOiCR8nIONE4u0AMdvQLjoyROnjDB+BS4rAbwu4R+bb4m/OO7Kr8SHmVi3db/4hpLahg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ5PPF2F2B659FE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Mon, 14 Jul
 2025 07:39:50 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 07:39:50 +0000
Date: Mon, 14 Jul 2025 08:39:37 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Shwethax Shetty
	<shwethax.shetty@intel.com>, Srikanth Thokala <srikanth.thokala@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - add missing INIT_LIST_HEAD in probe()
Message-ID: <aHS0OdJWk0mKl8tj@gcabiddu-mobl.ger.corp.intel.com>
References: <20250714071333.6417-1-giovanni.cabiddu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250714071333.6417-1-giovanni.cabiddu@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2P250CA0003.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:10:231::8) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ5PPF2F2B659FE:EE_
X-MS-Office365-Filtering-Correlation-Id: 14dab544-0b4c-41f1-202c-08ddc2a99d39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Fiex6e9N9m4pLEWSIqDGb0u38ubBTpNtRvRcRKAhfc7qzuhEwLEF1p7t1Jba?=
 =?us-ascii?Q?N/e52DAlKCpyfa8HsfX6nW2+De1/McGszIUki3aYOUXi2mAhwrkKZd+It0Fp?=
 =?us-ascii?Q?Xmq2cwSZg0Mnvd/rZJ9y25hYLnrsVw+dayTsRsULXGujOesvv0IV17Kqd6Xr?=
 =?us-ascii?Q?TAf3p51gwdT3ADbYhPJFFISiKBvusxhXIgxjrG/4h5C8+V19ONbKqsNy0g/T?=
 =?us-ascii?Q?KGnfruvwoVhXZbIewBBtwC84IiwwsqD/TBggNji5n52IvqBnQ6xOcGFegjbD?=
 =?us-ascii?Q?lrnfXvfFTLg96WRxFnnAno/9sObERLO+FYv+ihzKsEUPjJJINI1we0dorgkx?=
 =?us-ascii?Q?N1jiN+HgqE3NDG9MKuFq9YzsMPGwlLfG5Tci2rLPr6lfbkEKttlFYTycE6jK?=
 =?us-ascii?Q?pjKHZ6zMDUKO/nQyLWbVtS27KARKSuXiAxdQSATaFhWJXijgsJq5TZfmMtW9?=
 =?us-ascii?Q?sHxUF/hsfzWlDiLZtHdR2sOe8bk9kIWwgH3chnrcx+LtfYQtJSu5eQobYpA8?=
 =?us-ascii?Q?/aaYoaMoIIeE/GR43UPa/R3ItQpMCn4RykJ7mq8KSTr+hx50eud1npmtbf+C?=
 =?us-ascii?Q?Hzaic9TR2T7In3+4IC0t0RX2PU2NY6RsyD9DnCfovyNdY4EG7ZB1lbwEitcN?=
 =?us-ascii?Q?BlvlC0ZQxQXvLG1+JfHckOjMfMpC+ydRambm6pN8FELv4zneKRMC99vvfQ5F?=
 =?us-ascii?Q?9eyakOzRiJ3qndS+KuY5MMgCI+Rm0KkH+zvoLoGlFzJDD8ds+wNAEjsDzmWD?=
 =?us-ascii?Q?KaPpCJpzBmBhZKTEOLsA6Apiezrn7eoubf71C4IbWXLDweOrkqpc+FWoBrqq?=
 =?us-ascii?Q?E57gHsXfjpW9fuG+SBWtnZhL4RwBp/5wowLq5IS7iK829w+buy3ie4F/UtJF?=
 =?us-ascii?Q?nFWs8FDPmRBCssy0SA/NQIo0mEIa9ZKGa0cDqlzh8/vaIfVJQNoVxLH58di5?=
 =?us-ascii?Q?kEe7J9bMPz7uWsL6dkpRM9PkHJDJUztRlEDOq6+fXkLGmNgAGWOJ/mMztwSj?=
 =?us-ascii?Q?1aSvkmKxF3DUDgEnB4ORq9c8pW1xJCbpIrog0+jSfCywUD76RDUQ8KvtMBVm?=
 =?us-ascii?Q?JaQFSFbXAIeaFN6VAXYzdGM4CQEUj6xLsC/1fDKQ8eMj4q38q5czMMkjWWs4?=
 =?us-ascii?Q?kJM9Kq5BgmZ0MYzqlbvmGfOU1a5GmvFnKBGuyRJwONx1vZ5fo78bjoeen6gV?=
 =?us-ascii?Q?wKIVLlEEbje7bbsDImuXTSdmMFPmdDFHt3mYFh7z8c9DOWSZZ3LRyhsmOEnW?=
 =?us-ascii?Q?9Js/psMvU4RHOLl8RbMsJNpn8VddanTjR8AYm3GhbycltmewWN79ENk2cAdF?=
 =?us-ascii?Q?DNH9nAcXXbqsp0RKwJWESEJKjSy5ZpKzJ/RlbmnO8v7AY6glcP3ldOBKNJdR?=
 =?us-ascii?Q?xGNsLdqOi2NABNCvaWcbAppSSDwgg6xtijN1AfUcDzAwYSw1JzXauG/MvZgu?=
 =?us-ascii?Q?xKQhaDsQlt0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DSm9TSixkxc3Q8MxvjT/XSn/BgWZnN8AZkBd5tIezmdztFjCyLyvfLs8MrFj?=
 =?us-ascii?Q?b2lFyGx3wrQsTykUkyeFnXJqEdONOkifGLX2+XXegG8I60kWq9cpdHeE2zVz?=
 =?us-ascii?Q?dUjniTarT1HRJb3xgBqsISZjnBnST6H474+lrtRRfGeeAitgV3cmsKj2QbrL?=
 =?us-ascii?Q?KhJio4lEfNgBXXvxa9z+q4wpTP0+EQfIGuh2+Tr/jXguWj92xnfOdKp/6ySn?=
 =?us-ascii?Q?AgZRHXL30ncy2m4qVQIUOG9lPqM6LfIG6ldIYHO+gusduJQP+WXev996dYKu?=
 =?us-ascii?Q?VbRbPALfEz968T3muReDiyAp1VReEN5Dz+W6NjTz3OtyYJ7eGybndaD2Cdn3?=
 =?us-ascii?Q?rgd6Ghiz7cE8lv1JhdOcWshsHykdPTDJU3pTSJwG7RXWpk66sHAupmgd8b0P?=
 =?us-ascii?Q?YMRuI8r+GWJ80r2DvOzYcE8R2ZTQmIn8JjpDJk1ZAjs08P1l4SEPkM7s1pbi?=
 =?us-ascii?Q?f1wOC3JlPwBzasUk+Al9vtkE+IdGaemnzEt12wuceaFY/xe+8YqYWMTw819T?=
 =?us-ascii?Q?okrSm5sYJCESVLaQdbtaKgQwT2FAscyGhrKSbFAASmMyC3fDas7iVGOFsGqd?=
 =?us-ascii?Q?FEvX5yexJvhMTUnen4wGFUBRj4QJCfPgtp2wfnqEdIj88H8UP1OEqp5ab4zw?=
 =?us-ascii?Q?YVtiS39OX/2a7fwPBsKHOoDGLn2WrY1NF2xGE622gq7W7+L6yvanL57AHqhl?=
 =?us-ascii?Q?AXof3NAsOLZ2jWe0YNhdGMbhLMM4ZzYk2/Iiw4cWgPqKnQl1i6YFXCcjpER4?=
 =?us-ascii?Q?w8WYk9z+9ZZ68gyXwRpOXdNND0YorL/dkeY2kRoFJYJAvgRAN51yme1pFvin?=
 =?us-ascii?Q?Od5AVJX8k1XIaS8gmoH3acrrXC4QmM1rWTkPYVjpsfLeKlXc31nBD3Q1Wrev?=
 =?us-ascii?Q?F41R/QUS7biddOya1beIRZV+QG4NgXSGYRPO2MbvjZkPCZXg+VJw1Pbx04s4?=
 =?us-ascii?Q?BFmA/XrYPlFQoz/rq/ev5Cr2cCFSoLiY6TRSB98iTPgCcszd+I6etdHDgyXi?=
 =?us-ascii?Q?B8EXheZoLtgw9OUo4C3L7tULXq8dp5O8DFnIC/8T5WFjaq97NypW6344KdKo?=
 =?us-ascii?Q?C7ZI+915HX1cgauI9ygJ7xQEfWysOabdFNv3Sb/tTgqdG6w3aRiRS/fWAbF9?=
 =?us-ascii?Q?EuXSDdEpgsqsFb6JW4TLiPPP6ysntBHhqJjX1Md3lqwAWEZHdBG4UZOhkfOI?=
 =?us-ascii?Q?B8nSQWzS7kVmB98Y3zPUO+Loyku2zAaM8t1XZzyVxbgMf5v9sCw8DzrrCLVW?=
 =?us-ascii?Q?lac4en50oydMGEuf94cf9zFrD0p4FZ5vZiaCzTT0O3TzKs4erQuW0e/bj0yp?=
 =?us-ascii?Q?yBxTUpcs/ljICBhWH8wmUyaqY9JcsaNcIz7b/7+T3T6134NDx+og2EGzMFYs?=
 =?us-ascii?Q?FOh8Am8giXJjFSAeD+oFCgzjIjEueEncp5uMAXa7qAvgxDD7JpRioCry0mDG?=
 =?us-ascii?Q?KsE4xStE14c15hSYrSrt5sKUibQcPQXZoj/TpgYfJ/ukEyd+4lAcGw7m/q4H?=
 =?us-ascii?Q?uYqM9kCC4BYErgCeiTnq3WO9y+74wSXZK4XzJHlHYl+mu/nzffJ85FRNP4kc?=
 =?us-ascii?Q?PKneZ4e3ihmu0w7HlAnn5Hv7G0NF1HTXZyHZmFenNLvgnPX21gw4lFEThbLv?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dab544-0b4c-41f1-202c-08ddc2a99d39
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 07:39:50.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1lyhT0UjbDHAqJE07c90dedfzlLnPErKnGUR2X2MEZHT0JLxBrWksWsughlBPpRe7IHdOmqGOciFWg08/yFeLTadzQnBhz4mFFw1A3/w0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2F2B659FE
X-OriginatorOrg: intel.com

On Mon, Jul 14, 2025 at 08:13:13AM +0100, Giovanni Cabiddu wrote:
> From: Shwethax Shetty <shwethax.shetty@intel.com>
> 
> If a list is not properly initialized before use, traversing it can lead
> to undefined behavior, including NULL pointer dereferences. In this
> case, the `adf_ctl_stop_devices()` function attempts to iterate over a
> list to retrieve `accel_dev`, but if the list hasn't been initialized,
> it may result in a kernel panic.
> 
> This issue was observed during testing, with the following stack trace:
> 
>     BUG: kernel NULL pointer dereference, address: 0000000000000214
>     RIP: 0010:adf_ctl_stop_devices+0x65/0x240 [intel_qat]
>     4xxx 0000:86:00.0: pci_iomap_range() calls ioremap_driver_hardened()
>     ? __die+0x24/0x70
>     ? page_fault_oops+0x82/0x160
>     ? do_user_addr_fault+0x65/0x690
>     ? exc_page_fault+0x78/0x170
>     4xxx 0000:86:00.0: pci_iomap_range() calls ioremap_driver_hardened()
>     ? asm_exc_page_fault+0x26/0x30
>     ? adf_ctl_stop_devices+0x65/0x240 [intel_qat]
>     4xxx 0000:86:00.0: pci_iomap_range() calls ioremap_driver_hardened()
>     ? adf_ctl_stop_devices+0x65/0x240 [intel_qat]
>     adf_ctl_ioctl+0x6a9/0x790 [intel_qat]
> 
> To prevent this, add the missing `INIT_LIST_HEAD()` in `adf_probe()` to
> ensure the list is correctly initialized before use.
> 
> Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
> Fixes: dd0f368398ea ("crypto: qat - Add qat dh895xcc VF driver")
> Fixes: a6dabee6c8ba ("crypto: qat - add support for c62x accel type")
> Fixes: 3771df3cff75 ("crypto: qat - add support for c62xvf accel type")
> Fixes: 890c55f4dc0e ("crypto: qat - add support for c3xxx accel type")
> Fixes: 8b206f2d666f ("crypto: qat - add support for c3xxxvf accel type")
> Fixes: 8c8268166e83 ("crypto: qat - add qat_4xxx driver")
> Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
> Signed-off-by: Shwethax Shetty <shwethax.shetty@intel.com>
> Reviewed-by: Srikanth Thokala <srikanth.thokala@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
Herbert, please discard this patch.

`accel_dev->list` refers to an element within the list and the fields
`next` and `prev` are set when the element is added. This patch is
unnecessary.

Thanks,

-- 
Giovanni
