From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: crc32c-vpmsum - Convert to CPU feature based
 module autoloading
Date: Mon, 8 Aug 2016 23:22:09 +0800
Message-ID: <20160808152209.GA31540@gondor.apana.org.au>
References: <87y44biu7s.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: anton@samba.org, anton@ozlabs.org, benh@kernel.crashing.org,
	paulus@samba.org, davem@davemloft.net, alastair@d-silva.org,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36618 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbcHHPWm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 11:22:42 -0400
Content-Disposition: inline
In-Reply-To: <87y44biu7s.fsf@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> This is actually an arch/powerpc patch, so I'll merge it unless Herbert
> objects.

It's fine with me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
