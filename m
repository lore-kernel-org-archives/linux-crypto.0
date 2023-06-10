Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1E4C7EE2F
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Jun 2023 14:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbjFJOGW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Jun 2023 10:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbjFJOGU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2023 10:06:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32603AA3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2023 07:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686405977; x=1717941977;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CMqoSrc/R/Ka4TknlpAUVx5SbRzDYvzq97Ty7vJDjdA=;
  b=eDvjdOP5eVX1KBywBx3IfESFzycbQV0M5vM+68YR4Wqz5vzNFvi8JXVf
   PVN4v4TIf+Hd6Yy74IZTB0NTxptI8eSVtebrdpzQUz6XnNeZTvFHZxNbB
   UiPL9gBlqofSTuQ6Ri4XGWBtuw2HMDXQUJ/xOzIq6L8y/Zq+OmcTtzWDb
   ie90xuz4Tv/oRmgAKtyEkAHxrnhwl11uopwDhAssjQ5x/eQRz6f3R3yAo
   iJjDA0MMZoTybS8QXL6dZH8dseGFpQbazQGvrMMNIT4Miyf23TeC8bF87
   f1RO+qpLfacqXUJZpUZOgii0X0mPhCh2SlngpUElQuVwL2metfaI6bB3W
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10737"; a="355256380"
X-IronPort-AV: E=Sophos;i="6.00,232,1681196400"; 
   d="scan'208";a="355256380"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2023 07:06:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10737"; a="743792354"
X-IronPort-AV: E=Sophos;i="6.00,232,1681196400"; 
   d="scan'208";a="743792354"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 10 Jun 2023 07:06:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 10 Jun 2023 07:06:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 10 Jun 2023 07:06:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 10 Jun 2023 07:06:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 10 Jun 2023 07:06:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFBKJH4tbk01vawgaG3Zv4PKooo4INBIjVTPxak9mNTMhXeIp3CFB8HEq49x842NeF/+nPHZNf7bWFDgNUM6bkfxsBvbKgEiy3VhvHijzGmxPK4Df79s3LaFSop2LM37ExsGF3dFtW6ZDbP7Ihfy1Phl+XtdE8Xl26OJdnlV60WYgLWTHDJwPpiWW9ogkYYbusuucJG3vLpLBPaLwf0eTO/1CG699KVhVskmYaExGhduhCX56++8QmCftxW8KD1Dlir/KimrmmVM3tPPTYFQ5WBtp0ZTsfkrCtQ+qcpophx0fhvLo9U4CuevEUgay+E6hNSP2ZJ1No2387zL4JYVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b92oXG61vx3IT+5/FiKWL3v9M7IsQJAgbrxpqFO0b9Q=;
 b=C4BVmxtm+skRTh9pWCvxFoYx7Mstef2UCgBeh6oz7szioVgDX8AOrp4NCcayMD7syaRzOwzBV5DUFOuwEKMosk40iFe6kkQZD8zi7rxEQ014JVs6U7Vg58uIuTDj+Ksf90uGf0BQ6lAkN8x2+j4wt+6HHhIvwpi1plVLPQafnSMTYdngIBci1kujk6EH76/sBb+vY4ZTRynEWb1BfFWnJLRUEBV/sjI4l6mjKew8Yei+JrRgMCdaZUlkysq79I28t+5y1a5gqjyuWqU8Dfvvb0ROW0Tw0Nhq865NUwP8SuHhVjRzbWmJr74e+DS0ducxJ1wOeVsFmooiNAEec9ZtTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by SJ2PR11MB8347.namprd11.prod.outlook.com (2603:10b6:a03:544::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sat, 10 Jun
 2023 14:06:15 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::35cf:8518:48ea:b10a]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::35cf:8518:48ea:b10a%6]) with mapi id 15.20.6455.028; Sat, 10 Jun 2023
 14:06:13 +0000
Date:   Sat, 10 Jun 2023 22:06:03 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <ying.huang@intel.com>,
        <feng.tang@intel.com>, <fengwei.yin@intel.com>
Subject: Re: [linux-next:master] [crypto]  bb897c5504:
 stress-ng.af-alg.ops_per_sec -8.0% regression
