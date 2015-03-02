From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Mon, 2 Mar 2015 15:25:56 +0200
Message-ID: <54F464E4.8080204@freescale.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Martin Hicks <mort@bork.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0133.outbound.protection.outlook.com ([65.55.169.133]:42834
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750824AbbCBN0J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2015 08:26:09 -0500
In-Reply-To: <1424451610-5786-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/20/2015 7:00 PM, Martin Hicks wrote:
> This adds the AES-XTS mode, supported by the Freescale SEC 3.3.2.
> 
> One of the nice things about this hardware is that it knows how to deal
> with encrypt/decrypt requests that are larger than sector size, but that 
> also requires that that the sector size be passed into the crypto engine
> as an XTS cipher context parameter.
> 
> When a request is larger than the sector size the sector number is
> incremented by the talitos engine and the tweak key is re-calculated
> for the new sector.
> 
> I've tested this with 256bit and 512bit keys (tweak and data keys of 128bit
> and 256bit) to ensure interoperability with the software AES-XTS
> implementation.  All testing was done using dm-crypt/LUKS with
> aes-xts-plain64.
> 
> Is there a better solution that just hard coding the sector size to
> (1<<SECTOR_SHIFT)?  Maybe dm-crypt should be modified to pass the
> sector size along with the plain/plain64 IV to an XTS algorithm?

AFAICT, SW implementation of xts mode in kernel (crypto/xts.c) is not
aware of a sector size ("data unit size" in IEEE P1619 terminology):
There's a hidden assumption that all the data send to xts in one request
belongs to a single sector. Even more, it's supposed that the first
16-byte block in the request is "block 0" in the sector. These can be
seen from the way the tweak ("T") value is computed.
(Side note: there's no support of ciphertext stealing in crypto/xts.c -
i.e. sector sizes must be a multiple of underlying block cipher size -
that is 16B.)

If dm-crypt would be modified to pass sector size somehow, all in-kernel
xts implementations would have to be made aware of the change.
I have nothing against this, but let's see what crypto maintainers have
to say...

BTW, there were some discussions back in 2013 wrt. being able to
configure / increase sector size, smth. crypto engines would benefit from:
http://www.saout.de/pipermail/dm-crypt/2013-January/003125.html
(experimental patch)
http://www.saout.de/pipermail/dm-crypt/2013-March/003202.html

The experimental patch sends sector size as the req->nbytes - hidden
assumption: data size sent in an xts crypto request equals a sector.

I am not sure if there was a follow-up though...
Adding Milan - maybe he could shed some light.

Thanks,
Horia

> 
> Martin Hicks (2):
>   crypto: talitos: Clean ups and comment fixes for ablkcipher commands
>   crypto: talitos: Add AES-XTS Support
> 
>  drivers/crypto/talitos.c |   45 +++++++++++++++++++++++++++++++++++++--------
>  drivers/crypto/talitos.h |    1 +
>  2 files changed, 38 insertions(+), 8 deletions(-)
> 
