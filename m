From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Timing leaks in certain HW-crypto drivers
Date: Mon, 16 Nov 2015 21:38:24 +0800
Message-ID: <20151116133824.GA30580@gondor.apana.org.au>
References: <1447604082-1883-1-git-send-email-david@sigma-star.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Gstir <david@sigma-star.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33068 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbbKPNi2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Nov 2015 08:38:28 -0500
Content-Disposition: inline
In-Reply-To: <1447604082-1883-1-git-send-email-david@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 15, 2015 at 05:14:40PM +0100, David Gstir wrote:
> [resend to linux-crypto]
> 
> Hi,
> 
> the following patches fix timing leaks which are introduced by using
> (non-constant time) memcmp() to verify cryptograhic authentication tags.
> Specifically, the AES-GCM and AES-CCM implementations in the IBM Power
> in-Nest Crypto acceleration driver and the AEAD decryption function in the
> Freescale SEC (talitos) driver are vulnerable to this kind of attack.
> These timing leaks can be used by an attacker to find the correct
> authentication tag value for arbitrary messages with far less effort
> than brute-force testing all 2^n possible values for a n-bit tag.
> 
> The fix is rather simple: Use crypto_memneq() as the generic implementations
> in crypto/* already do.

Both patches applied.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
