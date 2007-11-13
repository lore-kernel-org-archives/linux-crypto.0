From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/3] [eSTREAM] stream: Wrapper for eSTREAM ciphers
Date: Wed, 14 Nov 2007 01:25:37 +0800
Message-ID: <fd3e431c0711130925s6b7acddck80dd0054b41d1147@mail.gmail.com>
References: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com>
	 <E1IrkoZ-0007hT-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:39458 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbXKMRZj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 12:25:39 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1334575nze
        for <linux-crypto@vger.kernel.org>; Tue, 13 Nov 2007 09:25:38 -0800 (PST)
In-Reply-To: <E1IrkoZ-0007hT-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Nov 13, 2007 9:43 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Why couldn't straem ciphers that require an IV just use the
> blkcipher interface? Please enlighten me :)

>From what I understand, the blkcipher interface provides functions
like crypto_blkcipher_set_iv() for the caller to set IV. What it does
is to set *iv in blkcipher_tfm to point to the IV buffer. Later this
pointer is passed to desc->info and walk->iv. (Some caller like
dm-crypt.c sets desc->info = iv directly though.) Subsequently
templates like "cbc" and "ctr" pick up the IV pointer from walk->iv.
For "cbc", the IV is XORed into the input block before calling the
underlying cipher. For "ctr", the IV is used to form a counter block
before calling the underlying cipher.

In fact, my "stream" template patch uses blkcipher in the same way.
However unlike "cbc" and "ctr", "stream" cannot process the IV. It
must pass it to the underlying eSTREAM cipher's setiv() because each
cipher's setiv() manipulates the IV differently. (Salsa20 uses it in a
counter block; other eSTREAM ciphers mix the IV with the key in their
key expansion.)

So blkcipher is indeed fine for stream ciphers as you stated - I even
use it in "stream". The problem is that cipher_alg and cipher_tfm do
not have callbacks for eSTREAM ciphers to expose setiv(). The
"estream" patch tries to address this issue by introducing
crypto_estream_type, estream_alg and estream_tfm.

I hoped my explanation is clear. The difference in "set IV" semantics
for block modes and eSTREAM ciphers can be confusing. The patches I've
submitted recently are my solution to this problem. It is probably not
the best solution. If you or any other expert on this list have other
ideas, please discuss and I will try to implement them. (Although the
patches pass tcrypt and seem to embody eSTREAM ciphers rather well, I
just realized they are not usable in dm-crypt as dm-crypt.c explicitly
uses crypto_cipher. Bummer!)

Swee Heng
