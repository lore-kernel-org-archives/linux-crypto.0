Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BECC32771
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Sep 2022 18:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbiI1S6i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Sep 2022 14:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiI1S6g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2022 14:58:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C303F3F97;
        Wed, 28 Sep 2022 11:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE599B821C3;
        Wed, 28 Sep 2022 18:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F7DC433D7;
        Wed, 28 Sep 2022 18:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664391512;
        bh=73cqCtnNsDvfXsy6P+CF5Gnpa0oRjpEWOATabkd0y9k=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=U1sH8DCduJBFVtNE7yAlXn+ak+MjNp86ZbDmHrcjAysL2CoJnUObFmS9WNGjF8SaU
         lgeXbWR/3OJLLg8wlRs+xo69pUEwgVSTtBpJRdiKsiA/pSXsXGhOWTqDtzSTYhCvlX
         NMHvN23fb+IA+pu6jw7hn+pcz/xe1A82Xe+wKRlRtUPpg5YySPJK/HNbotjrwsFuwd
         6YPscxERooUYDYQu7LD6SXQ8brpzaXj+vtecP3pNaAB2t9EUy0iEhZHi/GUOIF+g86
         CzTAkiLNISzTaJyaCQVkaCMBR2DxeXtMfFC38dtYPYc+V1DPyTGDJdfaXe4xdk4kvQ
         AjoGrX4XAUfjA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220927075511.3147847-27-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com> <20220927075511.3147847-27-clabbe@baylibre.com>
Subject: Re: [PATCH v10 26/33] clk: rk3399: use proper crypto0 name
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>, ardb@kernel.org,
        davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        robh+dt@kernel.org
Date:   Wed, 28 Sep 2022 11:58:30 -0700
User-Agent: alot/0.10
Message-Id: <20220928185832.59F7DC433D7@smtp.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Corentin Labbe (2022-09-27 00:55:04)
> RK3399 has 2 crypto instance, named crypto0 and crypto1 in the TRM.
> Only reset for crypto1 is correctly named, but crypto0 is not.
> Since nobody use them , add a 0 to be consistent with the TRM and crypto1=
 entries.
>=20
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>
