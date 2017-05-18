From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] crypto: drbg wait for crypto op not signal safe
Date: Thu, 18 May 2017 13:09:34 +0800
Message-ID: <20170518050933.GA32409@gondor.apana.org.au>
References: <1494503626-15877-1-git-send-email-gilad@benyossef.com>
 <1494503626-15877-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Eric Biggers <ebiggers3@gmail.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41826 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751155AbdERFKQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 01:10:16 -0400
Content-Disposition: inline
In-Reply-To: <1494503626-15877-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 11, 2017 at 02:53:43PM +0300, Gilad Ben-Yossef wrote:
> drbg_kcapi_sym_ctr() was using wait_for_completion_interruptible() to
> wait for completion of async crypto op but if a signal occurs it
> may return before DMA ops of HW crypto provider finish, thus
> corrupting the output buffer.
> 
> Resolve this by using wait_for_completion() instead.
> 
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: stable@vger.kernel.org

This patch doesn't even compile.  Please test your work first.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
