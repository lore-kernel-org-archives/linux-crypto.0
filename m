Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8349133F361;
	Fri, 20 Mar 2026 21:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774041065; cv=fail; b=gw07DWDoLx/5ivThXvN8BBDOzE+YVkjkX9pRJZe5TsO+M+z/Ne7BCLueADHlgBxktRe4UYnjypwO4I8eUMYm6vuyvd1m7FnJPmD0ysq0q9bD2XSheXh8/BFEkogY2uKJu5k2v47QepqrWCbm/qR9G60oASqh1tb93jK+4mlx40I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774041065; c=relaxed/simple;
	bh=V9sDyDjqyCHO5vegoE2fjFC7IfVFopc+NupxTPPdlqM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kX0N8Qc9TfjBc7wZkHo+10b9j/yKDzWUzDrnBKr7gl/Z8x06htsvHVGKAJC1RbucNiS7ZpS2gLYOyAgvtVciI8/bj5/ZRCRppow13UGTJJ4GUpQsn1Bc8OhA6g59UHlnrTdItsp06eZf8gaEyDtio2QL+Z4/NX5OPjnHf3ZF9WM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gj0CeR2P; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gj0CeR2P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774041062; x=1805577062;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=V9sDyDjqyCHO5vegoE2fjFC7IfVFopc+NupxTPPdlqM=;
  b=Gj0CeR2PaNBLcEwcIcfDdj1AOEGqS6/h2aoumam/qaw816lDtVLi43se
   s7Ysm1ptfSaOCtTJmDfqCQJtl+Ccaq+WK1ZcFJkZhi1og0/Nl0/y+VAYC
   vyhn7XQUjtXlRmhRxRS3gTV7jTpMXddkrv5WAADM1jG83pmoxE3qyzcHi
   7TgPQg/3jE9IisBZOY6OXi9mFXqjh3d0P1sPrihL7NHzGgNZHT67XEPHL
   okkH34V8XphZct7a20+1EjQUOXVJ1eKJT7ICR1/ftMaXXc9kblFWX16th
   oCyZ0sqgUGxHCZoPtU1uQgxfRhTuYCMYzJPf6zHhqPbwMPbUBLVEbZTv9
   w==;
