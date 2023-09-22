Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB92E6FE41
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Sep 2023 15:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjIVPOE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Sep 2023 11:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjIVPOD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2023 11:14:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E758196
        for <linux-crypto@vger.kernel.org>; Fri, 22 Sep 2023 08:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695395638; x=1726931638;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tHsEDCH8Rkbnrkz4qWBLnVVWQjaN3A0I96U7fHRtabA=;
  b=AxIEAVqrDflueRN3iFXzz331Tw4D5AXwZ/24eisaYq3bxX7meNqt+UaZ
   NxvymkUBQfnFS6UuSS283fa4HbgZL7IKK7pkxaY5pq/bRDpzDavfmpIPT
   h1tkeB++O+JBGesAexu0WqSsakKaEQpGwj+yVkn7jYBSK1tFpAUkMMa43
   YDWG0ueXiHra9CTwKTDpHA9DQIvWpsfqnxi/mj6zD7qg80hPoA2BIapBc
   +mz5yTECElJGBDasjfv10FR6Y79hFOFfLyvMZczHleX2wbV08DIJ1+yzp
   74aWNsayy1oSW01w8D/v0F4TIYeH/tK9hFXY/oP8avIp2FPw/Gnm/2fpE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="383601169"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="383601169"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 08:13:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="750873091"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="750873091"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Sep 2023 08:13:57 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 22 Sep 2023 08:13:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 22 Sep 2023 08:13:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 22 Sep 2023 08:13:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXEKojTn8wpLuUTac9N+Jclf2wuAygJQa2LsQiF1JDJ4H1ER6VSdD02X9yNDjvGUh2NAjkVj4qZaTVEm6lyY5rb9p8qmgpfl8077uBWA0TfO9zGFg9z/xalZ+NyhKEvqm+nDpeOxycZWm7lOr8A7dFLWpicHKvMcrp2LLKjGZx3jqysDQRxalQYcNCiSjLOq9r8MovUP0J+9pv6FDrWQ6kXBaaqvY0HnoNy+11txm5NCOB6Rxbr3DWoHPkmJwCwaRb4Qk3uuLEChMEUf7JE3TACRgNP/LwbfSjrJzq8NRhQxPoqnzlpoiERjqaXbV6YHIVLTnMVxEQXKUzgjQmR6tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71XKdsnqtCBP7do/c90R7k2U0RZaWTe+XPuXusDAQK8=;
 b=nu1+zjL8MnVQlmTpDKcO4HgD6N9z184jBC9LbG3HrffOyoRWGkrWKfLPvLUzwbXoS9G1aqSoX9/UHagfHe+xI+JQZVb/InCtkGpmjzG+A7JZRGebusLAo7AMYcEdw5Yra/x1geqO10feQX+0NJG3vVxMNZfG6HvPwK/vzaFumjOfOwqewZnujsCncpEoAlK7oiN5hyfz0IrLcMKA7bqpF3kpqQrToILPzY6z8t92EEYD/6JcSzxL7iMNfaFTUPQHmYOg/LEo+fSlUW4SomHBiAs7mXHYkPNo1q6AxDPQ5BDlxhPZtewwoi58QrTjTfjnGLnhpRlt/1mUl8Ueykgk6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY5PR11MB6282.namprd11.prod.outlook.com (2603:10b6:930:22::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.24; Fri, 22 Sep
 2023 15:13:53 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4c02:d735:4942:ad0c]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4c02:d735:4942:ad0c%4]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 15:13:53 +0000
Date:   Fri, 22 Sep 2023 16:13:40 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Hrivnak <mhrivnak@redhat.com>,
        Eric Garver <egarver@redhat.com>, <qat-linux@intel.com>,
        <linux-crypto@vger.kernel.org>, <dm-devel@redhat.com>
