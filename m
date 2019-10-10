Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9281DC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 736DA2067B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbfJJMzG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 08:55:06 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37628 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfJJMzG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 08:55:06 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iIXy1-0001sr-Jt; Thu, 10 Oct 2019 23:54:54 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2019 23:54:51 +1100
Date:   Thu, 10 Oct 2019 23:54:51 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: inside-secure - Fix a maybe-uninitialized
 warning
Message-ID: <20191010125451.GD31566@gondor.apana.org.au>
References: <20190930121520.1388317-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930121520.1388317-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 02:14:33PM +0200, Arnd Bergmann wrote:
> A previous fixup avoided an unused variable warning but replaced
> it with a slightly scarier warning:
> 
> drivers/crypto/inside-secure/safexcel.c:1100:6: error: variable 'irq' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> 
> This is harmless as it is impossible to get into this case, but
> the compiler has no way of knowing that. Add an explicit error
> handling case to make it obvious to both compilers and humans
> reading the source.
> 
> Fixes: 212ef6f29e5b ("crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
