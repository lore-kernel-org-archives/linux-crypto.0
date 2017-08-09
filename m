From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_aead - copy AAD from src to dst
Date: Wed, 9 Aug 2017 21:56:34 +0800
Message-ID: <20170809135634.GB743@gondor.apana.org.au>
References: <2726753.0P7LaXD3sy@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36794 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbdHIN4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 09:56:42 -0400
Content-Disposition: inline
In-Reply-To: <2726753.0P7LaXD3sy@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 30, 2017 at 02:32:58PM +0200, Stephan Müller wrote:
> Use the NULL cipher to copy the AAD and PT/CT from the TX SGL
> to the RX SGL. This allows an in-place crypto operation on the
> RX SGL for encryption, because the TX data is always smaller or
> equal to the RX data (the RX data will hold the tag).
> 
> For decryption, a per-request TX SGL is created which will only hold
> the tag value. As the RX SGL will have no space for the tag value and
> an in-place operation will not write the tag buffer, the TX SGL with the
> tag value is chained to the RX SGL. This now allows an in-place
> crypto operation.
> 
> For example:
> 
> * without the patch:
> kcapi -x 2 -e -c "gcm(aes)" -p 89154d0d4129d322e4487bafaa4f6b46 -k c0ece3e63198af382b5603331cc23fa8 -i 7e489b83622e7228314d878d -a afcd7202d621e06ca53b70c2bdff7fb2 -l 16 -u -s
> 00000000000000000000000000000000f4a3eacfbdadd3b1a17117b1d67ffc1f1e21efbbc6d83724a8c296e3bb8cda0c
> 
> * with the patch:
> kcapi -x 2 -e -c "gcm(aes)" -p 89154d0d4129d322e4487bafaa4f6b46 -k c0ece3e63198af382b5603331cc23fa8 -i 7e489b83622e7228314d878d -a afcd7202d621e06ca53b70c2bdff7fb2 -l 16 -u -s
> afcd7202d621e06ca53b70c2bdff7fb2f4a3eacfbdadd3b1a17117b1d67ffc1f1e21efbbc6d83724a8c296e3bb8cda0c
> 
> Tests covering this functionality have been added to libkcapi.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