Subject: Re: [PATCH] qat: fix deadlock in backlog processing
Message-ID: <ZQ2vJNs/7ZzY44z1@gcabiddu-mobl1.ger.corp.intel.com>
References: <af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2P251CA0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::25) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CY5PR11MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c124889-06dc-47ea-9763-08dbbb7e8882
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJETZFPiMHpQM7tP1gKzyt3X8DcMbwJ8i2ogHcO2oL/DN+bgU2r1fRyA8BKhpX4soxBxOFaPUUuzFbQZ8APowiOz3N+GgCKIasfgWmEL+IHGMfN58eARegkyjpcOPS+6OV2R9kpIcHhDEKVoumFWoC1bFo0pzkUKQFb9+0ziFFqTtVipcVux47XktwBJ4l2aCIAabKzmyY+f1rwFVzJPFsvs92Zf1qb0quSjHInFBCYvHyOLb9pXhG/8DMNIE/YrdxZPR3tBA2Ler/4Dbchm1n83NXOZlNrBxKmXZW1Iocl7l8tq/7djvEo2ABCtBJ0ikHk9nkGdGgsri/DiiHIQ6jWOclXX1GV0pUOxbgO/41nGfPAinjOGt//R7vevXoq0E/3yveMEzX+o9sumhzZ4siSmII4jZ0ZLdVW+r9iy24v1w+K4dzt5xkRIUKl97PGmtQCdElzEtlOU5vivKXy9cSKvTClGo9dAFc0q6AkZxuFgGC92CSozfWDKKr+dIJJmfVHCnRnV59icVysopcGP6bj5waJvoQO+Bwgv3bNnoYySeEx331pi/tmMFLoLEPfGDSKiak1bD6NKS4mTr9Eg6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199024)(186009)(1800799009)(966005)(6486002)(86362001)(5660300002)(44832011)(36916002)(6506007)(38100700002)(66476007)(66556008)(6512007)(54906003)(41300700001)(66946007)(6666004)(478600001)(316002)(84970400001)(6916009)(8936002)(82960400001)(8676002)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kdv7ou9WzeFoQbPoy3Ov5PA8VrAkIBjHNiLhlaz3zYy9gt/fWmOCij+cQ8bB?=
 =?us-ascii?Q?gEtIWca180e9nowvjfVcWmvc5nYTYSwIr2+/kP035DQqGQGMBdwC1K9uSavW?=
 =?us-ascii?Q?TqXPj19YBKG1ETn44b15ZBbHQE0IqgmGwgeR1kcQRck2m1WBfCOkvNH5Rb6+?=
 =?us-ascii?Q?q6zJ1rU6iTQRLC53S4q40j6XxuqNMnOCS31+YGra6OnskXa1DvSKhP/YHF8T?=
 =?us-ascii?Q?66sMm9+7nRLDjQ6oJapNEl6cxXshNGTg6ItdKDw5n/2IIbYZfoeCK/LY/GrV?=
 =?us-ascii?Q?+5kIiJnb5//onf23Wo7sLQ2R657ZgAGyTtv46cUAJA6TfGdwjE/mty7rBnVM?=
 =?us-ascii?Q?Rn/mIo9Kh5oBxoeQLgHlH/Shguv+mn26MOfggRt4LTWcaro08aYT6yXHsoQy?=
 =?us-ascii?Q?Fe8PvSPMoGMV6gJASIN7h8STpjAhtYDd9dxBXchMaPdt0ke5ARGPsKdUz/cY?=
 =?us-ascii?Q?Lo5IFD1XfqscjaC32w2/3gcxA+Z70rcFc9fYF0QnwO7cOZhiT8y6MDSmbMze?=
 =?us-ascii?Q?qI0R5pZq8GWx47cw/81SggMGzSnbCfRYRGXppNE1EmEgVcKWCKCTU9sRpmRs?=
 =?us-ascii?Q?hELqW80Y+0wCJpt8mT6YnfCINmQerk7K2thfxp5lHNZNVa35erEien122JWQ?=
 =?us-ascii?Q?OmXUlh/+RatuQrKKhhhHp/ZobvIJnXDcuvLyBhUrwbLCipuf0d9ISJfcAVvJ?=
 =?us-ascii?Q?239fJnhVZXWhOrkXiKuTKpMAE4Es+zpsGYmrE7M+04kjh9yztXdTJeJm6OPJ?=
 =?us-ascii?Q?/JKumxu8DHb6TI+/mVDRSAORO+YtE/HrCxMyyVciSmGfODwBxxpmbpC9FMLZ?=
 =?us-ascii?Q?jNpAwL/kXBlLEDlWI4lTAtxUMveOSN8BqkxyvjRFpQevj4t6DTRTPetreMB1?=
 =?us-ascii?Q?RDqsz5erxvZWfqyB1cRYedxpw/kS+eWLjvNw80w6emdNo4eOUZflnsNY/J8+?=
 =?us-ascii?Q?pJIeZ0IlaxNkucw3xHfYPlBVvxGgfM4BimYDSTOqI0KXGAw6D3qJbqoWTP30?=
 =?us-ascii?Q?PA3gt626f/HBYrliEUvgaiwpGPUekYnc5TfoF+I8QpJHG++EaPUjV1/k93R6?=
 =?us-ascii?Q?9RNDdACVs7exLLS5x8ysybj88NN0Meo2V1tiCNmolPz0YcE/T9APRQJMD4k/?=
 =?us-ascii?Q?z15vYxWQt7b2rIQiM71GeWSafjF0lORAA/yvdR0rc2Q6PFHW173UakxnfNgM?=
 =?us-ascii?Q?J5RHjK2YKDxGIjdnk4aLHS1W0O8wnN5cjUx25zPSgmYyaxIM33WcIfOD4qbj?=
 =?us-ascii?Q?0zFvCDJvg+VZP84+SHEQIL/VJxrhmxxvhv4altwPDarjMOfSozPz97FSRVoY?=
 =?us-ascii?Q?qq0p2575UxX90jr+vI+eKmQCwbhX1wviwhiBq23I1EsJhhV0Ajz/T7LaF0Cz?=
 =?us-ascii?Q?ADJP+1FTRBHKV5Wos9Oj8wBK1GIdfRQ2ZDdVtUukJVPY5y+/fY17E0rwOPWp?=
 =?us-ascii?Q?qou69GbqZShJ/L+X5kJv5+OtjslW7eYS3bKw4aryUAMP/1FvM4JN3HJIB9rA?=
 =?us-ascii?Q?SLQ5zPIc+OSmBYLmeelS58xtU0t8A/JP2pppxnUwENfJ6ZJr/f1Z3NPByso0?=
 =?us-ascii?Q?AnJT8c77vmVCqBiofb5oy1DjyqORrN/tHwtsyiNjYJd2QVgNO+UloSiDS3Gs?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c124889-06dc-47ea-9763-08dbbb7e8882
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 15:13:53.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyTw61UEIyyDowd/LNbwgI1kKAn61dOH+TKeAF/+rVmz9/UdMXtMmGog6rpjN3iz0xLNmHh7jjmCr/6fMo/m878XGfXnmWYC5knG2jGxoP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6282
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mikulas,

