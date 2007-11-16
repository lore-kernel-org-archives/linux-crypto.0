From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/3] [eSTREAM] stream: Wrapper for eSTREAM ciphers
Date: Sat, 17 Nov 2007 01:48:04 +0800
Message-ID: <fd3e431c0711160948n19455a6p2ba54f895359e44a@mail.gmail.com>
References: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com>
	 <E1IrkoZ-0007hT-00@gondolin.me.apana.org.au>
	 <fd3e431c0711130925s6b7acddck80dd0054b41d1147@mail.gmail.com>
	 <20071114030740.GA8539@gondor.apana.org.au>
	 <fd3e431c0711141714qbd444f9o2b15973caaf15a3c@mail.gmail.com>
	 <20071115011807.GA21310@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:2221 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414AbXKPRsN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2007 12:48:13 -0500
Received: by ik-out-1112.google.com with SMTP id c28so564048ika
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2007 09:48:06 -0800 (PST)
In-Reply-To: <20071115011807.GA21310@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Nov 15, 2007 9:18 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Actually what I suggested is that you add a wrapper called
> salsa20 that then simply calls ctr(...) after constructing the IV.
I tried that but encountered a problem: what is the blocksize for the
underlying salsa20 expansion function. If 16 (block size of input)
then crypto_ctr_crypt_{inplace,segment} will be taking steps that are
too small. If 64 (block size of output) then we fail the ((noncesize +
ivsize + countersize) < alg->cra_blocksize) test in
crypto_crt_alloc(). It appears that ctr(salsa20,...) may not work or
am I missing something here?

> We don't really need to have two copies of the ctr code under crypto :)
Since I was unable to do ctr(salsa20,...) I simply let Bernstein's
original code handles the increment of the counter.

By the way, are there plans to collect the xor_{byte,quad,64,128}
functions into a common header, say include/crypto/xor_n.h? It would
be nice to have these common functions in a place where everyone can
use. Currently cbc, ctr, pcbc and xcbc each has their own
implementation. If it is useful to have such a header file, I can help
to put together it. (After all, I foresee that I will need them when
implementing other eSTREAM ciphers.)

Swee Heng
