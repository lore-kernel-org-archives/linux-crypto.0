Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E06EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 13:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjFPNvX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 09:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjFPNvW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 09:51:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA512702
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jun 2023 06:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686923481; x=1718459481;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a1csoBFsIjNtx3Q1meAqK3lr+wpwV9M3yQPOHR8d/D4=;
  b=kHhi4pHA4KK1R3uAUB81YrckhxqlAHuQ+DIWDoIZXUUnXneDTmF3y0sS
   lhLtevs4HyJIuAq+XETmRchUAnb02DDeVCjFpgsHuwq4D0ogdyVQ2u+jb
   32dHKUPzGujPhytu6pHnbfUH2j8iTZzpzixkOHd00NCkTGADwlNN3v38a
   C0nR0qlfEwGGmtqe73sz+d47ZVGftbfi2qxIW6pOp3x90CdkmnYnvRvQp
   rDA0/TEJrZcKCF5DN5IDt/Uj1HQL5VmUDDOXbgWHZCxH0M4ValKfk41Iv
   VjpoVU5XCDjaoqIPlt5/pQH9ygP64SwRMfMW9LkIhB/244AXXP4KqX69D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="339546142"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="339546142"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 06:51:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="1043100453"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="1043100453"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jun 2023 06:51:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 06:51:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 06:51:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 06:51:19 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 06:51:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9GrCnzIptA53Qp0rF9t5O6wXs+iDI74x9Yz3LIpOMEapdSwNb/Jfy0rLz7gDkIS6T5LrVa4whMvwED8o+DGycaTtgf7vqocsTxVc1868PS+213K2oPzlk+h0wHWlddXpGTumzn+NISmrH0gqa/P7TH91UTqhntbh/tANxM+blIIfvJbAwp07e/a/In2nzwnMYOuySwbZrb5ENCwGUkEio8h0jnFLmKsbNs2h0RTyNtmI4/c2lS7yowfakQoAL2OMGhhkiEo/uI5tgNR6lOTTNpmnkSPx6ZBExWiHtKyrZS7fcrYHZrFPJqR41lfydTch9JSLs1sEzUh22wAIoAI+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNXTgN0QD4gdDjkns9+3Wn7zqF3CZqPMwmyv40boIsc=;
 b=M1Q5W67SsW4ymE+sYD8zyc7M0dwTa6mH2gvcHRy17DcIUCB1Po338i43yXh3yZr0nQGP5xinDKrxQTxuqn9qWNEXxoBltVU4KPtjl1JXSyjwhuhZaoA48nfAXz+Pm8cKEHKAMSy88lRKd6Zrk89FIEUuKcRg1rXPPcZijC2EiEwAmXKTP+EZs7I4u3SzxeCnDssOwca3P/Pe8z98tnFFwB5LluZssQqyzlXGY9HKq+1EKNCDivH/5971+INQJ9wWTv/0N4qTkVv0GfcyQws44qLF9NBul/f4k9xVCT445o+slyt/GwvKKI1D8enrplAXLGY2jxhj5WwJT+f4vMfgFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by SJ2PR11MB7473.namprd11.prod.outlook.com (2603:10b6:a03:4d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Fri, 16 Jun
 2023 13:51:16 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::21cb:3fb:a485:5481]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::21cb:3fb:a485:5481%7]) with mapi id 15.20.6455.030; Fri, 16 Jun 2023
 13:51:16 +0000
Date:   Fri, 16 Jun 2023 15:51:03 +0200
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - add internal timer for qat 4xxx
Message-ID: <ZIxox6SL8r8aNuH6@dmuszyns-mobl.ger.corp.intel.com>
References: <20230601091340.12626-1-damian.muszynski@intel.com>
 <ZILrxDmxkHyIZ1Sw@gondor.apana.org.au>
 <ZIMVSDWXOcS6/Whg@dmuszyns-mobl.ger.corp.intel.com>
 <ZIxUIjwZMHrZiDg6@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIxUIjwZMHrZiDg6@gondor.apana.org.au>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
