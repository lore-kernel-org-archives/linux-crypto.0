From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: shash_alg size fields and stomping memory
Date: Wed, 27 Apr 2011 19:57:52 +1000
Message-ID: <20110427095752.GA1349@gondor.apana.org.au>
References: <4DADD47C.1080701@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40566 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab1D0J54 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Apr 2011 05:57:56 -0400
Content-Disposition: inline
In-Reply-To: <4DADD47C.1080701@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kent Borg <kentborg@borg.org> wrote:
> 
> My most recent discovery is that if I want to do an shash_desc_ctx() and 
> use the result, cra_ctxsize doesn't seem to mean a thing.  Rather, 
> unless I set descsize, memory will be stomped.

descsize specifies the size of shash_desc_ctx.  ctxsize is the
size of crypto_shash_ctx.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
