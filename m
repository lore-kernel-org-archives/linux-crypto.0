From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AEAD x86 assembler crash
Date: Mon, 01 Jun 2015 11:27:42 +0200
Message-ID: <4763307.0Ij2da8UTH@tachyon.chronox.de>
References: <5734608.jOsyQWs821@tachyon.chronox.de> <20150601091745.GA12441@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58393 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbbFAJ1p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:27:45 -0400
In-Reply-To: <20150601091745.GA12441@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 1. Juni 2015, 17:17:45 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jun 01, 2015 at 11:12:45AM +0200, Stephan Mueller wrote:
> > [  599.243227]  [<ffffffff812b7b85>] old_crypt+0xc5/0xe0
> > [  599.243229]  [<ffffffff812b7bdd>] old_encrypt+0x1d/0x20
> > [  599.243233]  [<ffffffffa02c1183>] kccavs_aead_encdec+0x53/0x80
> > [kcapi_cavs] [  599.243235]  [<ffffffffa02c1cca>]
> > kccavs_test_aead+0x23a/0x3e0 [kcapi_cavs] [  599.243238] 
> > [<ffffffffa02c0f17>] kccavs_data_read+0xf7/0x130 [kcapi_cavs]
> Hang on, what is this kcapi_cavs? We don't support out-of-tree
> crypto users.

I understand -- this is my test tool that invokes all ciphers with all 
permutations. And it may be the case that it is my code. I am looking into it.

Though, it happens with the new API only, the old API works fine. And my test 
code with the new API works just fine when invoking GCM with an IV generator.

Just a question: is the new API without an IV generator to be used differently 
when using the new API with an IV generator?

Thank you.

-- 
Ciao
Stephan
