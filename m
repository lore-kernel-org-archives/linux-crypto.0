Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2473AEB64D7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 15:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjFTPKP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 11:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbjFTPKO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 11:10:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98021C0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 08:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687273813; x=1718809813;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j08z8zVwrhAFO7ed1IYfjNkOWIePRBoEFVYD/zy3vwQ=;
  b=d2M78aCjha8HtGw7rmHozJuCmE8jMWUZVOIkyWf3isRpyTr1e/DEs/dH
   vufvbTeBl0HnCAvx+HAeJ8pSjiJK7xBho8g4ksolm0T/8sTr0SbFFkaKI
   8ZcKF4ZCHvpcLGLKcUTgdxDS+oRRNydz+UyVvL+x/dT9r78m/CqQTzMYb
   q6Z8ude8o9aQbeAS9rM+dicLQRCMMkkdKYLUsbkXUxNwS1CcjgtrQS+ja
   2rEYhwq47J93OaSsZR7bWbNa/nYP316K0W2HYXRADtlY5L9/0juRFMR84
   szLVmuVGwtgP435tfdvtcIwO+k/JVPyD1zseL94M/IobfXvq2S+QWc/6b
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="359892657"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="359892657"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 08:10:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="803999179"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="803999179"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2023 08:10:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 08:10:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 08:10:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 08:09:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxD1dtAgJMoKZLUFT1rcJLH7VOyBSWK50C6NR6d1OlVYlomoQU8HP+oPAhfYhc25fKMv4Qys4c+j6rvIKJUdr8loomnqy1CZRYQ/M4AyqEGxXZ2oPfPjXeM6PcNN1uiv4mV4fNNO8SF7zjROBrGIHTXDb8uvsqfQq3p7CHn0UlnO4ted2uoe8LZTZtUNu8RadAU6vxtxEIkruK7EectZgjJtTffjpYrMpuARszIPpOsluO+AlrEIczK3PacYHOIaZsnTZYL+wtxcfkdqe+attoCYMSPzLQBNiLpuIeTjnlf7vN7npS/bu5SPJwMCa7HJvgIHcsGyfiR5f7xn+lZUIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IltJCkiUpV9tyqtSXVT9KFlrlbpNEpklb+GBZXRTq7I=;
 b=KMJkpB3BYo+5iTZm1WNqH3c5/pICLQgx8VlkcUgfFUGgzILFZlgBq4RzZkvMHkUZZ0YJHWZq6I/xVOpbuvZ5uOuPc0WhLbnWHlmJGx/WyCmHs8IukA+cbRuTZf9GA+D122HwRxSlhiC+ZhEp2lMtNa8wKAz8gV8lYJDHrXj/RPXsWdJYVc9Ii4uktZcHlhLHSbb6RApFOXdwACwYfb+AaJcEXQW+oIvvhr3C6z0mGPf2gBOXKsQ6bLNCCEw81xptd5oUt6gmSIXHxEr7H2+PIFNZoc+rjbTb3Kybbf2tPFo05v4j+mMLc3kSgLOZ0HiMVPN4m2zz2BUQkXMIVjmcfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6459.namprd11.prod.outlook.com (2603:10b6:208:3be::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 15:09:52 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::13c9:30fe:b45f:6bcb]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::13c9:30fe:b45f:6bcb%4]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 15:09:52 +0000
Date:   Tue, 20 Jun 2023 17:09:39 +0200
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - add internal timer for qat 4xxx
Message-ID: <ZJHBM1RZb3eXv/UO@dmuszyns-mobl.ger.corp.intel.com>
References: <20230601091340.12626-1-damian.muszynski@intel.com>
 <ZILrxDmxkHyIZ1Sw@gondor.apana.org.au>
 <ZIMVSDWXOcS6/Whg@dmuszyns-mobl.ger.corp.intel.com>
 <ZIxUIjwZMHrZiDg6@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIxUIjwZMHrZiDg6@gondor.apana.org.au>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
