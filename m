Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B55CC04E69
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 10:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjHKKQs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 06:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjHKKQr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 06:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9838BB4;
        Fri, 11 Aug 2023 03:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D3C266E04;
        Fri, 11 Aug 2023 10:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C666C433C7;
        Fri, 11 Aug 2023 10:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691749006;
        bh=p0874zC3P/4HkNA+wVRJkLg0l75K8zpw30iVncdc3hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZnbEJxBBvvyRVrrgqaUgZZHjXTQaaVvRcmnG+Kw6tY0jW8JMLnEntCAan1/Jv/IwK
         7S2gJZ1TdIKGrRy6ZexEARpp7JOigKWp2EyHIPnSQm30nHkGgawvRoW4h7JlKMa6bW
         B9VZPDYj7V1mJVZxUoasRspo2Tk97FQH9M1olZHQ=
Date:   Fri, 11 Aug 2023 12:16:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     Oleksii_Moisieiev@epam.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        alexandre.torgue@foss.st.com, vkoul@kernel.org, jic23@kernel.org,
        olivier.moysan@foss.st.com, arnaud.pouliquen@foss.st.com,
        mchehab@kernel.org, fabrice.gasnier@foss.st.com,
        andi.shyti@kernel.org, ulf.hansson@linaro.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hugues.fruchet@foss.st.com,
        lee@kernel.org, will@kernel.org, catalin.marinas@arm.com,
        arnd@kernel.org, richardcochran@gmail.com,
        Frank Rowand <frowand.list@gmail.com>, peng.fan@oss.nxp.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [IGNORE][PATCH v4 01/11] dt-bindings: Document common device
 controller bindings
Message-ID: <2023081117-sprout-cruncher-862c@gregkh>
References: <20230811100731.108145-1-gatien.chevallier@foss.st.com>
 <20230811100731.108145-2-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811100731.108145-2-gatien.chevallier@foss.st.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 11, 2023 at 12:07:21PM +0200, Gatien Chevallier wrote:
> From: Oleksii Moisieiev <Oleksii_Moisieiev@epam.com>
> 
> Introducing of the common device controller bindings for the controller
> provider and consumer devices. Those bindings are intended to allow
> divided system on chip into multiple domains, that can be used to
> configure hardware permissions.
> 
> Signed-off-by: Oleksii Moisieiev <oleksii_moisieiev@epam.com>
> [Gatien: Fix typos and YAML error]
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> ---
> 
> Changes in V4: 
> 	Corrected typos and YAML errors	

Why are we supposed to ignore the first patch in this series, but pay
attention to the 10 after this that depend on it?

totally confused,

greg k-h
