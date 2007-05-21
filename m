From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [XFRM] Camellia: fixed to add compat name for Camellia.
Date: Mon, 21 May 2007 16:17:21 +1000
Message-ID: <20070521061721.GA32721@gondor.apana.org.au>
References: <20061018.161749.782295638.takamiya@po.ntts.co.jp> <20070516.165231.783376564.takamiya@po.ntts.co.jp> <20070516091856.GA21695@gondor.apana.org.au> <20070521.114415.432839959.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	camellia-oss@sec.ms.ntts.co.jp
To: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4962 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754305AbXEUGRd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 May 2007 02:17:33 -0400
Content-Disposition: inline
In-Reply-To: <20070521.114415.432839959.takamiya@po.ntts.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 21, 2007 at 11:44:15AM +0900, Noriaki TAKAMIYA wrote:
> 
> > Is there a case where this is difficult?
> 
>   As you said, ipsec-tools(setkey) won't have such problem. I think of
>   the user who uses iproute(ip).
> 
>   Now, 2.6.21 is going to be shipped in Fedora Core7. So the user of
>   Camellia on the FC7 must use keyword "cbc(camellia)" with iproute.

Well I must say that this is intentional :) We want to people to get
into the habit of spelling it out in full, i.e., "cbc(aes)" instead of
"aes" because it's umabiguous and still short enough to type.

We can't force people to stop using "aes" so the best we can do is
to change to the new way with new algorithms such as camellia where
there wouldn't be a compatibility issue.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
