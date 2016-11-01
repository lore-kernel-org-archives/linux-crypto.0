From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: core - zeroize buffers with random data
Date: Tue, 1 Nov 2016 08:42:49 +0800
Message-ID: <20161101004249.GA7375@gondor.apana.org.au>
References: <5934786.pstHyKoYpf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49024 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161116AbcKAAmz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:42:55 -0400
Content-Disposition: inline
In-Reply-To: <5934786.pstHyKoYpf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 22, 2016 at 03:57:05PM +0200, Stephan Mueller wrote:
> 
> The HWRNG core allocates two buffers during initialization which are
> used to obtain random data. After that data is processed, it is now
> zeroized as it is possible that the HWRNG core will not be asked to
> produce more random data for a long time. This prevents leaving such
> sensitive data in memory.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
