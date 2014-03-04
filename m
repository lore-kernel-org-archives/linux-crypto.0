From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] take 2: repurposing blkcipher walk api for aead
Date: Tue, 4 Mar 2014 15:46:27 +0800
Message-ID: <20140304074627.GA10695@gondor.apana.org.au>
References: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48852 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbaCDHqb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2014 02:46:31 -0500
Content-Disposition: inline
In-Reply-To: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 04, 2014 at 01:28:37PM +0800, Ard Biesheuvel wrote:
> I think this is a better approach than the one I proposed before. This time,
> I have only added a single function specifically for use by aeads:
> 
> blkcipher_aead_walk_virt_block()
> 
> which takes an additional aead param which is used to get the ivsize, alignmask
> and blocksize of the underlying transform.

Looks good to me.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
