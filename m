Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB54EB64DD
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jul 2023 22:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjGFWKO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jul 2023 18:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjGFWKM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2023 18:10:12 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061BE1FC4
        for <linux-crypto@vger.kernel.org>; Thu,  6 Jul 2023 15:10:09 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-c6ae08ebfa2so1040799276.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jul 2023 15:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688681409; x=1691273409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EaRYPoQhBK/4tB9AkHrTvbi+01+8KyCJD5rHLEiLHRY=;
        b=tLbPe+XrraaPfIPZdRWkBh4e/SEhaJ9Zet06Uc7NH7vYFPUiPvihQ28EwpKzizoBic
         K26L9OPHDDM8n/oHVUDe1QtWNv8R2OrMAYAXYNM7k5HgzlIYdhprUG1DtSkdLWxfIoJr
         8/wbGP7bKMj+Z0PEdlbeo4XCMhBmQytubsI7/a2FC4x7Jz6H0cn0JOj0uc5edhe9GGIt
         U+JbC5EHcOv86SFMYTn8jpSJIjbP67uauBA1Q4a89QiahN0gbbjFseLsAWa6faOlUnwv
         0BLZlTU+50dCRKCWw1bcr3XtH3H+Mh63ALt87w5A/KP8Att4hvINACztwUzYiyOkBjX9
         riDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688681409; x=1691273409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EaRYPoQhBK/4tB9AkHrTvbi+01+8KyCJD5rHLEiLHRY=;
        b=c6RmrT7vVJDlrNqJg9aoEP8EzRsQPqYjhZFz7rwUTVN7cQu1LL//9u0OyMlYzxkXjI
         3+I/+t2ZdzAHX1rDNlUXex/Cg68t5jTaE1/IvAk8Bq8foukOdd1CqEC9vPDT+F5FjmJN
         ZayZGOKqXAjE4hky0kRIrvzd7wQBHaUT/b0Ws3vOjtVrT7HbPGmZyE7S25v2gXb/BXV+
         nuaqli5zNTyG1+hqlmYzxP56jtUz2mrvgYWc+w8wDizHorcyvBKexdJuQF8kmvA2lgH2
         VWxW39DSgoqdvMm81dSQbB8f5QVfr1pK10rMvNA9U2V+HDQ0a7Otm8/ehsVkl5ARY+12
         vJog==
X-Gm-Message-State: ABy/qLblg/fK3tH2DVrldG/JcqENSsWWh1THcCzZ/JYzB7rD87MMw7oG
        shM6iGBcTla1VWV4yGpmnoKN102+BK3S4Qu4/a/5rA==
X-Google-Smtp-Source: APBJJlFzm1sQUiz398ok7Tkvc/xWGg74bFGoqYKbyjqE426nRYq1ut4c9nhjvrnp43q+sujH7LVMZmtIAuk8p0V3e7k=
X-Received: by 2002:a5b:611:0:b0:c1c:e037:1379 with SMTP id
 d17-20020a5b0611000000b00c1ce0371379mr3138042ybq.1.1688681409016; Thu, 06 Jul
 2023 15:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230706073719.1156288-1-thomas.bourgoin@foss.st.com> <20230706073719.1156288-3-thomas.bourgoin@foss.st.com>
In-Reply-To: <20230706073719.1156288-3-thomas.bourgoin@foss.st.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 7 Jul 2023 00:09:57 +0200
Message-ID: <CACRpkdaHn8fhZtuhU4sXHK1xoxO3-xYg_Xb=3=bX8i-uJM9KDA@mail.gmail.com>
Subject: Re: [PATCH 2/7] crypto: stm32 - add new algorithms support
To:     Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Thomas,

thanks for your patch! I overall like the looks of
the end result.

On Thu, Jul 6, 2023 at 9:38=E2=80=AFAM Thomas BOURGOIN
<thomas.bourgoin@foss.st.com> wrote:

> From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
>
> Add the all SHA-2 (up to 512) and SHA-3 algorithm support.
> Update compatible table to add stm32mp13.
>
> Signed-off-by: Thomas Bourgoin <thomas.bourgoin@foss.st.com>

I testes to apply this and boot the Skomer (U8500, Samsung
GT-S7710) This patch regresses the ux500 hash like this:

