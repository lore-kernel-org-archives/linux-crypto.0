Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF53C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC88F2078A
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esIr4j65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgGAVsF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 17:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgGAVsF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 17:48:05 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9997C08C5C1;
        Wed,  1 Jul 2020 14:48:04 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s1so29053640ljo.0;
        Wed, 01 Jul 2020 14:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oBWOW26zKSzSMAadEmPIB83fwLL5OeyWmw0Mib1tIJw=;
        b=esIr4j65x6TPHvJ0te3aNtvSM4bhwpj5SGiQxOTw8nsdx+jXRUa323W+IJfGSfR51b
         WPTGhdseD9f0DZC1PQIE0U+CjbIy+iGQ7nqKiAHRE7ChXdm4VhA95zX4/85sF/zkxnBU
         h5v/NDt5MgyLTPKcuRuD1m/+ppkfx2lx6BrThXfanhgyCfUbusJcuTmIszEyokM9MGWc
         3JqVzdC8a09eCWv7lbdyOHhc+L/8RC9Q9YmnAm68JYXACX9Dml5cwgKkMqXMCPNaMlG/
         lSl8BbgBESrj3V+Ad4R1Y3XEyJ6tI5GbSyJBkSPfLt+3jR7Cau/ga8IlLnNz6EcQHuuK
         e/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oBWOW26zKSzSMAadEmPIB83fwLL5OeyWmw0Mib1tIJw=;
        b=TNodiZfeTyXDvPfZ7jGZsVjxh8y0/jMCcvAVpYRYBPK1Qhsls90nZJnSqa1KPi/TVB
         h3U360suSoEa++QMIlGUjk457fdVxdVu02SuaOvT2mqPJa8hTA3P79S1aqN6SSiejXER
         2+YOZ15Y7TODMKxCF5CJTLklZeSh3uCQJJK9eUv02vVEJqqFj4arQzGSo8p2TO83OBIr
         FQzLIXtPMlXqI0OH/TQUE615Le9bXBfwdhTpUbApu9fdv3SgrLqh6OTrxrQIcSB/bwlu
         pOcMcaA5Y2tSgrSsOcY5+yyjqI/A5MOT+cUPPFLwDkdQubSG90GhJzQ/hGmi/UDbE49F
         A/+A==
X-Gm-Message-State: AOAM531lyy348ejxEUIOhxmXc1YLoqYF4zd/3nz6MPPK9tbO7OudMrYI
        6d5nHY+u/e9fA7wjbB9Va64=
X-Google-Smtp-Source: ABdhPJyAwCiKG3xVRz7NbECuI22WwQqU8OQmxLbMTzJr4YdV50UfbAYTmgi4HV4uPJV8a06uivEdTQ==
X-Received: by 2002:a2e:968b:: with SMTP id q11mr13444603lji.300.1593640083414;
        Wed, 01 Jul 2020 14:48:03 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-181-241.NA.cust.bahnhof.se. [98.128.181.241])
        by smtp.gmail.com with ESMTPSA id d3sm2476812lfe.93.2020.07.01.14.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 14:48:02 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Amit Shah <amit@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Corey Minyard <minyard@acm.org>,
        virtualization@lists.linux-foundation.org,
        openipmi-developer@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] drivers/char: Constify static variables
Date:   Wed,  1 Jul 2020 22:09:45 +0200
Message-Id: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Constify some static variables (mostly structs) that are not modified.

Rikard Falkeborn (5):
  hwrng: bcm2835 - Constify bcm2835_rng_devtype[]
  hwrng: nomadik - Constify nmk_rng_ids[]
  hwrng: virtio - Constify id_table[]
  ipmi: watchdog: Constify ident
  virtio_console: Constify some static variables

 drivers/char/hw_random/bcm2835-rng.c | 2 +-
 drivers/char/hw_random/nomadik-rng.c | 2 +-
 drivers/char/hw_random/virtio-rng.c  | 2 +-
 drivers/char/ipmi/ipmi_watchdog.c    | 2 +-
 drivers/char/virtio_console.c        | 8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.27.0

