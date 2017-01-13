From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 19:04:17 +0800
Message-ID: <20170113110417.GB23617@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <3463059.TVfkfLOfNf@tauon.atsec.com>
 <20170113102339.GB23349@gondor.apana.org.au>
 <9279288.fr5DIlfFLr@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60431 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751406AbdAMLaB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:30:01 -0500
Content-Disposition: inline
In-Reply-To: <9279288.fr5DIlfFLr@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 11:58:24AM +0100, Stephan Müller wrote:
>
> May I ask how the in-place code path can be invoked by algif_aead or 
> algif_skcipher? As far as I understand, this code path is only invoked when 
> the cipher implementation sees that the src and dst SGLs are identical.

It's not right now but it isn't difficult to add the code to allow
it by comparing SGLs.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
