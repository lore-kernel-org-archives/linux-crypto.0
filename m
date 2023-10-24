Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9F6C25B6F
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Oct 2023 16:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343830AbjJXQVC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Oct 2023 12:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343853AbjJXQU4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2023 12:20:56 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D086610D1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Oct 2023 09:20:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-53df747cfe5so7340483a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Oct 2023 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1698164449; x=1698769249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKvuKpR6kDazmh6thDgnN9OKi8VRnTOS23Ea0LWxTCY=;
        b=SZgWCCKz7EWyqOQz96MOf8JAgDLazTvThwtgldeY+6stxPCKhqW1bzsDTgmKLrV7E9
         pybPCMzE4PcAJNXDgZDywpLeSGx8v/tso5xAveVfKBPmhfApB1xn1s9LxkCwsbnCpPdV
         F5DUWnUrjv2DyLTsIQyz30XtvIOBqi5Wg/JnzAfINwaHGEJAxrw9rZmKnDEd1ciL7C1b
         7de0rt8qOkWNVV3Xbfiq7RTh7ucMgbj4ng5EJtCc8m8HdnS6p2YDta+c+eFhn963o9fU
         65QKq0PNmcVp7EgtLNQshE8P6Xs324k7afK/mgIgn6TG2q5EFZgmJFBD0o3wbM8ZPsGP
         hIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698164449; x=1698769249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKvuKpR6kDazmh6thDgnN9OKi8VRnTOS23Ea0LWxTCY=;
        b=I6z2X4WFSt+tWxZuFQ3Cqa9og4jX6OVykkUlugG9moxvwBBqNzVFMrwlbwzxht6o9Z
         oDwgNfNvobUV/n+F9YWCzC0koCDhHrcAxq2kFiKeZ1Zz5j4a9yJNpqBqsMa3AddbyUsu
         U4A8CY1pMTTHHovt7luHexnVj5DB2UyqlD8LQ9kWXi1fqskZW4rQ3R4fuwyEi3nUKIhc
         27tuhMTJjqyrSUXWMP2wuQ8ahx8h1/rfo/HyO7XUtyJjr0CP017MvSF0LuTp+XjjHvDh
         hY2IvBHhpzZwVTaJ5punI6olMGoUIO/RLHlYn4XKbgF4dl3WhL4RWrE9/pMah3UULb09
         8+Dg==
X-Gm-Message-State: AOJu0YwfZDwoVDYtR2UAtIIr/sRKZFLyKbADdADIwNZIPlciVp3Bk251
        9eAJP3yh+gXe408Mci6B2tLZMQ==
X-Google-Smtp-Source: AGHT+IEsIMDMMXiyky9XeXMo8yp/3tzLQ/Zvl/6E5uEox/9qGpj9fohIT5ZY5ySf/uNOdqIWfBOh0Q==
X-Received: by 2002:a05:6402:50cc:b0:53e:5dad:dce7 with SMTP id h12-20020a05640250cc00b0053e5daddce7mr11006208edb.29.1698164449166;
        Tue, 24 Oct 2023 09:20:49 -0700 (PDT)
Received: from localhost (clnet-p106-198.ikbnet.co.at. [83.175.106.198])
        by smtp.gmail.com with UTF8SMTPSA id t20-20020a50ab54000000b00533e915923asm8352930edc.49.2023.10.24.09.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 09:20:48 -0700 (PDT)
From:   David Gstir <david@sigma-star.at>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Gstir <david@sigma-star.at>, Shawn Guo <shawnguo@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        sigma star Kernel Team <upstream+dcp@sigma-star.at>,
        David Howells <dhowells@redhat.com>,
        Li Yang <leoyang.li@nxp.com>, Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tejun Heo <tj@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-security-module@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Subject: [PATCH v4 4/5] docs: document DCP-backed trusted keys kernel params
Date:   Tue, 24 Oct 2023 18:20:18 +0200
Message-ID: <20231024162024.51260-5-david@sigma-star.at>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024162024.51260-1-david@sigma-star.at>
References: <20231024162024.51260-1-david@sigma-star.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document the kernel parameters trusted.dcp_use_otp_key
and trusted.dcp_skip_zk_test for DCP-backed trusted keys.

Co-developed-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
Co-developed-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Signed-off-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Signed-off-by: David Gstir <david@sigma-star.at>
---
 Documentation/admin-guide/kernel-parameters.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0a1731a0f0ef..c11eda8b38e0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6566,6 +6566,7 @@
 			- "tpm"
 			- "tee"
 			- "caam"
+			- "dcp"
 			If not specified then it defaults to iterating through
 			the trust source list starting with TPM and assigns the
 			first trust source as a backend which is initialized
@@ -6581,6 +6582,18 @@
 			If not specified, "default" is used. In this case,
 			the RNG's choice is left to each individual trust source.
 
+	trusted.dcp_use_otp_key
+			This is intended to be used in combination with
+			trusted.source=dcp and will select the DCP OTP key
+			instead of the DCP UNIQUE key blob encryption.
+
+	trusted.dcp_skip_zk_test
+			This is intended to be used in combination with
+			trusted.source=dcp and will disable the check if all
+			the blob key is zero'ed. This is helpful for situations where
+			having this key zero'ed is acceptable. E.g. in testing
+			scenarios.
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
-- 
2.35.3

