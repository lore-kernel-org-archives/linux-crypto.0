From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Bug in geode-aes.c ?
Date: Mon, 23 Nov 2009 20:08:33 +0800
Message-ID: <20091123120833.GC6424@gondor.apana.org.au>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com> <20091111220832.GC18452@Chamillionaire.breakpoint.cc> <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com> <20091112091807.GC22434@Chamillionaire.breakpoint.cc> <aa09d86e0911120218w3e1b640m91772d1859018ea9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Sergey Mironov <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33128 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757272AbZKWMIb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2009 07:08:31 -0500
Content-Disposition: inline
In-Reply-To: <aa09d86e0911120218w3e1b640m91772d1859018ea9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 12, 2009 at 01:18:53PM +0300, Sergey Mironov wrote:
>
> Here is similar patch for aes_s390:

It doesn't apply either:

$ git apply ~/p
patch: **** malformed patch at line 75: *tfm, const u8 *in_key,

$

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
