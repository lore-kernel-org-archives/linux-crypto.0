Return-Path: <SRS0=o+Is=OM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39668 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbeLCCx2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Dec 2018 21:53:28 -0500
Date: Mon, 3 Dec 2018 10:53:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Dave Rodgman <dave.rodgman@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, nd <nd@arm.com>
Subject: Re: [PATCH 7/7] lib/lzo: separate lzo-rle from lzo
Message-ID: <20181203025322.ak5eymaib6ubo2nw@gondor.apana.org.au>
References: <20181127161913.23863-1-dave.rodgman@arm.com>
 <20181127161913.23863-8-dave.rodgman@arm.com>
 <20181129044333.GH6379@jagdpanzerIV>
 <5b504430-fb4b-340b-66c2-1300c816cc3a@arm.com>
 <20181203024019.GB427@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203024019.GB427@jagdpanzerIV>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 03, 2018 at 11:40:19AM +0900, Sergey Senozhatsky wrote:
> 
> I'm not in any position to ask you to do this; white-space clean ups
> are not very popular (it's OK for staging tree; not so much otherwise).
> So we better ask David and Herbert.

I'm fine with white space cleanups.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
