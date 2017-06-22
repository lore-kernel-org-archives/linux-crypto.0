From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: XFRM Stats
Date: Thu, 22 Jun 2017 16:27:22 +0800
Message-ID: <20170622082722.GA25682@gondor.apana.org.au>
References: <CAMFBXf=9y=c7EP1rBKDL51e2QB0KqFTHaDAFaLPUMv+eCeyYww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Raj Ammanur <rammanur@arista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34606 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbdFVI1p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 04:27:45 -0400
Content-Disposition: inline
In-Reply-To: <CAMFBXf=9y=c7EP1rBKDL51e2QB0KqFTHaDAFaLPUMv+eCeyYww@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Raj Ammanur <rammanur@arista.com> wrote:
> oops yes, completely forgot the lifetime stats. Thanks Herbert.
> 
> I will check this out, but after a rekey, are the stats still preserved?

No those stats are per-state.  So your best bet would be to get this
feature added to your user-space key manager, and get it to read out
the final stats before deleting the SA.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
