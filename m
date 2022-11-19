Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BFBC4332F
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Nov 2022 13:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiKSNnQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Nov 2022 08:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSNnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Nov 2022 08:43:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC72B83EBB
        for <linux-crypto@vger.kernel.org>; Sat, 19 Nov 2022 05:43:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EF2C60A6E
        for <linux-crypto@vger.kernel.org>; Sat, 19 Nov 2022 13:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D05C433C1;
        Sat, 19 Nov 2022 13:43:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="L8WRt3rP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668865390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sNjUH9YYxs+T2CdAZKiMZPcLV7XYZEO0+q+grRvvYi4=;
        b=L8WRt3rP4VI0qjaFz/qNoRuPGBNx2gAsLFnfX3DnrIESuFcJRwcsCZ9WhrJQMa1HDwnL/Z
        LiAGpAKRj8xNXHR1gdhjgUE7xJzVcS30+RIfvxU44ADRT2mjluJDleUEioHQpdqggTPiZ9
        H5QG88aPU81HyRr2ExLRq8KnvIrSSio=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8e760f35 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 19 Nov 2022 13:43:10 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrej Shadura <andrew.shadura@collabora.co.uk>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] hwrng: u2fzero - account for high quality RNG
Date:   Sat, 19 Nov 2022 14:42:59 +0100
Message-Id: <20221119134259.2969204-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The U2F zero apparently has a real TRNG in it with maximum quality, not
one with quality of "1", which was likely a misinterpretation of the
field as a boolean. So remove the assignment entirely, so that we get
the default quality setting.

In the u2f-zero firmware, the 0x21 RNG command used by this driver is
handled as such [1]:

  case U2F_CUSTOM_GET_RNG:
    if (atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,ATECC_RNG_P2,
      NULL, 0,
      appdata.tmp,
      sizeof(appdata.tmp), &res) == 0 )
    {
      memmove(msg->pkt.init.payload, res.buf, 32);
      U2FHID_SET_LEN(msg, 32);
      usb_write((uint8_t*)msg, 64);
    }
    else
    {
      U2FHID_SET_LEN(msg, 0);
      usb_write((uint8_t*)msg, 64);
    }

This same call to `atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,
ATECC_RNG_P2,...)` is then also used in the token's cryptographically
critical "u2f_new_keypair" function, as its rather straightforward
source of random bytes [2]:

  int8_t u2f_new_keypair(uint8_t * handle, uint8_t * appid, uint8_t * pubkey)
  {
    struct atecc_response res;
    uint8_t private_key[36];
    int i;

    watchdog();

    if (atecc_send_recv(ATECC_CMD_RNG,ATECC_RNG_P1,ATECC_RNG_P2,
      NULL, 0,
      appdata.tmp,
      sizeof(appdata.tmp), &res) != 0 )
    {
      return -1;
    }

So it seems rather plain that the ATECC RNG is considered to provide
good random numbers.

[1] https://github.com/conorpp/u2f-zero/blob/master/firmware/src/custom.c
[2] https://github.com/conorpp/u2f-zero/blob/master/firmware/src/u2f_atecc.c

Cc: Andrej Shadura <andrew.shadura@collabora.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/hid/hid-u2fzero.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
index ad489caf53ad..744a91e6e78c 100644
--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -261,7 +261,6 @@ static int u2fzero_init_hwrng(struct u2fzero_device *dev,
 
 	dev->hwrng.name = dev->rng_name;
 	dev->hwrng.read = u2fzero_rng_read;
-	dev->hwrng.quality = 1;
 
 	return devm_hwrng_register(&dev->hdev->dev, &dev->hwrng);
 }
-- 
2.38.1

