Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1442CE7A81
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Sep 2023 20:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjIVUth (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Sep 2023 16:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjIVUtg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2023 16:49:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06604CA;
        Fri, 22 Sep 2023 13:49:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E0DC433C8;
        Fri, 22 Sep 2023 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695415770;
        bh=FPBJggAqY3MztbyF5zZ2NdjIeZqv2URtl6MtPiF6gnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QhQdNr5AXpQdzHkF60qZT6YR4V9QaZ0PBw35A2BRTzX2/EeYjvotEXkl+Ygn6/qnF
         k9y+Xu508Ix2oAPSXjWqNL24akI3+Pb68NuYrTpvQQ4yRUOkoDsrWGhNOLg8mgGipW
         C2ES7eZrzRW862C5sGdbZN3SVh/VcT6BE6C24LBlLTQrPZ3/vj0O6fWeVLjaNU9pDw
         awEOaez533uRlXrv2dmKh6Ya18xtQLzaSgQi6+jdaU8Kz74OJP0abISysC74Zz+BPe
         wVGnjxKNX/pfPn6eHvmlKkR1E0NBEp2GlwlzY8jhJlivxHtprysh7d6oxuRrwJX6xZ
         Uhuoibj/XBQcg==
Received: (nullmailer pid 3555012 invoked by uid 1000);
        Fri, 22 Sep 2023 20:49:27 -0000
Date:   Fri, 22 Sep 2023 15:49:27 -0500
From:   Rob Herring <robh@kernel.org>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Olivia Mackall <olivia@selenic.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/9] dt-bindings: rng: introduce new compatible for
 STM32MP13x
Message-ID: <169541574331.3554336.16089460775037826049.robh@kernel.org>
References: <20230921080301.253563-1-gatien.chevallier@foss.st.com>
 <20230921080301.253563-2-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921080301.253563-2-gatien.chevallier@foss.st.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On Thu, 21 Sep 2023 10:02:53 +0200, Gatien Chevallier wrote:
> Introduce st,stm32mp13-rng compatible and add st,rng-lock-conf.
> 
> If st,rng-lock-conf is set, the RNG configuration in RNG_CR, RNG_HTCR
> and RNG_NSCR will be locked. It is supported starting from the RNG
> version present in the STM32MP13
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> ---
> 
> Changes in V3:
> 	- Squashed with: patch [V2 07/10]
> 	- Declare st,rng-lock-conf at top level and restrain its uses
> 	  depending on the compatible. I discarded Rob's tag as for
> 	  the modifications.
> 
>  .../devicetree/bindings/rng/st,stm32-rng.yaml | 20 ++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