X-CSE-ConnectionGUID: G9OwQcfHQC64hAQMPiHBoQ==
X-CSE-MsgGUID: TYjvAqg9RHmYKnGtNKIICQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="78992366"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="78992366"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 14:11:02 -0700
X-CSE-ConnectionGUID: ht/dgVSOTrOoszcpV2awBA==
X-CSE-MsgGUID: 6tfxocGFR5Sx3DZ9LeZKCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="261294917"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 14:11:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 20 Mar 2026 14:11:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 20 Mar 2026 14:11:01 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.30) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 20 Mar 2026 14:11:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BCVypKC3ULmYsf7HGS8K7UxpBYdFAACumhb9/5pfLIEBPQM+stURZLnXex8WFfYwbjiJr8wUjQcQXXhVBaFoWs1wJLT68Yl27HDXVlE6md5lpqLe+R6WtUzFGolpWQsyIVKQM+sMkK5AfCfPhocklf6gi65SaixWZgE1XrBErpCv2h4uPvSduI0Tf4srEfIBSsQJeG/xzU/rbbQH/72rfPmvnOk+4uxe/lccwWrBj4IpO86sBZKz1k1tnUkKh4rDONEJ9wFtQtwUavM1IaWdpigFTEq8JpfFQdG7aQRCXVdfIHEzNlk57WxctQLDst7H7edV1lzHZt+1b9Vejo6aOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miJwuYhXGbcmp5oSWlc/CtKDjDYnk1F3v+eSxeq77zo=;
 b=W4iXXMglPnPuqCLk+uh5v5OQumt1O5TGLfHd7kIE/zyIyAWOCqgMnh944tU02v4oLEYUcOhI0JdbncyMKQmze6g+7UYGQmiwb/m/h81cWKgu4OJjAcXjw0D2pRgS7MQ5iJPnarYD8lqcvZjoCbgAbsleytAOCnxKU/U0owqow1MeuE4tLkDZkxDN8ko+wU+/IG5bldWfBk+dky/IWfVaN3DG8ZpkYAViIZ70b+wHMJRwmg5yHwHkTPedPUIMBDieDSXXrneIG4dhbBdaiMrmpaKxE8KJaOnX0XSC/C715s+HaEr2THDzREJ1GXiJqg2ApNjdIrHpsdQJhcPhhBzgWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 DM4PR11MB7255.namprd11.prod.outlook.com (2603:10b6:8:10d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Fri, 20 Mar 2026 21:10:59 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9745.007; Fri, 20 Mar 2026
 21:10:59 +0000
Date: Fri, 20 Mar 2026 21:10:51 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Atharv Dubey <atharvd440@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Crypto : qat: Replace scnprintf with sysfs_emit function
Message-ID: <ab232/oVbFU/+7Pd@gcabiddu-mobl.ger.corp.intel.com>
References: <20260320-sysfs-v1-1-91fd5ef42dea@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260320-sysfs-v1-1-91fd5ef42dea@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU6P191CA0043.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:53f::29) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|DM4PR11MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f5bce7-baaa-42c5-83dd-08de86c52f02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: vSp7i+qkDnCpkO8upYfddc64ftIj0mZNBDUejm8SnXIGepiORTZYWtsi0ILNmHHFbjVkq5ktLQkL4SE03/suyOdOugl35+2Dknx1A07g9SHtai04hVZ4BXuCH6eBl8YoBlLbNiCKsicWAUhHx71WZ3or5c6kTZsBPoV4ySxF0SijTvEgoDsoIEVPcXoYIYZgQftutxwvlq81Nz/O7v/fyQPYvtK9i3jMbLDRdgolJK4bIK7GygimE7ygj/xfuV5+W95yOHSM2r9MKq8G0Zk0niOORH0nI8afnxzDfKMY68y9JV6Vj3lPl3rwM1W5szit1JOP6AcJl93p8HAg8jueNP9dC5wTY/pgp5Y/0iIRyugLrH7ZqO3Bu3IcUT1MBxXjgZ3MAZRENwpUxuc3F4jmdXbQxqbzP3ScdmsbBuHXMZcuYCFul/Eix96NaPE0kB8zfC0Mm55GFcsZVn8K3dcaWWYb2m2+JkPYt0S4V1dPwi/GITMQEkjb/35IPIGJEJcXJLzwGByhyPtBKIfMuW8bVnDOPGbH2wUx2f8XrpgqVGxMzWiHiYPxiTqY2TKSjPMmKmXURlypNnK1q03MIQT5Pxxa4N0ZRRd33E4E7/I6riH2e0h9/TRfjxmjK2rNwFgtRzKcsbqD+Qx81DVys8uY0c5I565WPjOgkGTdVMN14RM6MXN4wL/rZned2p5Q3CCi+i2H9id7YxijdpfgGXHkDTRTm0Wfia3f/vSign6ShsA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UhrQjXeq3Drr15nzCNgXHFKqUVLw54H6WcGnJu5GRdPBQ/sp7KxyhgLZ+xlA?=
 =?us-ascii?Q?v20zZZXtwjgkVrx2XyFILY5HBZHoS0nL3Mxa4iykgGzmROZFgjEqXFOs6P6l?=
 =?us-ascii?Q?bXW8mbbVVBUnwQmNNPIV7J2GbpUMNJggkzXDQDqL08TTCrb+8KcuNFpC65jc?=
 =?us-ascii?Q?VQehxuUCBsm3C+cDJ9/tq9OK2k+30qmnbFXN8/q5wyS45d3Hdt51TzgIhoIi?=
 =?us-ascii?Q?bYHdi7PWibiA20daGEKCnMbSYMiRE5rt7LZ6LV55+pIKGsauBxtUWo472BYB?=
 =?us-ascii?Q?CL7agdMxlrLw6mk0rb8gnXtTZPQu5i102hG0vbZ2xFkLUZ3/D+kDMdJnYGZ9?=
 =?us-ascii?Q?nfHn4EaaHd+liEBTd6aiq/jbdefHhfzIJO6r2hwoBkO670Z4Uojf8CNUI2cu?=
 =?us-ascii?Q?WB2seGSue9RvNV3VK4+tRAi/OtNAzZzIRFpwj85cnouisSrypOv1bvkya/8z?=
 =?us-ascii?Q?reStJ533t9tHodAj8ySNv6IE2XSCssHRmdquiz0CG/LNfRRvoq8Oss45+5il?=
 =?us-ascii?Q?aOXrjaQOz3kJgSzq4WKVTJMmhdjm7Ct7htliXyUeAhJ7fhTVYHlxEp5Fd9xD?=
 =?us-ascii?Q?Y6/8IrWV6I+rBLzlzP2sQMp5qJWq9VqlxXQopwaj6Zj/THrH888u4VdT/dHc?=
 =?us-ascii?Q?4DUur+QWaeGKOg0BrWYbzyuBssqNhPX/m2frHu0sQ/oEF3iKCOV5wHf/6obh?=
 =?us-ascii?Q?uUvZ4Po7UZwkXcVZ1oMdC+YR6hE8leoEOdmngbTaplanjHoAx69dr6mAHZ0P?=
 =?us-ascii?Q?eulrH0QWHKGFKXzXCfm/rTAzb29hb1jB4OME9KEixqVl/M2nhZ+M9PMVVt6L?=
 =?us-ascii?Q?YRd9SEKRMMXeiyoR3K9+vQnSvPXFDPuMLxIrqB4uDcTaB8HkRWyaSZq7g+Q2?=
 =?us-ascii?Q?w0KsDL8pMB23TbQMyOW/TlcimeK1jJhEHNRvqc2BfYluAAaFrlUKmdu+24wT?=
 =?us-ascii?Q?QMVqHIj3cn1QTuOUgZqXMAWW7Lewh9uhR35ZqWeTvoIjstfnYmtfY2Q+XXrq?=
 =?us-ascii?Q?lGcV4tkZLndSa3om4IiAG0r/3q07stwDm8JFqwT0dW7cgaBfsjePZuybQsi2?=
 =?us-ascii?Q?01OXesfV0mzItUR+LkOL9W0GVpKgbqF6VxGznjN5LswKDAo2ANI7gQSe1LHC?=
 =?us-ascii?Q?BkCVEJoCcAckr/5ZfvVHSY4X666tqzfe6ojyyaBIDzQ45Cnl/SrxmPRKhnyU?=
 =?us-ascii?Q?uZEIHkQOLdr3RyHt9ZOyfZm9V0XTJK3vs15wkWnGfm6ZrkOD4KyzZggWwjlz?=
 =?us-ascii?Q?DFfdlmgEOegrdB/rh5NgMpGutqEWbPEMqmSg3myLbwBMeM8N0/sBB3svW9mq?=
 =?us-ascii?Q?inoSKqP5tt3KcMn9Y6GlXQsqzkAOhxeyNP4UOzuYIn4QOQTVWk4besAxr6UQ?=
 =?us-ascii?Q?3ANY+Zf1N15Ernmq8pygK8sWJIpgWCRONj7mG9HtWKYWjH1Ykj1U4IsP7Au9?=
 =?us-ascii?Q?Pp4jJu5tJ71EfHP9Q10iyxKGEzF6iHergMAiDNebWiqCUPLE5cTQiVhTLULc?=
 =?us-ascii?Q?g2oyrzSR57OuKwksj6JWxySUdXWGeRX3ke/TuxU0odw394knqrBW7EKUExtf?=
 =?us-ascii?Q?dl8UF/r6woyZaksLoy8/m53TsjSRqTldl2IzUoSxXa+j/x2vfHh6GbdEBQt0?=
 =?us-ascii?Q?FFhLDSRnlHpWb/Nvq/yrA5Xz93uJxm8wPWiBtRL9uMzAD0nl0gw0WffjJ+yZ?=
 =?us-ascii?Q?yn/gCNjPUucTqNfvXVYpjqzl/9NAQXEOYjeQBkNdszteK9rGMAUZNzq4k0iI?=
 =?us-ascii?Q?kzcFOGNOJ8/zPwt4B/YnXHyKYRV5ns0=3D?=
