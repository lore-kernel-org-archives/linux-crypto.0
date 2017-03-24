From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: powerpc - Factor out the core CRC vpmsum
 algorithm
Date: Fri, 24 Mar 2017 22:12:19 +0800
Message-ID: <20170324141219.GA14798@gondor.apana.org.au>
References: <20170315123737.20234-1-dja@axtens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        anton@samba.org, dja@axtens.net
To: Daniel Axtens <dja@axtens.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42592 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935739AbdCXONU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:13:20 -0400
Content-Disposition: inline
In-Reply-To: <20170315123737.20234-1-dja@axtens.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Daniel Axtens <dja@axtens.net> wrote:
> The core nuts and bolts of the crc32c vpmsum algorithm will
> also work for a number of other CRC algorithms with different
> polynomials. Factor out the function into a new asm file.
> 
> To handle multiple users of the function, a user simply
> provides constants, defines the name of their CRC function,
> and then #includes the core algorithm file.
> 
> Cc: Anton Blanchard <anton@samba.org>
> Signed-off-by: Daniel Axtens <dja@axtens.net>

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
