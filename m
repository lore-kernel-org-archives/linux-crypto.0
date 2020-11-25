Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974D7C64E7C
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 02:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AA5621D46
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 02:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mnac8xL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgKYCFf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Nov 2020 21:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgKYCFe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Nov 2020 21:05:34 -0500
Received: from kernel.org (unknown [104.132.1.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F44D2067D;
        Wed, 25 Nov 2020 02:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606269934;
        bh=owcj3wdVYKanekaIV/LKexGPXqZ0ESXPdUIBS5CRQyE=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Mnac8xL5J5ZX/rXfPEScACBuEFVNh/NSJprkhk1ZKFER/NBLMIq1nwSxpTiKMsZCt
         aP1pJWdWUI11C74nsnNuFkdnSeOhBxNkPTAa1ti0jaGDiMcWZ+8Sg1O5AD5GU+jVCW
         DSidh27bRf5eXdiHwp2YelIMjwfRokSvhsQRMUAY=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201119155233.3974286-3-thara.gopinath@linaro.org>
References: <20201119155233.3974286-1-thara.gopinath@linaro.org> <20201119155233.3974286-3-thara.gopinath@linaro.org>
Subject: Re: [Patch v2 2/6] clk: qcom: rpmh: Add CE clock on sdm845.
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
To:     Thara Gopinath <thara.gopinath@linaro.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, mturquette@baylibre.com,
        robh+dt@kernel.org
Date:   Tue, 24 Nov 2020 18:05:33 -0800
Message-ID: <160626993306.2717324.17114759592204357707@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Thara Gopinath (2020-11-19 07:52:29)
> Qualcomm CE clock resource that is managed by BCM is required
> by crypto driver to access the core clock.
>=20
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---

Applied to clk-next
