Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED88435C1A6;
	Fri,  8 May 2026 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778232333; cv=fail; b=kDlq6PXfx5x4jFxAtT/C6Cz7pBTR2Mqe2EzenDCmEAXIWCmYCsHLRvvxREZcORtiOmv7NPwYTIJyMmEbx7cyE7hkd/DbbdPzCTZDaJoOSlap+tH+H4s/E7TfLc575kgTgFtP3KXaFNazDmM/Bc9fyIgnOBtj+LPP/fRNRqhtiAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778232333; c=relaxed/simple;
	bh=GVrbw5OYpJ/4/4X2J0OYz8LhTfLULZWF3/ZTdKYJk74=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=naQYF/RjHbbxoFME6CgmHJAKUt/kLQ1VGJdIrEoEgEGjuZxNe4vPOTU3LOg9BDAmRtRQn9B/jkoBaEEAUfBfTVIQXYmhwqTj4b0Ryt+m4EX0wnjsQWNiqgusFA/2l3f6oAMGG6FoJn9DPvUGO9WjJtKTSGgoRktBeTrELWPI2bI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5fNMqdv; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5fNMqdv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778232331; x=1809768331;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GVrbw5OYpJ/4/4X2J0OYz8LhTfLULZWF3/ZTdKYJk74=;
  b=C5fNMqdvSVMgxJ3uDPt++rZLKzXzVAICCR2lMFxEA8xy+UEqo42SX0ES
   ZG+bcZDeY4DtTyokdCqMLriaVumlr/S+Kuo82ous5LmT1fyvR3fSVTNhl
   pMU9zsCfNtxPmUyJTWrUFJ+n4n8V0VB9vCbpahOmOgr1hXSfRMIOmIKXj
   70llg2xkD5DIYg1H7IS05z7bESmC0vEzjGngtv9IBlAJQt3sGR2B1+OyJ
   NRht2/nOr/hOxNBLuoMnMPd9az7C9kehPRGZsTnzyeOdxVxK1dMsNUtwJ
   e9v7Ajy9666a/x7kM0ZsqMbbZRWicCREMAeMNm/jl3Ot0r2ao8FEQdngv
   w==;
