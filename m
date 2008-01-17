From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: New Crypto Hardware
Date: Thu, 17 Jan 2008 21:27:35 +0100
Message-ID: <20080117202735.GA22733@Chamillionaire.breakpoint.cc>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com> <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: 'Herbert Xu' <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <locnho@sbcglobal.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40870 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYAQU1l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jan 2008 15:27:41 -0500
Content-Disposition: inline
In-Reply-To: <001c01c85937$ff3313f0$5c05420a@amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Loc Ho | 2008-01-17 10:37:20 [-0800]:

>struct hash_alg {
>	int (*init)(struct hash_desc *desc);
>	int (*update)(struct hash_desc *desc, struct scatterlist *sg,
>		      unsigned int nbytes);
>	int (*final)(struct hash_desc *desc, u8 *out);
>	int (*digest)(struct hash_desc *desc, struct scatterlist *sg,
>		      unsigned int nbytes, u8 *out);
>	int (*setkey)(struct crypto_hash *tfm, const u8 *key,
>		      unsigned int keylen);
>
>	unsigned int digestsize;
>}; 
>
>It looks like update and final functions are used for continuous hashing.
>And digest function is used for single hashing. I was thing changing to this
>for async:
>
>struct ahash_alg {
>	int (*init)(struct ahash_request *req);
>	int (*digest)(struct ahash_request *req);
>	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
>		unsigned int keylen);
>
>	unsigned int digestsize;
>};
>
>But it seems like there is still a need to support continuation hashing as
>well as just single hash. 
>
>Questions:
>1. Is my assume about update/final and digest function correct? 
With update you do feed the digest/hash with new data. ->final writes
the result out. You can have 1+ update calls while you have only one
final call where you get your result. Does your HW create the digest in
one go and does not allow updates before creating the final result?

>2. What is the difference between digest and hash type besides one operation
>on transformation structure (tfm) and the other on descriptor (desc)? 
They are used for different things.
Digest is something like sha1 or md5. You just feed your algoritm with
data and get a single result. A hash on the other hand has a key which
is used as a salt, a random initialization string. 

>3. Currently, cryptodev-2.6 git doesn't work under PPC4xx development board
>but Denx linux latest works. Have anyone tested on PPC4xx board?

Please define doesn't work.

Sebastian
