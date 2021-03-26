Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A8DC433C1
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 02:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8119F61A38
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 02:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhCZCgd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhCZCgY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Mar 2021 22:36:24 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4888AC06174A;
        Thu, 25 Mar 2021 19:36:20 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id q9so2263289qvm.6;
        Thu, 25 Mar 2021 19:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XY21P0oEzBo7moFwrTmpwbutbtWiFMXBtu5YZsX338=;
        b=InsuXlpySPiUdsjPadjkZNWlF2zHYgiIFSPVL69nS3wDLsSGk483NF9S+CZ7Tc4LRk
         YZB37YOLYf3vX3Yp/CYXPO2KWpoIl9V86gLIJ2+5Hc4sp95wK1jik83DbPst/gfFOoN0
         ztDYufhiNAvF9S/9zGZHNttA5I0l5525piXBL7/zDpxcSicwfh70pFSAbV2I4QGaPLl/
         bID3pzaUoIfrtobO1GNA51Cwghnmfr6RHJXsl76vxkcx+xKXeQUk9dI60HT+BzqxaLL7
         VPApccogA3/U7jw/C6WjBwKWv0vfnblT9v41sqliNSrug+lGKuv10m7gwY8pLywJqpyL
         LsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XY21P0oEzBo7moFwrTmpwbutbtWiFMXBtu5YZsX338=;
        b=P5/DhH9+mArCiUn+lWaX3Jym2nRhicmtzFjSPmh/8H+I6cZyzEIcrKsQOxNO8rxFyi
         Rgk+06eAVIjwVW+lKiK8DjefFCP84yDKkJDtSILXGUz5BRVtgQ2/3NGe/D69qEpk7dDB
         JpTXx0Y/h8LjuPj96GEdbr4/p+8Il6Wzsn2WiXq4w2z0EFDbna0vr1w3DH67CSJ/MAtM
         DJE6GzvuXfh7L8kptg7I3gQ747RsyzQcD6CwDCGcRLgsBQZJNvu+bfCIwY20GkGtGXb+
         IZTtIkORgb21hZvg5g8vu4d+WGniZH+AAXvYtnFcTduMMocCQ0isz7BRGuUKFy6hxQed
         sRAQ==
X-Gm-Message-State: AOAM531FL5g1vm1vM+bSJU/xR6xi6/zLT9HuOnbq63hj+FjDWdD+LAn9
        bnhd/BbG076nUZ37gby+giA=
X-Google-Smtp-Source: ABdhPJyJeUUYTWDQemPerzsD1NXsJiHVLjCqWFhTrkCBuxyzPWbXgu2CY+kKm7ohBv8OamxV4+hNJg==
X-Received: by 2002:a0c:8623:: with SMTP id p32mr11243517qva.23.1616726179632;
        Thu, 25 Mar 2021 19:36:19 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.107])
        by smtp.gmail.com with ESMTPSA id 18sm5995694qkr.77.2021.03.25.19.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 19:36:18 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     dan.j.williams@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, songliubraving@fb.com, yuyufen@huawei.com,
        unixbhaskar@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] crypto: async_tx/async_xor.c: Few mundane spello fixes
Date:   Fri, 26 Mar 2021 08:04:06 +0530
Message-Id: <20210326023406.11091-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


s/eninges/engines/  ...two different places.
s/explicity/explicitly/  ....two different places.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 crypto/async_tx/async_xor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index a057ecb1288d..fee33f76cdd9 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -170,8 +170,8 @@ dma_xor_aligned_offsets(struct dma_device *device, unsigned int offset,
  *
  * xor_blocks always uses the dest as a source so the
  * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
- * the calculation.  The assumption with dma eninges is that they only
- * use the destination buffer as a source when it is explicity specified
+ * the calculation.  The assumption with dma engines is that they only
+ * use the destination buffer as a source when it is explicitly specified
  * in the source list.
  *
  * src_list note: if the dest is also a source it must be at index zero.
@@ -259,8 +259,8 @@ EXPORT_SYMBOL_GPL(async_xor_offs);
  *
  * xor_blocks always uses the dest as a source so the
  * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
- * the calculation.  The assumption with dma eninges is that they only
- * use the destination buffer as a source when it is explicity specified
+ * the calculation.  The assumption with dma engines is that they only
+ * use the destination buffer as a source when it is explicitly specified
  * in the source list.
  *
  * src_list note: if the dest is also a source it must be at index zero.
--
2.26.2

