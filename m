From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: What should be the algo priority
Date: Mon, 10 Apr 2017 19:25:33 +0800
Message-ID: <20170410112533.GA8996@gondor.apana.org.au>
References: <CAFXBA=mHp_LB9tufr-aRGXkfoULGbMn5RxRV1ajSozx88Er0CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51952 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752756AbdDJLZ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 07:25:58 -0400
Content-Disposition: inline
In-Reply-To: <CAFXBA=mHp_LB9tufr-aRGXkfoULGbMn5RxRV1ajSozx88Er0CQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Harsh Jain <harshjain.prof@gmail.com> wrote:
>
> It means cbc, hmac should have smaller(nearly 10 times less) priority
> than their authenc implementation otherwise request will not offload
> to driver because sw authenc priority is (aes * 10 + hmac).

I think you should look at it the other way.  The priority of
your hardware authenc should be greater than (aes * 10 + hmac)
where aes is the priority of your hardware aes and hmac is the
priority of your hardware hmac.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
