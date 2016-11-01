From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: testmgr - Add missing tests for internal
 sha*-mb implementations
Date: Tue, 1 Nov 2016 08:32:49 +0800
Message-ID: <20161101003249.GA7297@gondor.apana.org.au>
References: <1477501485-18371-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55576 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933661AbcKAAc6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:32:58 -0400
Content-Disposition: inline
In-Reply-To: <1477501485-18371-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 26, 2016 at 03:04:42PM -0200, Marcelo Cerri wrote:
> This series adds null tests for all sha*-mb internal algorithms so they can
> be used in FIPS mode without further problems.
> 
> Since they are 3 separated modules I decided to use a separated commit for
> each one.
> 
> Marcelo Cerri (3):
>   crypto: testmgr - Add missing tests for internal sha1-mb
>     implementation
>   crypto: testmgr - Add missing tests for internal sha256-mb
>     implementation
>   crypto: testmgr - Add missing tests for internal sha512-mb
>     implementation
> 
>  crypto/testmgr.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)

I have a patch pending that skips testing of all internal algorithms.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
