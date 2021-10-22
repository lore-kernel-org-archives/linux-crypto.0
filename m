Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FD3C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 12:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD576108D
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 12:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhJVMjI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Oct 2021 08:39:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56244 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhJVMjD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Oct 2021 08:39:03 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mdtmr-00032l-Eq; Fri, 22 Oct 2021 20:36:41 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mdtmq-0001p1-D1; Fri, 22 Oct 2021 20:36:40 +0800
Date:   Fri, 22 Oct 2021 20:36:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt - fix skcipher multi-buffer tests for
 1420B blocks
Message-ID: <20211022123640.GC6920@gondor.apana.org.au>
References: <20211015073918.4837-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211015073918.4837-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 15, 2021 at 10:39:18AM +0300, Horia Geantă wrote:
> Commit ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
> mentions:
> > power-of-2 block size. So let's add 1420 bytes explicitly, and round
> > it up to the next blocksize multiple of the algo in question if it
> > does not support 1420 byte blocks.
> but misses updating skcipher multi-buffer tests.
> 
> Fix this by using the proper (rounded) input size.
> 
> Fixes: ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  crypto/tcrypt.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
