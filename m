From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/7] crypto/testmgr: add testing for arc4 based on
	ecb(arc4)
Date: Wed, 7 Apr 2010 17:29:07 +0800
Message-ID: <20100407092907.GB29993@gondor.apana.org.au>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270280969-11357-4-git-send-email-sebastian@breakpoint.cc> <1270621793.31184.50.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org
To: Pavel Roskin <proski@gnu.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57348 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752963Ab0DGJ3V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Apr 2010 05:29:21 -0400
Content-Disposition: inline
In-Reply-To: <1270621793.31184.50.camel@mj>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 07, 2010 at 02:29:53AM -0400, Pavel Roskin wrote:
>
> Can we avoid those special cases?  If the goal is "to make arc4
> compliant with the crypto API", this looks like a step in a wrong
> direction.
> 
> The same applies to many other changes in the series.
> 
> I do realize that the original arc4 is not a block cipher at all.

I don't like this bit either.

Sebastian, how about precomputing the IV and provide them directly
as a hex array?

To test arc4_setup_iv itself, you can add an alg_test_arc4 function
(like alg_test_crc32) that tests IV generation specifically.

Alternatively, just add an alg_test_arc4 that computes the IV
before calling alg_test_skcipher.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
