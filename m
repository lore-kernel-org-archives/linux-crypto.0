Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146E6C38A02
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Oct 2022 08:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJ2IMl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Oct 2022 04:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ2IMk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Oct 2022 04:12:40 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C0586810;
        Sat, 29 Oct 2022 01:12:36 -0700 (PDT)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1oogx5-00055T-D4; Sat, 29 Oct 2022 10:12:23 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        Corentin Labbe <clabbe@baylibre.com>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, sboyd@kernel.org,
        mturquette@baylibre.com, ardb@kernel.org
Cc:     Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: (subset) [PATCH v10 00/33] crypto: rockchip: permit to pass self-tests
Date:   Sat, 29 Oct 2022 10:12:21 +0200
Message-Id: <166703105270.1426558.18336536991217213193.b4-ty@sntech.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220927075511.3147847-1-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 27 Sep 2022 07:54:38 +0000, Corentin Labbe wrote:
> The rockchip crypto driver is broken and do not pass self-tests.
> This serie's goal is to permit to become usable and pass self-tests.
> 
> This whole serie is tested on a rk3328-rock64, rk3288-miqi and
> rk3399-khadas-edge-v with selftests (with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)
> 
> Regards
> 
> [...]

Applied, thanks!

[26/33] clk: rk3399: use proper crypto0 name
        commit: b136468a0024ea90c1259767c732eed12ce6edba
[27/33] arm64: dts: rockchip: add rk3328 crypto node
        commit: d1152bc533c941f7e267bf53d344cee510ea2808
[28/33] arm64: dts: rockchip: rk3399: add crypto node
        commit: 8c701fa6e38c43dba75282e4d919298a5cfc5b05

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
