From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 1/4] crypto: engine - Permit to enqueue all async
 requests
Date: Fri, 22 Dec 2017 17:57:24 +1100
Message-ID: <20171222065724.GA27149@gondor.apana.org.au>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
 <20171129084121.9385-2-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexandre.torgue@st.com, arei.gonglei@huawei.com,
        davem@davemloft.net, jasowang@redhat.com,
        mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:45946 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbdLVG5v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 01:57:51 -0500
Content-Disposition: inline
In-Reply-To: <20171129084121.9385-2-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 09:41:18AM +0100, Corentin Labbe wrote:
> The crypto engine could actually only enqueue hash and ablkcipher request.
> This patch permit it to enqueue any type of crypto_async_request.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

This is going the wrong way.  We do not want to expose any of the
base types such as crypto_alg, crypto_async_request to end-users
and that includes drivers.  Only core API code should touch these
base types.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
