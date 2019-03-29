Return-Path: <SRS0=TS5y=SA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC2AC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 16:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD38E2173C
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 16:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfC2QaO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Mar 2019 12:30:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbfC2QaO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Mar 2019 12:30:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1226E8830C;
        Fri, 29 Mar 2019 16:30:14 +0000 (UTC)
Received: from thinkpad.redhat.com (ovpn-116-220.ams2.redhat.com [10.36.116.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 792501F8;
        Fri, 29 Mar 2019 16:30:12 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: [PATCH] hwrng: core - don't block in add_early_randomness()
Date:   Fri, 29 Mar 2019 17:30:11 +0100
Message-Id: <20190329163011.7370-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 29 Mar 2019 16:30:14 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the device is not ready to provide data the kernel will
be stuck indefinitely in the init function.

This is not a problem if the device is driven using a module,
but if the driver is linked directly into the kernel then the
kernel boot sequence hangs.

This can happen with virtio-rng device with rng-egd backend
with no data provider, for instance with QEMU command line parameters:

...
    -chardev socket,id=charrng0,host=localhost,port=2345,server,nowait \
    -object rng-egd,id=objrng0,chardev=charrng0 \
    -device virtio-rng-pci,rng=objrng0,id=rng0

To avoid that, we can call rng_get_data() in non blocking mode because
the function already manages the case where byte_read is
0 (if the device is not already initialized).

See also commit d3cc7996473a
("hwrng: fetch randomness only after device init")

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 95be7228f327..3866d6b8017c 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -67,7 +67,7 @@ static void add_early_randomness(struct hwrng *rng)
 	size_t size = min_t(size_t, 16, rng_buffer_size());
 
 	mutex_lock(&reading_mutex);
-	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
+	bytes_read = rng_get_data(rng, rng_buffer, size, 0);
 	mutex_unlock(&reading_mutex);
 	if (bytes_read > 0)
 		add_device_randomness(rng_buffer, bytes_read);
-- 
2.20.1

