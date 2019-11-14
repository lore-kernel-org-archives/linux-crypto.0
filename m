Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E24C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DEEB2071F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOcHHWgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfKNKtZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:49:25 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39804 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfKNKtZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 05:49:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id l7so5891311wrp.6;
        Thu, 14 Nov 2019 02:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PsHKqqY8IP1kGma0cvoxtMrhEOwaSBiNr+WZYaEGu0g=;
        b=NOcHHWglfoKO58skQZauX0HJysJ9mN4S6+/mfw7RSDHMs8+6clX4CVpTzVYOz8R7dO
         rBXc73FjmFa3n3a1Er6eaHQiAew4lci0+BOEzL8aq6lEvv0OVq6tJBqX58wCKBnYfUnN
         /SeIUC20vxg7pm6jnlJKsf+8rqnfrNqglyC1N2+3zJjmUKpiW/DXD6sCtHuKAV0gxibc
         LCwmj4J6LiSkPjn0l3YU2aZNkzGpxokdbcZuc2id8DKoQKm9jBjpfgALJ9uyQ9naKv39
         NARuO18x4XX2ng9JxlMUgZYrQbscQ3HCnlSrEkXok7fCR9l7bSv0n92PDtqmYd3uruy/
         NNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PsHKqqY8IP1kGma0cvoxtMrhEOwaSBiNr+WZYaEGu0g=;
        b=uRYDG6k9P92ZbIUGlA3DGyPNx161yhTNDyq6GYCRXgPb1Ve5hA7u3QsPBxDLOoimn+
         q9L09+Ji/8UN9/KpZCjVowWZLSZoHgxdjbAQDNOghk+nGVgCDvipXqbfK6JZeYJ0TmFc
         F8dVYkajoOoeytGH17eXkS9HDHc6xXlxdAi2BpLioXMMdoBiEr67Q3iJ1gI+AP1PACDM
         i3V3N9tOOicpWTAIiekfbwO99r54e/2vItq5xZ1BMmJBbe6Aw3TGpYwrjUi0nemUH5uM
         YYNO8B0B9IXaSAtbLprdXZrQu8muH/4awP5KGKve0I7WO+wUBzSuJPyVx+6yOoM2CPgd
         xr5w==
X-Gm-Message-State: APjAAAVemMRJkXtq2Db8/qi0sir+s+N59m2m1r7JVGQSOqOSmqT3Echn
        7MpiUhne89vDHthNEOwkALE=
X-Google-Smtp-Source: APXvYqzW70DVjuUaihSTDR9YctsEX5FZ+s1gUJ7ISZDeUN6w5dhrMPFEcE91FgX+8CB+6kXYCTA1CA==
X-Received: by 2002:a5d:6b51:: with SMTP id x17mr8043604wrw.148.1573728563385;
        Thu, 14 Nov 2019 02:49:23 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id k14sm7229301wrw.46.2019.11.14.02.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 02:49:22 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/2] crypto: sun4i-ss: Fix 64-bit size_t warnings on sun4i-ss-hash.c
Date:   Thu, 14 Nov 2019 11:49:06 +0100
Message-Id: <20191114104907.10645-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If you try to compile this driver on a 64-bit platform then you
will get warnings because it mixes size_t with unsigned int which
only works on 32-bit.

This patch fixes all of the warnings on sun4i-ss-hash.c.
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index 9930c9ce8971..91cf58db3845 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
@@ -284,8 +284,8 @@ static int sun4i_hash(struct ahash_request *areq)
 			 */
 			while (op->len < 64 && i < end) {
 				/* how many bytes we can read from current SG */
-				in_r = min3(mi.length - in_i, end - i,
-					    64 - op->len);
+				in_r = min(end - i, 64 - op->len);
+				in_r = min_t(size_t, mi.length - in_i, in_r);
 				memcpy(op->buf + op->len, mi.addr + in_i, in_r);
 				op->len += in_r;
 				i += in_r;
@@ -305,8 +305,8 @@ static int sun4i_hash(struct ahash_request *areq)
 		}
 		if (mi.length - in_i > 3 && i < end) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
-				    ((mi.length - in_i) / 4) * 4);
+			in_r = min_t(size_t, mi.length - in_i, areq->nbytes - i);
+			in_r = min_t(size_t, ((mi.length - in_i) / 4) * 4, in_r);
 			/* how many bytes we can write in the device*/
 			todo = min3((u32)(end - i) / 4, rx_cnt, (u32)in_r / 4);
 			writesl(ss->base + SS_RXFIFO, mi.addr + in_i, todo);
@@ -332,8 +332,8 @@ static int sun4i_hash(struct ahash_request *areq)
 	if ((areq->nbytes - i) < 64) {
 		while (i < areq->nbytes && in_i < mi.length && op->len < 64) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
-				    64 - op->len);
+			in_r = min(areq->nbytes - i, 64 - op->len);
+			in_r = min_t(size_t, mi.length - in_i, in_r);
 			memcpy(op->buf + op->len, mi.addr + in_i, in_r);
 			op->len += in_r;
 			i += in_r;
-- 
2.23.0

