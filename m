Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81317C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 18:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4206D61353
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 18:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhESSkq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 14:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229982AbhESSkp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 14:40:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4940C6124C;
        Wed, 19 May 2021 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621449565;
        bh=yRW+htQIDwMH4ykLhdnlhwQpf0hw2usJ08nxwC3pNKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TjaTD7uWlB6PgNJbWS52J+lQ2TjoPN5LQLIMLFHOoJMAJDiCwXirVbNTVh47iuGc+
         d4q5zerH+NAyQ9oy42z/rDGd5DkQC0n6K6SWOfxPZIBhHMtZYPVke/89JloJw6IHEN
         Hl235VIBUHecUPjzfi393A1Oz90Q0j6Zh0JXXmonp7bq++KGIiCIFcKsyBsM7F5fDM
         a1yfU/7VhWOCZBJ/utvCeelTbjZnjH4b/veYhykSS4aMvj/VLj9A86nKInP9s8kr5K
         H+dh+le0DYuf2WgckR8k/vUIUIfaa3RBtoiNWZhPl+923bgpfZ+JHyxFnWLYntIHhk
         w6Fj7ajMN8dEA==
Date:   Wed, 19 May 2021 11:39:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] crypto: add gemini/sl3516 crypto driver
Message-ID: <YKVbW8T92bY3NG4u@gmail.com>
References: <20210518151655.125153-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518151655.125153-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 03:16:50PM +0000, Corentin Labbe wrote:
> The gemini SL3516 SoC has a crypto IP.
> This serie had support for it.
> 

Please describe how this was tested.

- Eric
