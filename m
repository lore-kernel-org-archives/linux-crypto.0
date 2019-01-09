Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfAIRWK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 12:22:10 -0500
Date: Wed, 9 Jan 2019 09:22:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kalyani Akula <kalyani.akula@xilinx.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: Re: [RFC PATCH 2/3] crypto: Add Xilinx SHA3 driver
Message-ID: <20190109172206.GA249140@gmail.com>
References: <1546851776-3456-1-git-send-email-kalyani.akula@xilinx.com>
 <1546851776-3456-3-git-send-email-kalyani.akula@xilinx.com>
 <20190107165606.GA2077@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107165606.GA2077@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 07, 2019 at 08:56:07AM -0800, Eric Biggers wrote:
> Hi Kalyani,
> 
> On Mon, Jan 07, 2019 at 02:32:55PM +0530, Kalyani Akula wrote:
> > This patch adds SHA3 driver suuport for the Xilinx
> > ZynqMP SoC.
> > 
> > Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> [...]
> > +
> > +static struct ahash_alg sha3_alg = {
> > +	.init		= zynqmp_sha_init,
> > +	.update		= zynqmp_sha_update,
> > +	.final		= zynqmp_sha_final,
> > +	.finup		= zynqmp_sha_finup,
> > +	.digest		= zynqmp_sha_digest,
> > +	.export		= zynqmp_sha_export,
> > +	.import		= zynqmp_sha_import,
> > +	.halg = {
> > +		.digestsize	= SHA384_DIGEST_SIZE,
> > +		.statesize	= sizeof(struct sha256_state),
> > +		.base	= {
> > +			.cra_name		= "xilinx-keccak-384",
> > +			.cra_driver_name	= "zynqmp-keccak-384",
> > +			.cra_priority		= 300,
> > +			.cra_flags		= CRYPTO_ALG_ASYNC,
> > +			.cra_blocksize		= SHA384_BLOCK_SIZE,
> > +			.cra_ctxsize		= sizeof(struct zynqmp_sha_ctx),
> > +			.cra_alignmask		= 0,
> > +			.cra_module		= THIS_MODULE,
> > +			.cra_init		= zynqmp_sha_cra_init,
> > +		}
> > +	}
> > +};
> 
> cra_name needs to match an algorithm that has a generic implementation.
> It should be "sha3-384", or is your hardware not compatible?
> Also does your hardware not support sha3-256 and sha3-512?
> 
> - Eric

Hi Kalyani, this was not addressed in v2.

- Eric
