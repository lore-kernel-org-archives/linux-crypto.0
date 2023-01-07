Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E435C54EBC
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Jan 2023 15:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjAGPij (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Jan 2023 10:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAGPii (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Jan 2023 10:38:38 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7183743D84;
        Sat,  7 Jan 2023 07:38:36 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 29A1AFF808;
        Sat,  7 Jan 2023 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673105914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1R0tFrnRkxpaya7FaSMEH1Vxs62o5AiwN5XKT3zuHOw=;
        b=jYj6k5t0jgbDvGd8bBN/g2gAALOqzhmVIfHgCR4EGMSQQH+igzEXI72CvXV9rj2isD+3lB
        7plO+djicHvAMNALglZLvO7OdDiFcMYoltr+V4Y3269dV8SsStrd1wokepVu2GXaq3iAJz
        umt3+MRVjk4D5EmVCSNOYOp+jctimyb/o3O7W2xKRa2x6Thygx78mr7O4JW8R4czS7rt3G
        kAAVLU2wD7P2aEWQhWLeqZVxYjbhEkhvTqEdV+rOQq2+Zb5Hp7NP3STRWbwPV7ZQNhv/47
        xIs6Q+hqKVv5tG5T1B7j83eMuKuC2U11mLBh7sv2T5hgMVfoKc8A/4dWDFlX/A==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>, arnd@arndb.de,
        richard@nod.at, miquel.raynal@bootlin.com
Cc:     krzysztof.kozlowski+dt@linaro.org, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, akpm@linux-foundation.org,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        broonie@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-mtd@lists.infradead.org, pratyush@kernel.org,
        michael@walle.cc, Tudor Ambarus <tudor.ambarus@microchip.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2] MAINTAINERS: Update email of Tudor Ambarus
Date:   Sat,  7 Jan 2023 16:38:29 +0100
Message-Id: <20230107153829.895550-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221226144043.367706-1-tudor.ambarus@linaro.org>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'c0f7ae27539fbac267384a7bfc58296ea7550d52'
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2022-12-26 at 14:40:43 UTC, Tudor Ambarus wrote:
> From: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> My professional email will change and the microchip one will bounce after
> mid-november of 2022.
> 
> Update the MAINTAINERS file, the YAML bindings, MODULE_AUTHOR entries and
> author mentions, and add an entry in the .mailmap file.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Pratyush Yadav <pratyush@kernel.org>
> Acked-by: Mark Brown <broonie@kernel.org>
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
