Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37616 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKPQ3n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:29:43 -0500
Date: Fri, 16 Nov 2018 14:18:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Brajeswar Ghosh <brajeswar.linux@gmail.com>
Cc: davem@davemloft.net, linux@armlinux.org.uk, jrdr.linux@gmail.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sabyasachi.linux@gmail.com
Subject: Re: [PATCH] arm/crypto/aes-ce-glue.c: Remove duplicate header
Message-ID: <20181116061824.ztwvpgaa7renupz3@gondor.apana.org.au>
References: <20181106121614.GA1985@hp-pavilion-15-notebook-pc-brajeswar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106121614.GA1985@hp-pavilion-15-notebook-pc-brajeswar>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 06, 2018 at 05:46:14PM +0530, Brajeswar Ghosh wrote:
> Remove asm/hwcap.h which is included more than once
> 
> Signed-off-by: Brajeswar Ghosh <brajeswar.linux@gmail.com>
> ---
>  arch/arm/crypto/aes-ce-glue.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