X-ClientProxiedBy: LO4P265CA0230.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::6) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|SJ2PR11MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f848c21-20f7-4f8d-e637-08db6e70c132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yw/2ygIjoPt8fpH2flppIgbPkpWZqwJvNJc+HAZtb8ezAHEcxh9osK6B3dSYPaP8CPw67htUNi08ZatoZC0Q/BASdLnDhp9AU85uZRoS4t8BHemgEvoSpBaHHhqCN4Izd/Ixi5WWsvFcQ9dzla4KnJPpP89s6L2s579OMzR3TWkeUlDipAcAA8JUFCMcnAM3hqGvpKj0rJtTrbaBRsrrH5Uk0iGnMy1ZLJPMKFdEvTjPHn9nSIrC6SKKKGB91O1VqfEq2u22E6xszQEYhGp7yd0SENzama7xo9oWeTILCr7L9FSWPhbXesD6y0sUF4pS1H0i6QbiLBfqr7WZAtyk39kHVBMgsI9lIEUj8jmTL5YQcrnqcRq4xKdNesi/5LcjS9lY8pvn6zLQsgajtW7PQss8Cv30zoeelEVO40EQzDnjI8mF/63UPR7KaC4H/OY+5wOce8btKqw/5KdAkTYfF5pUAsnfUBeru6/ZjGNYH2d3ZFi7zyelUt/Y7VRa7s46AnojYP2du9zschtCMETR0v/9lLlVDXZMyj5Ekoj4Pzxco80OF2jfbZrSqUetkCA2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199021)(478600001)(66556008)(44832011)(4326008)(316002)(66946007)(38100700002)(66476007)(82960400001)(6512007)(6506007)(36916002)(107886003)(26005)(6666004)(41300700001)(6486002)(6916009)(53546011)(8676002)(2906002)(86362001)(5660300002)(4744005)(8936002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QX7yeQOBuV4Y5kFNrqg7Hwtv7fSB/NOYJhFwOM/fqWa7TA3VhjfjHn6zztOK?=
 =?us-ascii?Q?BbMEKt2Q6nH+qv2njwpZooQRCLmZ/83HqLHRZEfrRXFUsuZyzTDpcxHxEgr/?=
 =?us-ascii?Q?xI+BZ2KyBiVDUlqJllmFKEay23EjJlJmMZN30BLBF5mOnvIOXzK40ApB/szM?=
 =?us-ascii?Q?XhwNaa1a4CJAUzli1OsddY+NNSs67OLSpQ+/zFObDzFvbkfo5jRP2aAfQNZc?=
 =?us-ascii?Q?NzCSmbaCtz7Z3Dt6pohec00NZZv13dhjmkcN1z7e9TFPewP6EoKCvo8iZqtr?=
 =?us-ascii?Q?OXF8+nWuYPGGAmPMJWWI2Kx1OmobQrdLAnp+Nr2exs8AYmKo60hTliJn++z7?=
 =?us-ascii?Q?gUZEcYQwdHIWQlW1B4+9d2l6bKaMdFoKCCHc2cDDY8CZGhIXEB+kv3T9eQc+?=
 =?us-ascii?Q?nQUhxEUidP8ZtiWN3qsDHRzlsm454gGNbGzMk1oppe4eGmOsh8GbMyHSN2ul?=
 =?us-ascii?Q?OnIcsdCOGddsVJi8bSwIM54/25KlVrrtZBYozLNTrAu6uGpxlCQaEfSSBgUz?=
 =?us-ascii?Q?gnG5wZbYkY65vR7BnbXRAMKUJyf5Iifu0fDvMbfLCVgoNKxwCIgwIyk04aNl?=
 =?us-ascii?Q?MbfjsFeyfJFmUDnKoEhQ68bCSP5FVEXaumVQbwYMkPUp6NVAkyVAdmyvXF98?=
 =?us-ascii?Q?73WqrT+3W35odcFD+4s2lBFUpu6K3OAA3upV59338Imf0ZdiwYCRVCAZcsh1?=
 =?us-ascii?Q?pps+vNZn5BLCnipuoT5pxdJ3PXNysaBHphEs8Pso+faGTXw4ygo/pnvMvkXd?=
 =?us-ascii?Q?Aa9S4I7Nlx5BMw31kh4YWm4RzqKt9YOKHdlhgQAt1IlrX4wNfIZQTNnaEm9J?=
 =?us-ascii?Q?A3C6oYyRkKwAIIzngVx+iCOWmVVLPl2mXHQ53IP/E1sw5DD/vuyaUirAc2TP?=
 =?us-ascii?Q?+siZG5luQ8pMgZwWu4ihliRZAtsO9JjCgQ3pHl6howe7ELlfIyd5mVq0QTvF?=
 =?us-ascii?Q?RmlZ1v5CwoOsxCo/jJ4ISf8AmCWu7DS8001aC4PPQep8jC4ynnzJOnh8tHtP?=
 =?us-ascii?Q?AH8hbg1NjkvxUoxBWEyx4WRnr9ROJ2ToCNh/cAAenG0PFOTHdyhRHQLE2MfZ?=
 =?us-ascii?Q?IRH/xdHpfcL+SkN1io1nkvb3G0WKgv0ut87eLLFIauCA2I/bPEin/VqpG4pV?=
 =?us-ascii?Q?DbvxdZJEdiY5amoHRruN4XjJ5kUnPVrMmnctWNxGGJwdvAg7AGjzz0iE/Vd0?=
 =?us-ascii?Q?WH6H7BQS6O/kuQiDl4USdYm8/goW3DcMYH95tdBaAe0StVmdqgTWZtTmVOnf?=
 =?us-ascii?Q?CvSuLowRKUL4pdyof0SY+7l6aKsiDCnrumMvcjcI/qIZ+19Ug8Xm66nTwSAx?=
 =?us-ascii?Q?2KlHkvhmVoIg6/vFcuushbck2Mt9dXPpeEr6KAVztF5GMJ7Hq8Bf9VZkvyj9?=
 =?us-ascii?Q?KqpaGzc03v0rMbJKFu79IwjpzdZia+wQgyaUgiPVWBuUIEXPGaRJYImcQ7Ti?=
 =?us-ascii?Q?yeJKD9gj1tVO/+SW8s3ND+ZSD57NOQELABvWGA4O6rTRLPPHrO/2eGydLU8h?=
 =?us-ascii?Q?bHQwpm9iQfeBfzEuk9GeiLlotkOaLWuLbcaN7I9hENHd+7HvdLHNc2qDnpmu?=
 =?us-ascii?Q?aStjEFJf6uYuemaSNAIrovJ8P6FtRmvEMQ0K5NK3V/S8PSO53/FaDbsZUwfh?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f848c21-20f7-4f8d-e637-08db6e70c132
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:51:16.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3b9a2mKjS18ohdJufqJrYL53ulcBrt3HBsIeItwiiKIA4mC4WFHK865bP8roVgBrjTDHNQW9Eyq0MunDUldqc67VxG1IuiQtZV9XwNyzfoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7473
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

We have chosen the timer instead of delayed work because it gives us more 
accuracy in incrementing this counter. The value of this counter is used by 
firmware to track the time so it requires that.

---
Best Regards,
Damian Muszynski
