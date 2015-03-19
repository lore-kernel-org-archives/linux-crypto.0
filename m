From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -crypto] lib: memzero_explicit: use barrier instead of
 OPTIMIZER_HIDE_VAR
Date: Fri, 20 Mar 2015 08:04:41 +1100
Message-ID: <20150319210441.GA10752@gondor.apana.org.au>
References: <9419c18a95e98ba92f1aad8fda7da51771fdccea.1426700375.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, mancha security <mancha1@zoho.com>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Stephan Mueller <smueller@chronox.de>,
	Theodore Ts'o <tytso@mit.edu>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:36751 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbbCSVEt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 17:04:49 -0400
Content-Disposition: inline
In-Reply-To: <9419c18a95e98ba92f1aad8fda7da51771fdccea.1426700375.git.daniel@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 18, 2015 at 06:47:25PM +0100, Daniel Borkmann wrote:
> From: mancha security <mancha1@zoho.com>
> 
> OPTIMIZER_HIDE_VAR(), as defined when using gcc, is insufficient to
> ensure protection from dead store optimization.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
