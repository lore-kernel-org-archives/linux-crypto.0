Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C218C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 10:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKYKEu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 05:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKYKEt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 05:04:49 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8291227DF7
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 02:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669370685; x=1700906685;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pmAKLudDeGJoLUf5rARJifHKvc9ini2gKMnvzFUQ3gk=;
  b=M6cR6WYb4GEmRP6ixK5SSJnOzoPdmZ8IMvxOSIyo/aqekkPNN0xARhHP
   FoL4pljTeQ/+vPq8DFqJaql98KfjNojL1WI6QpRjteD9GtjRrqBrUvC2J
   0zWLeDQ2424+5XKPh5Gsna/qeNHMN9FzFG30wuSuQnGTVemAKnjbYIL7p
   kMhSzbfPA7OPyth0XLji+y3+ujK/RwhMaJHxV7KLVJYDCypvD52DFfF66
   r4PQFgiwUezdkudDCdVgR0S+w+qzrziwChLHeSlqHb66oFgFmJaV4Khg1
   915DwgyKKd16dkoIkpwZXhR0Vd821jQME6MERJFTDtCNMcKOKK8L1vRlb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="400743237"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="400743237"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 02:04:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="673499633"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="673499633"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 25 Nov 2022 02:04:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 02:04:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 02:04:37 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 02:04:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ej7FiGyC+kG4qZZ71fTSi4aH+2f7LwxXtQlyZ0ZVJ1FEVYhlUJe0ug3RGf+UJQI25xfZpLvbpHSfcRIKJ1HH7oUuhRUU0fvXpJpLVOJugDvtdmKTRuc+wYjnyacLLpYttElHvyvFO4/P+xFDlIoGiq69Lu2TGcwgdADp5spx/rFqCx7JtuEm26RbyKMYXwkPjxwOhHGM6fEs//GVyMV8YOQ1sxrf14lBmnxv35CiamzyudFJLIRC6zjE+0EpAuiw8ytmEpHbStK54OtKaeqzzUOSDV45BCzLat/YB0iw8yVxBqejD+Gm0Ve/RRCZxjR9RKfFVyNGBkfQvGGWxdU5nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBTPLwSPxoLyKBthnZ27EkWLBIo66b3/Vt0RyMU+BHs=;
 b=lNB66iaqbK3pRc704tTeu/S5UkZCFT8FmPZlL4YEz6Ii0U4CkQPB9OI7VfDJcwSdcTP0Wm1am4xBJvihT7YcwcS2+GKqCzzHi8z1gRqrwVI1X69j4IoE/bL5oVLkEbmSIXRvEFXZiDZprT2ix2FNrZfpKSz2H0vs+qGo/tScqgVPJ0rvGSIB7GNzAyMTjLkwwH5LXrNzLoATS3tnz0Kjv3K86J77+QXSH03DzEZkxqjvo7VRLTb658jNlFajph35lXEoT+SqjbSWWVjgNAJxT564L0iYySYVNMQa1VjDNYWAx/+hejikSQA4wtZPPZiCqPjj3FuofZdMMMj/M2R8Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH0PR11MB5563.namprd11.prod.outlook.com (2603:10b6:610:d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 10:04:35 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158%8]) with mapi id 15.20.5857.019; Fri, 25 Nov 2022
 10:04:35 +0000
Date:   Fri, 25 Nov 2022 10:04:28 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v2 11/11] crypto: qat - add resubmit logic for
 decompression
Message-ID: <Y4CTLD7BdfFt5T5X@gcabiddu-mobl1.ger.corp.intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
 <20221123121032.71991-12-giovanni.cabiddu@intel.com>
 <Y4BKgx2axzqsjWch@gondor.apana.org.au>
 <Y4CO3O21Kx/Ywi6S@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CRBasSFNhXywKj@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4CRBasSFNhXywKj@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: FR3P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::14) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH0PR11MB5563:EE_
