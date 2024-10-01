Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE045188A0D;
	Tue,  1 Oct 2024 11:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727780749; cv=fail; b=AaFS+KdgcdYWue6SCfQHWWBsc7BKYsfoVnyj4cSL5YHN4g4ypYIzOowdiWFHkaZ/jbVZB3RRSL5hJhbzJ28vEKvVki/u4X0DSb20p+0VPrXpdMkV8WK2P26hXZWpxzA/e+fW2Npy8Z8b6dgiZ2/FQwnE0BBTosBzSRhIVhXvhjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727780749; c=relaxed/simple;
	bh=y4ATqYKl9YwirPArKJikRW/3ZAM/jrvc9g5neCwibgw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TJbuHs4JKlOPuTHMDrjtrkuajLnfh2F1RCzHetw116RNPv3FJbar4ZVCYKhVMjbtPoOMHIsZfbtjwrxIgtZkqTyY9D5MyWBVthPEB9PiBQ+L66BJaRB8Ok1AavUnHvttffl1zrOARReFKGcQ1G/cVgT4An96ZblcZ+kdC5F673Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g4K3EBNO; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g4K3EBNO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727780748; x=1759316748;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y4ATqYKl9YwirPArKJikRW/3ZAM/jrvc9g5neCwibgw=;
  b=g4K3EBNOEesPfM8QhEQLDd/GeI8jqDkKD3AD5ktwGO+69VXEU87Kc2qo
   ogG8xmG/KD45y3BUtMPlCG9+DWI63DNzp3NaBE3FI+MYdY/Q88s2z4lmU
   XF2sh+hesHGIsb6gMfXJQMxYzWp5jhKLlCYp/00fWY8rJCnsSPj0ht5MP
   GxudoexpGtHuGY5+/kwoWL8WkoT3I5BI9b68rhPrqo+XxWNr+25nlUk+w
   3ioaluQUTx/CE11pm2Qbz2vI3Tg8TRD1vzmo0eE/7PDZlYqkeBOxwPOQU
   ZzqYhuAwUVEGmjVjYKgTXfHQZ9P1y8Wr6NYfNCKXI7/EdMxb+b5RBYBgE
   w==;
X-CSE-ConnectionGUID: 9s8TQjV+TYug4Xrsc4LxeA==
X-CSE-MsgGUID: fmyMV0AkQUmWFDC64xbpVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="30794606"
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="30794606"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 04:05:47 -0700
X-CSE-ConnectionGUID: cDTLY+EvQuC5xZld43QaOA==
X-CSE-MsgGUID: HlZvW+/FQWKjc+6OL8gd/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="78492006"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Oct 2024 04:05:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 04:05:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 04:05:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 1 Oct 2024 04:05:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 1 Oct 2024 04:05:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zEUo3eWSG5h5Df5ncVpzUrJNbjU/UfcCdIAVtSylS6ZS8xA1kcuLVBFUdS4nOgSjWBvHb9QHO4qUags+Hx4f6Xbn0yNAd9EFnWX7MERYRHpjZEmMWgrAkGFbPKRLFxQ1gI8GsedXCrrlFQUjr/GhCN/DVGJxp3ONgLzmmL+r7GR0RPFfP4h3LrKaXd7dMszS+2t01l1PIE0v+TkXUjA93mgBRRs6hl4+rOxGN+3pOMZjAdXYzMgaeqsPvJ1RZ/K5r/89j5ctHEbWdnzh2Z0i9DQ6/pqSe2SGOiYS8ki6+bFHIWPoMWOnd1EXFHtrFWQ4Vj3Pmi6Dzol09axaP/Rv8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvOihc56HfAuIhY8pN2YCBfYv/imMqMIp6M/kVUR1dY=;
 b=MZ70y+aNSyqC5O//foe4GDCIYFJGZ+vujlDWF4UsospFisD98mnyFOGbyjqk6lkwXwvtxeMFaWjR4jpr8FqgWd+SxIiAlKmTuV1jNQPe9eqB0jZND+2o1kZpUKHH9DDoV38VczVg6pQMbZ3AhNhgTTOq2rVg4MMSXNl7H1/uKfcNYBOBADK0Hq0w4dyNzR8blvI5UAwUBSNziRhRv+VnT4e8TFIBGaZkw2AEqmx8+KMHcUBHOADktZxTm4ia/hgdH5/0d+lui8VIJwgC4tJlDm4IuYoSmKXwRCWeEJFZ8cmwWgPP6CrH2JSjyam7BCK5tM1wK/4gUWeaJyFS+5kAJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH7PR11MB7123.namprd11.prod.outlook.com (2603:10b6:510:20e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Tue, 1 Oct
 2024 11:05:44 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 11:05:44 +0000
Date: Tue, 1 Oct 2024 12:05:34 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: Jie Wang <jie.wang@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Damian Muszynski
	<damian.muszynski@intel.com>, Tero Kristo <tero.kristo@linux.intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>, Lucas Segarra Fernandez
	<lucas.segarra.fernandez@intel.com>, Dong Xie <dong.xie@intel.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - (qat_420xx) fix off by one in
 uof_get_name()
