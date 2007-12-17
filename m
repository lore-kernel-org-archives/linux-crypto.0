From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] Salsa20 stream cipher algorithm (x86-64 version)
Date: Tue, 18 Dec 2007 00:06:36 +0800
Message-ID: <20071217160636.GB14440@gondor.apana.org.au>
References: <fd3e431c0712161006mf162962je617794061c19398@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2392 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756032AbXLQQGk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 11:06:40 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712161006mf162962je617794061c19398@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 17, 2007 at 02:06:15AM +0800, Tan Swee Heng wrote:
> This is the x86-64 version of the Salsa20 stream cipher algorithm. The
> original assembly code came from
> <http://cr.yp.to/snuffle/salsa20/amd64-3/salsa20.s>. It has been
> reformatted for clarity.
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Patch applied.  Thanks a lot!

> Hi Herbert, as mentioned some time ago, I don't have an x86-64. So
> please help me test it. Thanks!
> The Python script used to automate the reformatting is also attached
> in case anyone is interested.

Yes it works fine here.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