X-CSE-ConnectionGUID: KylqhjNcTbWTZXAl3JNo9A==
X-CSE-MsgGUID: Zga2R33aRrOQ6a13+bKMEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="101870099"
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="101870099"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 02:25:30 -0700
X-CSE-ConnectionGUID: vRLDzDjMSZGkbC+NjO6vLw==
X-CSE-MsgGUID: Is/P0NMZRterSKdtKTU3jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="241723732"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 02:25:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 8 May 2026 02:25:30 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 8 May 2026 02:25:30 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.61)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 8 May 2026 02:25:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NXZI84eD5PERvHQKlD5KNkIWkZfxAG4+U1aKy80pA/iM5Ht2t58RvcIL5eARh5V/A+2Qcihcpr2C2PzCgzW1ilFh1qdKZ5KYKjcxAxvrjdRfxIlJRMVuCP8WpRt/1haWz9D/2off50kY7oiufRg/Hkx2mr01uUVIGg2jlHKcqFKRTApuzUJL3jHYuhbL+ob5aYF4rqKEjCj2tYafmFPtazT2CIv2vqXRoOFj2ziiOCj0g0EwgmRuTLdaqjUkek2FlJOecIdS7xht/2LxH2FNRf8xUTl8Xp3tnU/qNHPffS5zyB86UBOtkM6gXe/+V2GhIKGaAYdG32xCZfGh4a45fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kj30F1wgT5B+aRXWjSk45QVxf0SQ9x6h8R6tb0p1y1g=;
 b=fWqJNk1kMJpQ68aMHCkzDenqqi6sBdPG/HvJtl7Muq7KFvy8ycK7jL7JTBhDuHZ8YMW61q/amRzz1Nj96P14dWCQgsbCdaxPUUm7B/rjSchz0cW9dDQfnZ4HG5w6MTXDU9t04NoMn/+fZTt0bZe5gGC7q4Z4IkLDxUwXcoGmZSL1jUCQMMJAl65bFN8JVGZYjNOHOtoUpC/bO+ecr4rlGOCx7vJDVYWDuadJx16SNt44V4Un5cG7PrOnbQGLMtpijzW9OVxBi/a/vIrT++cPllIAxpY0pL/dN8wO4UmV7UzpScU91kMvw+WE5dFk2WdSEXm9OUsg9Mmoam1cAkEoLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 CH3PR11MB7893.namprd11.prod.outlook.com (2603:10b6:610:12e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.18; Fri, 8 May
 2026 09:25:27 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9891.019; Fri, 8 May 2026
 09:25:27 +0000
Date: Fri, 8 May 2026 10:24:33 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: "w15303746062@163.com" <w15303746062@163.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, qat-linux <qat-linux@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mingyu Wang
	<25181214217@stu.xidian.edu.cn>
Subject: Re: [PATCH] crypto: qat - fix use-after-free during concurrent
 device start and removal
Message-ID: <af2r0f/20watHiCX@gcabiddu-mobl.ger.corp.intel.com>
References: <20260504025120.98242-1-w15303746062@163.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260504025120.98242-1-w15303746062@163.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P191CA0027.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::29) To BL3PR11MB6387.namprd11.prod.outlook.com
 (2603:10b6:208:3b7::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|CH3PR11MB7893:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a91689f-b16b-4207-dfea-08deace3bd59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|3023799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: JkTtQQExCXoYfw9P6JCF3uV+cSEfrvXx8FBEsR1ToLM2LqOVo+KUgnhuPihjnKIdc/kqARgNkYVQzhL/MndfEIpby03ZvluuVPqQC7MUyz1k6MCpvMmDcu6gOlMz2gSFv6V9SJZImNwwoXj5y02Qz5TjEzsGpWUlLc6k2fodXciDXlkmSFJnr4i9Lp2N5+wEHIB4bOafIxdHialFlB9E/jHNStsnrvOW3Y5yY6Z1DI5aw5ltY5qLZOWi+xq89jMSug/+qbJqj4XgtwEPNKTlsc+934xoOC59ZfL8f+4cxQ/KNHTq4LYkXEwfBRfDDG9fSAnxmgHRSnp56tVHJdgPlRizaTBTUbn9jF+RB9Jjvvegq/+8ppyy4CJKmBIgsLnXGSfo8k5zODw3T4aYn5UK1+1P4ETjdIrzZ/7JyGNnfEpooz9TJIR0Zv7glrz3thXTNgRdmlexBYDa051aWTdOB/harOAd9vIyhui8QeAycZnNKY2TCZea16I0F0Y4kVMEI0P11ROGzs/ZzkxTB5dAvwaiHJ39UfWBtuV3ud5jRFHKUxgohnHQRlJFL1maVUBcYQf86NvTpmntj7Jsf9QJhJHkDPTO42MzdCpo3YknJTmMRxpBraleeRoiKjBbNpixGcTVss+6Movmn7Lg/X6pATdZxfryoN2MdQQ/+mbW8gGwyKJyYxUDzdpHJR5mec9Y8xcAFNxAYdWQZP7v2rWdjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(3023799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I4AFNRYrG7pDpmrj8X6xv5RcdJLSKowvoRWoLWRTz4484cLaJhnzs/kHqT4+?=
 =?us-ascii?Q?0ggGWbJTsi/L3MgVJ6YwWtkyLhgPVu1Vbour6LZWKu58RUKcvfMzdXXcwz4Y?=
 =?us-ascii?Q?1NVAl73bzdH13YKVSpLfHGD4qEaGjmuN+4oPHhbkePMQDxGWTmdUbXg/VLj0?=
 =?us-ascii?Q?Yr3s6ejbSZKfwBhUxbIpR4XXscxqBzcx3QnhMVAa3PJKKbGfCiGOIaesdKEW?=
 =?us-ascii?Q?1bDEyH5c7QAAaHxeOFF8h24pDgEQwsKoEV+fm6k7WVe5Poj6iHTrSG0JunLD?=
 =?us-ascii?Q?qw8wJ2/Uq1nPVOwHddY/KMYzDJw2Xl80hHwbIWbsp9vK3EVIC4dIuBxkaYmT?=
 =?us-ascii?Q?Ybi6W478YuGTc4/cn4eG9Y2desvkFdK+/faoiI3W6sNxI0PKmxZsy7YNAhZB?=
 =?us-ascii?Q?6Qf2BgDtSZWGtguLIFerRnoRAH8GWx8J1NPXXAGZ+oapi7HvHCMRMA0GlgVS?=
 =?us-ascii?Q?9rOYyW9y5p5HXAHj4hrIHuWiKpKdnI9NQrEV/oNh0bv6M4/+U+L0thHW5CV9?=
 =?us-ascii?Q?tvkwVUz+BO01ob5wZzCCqkUDcFGgaqOQtLzB8t3oyEIv9IIkXxuqUT+DQmCK?=
 =?us-ascii?Q?JLffoqlP24yKEtuXhVoSWTaxIBSAVp09Nw0KvNGOWwA+dAwAA9eTgp96LnQR?=
 =?us-ascii?Q?dpQ89A2upM8SgVHtfsSmoa59GuEwF066xSDiOL7YEAA27lVyuArPrXAoU5dM?=
 =?us-ascii?Q?hwUprwnbelgYhF8YeSITrOFeR+OxGeLyKWIvAqxfjW5af6ozeC2/Iuqz5J+K?=
 =?us-ascii?Q?Ea7SG+PCGWjZc1GKv9OVoLg6c4gbwLKWadZ7sIRAqiTDPi+JPtwIe857795J?=
 =?us-ascii?Q?NNTw3BKWMcrBRxnYBarxLXdvYp9G3bnsiS33s9PVXe7U22tWphrJAp0X6M+N?=
 =?us-ascii?Q?8vjS7YUDyIohNdlDnoAVGOgJohlISzCZXJL69eaP0rIUrAvWH7iIsEnzKKx6?=
 =?us-ascii?Q?/0WKT5CJxzLtRTqBY5RbBRtCpfpKvKPltwb5TtelYpsrKRWXFXcZ0nBJh4wb?=
 =?us-ascii?Q?4I5YjkNRdjQsKJCba7tJy8RfUZvmFmMHag3q1zGDi6AuengwTT+LgMFi07VC?=
 =?us-ascii?Q?jeoCdxsmS2QNtDW2Bqdpox0boITZzjey5+jXnNOO5FGREIawOJDndTMx9q8h?=
 =?us-ascii?Q?97D807QftyEg915DkfpkU530jYevnvM37yN2hMI2nMXxo0Q6aKMpczjULhJ2?=
 =?us-ascii?Q?E9bDibD42h63yoPmTLan66kv+22NVeuWbQMGm88SmG0/gRR4ht3a9ZLUyJvY?=
 =?us-ascii?Q?mo1GlIKHv6LvfPZh8WqWE9fBepw/fY6aK7tmzF6c/rtlnnauDFIw0PwsRy/U?=
 =?us-ascii?Q?rfMe8cLOn/qljtL8F/FwpUJmIw2vS/5uBflPYXdokixGYPFDz41WpP+oDl7g?=
 =?us-ascii?Q?Vnf2B8V69YsxTqf0XcSsrXK3TSpWS6szdovJbpBEvZsfeJ415IX6l9yiuwQF?=
 =?us-ascii?Q?/KD9Xq65jZmbj+JfsTRf1p/sjgCeTDB/hGaP9MWa+G+m1Fc4IQIJdFCo9VMr?=
 =?us-ascii?Q?NbaUnG0JEO6O9cd8keQXqnDjUskYWIrfFTCwlGN0Y14TfXeULJinBvxwQf75?=
 =?us-ascii?Q?ebhQtygGCMK5dY/6xyhTD/MZMBnn6xIxTqIosEvv/9Km7XRdGdPmmN2Han7w?=
 =?us-ascii?Q?dZIYhosQwe+mp80e3YZmj8SnDpbAjfIhFlYCgIKZYlgxT2RoZ8KgWF9Soqem?=
 =?us-ascii?Q?b0STx6uY4pnuJzQqWRrMxVjj+eJw/oIqp5EU6WA8TOuR4HfQt7KdnJTSr4/N?=
 =?us-ascii?Q?4xXCUqPZYBEjkZ9yakoio4tvAmZSt8w=3D?=
X-Exchange-RoutingPolicyChecked: oQ4wHX5y9E/vUrw/aVvjK6+i9AfM9RR1mIoMbremySrbZop5gUmIEvtkGku+imYLpg9J/dJo8IaPUJ7VcxQdOKFeQ5Q3V/8votg5bEujtskYPja+aJHv3R6MxsE0gFQKA0upMeWiSf5rFlYnF0fSMAF7SIWSuj/kH99LDm9d1qTkuNpIB4VEPzQhtT17Gf7GL0VsNPrLNunv+J1Fzq2BldcMUFNt9jd9fLIHtRIimv7rOL3zUo7ZCQDUW6Q4iN78a4iH63mQ2g7eWZD2ioZhnZNSNtLzakuBb8Jnfaf06nvCn+EhZM0TrSt1EFqgSZbJa2k2e5nL6lY3PHoRdWocUw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a91689f-b16b-4207-dfea-08deace3bd59
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6387.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 09:25:27.7817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3DC30S2fS1Cy4/huqn/+8jDnXDF+v3UrdW3Y+jamL/4w5+qoeCxMeqauoggWWQdre2mGmEAwF0AY7ZiMvXfMhfU9vnIu9GbAQ1h6vtuNys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7893
X-OriginatorOrg: intel.com

Hi Mingyu,

Thanks for your patches.

The ioctl interface exposed by the QAT driver is not part of any public
uAPI header and has no known users. I just sent a series that removes it
entirely [1], which also eliminates this issue.

[1] https://lore.kernel.org/all/20260508091912.206913-1-giovanni.cabiddu@intel.com/

Regards,

-- 
Giovanni

On Mon, May 04, 2026 at 03:51:20AM +0100, w15303746062@163.com wrote:
> From: Mingyu Wang <25181214217@stu.xidian.edu.cn>
> 
> A Use-After-Free (UAF) vulnerability was identified in the QAT driver's ioctl path. When handling commands like IOCTL_START_ACCEL_DEV, `adf_ctl_ioctl_dev_start()` retrieves the acceleration device using `adf_devmgr_get_dev_by_id()`.
> 
> Previously, this lookup function iterated over the `accel_table` under the `table_lock`. However, once the target device was found, the lock was dropped and a bare pointer was returned without incrementing the device's reference count.
> 
> This creates a critical race condition. If a concurrent thread removes the device (e.g., via device stop operations or PCIe hotplug) by calling `adf_devmgr_rm_dev()`, the device is removed from the list and its memory is subsequently freed. When the original ioctl thread resumes and attempts to acquire `accel_dev->state_lock` inside `adf_dev_up()`, it triggers a KASAN slab-out-of-bounds panic.
> 
> Fix this by properly leveraging the existing `ref_count`. Increment the device's `ref_count` via `atomic_inc()` inside `adf_devmgr_get_dev_by_id()` while the `table_lock` is still held. All callers of `adf_devmgr_get_dev_by_id()` are then updated to safely release this reference using `atomic_dec(&accel_dev->ref_count)` once they are done interacting with the device.
> 
> Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c | 10 ++++++++++
>  drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 12 ++++++++++--
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> index c2e6f0cb7480..4924b2bbb412 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> @@ -201,6 +201,9 @@ static int adf_ctl_ioctl_dev_config(struct file *fp, unsigned int cmd,
>  	}
>  	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
>  out:
> +	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
> +	if (accel_dev)
> +		atomic_dec(&accel_dev->ref_count);
>  	kfree(ctl_data);
>  	return ret;
>  }
> @@ -310,6 +313,9 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
>  		adf_dev_down(accel_dev);
>  	}
>  out:
> +	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
> +	if (accel_dev)
> +		atomic_dec(&accel_dev->ref_count);
>  	kfree(ctl_data);
>  	return ret;
>  }
> @@ -360,8 +366,12 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
>  	if (copy_to_user((void __user *)arg, &dev_info,
>  			 sizeof(struct adf_dev_status_info))) {
>  		dev_err(&GET_DEV(accel_dev), "failed to copy status.\n");
> +		atomic_dec(&accel_dev->ref_count);
>  		return -EFAULT;
>  	}
> +	
> +	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
> +	atomic_dec(&accel_dev->ref_count);
>  	return 0;
>  }
>  
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
> index e050de16ab5d..321bea3cefce 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
> @@ -320,6 +320,8 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id)
>  		struct adf_accel_dev *ptr =
>  				list_entry(itr, struct adf_accel_dev, list);
>  		if (ptr->accel_id == id) {
> +			/* Increment ref_count to prevent UAF during concurrent removal */
> +			atomic_inc(&ptr->ref_count);
>  			mutex_unlock(&table_lock);
>  			return ptr;
>  		}
> @@ -331,11 +333,17 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id)
>  
>  int adf_devmgr_verify_id(u32 id)
>  {
> +	struct adf_accel_dev *accel_dev;
> +	
>  	if (id == ADF_CFG_ALL_DEVICES)
>  		return 0;
>  
> -	if (adf_devmgr_get_dev_by_id(id))
> -		return 0;
> +	accel_dev = adf_devmgr_get_dev_by_id(id);
> +	if (accel_dev) {
> +		/* Release the reference immediately as we only verify existence */
> +		atomic_dec(&accel_dev->ref_count);
> + 		return 0;
> +	}
>  
>  	return -ENODEV;
>  }
> -- 
> 2.34.1
> 
