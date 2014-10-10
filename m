From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/2] crypto: caam - add support for gcm(aes)
Date: Fri, 10 Oct 2014 09:36:15 -0500
Message-ID: <20141010093615.6b8c6aee3b6842603fdd6982@freescale.com>
References: <1412866450-22587-1-git-send-email-tudor.ambarus@freescale.com>
	<20141009194317.3e0f2a73a15c540cc901c9f5@freescale.com>
	<95347feb4cb6441ea07456ce0b7610be@CY1PR0301MB0713.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Ambarus Tudor-Dan-B38632 <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:52832
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755121AbaJJOzi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2014 10:55:38 -0400
In-Reply-To: <95347feb4cb6441ea07456ce0b7610be@CY1PR0301MB0713.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 10 Oct 2014 03:47:18 -0500
Ambarus Tudor-Dan-B38632 <tudor.ambarus@freescale.com> wrote:

> On Thu, 9 Oct 2014 17:54:09 +0300
> Tudor Ambarus <tudor.ambarus@freescale.com> wrote:
> > +	/* Galois Counter Mode */
> > +	{
> > +		.name = "gcm(aes)",
> > +		.driver_name = "gcm-aes-caam",
> > +		.blocksize = 1,
> > +		.type = CRYPTO_ALG_TYPE_AEAD,
> > +		.template_aead = {
> > +			.setkey = gcm_setkey,
> > +			.setauthsize = gcm_setauthsize,
> > +			.encrypt = aead_encrypt,
> > +			.decrypt = aead_decrypt,
> > +			.givencrypt = NULL,
> > +			.geniv = "<built-in>",
> > +			.ivsize = 12,
> > +			.maxauthsize = 16,
> 
> AES_BLOCK_SIZE
> [TA] I think we shall not change the blocksize value to AES_BLOCK_SIZE.
> GCM uses a block cipher as a stream cipher. It generates encryption blocks, which are then XORed with the plaintext blocks to get the ciphertext. Just as with other stream ciphers, flipping a bit in the ciphertext produces a flipped bit in the plaintext at the same location.
> 

Sorry, I meant just .maxauthsize = AES_BLOCK_SIZE.

Kim
