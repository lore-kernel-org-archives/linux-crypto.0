From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 3/4] crypto: akcipher: add akcipher declarations
 useful for templates.
Date: Wed, 25 Nov 2015 09:18:20 +0800
Message-ID: <20151125011820.GB5907@gondor.apana.org.au>
References: <1447989215-523-3-git-send-email-andrew.zaborowski@intel.com>
 <20151124095408.GA315@gondor.apana.org.au>
 <CAOq732LT4JoBzHv3Jd=ZXzWkU+LMc1Zmqv4WvM4K4X5LRps3ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58872 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbbKYBS0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Nov 2015 20:18:26 -0500
Content-Disposition: inline
In-Reply-To: <CAOq732LT4JoBzHv3Jd=ZXzWkU+LMc1Zmqv4WvM4K4X5LRps3ow@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 24, 2015 at 09:54:57PM +0100, Andrzej Zaborowski wrote:
>
> It doesn't need to export crypto_aead_type but instead needs to export
> crypto_aead_grab and aead_register_instance.  I'll add those for
> akcipher and resend then.  Would there be any point defining a
> crypto_akcipher_spawn following the AEAD pattern?

Well if you need to spawn an akcipher (which I presume you do) then
yes you should define it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
