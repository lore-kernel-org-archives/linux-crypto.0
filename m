From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - process 8 blocks in parallel if
 we can
Date: Thu, 29 Dec 2016 10:23:48 +0800
Message-ID: <20161229022348.GA13402@gondor.apana.org.au>
References: <1481291246-20216-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161227085745.GA10121@gondor.apana.org.au>
 <CAKv+Gu8OkOR3Xzx=XEOWyFpo6sLiq=WQrq0SauaY0V57uYetCQ@mail.gmail.com>
 <20161228091020.GE11904@gondor.apana.org.au>
 <B32240B5-953F-42A2-A010-6FF64AC45859@linaro.org>
 <20161228092328.GA12494@gondor.apana.org.au>
 <CAKv+Gu__722s0JkpTzqDu7MmrzSMQ9jJQn=RYnxgSyV+P6MZRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39483 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752104AbcL2CYB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 21:24:01 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu__722s0JkpTzqDu7MmrzSMQ9jJQn=RYnxgSyV+P6MZRQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 28, 2016 at 07:50:44PM +0000, Ard Biesheuvel wrote:
> 
> So about this chunksize, is it ever expected to assume other values
> than 1 (for stream ciphers) or the block size (for block ciphers)?
> Having block size, IV size *and* chunk size fields may be confusing to
> some already, so if the purpose of chunk size can be fulfilled by a
> single 'stream cipher' flag, perhaps we should change that first.

For users (such as algif) it's much more convenient to have a size
rather than a flag because that's what they need to determine the
minimum size for partial updates.

For implementors you don't need to specify the chunksize at all
unless you're a stream cipher (or some other case in future where
the minimum partial update size is not equal to your block size).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
