Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AD1EE49A4
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Sep 2023 00:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbjIMAvK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Sep 2023 20:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjIMAvK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2023 20:51:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F90E125
        for <linux-crypto@vger.kernel.org>; Tue, 12 Sep 2023 17:51:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-cf4cb742715so5997116276.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 Sep 2023 17:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694566265; x=1695171065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DtPnDCTduCEq3Qr2ITLJnxh4c9FOD2gvVINJPxBbxIM=;
        b=M9HE9gpSilLT/CYs0oWeMyB+mCD6/NQUz3ojVhqmGa3sHNL3qeDpQxnTxGrPn3HXVl
         7wTZAFRNlH2BH65QvceQl7KpX8bC/u6SuqX9qlRWCLMXj13EAa1KuPHCalL2BOoeULLm
         kplnbB7z3Dq0+7lOZP7ctvBjuuFEq2JrSnP3mlfoFFlMVZ2+sqFQYmQvpGT+Juf3M227
         SuN14b6S6wjEUi0UlnYMZLXuG8WJoCixjsM0zRH7hpWglM7pW3aNkZL5t0iq0aTsJdxc
         b98Gm4LsMdIXMBMdfJPFXXqYBy8lnPS6YG+R+0UMtqnx9V38ZEyDtL98BrivaH6R2nHM
         wZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694566265; x=1695171065;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DtPnDCTduCEq3Qr2ITLJnxh4c9FOD2gvVINJPxBbxIM=;
        b=turg05QBBddf4yCFn6V+1+Y6pRDOpcCX2pVZY6G0OeUUdDxmivwXlp4dVWaogxTnkJ
         2LTf1mQV/GVKm2X/CskgwjrmknABR8QDkamC4kDVY6ZvKsOARP8LX4k8eLVFnzEB0PVO
         IPssEzW+J7YQanPBida6osJKKdHkEGiVhL3+u24cqy4cNY2EXvHLoxmXnCnTLpShOwLV
         l5eoMLP7Um97A+zVXjGDsvXgF9wkTeJaU1PAOdT1P3R8ndTV3oyBQfdM1FVNSjGKVXYq
         pDOrZEmtp4/VcF7LnCb+cNMx3hAU1J3eArg6oA9KcpXr22qyVbZGyhAyrlXBV3OeEUrP
         AD+A==
X-Gm-Message-State: AOJu0Yy1ZdRzm+yP4kHH3w18hM7phMflwtP5bS55SYKsgbQKz5ASUICI
        TTCHQy3oZXn5FHqjquaiSot5ZVKQ8p5x6KQ7NA==
X-Google-Smtp-Source: AGHT+IGsb3nv5OgzhkeL2GMJhAKdH/BPRBmT4a0/zqlpEa886WBsZj6ujoMsQkCL/Ix4d4IOUqxjtfJBlGBs9hHgqQ==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:80cf:0:b0:d7a:8e37:6d4b with SMTP
 id c15-20020a2580cf000000b00d7a8e376d4bmr24345ybm.3.1694566265616; Tue, 12
 Sep 2023 17:51:05 -0700 (PDT)
Date:   Wed, 13 Sep 2023 00:51:05 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAHgHAWUC/x2NQQ6CMBBFr0Jm7SQtVSNexRiDw1QngRamlUgId
 7eyeMl/m/9WSKzCCa7VCsqzJImhiD1UQO82vBilKw61qZ1prMOUNdC4YKcysyYkXcYcUULmHqc 2/3lQHIYY9vmhPiKh8cenPV+c8acGyvmo7OW7h2/3bfsBsFNY4YgAAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1694566264; l=1599;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=HFa7caLHh4Y4K31X6bYgfzu3rT5WKQkHKQH1LYS4bEc=; b=+lu5hyujktY6X9/cBe5+BmqWrHRCKzqDZdz0TNVSMtMZRhiU9xGmyaYaMN9EBmB1I+nNLMEz7
 9VTSzTgoBnkDFy9+1xv8Sosc5rYEZRxUPDH1+VCngkJ7eL9yey6Slg7
X-Mailer: b4 0.12.3
Message-ID: <20230913-strncpy-drivers-crypto-intel-qat-qat_common-qat_uclo-c-v1-1-88a6c07fc924@google.com>
Subject: [PATCH] crypto: qat - refactor deprecated strncpy
From:   Justin Stitt <justinstitt@google.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

`strncpy` is deprecated for use on NUL-terminated destination strings [1].

We should prefer more robust and less ambiguous string interfaces.

`buf` is expected to be NUL-terminated for its eventual use in
`kstrtoul()` and NUL-padding is not required.

Due to the above, a suitable replacement is `strscpy` [2] due to the
fact that it guarantees NUL-termination on the destination buffer.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index ce837bcc1cab..e2f82128043e 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -200,7 +200,7 @@ static int qat_uclo_parse_num(char *str, unsigned int *num)
 	unsigned long ae = 0;
 	int i;
 
-	strncpy(buf, str, 15);
+	strscpy(buf, str, sizeof(buf));
 	for (i = 0; i < 16; i++) {
 		if (!isdigit(buf[i])) {
 			buf[i] = '\0';

---
base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
change-id: 20230913-strncpy-drivers-crypto-intel-qat-qat_common-qat_uclo-c-0f4b16830f59

Best regards,
--
Justin Stitt <justinstitt@google.com>

