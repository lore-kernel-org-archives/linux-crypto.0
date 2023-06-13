Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24889EB64D8
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Jun 2023 22:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbjFMW1v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Jun 2023 18:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjFMW1r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2023 18:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0D61FC9;
        Tue, 13 Jun 2023 15:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5348E63B9B;
        Tue, 13 Jun 2023 22:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205D1C433C9;
        Tue, 13 Jun 2023 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686695246;
        bh=LgVl219+C8QFLtBQecP3c4ixxhp34QScKGMxJWxfL3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5IEpr2Cuhh5oteuZXaxrE9Dl/F1B3RgFwjQWauHSL3/JFDVa63y1EImfpAhu0TWG
         F014r8HdvX1ghXCWYKZW4WK6i8Dvp1P0d78+RyJQVwy5U97UcAbruAGYzu0fZyomnd
         8KMXdI4nb16o1auaGBlejJUFTAC7PQv26ZWlvAF9AIvZPBQbg9LQmeMTdKNlesXSJC
         psVx7UVUsEokyIT0hxrXOYE2WQ5ojcvyO68WQ4vGmMSI2m14wzHnwnnqWIsedaSPOt
         A7NUZ7XvKsfEUE/LTPWUdEoabNTOFoiGzjM9vfO/U8IJj83w1FFuT3HGbI+HKejvhS
         RaH9UF71e4LjA==
From:   Bjorn Andersson <andersson@kernel.org>
To:     agross@kernel.org, sboyd@kernel.org, p.zabel@pengutronix.de,
        herbert@gondor.apana.org.au, linux-arm-msm@vger.kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        Anusha Rao <quic_anusha@quicinc.com>,
        linux-clk@vger.kernel.org, thara.gopinath@gmail.com,
        conor+dt@kernel.org, konrad.dybcio@linaro.org,
        devicetree@vger.kernel.org, mturquette@baylibre.com,
        bhupesh.sharma@linaro.org, linux-kernel@vger.kernel.org
Cc:     quic_srichara@quicinc.com, quic_gokulsri@quicinc.com,
        quic_sjaganat@quicinc.com, quic_poovendh@quicinc.com,
        quic_kathirav@quicinc.com, quic_arajkuma@quicinc.com
Subject: Re: (subset) [PATCH V4 0/4] Enable crypto for ipq9574
Date:   Tue, 13 Jun 2023 15:30:22 -0700
Message-Id: <168669542896.1315701.6202135232520204215.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230526161129.1454-1-quic_anusha@quicinc.com>
References: <20230526161129.1454-1-quic_anusha@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 26 May 2023 21:41:25 +0530, Anusha Rao wrote:
> Update GCC driver to include clocks required for crypto.
> Enable crypto nodes in ipq9574.
> 
> DTS patch depends on the below series
> https://lore.kernel.org/linux-arm-msm/20230517072806.13170-1-quic_kathirav@quicinc.com/
> 
> Changes in V4:
> 	Detailed change logs are added to the respective patches.
> 
> [...]

Applied, thanks!

[2/4] clk: qcom: gcc-ipq9574: Enable crypto clocks
      commit: f6b2bd9cb29a1150a16f29a8d070e21317c62e71

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
