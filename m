From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hmac(sha1)
Date: Tue, 9 Mar 2010 11:08:52 +0800
Message-ID: <20100309030852.GA8153@gondor.apana.org.au>
References: <4B912E8C.4010009@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53863 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756634Ab0CIDI4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Mar 2010 22:08:56 -0500
Content-Disposition: inline
In-Reply-To: <4B912E8C.4010009@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos <dimitris@siganos.org> wrote:
>
> I am using linux 2.6.28, and in that version, the crc32 implementation 
> is of type AHASH. According to git, crc32 was converted to SHASH on 25 
> Dec 2008. I am basing my AHASH implementation on the crc32 AHASH.

Unless you're implementing a software async driver, I don't think
crc32c is going to be of that much help.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
