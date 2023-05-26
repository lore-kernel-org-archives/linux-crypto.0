Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09767C7EE23
	for <linux-crypto@archiver.kernel.org>; Fri, 26 May 2023 19:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbjEZTXG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 15:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243832AbjEZTXB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 15:23:01 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0949DE5F
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:22:56 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-53033a0b473so762487a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 12:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685128976; x=1687720976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bfn7W4wlvGKYY1Xv+0AM7IhBXt2kfIwNQPmd+vEv/4w=;
        b=Dtoy7ewh54wR5VT72iH4ijb/9S+LZy3gcmEkuL3y9fXW/n43FVEitTHRQhuWvtZSOg
         KA7OKe8eJ3Mosl1THk8rMj+NSGnAmVmHIJ1Lk02nAqUwFpvw+i0aMp4SbTwyr3HAWnp2
         JOhXtWjEtdochNrzeiJmvZtuw3TCJxpCMon/9fr1hloWj0W9SVPjI3BuiGDEQUXbNcaH
         IvcPLGvRtVvw23Jxo/0SS3B58mRuAj2X3XtAOz99PzN0hfQ95yKL0JT+80glWyrCaEHW
         2cjZ4au835aDEGbdkFmtQYoDVRbRTF5LqKIFCMTTjbFzcrKh0SMiGDH0ISd1sIhP7QIf
         axqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685128976; x=1687720976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bfn7W4wlvGKYY1Xv+0AM7IhBXt2kfIwNQPmd+vEv/4w=;
        b=jau0I7KXp6BH8x3Ant7R1XQFhZ0Q5osTumw3eteWi6hSJNqevSya5hW9u7NhtV8MaL
         +XBgWGN5W8y54RUwG7RGxMg0dar0elfVAVOhUnWNF2EDqcNwWRoKrm3+9Jijn2mvzHAJ
         9D9SLeWh7//UmANL7l2LX2Fusuh+1ScsBR7ucsOE9lJ/Yj+e+9+8qyVZp8c0X8J+xEPG
         Et3ye+aNB/us9UoqNYiel1LAq/g0HazUMC0b1rZH0XyEcrKBH3fcIovb6QbxdJmd3EYP
         BO2T035BgWzcn03iOV87eGWL8x4pYpSHOXbTScLjcv8UHbfF+uyciwqBMrB0km6PV/zl
         2gNQ==
X-Gm-Message-State: AC+VfDxo6rfFLUEN3H23XB0QyU6wTDsHRr8WO+DET7PMoxyhq9CmfRl5
        1dY62XuWejcGmcRzjZ+vclEibQ==
X-Google-Smtp-Source: ACHHUZ5wANoFsNTRQmDGKRNutkbGrk9m4YPYtyi77j8epfqprAhfnQpkcsQ20alJ3V6q4FfYvzj5SA==
X-Received: by 2002:a17:902:d4ca:b0:1b0:440:7f5f with SMTP id o10-20020a170902d4ca00b001b004407f5fmr4451943plg.49.1685128975895;
        Fri, 26 May 2023 12:22:55 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1f3a:6990:1a5c:b29f:f8cf:923c])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b001b008b3dee2sm1955079plh.287.2023.05.26.12.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 12:22:55 -0700 (PDT)
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
Subject: [PATCH v8 04/11] arm64: dts: qcom: sdm845: Fix the slimbam DMA engine compatible string
Date:   Sat, 27 May 2023 00:52:03 +0530
Message-Id: <20230526192210.3146896-5-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
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
index cdeb05e95674..0d1d7328cd62 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -5221,7 +5221,7 @@ msi-controller@17a40000 {
 		};
 
 		slimbam: dma-controller@17184000 {
-			compatible = "qcom,bam-v1.7.0";
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			qcom,controlled-remotely;
 			reg = <0 0x17184000 0 0x2a000>;
 			num-channels = <31>;
-- 
2.38.1

