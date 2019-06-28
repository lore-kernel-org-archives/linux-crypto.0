Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9C6C5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C55B32083B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="avVT/BO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfF1RIQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:08:16 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:34148 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfF1RIQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:08:16 -0400
Received: by mail-wr1-f49.google.com with SMTP id k11so7068858wrl.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 10:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b79/g9Nvq0eGYqHdJhiJkLQryIln2SAfitFpz7glqUo=;
        b=avVT/BO95F2mxYjDV/SPWpg4poWAaieylUFyi04ik8E4GQK9n6N0r1HcFgMdlmgtb3
         qAfQtwseUAGlJKvIDy+TPYhVNRHC2MVb5q74nZfqSnz7z3E4tMwwWJPnxvwI47uwOYYR
         UMdnEr/eMufjK0+ckQS6h0sHQ91S2AOp9V6sk3P7/o+wOCqoz1UlYAyThsqUWE1+qJvM
         xn35M12zBnM7xAO5i6MbnXyqu1Mgri1KuEv2xMjwojrmCpMRq/16oL3NDAGsr66XAGUg
         P6oJ3Gzj6Qn3Ls9SvIhkiuMDw6NO9mgUUC/aw8lQYpBRGUvs/7bsrp8/6VqsmQsM/Tzl
         BEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b79/g9Nvq0eGYqHdJhiJkLQryIln2SAfitFpz7glqUo=;
        b=D47HuVYrL3QFSD2drGD3BF8oEBrlYyOkkfNNdICcaC7oAFgQ8ny/Aj8mxgmGdJmIDS
         19eBz57A940lEzSLLK/LJWGwashZ3nnAOFr6+H9U2Qso1Akg3DKrc/4woF/MlUfdsSP5
         hWH+2sK4dXvGZDS5zHYedkydBCdYIBzk2VXtDrk5o+eisfaIb16pvVHi8d6rjMnP/06p
         6CWSxQRtQDYItg6QJtpcQ8xUwC1JRSS98OmfDFj7j7bxhdUM3/BCceJtW8AqZMy/QmTb
         aJ+YFQjTNUpJNxybVjJcP5pJ9DXeYyCwwfKo8qgG8+6Q02YdbtF9icbUgGqDbhGiIehN
         cpsQ==
X-Gm-Message-State: APjAAAUcycnR+OoC7oa0CmS9CqrsZ+YgHyn9N99/kbhq53Dn7+JB1hg0
        ZvAqSvK3FQcL4dgOGWP0P1xel18s90wkqA==
X-Google-Smtp-Source: APXvYqx7pNuM2IFFIIDpCzpdmdtqIBasSAu6ZL/rKGsa2kZkIs0DdrWJvipcIy/ZfMALWMU0NmTyfA==
X-Received: by 2002:adf:ebc4:: with SMTP id v4mr8644522wrn.113.1561741693838;
        Fri, 28 Jun 2019 10:08:13 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id c15sm3833251wrd.88.2019.06.28.10.08.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:08:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 7/7] crypto: tcrypt - add a speed test for AEGIS128
Date:   Fri, 28 Jun 2019 19:07:46 +0200
Message-Id: <20190628170746.28768-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
References: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/tcrypt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 798253f05203..72dc84e1c647 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2332,6 +2332,13 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				  0, speed_template_32);
 		break;
 
+	case 221:
+		test_aead_speed("aegis128", ENCRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		test_aead_speed("aegis128", DECRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
-- 
2.20.1

