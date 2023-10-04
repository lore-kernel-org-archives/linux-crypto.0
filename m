Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AB9E7B5E2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Oct 2023 10:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242053AbjJDKEC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Oct 2023 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjJDKEB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2023 06:04:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C43F9E
        for <linux-crypto@vger.kernel.org>; Wed,  4 Oct 2023 03:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696413838; x=1727949838;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SIDNaWFxgqdgZVCDcvcOKRy0SbAU9NdWG6Il0Ij7aLY=;
  b=MKRpMIkDLJ+q1FYm77ne1KQaipfbOjc/dmc4bE00qiMqEmeWvolESZjl
   g+QBh/shPPlsc8IueOvOur7rlCtphWtD1abcEH0sPRqLvx2Y7P1Xe+a3U
   DSNk6o3jzU625Xw+P+qFtwCfxh+Y66oGugOWm6qujBoFW+JMxF/20tRnX
   0bhPdleOu3CY31yKGPrQ6Gyg6yBhL0g62TRT7tbhE8i4wVkanVd3yA4C1
   IbnqEHPaPzZ7Bpnrt9VjOwHL3yJp6UVwWLaoqva9eOjG5V3vevK65S3Qh
   hDmNnxFq1gvoKbAjtzV1dqBYD5YdDwAt92rCtIOgXBf4itoZR4otUEiam
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="362473244"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="362473244"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 03:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="744896906"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="744896906"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Oct 2023 03:03:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 4 Oct 2023 03:03:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 4 Oct 2023 03:03:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 4 Oct 2023 03:03:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 4 Oct 2023 03:03:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XntajA01qsh9a9so690Yi/t78aePJqIIJ3D64nrcI1/xOrkNBfXw3wy1qinnjABA3fbuGBLGPKKnV+t9BHmX7djrN+dTyiK7sHm40p50duQebxnzmWQKPoWKlUItbLveZjE0MRAgOsQ2v7DHKQce7KAAU6CaOgy3VdkrOKsOICLHrmL5Qfk50FYUO1qgC7SQEgron8okFcDuhxc+jXQEa4jsXHmHNS0fzkynFQsj0RAD7lOc1jS6mW8mY1capN/uLT52s4eXsr4Tk8YmqC0JaZ8QDy+UwgjjQwQ7czDiisEd0aKZqbgtrrBmwWYulnvU5yAc9FkKJCq9rvpFLqfRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ue/U11Q4Rj0ZTazb9SckXH2vPYSxO5WGHgPBHuGEUQ8=;
 b=jrHMtzGI3NjCVFISVo254fTCe9s3hl9UvpLXmRHhXBTO5bXk+NX7rbXSKz4a4ND95VF8nHTiKb713omKBGRJsFZSGTOrF0D82akL+AS3njEEM0tjFscs9FDAxsOJcR7ORqjKZiZy49DbTWt+Hrk+ETGeqCcwR1WMnuptoHd4ZUo/mWvMiyduknqoozHzXlbqf3WyzRLHwiVfrDri9CIQyCttKsuILTVKi5cYb1zR4nGiLQUKOe1Ws2llkl/wPtjrKOMwCCDn28f/rYI/WyPHNd4HghKMP4etynsbXGxbQFZI52tK0i1VfPYJPCQPyUM7IeuOt+pGDF4vylU6JvJtoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by DM4PR11MB8204.namprd11.prod.outlook.com (2603:10b6:8:17d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.28; Wed, 4 Oct
 2023 10:03:40 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1cfe:33c9:5525:da28]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1cfe:33c9:5525:da28%4]) with mapi id 15.20.6792.026; Wed, 4 Oct 2023
 10:03:40 +0000
Date:   Wed, 4 Oct 2023 12:03:33 +0200
From:   Lucas Segarra <lucas.segarra.fernandez@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v5 2/2] crypto: qat - add pm_status debugfs file
Message-ID: <ZR04dWCgPU6dnzpW@lucas-Virtual-Machine>
References: <20230922101541.19408-1-lucas.segarra.fernandez@intel.com>
 <20230922101541.19408-3-lucas.segarra.fernandez@intel.com>
 <ZRkrasH0zjj2m+GQ@gondor.apana.org.au>
 <1488c761ef924df48ff89825ea8571e5@DM4PR11MB8129.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1488c761ef924df48ff89825ea8571e5@DM4PR11MB8129.namprd11.prod.outlook.com>
