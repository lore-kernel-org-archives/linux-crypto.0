Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C7FC433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 04:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBF1206F6
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 04:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgHDEEy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 00:04:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54606 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgHDEEy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 00:04:54 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k2oBY-0007a8-9k; Tue, 04 Aug 2020 14:04:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Aug 2020 14:04:20 +1000
Date:   Tue, 4 Aug 2020 14:04:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Liwei Song <liwei.song@windriver.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, David <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - zero the cmd data after use it
Message-ID: <20200804040420.GA10850@gondor.apana.org.au>
References: <20200803075858.3561-1-liwei.song@windriver.com>
 <20200803125242.GA7689@gondor.apana.org.au>
 <87ae939b-4983-4e96-cc3d-1aa1d1b3d3ae@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ae939b-4983-4e96-cc3d-1aa1d1b3d3ae@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 04, 2020 at 11:51:47AM +0800, Liwei Song wrote:
> 
> On 8/3/20 20:52, Herbert Xu wrote:
> > On Mon, Aug 03, 2020 at 03:58:58PM +0800, Liwei Song wrote:
> >> exist the following assignment in ccp(ignore the force
> >> convert of the struct) by list_del in ccp_dequeue_cmd():
> >> req->__ctx->cmd->entry->next = LIST_POISON1;
> >>
> >> after use the req, kzfree(req) can not zero the entry
> >> entry->next = LIST_POISON1 of the ccp_cmd(cmd) struct
> >> when this address available as slub freelist pointer, this will cause
> >> the following "general protection fault" error if some process meet
> >> this LIST_POISON1 value address when request memory:
> > 
> > Your description makes no sense.  Please rewrite it and explain
> > the problem properly.
> 
> The problem here is that the entry of struct ccp_cmd is not zeroed after we use it,
> If the other process got this address by kmalloc(), this illegal value "LIST_POISON1"
> will cause "general protection fault" error.

If that's the case surely the other process should be zeroing
the memory? Your explanation still makes no sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
