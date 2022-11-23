Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9610EC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 11:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiKWLvp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 06:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiKWLvo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 06:51:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3C265E4
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 03:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669204303; x=1700740303;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mRn9J1yzaB6BGiLcrf5uaQ+gnuUfk03dozDdp1On8ow=;
  b=JPz9C+4uIH9t2RwtQiEvNLSkSjGJ4mktsxchH0lv/30iVYscVoFt1vnR
   M1hFClriS6xw2IDF8yf2p5FKXpg93kpBkvy9x2dxPtufMHoW4w/G/4i9L
   yMqzpXoPbuwHiU66H93IXUWqAf8A4ZaDCQFKuqvpNaUXN0JQn+NU4KyvT
   S5soom4+JWcDyKdbTPD4/EREKB4sLjEfEz8vVPh5DntKWoiBjsPIm/J/7
   qGB9JWD0Mtegw4tBXLqQr+uieQnBA+shWlL6hir4VjidOkpjUv7s+bCo+
   iQAAvLbthUs5crvebk1in3i0Rj5dqKxIK4chxgmUdXQJyJ9DR3K/ZTSqC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="314083413"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="314083413"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 03:51:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="730759671"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="730759671"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Nov 2022 03:51:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:51:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 03:51:42 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 03:51:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7G5Q+4b1uT2W3Erxzy6CFAJahjvYD18WIksq260xZH9JSadOF5T4JUK+G0BkPKbdWFfqNSM4OEjua/R/vjhAi4YE16zSUGOuuVWbgpMOgLx6MNX9LQd5xSWTwOMHREY2z7TmKfofAVff0DSWWXgX+cRiv4NUcvlk88PBH9VB2yd6uY+ABug0D+zeYgnsY1nxLtNgSfOxymrQbN5Gc4mz/KucLsHpOaJjrhTB7DLyXo23S6rT369QfmL5vlZfqpJRjUbdpmjPWs0ndSuCRbd6e1GwLLWTns9sE3cF0JkcuVyf1qE6TTVqde1Er0iYcp3Cd0+cD/j46aZlSFGCtlDHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rqk9it+RMirok13ncFmr3/zd99Yzz9ojMo8ZFh7YDe0=;
 b=mhVQc7Mg2Qk075OAmdqNJrsiFvHoeCDqX+qpijcHPH91uZ2/XTCDJ3xjBhEJd7N2C1wWJwZp8SZ+38hGcIU6sPaIr8IyXxwfjW+XE26j7geWLTbkKF7lsMSHdzqE6Pkjy0yz2+4+MC/3GxGz411CjQ1BL+/OnBzkP+xQLARC4FSOkju6LCjoI4vCAOclezyWeetBmw5T8ZUhFOzOi+7Imste2bNWH5+335Dg6WGnRBDCgQEUEXeDh+fYPnFy8ttONZluB8CbRW5u6encB80WPipW2Q1KjZU97ChL2dSYPmMwrQnt+WHZmSe8C9duWxfHEDkphOyOmR47hMC+fMS2iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY5PR11MB6320.namprd11.prod.outlook.com (2603:10b6:930:3c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 11:51:32 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 11:51:32 +0000
Date:   Wed, 23 Nov 2022 11:51:23 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <qat-linux@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Use helper to set reqsize
Message-ID: <Y34JOwi60zducz7x@gcabiddu-mobl1.ger.corp.intel.com>
References: <Y3yW0jaRbzC44S4z@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3yW0jaRbzC44S4z@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0522.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::8) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CY5PR11MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be499ff-04d7-4c3d-0cd8-08dacd490f84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fe5EMkirP7oJUyFPaS42x/SSSATPXqDDKiUdxPgxKhxwPDAEMsGtG0WHUm2g1+2mLMTxVruody5mVWsQTOn9z4qGReo9APRuv123f0+TWZCNLpZ4HYx31SX000F3HEtGVk1ob9GaGHpF9J88RxdDxJfcIrG+X5SO6Za6V4vZPqcueD6ChTTteYw3x+GRTtW2WEXDdkjQc4szOk792HiAWOZy1RksSiqb1tlhpYkjqrTKhBK5kWFo9x2m/tPoo8In1939rLsqvwAN+wWRM5eT9WY8+OdRSoGm7C8xuQqHidHh77TpbAP8ZKIa0mvPoXNvVmzi7xqXQ16juFvIdkYKz8d4ad1zI2BPczxH1EF4F8KwlYRX/n1MZk6M7HhG2U9O2vHgroHj4lq9BpEbJBGFz0CpGD4Q2QlKcxdIi5ecQ/Lh+lxs7f6Pw7FJFGFXQ/j5S4xDRg1Y044C3FPaN/GXtH8/2IIVj0sieSg3p35LZdC1VXCcxIVHGGWKXxlEwUPg37Rz7QMfAM7nyoCBqaxr77/6X8k+Kif9CePsh7PpMKHnoRAK60jOs+TS7CD8gWewys+yLsfYwzq8SGLF4sNMLcNjpSv/JfrJhFd0O38/0VqgC4Q38MLQa+iwcw8n2liRo2Jef96MRmTKlZMI/OFu/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(558084003)(86362001)(41300700001)(66556008)(66946007)(316002)(66476007)(4326008)(82960400001)(8676002)(38100700002)(6486002)(8936002)(6916009)(36916002)(44832011)(478600001)(186003)(5660300002)(2906002)(6506007)(26005)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmfupjlQqPxbh8TBrkkLvsD29VOO5tWR/Ury+LMbYzGMU05Pxf9DvsT1rdkE?=
 =?us-ascii?Q?Hn74MuaqbaFZCIsEyYroILhKlUIVLgBvmyzNr6TrBzkx159F6XvkpQZ8zQY8?=
 =?us-ascii?Q?tQDse6sMib45kVFeRpY0VLRjHqWT6cjy5b7XG9KWRhW3sSIhyl3CXIzd8T15?=
 =?us-ascii?Q?ZIxXBnYiJhCF/qTXyyiuGSCWmrgHTCv4dtSsoo0fxPqXD7dyAprW/6qIwhDQ?=
 =?us-ascii?Q?kxqoPVqaJUP9GpadmtbbvkUUtncsWkeeo5jnSoFgAAHlf1W9GZckmToFBqql?=
 =?us-ascii?Q?debDvyK40uI26j3ASxLJvNOID5kV5nWkPiYv1Z4oAVlZA6cLa+R+UJj8d1wX?=
 =?us-ascii?Q?Aeeey6JRZSHrojkbL18FopdmN2oGEGbjvaHajAXHkueUOLLOzLMjGxVDY89i?=
 =?us-ascii?Q?Dk+b3C9zJ8YUCG+Ivn+pdkT4NvrJl1IfgZHz3ofi9lFb3EUANuxjcRXqAAbh?=
 =?us-ascii?Q?/xrgfA9uOsftQw7Dl7rqmcSZ6mXwE5BHXzvrXidVJAD3NkXa+HC9O4SxfPzX?=
 =?us-ascii?Q?nG7sTnrMjMNkbahOyrmU3+WR5Z3tIJFanZ5e6SeRZEZLspJ4Qky+ccvuFHEK?=
 =?us-ascii?Q?VG5H4nMPLNRo53Y7/mBAdawlxQvmLFECg3uAg78Av4bJljjNK67QCLSFPxal?=
 =?us-ascii?Q?4bgcJJdlnhHeVXyhhD37MQvor72RuK+UeQ226OmU9hvE4mmUgCfH8iW62FQj?=
 =?us-ascii?Q?7t32TjwCA41x4SSK10FT9rnOFidy/jsEQrqNXzmU5DU8BnyhtAQDMcza/oGu?=
 =?us-ascii?Q?IvgPvtXBNPOu665II/nH+O459cbZ+rHFfubn4/8U2SRktdVkNrJEPdTibZI6?=
 =?us-ascii?Q?hJaT+zpwHOgfbcjl4sbTORueoRwYAoNGqYvWica3uOoMWeXf25JLAcUaMZIs?=
 =?us-ascii?Q?8LZoB1ltvBdGW0Berg2aesrJR/2ewsiJFGFZM6Yk/RenyOysJjuh3J/F0M5K?=
 =?us-ascii?Q?s7r0GJMuLb3Uc885dmzMBDtM8HCwLuqujXxhtN5sRiXqwEA+WzTzXcsoJBAa?=
 =?us-ascii?Q?x/K++c98+mc5hTjOY99lUXZ1Ak/oAizqFDg1U/lUrOMcdTEUa/0Wf6j/wytO?=
 =?us-ascii?Q?jt4tn+XD5MELHHQ8O7LiBiYpIvjXVochL9FMZNT8akkh5T5y6ZJt2ZZnxNLg?=
 =?us-ascii?Q?rdlN9jzJw6WAdlPk1gunAuuBEE5vtY+/lD5M303ok3qXHWoE5fJmBauVwd01?=
 =?us-ascii?Q?afzbN+/WXKQZMocq8dsxwQiCS0azV8OdSaU/MHHOsPUeOMKdQEjtrdHipyKZ?=
 =?us-ascii?Q?yzkcHs274k0tJsqBv765fRLztsj6d8sK9RSpNc24XXxaGXw3xcfXZIMKxSUp?=
 =?us-ascii?Q?Rqjy9VUvjGCc0KMl+9YdxDxCY0mQcqq+QS17fbIfrWi9POJMPEgdzNuJUWBR?=
 =?us-ascii?Q?LPvglYt8/y5P6lDGzywzwJCtKuxiqsF+aSbuhJPjrRWOPC97nt8iVMWbM/b8?=
 =?us-ascii?Q?LBpIbmWk3NJN73ltDsFcylIlEa3YTcA/XZJZIIOHFJhIur+UXUZOOi/Si4Fe?=
 =?us-ascii?Q?NqJrfxniOMa9wq/5DbrmOE1g3MuqWN47ZUYNWEUyFY6hLdTOQAubsVrOQeQz?=
 =?us-ascii?Q?v1jfuajsYzAUETJBeTnlBNEAxohSHM6J08KBJaBpMaVxeAYuRPZd0YG/CnyK?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be499ff-04d7-4c3d-0cd8-08dacd490f84
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 11:51:31.9993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqwjjFxan5BnIfTqYUyerbQTJEfwf2hX5CkTtb3/nF+vE0thpV3iGrDfALXsxBrbhgNOSDAe48gzhjucJfTfCXNpM4PH42YBBD3GQB80jWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6320
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 22, 2022 at 05:30:58PM +0800, Herbert Xu wrote:
> The value of reqsize must only be changed through the helper.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
