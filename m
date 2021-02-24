Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2858C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 08:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AED964EDD
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 08:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhBXIXU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhBXIXT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 03:23:19 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED0CC061786;
        Wed, 24 Feb 2021 00:22:38 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h98so963452wrh.11;
        Wed, 24 Feb 2021 00:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QwOfJNfv6re2ebmSZFTKETkYLwXhNoR6kG6RlRtNKOk=;
        b=CV8pemUoNR37LLS/u/MsIWiuLsb7RqvPwrPfL7W+fJ4neqO6qpFQF++1yOfGGLSOhX
         31tqCwUOR8GFeM9zE7s1wXvS4cLky+ASqdwNs7cyltInwDez74GFFtF8fo+2XBfyhq9X
         GKokl43wWyB1zFt9ERkXpZqmPyKam7/SimOG6L49oFPq4vnhVuNJz+RQZ21awAjZbagg
         IGZ4FwISbeK32foy8Z6w6rzZkNnEGFW6WFMAaHs2seraFMQAjY3Y+N9COwxcuE1Erget
         /5WOAzN5zH8B0bPLzS+cqA2GDdZnPf4NLqlhEj6Zg6OKVrTB0qd2O/JRrrg3xfpWnpbS
         O3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QwOfJNfv6re2ebmSZFTKETkYLwXhNoR6kG6RlRtNKOk=;
        b=p4rv2vovLvBUn2SCm+gFfptPoPQj7FuVKHLUmscj4Z0ZezYHJSTsqMUqtaIVjkWsOP
         +lddL8m7/FaWsZmpc1tbvZAG0k78xtj/CDXxRY+0fTZrv7ReRvbnLYixPCJZePMKIlWW
         gH56eHXJ6/luNW4NHkUq7Rxl5bhYkkiatLYxlESSpe9m0EcDHGB4UZPL+bKBjPpnArUh
         n41ojzKOj3oBmO3ld9hDvOOR6xvPVka706Gf/MnM1FgxEj9n3zvYii6tZfXFvidRiSUB
         MmteluYsaaen9vny8LNLLp/99soJt7LM+dj7ZkmNu76sfvBAkTnpUNpjBqu2rDD3KH88
         ruqw==
X-Gm-Message-State: AOAM532Y3balBU2kngGkVWZwdoDflKztGt7gudi4Az/poxyy/stwtLdV
        s6D0TUDy8lRWaVAAE5Z2L3s=
X-Google-Smtp-Source: ABdhPJyOUFmigiz2HrodPNhPN+sPCXo+ZD2tvzS+6wd5jfnYbMWkpQbOLXGWDSqOJIFEa745jZEUDg==
X-Received: by 2002:adf:ec8b:: with SMTP id z11mr30102893wrn.374.1614154956936;
        Wed, 24 Feb 2021 00:22:36 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id u19sm1501628wmm.46.2021.02.24.00.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:22:36 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] hwrng: bcm2835: add reset support
Date:   Wed, 24 Feb 2021 09:22:28 +0100
Message-Id: <20210224082230.29015-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210223160131.29053-1-noltari@gmail.com>
References: <20210223160131.29053-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v4: fix documentation, add reset_control_rearm().
v3: make resets required if brcm,bcm6368-rng.
v2: document reset support.

Álvaro Fernández Rojas (2):
  dt-bindings: rng: bcm2835: document reset support
  hwrng: bcm2835: add reset support

 .../devicetree/bindings/rng/brcm,bcm2835.yaml      | 14 ++++++++++++++
 drivers/char/hw_random/bcm2835-rng.c               | 12 ++++++++++++
 2 files changed, 26 insertions(+)

-- 
2.20.1

