Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAFFC0015E
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Aug 2023 16:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbjHOQFT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Aug 2023 12:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbjHOQEq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Aug 2023 12:04:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C1A127
        for <linux-crypto@vger.kernel.org>; Tue, 15 Aug 2023 09:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692115484; x=1723651484;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=axm9w/EVrek3r9oaS/xWEsMJSMXp3OuykPP15uWlZj4=;
  b=KUYNQUUag8ZZWHcFxfuhzhvDkIsSEynLAP2qFDU5QsOjcQXQjBHs872v
   bWmqvgFSuKVxoyRW/Lb7h3G8hj5it+WvLJgylqoGuwIdKR6/c0X1wJjT+
   oboFSnrcNA9vZI2ErHeV60mCuf4rqgdrYllJsEcdgEs3PZlM+tob2bKNo
   tlzbA6bSN02R8NjvUk17jzWuqYMVufUbWzuySUkZLkJAumOb9Yvvk8rM3
   srYF0BJ6KogzSwA//PdBCXkrXiyvY3mrBJ0xBOVdVmpXb6X0OZuyxu4z+
   PsGUHf2XNxfC9UB1XHiRQLLCDGUASLtndUHcLqwrSG9LCuZ2mjZIw1Gxz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362465054"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="362465054"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 09:04:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="980401583"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="980401583"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 15 Aug 2023 09:04:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 09:04:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 15 Aug 2023 09:04:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 15 Aug 2023 09:04:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htkeWepNdG4dxkuIhGkJ8SVF2HJkZS1koDrWoVp7YiRXk/zB1BDL0ACfQKd8ZxONZ0D1cLPNeawxkTA7xwrvnFbTVr460ua6/SoC8B3jnk1HNkL9yOYjUcbgjaOsd46IrcD7tdvorSPBUcF9umTKbjoMftXVBMd+5Kc/MKll8XJde32uaZBWucEIT7T2ch7QZQTCEjS7zmt3nSjuQNs0fEp35+4laQK1p4D6jlXx6I70+OdRHU+MoQnAkmYUB6BGBZJKWdivP313hT3ZGFwHp485TyCsJHgE+c7F8Q/0iW940XGwnY+PB4+ukqH/eKAFdITqg1oEggoPgG0Zkc3zrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9vciPvb05uzkpila850sU5MjiYu13AmmtwJFm/60oU=;
 b=evdT7rb0ZeEEzUnpW86fbcHmJADr8gyXDFYc3SlDAv84lx1dLQb9uztIjYhJL9s22MscDObCnUT2gSuZqEYzBhDQYMfQI8QlKBfWe/i0ZZ/g9iMOvGNf5kjkGXIyoB+6FAVl5TUG1FDlC4r5oLG1RO0EQlPdV9r4YbsSSPOf3HnRFtuVFt2iicQ5JVHWaFTbeSUaSMjbJaNQcDXU+1j33b3pVzu1YOIUVNqYMVkNJ9e0uuviheweL9DDNLUK5ZZfxasGtD7Z/0/4ZFgofLPT6W0HCwmxsLYXGp7D6EEPYAryX+6hyhDvNFQxsIGQdOuMLKUzLhpJVaSl/bMLAyYu8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB7759.namprd11.prod.outlook.com (2603:10b6:8:101::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Tue, 15 Aug
 2023 16:04:21 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1%6]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 16:04:21 +0000
