From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Date: Fri, 15 May 2015 14:52:22 +0800
Message-ID: <20150515065222.GA16808@gondor.apana.org.au>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
 <1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	davem@davemloft.net, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, mchehab@osg.samsung.com,
	joe@perches.com, tj@kernel.org, arnd@arndb.de,
	boris.brezillon@free-electrons.com, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-sunxi@googlegroups.com
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 14, 2015 at 02:59:01PM +0200, LABBE Corentin wrote:
>
> +int sun4i_hash_export(struct ahash_request *areq, void *out)
> +{
> +	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
> +
> +	memcpy(out, op, sizeof(struct sun4i_req_ctx));
> +	return 0;
> +}
> +
> +int sun4i_hash_import(struct ahash_request *areq, const void *in)
> +{
> +	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
> +
> +	memcpy(op, in, sizeof(struct sun4i_req_ctx));

This is very wrong.  You're importing an arbitrary ss pointer.  The
whole point of having an import function instead of just a simple
memcpy is to deal with such problems.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
