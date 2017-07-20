From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: chcr - Select device in Round Robin fashion
Date: Thu, 20 Jul 2017 13:32:52 +0300
Message-ID: <20170720103252.jrtckdbcnnsbf4v3@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: harsh@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50375 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdGTKdD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 06:33:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Harsh Jain,

The patch 14c19b178a01: "crypto: chcr - Select device in Round Robin
fashion" from Jun 15, 2017, leads to the following static checker
warning:

	drivers/crypto/chelsio/chcr_core.c:163 chcr_uld_add()
	warn: overwrite may leak 'u_ctx'

drivers/crypto/chelsio/chcr_core.c
   152  static void *chcr_uld_add(const struct cxgb4_lld_info *lld)
   153  {
   154          struct uld_ctx *u_ctx;
   155  
   156          /* Create the device and add it in the device list */
   157          u_ctx = kzalloc(sizeof(*u_ctx), GFP_KERNEL);
   158          if (!u_ctx) {
   159                  u_ctx = ERR_PTR(-ENOMEM);
   160                  goto out;
   161          }
   162          if (!(lld->ulp_crypto & ULP_CRYPTO_LOOKASIDE)) {

Sure, we could move this check before the allocation, to prevent the
leak but is -ENOMEM really the right error code?  It feels like -EINVAL
with a WARN_ON_ONCE() message would be better but I don't really
understand this code.

   163                  u_ctx = ERR_PTR(-ENOMEM);
   164                  goto out;
   165          }
   166          u_ctx->lldi = *lld;
   167  out:
   168          return u_ctx;
   169  }

regards,
dan carpenter
