Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7C8C1975A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 17:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDAB820724
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 17:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="CdO56Nlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCQRgw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 13:36:52 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34042 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgCQRgv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 13:36:51 -0400
Received: by mail-ot1-f67.google.com with SMTP id j16so22540413otl.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2020 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uyRodrihPwb1FBNSB3Gz7xxv86LOWnjsXzCThasgnpY=;
        b=CdO56Nlx77tkHtyKo0Rn23jMTmmE7Qwa1DvqNje5e8ZRYdGwKISYTIcApiLSqkONmo
         pTE0Q9ejOxxPIPydctRFrMcP/m8MFijjtK1x+kpz+r5Yy4iUamMluTvjYT6ogFTS8+DB
         cKojHssTy1JUrU82D1DmLY0lZRIzZI0cNva1Y28zNFNqbRfhErvrN9QA0Rs3ogmnWaoj
         kTyhHzBpyCA7Y3Nq5/tdFwulGz7d3z1PU91jzoUaICKmaNazuEVB3hjg7ZZ0EcwsUSBb
         oSTQCK/8A9covEchS2IHHDKtKYM0OhQlU+2vApxXNOB/MJ0eonAIfmuu5MnHgWIeuxlB
         ELkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uyRodrihPwb1FBNSB3Gz7xxv86LOWnjsXzCThasgnpY=;
        b=AXVULcoFzc7LWgLd3/wBD6sxDUl0s5m0U3Nr0ySGvOadNZV0z47f+3qirIJMYDEpaX
         zt63BhkR2x5k5KCsAD36zxDiG99TUPZveFtuWVep0nkrTGZEm0HxO0qPU7sJHprLnuf9
         LRCgctyThWqIQsDxewCWXjWln7QAaIwK/uXvN0FQYTvAzEPufBhcc2TO45Vr2LlvUP3w
         ba/6C+7uxqtYCOwW2X2VKoA2NBm4kMFszRqJwbZGBaWrwAO/C7c8/idB6OV0joSgJrRD
         T7+Jqf0m6Cnjl2uPNMVqu/5R9kiUNPKkk+1kAjGv0ne/t1LPEbBS1TnZU10CD0NU8tX6
         AtJw==
X-Gm-Message-State: ANhLgQ2ENIei+NPjLX5HTu7QQB0w/+UdwnuQuFe8g1jkCYz2EOXqcV4l
        tD/uzZf0ddkdHQf0qoXNuCuX2hOzG3Jw7a3yJtdjNA==
X-Google-Smtp-Source: ADFU+vvxWbsurBzkkh+AKhjVD5kectkD8E39fsU56gLAllFVs+GBU8Qz5XC+16zuMJlxEA0YygvgbK4YDa69ymJcTO4=
X-Received: by 2002:a9d:5d09:: with SMTP id b9mr281483oti.207.1584466611366;
 Tue, 17 Mar 2020 10:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200317061522.12685-1-rayagonda.kokatanur@broadcom.com> <20200317061522.12685-3-rayagonda.kokatanur@broadcom.com>
In-Reply-To: <20200317061522.12685-3-rayagonda.kokatanur@broadcom.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 17 Mar 2020 10:36:40 -0700
Message-ID: <CAPcyv4j1BJStqSZvbNdjHs0RoSWWtk06ieQAXOUwJCjP8mqBLQ@mail.gmail.com>
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

On Mon, Mar 16, 2020 at 11:16 PM Rayagonda Kokatanur
<rayagonda.kokatanur@broadcom.com> wrote:
>
> Fix possible negative array index read in __2data_recov_5() function.
>
> Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
> ---
>  crypto/async_tx/async_raid6_recov.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
> index 33f2a8f8c9f4..9cd016cb2d09 100644
> --- a/crypto/async_tx/async_raid6_recov.c
> +++ b/crypto/async_tx/async_raid6_recov.c
> @@ -206,7 +206,7 @@ __2data_recov_5(int disks, size_t bytes, int faila, int failb,
>                 good_srcs++;
>         }
>
> -       if (good_srcs > 1)
> +       if ((good_srcs > 1) || (good < 0))
>                 return NULL;

Read the code again, I don't see how this can happen.
