From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 0/2] IV Generation algorithms for dm-crypt
Date: Fri, 23 Jun 2017 16:13:41 +0800
Message-ID: <20170623081341.GA29748@gondor.apana.org.au>
References: <1498106510-19793-1-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, rnayak@codeaurora.org,
        binoy.jayan@linaro.org, David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers3@gmail.com>
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498106510-19793-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Binoy Jayan <binoy.jayan@linaro.org> wrote:
> ===============================================================================
> dm-crypt optimization for larger block sizes
> ===============================================================================
> 
> Currently, the iv generation algorithms are implemented in dm-crypt.c. The goal
> is to move these algorithms from the dm layer to the kernel crypto layer by
> implementing them as template ciphers so they can be used in relation with
> algorithms like aes, and with multiple modes like cbc, ecb etc. As part of this
> patchset, the iv-generation code is moved from the dm layer to the crypto layer
> and adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
> at a time. Each bio contains the in memory representation of physically
> contiguous disk blocks. Since the bio itself may not be contiguous in main
> memory, the dm layer sets up a chained scatterlist of these blocks split into
> physically contiguous segments in memory so that DMA can be performed.

There is currently a patch-set for fscrypt to add essiv support.  It
would be interesting to know whether your implementation of essiv
can also be used in that patchset.  That would confirm that we're on
the right track.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
