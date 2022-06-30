Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87035C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 23:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiF3XNC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 19:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiF3XNC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 19:13:02 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D73658FF5;
        Thu, 30 Jun 2022 16:12:54 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id b5so395355vkp.4;
        Thu, 30 Jun 2022 16:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wzi5h6x58xxiTOM4JQOJLqp79CEZINGU2wxWSzdeGE=;
        b=T1k18UQz97Za886MWmNdTZ31Trb5KRB8i8ySpMh3nvUETfHSkm6PkUkJlpOraKIAFF
         JwUbT9RQUDEprCQCJVYyvbpgTprNrdK/ctvlmd6tF79UnPzCiiSICxpI2fclQo6IUDHN
         RzypN/YSmNslojBpfGAFnSTf9TCvAt1ahOTtMKLL0SjUdkMfG1jNmzc2oP8xVlfLWpn+
         YasiC8k2NehFNK5kFQb2iIhvMYemKz5qvhy3H8ZQ7+6/MvCJ0me7eh0zR76V9r7GgkqK
         Mawx9caGjt8ZriU1TyYJMAeWusfldwN2vVNj0SEot5LeB11R+LPw30dkRogrAjLra14B
         vNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wzi5h6x58xxiTOM4JQOJLqp79CEZINGU2wxWSzdeGE=;
        b=Z3fR89aDTh3BTlumrVMsw9T/iJgh4alGz/FoVQ/mQ1qI158YHf6IR9w3ikwUIyMt2P
         a5PFPwZGN1xojGOkItoO8TcBw4bgl9r8JQebiHFmLveF5TAbrpSqXJajxrk5imM6q1l7
         wgyFC2FDXoexB6ObL8I1iC217oOMEbnRngh9uhjxHncGhPb0ACVXQlDl7zYKafdzMVrQ
         Yc1Hixy6V/YxzgfzARRxK6a+bfEtz5qTIKDuYq03sgSEo7t34+C8shDXCJBjU8f3y9Tk
         9a9cbZ7+VtOiIz5clkl5cnl/SavjVjJLs5NnJ/seXdWs2wFHA7VZmMvC7aw+ZiNnN105
         03zQ==
X-Gm-Message-State: AJIora9YEmJ4qBYAzh617OGYRqLvUktT0UUZmRELYckdnfzPRegRtrdF
        nXLEHwKqiGkkmozfZxWQfsFofhVgNSShYb8Riqc=
X-Google-Smtp-Source: AGRyM1uqSrtTxBJm8dLdR4nVtFvtwn94GbJBtiFqAp1OjuGYQgBOm0LJ2F5gCMK68n6yga2Ieiwm1p/9sI6cc1ZELPg=
X-Received: by 2002:a1f:78c5:0:b0:36c:aca5:94bc with SMTP id
 t188-20020a1f78c5000000b0036caca594bcmr9646531vkc.15.1656630773545; Thu, 30
 Jun 2022 16:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
 <Yr1JvG1aJUp4I/fP@gondor.apana.org.au> <C7191BC8-5BE0-47CB-A302-735BBD1CBED0@bytedance.com>
 <Yr1TuPM8yvJUoV9r@gondor.apana.org.au> <CC761178-556D-44F6-9479-5151C69476C8@bytedance.com>
In-Reply-To: <CC761178-556D-44F6-9479-5151C69476C8@bytedance.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 1 Jul 2022 07:12:41 +0800
Message-ID: <CACXcFmmxDVBrnp3_0UzN+VbAjDaUSNtoUBz5fM1Y4u5yqL89qA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
To:     Lei He <helei.sig11@bytedance.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, berrange@redhat.com,
        pizhenwei@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 30, 2022 at 4:37 PM Lei He <helei.sig11@bytedance.com> wrote:

> I have explained above why we need a driver that supports ECDSA, ...

I do not think we do. There are some security concerns.
https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm#Security
