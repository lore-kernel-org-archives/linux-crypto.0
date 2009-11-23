From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Bug in geode-aes.c ?
Date: Mon, 23 Nov 2009 20:07:24 +0800
Message-ID: <20091123120723.GB6424@gondor.apana.org.au>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com> <20091111220832.GC18452@Chamillionaire.breakpoint.cc> <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Sergey Mironov <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33124 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757282AbZKWMHX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2009 07:07:23 -0500
Content-Disposition: inline
In-Reply-To: <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 12, 2009 at 08:36:42AM +0000, Sergey Mironov wrote:
>
> Hi. Ok, here is geode-patch

Your patch is corrupted:

$ git apply ~/p
patch: **** malformed patch at line 51: *tfm, const u8 *key,

$

Please resend.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
