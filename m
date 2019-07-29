Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF5CC76186
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 23:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31D1E2073F
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 23:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="iUit0JoG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfG2XAl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 19:00:41 -0400
Received: from gateway33.websitewelcome.com ([192.185.146.85]:37671 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727708AbfG2XAl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 19:00:41 -0400
X-Greylist: delayed 1339 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 19:00:40 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 8860B64790
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 17:38:21 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id sEHdhVmx2iQersEHdhurqH; Mon, 29 Jul 2019 17:38:21 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rY9Fx/sfJ0n15tzASJL3RTxSvMsm8xpo7ZmCsEw7YbA=; b=iUit0JoGefCef9w589D6lHBzJd
        ++RVPVB+lzPpMy9ljKOZXuMs1jVDb4DveNp+P+lhh/KwA/yVOj4efzHUX74mYFU+n8SeT1v1noyLP
        oBgYX2oHr+bU33ZSfSYOMAyPJfWB+Y68kojDf7ohs9anNBRXJAoFb52JYZiBzCXhM3rXFtSjz9pii
        vPOQcbLw7o7BLUMekzMXWl/DkcOtZ0iBXi0c4TjTD2D0WsC4/HMhLhXUbDz4p9cz9o+CaqI/N4ZSl
        GADG0aHz6/LPojbW0f1CWAqPbhVZEao6bI7+0KZVzJBAb3Y5kN7iZmiTwRkn8rUxzGpkt1cEhyTH6
        f7ZFD7kQ==;
Received: from [187.192.11.120] (port=60884 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hsEHc-0029mb-93; Mon, 29 Jul 2019 17:38:20 -0500
Date:   Mon, 29 Jul 2019 17:38:19 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] crypto: ux500/crypt: Mark expected switch fall-throughs
Message-ID: <20190729223819.GA21985@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hsEHc-0029mb-93
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:60884
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 34
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warning (Building: arm):

drivers/crypto/ux500/cryp/cryp.c: In function ‘cryp_save_device_context’:
drivers/crypto/ux500/cryp/cryp.c:316:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
   ctx->key_4_r = readl_relaxed(&src_reg->key_4_r);
drivers/crypto/ux500/cryp/cryp.c:318:2: note: here
  case CRYP_KEY_SIZE_192:
  ^~~~
drivers/crypto/ux500/cryp/cryp.c:320:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
   ctx->key_3_r = readl_relaxed(&src_reg->key_3_r);
drivers/crypto/ux500/cryp/cryp.c:322:2: note: here
  case CRYP_KEY_SIZE_128:
  ^~~~
drivers/crypto/ux500/cryp/cryp.c:324:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
   ctx->key_2_r = readl_relaxed(&src_reg->key_2_r);
drivers/crypto/ux500/cryp/cryp.c:326:2: note: here
  default:
  ^~~~~~~
In file included from ./include/linux/io.h:13:0,
                 from drivers/crypto/ux500/cryp/cryp_p.h:14,
                 from drivers/crypto/ux500/cryp/cryp.c:15:
drivers/crypto/ux500/cryp/cryp.c: In function ‘cryp_restore_device_context’:
./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 #define __raw_writel __raw_writel
                      ^
./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
 #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
                             ^~~~~~~~~~~~
drivers/crypto/ux500/cryp/cryp.c:363:3: note: in expansion of macro ‘writel_relaxed’
   writel_relaxed(ctx->key_4_r, &reg->key_4_r);
   ^~~~~~~~~~~~~~
drivers/crypto/ux500/cryp/cryp.c:365:2: note: here
  case CRYP_KEY_SIZE_192:
  ^~~~
In file included from ./include/linux/io.h:13:0,
                 from drivers/crypto/ux500/cryp/cryp_p.h:14,
                 from drivers/crypto/ux500/cryp/cryp.c:15:
./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 #define __raw_writel __raw_writel
                      ^
./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
 #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
                             ^~~~~~~~~~~~
drivers/crypto/ux500/cryp/cryp.c:367:3: note: in expansion of macro ‘writel_relaxed’
   writel_relaxed(ctx->key_3_r, &reg->key_3_r);
   ^~~~~~~~~~~~~~
drivers/crypto/ux500/cryp/cryp.c:369:2: note: here
  case CRYP_KEY_SIZE_128:
  ^~~~
In file included from ./include/linux/io.h:13:0,
                 from drivers/crypto/ux500/cryp/cryp_p.h:14,
                 from drivers/crypto/ux500/cryp/cryp.c:15:
./arch/arm/include/asm/io.h:92:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 #define __raw_writel __raw_writel
                      ^
./arch/arm/include/asm/io.h:299:29: note: in expansion of macro ‘__raw_writel’
 #define writel_relaxed(v,c) __raw_writel((__force u32) cpu_to_le32(v),c)
                             ^~~~~~~~~~~~
drivers/crypto/ux500/cryp/cryp.c:371:3: note: in expansion of macro ‘writel_relaxed’
   writel_relaxed(ctx->key_2_r, &reg->key_2_r);
   ^~~~~~~~~~~~~~
drivers/crypto/ux500/cryp/cryp.c:373:2: note: here
  default:
  ^~~~~~~

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/ux500/cryp/cryp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ux500/cryp/cryp.c b/drivers/crypto/ux500/cryp/cryp.c
index ece83a363e11..f22f6fa612b3 100644
--- a/drivers/crypto/ux500/cryp/cryp.c
+++ b/drivers/crypto/ux500/cryp/cryp.c
@@ -314,14 +314,17 @@ void cryp_save_device_context(struct cryp_device_data *device_data,
 	case CRYP_KEY_SIZE_256:
 		ctx->key_4_l = readl_relaxed(&src_reg->key_4_l);
 		ctx->key_4_r = readl_relaxed(&src_reg->key_4_r);
+		/* Fall through */
 
 	case CRYP_KEY_SIZE_192:
 		ctx->key_3_l = readl_relaxed(&src_reg->key_3_l);
 		ctx->key_3_r = readl_relaxed(&src_reg->key_3_r);
+		/* Fall through */
 
 	case CRYP_KEY_SIZE_128:
 		ctx->key_2_l = readl_relaxed(&src_reg->key_2_l);
 		ctx->key_2_r = readl_relaxed(&src_reg->key_2_r);
+		/* Fall through */
 
 	default:
 		ctx->key_1_l = readl_relaxed(&src_reg->key_1_l);
@@ -361,14 +364,17 @@ void cryp_restore_device_context(struct cryp_device_data *device_data,
 	case CRYP_KEY_SIZE_256:
 		writel_relaxed(ctx->key_4_l, &reg->key_4_l);
 		writel_relaxed(ctx->key_4_r, &reg->key_4_r);
+		/* Fall through */
 
 	case CRYP_KEY_SIZE_192:
 		writel_relaxed(ctx->key_3_l, &reg->key_3_l);
 		writel_relaxed(ctx->key_3_r, &reg->key_3_r);
+		/* Fall through */
 
 	case CRYP_KEY_SIZE_128:
 		writel_relaxed(ctx->key_2_l, &reg->key_2_l);
 		writel_relaxed(ctx->key_2_r, &reg->key_2_r);
+		/* Fall through */
 
 	default:
 		writel_relaxed(ctx->key_1_l, &reg->key_1_l);
-- 
2.22.0

