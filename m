From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] Revert "crypto: blowfish - add AVX2/x86_64
 implementation of blowfish cipher"
Date: Fri, 21 Jun 2013 15:17:13 +0800
Message-ID: <20130621071713.GC24151@gondor.apana.org.au>
References: <20130608091742.31485.50446.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60683 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758770Ab3FUHRP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Jun 2013 03:17:15 -0400
Content-Disposition: inline
In-Reply-To: <20130608091742.31485.50446.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 08, 2013 at 12:17:42PM +0300, Jussi Kivilinna wrote:
> This reverts commit 604880107010a1e5794552d184cd5471ea31b973.
> 
> Instruction (vpgatherdd) that this implementation relied on turned out to be
> slow performer on real hardware (i5-4570). The previous 4-way blowfish
> implementation is therefore faster and this implementation should be removed.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
