From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chacha20_4block_xor_ssse3: Align stack pointer
 to 64 bytes
Date: Mon, 25 Jan 2016 21:59:46 +0800
Message-ID: <20160125135946.GD8256@gondor.apana.org.au>
References: <1453393448-13636-1-git-send-email-elicooper@gmx.com>
 <1453449324.36963.7.camel@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eli Cooper <elicooper@gmx.com>, linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54492 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbcAYN7y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 08:59:54 -0500
Content-Disposition: inline
In-Reply-To: <1453449324.36963.7.camel@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 22, 2016 at 08:55:24AM +0100, Martin Willi wrote:
> Hi Eli,
> 
> > This aligns the stack pointer in chacha20_4block_xor_ssse3 to 64 bytes.
> > Fixes general protection faults and potential kernel panics.
> 
> I assumed 16-byte alignment according to the System V AMD64 ABI, but
> this is obviously not true with -mpreferred-stack-boundary=3. The AVX2
> version seems to be ok, so is Poly1305.
> 
> Acked-by: Martin Willi <martin@strongswan.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
