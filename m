Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B277C04E84
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 02:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB90220873
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 02:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557973856;
	bh=wM9TNClsZacWcRgk7xTDNK0BYza1+wzkgKUWbX29yrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=w4a3gFcjQ2CSl+qXANU1jC64eqcc3oYYgGUxGz4vXbbAW6maNqvhmKir8fsUZXPgg
	 y1d0Ur/3P4KiYKXsbj437hMIgTfS4cv/xRJZL5CoCVpZgYzpq8nI538r/UZ0jMFcwk
	 k4tRTDV9p2GhrKwDLDRPJFj9Yo/qs1FIcH4zgVPI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfEPCay (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 22:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfEPCay (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 22:30:54 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA6720843;
        Thu, 16 May 2019 02:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557973853;
        bh=wM9TNClsZacWcRgk7xTDNK0BYza1+wzkgKUWbX29yrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MxuvneykuaKmPMU593+C93QcL9NYo0U3hIQ3jPbZUw9YVhW3okQwsdkSF23jGw6Vs
         E47HWjp4V2AI4tkf9BtC9jDKrM3vOeIuB5S4G1NQveQFaD7L9HQKfCIvLEr7cqAVpo
         Sa9VmLheapfklWiIY0Pu9I17VSa/syzd6uR1jgC8=
Date:   Wed, 15 May 2019 19:30:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] crypto: talitos - fix skcipher failure due to wrong
 output IV
Message-ID: <20190516023050.GA23200@sol.localdomain>
References: <a5b0d31d8fc9fc9bc2b69baa5330466090825a39.1557923113.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB34858D80A15D4B55F64570E398090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <29db3f20-f931-efc6-02a8-fe160ab8b484@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29db3f20-f931-efc6-02a8-fe160ab8b484@c-s.fr>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 08:49:48PM +0200, Christophe Leroy wrote:
> 
> 
> Le 15/05/2019 à 16:05, Horia Geanta a écrit :
> > On 5/15/2019 3:29 PM, Christophe Leroy wrote:
> > > Selftests report the following:
> > > 
> > > [    2.984845] alg: skcipher: cbc-aes-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> > > [    2.995377] 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
> > > [    3.032673] alg: skcipher: cbc-des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> > > [    3.043185] 00000000: fe dc ba 98 76 54 32 10
> > > [    3.063238] alg: skcipher: cbc-3des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
> > > [    3.073818] 00000000: 7d 33 88 93 0f 93 b2 42
> > > 
> > > This above dumps show that the actual output IV is indeed the input IV.
> > > This is due to the IV not being copied back into the request.
> > > 
> > > This patch fixes that.
> > > 
> > > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
> 
> It's missing a Fixes: tag and a Cc: to stable.
> 
> I'll resend tomorrow.
> 
> > 
> > While here, could you please check ecb mode (which by definition does not have
> > an IV) is behaving correctly?
> > Looking in driver_algs[] list of crypto algorithms supported by talitos,
> > ecb(aes,des,3des) are declared with ivsize != 0.
> 
> According to /proc/crypto, test are passed for ecb.
> 

Did you try enabling CONFIG_CRYPTO_MANAGER_EXTRA_TESTS?  There is now a check
that the driver's ivsize matches the generic implementation's:

        if (ivsize != crypto_skcipher_ivsize(generic_tfm)) {
                pr_err("alg: skcipher: ivsize for %s (%u) doesn't match generic impl (%u)\n",
                       driver, ivsize, crypto_skcipher_ivsize(generic_tfm));
                err = -EINVAL;
                goto out;
        }

For ECB that means the ivsize must be 0.

AFAICS the talitos driver even accesses the IV for ECB, which is wrong; and the
only reason this isn't crashing the self-tests already is that they are confused
by the declared ivsize being nonzero so they don't pass NULL as they should.

- Eric
