Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CF2C0031C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 17:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbjITRKN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 13:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjITRKM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 13:10:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2AAA3;
        Wed, 20 Sep 2023 10:10:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2144BC433C8;
        Wed, 20 Sep 2023 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695229807;
        bh=4/QpFdXXat5YYWLWJXquh/jNvMlFGIeOXDZXtyrqkL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNXtXmMEtJ33lUPlF8cl/BbOYVSD5+rxt7WgqlwIDrVGwixMgEXspGeBc3Mnr33IO
         u7A1bjSASIYByr+Egg8GcA4fNFpNinYK5nJTPVNqJocdKevxQcJe05xMR7TZsHT/IW
         xL2SrHt/d6nyNx0LJt60N8yZJnGvhJzWiXJMWJ1OLvHDGPcj4ie3qArha+xSotz+3a
         0/w74WSiubSuA/LhhVpfEcQzNsaGhEGleoO6hUXc3MznIl5D9sehkBTJF6Ru/J5nWi
         hjz74eSVWuguXSAHuvtTLYTToQWH+Oj6eHZUO3xJzkEaMNhKWhqYSnocDS5vs+HEay
         8f4ahemZqTqBQ==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH 1/2] dt-bindings: crypto: ice: document the sa8775p inline crypto engine
Date:   Wed, 20 Sep 2023 10:13:55 -0700
Message-ID: <169523004971.2665018.5457570667421710137.b4-ty@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230913153529.32777-1-bartosz.golaszewski@linaro.org>
References: <20230913153529.32777-1-bartosz.golaszewski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On Wed, 13 Sep 2023 17:35:28 +0200, Bartosz Golaszewski wrote:
> Add the compatible string for QCom ICE on sa8775p SoCs.
> 
> 

Applied, thanks!

[2/2] arm64: dts: qcom: sa8775p: enable the inline crypto engine
      commit: 96272ba7103d4518e2d0f17daf6fe0008fc6e12c

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
