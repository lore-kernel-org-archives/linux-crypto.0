From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: (was Re: 2.6.24-rc5-mm1) crypto/authenc.c select symbol in Kconfig
Date: Fri, 14 Dec 2007 16:53:12 +0800
Message-ID: <20071214085312.GA15864@gondor.apana.org.au>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <20071213174636.GA30228@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: bbpetkov@yahoo.de, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763755AbXLNIxc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071213174636.GA30228@gollum.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 13, 2007 at 06:46:37PM +0100, Borislav Petkov wrote:
>
> which fails because crypto_hash_type is declared in crypto/hash.c. You might wanna
> fix it like so:
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

Patch applied.  Thanks for picking this up.

> --- crypto/Kconfig.orig	2007-12-13 18:44:19.000000000 +0100
> +++ crypto/Kconfig	2007-12-13 18:39:00.000000000 +0100

BTW please generate patch -p1 patches in future.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
