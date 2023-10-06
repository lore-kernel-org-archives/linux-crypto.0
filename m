Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50FEE92FEC
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Oct 2023 06:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjJFGn0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Oct 2023 02:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjJFGnZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2023 02:43:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6882DE9
        for <linux-crypto@vger.kernel.org>; Thu,  5 Oct 2023 23:43:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-4054496bde3so16182665e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Oct 2023 23:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696574602; x=1697179402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tHZrwWZAfNjVWk4/AUcfESVqIawgSpGdGoZyI+1qlJk=;
        b=t9QcH4qBdqtSq3VV6Ja74dYsDOzK0D3mF/7SGn2FoA+3rVrWJcMu+5FHLdlYApr8DW
         6TT6qYyj39ktkWH7zPzYipvar42vXzs0Spk6DC86gqiyhvIqJ6a7ARoVWd4g36yJkCPl
         2/gvjntMgaUFG8VWpAUDJy9CwMMtU1MS8D8nX2ZFzezYGOnJrAFOdLxKXyAH+DcQNLJ6
         0FUpiEqjCEfnVwe/O48KwTXsn9MkQqgfaH3P2HZKfxrgYGEVaBfkSQY8Tet4Vv8Rn0y/
         SUJs+MKRPJm6URmATHoowVDplayNIpTi0eveK0s8xUD+yWinULtPPnB85RL5CJmNwyoB
         1KmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696574602; x=1697179402;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHZrwWZAfNjVWk4/AUcfESVqIawgSpGdGoZyI+1qlJk=;
        b=gBuq2Y3iOCD5nR3tr4Z+Ky9qnjXd2vOKZyINcK26ZHcuibyQHTU2bjGKOlXT/MkOla
         +s23n3IZUxMVwDlqQwsZdn2g38uTJMM0Mkzmg/6tB/FXktxbD3eny/4waeAyczeGaBhj
         fOuHO+z7rkU6eScdmIA9FsXg8BmTPtbVyxPJX5L6nGSUYFNl5Kq5vWDMh7eVeteXXeO9
         XlZIng9hFX9XEjq2gVbJ/HuaUTVc0zMk/l8x2YoYKBWMRShYudODYgSn4meP8BnL32Mw
         ScCB8Ra4Cf95CFzR8ak1JgwMhMMcoAVwoemWgNP4PpdDqe8g5KOFDsW2GQ1TnMkxwY+E
         858w==
X-Gm-Message-State: AOJu0YzPoEWU/wC94g41DyrvsAztqlX1zb9qh7A+n283PfvFf7C6aqFv
        V0bg07v5ThgdY38PJPyWhqv06g==
X-Google-Smtp-Source: AGHT+IEa9D6UEg8Kim6Z9RKpbqTF6yPxbwX33SKhKAYQuYTwCSxIBRvJ5CVQJEe4sosIQ6eGaegeiA==
X-Received: by 2002:a05:600c:b41:b0:405:499a:7fc1 with SMTP id k1-20020a05600c0b4100b00405499a7fc1mr6767148wmr.40.1696574601638;
        Thu, 05 Oct 2023 23:43:21 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id y24-20020a7bcd98000000b004064741f855sm3002073wmj.47.2023.10.05.23.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 23:43:21 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
To:     olivia@selenic.com, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, conor@kernel.org, khilman@baylibre.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, lists@kaiser.cx,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Alexey Romanov <avromanov@salutedevices.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel@sberdevices.ru
In-Reply-To: <20230929102942.67985-1-avromanov@salutedevices.com>
References: <20230929102942.67985-1-avromanov@salutedevices.com>
Subject: Re: [PATCH v5 0/3] Meson S4 HW RNG Support
Message-Id: <169657460045.2128575.14990345978498318753.b4-ty@linaro.org>
Date:   Fri, 06 Oct 2023 08:43:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, 29 Sep 2023 13:29:35 +0300, Alexey Romanov wrote:
> This patch series adds hwrng support for Amlogic S4-series.
> Now, S4 uses a new random number generation algorithm.
> This changes implemnents new algo and also adds description
> to meson-s4.dtsi.
> 
> V2:
> 
> [...]

Thanks, Applied to https://git.kernel.org/pub/scm/linux/kernel/git/amlogic/linux.git (v6.7/arm64-dt)

[1/3] drivers: rng: meson: add support for S4
      (no commit info)
[2/3] dt-bindings: rng: meson: add meson-rng-s4 compatible
      (no commit info)
[3/3] arch/arm64: dts: meson-s4: add hwrng node
      https://git.kernel.org/amlogic/c/1e3dbe8006247386592a2fdce3a52cca15625997

These changes has been applied on the intermediate git tree [1].

The v6.7/arm64-dt branch will then be sent via a formal Pull Request to the Linux SoC maintainers
for inclusion in their intermediate git branches in order to be sent to Linus during
the next merge window, or sooner if it's a set of fixes.

In the cases of fixes, those will be merged in the current release candidate
kernel and as soon they appear on the Linux master branch they will be
backported to the previous Stable and Long-Stable kernels [2].

The intermediate git branches are merged daily in the linux-next tree [3],
people are encouraged testing these pre-release kernels and report issues on the
relevant mailing-lists.

If problems are discovered on those changes, please submit a signed-off-by revert
patch followed by a corrective changeset.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/amlogic/linux.git
[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
[3] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

-- 
Neil

