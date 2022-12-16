Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CA6C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Dec 2022 16:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiLPQJz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Dec 2022 11:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiLPQJQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2022 11:09:16 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094683882
        for <linux-crypto@vger.kernel.org>; Fri, 16 Dec 2022 08:08:48 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id a6-20020a05600c224600b003d1f3ed49adso720757wmm.4
        for <linux-crypto@vger.kernel.org>; Fri, 16 Dec 2022 08:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IGoF+2jeK3IkIsvFOiLtqC8rk3aTOnFvuluK6bOOS/s=;
        b=V4uY+vWc/RMYG7pA2bA3dSUek6jo2HTpzw5kpwwq+9/ZdVNEH0gQvYNW5Or+TWCRky
         f7Y6/9Khiv+DoWa+oGa9504FjuzAI92zMsjPS/QFrXPTYs0St3aidPUdVqKijA3MwxGm
         smBZ3ZsJThu78ZkErPyhH5oUXvp8EvszZj2Czz6sYjakiEk8hBNLXgxpaypl9nppX52i
         qeKqRqG00MJ0oEX97SxQPzmlSeG+JJPzr3w32COM053OLO9ECwgeYq1V6zmkOIJ2MSCp
         bYyfMtxQdxIdSzuzl+oltMftHHci/r5R9LFEYrmoTyyDTPsgdhb6Sw8QIQAiTv43zm+P
         qrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGoF+2jeK3IkIsvFOiLtqC8rk3aTOnFvuluK6bOOS/s=;
        b=J4hVwpf+y21t6vc5MVJe43fF4xFEezowKGYjVrAwSNdHorXg/TSaP5J8Vv5Fqr8taf
         ULXOh7Re+x5kHqWTbly7FJCoDmmFiAchkO1ekbCowLpRzr7WMoCmTw5mQJCej30fYt1g
         OKtvEpS7FgtWCb84VyhvMfWkf9QPkwscqn/DBZtwXjGaPU3UeLwFk/Z8zSU5eDEYhtcG
         rkDpNbzZw2FB8+T+H2djoBJX0dvIcLOoE+2XPmT74l0yFbKmKtII3bv4GtrNeAZLYZhz
         mbf+jK4f0OepD7rDR6YSMGPOTZn5GSUiwWoezezAca4ocZyUmZEd3lRUDOuxkQ9LWYEM
         wfxA==
X-Gm-Message-State: ANoB5pmDVL5ojVJRxhzqgfrpeQIwdJt81/Vn+gaBm7oPefkm3pwOQv0K
        T36gsk+NnmUl63Bnb3F4hvEfj8RldLQ=
X-Google-Smtp-Source: AA0mqf4hi3NoV2PPOPWSopZoCqtyNF/jAEb1brUqVVbG1TOeXQ0CqV0qCkQD1Dw23x5Qwh/tX8kvMwTXbDs=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:9c:201:ad2c:4edf:bcb3:f7ae])
 (user=glider job=sendgmr) by 2002:a05:6000:146:b0:242:9e3:87ba with SMTP id
 r6-20020a056000014600b0024209e387bamr33632358wrx.580.1671206926247; Fri, 16
 Dec 2022 08:08:46 -0800 (PST)
Date:   Fri, 16 Dec 2022 17:08:41 +0100
In-Reply-To: <20221215162956.4037570-1-arnd@kernel.org>
Mime-Version: 1.0
References: <20221215162956.4037570-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221216160841.2061759-1-glider@google.com>
Subject: Re: [PATCH] crypto: wp512: disable kmsan checks in wp512_process_buffer()
From:   Alexander Potapenko <glider@google.com>
To:     arnd@kernel.org
Cc:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> The memory sanitizer causes excessive register spills in this function:

> crypto/wp512.c:782:13: error: stack frame size (2104) exceeds limit (2048) in 'wp512_process_buffer' [-Werror,-Wframe-larger-than]

> Assume that this one is safe, and mark it as needing no checks to
> get the stack usage back down to the normal level.

KMSAN indeed bloats the stack frames heavily.
Wouldn't it be more preferable to further increase KMSAN's -Wframe-larger-than limit instead?
It is not intended for production anyway, and detecting a runtime stack overflow in the debug mode should not be a problem.
