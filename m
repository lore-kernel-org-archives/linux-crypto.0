From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH RFC 1/4] crypto: engine - Permit to enqueue all async
 requests
Date: Fri, 22 Dec 2017 09:41:48 +0100
Message-ID: <20171222084148.GA3024@Red>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
 <20171129084121.9385-2-clabbe.montjoie@gmail.com>
 <20171222065724.GA27149@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexandre.torgue@st.com, arei.gonglei@huawei.com,
        davem@davemloft.net, jasowang@redhat.com,
        mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:47068 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdLVIlw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:41:52 -0500
Content-Disposition: inline
In-Reply-To: <20171222065724.GA27149@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 05:57:24PM +1100, Herbert Xu wrote:
> On Wed, Nov 29, 2017 at 09:41:18AM +0100, Corentin Labbe wrote:
> > The crypto engine could actually only enqueue hash and ablkcipher request.
> > This patch permit it to enqueue any type of crypto_async_request.
> > 
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> 
> This is going the wrong way.  We do not want to expose any of the
> base types such as crypto_alg, crypto_async_request to end-users
> and that includes drivers.  Only core API code should touch these
> base types.
> 

Hello

It's you that was suggesting using crypto_async_request:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1474434.html
"The only wart with this scheme is that the drivers end up seeing
struct crypto_async_request and will need to convert that to the
respective request types but I couldn't really find a better way."

So I wait for any suggestion.

Regards
Corentin Labbe
