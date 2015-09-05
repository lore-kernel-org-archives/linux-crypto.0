From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/testmgr: don't copy from source IV too much
Date: Sat, 5 Sep 2015 10:04:12 +0800
Message-ID: <20150905020412.GA13392@gondor.apana.org.au>
References: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
 <20150903132057.GA31317@gondor.apana.org.au>
 <55E9C9F2.5060402@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrey Ryabinin <aryabinin@odin.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49107 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbbIECEk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Sep 2015 22:04:40 -0400
Content-Disposition: inline
In-Reply-To: <55E9C9F2.5060402@odin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 04, 2015 at 07:42:26PM +0300, Andrey Ryabinin wrote:
> 
> But noticed that some algs don't set ivsize (which makes it zero).
> E.g. "ecb-cast6-avx" doesn't set it, but test vectors (cast6_enc_tv_template[], cast6_dec_tv_template[])
> have .iv of 16bytes.

ECB should always have an IV size of zero so this is correct.
If the test vectors contain an IV it'll simply be ignored.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
