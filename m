Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC4CC2BA1A
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 03:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59640206B8
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 03:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDGDAH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Apr 2020 23:00:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52738 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDAH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Apr 2020 23:00:07 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jLeT5-0007jX-RH; Tue, 07 Apr 2020 13:00:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 07 Apr 2020 13:00:03 +1000
Date:   Tue, 7 Apr 2020 13:00:03 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: crypto: algboss - Avoid spurious modprobe on LOADED
Message-ID: <20200407030003.GA12687@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands when any algorithm finishes testing a notification
is generated which triggers an unnecessary modprobe because algboss
returns NOTIFY_DONE instead of NOTIFY_OK (this denotes an event
that is not handled properly).

This patch changes the return value in algboss so that we don't
do an unnecessary modprobe.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 527b44d0af21..01feb8234053 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -275,7 +275,7 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 	case CRYPTO_MSG_ALG_REGISTER:
 		return cryptomgr_schedule_test(data);
 	case CRYPTO_MSG_ALG_LOADED:
-		break;
+		return NOTIFY_OK;
 	}
 
 	return NOTIFY_DONE;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
