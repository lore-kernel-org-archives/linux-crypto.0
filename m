Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD211C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 17:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjG1Rjs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjG1Rjr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 13:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF562D4D;
        Fri, 28 Jul 2023 10:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35B2B621B9;
        Fri, 28 Jul 2023 17:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CD0C433C8;
        Fri, 28 Jul 2023 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690565984;
        bh=RnyiRDGe8sr5exbmJAcAawkOFhbk5z8TLN6R9p+ZT3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qg3v2LnTBt0EZr7gZBzzJaabEIuUd2iZWmHIOkTlpowzwViFShsi0ED3+OGiNY5Mg
         h5NC6ILShm5fcplSBvvax7rUbp0cEw/3/+MbLJCJS9efFUaK1gxcInV5bB6wzdhxPm
         e12+1MZCYyru0UJV3moUiLTKiUYIIYCuQRcacWLsCi4A/C1Lg4vZZ16tbq6U5njUo7
         4Fgme9LN6UMYxJflWYhuABtdFA8WLXaZ6S5KYUHmYPXI4fhhc/AfEv6rybqEXUdUMO
         vKzTfhkQPmsYQoPZEjbOBX0YFKFRkn8kCYNDjDD8RFZGGN6WrD7VQi/WF7cA5aO3wv
         O9WL9BYcNQW2w==
Received: (nullmailer pid 325463 invoked by uid 1000);
        Fri, 28 Jul 2023 17:39:41 -0000
Date:   Fri, 28 Jul 2023 11:39:41 -0600
From:   Rob Herring <robh@kernel.org>
To:     Varshini Rajendran <varshini.rajendran@microchip.com>
Cc:     krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org,
        alexandre.belloni@bootlin.com, herbert@gondor.apana.org.au,
        claudiu.beznea@microchip.com, linux-crypto@vger.kernel.org,
        tudor.ambarus@linaro.org, devicetree@vger.kernel.org,
        conor+dt@kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, nicolas.ferre@microchip.com
Subject: Re: [PATCH v3 10/50] dt-bindings: crypto: add sam9x7 in Atmel SHA
Message-ID: <169056598062.325408.11078837975857093343.robh@kernel.org>
References: <20230728102433.265772-1-varshini.rajendran@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728102433.265772-1-varshini.rajendran@microchip.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On Fri, 28 Jul 2023 15:54:33 +0530, Varshini Rajendran wrote:
> Add DT bindings for atmel SHA.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml   | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>

