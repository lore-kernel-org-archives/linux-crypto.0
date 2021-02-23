Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEF8C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 16:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D73A764E60
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 16:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhBWQCT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 11:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbhBWQCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 11:02:19 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED91C061574;
        Tue, 23 Feb 2021 08:01:36 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l13so2926735wmg.5;
        Tue, 23 Feb 2021 08:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8pId0GGCaDJbuNBJy+4MFY+EnRSRCwJYtg+gI5eOlnY=;
        b=uuT/einVI9mfGQbfukEiKjNUIKnYFFSaSfL482AnCpMXPacg6LKp58PvUT/dz5Lt8e
         SxffJ8NaceEE5A0uolBUirvPdqwJ5XRz60pWn8ctMBzALYpJ8HLbyV+ZP4jISuJ+HsdU
         PJSWaE04Z+YCazqMsqf2QGw/duTNrMVj+uSjSSu79O1J9NZ4IuRvlWLvzQcjmcagAScn
         Mt2uieOSzvGixC9vlXnYik2bHBtpzxOJT6YfnjYdujagPl8RgTqmaLQqSGsEq2uhUSdb
         4WqHTgdoC7C5UlQCpzXOZPcUtIHT+Nf0SGsf9cW7RGZJ5sdP2xtvAMyCLsNSRPob5Hm5
         8rKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8pId0GGCaDJbuNBJy+4MFY+EnRSRCwJYtg+gI5eOlnY=;
        b=EFpswKQtmjEkswosh/2rPNXRvcnWSaCjyoJmhVw8lLGNYxEGVrnV5rOsxEKBCWgM3x
         paoHCCcEkKpFaPcuTXwtHaIvNMbrSPFpaeko5tLf3gdDaXyVMmqtUGqP954rhJT4ODaS
         itKMYqYFRkL6vtL/eqyAC05XcxoiI9oTkWUGWoZNA4ivkQ45eWjytaML9CgUeGO+DQIO
         mXQWD92ju3zWhZDh03N502/6CYeLKM7aR++tDnZtjMvSZOkKKciQ6RAV302XFAuc0mWb
         vldoYZrctYqUcERg0QS783FJX+n4JIb+lZTjVueiImlD+BThYRL80sMuE3s2PZgC0y2f
         HA1w==
X-Gm-Message-State: AOAM533ajcIEyOOjedw2lxVZE/4lT0i13j67cINkastKs0LanfV89y3E
        SHyISSfl5k82TZYtc5zls3Q=
X-Google-Smtp-Source: ABdhPJxNxzbN1cZ3nt1lOUEhlhwxRBItAIvp+tgOfI3ePfkOMQDAXRZejsPegG1gryAOkXQl9qo11Q==
X-Received: by 2002:a7b:c391:: with SMTP id s17mr7764852wmj.155.1614096095346;
        Tue, 23 Feb 2021 08:01:35 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id h15sm33999381wrh.13.2021.02.23.08.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 08:01:34 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= 
        <nfraprado@protonmail.com>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] hwrng: bcm2835: add reset support
Date:   Tue, 23 Feb 2021 17:01:29 +0100
Message-Id: <20210223160131.29053-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222194510.14004-1-noltari@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some devices may need to perform a reset before using the RNG, such as the
BCM6368.

Álvaro Fernández Rojas (2):
  dt-bindings: rng: bcm2835: document reset support
  hwrng: bcm2835: add reset support

 .../devicetree/bindings/rng/brcm,bcm2835.yaml          |  5 +++++
 drivers/char/hw_random/bcm2835-rng.c                   | 10 ++++++++++
 2 files changed, 15 insertions(+)

-- 
2.20.1