Message-ID: <ZvvXfva6lCv8mnZ0@gcabiddu-mobl.ger.corp.intel.com>
References: <796ecd7c-54ad-4bec-b748-3e156cc0a1aa@stanley.mountain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <796ecd7c-54ad-4bec-b748-3e156cc0a1aa@stanley.mountain>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: WA1P291CA0013.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:19::16) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH7PR11MB7123:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e0708e0-9e2b-4a2a-eb67-08dce208fee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FNYdHi2KrhlIiO3cS7ilb5dJI/z+JsQYiHnhoq4J22otZJdIBbCN2IZ2aaGT?=
 =?us-ascii?Q?fXecF+96LT/m4HJqDoAGwxh/ull0Fv8OhtnrsaaXZx+2ukyuQifpqNcIPXst?=
 =?us-ascii?Q?HqUVoC1bP2j4h9yrVELNkTU30D5CPM1YhBY9vXPBLMI8/ZBlYTIeV5prU4KH?=
 =?us-ascii?Q?AObuNweqm5uzy0C1Ft4NPuXLdTdcCAhY3q+CZ7ygmWHsF/OHoP98jejStsOd?=
 =?us-ascii?Q?0yLACfIiCK9m8UWASd9auSmAAc5RjVQk945+Y6Wp923+fb8+fOBlEVnGu3jO?=
 =?us-ascii?Q?W0RpNYovoKgaWM8UbUCHTAc88YfUu/t767+SYsXKkyzUUqaPehpYe5FhXwGk?=
 =?us-ascii?Q?0GBAujsqDnsaPDiPDtBbWcI8G6lyZZgn28DZPmddYZSMM5HkwWqiolumV0A/?=
 =?us-ascii?Q?CzhTgwjNNjEoBeZJHa41MiexyLJqc5CVWV4+8A4YncZqafGxfMU4q1L76qXH?=
 =?us-ascii?Q?mXJqo8a2a3AiXflk2NELMBCz31wcD1KBzYgHV18lLLv3M6BJTo0sxUL/nRmR?=
 =?us-ascii?Q?rkGQYoM37+8ZfbXH/S4gEAjIQ9AG436D4K0eq85w6BJ3oLKqJRPFBHnDoXvH?=
 =?us-ascii?Q?YyRe3Xg77QwWMdGZcfm0Dfn52RtlI9t/6LyRGwOV+dUm8qV4OYzeImvQr3ju?=
 =?us-ascii?Q?fQXWixMZFTu6YhrjMzxR1mkvINo0s8RAL3ds/A0i0ma4bwjNzvqTQhxfTL44?=
 =?us-ascii?Q?t1+w0ucWKIhxrPrrxJx1qpgwaht2yQZD23YEWEYeqtYYS3bYnCUwbvLBMONP?=
 =?us-ascii?Q?4bEbyUoq9Hz7IrQ10QN/+UOl+KPJE7hKaarTmsmhyY4vBIMU0EtsbCEfgNbp?=
 =?us-ascii?Q?SEoREmGGAdoKyBrHY0q4B9v2VoDK8HlhOolI2XEmd+p2D22b+OMYFCIxujQe?=
 =?us-ascii?Q?qUBG/5hOKns+K4x03OiPQQQDKMYYVlWdyx3WQKanm8qm6zcenqFzGuaCp86r?=
 =?us-ascii?Q?7NL5mTz+7BZJBV7jRWkZ20+aoRfRmDOc216ZI3neT9v4cOcAva3ZtLOXe0sr?=
 =?us-ascii?Q?eVh+BrXAuqU4G+gx5LNgErP1SsjQrhdSl0dawy60CdJwuGBbEh8KKqU/oiv/?=
 =?us-ascii?Q?4B4K2O0HQEnAu4NtR2UALKdCq+OvJ8fYbv/7LwQDbGhB8SpxNdyx6sWsB2mZ?=
 =?us-ascii?Q?jg+JnADjBc7eZ+F5j9j9kYB83LpQeOWuKHnr+9nahpX81gJ7IQl+a1jSThRe?=
 =?us-ascii?Q?rosS6s9TA3V/rEX1Q4+9EQtK+dPSjN7TQqaq0H8lQ8WcTPml1BaLPxA2M/v9?=
 =?us-ascii?Q?p5H4k6rfJ+1M9JTpVQlDninWvv5EW0fImrlsROH2ozNbSpHWGpEaUyBsoxPB?=
 =?us-ascii?Q?u6LJJtDAlHFXj54B6oA+ZAj2b1k3le0w8I3jbVVRGpqhkA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DpPqYwiPPcMs/viC8UG1EGaMfcDe6nzZskYtlEFZPT5UgIhdTr/KILzU6RL4?=
 =?us-ascii?Q?0H/jGjCzJtA1h8QnY+d8MStWb3Veg4IggZo4FPR9ndYnqEvpcxqBTyCz1/FK?=
 =?us-ascii?Q?QPWeTcLelXNTBGIdbYgoy4/p4x+BZJdOD0Aq+Fsomc4MwRFbdbcnpeM7JbWe?=
 =?us-ascii?Q?ysWy5U4NSKr8tIwAV4fv9ygBuo3+aN8DaggQk2ba0Xm4aCmTLt0Gz9/Bd3+Y?=
 =?us-ascii?Q?oUbF1djM0gCioLlLFHOYmRTicnUdtDUzT+AKmKaX0GjSCDSRr18ylonYV2K9?=
 =?us-ascii?Q?3rhBR51P0exVqUqXAw8//wtGtTac76f3EeTlVOv/qV0RamQJmlK6SWD5Ng6T?=
 =?us-ascii?Q?F9cNaF/lLR9kR73mDb69/WmUL8IIEagKYd7ZJXiT1n0wg2H9ZEBJdzzM9UAN?=
 =?us-ascii?Q?ZH11QMRGGLKs9P1Q+l0x4CyPL1mzxpW1Ez6fos453N9FU/kVO7D/5gcki/4N?=
 =?us-ascii?Q?4JkvzLuKeaoJ0KTzyvSA+NPGrz5F6MePDR/A6uwjz0w/rqtBU2/8fokLvCV8?=
 =?us-ascii?Q?DmDwM4brIGaQwRBbzGvY99y4NjB38GhU9UoBD9Y037KKnD+OH0gH9UanYD7E?=
 =?us-ascii?Q?urG9V9xYVtWlWSuIeASjxRdnKwwROQH6D80WJL/Pf48wpr7quOkdqQ/ah6Wl?=
 =?us-ascii?Q?zDDSPDsnP0S8Gozd9t0LHqpWxEuMg9kECZI+/9HDvRiqzW1Zn9cMmwe7BuWH?=
 =?us-ascii?Q?gHHviLKhTPryCpibBcMp13sOBT/83aJVJaTLOa3hrCw2+mwPVTkGA0BHsSe6?=
 =?us-ascii?Q?BVMC8dO5IutlkKylvu7E8HQTHe4QVCkQHGzy8Hvuk8EH6iQOkEIUW677moiJ?=
 =?us-ascii?Q?rjBg8bSE8R+XCzfPXbnzuODKY6thLHUpfdPCKZZm+MoDS+8BsTOSNB+Z4ghA?=
 =?us-ascii?Q?h9hvaMVjixrB6HCnyXzE4fzG3vQ3wLZ2YVsBPphspUC5YfHsBmilsi5VVfEe?=
 =?us-ascii?Q?EmrLUntmMS5/EDsxQPZEYcZNfcf4RwW9YisphmG3CT72oTWM3AB4J6u/cCzc?=
 =?us-ascii?Q?E3XgFwEnINRUydAl/ashviTg5MPMasuZKZ7QlfGQNXk7hOZ+ApE+Y7BRQd/d?=
 =?us-ascii?Q?azGf/rh/Cv96AOvoSFWolu1iFw2Fv6mY0Q6Poek9Vf3FfjyvxGt0bkdKluOi?=
 =?us-ascii?Q?OOPQCmCYE2AoXwMRSn0GOA3541mk173fY4Rf0sS/P7T08a1JdA3pjmaM+Zof?=
 =?us-ascii?Q?PjzIKy+mWtziiIXEUIplvlO7sPrFyfjBlJk6J+8Xu/wKtKMVG3Mp23bVKFxU?=
 =?us-ascii?Q?3LCD4SxL0hfas2CAD/Ibia1blikFMLtKqm+LebPsNBwa+X0bHcltCpF8dM97?=
 =?us-ascii?Q?yMvj5rva/EechcPLVlfYxT1iz98XgtvX4AXxa7NvRSXnLq3eitQvzimOFrvP?=
 =?us-ascii?Q?4/VHmz4jc9XG1CUQI1HkKhW2Sx6r1ds9/Oq2N5yXWGrUthS+hynj7+s474il?=
 =?us-ascii?Q?7DW1pUPZpJeDfb4dDHQMUDbEodgCLt6wXR90YBfB2j+dOvGVJpUV2GfESU60?=
 =?us-ascii?Q?fSvC2YZj2CFIzNOlDZvJEqqpkFX7RoejUxeqWXFM+R80qVqnDfmNePbUOEVV?=
 =?us-ascii?Q?0qg3Wmp9PKraoc5IVE2kwJ6zqOcBxGNA2j3/cbcL7urxsSUQIYnCVG+SoUaM?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0708e0-9e2b-4a2a-eb67-08dce208fee9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 11:05:44.5230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qqw7FJN7E2XlnQgZvwgfny7twQapnyT9uUem/YN2aBVTa+A59xr+sbX0G24LLwUpllxAfjgz41mRCvcHBaw1aScswShSi/oFdLTX7ewlIGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7123
X-OriginatorOrg: intel.com

On Sat, Sep 28, 2024 at 01:05:01PM +0300, Dan Carpenter wrote:
> This is called from uof_get_name_420xx() where "num_objs" is the
> ARRAY_SIZE() of fw_objs[].  The > needs to be >= to prevent an out of
> bounds access.
> 
> Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
