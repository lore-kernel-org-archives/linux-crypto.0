From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AEAD x86 assembler crash
Date: Mon, 01 Jun 2015 11:48:54 +0200
Message-ID: <4731884.YtTi9ZUAcQ@tachyon.chronox.de>
References: <5734608.jOsyQWs821@tachyon.chronox.de> <20150601091551.GA12387@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58401 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbbFAJs5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:48:57 -0400
In-Reply-To: <20150601091551.GA12387@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 1. Juni 2015, 17:15:51 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jun 01, 2015 at 11:12:45AM +0200, Stephan Mueller wrote:
> > another crash with all of the latest patches and using gcm_base(ctr(aes-
> > asm),ghash-generic) using the standard AEAD interface and performing
> > encryption.
> 
> Can you send me the patch of libkcapi against
> b1e885f64f7b7f6cbc34faa1617158090c6123df?

The testing of the AF_ALG API is done -- all works with your latest patch set.

Now, I am testing the in-kernel API with an out-of tree test module that 
invokes all permutations of ciphers that are out there using NIST test 
vectors. I just want to make sure that the ciphers still work as expected and 
that the new API works well.

-- 
Ciao
Stephan
