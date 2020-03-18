Return-Path: <SRS0=FtFJ=5D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DDAC10DCE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Mar 2020 15:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6626920674
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Mar 2020 15:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="P9ymWRwz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgCRPxT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:53:19 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35604 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRPxT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Mar 2020 11:53:19 -0400
Received: by mail-oi1-f195.google.com with SMTP id k8so24829237oik.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2020 08:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/EsTMXwx4kqSqfiOJ+5VqxPy8ESW5kmMEvWmLUqRM04=;
        b=P9ymWRwzUtq3KgWOv+H7Pij9fdoc090XCS4OPxI9A1QLtCEKaCE0cbmT4EYt3eDtCA
         sb2dGnxnhqks0HWZ2ytr3VS8zMUcYfLKcIHEA9PbfqWjyRXfMwvq+5eqQXlSIW8W7DPU
         BawYthbfaq3FoiLzwKCXiAw3J1amj2PcUSsDmvftnx0MJyWPGWH6Cr0DP+O2wJSO9WV8
         JBJr1ILAo0xSr2VJcQVP2A9j4DLWMFiLIep3rETwXfcXbulb7bH5K9kGiW1Gk0idGUJU
         c55Wnogd3bxGL9X742NwMMBylQNk5i+sAOuUYe/Lv4W+N7fnnBhIJMkdHG+GIXnH7Gia
         ++Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/EsTMXwx4kqSqfiOJ+5VqxPy8ESW5kmMEvWmLUqRM04=;
        b=gICJuidxPNsGkCJ9Q3E7u1kNHCsaANxBkQoRyJ3IPI4Tl+UlZfu4pKf7+AwlsG99GE
         aH31FRVEjYoX/hVFJ2sVVORkW95oaXxXwkb42UWdfy/vNhesk6Thk9irKNAvwKa+Eo8L
         byniaLHbSJjZW2DmwMrZDxDewqNol/4FqX4zpGCiDw9+oGmkt36y16/lOJjsyMVVhH2c
         B8SUfhCqKVvxfHpWRbK1r31FQfZQvNwUDhnyRp7fk+LZ3WxWFcl/S4sNiiNfYMe1gFnN
         sluTKD4hbWxis2pv/XCeRRfvD8Q8u4y1IYni2DJxN3pAljrFNF2HOpWckqHlk1BkhcBb
         nsxA==
X-Gm-Message-State: ANhLgQ1HtLOyPxQNDlInZpPTdMgKpxZ+AzkTiBU/Fumj496tDioKDHpm
        MZv9t4PWbFBGT8Y4IfmJ9QKVM7fEvLlwNOgatSJ6OdjNcHs=
X-Google-Smtp-Source: ADFU+vutWXljLwy4LQhxFZY3HNaRb6NFkXajAdj6p1EAqEqrSw29FuzWdXXrb9ZA8cxm0hL7zE3UOGk1lBceIzIXLe0=
X-Received: by 2002:a05:6808:90f:: with SMTP id w15mr3813640oih.0.1584546798751;
 Wed, 18 Mar 2020 08:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200317061522.12685-1-rayagonda.kokatanur@broadcom.com>
 <20200317061522.12685-3-rayagonda.kokatanur@broadcom.com> <CAPcyv4j1BJStqSZvbNdjHs0RoSWWtk06ieQAXOUwJCjP8mqBLQ@mail.gmail.com>
 <CAHO=5PE9SLg2O1fp5YUp0Z0sbNfKNiu5kGXBRtHmGyXRW5w3pg@mail.gmail.com>
In-Reply-To: <CAHO=5PE9SLg2O1fp5YUp0Z0sbNfKNiu5kGXBRtHmGyXRW5w3pg@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 18 Mar 2020 08:53:07 -0700
Message-ID: <CAPcyv4j3Q6n8sj=ATtDL0cpHvMqZPaBxuZ13pgUsvhXWqDh1BA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] async_tx: fix possible negative array indexing
To:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Allison Randal <allison@lohutok.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 18, 2020 at 12:17 AM Rayagonda Kokatanur
<rayagonda.kokatanur@broadcom.com> wrote:
>
> On Tue, Mar 17, 2020 at 11:06 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Mon, Mar 16, 2020 at 11:16 PM Rayagonda Kokatanur
> > <rayagonda.kokatanur@broadcom.com> wrote:
> > >
> > > Fix possible negative array index read in __2data_recov_5() function.
> > >
> > > Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
> > > ---
> > >  crypto/async_tx/async_raid6_recov.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
> > > index 33f2a8f8c9f4..9cd016cb2d09 100644
> > > --- a/crypto/async_tx/async_raid6_recov.c
> > > +++ b/crypto/async_tx/async_raid6_recov.c
> > > @@ -206,7 +206,7 @@ __2data_recov_5(int disks, size_t bytes, int faila, int failb,
> > >                 good_srcs++;
> > >         }
> > >
> > > -       if (good_srcs > 1)
> > > +       if ((good_srcs > 1) || (good < 0))
> > >                 return NULL;
> >
> > Read the code again, I don't see how this can happen.
>
> This case can happen and it is reported by coverity tool.
> In the for loop , the condition "if (blocks[i] == NULL)" true all the
> time then variable 'good' will be -1.

Just because coverity reports it does not make it true. Please go read
the full call path that gets us to this call and identify how all
entries in blocks[] could be NULL. Hint, the answer is in how
async_raid6_2data_recov() calls __2data_recov_5().