Message-ID: <ZISDS6Ov7DS7Dis/@xsang-OptiPlex-9020>
References: <202306081658.d5c86ae9-oliver.sang@intel.com>
 <1697789.S9sCK8dtJg@tauon.chronox.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1697789.S9sCK8dtJg@tauon.chronox.de>
X-ClientProxiedBy: SI2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:4:186::13) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|SJ2PR11MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c6a0122-75b0-4f34-994a-08db69bbd9ba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yiymhWFGiG5OQhuR3WjWQKEsG8W4xKYZcDh5c5KBsI5tVjxTyRqN1NFFEv/RMbPX+ExEOv9xdSPjPnJOMPUGjrl+K58CqLLP4cC3/lpKC4UQn00M0SExMPGgGeY/lMopCJVV+TfoebD1QHgxGjSXyRj56SWNmYtO1Chwgcj5Zt48eNqhNkF13wa9RBlPcJwbmn7V7apKluPjhrOsq2maAC6Boy+5g+Gpe5zlzLhqgAGAYAsgHiLFgG6YbRixIekAh67+/2po/tJl4X3KsOh/4UvZGyel5Qd8Clq5Y1+WPZ9WkbSPfyzbur6/qfHBol6coZMXvZWhDPqANZDT6FIf/u0Pt1j+EtCQgGSfAqSIspQGkTJRvOKrLAr3hYQhIBN5/xddBzQGUWR4dGqc7a6ZHgnaxl1Tg8N/luDH6OJD3T9UOZNHOW5JeJqlx34DYStWgfnEi7ADlm39t91Ur/gLk3TnCx5nIkt/fdpM6yBawemczIuXJ1H1v0hm28fHG8KN2FLcUX4gBS7+TMuEiwObxiY/nJtVBMiMmYtfIA/+w/A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199021)(478600001)(6916009)(4326008)(8676002)(316002)(8936002)(66556008)(41300700001)(44832011)(54906003)(2906002)(6666004)(66946007)(5660300002)(66476007)(6486002)(9686003)(107886003)(966005)(6512007)(6506007)(38100700002)(26005)(33716001)(82960400001)(83380400001)(186003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OeK/Az22GaHHQCGAw2lqeT4wv45C+U5hmBWh8+ceUDg68R/RV9gUUt13ZlgV?=
 =?us-ascii?Q?uP9gB2GwJrofk1GCed9ZApoprjEezCumKLAI84OW5CSldDKFFfgIhvkhy+d2?=
 =?us-ascii?Q?gw4asHXjBvugRW8PIs96zaiYF0MJufmAO0cMacdW7nwIdPF3bEAhVcjnHWBq?=
 =?us-ascii?Q?4Agutn4Da1DPzfIur70+/mZaAfBe0mih3vaRDqlLMdxfo5jonyEkOHIlFe6y?=
 =?us-ascii?Q?ZusGBegNPSD4Dam+sfyIgNAFUqxipU6Vz2BhBnWa7XeISzFJQkYyIqs/SepQ?=
 =?us-ascii?Q?Z+CM415WYLN0igcUHp1k8ND2vM8YmF1SAqWmsfVOV0hf9J4EA8hEZ2+QuINd?=
 =?us-ascii?Q?kvXa9WTbH4qdobcSdKt1YK8MVT837rDrGXHKqEkTBx1W2KjYREXmCIV7oDme?=
 =?us-ascii?Q?V7ku0e2wEG0gyMO69eFG0wguv0KyYcIv3DZtr6IzRzg//IUIjjqI2cGbKD6v?=
 =?us-ascii?Q?PWOuvTWVrtlQ1S2SEB1SB79gDdqwP4xIgnJczFhofV/pw4t3rjMM70zykAkV?=
 =?us-ascii?Q?wF3mcc9lX/Mkh5iI+HmsLkTSSePAsIYUoLX2aEwWyS9CVvn9NxZV8+lh6jzg?=
 =?us-ascii?Q?8JgUyLqiDwZHjz+vqAMOHS5ETyyWS3xlc8o9SHxasDrSj6Nc60jgiqrldUuZ?=
 =?us-ascii?Q?Ect+fSPPS6+7bcdUdt2pjgfvgpttd21YU+xRyBw+lyfxScAuWNd8cJ9f+X3z?=
 =?us-ascii?Q?YJk4AWfF8c1aOgA4n2evaPIoRGpeIjhH4+szdkb1bZgh2PxBGsNglBS3uj5F?=
 =?us-ascii?Q?z5xIEHE/F4p+LehUwhb7iG9ZqsAOtXQQw+uGqfQBDheEfnRcTUsPF0Fcsf8z?=
 =?us-ascii?Q?SvFBMAfscTX9beXeQ9Q2m9L9MmvXVKcBa9B38ol074P0ehljaSND2CTwhbH0?=
 =?us-ascii?Q?yMzyCXrzSFQ6BzuSzlFVHEjclJ2tpN3o6RREzF1jFIEVy05SEgwHAuH7AGE9?=
 =?us-ascii?Q?Tuat5bvcaMrgnfIlg99wIZXPnRwGfxPkheb+XiGVuBgMlGUfYMyfJkf7eDP3?=
 =?us-ascii?Q?OKXmhdibu6ukxrcS6I7MKHHK+wY1/ckagtpy+h+O9aykUwwXJ/xitGgzTkaO?=
 =?us-ascii?Q?GsqubvoLKfQUJOeYLT08PDAqiEvxxMpuQsDm8DuIzyZZTL1DZhPAm/6tLs5W?=
 =?us-ascii?Q?8CYrgeQ/XlAU/+wfD8rg1JZ5G6pKvBX0C+m0yYFum8O5+kQ41Fm1u+vRDMkp?=
 =?us-ascii?Q?/iCgLqsUqr1xzf0G6y+FH+KdGMcuDtPkH4OLxYJVavfaLSOslP3623EpcUoY?=
 =?us-ascii?Q?rrMV0DGrR7Y4Bis81N09clmDCgw3XMpXnofc0h+NHFaI02zP4z/M31r4kpYj?=
 =?us-ascii?Q?uVGh3jEdf5lv8QFu1yUfbCbYM6eTFWOndmnb8PZlZQfrOzPUA9GP8c2S22I9?=
 =?us-ascii?Q?WfGSn+mkih/g0FFtAh4DRIdNcm7gZIT4IvnawP4v3TgoVkQspuG6QQgqmCJo?=
 =?us-ascii?Q?SkbIJSjRXJFP6sUYV4hnRFews/2vZngLfWc9A/vU649ZX0Ig+b+0GmixOykG?=
 =?us-ascii?Q?ouP7bNxiy1yRRIsQoioGKR5CEEdk7JWTrYL2rzBYdKAVL1/eex3JqjRnaS3o?=
 =?us-ascii?Q?NZ+Xl+T1mOzzuxNi5W0ocRCkT3Y2/gmmFDAfCXPo2zfPbColnuWIzGbJ5k5x?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6a0122-75b0-4f34-994a-08db69bbd9ba
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2023 14:06:13.6963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M21M5SzRjheCTjeF368Ei0jzPsVCeBmXinv+UMA/ti4rKBWUwA7EJ7iE0awQm7boLd0Dm4H8K/J6pmZcGN/dHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8347
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

hi, Stephan,

On Fri, Jun 09, 2023 at 01:57:27PM +0200, Stephan Mueller wrote:
> Am Freitag, 9. Juni 2023, 10:02:32 CEST schrieb kernel test robot:
> 
> Hi,
> 
> > Hello,
> > 
> > kernel test robot noticed a -8.0% regression of stress-ng.af-alg.ops_per_sec
> > on:
> > 
> > 
> > commit: bb897c55042e9330bcf88b4b13cbdd6f9fabdd5e ("crypto: jitter - replace
> > LFSR with SHA3-256")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> > 
> > testcase: stress-ng
> > test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-10980XE CPU @
> > 3.00GHz (Cascade Lake) with 128G memory parameters:
> 
> Thank you for the report, but this change in performance is expected to ensure 
> proper entropy collection. I assume that the jitterentropy_rng is queried via 
> AF_ALG. Considering that the amount of data to be generated (and thus the 
> effect of the performance degradation) is small, there should be no noticeable 
> impact on users.

got it. Thanks a lot for information!

> 
> Ciao
> Stephan
> 
> 
