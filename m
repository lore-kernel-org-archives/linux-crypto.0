From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] ipv6: sr: fix passing wrong flags to
 crypto_alloc_shash()
Date: Mon, 02 Jul 2018 20:37:15 +0900 (KST)
Message-ID: <20180702.203715.1217460369860711031.davem@davemloft.net>
References: <20180630222656.333-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, david.lebrun@uclouvain.be,
        linux-crypto@vger.kernel.org, ebiggers@google.com
To: ebiggers3@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180630222656.333-1-ebiggers3@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers3@gmail.com>
Date: Sat, 30 Jun 2018 15:26:56 -0700

> From: Eric Biggers <ebiggers@google.com>
> 
> The 'mask' argument to crypto_alloc_shash() uses the CRYPTO_ALG_* flags,
> not 'gfp_t'.  So don't pass GFP_KERNEL to it.
> 
> Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Oops, applied and queued up for -stable, thanks!
