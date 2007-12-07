From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Fri, 7 Dec 2007 17:22:11 +0800
Message-ID: <20071207092211.GA8496@gondor.apana.org.au>
References: <fd3e431c0712051231h44c7bc6epa2f526116cf2c47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2673 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752088AbXLGJWP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 04:22:15 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712051231h44c7bc6epa2f526116cf2c47@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 06, 2007 at 04:31:25AM +0800, Tan Swee Heng wrote:
> This patch contains the salsa20-i586 implementation. The original
> assembly code came from
> <http://cr.yp.to/snuffle/salsa20/x86-pm/salsa20.s>. I have reformatted
> it (added indents) so that it matches the other algorithms in
> arch/x86/crypto.
> 
> This patch also contains a speed test for salsa20-i586. Usage is
> "modprobe tcrypt mode=206"
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Patch applied.  Thanks!

BTW, I changed your speed test so that it just tests on salsa20.
That way the user can choose which variant gets tested by unloading
the i586 version.

It also prevents a failure if the platform doesn't have salsa20-i586,
which is the case on my x86-64 :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
