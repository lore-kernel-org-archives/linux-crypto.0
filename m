Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8258C7EE26
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 21:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjESVtZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 17:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjESVtE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 17:49:04 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DD010D4
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6436dfa15b3so2760841b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684532935; x=1687124935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZX6LVgOMZu0ArktFgLVf83JETk2AvPW+GkyQpaVw8k=;
        b=rPKR9Rx3JRg/0vvHaNXGmGLwQD5W3k6kCmmuzWJKWlIkRFaalkFvu9V/4ypfPte2ui
         VwaCd/TcG4vjvWr+Ff+2/Qe9MVbpkAfwRhZCCPzgWumrT3vAv37CxHPMb7RvJVlBioui
         g1AZip+tAFNcpVI91dwcEgyEIE27NTX9id/ADcBh5ya+srJ8WO5VTHDr+d52YGwpG1jo
         E844cPkxj+zSzSbAw2k9FZYSjHr+jBHuDf0xKOewl97kAfwm4wePEXxhgM8WJem/gcmr
         j3RO8hLWK9EXTljjVFwxQcT60xbOzK4z+9RYO23Pd9kuFur+CgPCCOt0203JSVNUCnnx
         pxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684532935; x=1687124935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZX6LVgOMZu0ArktFgLVf83JETk2AvPW+GkyQpaVw8k=;
        b=PtI5lfSGBZZT1z0LBSrGyMWEeM/vs3iPIfM3WkqCshWca30luZul4wbQ9WBiOBtRZf
         O2XXyAjbQYmu2ugJ64fsvrFENGWViCObFO3BuvB6yZdKvTDDVEKGGFmQ4M3NhwzIeTXG
         FH/8aZFNqVGbmz4/sHQd5SUegrT6RZOrDSWJk+wt5OkqpJkWVXETVCRhB6rqasB221Og
         f0y5XMPhdI17W5aUr9XHYUdr8gl73dyzAsNKgOsMWRj91RAEakVJkLBwFg4VsUnhFXgG
         l5XUYXjSyeB3zPWFfhijZ+miOYgFspB22hN3uAJRm5CZs2pxrKkOLLiMaZ90k3YYNo1q
         SDDQ==
X-Gm-Message-State: AC+VfDzO0+WfeO1dPNROwdVBczpiYprQDKMkJd5arihGt/DX34GoPHMg
        fNtJQ0ZyFqcksbTlvzXBqMNyJw==
X-Google-Smtp-Source: ACHHUZ7HN3g/AYQq4g1o3ywAtgSwto6zSC+wBqyNlsDixCqV9bMuIYqgilZ4+2ApoGWwOMP7VtGApQ==
X-Received: by 2002:a05:6a00:1389:b0:643:b27f:6c43 with SMTP id t9-20020a056a00138900b00643b27f6c43mr5326688pfg.27.1684532935042;
        Fri, 19 May 2023 14:48:55 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d309:883d:817e:8e91:be39])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7904e000000b006470a6ef529sm144891pfo.88.2023.05.19.14.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 14:48:54 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH v7 04/11] arm64: dts: qcom: sdm845: Fix the slimbam DMA engine compatible string
Date:   Sat, 20 May 2023 03:18:06 +0530
Message-Id: <20230519214813.2593271-5-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
References: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As per documentation, Qualcomm SDM845 SoC supports SLIMBAM DMA
engine v1.7.4, so use the correct compatible strings.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 90424442bb4a..4d768e09d62d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -5212,7 +5212,7 @@ msi-controller@17a40000 {
 		};
 
 		slimbam: dma-controller@17184000 {
-			compatible = "qcom,bam-v1.7.0";
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			qcom,controlled-remotely;
 			reg = <0 0x17184000 0 0x2a000>;
 			num-channels = <31>;
-- 
2.38.1

