From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] tcrypt.h: Salsa20 large test vector
Date: Fri, 7 Dec 2007 16:43:14 +0800
Message-ID: <20071207084313.GA7829@gondor.apana.org.au>
References: <fd3e431c0712031437i5b44cf36i969f9262487b843f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2189 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751759AbXLGInU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 03:43:20 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712031437i5b44cf36i969f9262487b843f@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 04, 2007 at 06:37:59AM +0800, Tan Swee Heng wrote:
> This is a large test vector for Salsa20 that crosses the 4096-bytes
> page boundary.
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Both patches applied.  Thanks a lot!

BTW, I had to fix a couple of white space errors in the second
patch:

$ git apply --check --whitespace=error-all ~/p
Adds trailing whitespace.
/export/home/herbert/p:544:                     0x00, 0x21, 0x42, 0x63,
Adds trailing whitespace.
/export/home/herbert/p:1060:                    0xaf, 0xdf, 0x11, 0x95,
fatal: 2 lines add trailing whitespaces.
$

So please try this command yourself in future.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
