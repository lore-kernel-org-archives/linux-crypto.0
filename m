From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/2] crypto: AF_ALG memory management fix
Date: Thu, 16 Feb 2017 20:10:21 +0800
Message-ID: <20170216121021.GA18940@gondor.apana.org.au>
References: <1652737.cgCBfDoNyd@positron.chronox.de>
 <2976339.VnMoFl3GdB@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34467 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753434AbdBPMKh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2017 07:10:37 -0500
Content-Disposition: inline
In-Reply-To: <2976339.VnMoFl3GdB@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 15, 2017 at 09:47:19AM +0100, Stephan Müller wrote:
> 
> as I just saw that you marked my patch with changes requested in patchwork, 
> may I ask which changes should be applied?

I thought we agreed that we would not do the TX offset thing and
keep the existing semantics of consuming all TX data given an RX
request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
