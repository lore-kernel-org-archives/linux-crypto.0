From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_xor
Date: Tue, 7 Sep 2010 10:12:03 +0800
Message-ID: <20100907021203.GA2139@gondor.apana.org.au>
References: <4C7E6A4D.4010609@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54566 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0IGCML (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Sep 2010 22:12:11 -0400
Content-Disposition: inline
In-Reply-To: <4C7E6A4D.4010609@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:
> Hello,
> I was checking the crypto_xor() function and it is for some reason
> limited to 32 bit integers. Why not make it depend on the architecture
> by replacing the u32 with unsigned long? That way 64bit machines should
> perform xor with less instructions...

We could do that, but you'd also need to go through every user
to make sure that their alignment requirement is upgraded from
4 to sizeof(unsigned long).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
