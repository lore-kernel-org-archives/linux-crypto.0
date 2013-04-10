From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - suppress sending source address
 information in recvmsg
Date: Wed, 10 Apr 2013 14:26:24 +0800
Message-ID: <20130410062624.GA713@gondor.apana.org.au>
References: <1365336339-403-1-git-send-email-minipli@googlemail.com>
 <20130410033148.GA32360@gondor.apana.org.au>
 <CA+rthh9y2JiqHeOqPsDx+tS1Mk0O7rJDWsNPzqfiQz+9rEAnqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:45510 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755356Ab3DJG02 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Apr 2013 02:26:28 -0400
Content-Disposition: inline
In-Reply-To: <CA+rthh9y2JiqHeOqPsDx+tS1Mk0O7rJDWsNPzqfiQz+9rEAnqA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 10, 2013 at 08:21:51AM +0200, Mathias Krause wrote:
> On Wed, Apr 10, 2013 at 5:31 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Sun, Apr 07, 2013 at 02:05:39PM +0200, Mathias Krause wrote:
> >> The current code does not set the msg_namelen member to 0 and therefore
> >> makes net/socket.c leak the local sockaddr_storage variable to userland
> >> -- 128 bytes of kernel stack memory. Fix that.
> >>
> >> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> >
> > Patch applied.  Thanks!
> 
> Thanks, but that patch shouldn't have been applied to cryptodev but
> crypto instead, and probably queued up for stable as well.
> I missed the 'Cc: stable # v2.6.38'. My bad.

OK, I'll move it across and add the stable Cc.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
