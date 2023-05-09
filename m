Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799F7C77B75
	for <linux-crypto@archiver.kernel.org>; Tue,  9 May 2023 02:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjEICTn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 May 2023 22:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjEICTj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 May 2023 22:19:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8D293FC;
        Mon,  8 May 2023 19:19:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pwCw9-006hZA-3R; Tue, 09 May 2023 10:18:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 May 2023 10:18:46 +0800
Date:   Tue, 9 May 2023 10:18:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tejun Heo <tj@kernel.org>
Cc:     jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shijith Thotton <sthotton@marvell.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 11/13] crypto: octeontx2: Use alloc_ordered_workqueue()
 to create ordered workqueues
Message-ID: <ZFmthqP+hpTZM2X3@gondor.apana.org.au>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-12-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509015032.3768622-12-tj@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 08, 2023 at 03:50:30PM -1000, Tejun Heo wrote:
> BACKGROUND
> ==========
> 
> When multiple work items are queued to a workqueue, their execution order
> doesn't match the queueing order. They may get executed in any order and
> simultaneously. When fully serialized execution - one by one in the queueing
> order - is needed, an ordered workqueue should be used which can be created
> with alloc_ordered_workqueue().
> 
> However, alloc_ordered_workqueue() was a later addition. Before it, an
> ordered workqueue could be obtained by creating an UNBOUND workqueue with
> @max_active==1. This originally was an implementation side-effect which was
> broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active==1 to be
> ordered"). Because there were users that depended on the ordered execution,
> 5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
> made workqueue allocation path to implicitly promote UNBOUND workqueues w/
> @max_active==1 to ordered workqueues.
> 
> While this has worked okay, overloading the UNBOUND allocation interface
> this way creates other issues. It's difficult to tell whether a given
> workqueue actually needs to be ordered and users that legitimately want a
> min concurrency level wq unexpectedly gets an ordered one instead. With
> planned UNBOUND workqueue updates to improve execution locality and more
> prevalence of chiplet designs which can benefit from such improvements, this
> isn't a state we wanna be in forever.
> 
> This patch series audits all callsites that create an UNBOUND workqueue w/
> @max_active==1 and converts them to alloc_ordered_workqueue() as necessary.
> 
> WHAT TO LOOK FOR
> ================
> 
> The conversions are from
> 
>   alloc_workqueue(WQ_UNBOUND | flags, 1, args..)
> 
> to
> 
>   alloc_ordered_workqueue(flags, args...)
> 
> which don't cause any functional changes. If you know that fully ordered
> execution is not ncessary, please let me know. I'll drop the conversion and
> instead add a comment noting the fact to reduce confusion while conversion
> is in progress.
> 
> If you aren't fully sure, it's completely fine to let the conversion
> through. The behavior will stay exactly the same and we can always
> reconsider later.
> 
> As there are follow-up workqueue core changes, I'd really appreciate if the
> patch can be routed through the workqueue tree w/ your acks. Thanks.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Boris Brezillon <bbrezillon@kernel.org>
> Cc: Arnaud Ebalard <arno@natisbad.org>
> Cc: Srujana Challa <schalla@marvell.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Shijith Thotton <sthotton@marvell.com>
> Cc: Vladis Dronov <vdronov@redhat.com>
> Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Cc: Alexander Lobakin <alobakin@pm.me>
> Cc: Minghao Chi <chi.minghao@zte.com.cn>
> Cc: ye xingchen <ye.xingchen@zte.com.cn>
> Cc: linux-crypto@vger.kernel.org
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 12 ++++++------
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |  6 +++---
>  2 files changed, 9 insertions(+), 9 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
