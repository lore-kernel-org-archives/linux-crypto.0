From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: vmx -  fix null dereference in p8_aes_xts_crypt
Date: Thu, 25 Aug 2016 13:56:35 +0800
Message-ID: <20160825055635.GA10607@gondor.apana.org.au>
References: <1472024080.3313.20.camel@TP420>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com
To: Li Zhong <zhong@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52351 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757548AbcHYF4j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 01:56:39 -0400
Content-Disposition: inline
In-Reply-To: <1472024080.3313.20.camel@TP420>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 24, 2016 at 03:34:40PM +0800, Li Zhong wrote:
> walk.iv is not assigned a value in blkcipher_walk_init. It makes iv uninitialized.
> It is possibly a null value(as shown below), which is then used by aes_p8_encrypt. 
> 
> This patch moves iv = walk.iv after blkcipher_walk_virt, in which walk.iv is set.
>  
> [17856.268050] Unable to handle kernel paging request for data at address 0x00000000
> [17856.268212] Faulting instruction address: 0xd000000002ff04bc
> 7:mon> t
> [link register   ] d000000002ff47b8 p8_aes_xts_crypt+0x168/0x2a0 [vmx_crypto]   (938)
> [c000000013b77960] d000000002ff4794 p8_aes_xts_crypt+0x144/0x2a0 [vmx_crypto] (unreliable)
> [c000000013b77a70] c000000000544d64 skcipher_decrypt_blkcipher+0x64/0x80
> [c000000013b77ac0] d000000003c0175c crypt_convert+0x53c/0x620 [dm_crypt]
> [c000000013b77ba0] d000000003c043fc kcryptd_crypt+0x3cc/0x440 [dm_crypt]
> [c000000013b77c50] c0000000000f3070 process_one_work+0x1e0/0x590
> [c000000013b77ce0] c0000000000f34c8 worker_thread+0xa8/0x660
> [c000000013b77d80] c0000000000fc0b0 kthread+0x110/0x130
> [c000000013b77e30] c0000000000098f0 ret_from_kernel_thread+0x5c/0x6c
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
