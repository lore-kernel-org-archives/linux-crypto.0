From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AEAD x86 assembler crash
Date: Mon, 1 Jun 2015 17:15:51 +0800
Message-ID: <20150601091551.GA12387@gondor.apana.org.au>
References: <5734608.jOsyQWs821@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51605 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbbFAJa1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:30:27 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YzM36-0001b9-1r
	for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2015 19:30:24 +1000
Content-Disposition: inline
In-Reply-To: <5734608.jOsyQWs821@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 11:12:45AM +0200, Stephan Mueller wrote:
> 
> another crash with all of the latest patches and using gcm_base(ctr(aes-
> asm),ghash-generic) using the standard AEAD interface and performing 
> encryption.

Can you send me the patch of libkcapi against
b1e885f64f7b7f6cbc34faa1617158090c6123df?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
