Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70314C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 14:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8292084A
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 14:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfFQOyf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 10:54:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35666 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFQOyf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 10:54:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so11050957qto.2;
        Mon, 17 Jun 2019 07:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RMA/1P8Zy+Da3dPZGY3jn8d8f/ncPVG+9hhwRd3TORE=;
        b=G2/kpH6uBUZP5+fXzdhJzzOpP+YH9Hf65NU2qPLrc29QhGWtuc7waYZd0y+X+gnHDw
         94PLn8ZouId6ryZ9XcwOrTQmM+RMoT+gcJeP0x3HHK9PzenIEtgLHp5lxNa3uBl0Y9yu
         pw0es2UsEE/y6Criu/RQYabj/sy5JrpkjUCtjBtB4QKsknI44os/Fb8VzmY9KbvbIanQ
         8PjhfZbegr+c8eTShSzm4Qs0Qk0mZKLcNWrT0f/vyFx/WLcRyKkZFbHk0HuXGn0Dt2S5
         M/zfwCiYrlhC6M5eNghTE5D0sk3G4C0Vf1eXVRkb77dcja9g8muIGIwxMVVvgQVSekF7
         QNzg==
X-Gm-Message-State: APjAAAXe8Ghl7BCuT//sKIRhmve3lRCweMMpyNTMMuV8rxWRKKnBNjzc
        aKu+EKNQiVtU2Rde2NJZweepO+kcttgAaS5Apc8=
X-Google-Smtp-Source: APXvYqwPjKhflMS1pvQDACBjClIuiv+1sDx/EJFdmh7iZpy1Q50p3hBSY1qU/lhBwpeDglWlRHqI1emBibVmJ8psd8U=
X-Received: by 2002:a0c:b758:: with SMTP id q24mr21924859qve.45.1560783273755;
 Mon, 17 Jun 2019 07:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190617132343.2678836-1-arnd@arndb.de> <20190617140435.qjzcouaqzepaicf4@gondor.apana.org.au>
 <CAK8P3a07Vcqs+6Rs2Ckq_itWfGKUv+_pdgdis9eSujCGHQgFkQ@mail.gmail.com> <20190617142419.yw4w5w344tf6ozrb@gondor.apana.org.au>
In-Reply-To: <20190617142419.yw4w5w344tf6ozrb@gondor.apana.org.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 17 Jun 2019 16:54:16 +0200
Message-ID: <CAK8P3a0G2K4u-Sh495O7_nfc6zydtZBTOJcq19g3YYQA2ZMKFA@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 4:24 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 17, 2019 at 04:10:44PM +0200, Arnd Bergmann wrote:
> >
> > In most cases, this ends up in favor of clang (concerning the stack
> > warning size limit) because most variables are small, but here we have
> > a large stack object (two objects for the hash fuzzing) with a large redzone.
>
> Oh I missed the fact that there is another large stack variable
> further up the stack.  So what happens if you just convert that
> one and leave the shash descriptor alone?

Just converting the three testvec_config variables is what I originally
had in my patch. It got some configurations below the warning level,
but some others still had the problem. I considered sending two
separate patches, but as the symptom was the same, I just folded
it all into one patch that does the same thing in four functions.

       Arnd
