From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Thu, 6 Aug 2009 19:19:36 +1000
Message-ID: <20090806091935.GA26162@gondor.apana.org.au>
References: <87zlaf3zl0.wl@obsidian.enotty.net> <4A7984A7.40109@redhat.com> <20090805203017.GA5875@Chamillionaire.breakpoint.cc> <4A7A8A73.706@redhat.com> <20090806083805.GA9736@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>,
	Stelios Bounanos <sb-lst@enotty.net>, dm-crypt@saout.de,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45144 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751249AbZHFJUF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2009 05:20:05 -0400
Content-Disposition: inline
In-Reply-To: <20090806083805.GA9736@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 06, 2009 at 10:38:05AM +0200, Sebastian Andrzej Siewior wrote:
>
> Herbert, any concern to inroduce 
>  #define CRYPTO_ALG_TYPE_STREAM_CIPHER      0x00000007
> and split block cipher from stream cipher?
> So no one would mix them up since dm-crypt for instance will look just
> for block ciphers. Unless you prefer that the user knows what he is
> doing :)

Stream ciphers should all have block size 1 so you can just check
on that.

In any case, I agree that we should make it extremely difficult
for users to select an insecure configuration.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