[    3.612426] stm32-hash a03c2000.hash: allocated hmac(sha256) fallback
[    4.236755] stm32-hash a03c2000.hash: allocated sha256 fallback
[    4.269287] alg: ahash: stm32-sha256 test failed (wrong result) on
test vector 4, cfg=3D"init+update+final aligned buffer"
[    4.280273] alg: self-tests for sha256 using stm32-sha256 failed (rc=3D-=
22)
[    4.280273] ------------[ cut here ]------------
[    4.291748] WARNING: CPU: 0 PID: 100 at crypto/testmgr.c:5936
alg_test.part.0+0x4d0/0x4e0
[    4.299987] alg: self-tests for sha256 using stm32-sha256 failed (rc=3D-=
22)
[    4.299987] Modules linked in:
[    4.309906] CPU: 0 PID: 100 Comm: cryptomgr_test Not tainted
6.4.0-rc1-00014-g3c85f4ad9472 #274
[    4.318603] Hardware name: ST-Ericsson Ux5x0 platform (Device Tree Suppo=
rt)
[    4.325561]  unwind_backtrace from show_stack+0x10/0x14
[    4.330810]  show_stack from dump_stack_lvl+0x40/0x4c
[    4.335876]  dump_stack_lvl from __warn+0x94/0xc0
[    4.340606]  __warn from warn_slowpath_fmt+0x118/0x164
[    4.345733]  warn_slowpath_fmt from alg_test.part.0+0x4d0/0x4e0
[    4.351684]  alg_test.part.0 from cryptomgr_test+0x18/0x38
[    4.357177]  cryptomgr_test from kthread+0xd0/0xd4
[    4.361968]  kthread from ret_from_fork+0x14/0x2c
[    4.366668] Exception stack(0xf0df5fb0 to 0xf0df5ff8)
[    4.371734] 5fa0:                                     00000000
00000000 00000000 00000000
[    4.379913] 5fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    4.388061] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    4.394744] ---[ end trace 0000000000000000 ]---
[    4.669372] stm32-hash a03c2000.hash: allocated hmac(sha1) fallback
[    5.131622] stm32-hash a03c2000.hash: allocated sha1 fallback
[    5.156005] alg: ahash: stm32-sha1 test failed (wrong result) on
test vector 3, cfg=3D"init+update+final aligned buffer"
[    5.166778] alg: self-tests for sha1 using stm32-sha1 failed (rc=3D-22)
[    5.166778] ------------[ cut here ]------------
[    5.177947] WARNING: CPU: 0 PID: 115 at crypto/testmgr.c:5936
alg_test.part.0+0x4d0/0x4e0
[    5.186187] alg: self-tests for sha1 using stm32-sha1 failed (rc=3D-22)
[    5.186187] Modules linked in:
[    5.195739] CPU: 0 PID: 115 Comm: cryptomgr_test Tainted: G
W          6.4.0-rc1-00014-g3c85f4ad9472 #274
[    5.205902] Hardware name: ST-Ericsson Ux5x0 platform (Device Tree Suppo=
rt)
[    5.212860]  unwind_backtrace from show_stack+0x10/0x14
[    5.218109]  show_stack from dump_stack_lvl+0x40/0x4c
[    5.223175]  dump_stack_lvl from __warn+0x94/0xc0
[    5.227874]  __warn from warn_slowpath_fmt+0x118/0x164
[    5.233032]  warn_slowpath_fmt from alg_test.part.0+0x4d0/0x4e0
[    5.238952]  alg_test.part.0 from cryptomgr_test+0x18/0x38
[    5.244445]  cryptomgr_test from kthread+0xd0/0xd4
[    5.249267]  kthread from ret_from_fork+0x14/0x2c
[    5.253967] Exception stack(0xf0f21fb0 to 0xf0f21ff8)
[    5.259002] 1fa0:                                     00000000
00000000 00000000 00000000
[    5.267181] 1fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    5.275360] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    5.282012] ---[ end trace 0000000000000000 ]---

This worked before the patch (verified).

>  drivers/crypto/stm32/Kconfig      |   2 +
>  drivers/crypto/stm32/stm32-hash.c | 666 ++++++++++++++++++++++++------

The patch is a bit big so it is hard to see the problem, do you
think you can break it into increments?

Yours,
Linus Walleij
