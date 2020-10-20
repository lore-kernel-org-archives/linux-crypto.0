Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6611C4363A
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9288B22256
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438600AbgJTUkI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:40:08 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:37881 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438591AbgJTUkG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 16:40:06 -0400
Received: by mail-qv1-f67.google.com with SMTP id t6so1621668qvz.4;
        Tue, 20 Oct 2020 13:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mKXeGSjs2PX4ElXU18mmsTyU03ZjqgEm7GsyImxM4Qk=;
        b=G0B+hpiok9ELahrTCbQds+rnuWxqyPTSBxvFqvFZPRJdts0AoAtrlDdp7UsLdu4PFo
         QDiWAw/GSQ8meH4SN+m+oQaxrsMeoa8MAFyOVwzyspK1AXnamiyfk/p7mMD8YLDNgaWi
         vtsEhpmOUzYF05Aerv7qCRa+L2Xc3g+6g30m5q3mpc+Mt4qzzakQkdx+7b6A3glj0iOV
         4asqep6K9dph0XJke/PSmKRa3gyzn6kF7akCgdZjIXFzGMGSpx2LccIiZXUuCP7kcmlN
         B5iMR55em9yAL9r1gyHs6Y0IifcimBFzw8SqoXoQ4VzWnSkgP/bhyu9slYKWnU5ruRF8
         pm1Q==
X-Gm-Message-State: AOAM533z1/8CAPBsNENVMlykdXZXobXqOZj4nggmi7/9UWa47Lk1SXpX
        vu9ozAmSgOPcV6kcwtAsAjw=
X-Google-Smtp-Source: ABdhPJzbiQdHTKHTglY3uXedvh48idzcfsU1X2+x9hmS3FzlcmWND9xbypFUtrhgsdG64HOLlL7nZg==
X-Received: by 2002:a0c:b251:: with SMTP id k17mr5301626qve.53.1603226405645;
        Tue, 20 Oct 2020 13:40:05 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m18sm1411165qkk.102.2020.10.20.13.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:40:04 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Date:   Tue, 20 Oct 2020 16:39:56 -0400
Message-Id: <20201020203957.3512851-6-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020203957.3512851-1-nivedita@alum.mit.edu>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Unrolling the LOAD and BLEND loops improves performance by ~8% on x86_64
(tested on Broadwell Xeon) while not increasing code size too much.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 lib/crypto/sha256.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 5efd390706c6..3a8802d5f747 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -68,12 +68,28 @@ static void sha256_transform(u32 *state, const u8 *input, u32 *W)
 	int i;
 
 	/* load the input */
-	for (i = 0; i < 16; i++)
-		LOAD_OP(i, W, input);
+	for (i = 0; i < 16; i += 8) {
+		LOAD_OP(i + 0, W, input);
+		LOAD_OP(i + 1, W, input);
+		LOAD_OP(i + 2, W, input);
+		LOAD_OP(i + 3, W, input);
+		LOAD_OP(i + 4, W, input);
+		LOAD_OP(i + 5, W, input);
+		LOAD_OP(i + 6, W, input);
+		LOAD_OP(i + 7, W, input);
+	}
 
 	/* now blend */
-	for (i = 16; i < 64; i++)
-		BLEND_OP(i, W);
+	for (i = 16; i < 64; i += 8) {
+		BLEND_OP(i + 0, W);
+		BLEND_OP(i + 1, W);
+		BLEND_OP(i + 2, W);
+		BLEND_OP(i + 3, W);
+		BLEND_OP(i + 4, W);
+		BLEND_OP(i + 5, W);
+		BLEND_OP(i + 6, W);
+		BLEND_OP(i + 7, W);
+	}
 
 	/* load the state into our registers */
 	a = state[0];  b = state[1];  c = state[2];  d = state[3];
-- 
2.26.2

