From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH] Install <linux/if_alg.h> for user-space applications
Date: Thu,  2 Dec 2010 16:55:55 +0100
Message-ID: <1291305355-24899-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0LBP4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Dec 2010 10:56:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 9aa9bca..60db44c 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -81,6 +81,7 @@ header-y +=3D hysdn_if.h
 header-y +=3D i2o-dev.h
 header-y +=3D i8k.h
 header-y +=3D if_addrlabel.h
+header-y +=3D if_alg.h
 header-y +=3D if_arcnet.h
 header-y +=3D if_bonding.h
 header-y +=3D if_cablemodem.h
--=20
1.7.3.2
