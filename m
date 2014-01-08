From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: mxs - Fix sparse non static symbol warning
Date: Wed, 8 Jan 2014 21:48:56 +0800
Message-ID: <CAPgLHd8_6_3CvqoSSPvynx3dVgqm_BiX=dLAt9WzNmdXNVC8Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, grant.likely@linaro.org,
	robh+dt@kernel.org, marex@denx.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:57668 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaAHNs5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jan 2014 08:48:57 -0500
Received: by mail-bk0-f53.google.com with SMTP id na10so681759bkb.12
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jan 2014 05:48:56 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/crypto/mxs-dcp.c:103:1: warning:
 symbol 'global_mutex' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/crypto/mxs-dcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d41917c..a6db7fa 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -100,7 +100,7 @@ struct dcp_sha_req_ctx {
  * design of Linux Crypto API.
  */
 static struct dcp *global_sdcp;
-DEFINE_MUTEX(global_mutex);
+static DEFINE_MUTEX(global_mutex);
 
 /* DCP register layout. */
 #define MXS_DCP_CTRL				0x00
