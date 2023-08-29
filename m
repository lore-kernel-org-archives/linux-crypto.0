Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F126C83F12
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Aug 2023 16:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjH2QXI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Aug 2023 12:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjH2QWj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2023 12:22:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10F8A6;
        Tue, 29 Aug 2023 09:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B0F062788;
        Tue, 29 Aug 2023 16:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBB8C433C8;
        Tue, 29 Aug 2023 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693326155;
        bh=7bXUJT2kfyzw7wkUfS8lZ78Kd1ZXxCKkRkhvrc8fDl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EoinLj3oznsPcWf/YylB/LBHyZqdAoZ4eE9Whhs473rhkonSq6wITSiEd3KzWEtsz
         rzKR14aZk8FUR+QjplaXqxwNEDNNCldABMMjq4IlS6Yhh/pcMlmdMS9lE+f7dhltw7
         9b+s7IGxT5FK8nt9MNY1feYGaQlE/SNRujNSvQW5wyheGO7OJU+0WgJJNQ/8AxDwAQ
         CtXGWSiVO3bX2opi6t0VHEmzD76ewDF6ZdqHHsuWLQo0znfWvFipG7xPJ1myR1MVWy
         qxZON2t4o8cTagDm7ybXJW0zZwocJuA73fxOAP3k4u+1uXYEj4SswnirsfmkafbYy0
         OdxBA6RNHo8uQ==
Received: (nullmailer pid 2288009 invoked by uid 1000);
        Tue, 29 Aug 2023 16:22:33 -0000
Date:   Tue, 29 Aug 2023 11:22:33 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>
Subject: Re: [PATCH v3 4/6] dt-bindings: crypto: qcom,prng: document SM8550
Message-ID: <20230829162233.GA2283052-robh@kernel.org>
References: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
 <20230828-topic-sm8550-rng-v3-4-7a0678ca7988@linaro.org>
 <20230828213610.GA386486-robh@kernel.org>
 <c741c4be-50b4-0bd8-79eb-37895342f5af@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c741c4be-50b4-0bd8-79eb-37895342f5af@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 29, 2023 at 08:38:48AM +0200, Krzysztof Kozlowski wrote:
> On 28/08/2023 23:36, Rob Herring wrote:
> > On Mon, Aug 28, 2023 at 10:04:39AM +0200, Neil Armstrong wrote:
> >> Document SM8550 compatible for the True Random Number Generator.
> >>
> >> Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
> >> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> > 
> > Where's Krzysztof's tag?
> > 
> 
> The patch evolved and Neil mentioned in cover letter changelog that he
> did not collect Reviews because of that. Seems ok for me.

I did go look there and just saw 'Added review tags'. Not too helpful.  
That's why changelogs for a patch belong in the patch.

Rob
