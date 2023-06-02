Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE60CC7EE24
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 16:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbjFBQLS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 12:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbjFBQK5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 12:10:57 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282E010E5
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 09:10:11 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f3b4ed6fdeso2976660e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 09:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685722190; x=1688314190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AeFT72TXfXAwhYRh1W0GvqbmonxTxhIBsAfBN2yDsw0=;
        b=d5xN3B8XR5vGIWsQm4Vs7a1dtkZNy5nYvd4LEWmq6303Q6HHrfgEmFxPsToRFiRxl5
         511Ba2q1rBQypNVdPN6W8NB2gRGACwVHpOj9QC/TmIU3XJckfJIU3tzW6+RooU5If8OP
         kyijF1OfAHU2QzGjZ3FLl/SKtByZVA30ZELec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722190; x=1688314190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AeFT72TXfXAwhYRh1W0GvqbmonxTxhIBsAfBN2yDsw0=;
        b=UCmKl+bs3twtr+qc4jVuIhhJ54LJbKouqztFYYSlWT4pP7iVQhlcfpdCEw5lZHxs1z
         rp5icVu61Lu7qNLcuY75EMhtmzDzOdi+5OQgSg2OxCZiSiC1wnrQgECww4HVpLa4dLKy
         /9zX6Nb/63qixAtCo95vtZFeGHn9bLGx2tTEqGkSSSkhMe4rgkR/zPfNYVDP4CCUxSQL
         Snk33v7FPFLzzbzg6nRrVfcTGFc3vbWBm2PHVYygw+ivfOYmAjLkqQCAuFiy6qvfjNaN
         jF85gLf4ZyBOuTfRdHkdtwdSNywXWXNVF68ojaSq8UnafR+l7T3NDOhN1mqgwQuTd5g0
         5VkA==
X-Gm-Message-State: AC+VfDyKGg6wbj37pD4ngXckB8v9/SAbgxduUt0D2aX/dN09DRq1p/KC
        /LADW6Aeg7NMomcajKHYYWavD27TAIVW5//R6IYSJvE2
X-Google-Smtp-Source: ACHHUZ7v0fr6ZP3Bg8Y32vGTjYbYHVONo1mkrYdXQ4abaYNzBiVZ4cwL72HnjeXaS4MpSYPnnrWKnw==
X-Received: by 2002:ac2:551e:0:b0:4f3:89da:c374 with SMTP id j30-20020ac2551e000000b004f389dac374mr1868989lfk.1.1685722190080;
        Fri, 02 Jun 2023 09:09:50 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id j4-20020ac25504000000b004f3945751b2sm206179lfk.43.2023.06.02.09.09.49
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 09:09:49 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4f3b4ed6fdeso2976612e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 09:09:49 -0700 (PDT)
X-Received: by 2002:ac2:5d6c:0:b0:4f2:509b:87ba with SMTP id
 h12-20020ac25d6c000000b004f2509b87bamr2034590lft.50.1685722168361; Fri, 02
 Jun 2023 09:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230531130833.635651916@infradead.org> <20230531132323.722039569@infradead.org>
 <70a69deb-7ad4-45b2-8e13-34955594a7ce@app.fastmail.com> <20230601101409.GS4253@hirez.programming.kicks-ass.net>
 <14c50e58-fecc-e96a-ee73-39ef4e4617c7@gmx.de> <CAHk-=whL65CLuy9D9gyO608acM5WLWo_ggAMP1cGu2XvyC0-hA@mail.gmail.com>
 <20230602143912.GI620383@hirez.programming.kicks-ass.net>
In-Reply-To: <20230602143912.GI620383@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jun 2023 12:09:11 -0400
X-Gmail-Original-Message-ID: <CAHk-=wj7K3Q9WbBtQHiOXKc04SRjeOF+TRopkwVoQh_CFU+kvg@mail.gmail.com>
Message-ID: <CAHk-=wj7K3Q9WbBtQHiOXKc04SRjeOF+TRopkwVoQh_CFU+kvg@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] parisc/percpu: Work around the lack of __SIZEOF_INT128__
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Helge Deller <deller@gmx.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, dennis@kernel.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Heiko Carstens <hca@linux.ibm.com>, gor@linux.ibm.com,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        borntraeger@linux.ibm.com, Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        suravee.suthikulpanit@amd.com, Robin Murphy <robin.murphy@arm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>,
        Sam James <sam@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 2, 2023 at 10:40=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> Something like so then?

Ack. I think it would be much cleaner if we would have it as part of
the Kconfig file and architectures could just override some
GCC_MIN_VERSION value, but that's not the universe we currently have,
so your patch looks like the best thing to do.

              Linus
