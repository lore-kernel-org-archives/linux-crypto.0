From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: improve gcc optimization flags for serpent and
 wp512
Date: Sat, 11 Feb 2017 18:54:55 +0800
Message-ID: <20170211105455.GG855@gondor.apana.org.au>
References: <20170203223334.3888507-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        kernel-build-reports@lists.linaro.org,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750778AbdBKS56 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 13:57:58 -0500
Content-Disposition: inline
In-Reply-To: <20170203223334.3888507-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 03, 2017 at 11:33:23PM +0100, Arnd Bergmann wrote:
> An ancient gcc bug (first reported in 2003) has apparently resurfaced
> on MIPS, where kernelci.org reports an overly large stack frame in the
> whirlpool hash algorithm:
> 
> crypto/wp512.c:987:1: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
