Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E85E748F3
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Oct 2023 08:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbjJAIdQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Oct 2023 04:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbjJAIdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2023 04:33:15 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA386A7;
        Sun,  1 Oct 2023 01:33:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qmrsn-002PTt-Vj; Sun, 01 Oct 2023 16:32:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Oct 2023 16:33:01 +0800
Date:   Sun, 1 Oct 2023 16:33:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: ice: document the sa8775p
 inline crypto engine
Message-ID: <ZRkuvVkyLJGOnQnH@gondor.apana.org.au>
References: <20230913153529.32777-1-bartosz.golaszewski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913153529.32777-1-bartosz.golaszewski@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 13, 2023 at 05:35:28PM +0200, Bartosz Golaszewski wrote:
> Add the compatible string for QCom ICE on sa8775p SoCs.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
