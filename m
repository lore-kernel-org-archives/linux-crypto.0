Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16588EB64DA
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 10:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjGJKX2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 06:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjGJKX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 06:23:27 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC0AA4;
        Mon, 10 Jul 2023 03:23:26 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b867f9198dso7642255ad.0;
        Mon, 10 Jul 2023 03:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688984605; x=1691576605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/bES5zK8LfFOykRC97jWvEVozpQHjO1n1TwlTrs0pDo=;
        b=XJd1AdkP5i26E0jRIx43SZEhT8iTIXZSdJDgQ2egpeJTMEz0Fp7BEVXrVgOmyfQUaS
         h6050GANKD90idk2a1dKLzG0l6HFqJ6UoYINEDdwEcSuJQsiVxR9impwkrjOH/j/FhYS
         VY7HYHkeWVmWws6SMulYGty2qLAtbcyQhieMQ3H11JqFvabvwWEMo9c4yX8rT13LJFF3
         /jfHFjIfHcch8FWvDh9vzn34KaBb+cGH/7I2x/kpazrANXaqjPnoFTE3vr6hZWgduCLy
         e4PUgsckjol7nyaAx5anIslsHJt4Pad+6rRruNBYbDPQy86F2kSeynGI6HwvuBob7gXi
         PXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688984605; x=1691576605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bES5zK8LfFOykRC97jWvEVozpQHjO1n1TwlTrs0pDo=;
        b=KPFhQpgxKtpfPur1kig1oP+Yq9OHmaHlVX61pG9Whn9XOrU5XnDsgKFSg2EGPcGO+k
         KgnsbkHZC5sNBvkxy68MqZfyHl5aquVodxITtVl1LxMIUIyHAHzj6Vgx5MwUhJ6kPIG7
         HNXhPU/UAeOB+yJ+LWcj0BaNYzs6sKWWd0wT3axQb8+OTAOOhTFxN7uPz14VcIIYe8wH
         teTTb6CuwGAvH+j37w0rl4clfmCq42RJXXhgQAonja0QhSYiCE2oEzL63sWDABHsVrno
         NXhvl0AgxQwXqEt2XVwtc9y+LInxvOy6kTgas7Pu7QeitpcQ04bxdodoa9R25rmfSoZp
         cXxg==
X-Gm-Message-State: ABy/qLZM53CpcJUTr28fwsNjnjejhJjtWKCfvCO4P7pX9CLqu+isAF48
        DfeF24zWk3dT9EJbqO/lJykKMx9u/YRetvY5
X-Google-Smtp-Source: APBJJlF8mNENavwfmHPm4sg9nfRrfTMpQA0coeANubDmtepTsYFki89FZdm9IZeY8EqIWZvm2KOMYg==
X-Received: by 2002:a17:902:e809:b0:1b8:1591:9f81 with SMTP id u9-20020a170902e80900b001b815919f81mr16160703plg.4.1688984605206;
        Mon, 10 Jul 2023 03:23:25 -0700 (PDT)
Received: from ip-172-30-47-114.us-west-2.compute.internal (ec2-54-68-170-188.us-west-2.compute.amazonaws.com. [54.68.170.188])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b001b5656b0bf9sm7901984plg.286.2023.07.10.03.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 03:23:24 -0700 (PDT)
From:   FUJITA Tomonori <fujita.tomonori@gmail.com>
To:     rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     alex.gaynor@gmail.com, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, benno.lossin@proton.me
Subject: [PATCH v2 3/3] MAINTAINERS: add Rust crypto abstractions files to the CRYPTO API entry
Date:   Mon, 10 Jul 2023 19:22:25 +0900
Message-Id: <20230710102225.155019-4-fujita.tomonori@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710102225.155019-1-fujita.tomonori@gmail.com>
References: <20230710102225.155019-1-fujita.tomonori@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The files are placed at rust/kernel/ directory for now but the files
are likely to be moved to crypto/ directory if things go well.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 250518fc70ff..3dd33850ff7e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5446,6 +5446,8 @@ F:	drivers/crypto/
 F:	include/crypto/
 F:	include/linux/crypto*
 F:	lib/crypto/
+F:	rust/kernel/crypto.rs
+F:	rust/kernel/crypto/
 
 CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
 M:	Neil Horman <nhorman@tuxdriver.com>
-- 
2.34.1

