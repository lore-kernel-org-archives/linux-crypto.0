From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] how to handle AAD copy operation for algif_aead
Date: Thu, 9 Mar 2017 18:00:11 +0800
Message-ID: <20170309100011.GA6844@gondor.apana.org.au>
References: <13406914.zeok8basum@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35295 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754471AbdCIKAV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 05:00:21 -0500
Content-Disposition: inline
In-Reply-To: <13406914.zeok8basum@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 24, 2017 at 02:24:47PM +0100, Stephan Müller wrote:
> Hi Herbert et al,
> 
> attached are two patches where each patch has a different approach to copy the 
> AAD in the algif_aead operation. I would like to hear your opinion which 
> approach should be taken.
> 
> The patch 0001-crypto-algif_aead-copy-AAD-from-src-to-dst_separate.patch 
> simply copies the AAD over from TX SGL to RX SGL. The pro is that the patch is 
> small. The con is that this approach does *not* provide an in-place crypto 
> operation.

I prefer this patch with the proviso that it copy the whole thing
instead of just the AD.  That way you can just feed the dst memory
to crypto_aead for in-place operation.  Of course you have to mangle
the tag data onto the dst SG list for decryption but it shouldn't
be too hard.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
