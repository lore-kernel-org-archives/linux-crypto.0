Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FB6CA0EC8
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Sep 2023 21:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353822AbjIKVuz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241328AbjIKPGs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2023 11:06:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B28FA;
        Mon, 11 Sep 2023 08:06:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C584AC433CA;
        Mon, 11 Sep 2023 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694444804;
        bh=1jkS9Ats1JoDNaymOePPSbD5PM9h6PddgwPxnahLIiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzW0fLfcR2ykeJzwkX/u0r/Yz3k3XIUyeCjbRtY8h+8VuXge1dOIb1AI/am7yyLFc
         VipgVDoQGEStg5piUu/uDQ+QnD9vJVDIdQmr5rlHkvaW9RbbwkgZaPpXRtwqMBBoVI
         /E1+YF58hIqBpeXOZnqxM1PyAoXI7RPkCBGpd9oybYLVaOQpgvh7fZ1GxLE7HLRUDe
         gHHFy6awF+1XinYQgWGn7xLzTv3cZG7iJ7rn2ZJENaulIunCtWGrYtjKC7kmkyAMIT
         kNnOGDFXc4fY08i7znUIzH3eBMU8ZD+PM1ok5mim/3lkJTqavTa3lJPzSYn5nYCpkK
         xzg3I4q348Oew==
Received: (nullmailer pid 1255885 invoked by uid 1000);
        Mon, 11 Sep 2023 15:06:41 -0000
Date:   Mon, 11 Sep 2023 10:06:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Olivia Mackall <olivia@selenic.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Subject: Re: [PATCH 01/10] dt-bindings: rng: introduce new compatible for
 STM32MP13x
Message-ID: <169444480100.1255834.17566582577816053132.robh@kernel.org>
References: <20230908165120.730867-1-gatien.chevallier@foss.st.com>
 <20230908165120.730867-2-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908165120.730867-2-gatien.chevallier@foss.st.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On Fri, 08 Sep 2023 18:51:11 +0200, Gatien Chevallier wrote:
> Introduce st,stm32mp13-rng compatible.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> ---
>  Documentation/devicetree/bindings/rng/st,stm32-rng.yaml | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>

