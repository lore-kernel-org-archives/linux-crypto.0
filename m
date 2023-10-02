Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B9EE7849A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Oct 2023 10:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbjJBKO1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 06:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjJBKO0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 06:14:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36319B
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 03:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696241662; x=1727777662;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kBB3iJHu4XXHA6p1PyrqI1woLN/9A9IMIIouQ0kPc9Y=;
  b=eG4VMW9p1iVedYWyNZtoxY4YEa5ExYOXoE9MBCrPiKIgl9MrRKYQEW60
   31NQIu48lH3MirSGtipJdIhpVdrdp0JF1A05GIV7Uegelda+ogj98HGPO
   bhRU6OVRIhFyJbyM4wc9h1OQbNalIof2Vak01OTuecRoSJ2F6cTXV0hhZ
   5lP9QCfth4dIhQiDCEXB0yMd8MOnJKQ3hCya6WW5eRiOhnUf64aGNOGsl
   vH8psvM0LJnQFkgWEvzGZANP1N0ceklzFppav7aGzPrIXtMQvp958z+Es
   NOedBZWgPz81Z9ORTqpLWhx8wFcpV16vCi6GXIAc7tORi8M/CEjg6ZuHp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="372964297"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="372964297"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 03:14:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="1474639"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Oct 2023 03:13:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 2 Oct 2023 03:14:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 2 Oct 2023 03:14:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 2 Oct 2023 03:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlsDaeTmAyfz8IuWG7LQL95hKgFZxT13lt3vMLX1AmlaMgI06K+QEgjpH7rpHRbAm53RksDlRjwuPK34DDSXaNdMw4sYl6VUzlXxnb1JH4LjjULG++lTCvFwrWLtOF/kZgROZIccYpQ/y9+71Oa7Zv81cVwXpcBhz1ra/Wf3GPNB3JEjIEcRHyg66x1XZtSyZQZuK35xE193UjuR8+vlBLaD2gokyYRr3GbxZtpzW0AnpyTwYJOOe9qYkHP9CWqAgEL6x0hBbOoAFYg9zvPsNpCnY2RDKAnsJxujlYWZYpstgGKyRiOLHFX8oS+VKcOAw3vvypVnfBdb5Rfax0KkIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FsvzF3beBo2ytw/9teglp02tDc50jBOEnyS6TkNtW8=;
 b=Ph+nOEFZlGbpAjBoLRjkxGRpsyFIn4MOxXZucGEppFzlG95mfTC1N9VcXBTN5o2VgrrVIPBHjQ0MvbWpIJS3e5VgLtKtSldcNPU2YoXPBGWSs3n/+3S/dhQXqD0TNpNMBiMLUnCWwkTMjTfRMMK0U/aPOAoY4oYuMw1tu7bg6AwDATZxT66ln646ItkkSTLpKM8GqEpA26ne9OFIyyT8q637Yig1/6aBIjAuIP4aiiS/zhMI5hHTI4f5RuO3GwW5sWI/TJ2hhaD1bxyDrJym7Szsc/T/ryHKAYaK/0Drc4HjiRn+J73VcLPc7kzMz1NYjJXLJrmeZXStGns5GJl/SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by SA1PR11MB6736.namprd11.prod.outlook.com (2603:10b6:806:25f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Mon, 2 Oct
 2023 10:14:00 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1cfe:33c9:5525:da28]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1cfe:33c9:5525:da28%4]) with mapi id 15.20.6792.026; Mon, 2 Oct 2023
 10:14:00 +0000
Date:   Mon, 2 Oct 2023 12:13:46 +0200
From:   Lucas Segarra <lucas.segarra.fernandez@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v5 2/2] crypto: qat - add pm_status debugfs file
Message-ID: <ZRqX2iKbGC8Jqkp3@lucas-Virtual-Machine>
References: <20230922101541.19408-1-lucas.segarra.fernandez@intel.com>
 <20230922101541.19408-3-lucas.segarra.fernandez@intel.com>
 <ZRkrasH0zjj2m+GQ@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZRkrasH0zjj2m+GQ@gondor.apana.org.au>
