Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EDDC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 19:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB048206BB
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 19:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QPF2NDhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfICTQv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 15:16:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44443 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfICTQu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 15:16:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id 30so7708607wrk.11
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 12:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBst/PzcKHazEBTzFOINHVe/fZC6+oHesCadX7XbBW0=;
        b=QPF2NDhYwyppH6Ky42ZPl3wJNJ0hG3VrH/qMWKJNT7kXCTnpRDLUfCVs1QYDGM5eaI
         46oNdYPrKSnwq3Ju/RtVX4uw+8ZgLxmEoj6+V78IsZx4exsmD27Iu2xF3zZberjXTVw2
         vL2KikBY1kzZzgt1J0zx0PKDw8/oP/CwwCKvmnzL/0cxt9x2XYP1TeprVhmSycNd4oi9
         bMooHOJTblHagb7LIY7ZaPQAX7yHJKqXJcvUGYtHQpqtQxoNpLkw/TYGZ5spqbsheTBs
         y5HsHbeJOdMN7+b7bzuMSUg1l4qCURo2ACak2V1hnoFeeAOBTdoWzcPni02eATquQePb
         ljfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBst/PzcKHazEBTzFOINHVe/fZC6+oHesCadX7XbBW0=;
        b=X6PBoF6JsMKbzZ3sgJ/Nj81w64LHvKrzQi2AkwFs2vQekMGijWXsQp9bqz2Kk8KDTA
         DNOrh1IJ+wQ5QQZijmSpQPByOt4Kz5mR00EqBH4kde10/AtbF8/cVWVGuP54Gm+ZYqnt
         mjdUFe4etiENO2koqugYr8CNcVjwqcphM9HbhPeOG2JsQG8HQObIy3Fv2L4fHGeUCfcu
         uBYz+o/SFcuDLv1sjSgydnGuRsifslZCTDmN7SrPUw/98xPHWE0HOPqC/rcS7eYyOlU3
         1oYPWBo1M2r6dO7hiWlPP+CvV6NVyLgRdZYAric/IW0YHQQI+LB7c7UHVmk4eNdb4+GR
         ppwg==
X-Gm-Message-State: APjAAAW2bUQxQv3kAtMlW7Ldv6tAtIQs8wAcBBINVOVmZ3hMe4bPJgKU
        Ny4tLJU14t4bYajwOsR869dY/iOiknCyzcgFG3KUsw==
X-Google-Smtp-Source: APXvYqwpxhf+Qoc7sEiMbRBgC/7oVqCEsQjJITxxASlLOngz3EaN5uDzkvXJq3beLubl4iXw3k2o/reTbxu92Zi6LBc=
X-Received: by 2002:adf:9e09:: with SMTP id u9mr45284225wre.169.1567538208948;
 Tue, 03 Sep 2019 12:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-6-ard.biesheuvel@linaro.org> <20190903185537.GC13472@redhat.com>
In-Reply-To: <20190903185537.GC13472@redhat.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 3 Sep 2019 12:16:37 -0700
Message-ID: <CAKv+Gu8wr3HnP7uVDAOY=o54dWVkPoWm5V43LU_QNVMK_Cc2GA@mail.gmail.com>
Subject: Re: [PATCH v13 5/6] md: dm-crypt: switch to ESSIV crypto API template
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        device-mapper development <dm-devel@redhat.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 3 Sep 2019 at 11:55, Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Mon, Aug 19 2019 at 10:17am -0400,
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> > Replace the explicit ESSIV handling in the dm-crypt driver with calls
> > into the crypto API, which now possesses the capability to perform
> > this processing within the crypto subsystem.
> >
> > Note that we reorder the AEAD cipher_api string parsing with the TFM
> > instantiation: this is needed because cipher_api is mangled by the
> > ESSIV handling, and throws off the parsing of "authenc(" otherwise.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> I really like to see this type of factoring out to the crypto API;
> nicely done.
>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
>
> Herbert, please feel free to pull this, and the next 6/6 patch, into
> your crypto tree for 5.4.  I see no need to complicate matters by me
> having to rebase my dm-5.4 branch ontop of the crypto tree, etc.
>

Thanks Mike.

There is no need to rebase your branch - there is only a single
dependency, which is the essiv template itself, and the patch that
adds that (#1 in this series) was acked by Herbert, specifically so
that it can be taken via another tree. The crypto tree has no
interdependencies with this template, and the other patches in this
series are not required for essiv in dm-crypt.

If you feel it is too late in the cycle, we can defer to v5.5, but in
this case, we should align with Eric, which will depend on the essiv
template for fscrypt as well.

In any case, it is up to you, Eric and Herbert to align on this. For
me, it doesn't really matter whether this lands in v5.4 or v5.5. There
is some followup work based on this, but that is further out still.

Thanks,
Ard.
