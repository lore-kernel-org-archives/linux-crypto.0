From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: XFRM Stats
Date: Thu, 22 Jun 2017 10:42:11 +0800
Message-ID: <20170622024211.GA24666@gondor.apana.org.au>
References: <CAMFBXfmPTjuSkC+Wv9woBG36cqYTexmqoYE4C-iW-jRjYvRdiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Raj Ammanur <rammanur@arista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34336 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdFVCmc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 22:42:32 -0400
Content-Disposition: inline
In-Reply-To: <CAMFBXfmPTjuSkC+Wv9woBG36cqYTexmqoYE4C-iW-jRjYvRdiA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Raj Ammanur <rammanur@arista.com> wrote:
> Hi Crypto/Xfrm Team,
> 
> I was wondering if there has been any discussion in the past
> about adding stats in Xfrm to count the packets going in/out of
> this sub-system? Right now we only have error stats.

Have you looked at ip -s x s?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
