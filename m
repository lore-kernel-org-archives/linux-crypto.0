Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56922C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 22:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A285613D8
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 22:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhEEWKm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 18:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhEEWKl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 18:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62919613D6;
        Wed,  5 May 2021 22:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620252584;
        bh=MrFPJWMFWa2Yv9X0RL/C0HOz8fh7sy6Uvwm9FYcYjag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HsZXp4zUwt0UoBrKcTcj6EsxJQg9uZZYCxa4FRbrCpAmBwzWySsLoqBR4DcWc++kN
         DTH8r+R2tQ9HEFB+csGOwEc2tvq9g7oEx3tvuaWz2a0oH87B2q6ueKrQEMWia8EE4i
         uu1VqX//aBuEXL+uDX4zREvvz85UCtUgHfHih2g1lJVr+9eI9uDzMpSh1YIzSFkcdY
         hYAtXrMu8H3q+6iueFg2WdAEgsD4ugtQsNRWc/vP8G0ieyR4C14zW4YF/O9bgwKVFP
         EEdJVvL06zCIDXNGisyAO0AzgffRJ/RdrDocj4Sq6Wp34s4DozFNC8Kgh7CK9d3oFB
         XG50JVFe9yhHA==
Date:   Wed, 5 May 2021 15:09:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: Re: [PATCH v2 00/17]  Enable Qualcomm Crypto Engine on sm8250
Message-ID: <YJMXpi1V/2vTdJKD@gmail.com>
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 06, 2021 at 03:07:14AM +0530, Bhupesh Sharma wrote:
> 
> Tested the enabled crypto algorithms with cryptsetup test utilities
> on sm8250-mtp and RB5 board (see [1]).
> 

Does this driver also pass the crypto self-tests, including the fuzz tests
(CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)?

- Eric
