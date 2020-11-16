Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF79C64E7B
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E0EF222B9
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:54:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="t/iUAs6+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgKPNyL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 08:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgKPNyK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 08:54:10 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58605C0613D1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:10 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 10so14190873pfp.5
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=9xqbMfDK84LfAE+DUJJfb4bFExHt13Qqq3+lMB9/cx4=;
        b=t/iUAs6+5bIjom4ikhmS3npW0WvegKoLTw5jPVBg96byt6IbU77zK3ar4lY0y3Wq82
         f7iJp/NXK97qVqZfFPFLiBRAT5vOBwpaIAtCbs4AtRpMPGApm+faOvB7vJDblLR00Qtl
         PB3peuUHmHs6FAog5Zm34ZU735euugn99XRiH9IzvFGTMMTfwH9LdV5o7QgMwSaAv1Cm
         KvP73xEOS5CXMRI0yKhmZ59VWAPrKPmSZYq7LkilCtUnlCktjHTQm1TItSehuUm+QVPO
         o2XtAkUMbXHohHquMSbEq+pn4yVVCzEjtjwds9cYqwzUfbdzh/z3N7fYw/MZ7BuljcOR
         IAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9xqbMfDK84LfAE+DUJJfb4bFExHt13Qqq3+lMB9/cx4=;
        b=U+JitBG8971qZPCufCeE2pc1zCyiBZQXD58kvCFTYXiuR53Is7ZiVdfRQr0H2K2x2e
         14EyY6WCr2uZuP/yl9C9QkdYb96tx7636M9ZJx7A+YAEcAkRWHbfAkM+uXRLqp/dByOu
         Mv89auDGHcaLYW8LvYan5xhP7qn8UaacREUGPWqbwoKPYXfmRYkYTLjog8o7T7Lkvzcs
         //p0qTNCkFabq4aOh5Qn8ZtD1WmcIPH3I5qO1Wj4N3PoxzE6iZUSOIwqI/UuWFBJHQLv
         1YLD15uubDFe+gWWMzC78rhKkBhCVXHM0EBaKsaa8bqbr4FNoVBi8aeoo6ooVTlQz0y2
         HbPA==
X-Gm-Message-State: AOAM532r6PjMWmjS6y03B6Bv8wqvUl3dq1zP+CXZMasHre6XD/OoaOxO
        47arEEQHMdoepFMicUyTYA9PBMGcg+mSnuYl
X-Google-Smtp-Source: ABdhPJwuCTWXJaoWWI+pfrE1aZ7EfaWhfZNABzQEKZKsQKPygPQPkunTV2QwgIehC+6Jy3uALDTFSA==
X-Received: by 2002:a63:2cc3:: with SMTP id s186mr4196229pgs.230.1605534849841;
        Mon, 16 Nov 2020 05:54:09 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:09 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 0/7] crypto: sun4i-ss: prevent always fallback for ciphers
Date:   Mon, 16 Nov 2020 13:53:38 +0000
Message-Id: <20201116135345.11834-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

For help testing on "crypto: sun4i-ss - Fix sparse endianness markers",
I have added "stats" support like other allwinner's crypto drivers.
Seeing stats showed a clear problem, the ciphers function were not used
at all.
This is due to the not-inialized need_fallback which is "init" as true
everytime.
So basicly, since the patch introduced it, this probem hidden some bugs.

This serie fixes all hidden problems, then fix the initialization of
"need_fallback" and then add the stats like other allwinner drivers.

Regards

Changes since v2:
- patch #1: move buf/bufo out of function for reducing stack usage
- patch #4: use writesl()
- patch #6: use IS_ENABLED instead of #ifdef

Changes since v1:
- patch #4 is sufficient to fix BE problem (removed todo)

Corentin Labbe (7):
  crypto: sun4i-ss: linearize buffers content must be kept
  crypto: sun4i-ss: checking sg length is not sufficient
  crypto: sun4i-ss: IV register does not work on A10 and A13
  crypto: sun4i-ss: handle BigEndian for cipher
  crypto: sun4i-ss: initialize need_fallback
  crypto: sun4i-ss: enabled stats via debugfs
  crypto: sun4i-ss: add SPDX header and remove blank lines

 drivers/crypto/allwinner/Kconfig              |  9 ++
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 87 +++++++++++++------
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 56 ++++++++++++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  6 ++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-prng.c |  6 ++
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  8 ++
 6 files changed, 146 insertions(+), 26 deletions(-)

-- 
2.26.2