X-ClientProxiedBy: FR2P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::6) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|BL3PR11MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: af335740-5668-4a34-f8fc-08db71a06599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Id4hQKOT2y+7DyVoaPlK6WxxvPMHsayuwMGk5EXwS3QqipKU/8aO0vqtHt/VMW10fhLrWDblMULRGLexFRl+Hruuvc5XJV09m7bXfRlnpQ01/6wlcsM8AMxM9QmAGXb1CqLuVwAW8epWo8FLiX8BkkTFaG5+JhIQoddejEzY0eyCRL97MzdlORpzJmQgyOVf5DuEtFE1DPgXS5AbFY+CaBPSTRP/SFhCLzWgSOsACq1txHKAUD+xAAYgw3FnvdiOX02XFZBXrOTk1sG4zQkfCJUDsZ+pFDATMOIHjUVPBMZDoPBMlVNxbfvJBxjQ18aThYQfjxp6iVUpeCT+xSVdLdAsYbwn7SQllihUx18Sd3lifNZMUqCr3B24dzUTFTKCruIJXOQ70O/z9TeIoOhVlRBBSYv5aVJojJbKc3dihD9ND8psL72w3R7CV3/N64w1Ru5tenLVhBnjpfE/CB1Gmg6OOwiQoGi7whlI0c1vMAGc2QbRH21CieohOkQ+SL91l5EZFf9QHVkdi6MGG4m2ZP0E8gZ6fB+BqwrYc7+9Ba2IuTW2hWff2c2Qf15Zw5g9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(36916002)(6486002)(6666004)(478600001)(186003)(107886003)(6512007)(6506007)(26005)(53546011)(38100700002)(86362001)(82960400001)(8936002)(8676002)(5660300002)(316002)(4326008)(4744005)(2906002)(6916009)(66476007)(66556008)(66946007)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IXFeFo7L3yOj9ybwMLY2+gWRwVGwVINFIaq3rLA/NSS7jrNNMy8ykMaKaf1F?=
 =?us-ascii?Q?VEsQwx87o9DSRvwbU3tzY7WBwHLTVmNmGfEAQF/m0Bw6XsXYlT9IGpD42lqz?=
 =?us-ascii?Q?pAzA3retxLuMvfWCZ9ZJDSJTN+YqOzgF/tRfc+eSOU5GCe+xwR/+HxpJj+09?=
 =?us-ascii?Q?/vgjG+Qhu5tMgCu29HQtsqIfoo2stze4lU1slgnb5ZdiEKuPtuWkq4Jt9idw?=
 =?us-ascii?Q?JVJ2A9K+ibGYk/dg26UlCtCf2vFZw6Pqz7D6/AYfaquyOYN5COCUj4/fbhTv?=
 =?us-ascii?Q?TZg5h3fDFRca3gqIXGzvPPGXbVhLssA04AgvWBvmwko/KYRonMN673qyDnYn?=
 =?us-ascii?Q?2T5uylZ6DnnJnY+8UkukuW2Xzuh+OdfZ/UYIGtlfLCsRWjrDQhRypa0LTxqc?=
 =?us-ascii?Q?Lr9BP4HrYs05sncFNUcjpWiUmW3/u5qzz4OIXkY6mRiMTRwOA1Idl2QSGGuf?=
 =?us-ascii?Q?qDRvh/xcFkxg6MKXXxNL7Nrdak0X0CO2h+fu1jEvNVYfVA0LgTbf7i4bMF7n?=
 =?us-ascii?Q?oxQqI/QlydBRYhYFEWs3Nd+rp43P5MyLXP2nneP2YSUgXH32QP322e6lxqWS?=
 =?us-ascii?Q?/OZl9iDo92TLFiiQS9UhCNvuNwHkB2/k7Xz1lByirVWaH46H9M3BoFeABM8c?=
 =?us-ascii?Q?TAtTsQgVaQHWojhXyFPeIE5yyZE3z1e7oxMjt7AgUw9LCnB8Ad/PdVlaKX9l?=
 =?us-ascii?Q?z7AJkP405RLmafXTF0S9x2LIfVdWji2BoFf4mjE9mhVcJwKWKtlsNPMG7fVu?=
 =?us-ascii?Q?77vjil9IBvOfPUyD7N7EnxQ2zhDIm0xWST0qQf7SQKPQmbgZZWyIqf3NsBFk?=
 =?us-ascii?Q?07CFnMcphw02YPp8wMhYBTYl6p0E8FHXot5lZzg7yYyTPAl0Mrh3OrSDelk2?=
 =?us-ascii?Q?xqAIQqIQpsiZzzizQVTQ7ma4T+AjLxdgvg0fh6mQEkq2PyL6+3DeAlHxBDXe?=
 =?us-ascii?Q?MhpwzHVUAOloBoMcKfVj8u3pVHAYBRgDe6uHTwC9ZaukItC5tc08LgM6HxBz?=
 =?us-ascii?Q?maol2NxMGKhhyts6rX9Iz1PCRcJM7KEpZySwQiL6+tOlmOAX16YdX12GPDrA?=
 =?us-ascii?Q?SI/+ZHhiKRZhCjybShomc7yObkQiHDixrPBStocXfQA3kTv5kmvm86Z+de19?=
 =?us-ascii?Q?c7zdO8+KaimbC9d73LTXNbBR7TI1deG3p8usnf9o8oXPjkQNBQPdmv30qXeE?=
 =?us-ascii?Q?C7HsOdb26UzS1Ffc2nAhXwSv0AJxAtHUMUD0hgPtQaodEIGpY22MR1z+vHpb?=
 =?us-ascii?Q?eBl4JNbOF3CILd6EJGLMifca4eB9Ij3nnE9ctdPghOKjN5U2AodmdnmWu8Jr?=
 =?us-ascii?Q?i/pRKvWr4H9cBr1WceZflqIbuTyc1n6nlU2gvPdFQpV8EXYskQjuHfg4SGZI?=
 =?us-ascii?Q?gcwVHCa+HDG9twC44swJ1DUN15oIXlcXMpTzPzdNw5mXLXzS1XJYkkMqI3nD?=
 =?us-ascii?Q?D/s+10GN4j0mrx4jmbgKvphD96KLVsrJx7vZBpWjYz1jbNT55qYyoKZQdfWn?=
 =?us-ascii?Q?5D1CDLYjxkxm773H4n4i75vmI6KUfLnFI2CAKeCxhi/duWquyru4C1gM1eOZ?=
 =?us-ascii?Q?fydErltIjwleXsGvPIs/Us+TIgavn+1QF6HlkgpP2QVBmtTE15EiBN0Hluvs?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af335740-5668-4a34-f8fc-08db71a06599
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 15:09:52.0370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CHQ+FKKpZNxy/ssonkEVUfeqHQPBnXYQSMyCL95FuBuGPOKkfdau0QrC+P43OcmEE+DNNgxJ5fqtcXDmHUMGKOdI/aQiL9xovoO3IzSQ+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6459
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023-06-16 at 20:22:58 +0800, Herbert Xu wrote:
> On Fri, Jun 09, 2023 at 02:04:24PM +0200, Damian Muszynski wrote:
> >
> > We considered the usage of delayed work when implementing this, but it will 
> > break functionality. Apart from scheduling the work queue, timer_handler() is 
> > incrementing a counter which keeps track of how many times the timer was scheduled.
> 
> Please be more specific.  I don't understand why the counter can't
> be incremented in the delayed work instead of the timer.
> 

We found a solution with which we can be sure about accuracy and replace 
the timer with delayed work as you suggested. An reworked patch is included 
with a new version of the heartbeat patchset as the feature development is now 
finished and this patch is a prerequisite for it. 

Best Regards,
Damian Muszynski
