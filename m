From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] crypto: caam - Add support for hashing export and import
 functions
Date: Sat, 17 Oct 2015 18:38:23 +0100
Message-ID: <20151017173823.GP32532@n2100.arm.linux.org.uk>
References: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, fabio.estevam@freescale.com,
	boris.brezillon@free-electrons.com, arno@natisbad.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	davem@davemloft.net
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43306 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbJQRi3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 13:38:29 -0400
Content-Disposition: inline
In-Reply-To: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 16, 2015 at 04:19:33PM -0700, Victoria Milhoan wrote:
> @@ -1569,6 +1601,10 @@ static int ahash_import(struct ahash_request *req, const void *in)
>  	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
>  	struct caam_hash_state *state = ahash_request_ctx(req);
>  
> +	/* Allocate new data buffers to use for this request */
> +	state->buf_0 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> +	state->buf_1 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> +

I'm really not sure you can do this at all.  What if the previous
digest calculation prior to the accept() cloning the state was for
a non-hash-block aligned size of data.  The above will lose that
state, and produce an incorrect hash result.  Herbert, can you
confirm please?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
