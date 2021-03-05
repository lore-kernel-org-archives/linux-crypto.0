Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B3DC433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFBE264FD2
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 07:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCEHBg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Mar 2021 02:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCEHBg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Mar 2021 02:01:36 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234C2C061574;
        Thu,  4 Mar 2021 23:01:36 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a18so863937wrc.13;
        Thu, 04 Mar 2021 23:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pH2+9JAFmJC7s5/cQ1Bjnd0LzvMdoyaqsqzj6ICiWMo=;
        b=ZH2JWuNP5/SNX9uc+HMaxgCcwVFn0egPZQ4vA0dOFv3DrxkDNJ6S+KXfiQdShx2u9I
         oc/wo2Msr0VJg36A0/I3MaC4y0j+42gvufk0v0nTodJYLyVwEfoKe7IQ5F9ynO+/2CMk
         aCLOfsVkqurU8KcBZ/ZPAQ11PjtUyfWNZuhUSXJvR2pg8BWzs1IGPZdT9Hq3zDx+kcM0
         KvfE6oBtCO9v8Bmh2/6S18ClrvtjXYjd/L53pyfYOhleTJKpuI2YLzbjY6iQdD8efJ3O
         0VQKUd+9yWYfGVfEhPXH1Pkbjvx4AokTOEqYz/Zh8w/DjIQaCur1zkltv6Jz6Mc8sD7E
         oicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pH2+9JAFmJC7s5/cQ1Bjnd0LzvMdoyaqsqzj6ICiWMo=;
        b=oQzRFMjuJVdIra4OcAJLjjFvgqT8D3ZAK0sdm1Uf2qlafSnX1TY5cqRmFrIzFRWVmI
         MXFRWjMIjE+suk/ct0D3mi5q9HGuCRbH8T76/EOUunamHByybecsEKjL25Ozz9xwS+Y9
         T/8O9AmciRKosD095w7TIPiYAOJWfbuyCxWN3pby+F+YOpLEe6hr67A17KpIyHGUC0Q5
         IUT+ONAhnHP6dfGyH4DZKeTU8uYzzesZMuzEXk9hvDeukkWYQ2VPosL+H9BRznrNtERF
         6Q6tZARV+bh/CG33sAJ1wgb3tr9IapkQNWPsPXOWRJ8CchM4LthmDvCxd3/2/STOxvPM
         etlw==
X-Gm-Message-State: AOAM531YqiNJfksuMCHZF///g+kxFXp16yfXUIwB/Ydq4uTksqXys1fQ
        s1892hRaBymNA1ORdqbnZ6uqOrsvjDgM0LoR
X-Google-Smtp-Source: ABdhPJyBumVXPYcelUUdEU2yXOYCkvuLZyotagaGcwuwzEHSwCDZLPzJPQCWmBPGlqVRgUrpr/nfhA==
X-Received: by 2002:adf:a453:: with SMTP id e19mr7516340wra.283.1614927694832;
        Thu, 04 Mar 2021 23:01:34 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id y18sm2799220wrq.61.2021.03.04.23.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 23:01:34 -0800 (PST)
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
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/3] hwrng: bcm2835: add reset support
Date:   Fri,  5 Mar 2021 08:01:29 +0100
Message-Id: <20210305070132.2986-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some devices may need to perform a reset before using the RNG, such as the
BCM6368.

v6: fix dt-bindings documentation, add patch makings clocks mandatory for
 BCM6368.
v5: remove reset_control_rearm() and apply on latest herbert/cryptodev-2.6.git.
v4: fix documentation, add reset_control_rearm().
v3: make resets required if brcm,bcm6368-rng.
v2: document reset support.

Álvaro Fernández Rojas (3):
  dt-bindings: rng: bcm2835: add clock constraints
  dt-bindings: rng: bcm2835: document reset support
  hwrng: bcm2835: add reset support

 .../devicetree/bindings/rng/brcm,bcm2835.yaml | 21 +++++++++++++++++++
 drivers/char/hw_random/bcm2835-rng.c          | 10 +++++++++
 2 files changed, 31 insertions(+)

-- 
2.20.1

