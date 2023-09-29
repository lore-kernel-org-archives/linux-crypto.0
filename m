Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A063AE71D33
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Sep 2023 21:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjI2VFG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Sep 2023 17:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2VFF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2023 17:05:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F5B1AE
        for <linux-crypto@vger.kernel.org>; Fri, 29 Sep 2023 14:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696021503; x=1727557503;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EgUHj1kM3xdZfD04UPP70mO4qx4o0KMxIdhsH3By9uY=;
  b=W+2VeWTD8qFnEj0P7vZG5cs017G4QBIWHTWl/S4Ze+QilcX9SOpVq9id
   S/S3q3qO9vQAp/Ej/wSF4BPiCGZT8ug8Qn12PCQXRwZa0Hp6gnFKZ/VXE
   W0tkuWZQSd+LM4SNNtexLyAw18QJNirhEHaJshL3Rzorv1C8VZeNuqO4+
   FQRqRGk0e0IQ5ygzBK5Mx4i6Rf5ert1BreqFNmN54U4zcyRlPx0adW/GS
   m5JqE4KKsvvTJHpmEeU4OkUh+WZF/E1QemkITGT7hm2SDp4gjxYGhgwvG
   LWmJdBwEA+FWj1oUO+mu6XjrYtmMFUug9RA/4uNl5cJxyoOVdIiR5qL79
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="448870637"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="448870637"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 14:04:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="840414243"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="840414243"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Sep 2023 14:04:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 29 Sep 2023 14:04:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 29 Sep 2023 14:04:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 29 Sep 2023 14:04:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeVlLPhSaEyBvL0yrO54+qpsJzs5xRhCqX0eLT2TPYXexUWZjkSKp0IH+jTcFWtBAOOZWFMfY7Rt+lU+yBWpIKR5M0ydgXsvBdcEQJkPO/qiAlflrlACHAeXLXFDatLV5mwbktRysE0JL6V+wVMs9aDlMCRJj/flfoO9IfIMxSthuoBvLArXAhXv+reSM5SOYmEESyeX5vK1pVDoncUwoXcchEDKekqtRv5ZbfJMAzj80OvJRP6puSl2hv41ZKCFy56Lu5dyK6nXvVk7Kdo4hlVPJDv7BTyQhW8bliLIEajPmk9DqH4L+fT6k4q/fAk4WxnWYy1VkKFcKeRMr5vTdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uuDEiV5IJaZfNkMzyVh6oDqPrRSwlH/SK3UobMegr8=;
 b=meriY6cIE9JMF8IG+7ZCv8Zf8n62aUuegJzPeH1I6XH6yyJsov/mGLrWdk20Vh/MAZQ9w50F2asrT9wNv/lc5anqcEEaM9eErGDVFevSnHicX9dxmMAC9awPq+M04AcnlUlKbH3W2KtNtodVdwRgtLrLXlNXbhuQ6ez+P8vn8GspwkK0CTYKNZt6y9fDNyzQUzmF107Dc0mZqLIXZt5LvTUxjurY/AB3tOkM7ln/mCdNfBSjF+ZbLSAr67qfG/ZO9LnONoQgdOaT5ld0++mAZhJKtpteOYem2Y7Jf6yyEouNYHbh8oJHiQ7Ozk8ydZcQ0M8BCnJ0DdbPi11LeThx4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS0PR11MB7829.namprd11.prod.outlook.com (2603:10b6:8:f1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Fri, 29 Sep
 2023 21:04:48 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4c02:d735:4942:ad0c]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4c02:d735:4942:ad0c%4]) with mapi id 15.20.6813.017; Fri, 29 Sep 2023
 21:04:48 +0000
Date:   Fri, 29 Sep 2023 22:04:37 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Hrivnak <mhrivnak@redhat.com>,
        Eric Garver <egarver@redhat.com>, <qat-linux@intel.com>,
        <linux-crypto@vger.kernel.org>, <dm-devel@redhat.com>
