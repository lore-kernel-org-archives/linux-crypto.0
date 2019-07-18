Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D94C7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 16:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DDB321851
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 16:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cAvaFYYn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfGRQTi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 12:19:38 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:38312 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRQTi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 12:19:38 -0400
Received: by mail-wr1-f41.google.com with SMTP id g17so29364193wrr.5
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2019 09:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r3GlNBVst9t8jRnUchWq6hQTL9LZJ3mgIWLVfA8vl2E=;
        b=cAvaFYYna2pGYnNS54i+OV8AOmRUdbYBQRhlr+pzWwELtS5raoT2vgQpCKklNjlWU6
         VLffcf3pnj+YtCji6HT/XXsk70R9wkcG6akf+SzUELz1oiWpVwe6DKpAknAUa1fM+MKp
         EkWxzOWiQgaAxMvXQPUQPP2X7pi7WW3TwJLPvWY4o0mIvh1pVSbMqeIiGV0WtoQrThnC
         AgIdDiTjjB6ajoy0MqfFMMixvHcCFMks2f6E+ayof3vHv3CrAIDJ2AId3EUaYCMeks6d
         7PvkM/cZkQuhm5r/GpSe4/xruRWpWC+TN5lACj4Ux6wIOCmnLzmFxBqytDy6E3mH9xww
         wSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r3GlNBVst9t8jRnUchWq6hQTL9LZJ3mgIWLVfA8vl2E=;
        b=asrZ8VAVx9kDuQjgSTqShAsaYM1PxV7WxFrgfmqhucFRgW9rHFtFbgAvmiOV8roScI
         0dZPJFkfen7YHUlM6ZTrgutjYtDoetm8H5a7xeKJwi2pd87MZqGun2fDACid+EHqpcn8
         aivyAlwyizkpfL6RXwsNq5v8UzVWHcHAwhksiRO0a41GMW9Y9uMXzdw6La2b4dmgr0I8
         SuIpBa0Xk42zhvlcrlWfBJHNAjPlHBOAc+BbahRldlcctCMNMh+CU6G2k2gBFKzRjb5r
         y4pCdAB7Ea7FWjbtI0Rh1/L/Iv0kp63JR9/tNRdrsv7WZ8sKlXEeAKYcAG2BhkyBJzzL
         GXQA==
X-Gm-Message-State: APjAAAXIEk+kLoSfYqpPBWRcgIsvlnlSIGUGCanyAX3Xp52lMl3pAVqO
        HjYaQvAtku+Wlj7aivnm7a9RGIPkckDI+9sdJQOJzw==
X-Google-Smtp-Source: APXvYqy+kJgsx7Ky1c4wR0zRzAVUExEZ4EmTRuTx/jL4Gnzjk7syrW8Z87IdmvbJM9CotVHG1uCzQctJPbQU97fHrPg=
X-Received: by 2002:adf:e8c2:: with SMTP id k2mr36541175wrn.198.1563466775933;
 Thu, 18 Jul 2019 09:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com> <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au> <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au> <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au> <MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
In-Reply-To: <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 18 Jul 2019 18:19:24 +0200
Message-ID: <CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Milan Broz <gmazyland@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 18 Jul 2019 at 17:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 18, 2019 at 03:43:28PM +0000, Pascal Van Leeuwen wrote:
> >
> > Hmmm ... so the generic CTS template would have to figure out whether it is wrapped
> > around ECB, CBC, XTS or whatever and then adjust to that?
>
> That's not hard to do.  Right now cts only supports cbc.  IOW
> if you pass it anything else it will refuse to instantiate.
>
> > For XTS, you have this additional curve ball being thrown in called the "tweak".
> > For encryption, the underlying "xts" would need to be able to chain the tweak,
> > from what I've seen of the source the implementation cannot do that.
>
> You simply use the underlying xts for the first n - 2 blocks and
> do the last two by hand.
>

OK, so it appears the XTS ciphertext stealing algorithm does not
include the peculiar reordering of the 2 final blocks, which means
that the kernel's implementation of XTS already conforms to the spec
for inputs that are a multiple of the block size.

The reason I am not a fan of making any changes here is that there are
no in-kernel users that require ciphertext stealing for XTS, nor is
anyone aware of any reason why we should be adding it to the userland
interface. So we are basically adding dead code so that we are
theoretically compliant in a way that we will never exercise in
practice.

Note that for software algorithms such as the bit sliced NEON
implementation of AES, which can only operate on 8 AES blocks at a
time, doing the final 2 blocks sequentially is going to seriously
impact performance. This means whatever wrapper we invent around xex()
(or whatever we call it) should go out of its way to ensure that the
common, non-CTS case does not regress in performance, and the special
handling is only invoked when necessary (which will be never).