Date:   Tue, 15 Aug 2023 17:04:09 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Yue Haibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: qat - Remove unused function declarations
Message-ID: <ZNuh+Q6Q0tiv1AH7@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230809031614.9704-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230809031614.9704-1-yuehaibing@huawei.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: BE1P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::6) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d6a87be-0d8d-4f78-c779-08db9da9497a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cztLHEEtoM5BlCU1ggGsBWHPfAedljQz5Rh4t9SRen48uRbKNMb/LtJNkq+bgyXivm1AFCO20hB1SZXZs1hTuRLyyDVtbP1ksOsbAmvwXfg6fGiv49ZVm0YXer3Cch0JcJ3rHZoUh+ednDAMYDlwAmM2d9UMLK91bAUoRiJx2TpiPRvFoB6lDk1qAnjUqNzD6o+LHxuUyWnmw+AniSv+4pxd50M6e6ZGs24HLyi8QGnDbAbg+cA1uq3kox98/gqvMiqodieT/XfayVj3F5oQi98i/fmNOVq/ZCgmUSz3WaEo/MIScJDhwan2KOmZ2aARz4fJUsJxj67XsowJPAbpp5fMYuO5wNC1Bv5UaOxmPjvngEViPfG102gTvy2yMbFNKFXGQpKYObERZMIRrxvRli+Tw2P2WmCUAj1lgQkPiOp2gjMwucXt4u5342GpDZbDo3XZfO0F6SURRioHWNujEuRkb9G9ltVt9vKFxNPaxze57JAar+jbh4i4JeEx7qSLLoWs8XvZgJpUoAivlMc5I6EAGaURefolxYr8lSMN8DRf7IB29xk5XmpMjzXCPn1ykWMw/uGggH/2faRT3im51bRvpdIO+jZHz8+TckgmPJM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(366004)(396003)(346002)(1800799009)(186009)(451199024)(44832011)(6916009)(5660300002)(478600001)(6486002)(2906002)(6506007)(82960400001)(4744005)(8936002)(8676002)(26005)(6512007)(36916002)(38100700002)(316002)(66556008)(4326008)(66946007)(66476007)(86362001)(6666004)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IYlC6qzw5h73wmrlgK5Rts0lfpPgryq1Vhln6JXG/zSDlsUiDjGb0SyyheGu?=
 =?us-ascii?Q?aYtG2UJzMSWxV68TjiV71YtJZfvVoDF507hen+oTTQodcto0kDLRpxsBFmuG?=
 =?us-ascii?Q?PrtqFFVNaWNKOSEeoYp5MMwJIIOz/M9sP+8tVNo9YR7mX4Tu17BEYOw31bV9?=
 =?us-ascii?Q?LIEd1K0Z9G+gYeuw0QlGgA5awoE12CIoRWYs9/wI2+qtcuYNGGDzgnF/5fjg?=
 =?us-ascii?Q?JuPtMnkwy6tcm54eswNcBejfykT0ufKkHDkzrG34WQhnFLW9XQowQ0myBW/I?=
 =?us-ascii?Q?x1/8XRf6xuGYfX5pHofAB3NrFdm9MEmCWtSn8p+5pcSJWpNn2UPqr1cDIOql?=
 =?us-ascii?Q?eSX0HazeNXPVs1huV841SyZgh2wqBbhs9pEz+kLYWXA7dJyN+f4B87cx8tEz?=
 =?us-ascii?Q?EWQ2Gl0ijFQPDf1v/n6NmHq2IgDK4fRki0b/hQk9Z0qTiNwaMPMhLJ2RyuVm?=
 =?us-ascii?Q?lLKzhqgC/Cc6s2OJytJDK67PZAXGKFuhFIEa6WgfIvCQ+gXImhkhaF0rdS7G?=
 =?us-ascii?Q?KEzpSeLZUTyaBc+XwJhKd/BrbNjCqeDlV1E68u0aKMdpY/YrbcWmYp9fddjp?=
 =?us-ascii?Q?twhBzSMnddcO/I8+mASdR9gU4L3Q/84S/9V7s/d9f15dZVS1/VCPd6h/pUp1?=
 =?us-ascii?Q?deSmsnPPabvkwv/SHx9YXnQEoNFjIeia4aOMXS80Okg4HFDzgRfwybbWEBi/?=
 =?us-ascii?Q?BEYvEvjY6DcRbicQj8A1GdNcHdauJ42t1jAezRWNUv7EqpRPswgba/edz+C7?=
 =?us-ascii?Q?P6t+QY6iNEunD+OWDhFRhs+GxrUKCbg3blBMs35e/O56/bhMVKj/1cgoIdQw?=
 =?us-ascii?Q?8KGLRlzXCLHE4IzQhq1LD7oVnyNRpBk9ZPeKck53xMHdGX5RKbFvafAivdqt?=
 =?us-ascii?Q?wtEVAxyqke7LZO2CCQ/tStr1IJVnX6vkEdkDN1bDIj2Ytp7uAmffmJ3590Ky?=
 =?us-ascii?Q?9p4dl4/qDkEjLN+hvU4B0h4zPi38XhJdlzccOxmX6AwVEm05WUG4lbdMLrlJ?=
 =?us-ascii?Q?x8Hq8UN12sQgV9Q3/RTWOuONTgJcYeux8dbvTr7kJC6Zg7i521WafiFCpxjb?=
 =?us-ascii?Q?OGJBtyCgdMEsvrB6MOKNxQGsxI4LMomwIi+fEszLfW17hawhpaZmnxlXJp6+?=
 =?us-ascii?Q?y26qYpo/N5bi7ckUQpUsmJSM+MyWy5Smd2gbpn8a46+52aptdmP2z49MoDWF?=
 =?us-ascii?Q?Cg4HjD+OZGIdoLR1jSBJCbF4BX9WiomLYVpUDkV6PyRw5xEKVVHuw6T3tvKf?=
 =?us-ascii?Q?NQpp2ZNlqDuHBigoRR7/kgoXlFpEpHe3RIc5ImduYbLfrwE/POEzvqhfj080?=
 =?us-ascii?Q?Tk9PJf/NqbnzgxuTGi8QYhOf5i1vI8tuWHFDm7pH6maQIKc6ZxQpNXxDIT1q?=
 =?us-ascii?Q?QVs7WtxqArP1hpJNE107PehEpBiGOCzQpsDFOIjTPb5S55kXAqReCeFZwMeN?=
 =?us-ascii?Q?5RA3WLKk+3KEcAqkZLQPSGQjWqID0NWyPugoxaXT0zw67v957/wcVW4G21Iq?=
 =?us-ascii?Q?IY7gUVtVulc8miSdiLcWQudW84ubuhA9Rk3ApnfufvZwiu5pMzcII2gqT4za?=
 =?us-ascii?Q?sVEJuyH4fCewj/0cD9LXguagCIiaWVoZRSEGjWgtXv6THzn6jV1QbZKyz2MJ?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6a87be-0d8d-4f78-c779-08db9da9497a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 16:04:21.2805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /P9wDjmj43AKMoRZ914Le1LJYaZI8uUMhZTWwMKqPpBOYgNhag1438r2lQk/wQ9RTzTv2B7xJ9F44Z74hHbAI3pFS7NFr0YlFp3lOVB1CrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7759
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 09, 2023 at 11:16:14AM +0800, Yue Haibing wrote:
> Commit d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
> declared but never implemented these functions.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni
