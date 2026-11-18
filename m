Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024525;
	b=5ULK0MpY4qEmLvsqZe/9JOU16HsyOfJnHY9ubpxeWMRkNYfnRoofUjU4jChhZNsvllgH
	 GAXd0Ns4CN+LRA19euk1k3lvSA6NN7aTw/j++NE6MQVsocTEGSchQBQIMGb8mPeOy+S0Y
	 flgz+gWkRzWH04SNygvwhrTG6q6OnQK7pngWDHyB0YU1fAfgG8Yk3fT56KxdnaC0BLeCC
	 9QqWXkEM8ewbtkwhbbpI8uAjyYneiSnj4yAMf9qoP6wCqf/2QlkIfH08z17fgcjvPOWaP
	 PPpVjuWWSSQxXlYNcI7EpCL7kiV8F12Cw68sv8c6NGYRbRMtDTcAV+VNkE6MCWAMEvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024525;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 Organization:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=whpnug8U0xt/M70MJle9NdwT/ixuuXV1Q73RnS78mGk=;
	b=sg/aCpHha3+uK+q6qzXXumGl/s7gZw+oYflXvecf5ypQDojC9YEDAI6CFrCIO/eOSe4N
	 xLLJWoOIz7qfRH6ADvuN0cpsPKy6dfbTcAQEvEWdKCBTKex07/X93Q66EcL/M89+305zm
	 2JBaeUVJlTbUxgkw2NBn3D1ooW9FCQH56LMUnmhzN72PBOiPLIcILr9aaa21SIh+759WJ
	 JPN6v+lgho4d238BAvBffHLI/O48JzCFJZ6933BYrEISibs3MBYyRIEs7L4oqIllZVtfA
	 NJqMKMOgCkiiHNsuqZ8hEI1y4ZhsqXgCgXuCUxD/reUVOJzbl591f6xDFVDXxCAMQIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HU7jZDu7;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=EzvXov0s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5285F606A320;
	Wed, 18 Nov 2026 17:55:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5285F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HU7jZDu7;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=EzvXov0s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795024524; x=1826560524;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=czgqYm6Zji3O5qQM8MifGt3/Bbs+wTmg7juDUmKuC+4=;
  b=HU7jZDu7fxk2odCtTsvhLOyaFf3pphK1S1v6BOaf86FS/r+aowxCA8UV
   NfJMQ19n2ssQWcCGOrBzQKaSx/JxFmlK/n2XliTsglpc8YzrtMzCMIlou
   rKC+MxLlsZzbEmgdHNznaKyBfFYKKxyGjoAAC4ibqH9hnwC7P+UuLPgOY
   Go4+8rpVqWT8A5R7BgIT5UB1RDBS3KGNJa9A6y6y4n2nKthbrQ/wxUJtl
   HgwpdNEGQAT/APae00wcGhaVzD08IUXwcg791U5vgTyv9BBdx8+kgs73P
   MoFYheLRid6VMg3TANJEwIOrjclxrJ6Djo8NDJeglhepErJ0dv/6ppdOJ
   w==;
