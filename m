Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670E0C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53053206C3
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgFAQMu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:12:50 -0400
Received: from smtp02.tmcz.cz ([93.153.104.113]:36072 "EHLO smtp02.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgFAQMt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 12:12:49 -0400
Received: from smtp02.tmcz.cz (localhost [127.0.0.1])
        by sagator.hkvnode045 (Postfix) with ESMTP id 1872694D525;
        Mon,  1 Jun 2020 18:04:24 +0200 (CEST)
X-Sagator-Scanner: 1.3.1-1 at hkvnode046;
        log(status(custom_action(quarantine(clamd()))),
        status(custom_action(quarantine(SpamAssassinD()))))
X-Sagator-ID: 20200601-180424-0001-83035-TqdWZJ@hkvnode046
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp02.tmcz.cz (Postfix) with ESMTPS;
        Mon,  1 Jun 2020 18:04:24 +0200 (CEST)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1jfmvG-0001W2-Ob; Mon, 01 Jun 2020 18:04:23 +0200
Received: by debian-a64.vm (sSMTP sendmail emulation); Mon, 01 Jun 2020 18:04:22 +0200
Message-Id: <20200601160421.912555280@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Mon, 01 Jun 2020 18:03:36 +0200
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Mike Snitzer <msnitzer@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc:     dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] dm-crypt: sleep and retry on allocation errors
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=crypt-enomem.patch
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some hardware crypto drivers use GFP_ATOMIC allocations in the request
routine. These allocations can randomly fail - for example, they fail if
too many network packets are received.

If we propagated the failure up to the I/O stack, it would cause I/O
errors and data corruption. So, we sleep and retry.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -1534,6 +1534,7 @@ static blk_status_t crypt_convert(struct
 		crypt_alloc_req(cc, ctx);
 		atomic_inc(&ctx->cc_pending);
 
+again:
 		if (crypt_integrity_aead(cc))
 			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, tag_offset);
 		else
@@ -1541,6 +1542,17 @@ static blk_status_t crypt_convert(struct
 
 		switch (r) {
 		/*
+		 * Some hardware crypto drivers use GFP_ATOMIC allocations in
+		 * the request routine. These allocations can randomly fail. If
+		 * we propagated the failure up to the I/O stack, it would cause
+		 * I/O errors and data corruption.
+		 *
+		 * So, we sleep and retry.
+		 */
+		case -ENOMEM:
+			msleep(1);
+			goto again;
+		/*
 		 * The request was queued by a crypto driver
 		 * but the driver request queue is full, let's wait.
 		 */

