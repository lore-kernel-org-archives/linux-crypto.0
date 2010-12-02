From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH] Install <linux/if_alg.h> for user-space applications
Date: Thu,  2 Dec 2010 16:52:05 +0100
Message-ID: <1291305125-24692-1-git-send-email-mitr@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0LBPwR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Dec 2010 10:52:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 9aa9bca..60db44c 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -81,6 +81,7 @@ header-y += hysdn_if.h
 header-y += i2o-dev.h
 header-y += i8k.h
 header-y += if_addrlabel.h
+header-y += if_alg.h
 header-y += if_arcnet.h
 header-y += if_bonding.h
 header-y += if_cablemodem.h
-- 
1.7.3.2
