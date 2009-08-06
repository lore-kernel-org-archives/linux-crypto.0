From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Thu, 6 Aug 2009 10:38:05 +0200
Message-ID: <20090806083805.GA9736@Chamillionaire.breakpoint.cc>
References: <87zlaf3zl0.wl@obsidian.enotty.net> <4A7984A7.40109@redhat.com> <20090805203017.GA5875@Chamillionaire.breakpoint.cc> <4A7A8A73.706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Milan Broz <mbroz@redhat.com>,
	Stelios Bounanos <sb-lst@enotty.net>, dm-crypt@saout.de,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47534 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZHFIiZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2009 04:38:25 -0400
Content-Disposition: inline
In-Reply-To: <4A7A8A73.706@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Milan Broz | 2009-08-06 09:46:59 [+0200]:

>yes, I understand why this happens. I do not want to use stream cipher,
>but apparently users will do that:-)
So once they discover that they have salsa20 in kernel they see another
problem.

>My question was why crypto allows this setting?
Well, WLAN is afaik the only user and they use it that way. So it
is okay as long as you now what you do :)

>Or maybe what to do in dm-crypt to not allow user set such cipher
>mapping (because it cannot produce anything useful).
You could encrypt one block twice and compare the result. This sounds
like a dirty hack.

>IMHO it will not work even in ECB mode here for dm-crypt.
You could make it work but it is not worth it.

>> CBC will not work because one of its requirements is that the cipher
>> provides an inverse function which ARC4 simply does not have.
>
>Again, why crypto API allows to use it and do not produce error then?
WLAN folks are the only user of arc4 afaik and they probably hacked it
quick together. Since stream cipher don't provide an inverse function it
is an abuse of the API because encrypt/decrypt don't do what one would
expect.

Herbert, any concern to inroduce 
 #define CRYPTO_ALG_TYPE_STREAM_CIPHER      0x00000007
and split block cipher from stream cipher?
So no one would mix them up since dm-crypt for instance will look just
for block ciphers. Unless you prefer that the user knows what he is
doing :)

>Milan

Sebastian
