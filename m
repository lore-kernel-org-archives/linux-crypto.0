Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A7FC32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3DD22073D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbfHBEzx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 00:55:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48682 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbfHBEzx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 00:55:53 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htPbb-0006Iw-8i; Fri, 02 Aug 2019 14:55:51 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htPbZ-0004kT-Bp; Fri, 02 Aug 2019 14:55:49 +1000
Date:   Fri, 2 Aug 2019 14:55:49 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: Remove redundant #ifdef in crypto_yield()
Message-ID: <20190802045549.GH18077@gondor.apana.org.au>
References: <alpine.DEB.2.21.1907262217130.1791@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1907262217130.1791@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 26, 2019 at 10:19:07PM +0200, Thomas Gleixner wrote:
> While looking at CONFIG_PREEMPT dependencies treewide the #ifdef in
> crypto_yield() matched.
> 
> CONFIG_PREEMPT and CONFIG_PREEMPT_VOLUNTARY are mutually exclusive so the
> extra !CONFIG_PREEMPT conditional is redundant.
> 
> cond_resched() has only an effect when CONFIG_PREEMPT_VOLUNTARY is set,
> otherwise it's a stub which the compiler optimizes out.
> 
> Remove the whole conditional.
> 
> No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-crypto@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  include/crypto/algapi.h |    2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
