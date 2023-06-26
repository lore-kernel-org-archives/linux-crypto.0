Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E99EB64DA
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jun 2023 11:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjFZLXg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jun 2023 07:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjFZLXe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2023 07:23:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E551993
        for <linux-crypto@vger.kernel.org>; Mon, 26 Jun 2023 04:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687778590; x=1719314590;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZRjtLJwkrtikDqp7wPtXolseSa1MBUbNwXPn5ViUAD0=;
  b=WgE5oXtZGoG/o6yQb1pRgH7At015GLmir+hRNRviA3PNUW+v3ET8Mhba
   RdgtKuzOIFCQLUvgHEQIiFR5H7PrCZXdbQcsAikhlj9nVSiRUD8U3q1ED
   W9jsYNZ43fYOCpooy7EnRRdRNj6GBilmCwtIMAeK/a3npptdL5gJdK77z
   6dwkllGpLCq6mcHMbbb22C40vcyMrKLmxVbNefvmmz4ES0hJbL+Te27hB
   XaWdGAS9x8MfnZG6GocMxz4gpjv/2zMyEUPIJWObzhtULlS4GafcQPG7f
   JV0aYTjPHSZwoXq/XtihdCGTgFz204Lfp9iWpuWoPlsuhIWwEX12c8Vdh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="424911798"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="424911798"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 04:22:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="745753219"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="745753219"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 26 Jun 2023 04:22:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 04:22:17 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 04:22:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 04:22:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 04:22:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO8IL6VoflD8RQMj2rFFG0Z/BzLMQeJAJ7vKFj9k3NGO2/q7dtdVCBP+q8zsi++klnOWdZ6u57vLYK4bZWrr63JbhoSydf6C9s82Ubt4VF6Ih2nei4y34QStULtQ1NEpWzM/2J6ueX8rxj/HfmtH6MRiW4EnEHzfM4z4CquHxUx/8nzybHhhht8xKpv/nleawTp0PcYvAw1X514HIuHxro8NiGhEJCy12qbtNL2FyFghzhvPRogst5cMypvqjq7Qv1RjRi7J6GkAWvIWhIoRZM0zHJG+/KiHePX4sphG8foXvAaDI0T3pV1E27n9gck1i8lcJk+i1JfNxTNVPAhwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4YzkHw3gkNqzslhQTuMlNJ3ZLIQpNNwH3oES03XbBc=;
 b=DPwJ5NvYu+WsC3/ZImdQWo52i0yZ6vL1Ig9+phFpin/8yf5vna677AbFVicIu82ZBxnCOYa8P/0Mkg4Nf5aeT4GiE53DuvEq72nhhiHYiNGAZAr1JFMHWN0lMRysOD9V4SilOCBy6CyGiE0A15oA9Gcy7sx0DMKfs3EvoH97sKAsBDa/pdm/kBmEy0W//UULL8f8hCV4WrGL/K4dUX03gxGzAzchN95JBE3GJ+9mC2DdGkE3ZPWPly6I6nV7wsdjjG28RzwTfJgUZ0KSNxx/1VQeX/dcoEoO8TAoaSuBTn6n98HQ98NZB95HR7zBbmru3X/XxLCHPnQ7ozUovLSSAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by MN0PR11MB6158.namprd11.prod.outlook.com (2603:10b6:208:3ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Mon, 26 Jun
 2023 11:22:14 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::13c9:30fe:b45f:6bcb]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::13c9:30fe:b45f:6bcb%4]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 11:22:14 +0000
Date:   Mon, 26 Jun 2023 13:22:08 +0200
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v3 0/5] crypto: qat - add heartbeat feature
Message-ID: <ZJl04LiQrQLkwWsS@dmuszyns-mobl.ger.corp.intel.com>
References: <20230622180405.133298-1-damian.muszynski@intel.com>
 <ZJSSmE9nDZXKwPd0@smile.fi.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJSSmE9nDZXKwPd0@smile.fi.intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
