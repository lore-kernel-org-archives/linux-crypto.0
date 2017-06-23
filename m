From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v6 0/2] IV Generation algorithms for dm-crypt
Date: Fri, 23 Jun 2017 11:21:56 -0700
Message-ID: <20170623182156.GB84943@gmail.com>
References: <1498106510-19793-1-git-send-email-binoy.jayan@linaro.org>
 <20170623081341.GA29748@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Binoy Jayan <binoy.jayan@linaro.org>, broonie@kernel.org,
        arnd@arndb.de, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, rnayak@codeaurora.org,
        David Gstir <david@sigma-star.at>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34044 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdFWSWA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 14:22:00 -0400
Content-Disposition: inline
In-Reply-To: <20170623081341.GA29748@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 04:13:41PM +0800, Herbert Xu wrote:
> Binoy Jayan <binoy.jayan@linaro.org> wrote:
> > ===============================================================================
> > dm-crypt optimization for larger block sizes
> > ===============================================================================
> > 
> > Currently, the iv generation algorithms are implemented in dm-crypt.c. The goal
> > is to move these algorithms from the dm layer to the kernel crypto layer by
> > implementing them as template ciphers so they can be used in relation with
> > algorithms like aes, and with multiple modes like cbc, ecb etc. As part of this
> > patchset, the iv-generation code is moved from the dm layer to the crypto layer
> > and adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
> > at a time. Each bio contains the in memory representation of physically
> > contiguous disk blocks. Since the bio itself may not be contiguous in main
> > memory, the dm layer sets up a chained scatterlist of these blocks split into
> > physically contiguous segments in memory so that DMA can be performed.
> 
> There is currently a patch-set for fscrypt to add essiv support.  It
> would be interesting to know whether your implementation of essiv
> can also be used in that patchset.  That would confirm that we're on
> the right track.
> 

You can find the fscrypt patch at https://patchwork.kernel.org/patch/9795327/

Note that it's encrypting 4096-byte blocks, not 512-byte.  Also, it's using
AES-256 for the ESSIV tfm (since it uses a SHA-256 hash) but AES-128 for the
"real" encryption.  It's possible this is a mistake and it should be AES-128 for
both.  (If it is, it needs to be fixed before it's released in 4.13.)

Eric
