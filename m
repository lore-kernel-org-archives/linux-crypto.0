Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26116C25B6E
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjJ0KuW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjJ0KuV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:50:21 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7EBC9;
        Fri, 27 Oct 2023 03:50:18 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKPn-00BeO4-Cc; Fri, 27 Oct 2023 18:50:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:50:13 +0800
Date:   Fri, 27 Oct 2023 18:50:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Om Prakash Singh <quic_omprsing@quicinc.com>
Cc:     neil.armstrong@linaro.org, konrad.dybcio@linaro.org,
        agross@kernel.org, andersson@kernel.org, conor+dt@kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        marijn.suijten@somainline.org, robh+dt@kernel.org, vkoul@kernel.org
Subject: Re: [PATCH V2] dt-bindings: crypto: qcom,prng: document SA8775P and
 SC7280
Message-ID: <ZTuV5XxY+KqP+Qm6@gondor.apana.org.au>
References: <20231016143428.2992168-1-quic_omprsing@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016143428.2992168-1-quic_omprsing@quicinc.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 16, 2023 at 08:04:28PM +0530, Om Prakash Singh wrote:
> Document SA8775P and SC7280 compatible for the True Random Number
> Generator.
> 
> Signed-off-by: Om Prakash Singh <quic_omprsing@quicinc.com>
> ---
> 
> Changes in V2:
>   - Squashed two separate patches for SA8775P and SC7280 in one.
>   - Sort entries in alphabetic order.
> 
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
