Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5655DC43331
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3365C206DB
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgC0E4F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Mar 2020 00:56:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57092 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgC0E4F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Mar 2020 00:56:05 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jHh2I-0000FV-RU; Fri, 27 Mar 2020 15:56:03 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2020 15:56:02 +1100
Date:   Fri, 27 Mar 2020 15:56:02 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lothar Rubusch <l.rubusch@gmail.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: bool type cosmetics
Message-ID: <20200327045602.GD19912@gondor.apana.org.au>
References: <20200320113631.2470-1-l.rubusch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320113631.2470-1-l.rubusch@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 20, 2020 at 11:36:31AM +0000, Lothar Rubusch wrote:
> When working with bool values the true and false definitions should be used
> instead of 1 and 0.
> 
> Hopefully I fixed my mailer and apologize for that.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  crypto/af_alg.c     | 10 +++++-----
>  crypto/algif_hash.c |  6 +++---
>  2 files changed, 8 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
