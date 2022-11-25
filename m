Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF5CC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 10:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiKYKOz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 05:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKYKOv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 05:14:51 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EC03AC3A
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 02:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669371291; x=1700907291;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aiiVPEZSY6EFGQhi32+ByEbYosrZoILd3kqYr6J80VE=;
  b=BP4Qbtn+6bVw2Adv3mz/wj0/TuLBwSnhFyLmkFKTqs474Ge77gia6DUI
   2UZa5AWmCD+ntA+fEYR3bzY8XzR3cCi/3CsSrYbX+e92XeHmuvs4wl2Qp
   nUZLQrvuerv3kNBpln0j6a1TG+W07Q9G44+Ppu9XAMKnvfrNEkNiQf/jK
   /kXAz0+QJVrAkFMzVlAHBp01/0jckvjp3cWW/cbkSeE18iQOYjdQS4qUI
   /JaoxbcmjG9hGyYRZgE0gbXuF6kD5Bo5UTMeAAwBA72NIZK560tXiKN5o
   CWrELMMH4N9pLactv7A11fzjhr51xOFCpbNEiuXEVNyGCsvJCnAqAjOPo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="312090882"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="312090882"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 02:14:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="817099604"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="817099604"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 25 Nov 2022 02:14:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 02:14:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 02:14:50 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 02:14:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l56PNBOHGWn/E18V0MaXHZW8ieUEFgS7hxV59pwkc69ZvqlU1yE4DFXEXl+5X5gPHF2cpkHtM1Ye4qHNyizBaAFiZ82/g+kyBFQM5ru/Xnv4x1lO6OKvot8FB/vPqSds5uuP6gASYgzhEcH/VPnFkhbIAiZYfeCfJAmKDjmHTYEAOfoPNfrwb/B34y1SyVzaFFFsEzOI+lBeWmoJywQz3ONlyy5CAk4qZnE2U6FZ7w9gROKFUIUrqYdlFXt7OE5VWxoewr9LXmFxm8wlJnEzbcmMP/qkEbSab6kGIHOhPhkbRlUdg2mLdQ+R6FZaTloGh4k6fCBFcPyG1RQCtlCt6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJ1NN3SmGDGLTYFxfk9mWO0KXB7EgB8LnW/6aKQZdrA=;
 b=BfXfVT4BbDtKWK/x9O4KEIO4g2tQguW7HJXp8zxEmsQlvTibfXii5sR5CC9JLvG88k77YskdnMhEy4A7dizdiicYcRfsPq7q6wW+5JymhgRdz6j1YDc91auIXEEgKMbkc3hCFwSTDSfjT6BlQLa20pPpTgYUEO+Mnzlp/8MBCJQM12b2EQ/4uqyHvc8Z2x3kTzGsV6U3uMRtLhDsgo2LtVuYWUXTktgj5Vlq8Z0ZxIUy0rVJCcn5fZDYpG/5+xRgTVQsSUa3y4Vn5rlpnGYnVroCMz4EMwO8jWMLG6OqHvh72d06Fyw2y+J9Zq7HhvzssXhUEWu2ei/M8zCLMMh3qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH0PR11MB4823.namprd11.prod.outlook.com (2603:10b6:510:43::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Fri, 25 Nov
 2022 10:14:42 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158%8]) with mapi id 15.20.5857.019; Fri, 25 Nov 2022
 10:14:42 +0000
Date:   Fri, 25 Nov 2022 10:14:37 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v2 11/11] crypto: qat - add resubmit logic for
 decompression