X-CSE-ConnectionGUID: OGiMDK/+RWKUuhfMzJ0RDQ==
X-CSE-MsgGUID: f1NMk8vsT5GOXDefoKvsnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3737415"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3737415"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 09:55:23 -0800
X-CSE-ConnectionGUID: 00iX2f9bSlOj/R7BWtmqFA==
X-CSE-MsgGUID: y8+ylzYcT26Csk5Q8jfH5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="10130487"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 09:55:23 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 18 Nov 2026 09:55:23 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 18 Nov 2026 09:55:23 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.12) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 18 Nov 2026 09:55:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0Hda2BQQ4F8FpUjfOxlrx187yuGGWqPl0jC2xHgP9X+SV/01MJWIMGseFQ+E1A7Nx0y4Ct+E6MqpbtBtpX0Zv/IyimHl3s5JExmhg108pRaKokSL/wwoFCBk9wp2MEEzcrKGXmnEy1/1I/2wxqc/3h0fQl01f7yWyjXuEkfZdXgzIjiqXFEtrgx96TbAkdwLpAqNkTdOEIFdwWYNBit5JvNFWiJ/aNxAWfGpw2JMTp0RISMZQi7P1oi/WUENXqq7bFWY37IbBXmH0n5mPKxvxNVE+qHN2ckeLKXMSfbADys5BAR6Rzo+4HSc0p7hRsWkwwCrpEMxrDeGANJGfOcxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whpnug8U0xt/M70MJle9NdwT/ixuuXV1Q73RnS78mGk=;
 b=GvKExSzZ89rForNQVVq8BC9ilW/2ZAf3V8s8E9aRfg4uJ1qt3Vk0fWudNkkPf6h7CEvedmHKE25E1l9SnpCj9beCrHhyxRSB/JL30oyIB24leU6ULam4mZpLX5PO68xb6fQ88KtYvhjY5/EEbWTj0XWd5jHCaWQPRrSeK1r44SyN3gKIwmMoCYbkUDiKsea18gUFfPYqK9u7AtFb+WoR6lk+/fIXGAaK9xH6WHqG2V5780Z0fjlvq3vkFGr3XJ0wz9Y83TgsYeTJPawpuVtCNR4GTf2Td/Ghgfu8RgFjHQIUUJPHlw2hfMMTwmOF6B3bfWCiFE2TlrWnf8YTIKdFWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whpnug8U0xt/M70MJle9NdwT/ixuuXV1Q73RnS78mGk=;
 b=EzvXov0sxn5tc2ta0cGjADM4YRomuj3mEBPYb27/NCYFUve1+hFo0lH6RIPXAV+mXA1pY69xq+sXIxX24hbxEINkyoLKNu+biK3gHQshdGd7m1aw64RvHRFf2h5Hw3xcWP2gDtMqk2ZREfkmqDm5abVUzwM8sYvB1DJgjj4aRYE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH4PR11MB742795.namprd11.prod.outlook.com
 (2603:10b6:610:517::15) by DM3PPF49E43CAC1.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f1c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 17:55:20 +0000
