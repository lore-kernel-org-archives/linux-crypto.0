From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] x86_64 assembler implementation of camellia block
	cipher
Date: Wed, 14 Mar 2012 20:31:10 +1100
Message-ID: <20120314093110.GB2847@gondor.apana.org.au>
References: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:47643 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030710Ab2CNJbM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Mar 2012 05:31:12 -0400
Content-Disposition: inline
In-Reply-To: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 05, 2012 at 08:26:16PM +0200, Jussi Kivilinna wrote:
> Patches 1-2 add new tests and test vectors for camellia.
> Patches 3-5 rename 'camellia' module to 'camellia_generic'.
> Patch 6 adds x86_64 implementation of camellia.
> 
> Series depends on patch:
>   http://marc.info/?l=linux-crypto-vger&m=133077599602729&w=2

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
