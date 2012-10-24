From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] Avoid stack buffers in glue code of AVX
 implementations
Date: Wed, 24 Oct 2012 21:11:54 +0800
Message-ID: <20121024131154.GB3251@gondor.apana.org.au>
References: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:48224 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752402Ab2JXNLz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2012 09:11:55 -0400
Content-Disposition: inline
In-Reply-To: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 20, 2012 at 03:06:31PM +0300, Jussi Kivilinna wrote:
> Patches modify AVX implementations so that they avoid using extra
> stack memory. Stack is not needed since implementation store
> blocks in registers.

All applied to cryptodev.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