Received: from CH4PR11MB742795.namprd11.prod.outlook.com
 ([fe80::4bf1:7579:c9da:77d5]) by CH4PR11MB742795.namprd11.prod.outlook.com
 ([fe80::4bf1:7579:c9da:77d5%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 17:55:20 +0000
Date: Wed, 18 Nov 2026 17:55:11 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Thomas Huth <thuth@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, qat-linux <qat-linux@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Atta, Ahsan"
	<ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - Don't use -EFAULT as error code during
 setkey()
Message-ID: <av3mf1z+/SlzbCxH@gcabiddu-mobl.ger.corp.intel.com>
References: <20260824122403.630026-1-thuth@redhat.com>
 <a0153735095f47aabfb471f12cff9cb7@BL1PR11MB5431.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0153735095f47aabfb471f12cff9cb7@BL1PR11MB5431.namprd11.prod.outlook.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZP191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4f8::17) To CH4PR11MB742795.namprd11.prod.outlook.com
 (2603:10b6:610:517::15)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH4PR11MB742795:EE_|DM3PPF49E43CAC1:EE_
X-MS-Office365-Filtering-Correlation-Id: 11462f37-cdc0-4c02-2be8-08df459d1c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|6133799003|22082099003|18002099003|261009223027099003|56012099006|11063799006|261021123027099003|10067099003|261026140227099003|4143699003|261102123227099003|261026121527099003|261022075727099003|261028144727099003|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info: mjCvzdQB451KpHieZaZDW92AdwiHJDWJtQMnRboqQsmDPZrFlFxgnwwAHNlC/nYL+6Oiv9tmqq0j7i+drWMNlicP1Sjnv1nK+HLdo6a8Y9ErDfgegJLA0bVQc42TLDPjQfeZPprhe4zrQgiX1Kd/6uKGtcHEATgwNnKUaqsU3NzsquX3R6FtHx2ek2PscAD758/6wnpJXuDsKinQuvWXVsVSuGw8P//likyf4WT/ZMlD/rgr5Q7w8Ru+wjsSDeK4puhAxjI92xxEXMD5YJ+7WyXk4/zujZsEhUCD6GVBLqohxJiyIAySR/v0FEonl/TTUCY3c3PXL+hh5edu7PvAlwGOz8J38gbTiCkddBTP4Parl4Wt0UK7Y55+LryyQjU2LhfBM7Hu87cT0nA4gFWqONzDMnncK2BJ+wqJrat8oWi0z3WVviU+dlyFvGJ31tEUhI85yJPZh76RYWUxI2ozR3Dfoq2Zloarkq3wF2fS83yaHEz80mubSBonItyq//wN6+5wzikLLAkWSkdfV0yUDBjUz4bkQqnZgoiqy6brMoWhR8XO67Ou97w0fNNyb9UbdRby4xtNJTPhS0aZdu9GzCIbTAi+U21o+yprosmIkQ6m7SFsabNOmxMD/8As4rMOg/eaXvWBQZgT0OLiafGzgdYapr9hOhoEdGl+TNE47yo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH4PR11MB742795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(261009223027099003)(56012099006)(11063799006)(261021123027099003)(10067099003)(261026140227099003)(4143699003)(261102123227099003)(261026121527099003)(261022075727099003)(261028144727099003)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v/JuzQttcDXBWKEmiP+9QGE6TWp1MTddSL8SX5CBpks7jCHcGMfNp4/MkAtl?=
 =?us-ascii?Q?ArIyE+9PHbXxONZIISggJ8T+0a2ofXF+LFEF1tyD+uBeVNefucKty8NWn77b?=
 =?us-ascii?Q?E/ezMreQcR6kwkwAcWXp/PnCZHlKLusa4/auqgPy7wJ8FnHMgBLz9apJ5/51?=
 =?us-ascii?Q?QXUOmpgemWzgl/ibTThO95qZelncXA239qbF296ZU9YGA+d7ErYzQnvvJ4CY?=
 =?us-ascii?Q?GbqXni+hzXRFwsA2WGr/bGPDs0HeH87e71Y4vK48t8m5DE0+QWKC0XvXqyDs?=
 =?us-ascii?Q?lCWN2++MrqtWs2DVygv/WdsVo9I2plArw8MrbZ38aW7F29NaFAPE/GZw7Tx3?=
 =?us-ascii?Q?dHzbTwpUmoY9gv+pTZGPXN0zacp8wSQ7k1LQg1D+SlaxWqFii4ZDTZNuBbi7?=
 =?us-ascii?Q?Lzxi2sto8iqLaw4D2icsQnmcXfcVKQr5SVmtw5jsdJHp43B2g5f6bhFyMxAN?=
 =?us-ascii?Q?sq+XczNogNoIweyry9THKaV5putT96CfCShisgzTFArUftsdeprdBsGtvud4?=
 =?us-ascii?Q?zMckJnqj2QeyqUlLkSuSxtVSX3YOlwQeI4hZvg6yXc/yO75PigE+otevyBvd?=
 =?us-ascii?Q?aLVJiph/4alo1yIRsK2/MZzT9wrukFrCkoL4APFL00jaJfHbni6Z7Aen9Aom?=
 =?us-ascii?Q?v+Hf+Mk8d/rMgsL6yphOC50Mnah6SIatix2wdGt4NVnqyl/I7GUoRvxggTN0?=
 =?us-ascii?Q?NZl+RT421etjDmIPA6bilk7vk0ZIfaCsBjUM2QO1lBQ0r3DaD4Z9jUk4I5CY?=
 =?us-ascii?Q?2mxpUdQk2SV8YoBRub2HBMMo663E1RkjcunRUWrngS5p+StOjbmBisIGMs03?=
 =?us-ascii?Q?ADceRsZ16VwcAjHOoSf9GiwTVsYLrZ3zjiLMfIIKozvKhuADu2O1xL2FOVts?=
 =?us-ascii?Q?fG1MmJpeP5RSS6E/jnyTs55qKJnatsAYX/JNvvn+YRonYXyjATjHXDSl1Kic?=
 =?us-ascii?Q?EMkR5nwJqicIY2Va+l2p0DM2RPUX+lPwykgzze05XIAFSOhT8MTUGWwvrtgm?=
 =?us-ascii?Q?qLlMNd25y94u5gKDQQr1gOcjUp222e6lFFgUGPNw0ogBeYeY+a0fWUATrHph?=
 =?us-ascii?Q?KgFr/BYylE4z9E/ialIYr2DeaN0DGViCwuU1odYoR12R64r9rG9xYAWIC5Zq?=
 =?us-ascii?Q?aWo+lmx+QC6QgTSVT8Nv6OFz4EAOYpRqfmCMTDNvC5xqkuR1Y9iQvASGxhU+?=
 =?us-ascii?Q?uxaceK9hCrc1gM+WjNNZ2Bg6Ln9CCxMpPzc9PEfGLvhaHnJ32kWVLfNK/o0z?=
 =?us-ascii?Q?pBBGz/7PZKb8+fUazLPwfU8QtCizSS2v+uqzR4gz+WHHz/z9e0DJ2mqxl/4k?=
 =?us-ascii?Q?0E1uGzgdgJXFrEiw6VwGwPUqr4WtCL+Sbe3G2Z5NhMjSntALDaDTWd36Mkmw?=
 =?us-ascii?Q?uCEspjf1aOqSg75VhwQYfesgnKp80Ppnza9z7YxsmydJ8yabnqkvb15rm3am?=
 =?us-ascii?Q?P/7oIjoToVzQ7lM9xfG2a3s/JsChZie8Nwyuj39wwH7MnzS1uwKX/eRz8PPu?=
 =?us-ascii?Q?Zk1HnPCBka/F9JXC4yytGLIYD4ghihwPpKIJqIiJcUt0m3zmW1n8SN9GBCim?=
 =?us-ascii?Q?rHFWNKneg5VVTvMkA27Msjdfhhc+ALoSFJzAp8DReC6+T4v1yxG+xaG5M03a?=
 =?us-ascii?Q?+M+Gv8F8PEJ0PIqhgDfCKi6hesgjw/fY4eBCNhh83j30KcJ/O93f4ZBVP/fM?=
 =?us-ascii?Q?kyXaa9CxKI5bQ/67Da5Kc3MLKPYfA0waGa7l2+6DhKHYMQ18fNh6k9zPpj6v?=
 =?us-ascii?Q?S0hYZZxO34j1nDw4jFKVHdUsqNnIB3U=3D?=
X-Exchange-RoutingPolicyChecked: LWUQPh6RsYQLXNBjTZKQgKARmjqtBkW9avp8XKuU0/J35LTFNv3D4yKXnF3diYpkBn574Aql1ehUZckkJR5PRkjKKmxMyMmaLFAnn+R66BXhxxrKZYEXeUJzIhOan9oZ5+i0pF4LlX9mxQz6tTGqqJKs6HC9NdzUX6KoNl/+nny2/SZnvjjH+qKYZCISqg85b2yMUB4etxGkSTF7AYJiQ9Rw07KPA8dJzO48UyQ9Z5A2xkOnUt5XqW1OuCSmT43CM7Mhu5JwkacQMo+MYtJez6KehIzEfC5CadjBFWGA3v64wTYpUtbLggL8eZxLYdhdQ4WQjCZxSX7vLX+OEB2M+A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 11462f37-cdc0-4c02-2be8-08df459d1c8d
X-MS-Exchange-CrossTenant-AuthSource: CH4PR11MB742795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 17:55:20.2487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ay/gTGt7ZQ49opkJsMkSBlerXdt9UPRwF9g0NGvDwFhrIdcaI4Cgb6E1QZ72/dO3cn0k0sWz2jiFIT85qviig013v2sa/QKUi2v1imLv0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF49E43CAC1
X-OriginatorOrg: intel.com

On Fri, Nov 13, 2026 at 11:34:39AM +0000, Thomas Huth wrote:
> Am 24.08.26 um 14:24 schrieb Thomas Huth:
> > EFAULT means "Bad Address", it's the error code that is meant to
> > be returned when userspace provided the kerknel with a pointer to
/s/kerknel/kernel

> > memory that is not part of its address space. However, the QAT driver
> > abuses this error code during its setkey() function to signal that
> > there was something wrong with the selected algorithm, which is just
> > confusing.
> > 
> > The best choice for an error code would likely have been EINVAL here,
> > but qat_alg_aead_init_sessions() seems to make an effort to use this
> > for another error case already, so there is likely the desire to
> > distinguish the different errors here. Thus use EOPNOTSUPP as a
> > replacement now, so qat_alg_aead_init_sessions() continues to return
> > two different error codes depending on what went wrong.
> > 
> > Anyway, instead of hard-coding the error codes in the function
> > qat_alg_aead_init_sessions() again, let's also simply rather pass
> > the error code from the called functions up to the caller instead,
> > this way we can also get rid of the need to call memzero_explicit()
> > here three times.
> > 
> > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > ---
> >   .../crypto/intel/qat/qat_common/qat_algs.c    | 31 +++++++++----------
> >   1 file changed, 14 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
> > index 91663805d9e60..91da9cad1d89a 100644
> > --- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
> > +++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
> > @@ -135,7 +135,7 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
> >   		return 0;
> >   	}
> >   	default:
> > -		return -EFAULT;
> > +		return -EOPNOTSUPP;
> >   	}
> >   }
> >   
> > @@ -186,7 +186,7 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
> >   		cpu_to_be32(ctx->hash_blocksize);
> >   
> >   	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
> > -		return -EFAULT;
> > +		return -EOPNOTSUPP;
We could also change this into:

	ret = qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen));
	if (ret)
		return ret;

