Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853D7C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 10:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbjJ3KbS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 06:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjJ3KbR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 06:31:17 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B22B8E
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 03:31:15 -0700 (PDT)
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BF3603F04D
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698661869;
        bh=9khDIoutyVVO4OorlUjWR4zCGtUfevyQIKBqlCrcSI4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=b7jjbcevW6TEkqWllgoeUjGHjvOfuI2jC4XmBXk3cf+A/gWbxjNdCqGzR22Hhrh1R
         G+Uj/SK5yzOJQQ56W7FKEfVpC+kVf9JNz3JDlDsveW5Z+FTxPzh7duJ7mTyggJnyYR
         fDhbxAkgvqro6bPkppuEc2mRT5fe6zk65G7WI98PjDAU0wvQf6C2T4Yt9gkmtzIb8T
         t9xUpRCB+Eq+XVyc1fp7O8JsfEmJ5zChC9yMzcI6VONO80afizsQc1pojkoXg4W/Ae
         AdjLA1CSBfF7NmffTwj4gWfYHD15p9ZJBb3vh8aILB5fqpCDID/fltYdYEnZpWacnQ
         8SozQFnZud69Q==
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50911cc75adso1976020e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 03:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698661868; x=1699266668;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9khDIoutyVVO4OorlUjWR4zCGtUfevyQIKBqlCrcSI4=;
        b=OH2vQBFGD6orECetqGoQNaGwIVCxOzVjMUpwSOzyawQrSh1i1dZPbnch2Siwmxvk76
         wTaQcJMriXsHpByg+Mu1LG4eKWHhshQ2jKwKHbuNqkxvYSWGzm93tatvybRKDRTg7W7s
         jDxOR6MVWKHkKzPXByHPPlQ5L8lji27EuoiQE1qTvmkmkh4WRrC/LKtb0hkUPrXBvhk9
         aexkKojeUzI+9yQWyKYsTIXlaEL9VTcJfbPRnTMdMTENUDlGBz/pjn3G9zg/U6zoizpj
         DK6KVwqPexLH/J/oTK5/ADjJ7XlvoZHSd6RmhAjVyJrR2v/iJEIoEJ4Ux4jGuKkXkCWU
         TkSw==
X-Gm-Message-State: AOJu0YybbMhwcJUNzg8sV2l9q9dt7LnvTQtFkPgQq059V8oCiN/gNoby
        MaAjFKx4mEm4Bs3w1SwFlBNZ76Qq+On/Pe74QgKIgGxfsK0qlwiaWTLx5n62jQ6Wg64Ra2+b1H5
        hig1xhpLZCFXSchHMAc6jeyB6gZozbHeSOc9ldGfEa/3980YNTECqiVeQSg==
X-Received: by 2002:a19:ca45:0:b0:502:9fce:b6da with SMTP id h5-20020a19ca45000000b005029fceb6damr6117132lfj.21.1698661868747;
        Mon, 30 Oct 2023 03:31:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzmok2NC2UFhT5xqTcur1IDEbtbIhjT5/OR1Odr6djEXj7xXwohl+4ifXuKC+ZtvwN2tG9K+tbsxMsHwtT0U8=
X-Received: by 2002:a19:ca45:0:b0:502:9fce:b6da with SMTP id
 h5-20020a19ca45000000b005029fceb6damr6117116lfj.21.1698661868368; Mon, 30 Oct
 2023 03:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
 <20231029204823.663930-2-dimitri.ledkov@canonical.com> <6413919.eMfrkXpHmx@tauon.chronox.de>
In-Reply-To: <6413919.eMfrkXpHmx@tauon.chronox.de>
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date:   Mon, 30 Oct 2023 12:30:32 +0200
Message-ID: <CADWks+Z0b8GPSg37=TQK_5LqVejC_CzbOxn_TUsvkQ45TOyuYw@mail.gmail.com>
Subject: Re: [PATCH 2/4] crypto: drbg - update FIPS CTR self-checks to aes256
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, simo@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Oct 2023 at 12:23, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Sonntag, 29. Oktober 2023, 21:48:21 CET schrieb Dimitri John Ledkov:
>
> Hi Dimitri,
>
> > When originally drbg was introduced FIPS self-checks for all types but
> > CTR were using the most preferred parameters for each type of
> > DRBG. Update CTR self-check to use aes256.
> >
> > Fixes: 541af946fe ("crypto: drbg - SP800-90A Deterministic Random Bit
> > Generator") Signed-off-by: Dimitri John Ledkov
> > <dimitri.ledkov@canonical.com>
>
>
>
> > ---
> >  crypto/drbg.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > index 2cce18dcfc..b120e2866b 100644
> > --- a/crypto/drbg.c
> > +++ b/crypto/drbg.c
> > @@ -1478,8 +1478,8 @@ static int drbg_generate(struct drbg_state *drbg,
> >                       err = alg_test("drbg_pr_hmac_sha256",
> >                                      "drbg_pr_hmac_sha256", 0, 0);
> >               else if (drbg->core->flags & DRBG_CTR)
> > -                     err = alg_test("drbg_pr_ctr_aes128",
> > -                                    "drbg_pr_ctr_aes128", 0, 0);
> > +                     err = alg_test("drbg_pr_ctr_aes256",
> > +                                    "drbg_pr_ctr_aes256", 0, 0);
> >               else
> >                       err = alg_test("drbg_pr_sha256",
> >                                      "drbg_pr_sha256", 0, 0);
> > @@ -2017,7 +2017,7 @@ static inline int __init drbg_healthcheck_sanity(void)
> > return 0;
> >
> >  #ifdef CONFIG_CRYPTO_DRBG_CTR
> > -     drbg_convert_tfm_core("drbg_nopr_ctr_aes128", &coreref, &pr);
> > +     drbg_convert_tfm_core("drbg_nopr_ctr_aes256", &coreref, &pr);
> >  #endif
> >  #ifdef CONFIG_CRYPTO_DRBG_HASH
> >       drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
>
> I am not sure again whether this warrants a "Fixes" tag, because the first
> modification is in a commented-out code section and the latter again intends
> to test the DRBG thresholds and thus just needs "a" DRBG.
>

Agreed, it is more of a reference. But yes, I don't believe this needs
to trigger stable backports - because yes it is like dead code, or
fips only code which majority kernels don't do. Maybe I should
reference that commit in description only?

> Anyhow:
>
> Reviewed-by: Stephan Mueller <smueller@chronox.de>
>
>
> Ciao
> Stephan
>
>

-- 
okurrr,

Dimitri
