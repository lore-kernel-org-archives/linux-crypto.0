Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B7DC38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 14:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiIGOya (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 10:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiIGOyK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 10:54:10 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A142B6549
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 07:53:46 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id z23so16316967ljk.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Sep 2022 07:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=JA9TuoAtB0Hdj8lp2ESD/D+NAeIyn8GknvA95wIowgc=;
        b=lkyy+Vj9xIxeSsOTcc37N97vHk2IeH5ikX2Dr4G8r2ZOrH7NwWJRHJlmH3pjhlzkwv
         jyNfkprU+TsRKtfHyIAwF1vH+1vtzai/I6nmMfUbxJGlfuFWmx/UeEl5TAr8YRUuWQ7N
         pUfbqDirdVle8VvJHt3VeJtsR51+MRhzRZcjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=JA9TuoAtB0Hdj8lp2ESD/D+NAeIyn8GknvA95wIowgc=;
        b=K5Hi5F2F/4AoThTS0ab84dWsbpL/QISbcUdPQ/a1eGxdjNoyyi6wNJpzs7N2VwfBVf
         QwTE+s6EV0fHHORi+uHfZw/FcQNpb0wwKm1nUkd7FLPbcTKY9s1UwFyXCenqGmldrEls
         hZfk7tdM9oXECVplKDQJKegWqJfhmuXt8r9krfmJ0wO51ZAJKGsBo9uhIjIAlD+g82Jf
         DlPJGv/3gtHdgUivNEIfhDXXlw05t5xE1s7D2NztsFBLryo9apEnrgo/lZqTY+dyinOd
         5V9q0aDn4wxAOyz8cyVaPNlRolIRTUT7+zLGD67OvoiFSbEK7u5ij112w8NIL7ycgs7o
         rtiw==
X-Gm-Message-State: ACgBeo1oP+o2YroqFO7BrTL7FrO1kuZujKh8uGMHRTCcLdrpd5lpWXmD
        6GBohHdD3B7HREWlsHWE/qiJ7OcnI76u0w==
X-Google-Smtp-Source: AA6agR5vxkv+ULXQ4ek8kuPyLq4CONCmVZa9SqNbXotDGSfd2pBQlkZsOy9YXpieaj0F2+yIG9NyZA==
X-Received: by 2002:a05:651c:110c:b0:268:a019:f84a with SMTP id e12-20020a05651c110c00b00268a019f84amr1163176ljo.162.1662562423100;
        Wed, 07 Sep 2022 07:53:43 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id x6-20020a056512046600b004979e1ff641sm1041674lfd.115.2022.09.07.07.53.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 07:53:40 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id z25so22875695lfr.2
        for <linux-crypto@vger.kernel.org>; Wed, 07 Sep 2022 07:53:39 -0700 (PDT)
X-Received: by 2002:a05:6512:c1e:b0:494:7c8c:f5f2 with SMTP id
 z30-20020a0565120c1e00b004947c8cf5f2mr1302375lfu.593.1662562419339; Wed, 07
 Sep 2022 07:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220831172024.1613208-1-svenva@chromium.org> <20220831172024.1613208-2-svenva@chromium.org>
 <Yxg6OayyEFWIax/r@gondor.apana.org.au>
In-Reply-To: <Yxg6OayyEFWIax/r@gondor.apana.org.au>
From:   Sven van Ashbrook <svenva@chromium.org>
Date:   Wed, 7 Sep 2022 10:53:27 -0400
X-Gmail-Original-Message-ID: <CAM7w-FW_w2h6JmvZpg2qjspESAYR21o-0Pw89JnnV8hFEdaHmw@mail.gmail.com>
Message-ID: <CAM7w-FW_w2h6JmvZpg2qjspESAYR21o-0Pw89JnnV8hFEdaHmw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] hwrng: core: fix potential suspend/resume race condition
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Alex Levin <levinale@google.com>,
        Rajat Jain <rajatja@google.com>,
        Andrey Pronin <apronin@google.com>,
        Stephen Boyd <swboyd@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Olivia Mackall <olivia@selenic.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Wed, Sep 7, 2022 at 2:29 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The general concept seems to be fine.

Thank you kindly for the fast review. I plan to get a v2 out in the
next few days.