X-ClientProxiedBy: DU7PR01CA0004.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::18) To MW5PR11MB5812.namprd11.prod.outlook.com
 (2603:10b6:303:193::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5812:EE_|SA1PR11MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: 20829742-d0f1-4e66-1bfa-08dbc3304bfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+dr2XyGJVvTOHe58RGVhJ6um49DTbc0wZmNchYr/SN7/Wm6ffKE+TozZUTfDEE1Bjl2qjoYF4mIaGp8VahS/W61u+GSLFrs6qSkKXtP3cES7FHHtV4VlNVTVf+0JmDx+GDrhI0VQmUEwZ816zM318aV/16UPzfmdFYxOgfbrB7IaYxULz9G30qdr08CZ/AZ26TNA5boCrNIx5l6amAjeEvHElzGvbEe9YFHWmw3t4Fm76GH/SppnRZpEJLr+rkQgbnzb7JmSEGsx2ZmpLwH3oc00Sy4u6QxPmyOLwujQE2ddZaS7o02klweEYyel5pUWzXMP+bh/RuxlrcjUcu9KeNtEKi8NdFYXacDZ5V8eCvmbk/UhCj/QwY4mc8bQ92y60BA18kmHUUQjG0RRmlPgyBK6vlige8GTTvryChU8shHuRsvpEcFCMdRvLvlutPM5yUa+7+sp5Tx+saeOYf2nIwMGUE+MaxGN9Fam7CAOmdw7XorMhejZAK+yhXs9a6iQBQlfpilGGz7d9V3D/jD1KEYIy/5hAGqHgJ/JEpGzcQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(39860400002)(136003)(396003)(376002)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(66476007)(107886003)(6512007)(33716001)(6916009)(38100700002)(26005)(66946007)(9686003)(316002)(41300700001)(66556008)(4326008)(6506007)(966005)(478600001)(6486002)(6666004)(82960400001)(8936002)(2906002)(8676002)(86362001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sDVZdX9kpum2GPRgXj+E4WkZzwF8vzjTE/J2a7Uf0c4UXLZtUtExx4yqeKbo?=
 =?us-ascii?Q?hzJNR87BM2itg+jZlAfnLXdWyEbd3U0nQIXZmLOFhTretUpuTkZF/Kd5jJu8?=
 =?us-ascii?Q?xUejURKogY+meXjHMifyzeVCZURG+HDFhEWHXsZ8ENaquyIs1n9qVF8KD1qw?=
 =?us-ascii?Q?iOpej7XhwG9Ey8suuOTw4TEkR+n0q984klEGiQJ9unrnxjbTuSXzGYyIkPgY?=
 =?us-ascii?Q?FJQkfpPayHaTwOYI3JbpaSwLZkq5p8OVDahEvEu98FwKsd5uyp6RZ7VcwLJu?=
 =?us-ascii?Q?gzbsU1fXK+5qkPnsxNg/hVjC+Y82WAucPxMZWsEC0wrCIzO62kpPuvbrkAbL?=
 =?us-ascii?Q?CPZhIEHz4yDZwxB06Oq/VeYm/SjTYXHyAGByeVz3o0B5OnARFxNKrEI0ihxy?=
 =?us-ascii?Q?iKs079kaMg826+co3Q9MVUa+fM977wOfT5vGulNSXhLkRA+eQ2J0KF3DLqdI?=
 =?us-ascii?Q?L+TqkD9aiNhA++fXItf/+/kBbGp7UevtFsd7gpq6+w48Tjqah+J3otH9B9wn?=
 =?us-ascii?Q?hcfR9Cfi/NQuMzR9yo6CY/GJzuk18ejDMJf8nMFEz52XL8rFwOZMIsBf+prA?=
 =?us-ascii?Q?o7b6/SP8J73b0exqF55rbUahoOdfTVBQDkMLT7BXGEB3/ZF22RDBFr5lv3jd?=
 =?us-ascii?Q?tr5VYhQo4FNhuniUJ8jOZFbV0WbGfS5YdzEhZc6Q1wl3gjX+ZdE618yvdfbM?=
 =?us-ascii?Q?KPOOUcMc6vb6S8gNXabuOM6VnXZHU/dImeKy5P4AaX2Wuoe4A1fyAug0dD3c?=
 =?us-ascii?Q?+p7GdaSH9zSYG0edggXzMquAs6T7pILkMysL/Q2lYDlsgRjBTLQZBH1F2PPO?=
 =?us-ascii?Q?S1s3tz5nDE3Hr4PsSg/jRyU/I9Vpr6j/ST5knMKIOCMSxlP0ZfziqRP2ejFw?=
 =?us-ascii?Q?FlhLVTt8VuSRvRac5Mg6wKxbOR4U4NEb7Zo7q9wbpR7frrWx0UTYGv/smUxe?=
 =?us-ascii?Q?2wgTQPzVszWOUfOZEz3IxkkD09ssZH3IDDgqsXknqwH9YuEu1bpaaS6rYc+5?=
 =?us-ascii?Q?t7lKgjCM3AqGMXdmzSLbKMf9XsQcG/HI87e8Exi6UlqGgDniKxWerpyM9b+U?=
 =?us-ascii?Q?83SY2xFpahlJmUM0CqatyPebcBSrBVN38GP4Rfr1pPx/cN8lGg2F/AYe67Dl?=
 =?us-ascii?Q?my/4KnnxOcM8FULzUgMhZ6I7jiNzlu/Ri4Uc8BCZuznrijwFsOO3095yCIWI?=
 =?us-ascii?Q?XMwnDUEaVuCL6Tx59UXwuGKlDoKfbWvKEjc1JkY4xZUhujHI8oSopUsw1TW0?=
 =?us-ascii?Q?2ReSj8tdw0TogDlLYjwAR7Y1bJpMmclb5II9u/GyC+6TMNaYAvSJfIBELjj1?=
 =?us-ascii?Q?WGtyy0G32qCYWdEaKXf8Kbqo1tCyXgXc3xZbwgB1+6kLSajpuvgO+VPFPE7r?=
 =?us-ascii?Q?sUiXUPzvau/IqKDpX+lHEE11csdKk+27iM1fnd+gYyH4CChCNgYFT33XkQy5?=
 =?us-ascii?Q?vl06g4cD0fDABnSl4VTahH6ImLfkNr0MFVwPj+b5lyTE0PwZK3yxU3mnrvH7?=
 =?us-ascii?Q?UoiMJ+3+pHYae/P8536KSYlyM0Ck1bimbkFiJJPI2iw+Pt/yjhvCZnS496Tn?=
 =?us-ascii?Q?gcUqakKzusRFToR9Te73v4KGhn+FW0g/4jcsuFae0TCsDPflY+ON8ExesgeO?=
 =?us-ascii?Q?A6vliYf5p7P4s8q0+vRfl/4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20829742-d0f1-4e66-1bfa-08dbc3304bfd
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 10:14:00.4852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/VllAK2RDdRln25Q1Sm72AqjhfdkZOBsw2c/LPNt9zPjTPgsUTwc+76rn0Zmj3PTt6h+uZIk/n66FcYXIW3TXCoHnHgOrwNPmFFFmhX9cBFcfXUEZG1kpCiM0/ZWl5D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6736
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 01, 2023 at 04:18:50PM +0800, Herbert Xu wrote:
> On Fri, Sep 22, 2023 at 12:15:27PM +0200, Lucas Segarra Fernandez wrote:
> >
> > diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
> > new file mode 100644
> > index 000000000000..55db62a46497
> > --- /dev/null
> > +++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
> > @@ -0,0 +1,255 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright(c) 2023 Intel Corporation */
> > +#include <linux/bits.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/slab.h>
> > +#include <linux/stddef.h>
> > +#include <linux/string_helpers.h>
> > +#include <linux/stringify.h>
> > +#include <linux/types.h>
> 
> The kernel.h comment applies to this patch too.
> 
> Thanks,

Will be resubmitted including kernel.h in this file.

For the last 2 submitted versions of this patchset we've tried to apply the Rule
of Thumb mentioned in [1], understood as: Include kernel.h in every .C file that
includes __3 or more__ headers directly included by kernel.h, otherwise include
the directly used headers.

It seems this understanding is not correct. Could you help to understand which
is the Good Practice in this regard?
Should kernel.h be included in __every__ new C file a patch adds?

Thank you!

[1] https://lore.kernel.org/lkml/ZPAPSOnSTMgYrlV%2F@gondor.apana.org.au/
