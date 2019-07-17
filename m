Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CCCC7618F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 17:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFB02184E
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 17:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563384508;
	bh=N+UJ7GLw1U0qClVIF6cFvFlLcWkWCzd2SdKdwTn5VpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=WCYcfwpvXrt8PSYt16ggs+rUJRW7DMHXTV+2mMHkSBdY8xHp7VvsuOOZcWjxS4G4N
	 h+mhQtpYLRoNEI3swtm6YhhvcqfS7e6Nu0clluZKOdq/+/XvfE2eswl500Yan8WhZi
	 sbn9Bznca9HUjStqB6D7k8DGPBQk8a9tCKMo2bn0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388105AbfGQR21 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 13:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfGQR21 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 13:28:27 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DBBF21743;
        Wed, 17 Jul 2019 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563384506;
        bh=N+UJ7GLw1U0qClVIF6cFvFlLcWkWCzd2SdKdwTn5VpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YE2wx4/JYyxfTYWWnmlWVt958TMYn6Zd2YSukcN8+ozrb3s30q6/tjIRem5IxCBFz
         16VDbFDJWCXDGSqRqcwWIGSd7GyixZQb4Ow1a7rTmi7v1g4INAHoAq2mGopZuIrOG3
         8Lv/qfkEpQfpvfDp+raa/I0/QqQ/wsFMMFuKNpRU=
Date:   Wed, 17 Jul 2019 10:28:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
Message-ID: <20190717172823.GA205944@gmail.com>
Mail-Followup-To: Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 17, 2019 at 05:09:31PM +0000, Horia Geanta wrote:
> On 7/17/2019 1:16 AM, Eric Biggers wrote:
> > Hi Horia,
> > 
> > On Tue, Jul 16, 2019 at 05:46:29PM +0000, Horia Geanta wrote:
> >> Hi,
> >>
> >> With fuzz testing enabled, I am seeing xts(aes) failures on caam drivers.
> >>
> >> Below are several failures, extracted from different runs:
> >>
> >> [    3.921654] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=40 klen=64"; expected_error=-22, cfg="random: inplace use_finup nosimd src_divs=[57.93%@+11, 37.18%@+164, <reimport>0.68%@+4, 0.50%@+305, 3.71%@alignmask+3975]" 
> >>
> >> [    3.726698] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=369 klen=64"; expected_error=-22, cfg="random: inplace may_sleep use_digest src_divs=[100.0%@alignmask+584]" 
> >>
> >> [    3.741082] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=2801 klen=64"; expected_error=-22, cfg="random: inplace may_sleep use_digest src_divs=[100.0%@+6] iv_offset=18"
> >>
> >> It looks like the problem is not in CAAM driver.
> >> More exactly, fuzz testing is generating random test vectors and running
> >> them through both SW generic (crypto/xts.c) and CAAM implementation:
> >> -SW generic implementation of xts(aes) does not support ciphertext stealing
> >> and throws -EINVAL when input is not a multiple of AES block size (16B)
> >> -caam has support for ciphertext stealing, and allows for any input size
> >> which results in "unexpectedly succeeded" error messages.
> >>
> >> Any suggestion how this should be fixed?
> >>
> >> Thanks,
> >> Horia
> > 
> > I don't think drivers should allow inputs the generic implementation doesn't,
> > since those inputs aren't tested by the crypto self-tests (so how do you know
> How about implementation adding static test vectors and using them to validate
> the standard feature set that's not supported by the generic implementation?
> 
> > it's even correct?), and people could accidentally rely on the driver-specific
> > behavior and then be unable to migrate to another platform or implementation.
> > 
> People could also *intentionally* rely on a driver offering an implementation
> that is closer to the spec / standard.
> 
> > So for now I recommend just updating the caam driver to return -EINVAL on XTS
> > inputs not evenly divisible by the block size.
> > 
> I was hoping for something more constructive...
> 
> > Of course, if there are actual use cases for XTS with ciphertext stealing in the
> > kernel, we could add it to all the other implementations too.  But I'm not aware
> > of any currently.  Don't all XTS users in the kernel pass whole blocks?
> > 
> That's my guess too.
> 
> What about user space relying on offloading and xts working
> according to the spec?
> 

Sure, AF_ALG users could expect ciphertext stealing to work.  I don't know of
any actual examples of people saying they want it, but it's possible.

My point is simply that we add this, we need to find a way to support it in all
implementations.  It's not helpful to add it to only one specific driver, as
then it's inconsistent and is untestable with the common tests.

- Eric
