Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F399C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 20:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4966D206C0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 20:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y5a00ORe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbgF2UuD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731475AbgF2TNi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:13:38 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F70AC008761
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2020 01:53:15 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so17106661ljv.5
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2020 01:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4N3NxnIHOlrbNxccCBL6Rnaa4Jaah/lF3KoyD4lJEU=;
        b=Y5a00ORenb6fp3CAxkO2RdJhoSHYbhVhEF70f/Bopch+KginR0LyR2AYL2cW7YtzgE
         4IBv/FjDw/X3ITMn7zE1q91GX2itg9qJ9m1DAIGJ86/5nVIvAESpGJNbQXrsq5JVOY8Q
         E02Bdpx76U4cBBUxa7dA3EhR/bJGYosrKez06N2Q11o/6BTmZ2nXQj9qA1UoQ07YuyQr
         ZMQ9sNVxKVhUWhtR+8oz6o4ZpoXBu+EE8pARkgtqi8O3gLxn7g4K5ldEY4iH6/+z7nqg
         CXwAu2lLH9//ry9zSvJFNwpPG3zUVVSA+8mEmzkmKQxRlv5HRIrcnw1SNTabSrO8WFfd
         aMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4N3NxnIHOlrbNxccCBL6Rnaa4Jaah/lF3KoyD4lJEU=;
        b=XWgtJgxCEKFgL8vEF75pHT/wUTNCxKfR7gTLZFechwe4l+Phrl8woXYT/eaanv3eRF
         cdhak7gymVFnLDsl4Ps2WieBy595mlg1Tsg0T9HmS9hu4u16NE9UvL1PlA8LiPFjjGLt
         VfkrQ5zhqBRbGyHgh3NWHs39+D0PqEIg8KJvGTyS069wIUX4lywHVL8T9rBdKov2takA
         Iu9G+ercMwQ9wqWD8jwQJmXf0spRjwca3TTZ2AzTSMBBaM2KZur6OrHtgP6WavTbk2/X
         75KBKjjH19xw6gA531BJBy4vUUOQTdKm5Lp8OcbO8ikYULObKRsDidJ3LW3YwJY2mNFL
         GUDA==
X-Gm-Message-State: AOAM533y/GJLYXvgJu8sDSuZkizejI9tGDTVxJlGqB8jQle3ioDImTI9
        PJcuKEyeJVRQJJdN/NKeI+WTo4xEifvoNGqmNoW7jg==
X-Google-Smtp-Source: ABdhPJy1rQQ5J/jylQniMmYImqn4+s/8Ebp+FCxmpDIQBCBP4TtEoH93hKJjC0A/2GKgXMfoOCLC5zfzCmLvoKP0M2c=
X-Received: by 2002:a2e:b054:: with SMTP id d20mr7114033ljl.55.1593420793493;
 Mon, 29 Jun 2020 01:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvHFs5Yx8TnT6VavtfjMN8QLPuXg6us-dXVJqUUt68adA@mail.gmail.com>
 <20200622224920.GA4332@42.do-not-panic.com> <CA+G9fYsXDZUspc5OyfqrGZn=k=2uRiGzWY_aPePK2C_kZ+dYGQ@mail.gmail.com>
 <20200623064056.GA8121@gondor.apana.org.au> <20200623170217.GB150582@gmail.com>
 <20200626062948.GA25285@gondor.apana.org.au> <20200627083147.GA9365@gondor.apana.org.au>
In-Reply-To: <20200627083147.GA9365@gondor.apana.org.au>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 29 Jun 2020 14:23:02 +0530
Message-ID: <CA+G9fYszuzVq5P+10OA1biMQHQ-4tTDtqoOBHHdVMQXrwnWFJQ@mail.gmail.com>
Subject: Re: [LKP] Re: [PATCH] crypto: af_alg - Fix regression on empty requests
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        LTP List <ltp@lists.linux.it>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 27 Jun 2020 at 14:02, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jun 26, 2020 at 04:29:48PM +1000, Herbert Xu wrote:
> >
> > Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Reported-by: kernel test robot <rong.a.chen@intel.com>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

I have applied your patch and tested on Linux-next on arm, x86_64 and i386.
All LTP crypto tests got passed.

---
patch -p1 <  crypto-af_alg---Fix-regression-on-empty-requests.diff
patching file crypto/af_alg.c
patching file crypto/algif_aead.c
patching file crypto/algif_skcipher.c
patching file include/crypto/if_alg.h

Test output:
af_alg02.c:33: PASS: Successfully \"encrypted\" an empty message
af_alg05.c:40: PASS: read() expectedly failed with EINVAL

Test results summary:
af_alg01: pass
af_alg02: pass
af_alg03: pass
af_alg04: pass
af_alg05: pass
af_alg06: pass

ref:
https://lkft.validation.linaro.org/scheduler/job/1532020#L1413
https://lkft.validation.linaro.org/scheduler/job/1532019#L1516
https://lkft.validation.linaro.org/scheduler/job/1532026#L935

-- 
Linaro LKFT
https://lkft.linaro.org
