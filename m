Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C78C56201
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DECB820888
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tzSx5Bzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgKSPwj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbgKSPwi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 10:52:38 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F11CC061A4D
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:37 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id k4so5727922qko.13
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Npw6pndFeDGN1j2LCowh5jKLxcwFxW0ubJq0P0MtToo=;
        b=tzSx5BzoSWa+UyX23Szfm8Za+2AUHXHyE1c/mT8Nff0Lu1w8kEyfDAAdP57DYKHkJO
         oyfEj6ErpuYVuwv3FgF4lhNkvWwj4EJIs/hzwmU8+M6fasdS2y/UwZCbqx+8G7lfhqt1
         ga1EqQZzUpNH8TaRzgVMMhtemfyvlFCLuFtfcuMmnl6YxwXLVjWUKYb0k2RKp/KEhVwR
         aes6IhVH4Y1BRnGT2gIE2gVBpAz3GqTREs6T2yeYNWgTPwfvV3wvpNF69WaMgKRDk/Pd
         BrUWYSc3kAfGV4NdD0cfhjsxBeQk6eAvvUbhH4OrZ4P+0FROL3rtlVXPT/GqPkG9PGZG
         KYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Npw6pndFeDGN1j2LCowh5jKLxcwFxW0ubJq0P0MtToo=;
        b=fXJOEX/W8prZOrwX62BA7d2IbtRyUagLxcbREa6P4r6RSvPj9fULMCNjGuMf8dpJ8V
         eM8dufLz4CC/PIFMT83Po9eQVzoruiBnCDRYkELq27bW6IqiNS6eGpdSmhi9zuiCBFDT
         OSMlGNaBc6cZEHa8OJcgu//8WRllomN8rGMICr6Y9ufE5Jzg2uzWNyKIVAQ8KPzfmuzG
         v/rpP66B3vooCQVBzsfd3xJJ6c+8dGtiz0PoL3BzYuCvYsWyLiwwn5WfZXZ8V/vBNtTx
         u+M32sj/VXZuKGpVK9kkAUdu4L0DemVzDEgIZtXxMkhSzDYwNJ75qAZ5nWjYO6XjMyO6
         WUNw==
X-Gm-Message-State: AOAM533NNgmMeRAbKgfAEL/MnQ3WGrjJHIJemhFrYbafacUihnQkoKr4
        5gC5kOMYR+zKTAFn+I7UERHY6w==
X-Google-Smtp-Source: ABdhPJzE/cpIdffZF7GXTI12bMsYjzDIHtiepu5cxTYppLPpKsAIMXNtigSCwXOsudsnLdzUqij17g==
X-Received: by 2002:a37:52c3:: with SMTP id g186mr11115468qkb.1.1605801156368;
        Thu, 19 Nov 2020 07:52:36 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id g70sm127290qke.8.2020.11.19.07.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:52:35 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [Patch v2 1/6] dt-bindings: clock: Add entry for crypto engine RPMH clock resource
Date:   Thu, 19 Nov 2020 10:52:28 -0500
Message-Id: <20201119155233.3974286-2-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119155233.3974286-1-thara.gopinath@linaro.org>
References: <20201119155233.3974286-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add clock id forc CE clock resource which is required to bring up the
crypto engine on sdm845.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 include/dt-bindings/clock/qcom,rpmh.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/qcom,rpmh.h b/include/dt-bindings/clock/qcom,rpmh.h
index 2e6c54e65455..30111c8f7fe9 100644
--- a/include/dt-bindings/clock/qcom,rpmh.h
+++ b/include/dt-bindings/clock/qcom,rpmh.h
@@ -21,5 +21,6 @@
 #define RPMH_IPA_CLK				12
 #define RPMH_LN_BB_CLK1				13
 #define RPMH_LN_BB_CLK1_A			14
+#define RPMH_CE_CLK				15
 
 #endif
-- 
2.25.1

