From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AES-NI GCM - handle zero length dst buffer
Date: Fri, 26 Jan 2018 23:46:11 +0800
Message-ID: <20180126154611.GH4002@gondor.apana.org.au>
References: <2389839.8lvrU0lKhj@positron.chronox.de>
 <68925276.69ZJuSpAmI@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39626 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbeAZQap (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jan 2018 11:30:45 -0500
Content-Disposition: inline
In-Reply-To: <68925276.69ZJuSpAmI@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 18, 2018 at 08:41:09PM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> Sorry, I forgot to CC you on this patch -- v2 is unchanged from the
> original patch. It only adds you in copy.
> 
> ---8<---
> 
> GCM can be invoked with a zero destination buffer. This is possible if
> the AAD and the ciphertext have zero lengths and only the tag exists in
> the source buffer (i.e. a source buffer cannot be zero). In this case,
> the GCM cipher only performs the authentication and no decryption
> operation.
> 
> When the destination buffer has zero length, it is possible that no page
> is mapped to the SG pointing to the destination. In this case,
> sg_page(req->dst) is an invalid access. Therefore, page accesses should
> only be allowed if the req->dst->length is non-zero which is the
> indicator that a page must exist.
> 
> This fixes a crash that can be triggered by user space via AF_ALG.
> 
> CC: <stable@vger.kernel.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