Message-ID: <Y4CVjUAvXx9AIBBa@gcabiddu-mobl1.ger.corp.intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
 <20221123121032.71991-12-giovanni.cabiddu@intel.com>
 <Y4BKgx2axzqsjWch@gondor.apana.org.au>
 <Y4CO3O21Kx/Ywi6S@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CRBasSFNhXywKj@gondor.apana.org.au>
 <Y4CTLD7BdfFt5T5X@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CT61fknX5aNvpa@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4CT61fknX5aNvpa@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: FR3P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::9) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH0PR11MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: d126dcab-0a53-4f8a-8770-08dacecdde8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJ5v4vGpaEn6rFYlG8vVaR6IqwO/CaYzfvf8790X5TCI3AkHv2J2tkF3L/n/9lYO5Hjfs6oeTJ0/goWnMxPhwzAd5++m9+Npsgl+9QTxKUz6AvGUgFjESd+I3kKekCbbX0Q2NGRT5Nuhc01IYikG3HfNF4d1gWKI23yBEPIeo/bpfVxE2MX/zAgxJRzS5A09fW1+qs/a0kutDcTb4gszz8G6zfB85K7wf5Uk/kPtpSnuG6njieJiqjNNVGXjCwbFAl/nl7VaMmZLC2FlLEu2hSXZPvVjMaNUtWK9UhDH1LEM9JjYi+kf2IkQyzRq1g53flCEoZd/DUO25Y3qGsuBuhpOCIIA/FdzzesKdgzjf+doiGbt0f4l9WCufo1K1b0EhCkTDq/280CZhHRtL60zZ34IswqFslcKSWm02biJH38MgqjrNKPXBjVxcuPTNeT7Isz2kYRyD8kRLwKXoSjlk9kZ1joNM+bjjxS8Zr18iGrmoZ5YZ57AVf0VfoRY58im5oZJo/l86gMxGcXv7F7mjqSDgfUNmqSPXOnkjhXMVWStQ5mjFn2YTz7ffj+rmjnlnw1idP7kXo6m0zTcohYB1r44ocnogtXOOrXYuepocn3JfOmdXAu01sQaEw94Xocv5AB39Lr2BWwvzye5RkZ6MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(26005)(38100700002)(82960400001)(86362001)(66946007)(6666004)(5660300002)(6486002)(36916002)(478600001)(8676002)(8936002)(4326008)(41300700001)(316002)(66556008)(6506007)(66476007)(6916009)(6512007)(83380400001)(44832011)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xSGZuh/mp+Ico8QGutPNJ/dwOQDjzUSSFyRX+9/9736PU+tPyt6o6WtOh8FC?=
 =?us-ascii?Q?7Du9eQ4mViunAdcQzetSJtTUBLtpYWLqMQLjqZmVmOOIOsgLWEnHanLEV8EI?=
 =?us-ascii?Q?wUC+kST969MzG2IzU9nbMw94Nz5PU49oXOj3L6zL/9DcrfNnrQYbt9WdeHwo?=
 =?us-ascii?Q?evdJztv0rM/d/RU/NqPjsmYrI3hlZoZ458N5DLimor4SIBAH0uO6xmdGqs4X?=
 =?us-ascii?Q?iGq9TaOKjVjWm3lNnNUh/DDsN8ufPPvWK4ejJnynPqWoWpR1xyL12RuU69S/?=
 =?us-ascii?Q?7Z8oAokfjHklwHpCX0pyBqSB4sSNfKeoAFQFNyB9ge3FDB3hLAB8NOVOJCaD?=
 =?us-ascii?Q?xtS+GTklz8FIbZ9CMqheowZBVpjDLlOWyc+qvf9sVt9ElBYP256Nd6xIkrTJ?=
 =?us-ascii?Q?I1POfFUlJf+//DmyR6hc9+JLzxGHqqHSGmi31dqnuqTEJqXLC2VLQHpHyfA0?=
 =?us-ascii?Q?ax9z354zikDvpyAUoffia8VlmwnU4QyoYBdp/fK4oIneILCKefSIgR3b+JOS?=
 =?us-ascii?Q?uyGcD/BPH42LvtQ+S4zhEjrjzd8u2YwfNV7/PjaaGtJoZfPSN6yqA/6ZYWDm?=
 =?us-ascii?Q?EGB5ky3HT7lQ+cTI2ZVmE5BQnnrEchxl0up4LsWL7jx4+iQk+GySsoAVUrKo?=
 =?us-ascii?Q?o8DH6/AquWnHM88xzHVuiOrRAyeXYt6z1QLv9q/MVOB8NsYV4D/5VRC7br3u?=
 =?us-ascii?Q?Skny0OymF8XPKdjBagJdMs72k0F6QZ3jmIxsNr87XNDdf8Eg5R+UZYH9xZ1/?=
 =?us-ascii?Q?K9bPzl8iavQ15HSEqtoiHgxnIvNzbszEJpjJrl3TFSRgOcW7dH6dyvPe+V6x?=
 =?us-ascii?Q?PfRcwEjrJQ/th+JKv9MTJuNK7kXvaRUQGsoAB/RP94R1iJyuOB7PfVzNzcuz?=
 =?us-ascii?Q?nDE1dGn2GbHmdCldpbaQKJuSgH93QGEoISDSeTAPdz2T1nT1ohHDPB2P2zsf?=
 =?us-ascii?Q?YdfumvO6cnVLb9N6mILNtnP1rhM3zaYhRIavsJlGrt3I2NM3KVY4dyraCJFh?=
 =?us-ascii?Q?Ap7PnIcLIYc7b2/x+X2oNpJg/skwrOpZmLsTaSlu4q3uBW9ME7x7D9dJw3Jv?=
 =?us-ascii?Q?PKNJYRj9x9z/sxQf9Mvv3WzFKl9DPPKbidCcVFTg3IwAJmibR7Fhh0HgLW+/?=
 =?us-ascii?Q?xWw4kE3XPthvgyp/PE06hHeav4WEY2twFkXOP8njXjz1uynxLOzwAPLUtcII?=
 =?us-ascii?Q?Sni/1/bZR8i/+vxRCVdMfijMPD19sAdzWtiEVdRQgzb0PQpRLKff46vGcW6q?=
 =?us-ascii?Q?FJwDxmfGEnO+I+D8XRUmQqvbN45yjxP0Tsya7MhYEbf02jRvMUivCgqZH3rP?=
 =?us-ascii?Q?xI7rxbrQ8jLbmBtwTe9VV0ncMno1XHSFX86zJY9ug8xazyyTWLguMWelU95p?=
 =?us-ascii?Q?TLOuY+6d17DapUTdTjEdpzewsetxkdYcORnK17Z0wZngu/PPWUqMoo7qdqio?=
 =?us-ascii?Q?iemwO75gJNdidXNKY/3c6jK1VSkwom5nX5aIIhXzT8LvciiibJmbah6G9Lku?=
 =?us-ascii?Q?V5ZsADnBuGnwnqNpgR24FkT1WbF+LFVV3ccWo1pP+hUX2DGYu5tiwGalZo2R?=
 =?us-ascii?Q?x+r6IXCO/KcevX/WYbS55/+32TzaVu22AtaDH4Iz3X3KeY8urs0CNiqih8nw?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d126dcab-0a53-4f8a-8770-08dacecdde8e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 10:14:42.4784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H9qVsSolajL2DzN8QIGn3nscw+UgqSl/LDXgxyvpIP87izYdeDl+9+qlqH6dTJIGeS2xnK03vO6XGMO6yHrx5CgEand/yWVzp1Jh4na+ttk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4823
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 06:07:39PM +0800, Herbert Xu wrote:
> On Fri, Nov 25, 2022 at 10:04:28AM +0000, Giovanni Cabiddu wrote:
> >
> > Just double checking if I understood correctly.
> > At the first iteration, i.e. first call to decompress, allocate a
> > destination buffer of 2 * src_len rounded up to 4K. If this job fails
> > allocate a destination buffer of 128K and retry. If this fails, terminate.
> 
> Right, that's what I was suggesting.
> 
> Oh and please add the limit to include/crypto/acompress.h so that
> it's part of the API.
Yes, that is what I was going to do. Is the name of the define ok with
you?

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index cb3d6b1c655d..bc16e0208169 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -11,6 +11,7 @@
 #include <linux/crypto.h>

 #define CRYPTO_ACOMP_ALLOC_OUTPUT      0x00000001
+#define CRYPTO_ACOMP_NULL_DST_LIMIT    131072

 /**
   * struct acomp_req - asynchronous (de)compression request


Thanks,

-- 
Giovanni
