Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB46EC10F27
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 12:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FDD42468E
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 12:26:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRk29ZvL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgCJM0Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 08:26:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38675 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJM0Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 08:26:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id z5so1525330pfn.5;
        Tue, 10 Mar 2020 05:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aqG1gpI3UojXGpXKG8hweJC7Y4rK/8MUyRGkcr9E4Og=;
        b=NRk29ZvL9dXRWhydPFZ1MNK8u+VK026HEZdZ6QJrhG6+YwgQJuM7hPfBqK43y29Z/P
         hWjhYn+xQYQ139crRXlL6FVPYINBUyzwkWupHkYDkopCT25pfhSL/C+lh7wspGkpamcO
         HygLSE48s954ZazP/AOdt6BNis2UE2+oCV+23F2KC92SOkyyT8Z46DyqmlybGYQQPnoL
         o3dP2LYSOlpEKs3G44b5dpHRWF0F4ZCaQHnnfQGsQqsZOFhA/MfKa2yp1KNWo5I5zPa4
         0HoLFM9+y1dGU69VBRHAS+ULujVS+3wcyH+yKDkDERtzTPYeMQZcwWxvGf1bYoGtNIn6
         ONnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aqG1gpI3UojXGpXKG8hweJC7Y4rK/8MUyRGkcr9E4Og=;
        b=N+wQX3okNNEuTp5Cxo0wlLd5vmslArqxxOip7ljl2j/vNWNs1xSDDWd+9aMQ69DFwt
         A8V9uBkq9XU9DqrfZ1NNBR9ewZtL622ZfjXZ3wXsw98ZR1XyenobfwkCEfhDut6QY3zs
         2c8WSehBJhyu+jprfeMdRs7j2Iums85xob3MQ7rEg7WDcbkBgjwqJgBzk4Of9MF3HvWJ
         nzHHSNPVcyv+oY7Vm/CNIvn85rcZsfYB6w7wvsyNetRQZ5UtkzOo10XK2OtGaAnwxyCX
         XY37tR8bAFvyQnv8EBeCE04wWKCju8l9RF/Xe2hPXHgXkdZ0r0a/py1ScG68jgnO8g1V
         s5aA==
X-Gm-Message-State: ANhLgQ0wIVvjGslZr1PWQaf3B+rucsJ620Ff7DxBYWfSPXW7SZ81FetW
        E9DF2zyoCjTsxYbDpoIpbfY=
X-Google-Smtp-Source: ADFU+vsGROcltLUCt7lKgq5KZYHU57Q1LyZzFESKeWrFihj5+bJ1r/nBxQ+urASpaa7ZFtj7UtrrtA==
X-Received: by 2002:a63:5864:: with SMTP id i36mr21841664pgm.426.1583843183996;
        Tue, 10 Mar 2020 05:26:23 -0700 (PDT)
Received: from localhost.localdomain ([149.129.63.152])
        by smtp.gmail.com with ESMTPSA id w11sm47557396pfn.4.2020.03.10.05.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 05:26:22 -0700 (PDT)
From:   Jianhui Zhao <zhaojh329@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jianhui Zhao <zhaojh329@gmail.com>
Subject: [PATCH v2] crypto: atmel-i2c - Fix wakeup fail
Date:   Tue, 10 Mar 2020 20:25:51 +0800
Message-Id: <20200310122551.27831-1-zhaojh329@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The wake token cannot be sent without ignoring the nack for the
device address

Signed-off-by: Jianhui Zhao <zhaojh329@gmail.com>
---
 drivers/crypto/atmel-i2c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 1d3355913b40..e8e8281e027d 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -176,7 +176,8 @@ static int atmel_i2c_wakeup(struct i2c_client *client)
 	 * device is idle, asleep or during waking up. Don't check for error
 	 * when waking up the device.
 	 */
-	i2c_master_send(client, i2c_priv->wake_token, i2c_priv->wake_token_sz);
+	i2c_transfer_buffer_flags(client, i2c_priv->wake_token,
+				i2c_priv->wake_token_sz, I2C_M_IGNORE_NAK);
 
 	/*
 	 * Wait to wake the device. Typical execution times for ecdh and genkey
-- 
2.17.1