> >   	/* Request setup */
> >   	qat_alg_init_common_hdr(header);
> > @@ -273,7 +273,7 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
> >   		cpu_to_be32(ctx->hash_blocksize);
> >   
> >   	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
> > -		return -EFAULT;
> > +		return -EOPNOTSUPP;
> >   
> >   	/* Request setup */
> >   	qat_alg_init_common_hdr(header);
> > @@ -472,28 +472,25 @@ static int qat_alg_aead_init_sessions(struct crypto_aead *tfm, const u8 *key,
> >   				      unsigned int keylen,  int mode)
> >   {
> >   	struct crypto_authenc_keys keys;
> > -	int alg;
> > -
> > -	if (crypto_authenc_extractkeys(&keys, key, keylen))
> > -		goto bad_key;
> > +	int alg, ret;
> >   
> > -	if (qat_alg_validate_key(keys.enckeylen, &alg, mode))
> > -		goto bad_key;
> > +	ret = crypto_authenc_extractkeys(&keys, key, keylen);
> > +	if (ret)
> > +		goto error;
> >   
> > -	if (qat_alg_aead_init_enc_session(tfm, alg, &keys, mode))
> > +	ret = qat_alg_validate_key(keys.enckeylen, &alg, mode);
> > +	if (ret)
> >   		goto error;
> >   
> > -	if (qat_alg_aead_init_dec_session(tfm, alg, &keys, mode))
> > +	ret = qat_alg_aead_init_enc_session(tfm, alg, &keys, mode);
> > +	if (ret)
> >   		goto error;
> >   
> > -	memzero_explicit(&keys, sizeof(keys));
> > -	return 0;
> > -bad_key:
> > -	memzero_explicit(&keys, sizeof(keys));
> > -	return -EINVAL;
> > +	ret = qat_alg_aead_init_dec_session(tfm, alg, &keys, mode);
> > +
> >   error:
> >   	memzero_explicit(&keys, sizeof(keys));
> > -	return -EFAULT;
> > +	return ret;
> >   }
> >   
> >   static int qat_alg_skcipher_init_sessions(struct qat_alg_skcipher_ctx *ctx,
> 
> Friendly ping! Anybody got a comment on this patch?
Apologies, I thought this was already merged!

You might have to re-send it as I see that it is marked as `Deferred` in
patchwork.

Also, you can add my tag:
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni
