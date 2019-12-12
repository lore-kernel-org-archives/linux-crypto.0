Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198BCC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 17:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4E4D22527
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 17:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576171318;
	bh=uRJSiDhmjJYSkb9mBEfv9rnD8eQ3WJ4UmRiDLVfLaKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=q/aJcu+vajmB1YZRbicma4lN5BqjHkhiXhL0Wrp/axI6mIIjNF3m+EIhVmei/H7if
	 YX2XpZ8wRLkIkxHLTQpiFOSfnUAxgSUQ2lMpIBo71Lr1t90c30w7lbE/8mvA5kGD5r
	 vCc3vDHL9dH4A6vOQX2D0RLKuUfKzAWCChLmS8nE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbfLLRV5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbfLLRV5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 12:21:57 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 823A321655;
        Thu, 12 Dec 2019 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576171316;
        bh=uRJSiDhmjJYSkb9mBEfv9rnD8eQ3WJ4UmRiDLVfLaKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ikUaAwMc2HbYkE54w4YkzmolUgMQzAjAcSSG0Sirsk3YSh/VPPU+Ev5iLVMUiIToB
         9cF35ZZbNvS9KMPgXCWx0cxT9VgPe5YAW6kb4b1NUVnlaCrwsbeAkSPGXPU/YTb4S9
         l00OS8KgOkh9wUyr4bt56b6GzCqCoFNArQksNcNs=
Date:   Thu, 12 Dec 2019 09:21:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: adiantum testmgr tests not running?
Message-ID: <20191212172154.GA100563@gmail.com>
References: <CAHmME9o4s3B_KUKYAzJr6xNaKdiLSGMJz-EyzP7RUptya1FqMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9o4s3B_KUKYAzJr6xNaKdiLSGMJz-EyzP7RUptya1FqMg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On Thu, Dec 12, 2019 at 04:33:25PM +0100, Jason A. Donenfeld wrote:
> Hey Eric,
> 
> I had to do this ugly hack to get the adiantum testmgr tests running.
> Did you wind up doing the same when developing it, or was there some
> other mechanism that invoked this naturally? I see all the other
> primitives running, but not adiantum.
> 
> Jason
> 
> diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
> index 8beea79ab117..f446b19429e9 100644
> --- a/crypto/chacha_generic.c
> +++ b/crypto/chacha_generic.c
> @@ -117,7 +117,9 @@ static struct skcipher_alg algs[] = {
> 
>  static int __init chacha_generic_mod_init(void)
>  {
> - return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
> + int ret = crypto_register_skciphers(algs, ARRAY_SIZE(algs));
> + BUG_ON(alg_test("adiantum(xchacha20,aes)", "adiantum", 0, 0));
> + return ret;
>  }
> 

You need to do something which instantiates the template, since "adiantum" is a
template, not an algorithm itself.  The easiest way to do this is with AF_ALG,
e.g.:

python3 <<EOF
import socket
s = socket.socket(socket.AF_ALG, 5, 0)
s.bind(("skcipher", "adiantum(xchacha12,aes)"))
s.bind(("skcipher", "adiantum(xchacha20,aes)"))
EOF

All the other templates work this way too.  So for more general testing of the
crypto API, I've actually been running a program that uses AF_ALG to try to bind
to every algorithm name for which self-tests are defined.

- Eric
