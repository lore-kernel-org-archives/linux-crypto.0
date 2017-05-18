From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt: don't disable irqs and wait
Date: Thu, 18 May 2017 13:25:01 +0800
Message-ID: <20170518052501.GA32485@gondor.apana.org.au>
References: <1493108740-1642-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        gilad.benyossef@arm.com, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41854 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751155AbdERFZ2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 01:25:28 -0400
Content-Disposition: inline
In-Reply-To: <1493108740-1642-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 25, 2017 at 11:25:40AM +0300, Gilad Ben-Yossef wrote:
> The tcrypt AEAD cycles speed tests disables irqs during the test, which is
> broken at the very least since commit
> '1425d2d17f7309c6 ("crypto: tcrypt - Fix AEAD speed tests")'
> adds a wait for completion as part of the test and probably since
> switching to the new AEAD API.
> 
> While the result of taking a cycle count diff may not mean much on SMP
> systems if the task migrates, it's good enough for tcrypt being the quick
> & dirty dev tool it is. It's also what all the other (i.e. hash) cycle
> speed tests do.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Ofir Drang <ofir.drang@arm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
