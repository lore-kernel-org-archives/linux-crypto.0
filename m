Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3F2C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA54E208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfHIGTm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:19:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37440 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbfHIGTl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:19:41 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvyFK-0007Np-UA; Fri, 09 Aug 2019 16:19:27 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvyFH-0002qe-7g; Fri, 09 Aug 2019 16:19:23 +1000
Date:   Fri, 9 Aug 2019 16:19:23 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] crypto: Reduce default RT priority
Message-ID: <20190809061923.GM10392@gondor.apana.org.au>
References: <20190801111348.530242235@infradead.org>
 <20190801111541.800409062@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801111541.800409062@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 01, 2019 at 01:13:51PM +0200, Peter Zijlstra wrote:
> The crypto engine initializes its kworker thread to FIFO-99 (when
> requesting RT priority), reduce this to FIFO-50.
> 
> FIFO-99 is the very highest priority available to SCHED_FIFO and
> it not a suitable default; it would indicate the crypto work is the
> most important work on the machine.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  crypto/crypto_engine.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