X-Exchange-RoutingPolicyChecked: UOAgu1D6nw1mXQ/iy5REARiFcvvwX2SatZT2xd9z/VaOpts9H8ZNMKuDhbXQKzDc8wp988aHwRqDumffsz0vjZRLC74lZzgAq6M+xivmcpshLb2iAfsw3CIPSdZtSANKInWxpG9Q+oAxZ49i867lfxaQW/YWWVCpe+efG1MoCyUiYjfmVciXCsy+hb+n/N1NMbq84SK0bennobpW2lAsH4EvpYvN0NZ2owwuVRbONunKsGyMXz+p0NsazgHH+dNtNzikzeN9Peb9WVp3cXPou1Jwgh20hcg5HQt6kMAHS3uANca4mawsMs2Dr544xCxG61hz9vbKNwVhnnFTeJyq3Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f5bce7-baaa-42c5-83dd-08de86c52f02
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 21:10:58.9536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JybKfAn48/cXxIUI/3zkZNLyDpu2OLGjhzV2mCvLEPafA0o+9fcf/KV9cmUFUGBv9f6YhTsdWnoDwZcrgV/qral9tZnEqsklIIYrf0YWqH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7255
X-OriginatorOrg: intel.com

Thanks.

Can you re-submit with the headline below?

    crypto: qat - replace scnprintf() with sysfs_emit()

On Fri, Mar 20, 2026 at 11:49:28PM +0530, Atharv Dubey wrote:
> Replace 3 sysfs functions in the Intel Qat Driver
> to use sysfs_emit() instead of scnprintf.
nit. scnprintf().
> 
> - erros_correctable_show(): Replace scnprint() with sysfs_emit()
> - errors_nonfatal_show(): Replace scnprint() with sysfs_emit()
> - errors_fatal_show(): Replace scnprint() with sysfs_emit()
> 
> This change is in accordance with Documentation/filesystems/sysfs.rst,
> which recommends using sysfs_emit/sysfs_emit_at in all sysfs show()
> callbacks for buffer safety, clarity, and consistency.
> 
> Signed-off-by: Atharv Dubey <atharvd440@gmail.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
Apart from the commit message, it looks fine.

Thanks,

-- 
Giovanni
