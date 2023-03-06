Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5FDC678D4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 09:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjCFJ7V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 04:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCFJ7U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 04:59:20 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DA5FF2B
        for <linux-crypto@vger.kernel.org>; Mon,  6 Mar 2023 01:59:19 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-536bbef1c5eso173459297b3.9
        for <linux-crypto@vger.kernel.org>; Mon, 06 Mar 2023 01:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmCoxFXOjygQDIzK1tZa6oHAVDWZOb2fMdPu8gYG9LA=;
        b=R1GDPbh4yVZ0p5iRkuHOTmZh5TuKhZv4Wcznyvdjvx0OoqKh7ZF783XLGZ/vpVQMXz
         bCxdyNge9U+zOI4R5TbF+OpFlm5lbt2Qo3EfdH+Mjpqa+skPMwa6qSsiZjmvWLi7nox0
         EQTgXhI1kvDjXvrCq/9ssHTd0DY3B4thYvsE4B7UoyjGhjV+knXolZqr7rp1nqS/yS6+
         QVLPGBm47vUQoRSG3tH5RMEJoNoVYCEBPeG1o7pAKfR14gefnbQGTHm1yD4PzUq2pYvS
         BMJcXBupsMXISEkc3h9zDNew5Z7P8wyr7AluMml9ITeCq0CbnJdj0VSjQhuk0RAEbZfG
         Oavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmCoxFXOjygQDIzK1tZa6oHAVDWZOb2fMdPu8gYG9LA=;
        b=epxkyEZbDO51l1uVrGdAD1QhyE0DpyHvKfxamUPLF4yU/5/N+4jX881RLRROwO/lDm
         G/U6BfCGg/tFTK36AB7Qd4cGQJj1QhqPKvBlEumL8723P5fWfUxPciefar67WVtF/Dcq
         +l/9IQDoJq0ViEIRUyYZt1AoQhtl2hcAWwSZ6U7i73UdOyxODp0RmZFOEHEw/HMYZGcb
         Nz1CB7Uw5ceMZmZVa+L35kaR6APWDuOfW0cPZSq/vcHyRch3zxXiNKlCxziUVXQ1Ln4V
         5/xVZSHdDcYH4/6FMoRylZ4AIVZMDtxZpy5u9kLuVQaiZ6RAq8T41qfi72WuF35AEi1G
         Winw==
X-Gm-Message-State: AO0yUKW+ysiVoDAVZgQvNgBlf7B0MmJknNNqwl9Eoc1wdZCFib/7qKzC
        V9PBz+0TefhO07/e17kfHgbfLzKCp+ab387EEpHmpQ==
X-Google-Smtp-Source: AK7set9thiTXKi70kvUYtjvGioPgktg/AQjQIDH9/Y8okcnfS3yBXcctmzIV8JdJro5UMpz5tBKLzbCtxmBve6+SzEo=
X-Received: by 2002:a81:ad24:0:b0:52e:bb2d:2841 with SMTP id
 l36-20020a81ad24000000b0052ebb2d2841mr5996953ywh.10.1678096758438; Mon, 06
 Mar 2023 01:59:18 -0800 (PST)
MIME-Version: 1.0
References: <ZAVu/XHbL9IR5D3h@gondor.apana.org.au> <E1pZ2fn-000e1d-Qm@formenos.hmeau.com>
In-Reply-To: <E1pZ2fn-000e1d-Qm@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 6 Mar 2023 10:59:06 +0100
Message-ID: <CACRpkdZj5Ou75TN4pFjDU==5=6nSzBtsszzOiL3U3D3JK=RLqw@mail.gmail.com>
Subject: Re: [v5 PATCH 5/7] crypto: stm32 - Move hash state into separate structure
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

thanks for keeping going at this!

On Mon, Mar 6, 2023 at 5:42=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:

> Create a new struct stm32_hash_state so that it may be exported
> in future instead of the entire request context.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

First the patch bugged but I found the problem in a small semantic
glitch:

diff --git a/drivers/crypto/stm32/stm32-hash.c
b/drivers/crypto/stm32/stm32-hash.c
index de8275a80271..3743f55b5c04 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -785,7 +785,7 @@ static int stm32_hash_final_req(struct stm32_hash_dev *=
hdev)
        if (state->flags & HASH_FLAGS_FINUP)
                return stm32_hash_update_req(hdev);

-       return stm32_hash_xmit_cpu(hdev, state->buffer, state->buflen, 1);
+       return stm32_hash_xmit_cpu(hdev, state->buffer, state->bufcnt, 1);
 }

 static void stm32_hash_emptymsg_fallback(struct ahash_request *req)

Afte this all (extended) tests pass fine.

Just fold in this and you can add:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