Subject: Re: [PATCH v2] qat: fix deadlock in backlog processing
Message-ID: <ZRc75XGd92MgaVko@gcabiddu-mobl1.ger.corp.intel.com>
References: <af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com>
 <ZQ2vJNs/7ZzY44z1@gcabiddu-mobl1.ger.corp.intel.com>
 <ed935382-98ee-6f5d-2f-7c6badfd3abb@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ed935382-98ee-6f5d-2f-7c6badfd3abb@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0091.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::26) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS0PR11MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 1621498c-138b-4bf3-7acd-08dbc12fb71e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qofyzz8k5NRxX4Q/B4CA4A28Ixea2JQ83yqAkLEa2L1LZCMXSX+bCTaW7OzkKIFEEjfVjIyRkp/UvI0VGwRWjWQkgBgsTahK0u4D5LB7k4NV5WhKJMcrJyvMPKjMhEa9KiohZpBrKB8exG7tWYJCV+SGGBkhzjviGGMEn3r8hKSLgJUrCnFH6cZlsCEDSARAnWMVWp4lltb12VMTdX5TfaBqWZCzxgANDbygnO+kLdhPutMXWig7dYlFjByrZ6lyQrwy5uWndlFKSr8Hca/xFTF9Ztgy0qH1z4zd71dNHfgoD62Tx6XVTXiOxqf4aOGa7TcYM6yDz8EXZpXKESvpDhL/p50iFN1SfGuLGb1PTAglNghq5uiEdSyUPTVu+7TTldOcMkliE3EXR/ylBaH7KtFJh9Nd2NxmzH14I6VGB5ddsnp41DZQM8vGhzhyPbScY1LoJnfiCbJlE2CS8C5jed8Dxq1wuRgjVUZJOeGaLcZd3q/lrEu3oVwK/iSqoVL5foWJT53/9qCxaXrUzPRi/A4gM7G4xQXx1PGqWlWxmAk3klkmFTbpF15TxKwTqbXB28pzarsa5dgZtsxPlUp71g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(366004)(376002)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(84970400001)(966005)(6666004)(478600001)(83380400001)(26005)(82960400001)(6512007)(6486002)(36916002)(6506007)(2906002)(86362001)(5660300002)(44832011)(8936002)(4326008)(8676002)(316002)(38100700002)(66556008)(66476007)(66946007)(6916009)(41300700001)(54906003)(30864003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?moqf7ubP0qyiI6BhrMeLpuVUaeP+saFN7IzgdIp1FB4l4VqjQIsZwHvNqspG?=
 =?us-ascii?Q?F+J8tYGZxhNHz0RMNauxfol8ejITw1v1VnX5azD8duV13vOlsh7KU/hAC7fL?=
 =?us-ascii?Q?CO8lH6RnUN2sD1rmiTOgHMcdj9z5agUVNGE50wM+VD9t9X6xhJ/wTByQXCQz?=
 =?us-ascii?Q?/o77r6ia3SJ7fkGNcaq3qCsVT6f32ySVcodx5+SzyLlDiFZiqwVwR1yMZQzY?=
 =?us-ascii?Q?m90R6EU9e76Gnzdm1Y4bSKDflzDdpAVto2mPm+O9tdWFSYvkgZHfVBDe0A9K?=
 =?us-ascii?Q?dWVk1+DLZ5HaEMbbyRA6ojNscNcm05URbKZClOQRbKwH+5P8phrSl3es6RP0?=
 =?us-ascii?Q?INJtLXc4DWf3mojjgsqISQzF4P4ALLnx0jcXbKWAza7v9RxpIt+dvVRs8hLX?=
 =?us-ascii?Q?o6vSxMl3Knv2sOSlQVs61s3vRftmooEo7ICuwPwxVYpCD8j7VC5TnoFjhd18?=
 =?us-ascii?Q?eve7gfauecyUSUSpvAxgMGmxj3E+b1+RRv7rE6hd68Am0NxbznYiEcAEyc50?=
 =?us-ascii?Q?cfAmFVa0LsdEJcqxhY4xv6ZXxIgBLO9glZFadGfQ9EMRxYVOz+I0aC/Qs3CT?=
 =?us-ascii?Q?qrcnQUdsGLumlnPxdVx25V2rso/Zc4QmGcs58HKYdk5N9cdTIMLfREJN4JtV?=
 =?us-ascii?Q?oMEpA6XqjeZ1iB3r1fIkDtggO1wvbQrtu8W6e90PH3b0nGsJHV1RxUOOEXn3?=
 =?us-ascii?Q?K/w4ZbVZlI56shQrNK2oAcKymUd8anLU/z+q81W5RSW3WsUJHbWZFa047EHe?=
 =?us-ascii?Q?JINt8NiwyCfWShakCzCU55Dw72T68GGRTHMXQGNm6E209OkkEOW/FpqO83Ih?=
 =?us-ascii?Q?2pDk1GrA93AakkZYIxSWPIHDdqaJe6lItmoW5ZXePM6sqZM88CsBoqsNmYTN?=
 =?us-ascii?Q?vxfFfbtEfq9WSqN3ZnvOo8Mo+Pgp79f/GtmzjCkbC3NUkct5c/yI96GH45L/?=
 =?us-ascii?Q?O4f4G/vxwhUVQLgVZMmt+BqTubroRX7XyCUGUkteIgtWzYfLUZMmyOWayjaL?=
 =?us-ascii?Q?51KfvsZrOJxrS7tzOJUVxP9N/o1SzuNxXxlrn8vP69guFJlBvqd54EBEcNMB?=
 =?us-ascii?Q?OSZE/G4B8c9LCAEQe1Z0OwCli1AHFrTBMyerN+8h2EZHBnKxOUbXZn5yoWH4?=
 =?us-ascii?Q?gaB8DJ0+uyvbvNlmfM4n3CODtDzw191jHjnjXEKG5exyleUm4fJE+2wycwqN?=
 =?us-ascii?Q?0Cog3CeQkP8reFn+KOJGuP193OY+fC7rmrO87Um+B+tt3EjzFqhsV5+k1gOo?=
 =?us-ascii?Q?gtNKozBcU5oN/e+FIV/vFRpc0kaey2+nTF71O5bJHmwvWxoNuvflC1MrKgG7?=
 =?us-ascii?Q?oj92e7gIG7y/KYwTjVJ8e/BpdkxgSpXTBhyZwhRDNE6rr0Bc8oh26VKL2BX0?=
 =?us-ascii?Q?03bGGfsSHeWhc0pAnkKTvz7Ar4GE+S9uaUv2tHnIe5shoeMzqAObFsLziRIh?=
 =?us-ascii?Q?P5b5ccG6rViROtJIwFgMlg0f/u+auHr286vA4eHc6Civ2TmS1EloA8htmiVX?=
 =?us-ascii?Q?JxyRlNQLfGP97kztP4KVZxcOF10FCl3tZ+wsTiMfI4Bv9EyHUp/FRaW75Whm?=
 =?us-ascii?Q?HCRvbeilMnPY19JyWKIn7p+Hd5ZIc1uV9/trnT96MIp9bP0SVItheSp/Jovi?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1621498c-138b-4bf3-7acd-08dbc12fb71e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 21:04:48.5161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeXSHnhuM2Ydjd04yAAW3XrpqBc5otshDTtdyG7nSMBnWWK48U9NlT2K4UeSWvniYTwUQYcFFp3rlUCH4hc67Xe07ATdkeMQ/fxQE7Qc7/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7829
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 22, 2023 at 06:34:16PM +0200, Mikulas Patocka wrote:
> On Fri, 22 Sep 2023, Giovanni Cabiddu wrote:
> > Hi Mikulas,
> > 
> > many thanks for reporting this issue and finding a solution.
> > 
> > On Thu, Sep 21, 2023 at 10:53:55PM +0200, Mikulas Patocka wrote:
> > > I was evaluating whether it is feasible to use QAT with dm-crypt (the 
> > > answer is that it is not - QAT is slower than AES-NI for this type of 
> > > workload; QAT starts to be benefical for encryption requests longer than 
> > > 64k).
> > Correct. Is there anything that we can do to batch requests in a single
> > call?
> 
> Ask Herbert Xu. I think it would complicate the design of crypto API.
> 
> > Sometime ago there was some work done to build a geniv template cipher
> > and optimize dm-crypt to encrypt larger block sizes in a single call,
> > see [1][2]. Don't know if that work was completed.
> >
> > >And I got some deadlocks.
> > Ouch!
> > 
> > > The reason for the deadlocks is this: suppose that one of the "if"
> > > conditions in "qat_alg_send_message_maybacklog" is true and we jump to the
> > > "enqueue" label. At this point, an interrupt comes in and clears all
> > > pending messages. Now, the interrupt returns, we grab backlog->lock, add
> > > the message to the backlog, drop backlog->lock - and there is no one to
> > > remove the backlogged message out of the list and submit it.
> > Makes sense. In my testing I wasn't able to reproduce this condition.
> 
> I reproduced it with this:
> Use a system with two Intel(R) Xeon(R) Gold 5420+ processors
> Use a kernel 6.6-rc2
> Patch the kernel, so that dm-crypt uses QAT - that is, in 
> 	drivers/md/dm-crypt.c, replace all strings 
> 	"CRYPTO_ALG_ALLOCATES_MEMORY" with "0"
> Use .config from RHEL-9.4 beta and compile the kernel
> On the system, disable hyperthreading with
> 	"echo off >/sys/devices/system/cpu/smt/control"
> Activate dm-crypt on the top of nvme:
> 	"cryptsetup create cr /dev/nvme3n1 --sector-size=4096"
> Run fio in a loop:
> 	"while true; do
> 		fio --ioengine=psync --iodepth=1 --rw=randwrite --direct=1 
> 		--end_fsync=1 --bs=64k --numjobs=56 --time_based 
> 		--runtime=10 --group_reporting --name=job 
> 		--filename=/dev/mapper/cr
> 	done"
> 
> With this setup, I get a deadlock in a few iterations of fio.
> 
> > > I fixed it with this patch - with this patch, the test passes and there
> > > are no longer any deadlocks. I didn't want to add a spinlock to the hot
> > > path, so I take it only if some of the condition suggests that queuing may
> > > be required.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: stable@vger.kernel.org
> > The commit message requires a bit of rework to describe the change.
> 
> I improved the message and I send a second version of the patch.
> 
> > Also, deserves a fixes tag.
> 
> "Fixes" tag is for something that worked and that was broken in some 
> previous commit.
That's right.

> A quick search through git shows that QAT backlogging was 
> broken since the introduction of QAT.
The driver was moved from drivers/crypto/qat to drivers/crypto/intel/qat
that's why you see a single patch.
This fixes 386823839732 ("crypto: qat - add backlog mechanism")

> 
> > > 
> > > ---
> > >  drivers/crypto/intel/qat/qat_common/qat_algs_send.c |   31 ++++++++++++--------
> > >  1 file changed, 20 insertions(+), 11 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > > +++ linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> > > @@ -40,16 +40,6 @@ void qat_alg_send_backlog(struct qat_ins
> > >  	spin_unlock_bh(&backlog->lock);
> > >  }
> > >  
> > > -static void qat_alg_backlog_req(struct qat_alg_req *req,
> > > -				struct qat_instance_backlog *backlog)
> > > -{
> > > -	INIT_LIST_HEAD(&req->list);
> > Is the initialization of an element no longer needed?
> 
> It was never needed. list_add_tail calls __list_add and __list_add 
> overwrites new->next and new->prev without reading them. So, there's no 
> need to initialize them.
> 
> > > -
> > > -	spin_lock_bh(&backlog->lock);
> > > -	list_add_tail(&req->list, &backlog->list);
> > > -	spin_unlock_bh(&backlog->lock);
> > > -}
> > > -
> > >  static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> > >  {
> > >  	struct qat_instance_backlog *backlog = req->backlog;
> > > @@ -71,8 +61,27 @@ static int qat_alg_send_message_maybackl
> > >  	return -EINPROGRESS;
> > >  
> > >  enqueue:
> > > -	qat_alg_backlog_req(req, backlog);
> > > +	spin_lock_bh(&backlog->lock);
> > > +
> > > +	/* If any request is already backlogged, then add to backlog list */
> > > +	if (!list_empty(&backlog->list))
> > > +		goto enqueue2;
> > >  
> > > +	/* If ring is nearly full, then add to backlog list */
> > > +	if (adf_ring_nearly_full(tx_ring))
> > > +		goto enqueue2;
> > > +
> > > +	/* If adding request to HW ring fails, then add to backlog list */
> > > +	if (adf_send_message(tx_ring, fw_req))
> > > +		goto enqueue2;
> > In a nutshell, you are re-doing the same steps taking the backlog lock.
> > 
> > It should be possible to re-write it so that there is a function that
> > attempts enqueuing and if it fails, then the same is called again taking
> > the lock.
> > If you want I can rework it and resubmit.
> 
> Yes, if you prefer it this way, I reworked the patch so that we execute 
> the same code with or without the spinlock held.
> 
> > > +
> > > +	spin_unlock_bh(&backlog->lock);
> > > +	return -EINPROGRESS;
> > > +
> > > +enqueue2:
> > > +	list_add_tail(&req->list, &backlog->list);
> > > +
> > > +	spin_unlock_bh(&backlog->lock);
> > >  	return -EBUSY;
> > >  }
> > 
> > [1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1276510.html
> > [2] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1428293.html
> > 
> > Regards,
> > 
> > -- 
> > Giovanni
> > 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [PATCH] qat: fix deadlock in backlog processing
crypto: qat - fix ...
> 
> I was testing QAT with dm-crypt and I got some deadlocks.
> 
> The reason for the deadlocks is this: suppose that one of the "if"
> conditions in "qat_alg_send_message_maybacklog" is true and we jump to the
> "enqueue" label. At this point, an interrupt comes in and clears all
> pending messages. Now, the interrupt returns, we grab backlog->lock, add
> the message to the backlog, drop backlog->lock - and there is no one to
> remove the backlogged message out of the list and submit it.
> 
> In order to fix the bug, we must hold the spinlock backlog->lock when we 
> perform test for free space in the ring - so that the test for free space 
> and adding the request to a backlog is atomic and can't be interrupted by 
> an interrupt. Every completion interrupt calls qat_alg_send_backlog which 
> grabs backlog->lock, so holding this spinlock is sufficient to synchronize 
> with interrupts.
> 
> I didn't want to add a spinlock unconditionally to the hot path for 
> performance reasons, so I take it only if some of the condition suggests 
> that queuing may be required.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/crypto/intel/qat/qat_common/qat_algs_send.c |   23 ++++++++++----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> ===================================================================
> --- linux-2.6.orig/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> +++ linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> @@ -40,22 +40,14 @@ void qat_alg_send_backlog(struct qat_ins
>  	spin_unlock_bh(&backlog->lock);
>  }
>  
> -static void qat_alg_backlog_req(struct qat_alg_req *req,
> -				struct qat_instance_backlog *backlog)
> -{
> -	INIT_LIST_HEAD(&req->list);
> -
> -	spin_lock_bh(&backlog->lock);
> -	list_add_tail(&req->list, &backlog->list);
> -	spin_unlock_bh(&backlog->lock);
> -}
> -
>  static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
>  {
>  	struct qat_instance_backlog *backlog = req->backlog;
>  	struct adf_etr_ring_data *tx_ring = req->tx_ring;
>  	u32 *fw_req = req->fw_req;
> +	bool locked = false;
>  
> +repeat:
>  	/* If any request is already backlogged, then add to backlog list */
>  	if (!list_empty(&backlog->list))
>  		goto enqueue;
> @@ -68,11 +60,20 @@ static int qat_alg_send_message_maybackl
>  	if (adf_send_message(tx_ring, fw_req))
>  		goto enqueue;
>  
> +	if (unlikely(locked))
> +		spin_unlock_bh(&backlog->lock);
>  	return -EINPROGRESS;
>  
>  enqueue:
> -	qat_alg_backlog_req(req, backlog);
> +	if (!locked) {
> +		spin_lock_bh(&backlog->lock);
> +		locked = true;
> +		goto repeat;
> +	}
> +
> +	list_add_tail(&req->list, &backlog->list);
>  
> +	spin_unlock_bh(&backlog->lock);
>  	return -EBUSY;
>  }
>  
> 
Thanks - when I proposed the rework I was thinking at a solution without
gotos. Here is a draft:
------------8<----------------
 .../intel/qat/qat_common/qat_algs_send.c      | 40 ++++++++++---------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
index bb80455b3e81..18c6a233ab96 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
@@ -40,17 +40,7 @@ void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
 	spin_unlock_bh(&backlog->lock);
 }
 
-static void qat_alg_backlog_req(struct qat_alg_req *req,
-				struct qat_instance_backlog *backlog)
-{
-	INIT_LIST_HEAD(&req->list);
-
-	spin_lock_bh(&backlog->lock);
-	list_add_tail(&req->list, &backlog->list);
-	spin_unlock_bh(&backlog->lock);
-}
-
-static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+static bool qat_alg_try_enqueue(struct qat_alg_req *req)
 {
 	struct qat_instance_backlog *backlog = req->backlog;
 	struct adf_etr_ring_data *tx_ring = req->tx_ring;
@@ -58,22 +48,36 @@ static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
 
 	/* If any request is already backlogged, then add to backlog list */
 	if (!list_empty(&backlog->list))
-		goto enqueue;
+		return false;
 
 	/* If ring is nearly full, then add to backlog list */
 	if (adf_ring_nearly_full(tx_ring))
-		goto enqueue;
+		return false;
 
 	/* If adding request to HW ring fails, then add to backlog list */
 	if (adf_send_message(tx_ring, fw_req))
-		goto enqueue;
+		return false;
 
-	return -EINPROGRESS;
+	return true;
+}
 
-enqueue:
-	qat_alg_backlog_req(req, backlog);
 
-	return -EBUSY;
+static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+{
+	struct qat_instance_backlog *backlog = req->backlog;
+	int ret = -EINPROGRESS;
+
+	if (qat_alg_try_enqueue(req))
+		return ret;
+
+	spin_lock_bh(&backlog->lock);
+	if (!qat_alg_try_enqueue(req)) {
+		list_add_tail(&req->list, &backlog->list);
+		ret = -EBUSY;
+	}
+	spin_unlock_bh(&backlog->lock);
+
+	return ret;
 }
 
 int qat_alg_send_message(struct qat_alg_req *req)
-- 
2.41.0


