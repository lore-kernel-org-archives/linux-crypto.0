Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A705C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 586C261154
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhJ1SAb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 14:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhJ1SAZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 14:00:25 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F56C0613B9
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:57:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w4-20020a1709029a8400b00138e222b06aso3183872plp.12
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CJzxj2iqDipvs+pquBQbl+bcjtEOEAvwGOWZ8RzyC6o=;
        b=UBHr00wGhWNk0aRNHCqcfmT28gXQtA6Ax9ZCimGkJG9mvqXtl1c3F7ZJizsymoHfRi
         RuMPnzn9EA6asCnAo/ERZcPW7NmNNPtZSshlHhYqWSq01Qgf/T+XGqgO8ffD18h62/Tf
         bYRU06ppNrShs45YAqFdlcPGfGhTKprt1H7hs3yTCmmEshTJEM1rfAE/P/hqJSw+I850
         njN10Wg3/1l+oZayI0/+eT57g02FJpZqpNZjTBD8AnLZYEeqXz+PADyW6mY8rRBdm72k
         4eKAwL+IvFdO6N2JTPSDtvHGjHVkTmZEkqlvUDy0aFGxtdWpWB+fRu1Kc1dY8FCvx5Cc
         aOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CJzxj2iqDipvs+pquBQbl+bcjtEOEAvwGOWZ8RzyC6o=;
        b=IvEn1B32Cn43/3Y+Qnisjqlgt1bc1XzcOwW3lg606cvEm+xJuFTf7PbwXJTNkba2RT
         lZA92xUZYGytAzmHFBVoAT+0fk8PaKsuFpfXJsCYxaLz67iShtdZZ/dq1MGOv72+cE2i
         EuLzUlIFsEjBkEpwfnagvisUWxuAUMIrnfNMRXxr9JeiWTcfHUFqcJlPEejWTXMafX9f
         6jCQb9ual6K3NRZLHqwqRowpTPHwAn60tHdOu0+AoHTSxF4CWvFF01i9QrVVP/GQAUWm
         63USdE2osta2ft4Q9wPjpww+r8qmF3t0QkphOJsn5TEH7RtIzxaSVS3UpqWmW2B6tBRz
         frZw==
X-Gm-Message-State: AOAM533vXtRN2QlJGACM5HDPmfEw07zdt7sw2bzJajJYphshcz3TZLWz
        JO1fooU91BIbCeI7Wk5McUEZxpSQgd8=
X-Google-Smtp-Source: ABdhPJxuRnJjh5665jtoDHE/P4scnUhxmrO1YD+5mq45MupXrlDvCwpazfrLyxFoqo1v6G/O1xRti54Hdj4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:41d0:ac84:3b61:5938])
 (user=pgonda job=sendgmr) by 2002:aa7:8b1a:0:b0:44d:37c7:dbb6 with SMTP id
 f26-20020aa78b1a000000b0044d37c7dbb6mr5683432pfd.11.1635443877607; Thu, 28
 Oct 2021 10:57:57 -0700 (PDT)
Date:   Thu, 28 Oct 2021 10:57:47 -0700
In-Reply-To: <20211028175749.1219188-1-pgonda@google.com>
Message-Id: <20211028175749.1219188-3-pgonda@google.com>
Mime-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 2/4] crypto: ccp - Move SEV_INIT retry for corrupted data
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This change moves the data corrupted retry of SEV_INIT into the
__sev_platform_init_locked() function. This is for upcoming INIT_EX
support as well as helping direct callers of
__sev_platform_init_locked() which currently do not support the
retry.

Signed-off-by: Peter Gonda <pgonda@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com> (
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ec89a82ba267..e4bc833949a0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -267,6 +267,18 @@ static int __sev_platform_init_locked(int *error)
 	}
 
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+	if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
+		/*
+		 * INIT command returned an integrity check failure
+		 * status code, meaning that firmware load and
+		 * validation of SEV related persistent data has
+		 * failed and persistent state has been erased.
+		 * Retrying INIT command here should succeed.
+		 */
+		dev_dbg(sev->dev, "SEV: retrying INIT command");
+		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+	}
+
 	if (rc)
 		return rc;
 
@@ -1091,18 +1103,6 @@ void sev_pci_init(void)
 
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
-	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
-		/*
-		 * INIT command returned an integrity check failure
-		 * status code, meaning that firmware load and
-		 * validation of SEV related persistent data has
-		 * failed and persistent state has been erased.
-		 * Retrying INIT command here should succeed.
-		 */
-		dev_dbg(sev->dev, "SEV: retrying INIT command");
-		rc = sev_platform_init(&error);
-	}
-
 	if (rc) {
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
-- 
2.33.1.1089.g2158813163f-goog