many thanks for reporting this issue and finding a solution.

On Thu, Sep 21, 2023 at 10:53:55PM +0200, Mikulas Patocka wrote:
> I was evaluating whether it is feasible to use QAT with dm-crypt (the 
> answer is that it is not - QAT is slower than AES-NI for this type of 
> workload; QAT starts to be benefical for encryption requests longer than 
> 64k).
Correct. Is there anything that we can do to batch requests in a single
call?

Sometime ago there was some work done to build a geniv template cipher
and optimize dm-crypt to encrypt larger block sizes in a single call,
see [1][2]. Don't know if that work was completed.

>And I got some deadlocks.
Ouch!

> The reason for the deadlocks is this: suppose that one of the "if"
> conditions in "qat_alg_send_message_maybacklog" is true and we jump to the
> "enqueue" label. At this point, an interrupt comes in and clears all
> pending messages. Now, the interrupt returns, we grab backlog->lock, add
> the message to the backlog, drop backlog->lock - and there is no one to
> remove the backlogged message out of the list and submit it.
Makes sense. In my testing I wasn't able to reproduce this condition.

> I fixed it with this patch - with this patch, the test passes and there
> are no longer any deadlocks. I didn't want to add a spinlock to the hot
> path, so I take it only if some of the condition suggests that queuing may
> be required.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
The commit message requires a bit of rework to describe the change.
Also, deserves a fixes tag.

> 
> ---
>  drivers/crypto/intel/qat/qat_common/qat_algs_send.c |   31 ++++++++++++--------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> ===================================================================
> --- linux-2.6.orig/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> +++ linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> @@ -40,16 +40,6 @@ void qat_alg_send_backlog(struct qat_ins
>  	spin_unlock_bh(&backlog->lock);
>  }
>  
> -static void qat_alg_backlog_req(struct qat_alg_req *req,
> -				struct qat_instance_backlog *backlog)
> -{
> -	INIT_LIST_HEAD(&req->list);
Is the initialization of an element no longer needed?

> -
> -	spin_lock_bh(&backlog->lock);
> -	list_add_tail(&req->list, &backlog->list);
> -	spin_unlock_bh(&backlog->lock);
> -}
> -
>  static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
>  {
>  	struct qat_instance_backlog *backlog = req->backlog;
> @@ -71,8 +61,27 @@ static int qat_alg_send_message_maybackl
>  	return -EINPROGRESS;
>  
>  enqueue:
> -	qat_alg_backlog_req(req, backlog);
> +	spin_lock_bh(&backlog->lock);
> +
> +	/* If any request is already backlogged, then add to backlog list */
> +	if (!list_empty(&backlog->list))
> +		goto enqueue2;
>  
> +	/* If ring is nearly full, then add to backlog list */
> +	if (adf_ring_nearly_full(tx_ring))
> +		goto enqueue2;
> +
> +	/* If adding request to HW ring fails, then add to backlog list */
> +	if (adf_send_message(tx_ring, fw_req))
> +		goto enqueue2;
In a nutshell, you are re-doing the same steps taking the backlog lock.

It should be possible to re-write it so that there is a function that
attempts enqueuing and if it fails, then the same is called again taking
the lock.
If you want I can rework it and resubmit.

> +
> +	spin_unlock_bh(&backlog->lock);
> +	return -EINPROGRESS;
> +
> +enqueue2:
> +	list_add_tail(&req->list, &backlog->list);
> +
> +	spin_unlock_bh(&backlog->lock);
>  	return -EBUSY;
>  }

[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1276510.html
[2] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1428293.html

Regards,

-- 
Giovanni
