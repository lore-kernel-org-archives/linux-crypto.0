Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AE4C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 17:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiKHR3c (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 12:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiKHR3b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 12:29:31 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197DF20996
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 09:29:29 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id b62so14008767pgc.0
        for <linux-crypto@vger.kernel.org>; Tue, 08 Nov 2022 09:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5FVCMfeiZLHWKmFh+FqLYpaeqKRAlifxYJVyfWqZqZk=;
        b=TcXV7SAA0xvPOfmvHzBUPQnugs/YasXJ6whZHnJ7gjDDFxRs64xayMIqnUph3gVGuM
         Vk7oED5XLpqF8JjKACQYtGGBJcsD1icZ4+7PfBZj5p814CvweAwkXr8kDdYGLXWjSTH8
         mSeioFi2Rcl6sCMT060qYV7CiWku9QUPYtbzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5FVCMfeiZLHWKmFh+FqLYpaeqKRAlifxYJVyfWqZqZk=;
        b=mY6zgBjgZ7jjtWLLwfbnwXUAAQdSvpLim7TeQJEYD7PdCgQHoM8uI1Qog/DueUIMGV
         p2vRioCJmih+Og53Z+uddRWSUKl5U/6MpUjeiOhFKTdqCmRk6sYzgKZP/Xc7Sho5jE9J
         QgcGPjdYDY8v/2hnI0R7zZ6wNG1mt05qGl/ZbozUPGU7xY59tZ6NsMxqE/M1yZvraoTz
         eonbpkNBSmEZBDjETZUm44Xm9QN73ZtusqC/Sr9ZklgJTpE/uFsqXmW5gXXlRr7GqrBa
         elhjZ0h2WhmJDaKaR/X5wsSVRC0Gt7wg2B8wwGBogdaaos19Ad0N5VGm+avz9joKyRpT
         PP4g==
X-Gm-Message-State: ACrzQf1tEExG7lCDKomt60rh9Faj6Re1XsTz1X9agF2Zd9yaQBZwRtzt
        cOp1w5A3+jiI+nhN0Nb5c4OFvQ==
X-Google-Smtp-Source: AMsMyM5aFIIqDhZfHqMUWHiT3mSwKknCdK4qJXdm+uZ0LnKIMqvrnR1fIs6JDxdhfeftiDlv8cN4qA==
X-Received: by 2002:a63:6909:0:b0:41c:9f4f:a63c with SMTP id e9-20020a636909000000b0041c9f4fa63cmr50519040pgc.76.1667928568583;
        Tue, 08 Nov 2022 09:29:28 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b191-20020a621bc8000000b0056bb0357f5bsm6631443pfb.192.2022.11.08.09.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 09:29:28 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Tue, 8 Nov 2022 09:29:27 -0800
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Olivia Mackall <olivia@selenic.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: add_early_randomness(): Integer handling issues
Message-ID: <202211080929.F5B344C9F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello!

This is an experimental semi-automated report about issues detected by
Coverity from a scan of next-20221108 as part of the linux-next scan project:
https://scan.coverity.com/projects/linux-next-weekly-scan

You're getting this email because you were associated with the identified
lines of code (noted below) that were touched by commits:

  Mon Nov 7 12:47:57 2022 +0100
    e0a37003ff0b ("hw_random: use add_hwgenerator_randomness() for early entropy")

Coverity reported the following:

*** CID 1527234:  Integer handling issues  (SIGN_EXTENSION)
drivers/char/hw_random/core.c:73 in add_early_randomness()
67     	int bytes_read;
68
69     	mutex_lock(&reading_mutex);
70     	bytes_read = rng_get_data(rng, rng_fillbuf, 32, 0);
71     	mutex_unlock(&reading_mutex);
72     	if (bytes_read > 0) {
vvv     CID 1527234:  Integer handling issues  (SIGN_EXTENSION)
vvv     Suspicious implicit sign extension: "rng->quality" with type "unsigned short" (16 bits, unsigned) is promoted in "bytes_read * 8 * rng->quality / 1024" to type "int" (32 bits, signed), then sign-extended to type "unsigned long" (64 bits, unsigned).  If "bytes_read * 8 * rng->quality / 1024" is greater than 0x7FFFFFFF, the upper bits of the result will all be 1.
73     		size_t entropy = bytes_read * 8 * rng->quality / 1024;
74     		add_hwgenerator_randomness(rng_fillbuf, bytes_read, entropy, false);
75     	}
76     }
77
78     static inline void cleanup_rng(struct kref *kref)

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527234 ("Integer handling issues")
Fixes: e0a37003ff0b ("hw_random: use add_hwgenerator_randomness() for early entropy")

Thanks for your attention!

-- 
Coverity-bot
