From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Wed, 6 Aug 2008 18:09:44 +0800
Message-ID: <20080806100944.GA31448@gondor.apana.org.au>
References: <1218000211.4231.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bunk@kernel.org, dwmw2@infradead.org, davem@davemloft.net,
	randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57610 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752003AbYHFKKB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Aug 2008 06:10:01 -0400
Content-Disposition: inline
In-Reply-To: <1218000211.4231.23.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 06, 2008 at 01:23:31AM -0400, Austin Zhang wrote:
> =EF=BB=BF=EF=BB=BFRevised by comments:
> Add 'static' for limitation namespace;
> Resend for fixing lines-folded by adjusting evolution config;
> (The patch was created against 2.6.27-rc1)

Applied to cryptodev-2.6.  Thanks a lot Austin!
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
