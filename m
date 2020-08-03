Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4D9C433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 12:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02DD20678
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 12:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgHCMxg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:53:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52316 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgHCMxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 08:53:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k2ZxL-0006Zw-4H; Mon, 03 Aug 2020 22:52:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Aug 2020 22:52:43 +1000
Date:   Mon, 3 Aug 2020 22:52:43 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Liwei Song <liwei.song@windriver.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, David <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - zero the cmd data after use it
Message-ID: <20200803125242.GA7689@gondor.apana.org.au>
References: <20200803075858.3561-1-liwei.song@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803075858.3561-1-liwei.song@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 03, 2020 at 03:58:58PM +0800, Liwei Song wrote:
> exist the following assignment in ccp(ignore the force
> convert of the struct) by list_del in ccp_dequeue_cmd():
> req->__ctx->cmd->entry->next = LIST_POISON1;
> 
> after use the req, kzfree(req) can not zero the entry
> entry->next = LIST_POISON1 of the ccp_cmd(cmd) struct
> when this address available as slub freelist pointer, this will cause
> the following "general protection fault" error if some process meet
> this LIST_POISON1 value address when request memory:

Your description makes no sense.  Please rewrite it and explain
the problem properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
