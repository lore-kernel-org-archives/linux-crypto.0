Return-Path: <SRS0=/mkk=BM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A402C433DF
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 17:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F28206E7
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Aug 2020 17:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbkTXtQM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHBRM4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Aug 2020 13:12:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58080 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725907AbgHBRM4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Aug 2020 13:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596388375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=cMGJeihf68/SzYvQTtJu1Xd1NxXkQ2OyiZYDKiEiLwg=;
        b=gbkTXtQMHihK7N01Uirq2DhxG8phfN1uVr8WsTcglUbYXwE8WzWoVmEcH98cae+ykcYbTz
        fclaH71IyD4hogsbZFeFivKCtkIwFwLA7pY1wTVwYa1mV7o73WnvDUtJAw8V3ZRMNxVP8/
        2FlqVJ8b5KqfJ6oy37yV/mg74npC8DY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-Bev7rg2hNIGADy313MhIUA-1; Sun, 02 Aug 2020 13:12:53 -0400
X-MC-Unique: Bev7rg2hNIGADy313MhIUA-1
Received: by mail-qk1-f199.google.com with SMTP id v16so24721335qka.18
        for <linux-crypto@vger.kernel.org>; Sun, 02 Aug 2020 10:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cMGJeihf68/SzYvQTtJu1Xd1NxXkQ2OyiZYDKiEiLwg=;
        b=H0xwzfSQCOLfr8hL1PnIqpBiVXsaGggYaZv16jFHauFnLAeQYjBjy84MXDYEPsEVrM
         xKu8xYLaIV32Ksh0+ALpWkplRPQhm6PNfrc7+po3zRoC0tWsXUY5eN76+df1krQDwmNn
         Cyw10qfS2ee2DeV/MxU1NE4GGjrvxLP3zyEdEPUl7Vv3AIZnu5UyR8yBbZWZMKwVgr7L
         /gnS3pgQzXOqqGacSGqclUA8jVhsQ5lorxmLIrWl2uM9JXIoy3jO7tFfA4zKok0aoXmY
         Es0JUenKtRi9lYvXdUH1TB2yWwKwro0hlA34bgj7261qnXq+lGhBiOgluTyXk3CrvRmI
         rzPg==
X-Gm-Message-State: AOAM530k2zwvDZ9spbB36uMtCarnJoXzuE12FrGDP76isEMa3ZnbcqTS
        QVsLDO8WJQLfugV4M5ggrsDw0n/2qiKK3tDSKQ3QWVmY/DyuW7Y6cEhUKChzVPhtOjIFdQoN5qH
        82Ei88ZNtUcqsn/3Ji2Chrl7C
X-Received: by 2002:a37:910:: with SMTP id 16mr12366637qkj.466.1596388372911;
        Sun, 02 Aug 2020 10:12:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxR7HqMksnZzGBECjPQnqdYT9adQy1oaafRwKuLOrG+gGnBFOCuGBMWoP3NZnzmDuFk4ncaVg==
X-Received: by 2002:a37:910:: with SMTP id 16mr12366617qkj.466.1596388372629;
        Sun, 02 Aug 2020 10:12:52 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id a3sm16735354qkf.131.2020.08.02.10.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 10:12:52 -0700 (PDT)
From:   trix@redhat.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        smueller@chronox.de
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: drbg: check blocklen is non zero
Date:   Sun,  2 Aug 2020 10:12:47 -0700
Message-Id: <20200802171247.16558-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this error

crypto/drbg.c:441:40: warning: Division by zero
        padlen = (inputlen + sizeof(L_N) + 1) % (drbg_blocklen(drbg));
                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~

When drbg_bocklen fails it returns 0.

	if (drbg && drbg->core)
		return drbg->core->blocklen_bytes;
	return 0;

In many places in drbg_ctr_df drbg_bocklen is assumed to be non zero.
So turn the assumption into a check.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 crypto/drbg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index e99fe34cfa00..bd9a137e5473 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -420,6 +420,9 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	size_t inputlen = 0;
 	struct drbg_string *seed = NULL;
 
+	if (!drbg_blocklen(drbg))
+		return -EINVAL;
+
 	memset(pad, 0, drbg_blocklen(drbg));
 	memset(iv, 0, drbg_blocklen(drbg));
 
-- 
2.18.1

