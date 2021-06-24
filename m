Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D586C49EA6
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 20:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D02C60FF1
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 20:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFXU6m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhFXU6m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jun 2021 16:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624568182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i/I9drIY4G6WoJ1Dm0KPQrMLUUgs0feVsDBEUSTvmMg=;
        b=Xis2p7FnQJWsWZYavL5l3YN8EJNbHan7NnTrURrRK/9FI4eEFKHi0/CsIsFvNRW3g5aovG
        TUvbdcFao8fI6vkO6d3JDQIErzmcg8uVYQQEQyPIH/HSYBS0FoToQArw1RhfpsAt1a4HVg
        DjzzNOKWk/K7wEuBB51Ju0jiUFChLl8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-JhXskFJtN6a2Uf4Gy8BKSg-1; Thu, 24 Jun 2021 16:56:20 -0400
X-MC-Unique: JhXskFJtN6a2Uf4Gy8BKSg-1
Received: by mail-ed1-f72.google.com with SMTP id dy23-20020a05640231f7b0290394996f1452so4040571edb.18
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jun 2021 13:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i/I9drIY4G6WoJ1Dm0KPQrMLUUgs0feVsDBEUSTvmMg=;
        b=UMO7S2R5HWwdzZp9FM7vbZFu8uzk5TaGRFgEgtA9blZbRI7vRNKtGKm75F7vKdTQyl
         2gOJRR8D0//JQTDPjaqDoHZytQfi0OrJq/zmv0viZ0KwOx/T7BLqmSrqs23oUww4Qitd
         IR4sDWnM/0xDBBgKZ/LeO/9tOMiOBe1zIBOmdlfc6zaZtOb811KbhjQotjjEsziAn9HR
         N1PN/Yt5k3XPkHiDbyrljAvZ+tVfIDX8HKMsn7lD9vxo1NKDMMk07oZa3h85PCkb0TNb
         WQzKfU3N0TJyS0AeVS4bTi+lG7zn8vzrwtgyU1vq6jYVedOCg4BQG3YMRuYNCzl0jesH
         Sk+Q==
X-Gm-Message-State: AOAM531ciHIkQBcBcvPPb6qCEr7n7xz9tTHnZD7PAGxlnQFnUlvh5csD
        eXToXR7EfHxaTjldQSgcf9NJAW2C137SrGkFV7iOLLqwkV0HM1gAKTlpIUGQUpZBPTQ/iQabRZk
        MCtnGe7gzodyYwURkM8oTWuJDtaVBYNkL5X5iB6ND
X-Received: by 2002:a17:907:75ee:: with SMTP id jz14mr7195288ejc.524.1624568179505;
        Thu, 24 Jun 2021 13:56:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqu91uvML15XM7YipBH6KliormoYiD0Xkr3JAnx2ZRWUO/+iuN2upoJCHk5Auok+YrqAFHcV/HzJP8TY7tupE=
X-Received: by 2002:a17:907:75ee:: with SMTP id jz14mr7195282ejc.524.1624568179347;
 Thu, 24 Jun 2021 13:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <3171520.o5pSzXOnS6@positron.chronox.de> <20210624143019.GA20222@gondor.apana.org.au>
 <11782290.ZbvtA0Mc7t@positron.chronox.de> <CAMusb+TVdPRtDCY88kREZgWNH8XtrJS4yLkK3UJFqhXgn36raw@mail.gmail.com>
In-Reply-To: <CAMusb+TVdPRtDCY88kREZgWNH8XtrJS4yLkK3UJFqhXgn36raw@mail.gmail.com>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Thu, 24 Jun 2021 22:56:08 +0200
Message-ID: <CAMusb+SaES3zBO7bugqHFn8dMWaW0pC7Z4R=0+ELsfgKgCfmzQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: DRBG - self test for HMAC(SHA-512)
To:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello, Stephan, Herbert,

Thank you for posting this patch. I would like to confirm that it
fixes the issue
in the RHEL8, i.e. RHEL8 kernel boots up in the FIPS mode with your patch.

Herbert, could you please consider adding this patch to your cryptodev-2.6.=
git?

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

On Thu, Jun 24, 2021 at 5:44 PM Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
>
> Considering that the HMAC(SHA-512) DRBG is the default DRBG now, a self
> test is to be provided.
>
> The test vector is obtained from a successful NIST ACVP test run.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/testmgr.c |  5 ++++-
>  crypto/testmgr.h | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 1 deletion(-)
>
>  ...

