From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Mon, 15 Nov 2010 19:58:42 +0800
Message-ID: <20101115115842.GA4007@gondor.apana.org.au>
References: <1289810592.30446.410.camel@vespa.frost.loc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: drosenberg@vsecurity.com, linux-crypto@vger.kernel.org
To: Tomas Mraz <tmraz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33645 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0KOL6s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 06:58:48 -0500
Content-Disposition: inline
In-Reply-To: <1289810592.30446.410.camel@vespa.frost.loc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tomas Mraz <tmraz@redhat.com> wrote:
>
> This would not be a 'hashing' algorithm but a simple block encryption
> algorithm in the ECB mode with the random key initialized at boot. The
> problem here is that the standard block ciphers have at least 64 bit
> block length as smaller block length ciphers would not be secure for
> general purpose uses. You would have to take an existing block cipher
> algorithm and modify it to achieve the smaller block length.

If block sizes are a problem then we have stream ciphers too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
