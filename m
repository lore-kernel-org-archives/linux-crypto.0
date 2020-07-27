Return-Path: <SRS0=C5/f=BG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B86AC433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 13:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6E5206E7
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 13:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgG0NFW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jul 2020 09:05:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41356 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbgG0NFW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jul 2020 09:05:22 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1k02oi-0003FI-SB
        for linux-crypto@vger.kernel.org; Mon, 27 Jul 2020 13:05:20 +0000
Received: by mail-wr1-f71.google.com with SMTP id t12so3947774wrp.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2020 06:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bzR3LoEEn8WdPuh8casfIRu7IDrLfMDc4V7KUL0jgCY=;
        b=HCnzj//O/YT0AB/GYBWsUKkolvc7Li5DT0M7LzQCHpdvSawUpJZhnqTNJl+WujdO0H
         3sqDnClBCEhRrSO1bgWLda+5bP23+hhEBExluiiZRNlAVZMKeynUBUypwdqBzmw834fS
         +PvzW7gI/6SHzHKdi1+RfBO7DO2+LpGPzlAcdSDnX9gSKXN8z5bJlTl60lCYp953aCx4
         KaUciS0Dx5rjjIitZYK/g0QzWClnOoL733rDpziL5Xc79RV6HYJel1DS9qrXKnOIuaE2
         nsaiqf/sadHP9GV/uXiqPhAjaYTcjYL5PIWleubs+V79vYCqvTPgdaNcYeOvIem8pD4J
         wN8A==
X-Gm-Message-State: AOAM533akhxNVr+HtM9g1zIDrqPVVDJRYlxQIfKK1LAeEWTFsLhsq4ow
        iZhSmpZp61Wu7GAitpg3CPBx5Gs++m54zNjZSDPlbi9QA9Vo10q2TN0tSqYyfGphZ3lvcBbwdLW
        rZPWtKYh1OdGmPz6hVhJeG7h07ItU+Sq6AcAe1mw89Q==
X-Received: by 2002:a7b:c92b:: with SMTP id h11mr19357067wml.7.1595855120064;
        Mon, 27 Jul 2020 06:05:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxS8vOBlTBGfZagOx/7xHoe4Q1rRXmLkgmZv9m4Qk0aKPHSDg7YFGtdOTXCeisZv+go7aB/NA==
X-Received: by 2002:a7b:c92b:: with SMTP id h11mr19357045wml.7.1595855119761;
        Mon, 27 Jul 2020 06:05:19 -0700 (PDT)
Received: from localhost (host-87-11-131-192.retail.telecomitalia.it. [87.11.131.192])
        by smtp.gmail.com with ESMTPSA id h6sm12969636wrv.40.2020.07.27.06.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 06:05:19 -0700 (PDT)
Date:   Mon, 27 Jul 2020 15:05:17 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: crypto: aegis128: error: incompatible types when initializing type
 'unsigned char' using type 'uint8x16_t'
Message-ID: <20200727130517.GA1222569@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I'm experiencing this build error on arm64 after updating to gcc 10:

crypto/aegis128-neon-inner.c: In function 'crypto_aegis128_init_neon':
crypto/aegis128-neon-inner.c:151:3: error: incompatible types when initializing type 'unsigned char' using type 'uint8x16_t'
  151 |   k ^ vld1q_u8(const0),
      |   ^
crypto/aegis128-neon-inner.c:152:3: error: incompatible types when initializing type 'unsigned char' using type 'uint8x16_t'
  152 |   k ^ vld1q_u8(const1),
      |   ^

Anybody knows if there's a fix for this already? Otherwise I'll take a look at it.

Thanks,
-Andrea