X-MS-Office365-Filtering-Correlation-Id: 62d5bb30-dd39-40a5-1c10-08dacecc73f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Xhc2VCknUqIJcmZQCKEWoyU40swpohiAYCW1jdEk4N0TfTLKs+hqPU7OZPUjsS8yuHm7sv9Obdu4jLIIuQjtE/e9zj4Mi6IOH/4765iimiu6zLBvCt7vFCvob4AMHO28FDhi6+je/ufeWtk5eOV+3DDQsxGESra3Jn5H+A32Kp73hdgQaAo+TWEV0Wlc91fctmLIKJ++0KbceKW9DozXtFKMsWqyCPoCYXeHynX+X+cxdOmp6iGdcWCcX1mDDVHKDfy6kjTWkvDR51ZnkKbe9wrfezMB9fwG/7gDe06SGcZvcf+XQhKD+qbfuvuc/NnR1ojpMazx4bKMlZZpi3U/L+98Uy6a8DLQSUgsDzfLe/ohPmiraqzAT2yZgy7eSkg1oLhctWSFTg5IEBeQtYilq2nISegF0GMn9WPKk7vWMkObURm0fnAujpI3/pzIvWvISwOFdwblOgf+rw5eFDclbPiGknDPL4isYH967T9X751IoswEvSCEQXTczmaTa0AAD8Vh6+I0Yt1l7I1wCI9N4ywvKMw1JupMYBDzPY11mysAwH+/1shBIn0goRP6zNpTuyaWB4dLzipHyliCiK5FjRVjbQmzU78Vv0oh2+NFBD8DX5QW1DuFZA6AQECXKT/ZgcSzZo85jDxL9JMjgpFRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199015)(66476007)(66556008)(66946007)(8936002)(4744005)(41300700001)(44832011)(8676002)(4326008)(86362001)(5660300002)(26005)(6506007)(6512007)(6666004)(83380400001)(66574015)(186003)(6916009)(6486002)(316002)(36916002)(38100700002)(478600001)(82960400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ADDT00TysDK5AGAmEIGbEOt8ZlF3uoyOP0JxgPbZWvUGLRufm5M091IChNLA?=
 =?us-ascii?Q?7u4mtTb+QqhdwNIhJSr34OBUwpdx+PDsG0o160OSCsI4SLHtUQ6DHCfB3Jse?=
 =?us-ascii?Q?EboL3C5RNnWRCRLUMvU2xm5LMwhTOem867OQYmFehKUO4ssDY/jM45GBtNww?=
 =?us-ascii?Q?rYMbqohcO7yugegABOkGZ5fbtFl9UNfOW6J9zvGuHKgAb2c1FcB/0+j15IC9?=
 =?us-ascii?Q?wiAVKSpQ4JWD/0szL2vFXJSL1zbfGMKuYb/7xuES3oC3jRn5utHWWmd0cShm?=
 =?us-ascii?Q?NFdI8giL45kBb2++wCrB7WMF6/XlthM/2MYHlWW7RU2rzkoCdsJGItAcWtoJ?=
 =?us-ascii?Q?wB/jRbgjc6bM2GVSUwSQadOVqyboJAwb4vgNF+++cQ0xIFrPA4+6yn68Ozw8?=
 =?us-ascii?Q?7fFQPO1Dz35Q4oExAMiRDtJoDMsvp3O8HpqEZ27ds9ZT4vOPcqeadfL06aur?=
 =?us-ascii?Q?27mgee28SRRTgdHxoVsmB4wKwhVy9MkZcY/LcbKiPpDFIZ+ktcJo04Ts0PFM?=
 =?us-ascii?Q?0g2+oH7HvwAmgpAxdl4FOvrHb68kVvv71LIaaDbWrnepaB59JjEHCGNErRrK?=
 =?us-ascii?Q?QARWP++Jt/Z/QuNN+sI0WyDIMwLvqXB3ZW9IPNYUl48k+mPW6tyMPSMMTk/Q?=
 =?us-ascii?Q?nXErRnZyNBTB7CT2izpuJRm0cnmENqJD+SqFw//f93aOU7oy9b7cfHDMHfpB?=
 =?us-ascii?Q?PXvlppu39MQtlLsbUQ5fGYu7mIu13FIwpPs7Zf+a+t/91kzNdk8TsHMO7MVp?=
 =?us-ascii?Q?rvju3HsAr/zJMxaKwrVwPen1r+CPB5liVh0nrsaOJr89O4lCnIGaDJ7sMS35?=
 =?us-ascii?Q?/7BupYkXyzXUfzOWJkw/B1LQkWePqLU8ky0bPSzL9T91U4GbYIr9jGCiQsrX?=
 =?us-ascii?Q?n5Znat7r2m/oigXWUS5jcs67Mj/dGi3SeSJGpsHI0xdtIUFrN0aiXYN3udeF?=
 =?us-ascii?Q?PFl0jgdoN0vcKgdY1K3OKGhW9A6FIzbB+pLl1rhGFY1XDClsX1IJ0n6sRhso?=
 =?us-ascii?Q?Hze07Ewjfcs0kYBjdMC88x9UyRDRFw2b4JKG6gAX7diIB93xYvfoT8N5yUHj?=
 =?us-ascii?Q?GeZ0yuhkTE/AADHpby68xigOxIvU5VNBzroUpWX6/GfsvSNDFlSyA5JA2FT+?=
 =?us-ascii?Q?pwWnVMKqAr01MJOegznaytcY77GD483x3+/lCCEyRIjpkVAsHGIaQhGqvSd8?=
 =?us-ascii?Q?vpdkJB5P6h/DOgWLhIWP2tyEvFFAZBnosfUCIXijTHzrhSN2U61WgjDjHiHf?=
 =?us-ascii?Q?tabvuwIJyKbYDi/RODobpi/iN1nfNadTr4tfomYblBuGPWE04XYEa1EKa3Bm?=
 =?us-ascii?Q?yJ3tecq+qbxC0U9E4mV3P+50L0ECijlVxBaBABp43tNg+KEuFUwrTECQIAKe?=
 =?us-ascii?Q?XevTRnqIl3jlFAOmR6hjyMT47JOsX2RO/iYpo+WYT+nd6FlXeZCZmZyTpGgr?=
 =?us-ascii?Q?V6xPppF4rgX/A90OPR0EoPjewSLzcKjPdkHAYNzEirohERL4NAxpZEwTBdBX?=
 =?us-ascii?Q?DWYntfci35WDrG0y/9a6CrGtPCuQA9cnK0eD7ARlFB5KnqYZV++6zjr/OYLw?=
 =?us-ascii?Q?Yr7lUAlt+7dFiQT+sDGe5YIQCx/zkkwzvbACyQqluxWPqP9p6dnFC3X8u0/E?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d5bb30-dd39-40a5-1c10-08dacecc73f8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 10:04:35.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fSIY7amLLATSpiH2lodrcYduU8cegMwWiXm+GcgAXHS/HATrYv8e+A4Kb/vnWEL9UTfXE8Li2e23N5N0S+ut+CAmhwV3Il6/yZXAAtoRbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5563
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 05:55:17PM +0800, Herbert Xu wrote:
> On Fri, Nov 25, 2022 at 09:46:04AM +0000, Giovanni Cabiddu wrote:
> >
> > I wanted a cap on the number of retries. What if the input is a zip
> > bomb [1]?
> 
> OK, but in that case we should just have a flat limit.  In which
> case it also makes no sense to double when retrying (as the limit
> is so small), if the first decompression fails, we should go straight
> to the limit.
Just double checking if I understood correctly.
At the first iteration, i.e. first call to decompress, allocate a
destination buffer of 2 * src_len rounded up to 4K. If this job fails
allocate a destination buffer of 128K and retry. If this fails, terminate.

Thanks,

-- 
Giovanni
