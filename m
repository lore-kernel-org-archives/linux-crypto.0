Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3F7C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 711B82064A
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbfJJMlT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 08:41:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37584 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733191AbfJJMlS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 08:41:18 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iIXkX-0001OD-Jc; Thu, 10 Oct 2019 23:40:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2019 23:40:51 +1100
Date:   Thu, 10 Oct 2019 23:40:51 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
Message-ID: <20191010124051.GA30370@gondor.apana.org.au>
References: <20190930121520.1388317-1-arnd@arndb.de>
 <20190930121520.1388317-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930121520.1388317-2-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 02:14:34PM +0200, Arnd Bergmann wrote:
> safexcel_aead_setkey() contains three large stack variables, totalling
> slightly more than the 1024 byte warning limit:
> 
> drivers/crypto/inside-secure/safexcel_cipher.c:303:12: error: stack frame size of 1032 bytes in function 'safexcel_aead_setkey' [-Werror,-Wframe-larger-than=]
> 
> The function already contains a couple of dynamic allocations, so it is
> likely not performance critical and it can only be called in a context
> that allows sleeping, so the easiest workaround is to add change it
> to use dynamic allocations. Combining istate and ostate into a single
> variable simplifies the allocation at the cost of making it slightly
> less readable.
> 
> Alternatively, it should be possible to shrink these allocations
> as the extra buffers appear to be largely unnecessary, but doing
> this would be a much more invasive change.
> 
> Fixes: 0e17e3621a28 ("crypto: inside-secure - add support for authenc(hmac(sha*),rfc3686(ctr(aes))) suites")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../crypto/inside-secure/safexcel_cipher.c    | 53 ++++++++++++-------
>  1 file changed, 35 insertions(+), 18 deletions(-)

This patch doesn't apply against the current cryptodev tree.

Please respin it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