X-ClientProxiedBy: DU6P191CA0046.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:53f::20) To MW5PR11MB5812.namprd11.prod.outlook.com
 (2603:10b6:303:193::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5812:EE_|DM4PR11MB8204:EE_
X-MS-Office365-Filtering-Correlation-Id: 02cb96ef-7a91-4d20-5214-08dbc4c12f32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W3z0w4IGUTXndgQ4/OhH4GyFLlYjunorElNMZeRbdv+G7KC1yf8Vy/OybWBmAbwg1Shp9UYpev0Qxloz58tqHfotWXHnIbXYXuh+Yc5Pm15q4lOKfoV+ENvdIdSsNTnXi4ivN46pUM0PhV/27Yj63qBl2Ce3FaD5Cy2eIXnj8WCuCOrGpDkvX4Td1Ymu+98MiaWYBlveMFWBCB/AIlii386y4mUbDWgvOg4jTbCnX3F/Iq64qNXxLI9NGBXyBpVx7aJ68Zti+aFZTo/1+0nBVnBCwMCqjH0WhFX37SZhMY3fj9K7qfThezKPCZmVA0lKyk3gm7Jc+RvZPZ04CUYNbmfe7yc+n24lZaFLqYW132aaU9cxHIJ0HYRwaDSc2NLEQhlbtr/R2BODblqUKuuOa4SmfFKCFSgYKa8qtrljz8BXIHEADJ4pJWiEV+f0I/noGAjL8OLO3M1Ujy8dSMQV7442KwZS3qZMcsHX14hkzNPb0bMBmsQmQus8Ka6lTt2zbiSmGSGuw20lteZClqLZdf2CllwRNkvj5nnRCSbHglI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(366004)(396003)(376002)(39860400002)(136003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(82960400001)(5660300002)(8936002)(8676002)(4326008)(2906002)(41300700001)(66946007)(66556008)(316002)(66476007)(6916009)(33716001)(26005)(6506007)(966005)(6512007)(107886003)(9686003)(6666004)(478600001)(86362001)(38100700002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zZRJwnpkB6FQNaAqCL+lvXucylK+2/0JTTv8yi5Tyb7Jb2Z5m4xXmi9V9SIr?=
 =?us-ascii?Q?tImbhL1IquEyGhTFQhMiagu+pDt0joOmCO9H/qn/bd7SjUf/Ji3a8l7/Q5Xj?=
 =?us-ascii?Q?iTMuemY9cGolfS0kvrFdSQaK2rohUCTFdBIUq3G9FOaHJmjrAPohPFKZ8a8s?=
 =?us-ascii?Q?//trF1PTyKvzOdFbMsDPOS/HEtVZ0l+xdZ2T7sH4Wgyo/a8Ms6P9QDSkU4jV?=
 =?us-ascii?Q?7V6NKrTN2BStc9F4ItYd4bsa0UlKi3DCeyoHS6FgfHDboehv+6sP+c2JUuBO?=
 =?us-ascii?Q?btyFkHttWaTKfjKBNDgHL7pURu1LAxK635HUFBCP+5GCUiMAJYPWc9IaQzXY?=
 =?us-ascii?Q?4Fvoi7spsKCosdhbo/PrCQEQV+ScGlN77pXezeg3yaRIvyT/DkUItQ+lDHH9?=
 =?us-ascii?Q?3grJwECXTugqcndCNDyzX4n9iSUTRsijQWA26djmIOs5UuvkptX6WsvnouTO?=
 =?us-ascii?Q?kz3M6n5LqDZRTFbRd7mjdScq0IxL1Zw09r817wJol0J7loQPvmyp6KagllP7?=
 =?us-ascii?Q?YKYdSH84wlaiDGerJshsztiOd2u1MDn5KJW8QP57xaVab2rcboiSMHzMWFoC?=
 =?us-ascii?Q?GD2PnCh2vh247meVuurd1SNDlc5DtdOyxHZi9zT55939hzhH4UwybrtYghih?=
 =?us-ascii?Q?60DbHcTQqawkq+R/rfy2w7mQdkKP/G76dAKjmZLgL7b/sNUCgDtN96xeu0vo?=
 =?us-ascii?Q?fAu2Q1vEv2QPA51ZsQhUvBIbLGK1DF6iK58Gw8yWxvVrJX412bPV6tXHvyt2?=
 =?us-ascii?Q?gKkHWhl7MQRcd/Xgc75mn0T4u37w4mX5oWzBe/XP3TkBGEl3LoIQWno3vqYm?=
 =?us-ascii?Q?upqn3QuUkQpk7BeR7UwMa94XepXypm5lVCAsEoghtyKghmd4t0k+OjLQUMa3?=
 =?us-ascii?Q?1FVoKiyTAx2Qm29bCeJeQ1Yl6gOCzXRMkfNXMo7F2nObER0JE1qho/zUjMeh?=
 =?us-ascii?Q?fTQQy5FiWDvsFx6nGdAryxiW5/Mo2/qRx2ZnIBmoXFSca2dB+iIzXg2gxd4i?=
 =?us-ascii?Q?g6KjBwbqYgd8xSXMQzpzRMNc1I0tVblSwDJXUDWqbTW1GJeYCuogSlThE/Vk?=
 =?us-ascii?Q?q4C/jzifXu7w0zIBZtUGW9mIZR8LDO1iGK40E8APQINZemjCQ3N+IFPIguSp?=
 =?us-ascii?Q?vSRxiMQRm66C1V4MGSO6DzqjS5KQtERCcMLijpjd7ZNKgXOhRIcj+I7vCMzV?=
 =?us-ascii?Q?uap/f7BKC9KLqGCUSPXJv/Rltjanf7fgIgabb+7bPk7zxyKhaIuaUWuoIdUy?=
 =?us-ascii?Q?RSnl1ed/8g7Nc688HtNu7XuM2knFCfrrnB0VLEmdtypIGhED+BE1hkkgQ8Nh?=
 =?us-ascii?Q?/yYKusaEzAaOaxNFci2sqO5sAJEnmoBnqqudkrp9yh5OOwIBimG9+DQmqeGd?=
 =?us-ascii?Q?sKQf8sH9iHWDf8makl5RK1dMcAgXyUvNyT2o26YB4ypSFm1/rduK5IMC4jvA?=
 =?us-ascii?Q?RbX9PEgxxuxjFHy+qlf2N8b+MuXN8LXbbHDoHJ7fjbzr7sDMGgcJQwdl+DyH?=
 =?us-ascii?Q?oBpIn3MuhM6DCRkiXP93p2Y740//aNzMsmWnoxSUYaE7dFBsdM1PAirknuP2?=
 =?us-ascii?Q?FqJdtlSm6OASTmjZowqaMChNUji8hWPjPUlLBKoQBVS5eb5OPAP4zA66qhng?=
 =?us-ascii?Q?0YZB3fluSJpsmJJRTNuox6c=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02cb96ef-7a91-4d20-5214-08dbc4c12f32
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 10:03:40.5454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78h3mQJwOENYF3gACtp4jt/fn2pmLEPmHzwuUkywk+L+n9pkX5eSOxsm24okaAsykhW7cQPbFzKe2HqHsr8LTpOAZNrIYsuQzCmcUvURiwSQTI2oZpoukLAdM+Oiu8iC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8204
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 02, 2023 at 12:13:46PM +0200, Segarra Fernandez, Lucas wrote:
> On Sun, Oct 01, 2023 at 04:18:50PM +0800, Herbert Xu wrote:
> > On Fri, Sep 22, 2023 at 12:15:27PM +0200, Lucas Segarra Fernandez wrote:
> > >
> > > diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
> > > new file mode 100644
> > > index 000000000000..55db62a46497
> > > --- /dev/null
> > > +++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
> > > @@ -0,0 +1,255 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright(c) 2023 Intel Corporation */
> > > +#include <linux/bits.h>
> > > +#include <linux/dma-mapping.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/stddef.h>
> > > +#include <linux/string_helpers.h>
> > > +#include <linux/stringify.h>
> > > +#include <linux/types.h>
> > 
> > The kernel.h comment applies to this patch too.
> > 
> > Thanks,
> 
> Will be resubmitted including kernel.h in this file.
> 
> For the last 2 submitted versions of this patchset we've tried to apply the Rule
> of Thumb mentioned in [1], understood as: Include kernel.h in every .C file that
> includes __3 or more__ headers directly included by kernel.h, otherwise include
> the directly used headers.
> 
> It seems this understanding is not correct. Could you help to understand which
> is the Good Practice in this regard?
> Should kernel.h be included in __every__ new C file a patch adds?
> 
> Thank you!
> 
> [1] https://lore.kernel.org/lkml/ZPAPSOnSTMgYrlV%2F@gondor.apana.org.au/

Patchset will be resubmitted based on the following asumption: If a C file needs
to include any header directly included by kernel.h, include kernel.h instead.

Regards
