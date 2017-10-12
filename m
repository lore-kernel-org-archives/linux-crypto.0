From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: lrw - Fixes for the 'create()' function
Date: Thu, 12 Oct 2017 23:10:13 +0800
Message-ID: <20171012151013.GB31122@gondor.apana.org.au>
References: <cover.1507445539.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1507445539.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 08, 2017 at 11:39:48AM +0200, Christophe JAILLET wrote:
> The first patch is the same as the one committed for crypto/xts.c applied a
> few days ago.
> (commit 5125e4e867ab ("crypto: xts - Fix an error handling path in 'create()'")
> in /git/herbert/crypto-2.6.git)
> 
> The 2nd one is a pure speculation from me.
> The create function in 'crypto/xts.c' and 'crypto/lrw.c' look very
> similar.
> However, there is one more sanity check in xts. This patch proposes to
> add the same test in lrw. Not sure at all if correct!
> I just send it for consistency.
> 
> Christophe JAILLET (2):
>   crypto: lrw - Fix an error handling path in 'create()'
>   crypto: lrw - Check for incorrect cipher name

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
