Return-Path: <SRS0=wawN=VN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4D0C7618F
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 22:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC78B2173B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 22:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563315406;
	bh=GmeO5yi4t0dbDpMdkRaLpWH3QSHfNwKYnvWl9mEMk8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RfRYe5cZspfj2ZTN3+nWTJ1Pccf8bRRx1ODq07LzCzmF9RXHkQqq3jkGrE7JfbMPl
	 lrrkvfwKv07Ielpp46tK4G3c0/6Ipp9m2T1vRqHuTD1nIY/PxdnoMseZLxkrBn+TNx
	 m8gU1vBvdCBsP5o3PELCooR5ARTqDF4ZSu94IxKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfGPWQn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jul 2019 18:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbfGPWQn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jul 2019 18:16:43 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4482173B;
        Tue, 16 Jul 2019 22:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563315402;
        bh=GmeO5yi4t0dbDpMdkRaLpWH3QSHfNwKYnvWl9mEMk8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tt0P5e36/mP7FGqLuIvBPOZbAfs+Fog54vpMAd0uTKOr7S5qsWjrf5IN1qUxcr4JG
         l3R0ETaYpJ5CuqagosvhZhHCl/mNswKx5GKVNkH96NpHgFyxs4wE3lLj7bj2SCx+1U
         JM+d/Wb93fuhJkzLRJYe9uBN7oXSzEOrFkf/ycrk=
Date:   Tue, 16 Jul 2019 15:16:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
Message-ID: <20190716221639.GA44406@gmail.com>
Mail-Followup-To: Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

On Tue, Jul 16, 2019 at 05:46:29PM +0000, Horia Geanta wrote:
> Hi,
> 
> With fuzz testing enabled, I am seeing xts(aes) failures on caam drivers.
> 
> Below are several failures, extracted from different runs:
> 
> [    3.921654] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=40 klen=64"; expected_error=-22, cfg="random: inplace use_finup nosimd src_divs=[57.93%@+11, 37.18%@+164, <reimport>0.68%@+4, 0.50%@+305, 3.71%@alignmask+3975]" 
> 
> [    3.726698] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=369 klen=64"; expected_error=-22, cfg="random: inplace may_sleep use_digest src_divs=[100.0%@alignmask+584]" 
> 
> [    3.741082] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=2801 klen=64"; expected_error=-22, cfg="random: inplace may_sleep use_digest src_divs=[100.0%@+6] iv_offset=18"
> 
> It looks like the problem is not in CAAM driver.
> More exactly, fuzz testing is generating random test vectors and running
> them through both SW generic (crypto/xts.c) and CAAM implementation:
> -SW generic implementation of xts(aes) does not support ciphertext stealing
> and throws -EINVAL when input is not a multiple of AES block size (16B)
> -caam has support for ciphertext stealing, and allows for any input size
> which results in "unexpectedly succeeded" error messages.
> 
> Any suggestion how this should be fixed?
> 
> Thanks,
> Horia

I don't think drivers should allow inputs the generic implementation doesn't,
since those inputs aren't tested by the crypto self-tests (so how do you know
it's even correct?), and people could accidentally rely on the driver-specific
behavior and then be unable to migrate to another platform or implementation.

So for now I recommend just updating the caam driver to return -EINVAL on XTS
inputs not evenly divisible by the block size.

Of course, if there are actual use cases for XTS with ciphertext stealing in the
kernel, we could add it to all the other implementations too.  But I'm not aware
of any currently.  Don't all XTS users in the kernel pass whole blocks?

- Eric
