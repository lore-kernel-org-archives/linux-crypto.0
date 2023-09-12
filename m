Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DFCCA0EC3
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Sep 2023 07:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjILHPl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjILHPk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2023 03:15:40 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E990DE73
        for <linux-crypto@vger.kernel.org>; Tue, 12 Sep 2023 00:15:36 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6c0c675cb03so2790172a34.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 Sep 2023 00:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1694502936; x=1695107736; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWNdyPVUhTz83dozDzHZ2crOn6mqNkmosICyn2Ni38s=;
        b=i66c3lbgbghqJGC7PB+4j/Rqd7vq20QsbY3EvvQ+wB8fzgStQgLHyIdYnEDhprQ9Wa
         vWi676/nkiblofRZLiBcGJhYljWDj7bcFkRRpSbsjvc8KP+U3Dp5UN1U219qixaG8Y1V
         4dmkilGn1a6VNUjHUP8rRMrmVTpWpueyuDPqJd8cx075dQ+RpH04Jspaw3LCjHl3XatO
         8aRFUH0sd5qkwM/ApVE2G0r+7dQ1bZcpwzMqWD+aibQn51/UfPhsT9QSQ68PxO+Fwr2Z
         4TwBA6/7MbHNOifvF7ITtas5ySzEXme893OswmGg+79qNEEZLeoEOVX9Kw2hOPouLiyX
         Tg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694502936; x=1695107736;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YWNdyPVUhTz83dozDzHZ2crOn6mqNkmosICyn2Ni38s=;
        b=bvVeoz+G1Lwf7IveKP/9t0FjYIeugAwxuUNp4MHz3a7RMBGAdlGse3YlNBIuF0umsY
         euwx7pGxuhOBowH8lxQiHjsocJEEyNt0IDy7pZuA7Ze/FU4ezUpcj3+FS0TX/3Kvn+eq
         J2HI/hb59lA2NAYBXIB/Ui5sKLLPot8WTHqXDRPyMbcP8SgTuIAgyc634CiE1HqA00Yg
         HmKHBBPVmHG9+5uyONdHhd45mdW+D9lL0Bb56BzsJ7uI6mqrJHYDii9Ua821P5phkOa7
         btO+VYQ+tLk0eiyBJF7YoTrHP35Dc15FCa7YPRacCflRfYTYIGpMYibhtiRiL6HcUUS2
         nMlw==
X-Gm-Message-State: AOJu0YycbdjK2YbUPIMiLuCH/YQqWF8k6mK4ljPmQFaZz0yft/kNC1Oa
        pz9bMVku7mSJczu7cvKVFSW/zA==
X-Google-Smtp-Source: AGHT+IE7BxX2OK/dGjEsVl/1nUADEVB1Xh2UIPWp4SnQmZuKPv8XSDoqNWuJTTw59mIrzcsHuontdA==
X-Received: by 2002:a9d:7c8d:0:b0:6bc:b2a2:7b02 with SMTP id q13-20020a9d7c8d000000b006bcb2a27b02mr11581966otn.7.1694502936238;
        Tue, 12 Sep 2023 00:15:36 -0700 (PDT)
Received: from ?IPv6:2402:7500:4dc:9c7e:c46c:519:8d4b:654f? ([2402:7500:4dc:9c7e:c46c:519:8d4b:654f])
        by smtp.gmail.com with ESMTPSA id bk17-20020aa78311000000b0068fc9025a08sm2742425pfb.151.2023.09.12.00.15.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Sep 2023 00:15:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v4 10/12] RISC-V: crypto: add Zvkned accelerated AES
 encryption implementation
From:   Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <CAMj1kXEGnZC6nge42WeBML9Vx6K6Lezt8Cc1faP+3gN=TzFgvA@mail.gmail.com>
Date:   Tue, 12 Sep 2023 15:15:31 +0800
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        conor.dooley@microchip.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        christoph.muellner@vrull.eu,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Reply-To: CAMj1kXEGnZC6nge42WeBML9Vx6K6Lezt8Cc1faP+3gN=TzFgvA@mail.gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1BB805D3-FF47-4A58-8507-CCA72A27DD82@sifive.com>
References: <20230711153743.1970625-1-heiko@sntech.de>
 <20230711153743.1970625-11-heiko@sntech.de>
 <20230721054036.GD847@sol.localdomain>
 <CCA32056-CCE2-4FB5-8CFC-62444CDDA89F@sifive.com>
 <CAMj1kXEGnZC6nge42WeBML9Vx6K6Lezt8Cc1faP+3gN=TzFgvA@mail.gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sep 12, 2023, at 15:04, Ard Biesheuvel <ardb@kernel.org> wrote:

>> We have further optimization for RISC-V platform in OpenSSL PR[1]. It =
will include
>> AES with CBC, CTR, and XTS mode. Comparing to the generic AES =
implementation,
>> the specialized AES-XTS one have about 3X performance improvement =
using
>> OpenSSL benchmark tool. If OpenSSL accepts that PR, we will create =
the
>> corresponding patch for Linux kernel.
>>=20
>> [1]
>> https://github.com/openssl/openssl/pull/21923
>>=20
>=20
> This pull request doesn't appear to contain any XTS code at all, only =
CBC.

We have some license issues for upstream. We will append the specialized
AES modes soon.

-Jerry=