X-ClientProxiedBy: FR3P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::22) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|MN0PR11MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d3789d8-5bde-42c5-ad45-08db7637979f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jxnFt7uusFAAHrCZca9YBEkTkuIcKVfOmuFSvMu+PJ/v8FYlqJ6ocy/kzU25mR7TfvUElF9ZA7z/aha/qaizkSAzMiueVAbchW6g2DUnRwuBvZGJlmflocsU+gOIyQS0v/YEBpXc04CzB/C8ay+G/Tipouspk2pGASx2QAu8B1ju/4ZoggHBL3Vz4MmySwEkoWtt0CjZ0xAf0NUscIKKDM88WYsjCrJmiE2MvWAFZwsYBfzE7c0YJPcB9gr0t4ef7nnv0Wa+r/gylTuPyIYAejk9sWYMzN0ruTmPaA+FC5NUCBFMU1dzuqHxJok+wIp6LqfC2A+vs/AaF8rE6juLz3GIlko092tCDNNKp26Pj+Qlbm9Y4gnQE5adRN2xumHrQTi+pW3mLtgAPOfkjND2zU/0D+3A6hzcAypxSVZFda15phqFbITwlEMAxk5OOOME/lDEwaALfIbgJYD9o3ie8A8pM2mLzZ72oDiYZ20ieGU5jDkKtq55+T4wJ2y6jdzb4XqMTbs6yicvgnFRJJ2I3xRIiAWh4Pl+EZv+n535/pFfa2wuJapGm6p8Ed7AM+Z1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(186003)(26005)(2906002)(36916002)(6666004)(82960400001)(8676002)(6916009)(316002)(6486002)(86362001)(478600001)(4326008)(38100700002)(41300700001)(44832011)(5660300002)(83380400001)(8936002)(66946007)(66476007)(66556008)(6512007)(53546011)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ngqq864vdCOks8sxfXxbZIrajkno3tcD/2BRTBrV4lFjTZNsfrlkh2WjFu3r?=
 =?us-ascii?Q?vyc7prHSHU5pP9jcuFUFH/KRd7xo4wFCQxpgJmW4MgJ9IKIwZrilzJVeR9sr?=
 =?us-ascii?Q?0pbxNu5pjxQxF0QZNj72OxOsuknP+ruH9/Br7VZ62V6w7wXsN6FATe7aPkuW?=
 =?us-ascii?Q?lRgpsXO7syhhZ0iHhswRIbNi9xwKn/4XmGun5bcJu+/UpMF8cL+9ZUW/uI0N?=
 =?us-ascii?Q?VkJcfU94DKB8ZQFLDCRmsWV2oyJH/87NXkMuo+gpcumtAYWcPRPgU79dZ2qq?=
 =?us-ascii?Q?DxgGzCnhx6cX2uuUF+4Ly07b2JASe13PXJP9UloHkh6e/qRJjAIJjrNa19YE?=
 =?us-ascii?Q?z/je2bcKFoBfuD89WmGltnAQrri/R8I/uZ/GXdFJD2Pnjarv0QMkEno4wKm7?=
 =?us-ascii?Q?+/XtTdIdlex7gWjw7uyLgQRS71skh8jfvMbpEXedw3HeuLvrGQkNrlGTBoSK?=
 =?us-ascii?Q?1J/FueGveXAJ3CQYKjvn9f5yqN0pTRo1x+mJ+BoeW/W3o15QD9Ty2jl+TJR+?=
 =?us-ascii?Q?Cs1XrUiTgN69EAyZBjrOf0A7nvIHq0HyQY5vCIxAQWLIA+YK8DwmR+PqU/7a?=
 =?us-ascii?Q?VRm7ih7Du3buttFFXld+mbeC8MQuBXfKvG7gK7Ed2Pn4pkEzHAYiItEuzpff?=
 =?us-ascii?Q?WvMF/RYFw6+zt2xvQPM+x1hiymHPth39vsI4TwrNLv02Evz7cT+yl6XELT/l?=
 =?us-ascii?Q?xrZoTenaTcn+MWPBvsAWHgzEe8wL701UjXA76qhcZ4GKVc95NeS4o9b8Wlqh?=
 =?us-ascii?Q?zC5rikLdH4jQVRhTGsI+hjXC76yIa8dgL4cYEgm5kVBXtbDiKL57zMwSFEAi?=
 =?us-ascii?Q?yN8h8SBncSvyQ67iTRKZb1aBRW6w96a0GZ5tY4tMcQxGgwOBhuXU/HBHcJsE?=
 =?us-ascii?Q?lhjBdqZCFn8ghkj9fhaw9pfRo4U+4yraMGV/JUeXD9GtmvNQSOlTeU+ubG0d?=
 =?us-ascii?Q?1qyFRd71gCproFQcLl/Trbm5zsFNusgJbGZ73oxPZ/afOCpIbLFLTut9mNOh?=
 =?us-ascii?Q?miC8eQBIo9BYQPdbfRdK3rMPDz086rWUyaCc1CLghAJb4BIbUcpREGJg7c7z?=
 =?us-ascii?Q?DRPxhgtlHGaBxqsznrb68FmA1dSFuCmvLa9qzENMSrYJrEVeo0MZbMeVolKL?=
 =?us-ascii?Q?nBPHGw1UjFdemvui0+uMnRhQId0Ng5S9WeA2q5N7fRnQpiiv6QK2a4Hu8GWy?=
 =?us-ascii?Q?NjbCAYLhG2RErs/6SLcncxG/jBh0ZGasF9wa9/IeXJCf0IomL43MV+EVzjeT?=
 =?us-ascii?Q?fx2un+C49Wjmq6HiHANdULqNBS1NHDA1YZSWVXOqQKClnMdOkoa8Sa1Xwya2?=
 =?us-ascii?Q?cTVSOfLK/LH1jRm0yDTvMlRSroEQL+ZG580yBiGr8KyCOMCN3VPB3Kx6du/a?=
 =?us-ascii?Q?uRBgvJToG9DEqL2x9aB/H0LZ28d0Rl8Qpk6Qo6n4bSdmrrSMCpz29VfkpELy?=
 =?us-ascii?Q?LVXNWVd0bmNOG7kpenr03828JCwc2uwz5pYdbJVMihBTVpbNfeOFK/xhhY6I?=
 =?us-ascii?Q?euHp9W1e3ahkSWsDgjA8Oqo6iO7fvXwMQ3GdaWpasEyEF6ddYXZu+p7spU3L?=
 =?us-ascii?Q?B3sZcz5cpmALwhzi9MHMdIk0LZlu3JgkcMOAT99zpiVs8KVVY3gjB4gLEbRU?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3789d8-5bde-42c5-ad45-08db7637979f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 11:22:14.5384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsayUAbboACSx9Imsj6of49JClysRSdhf4yUNCExT1/OjxoqfRUhjpVvVOAmohozOxkzFHhxmgL/UYkfUhnzuzmKcnbX2ilYq3c7Vaz7JxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6158
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023-06-22 at 21:27:36 +0300, Andy Shevchenko wrote:
> On Thu, Jun 22, 2023 at 08:04:01PM +0200, Damian Muszynski wrote:
> > This set introduces support for the QAT heartbeat feature. It allows
> > detection whenever device firmware or acceleration unit will hang.
> > We're adding this feature to allow our clients having a tool with
> > they could verify if all of the Quick Assist hardware resources are
> > healthy and operational.
> > 
> > QAT device firmware periodically writes counters to a specified physical
> > memory location. A pair of counters per thread is incremented at
> > the start and end of the main processing loop within the firmware.
> > Checking for Heartbeat consists of checking the validity of the pair
> > of counter values for each thread. Stagnant counters indicate
> > a firmware hang.
> > 
> > The first patch adds timestamp synchronization to the firmware.
> > The second patch removes historical and never used HB definitions.
> > Patch no. 3 is implementing the hardware clock frequency measuring
> > interface.
> > The fourth introduces the main heartbeat implementation with the debugfs
> > interface.
> > The last patch implements an algorithm that allows the code to detect
> > which version of heartbeat API is used at the currently loaded firmware.
> 
> I made a few last minute nit-picks, feel free to ignore them if it's okay
> with the maintainers.

Thanks, I will implement those. 

--- 
Best Regards,
Damian Muszynski
