From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCH] crypto: talitos - fix bug in sg_copy_end_to_buffer
Date: Sun, 11 Jul 2010 15:24:06 -0500
Message-ID: <1278879846-29701-1-git-send-email-lee.nipper@gmail.com>
Cc: Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56577 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0GKUYM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jul 2010 16:24:12 -0400
Received: by gwj18 with SMTP id 18so1763284gwj.19
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jul 2010 13:24:11 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In function sg_copy_end_to_buffer, too much data
is copied when a segment in the scatterlist
has .length greater than the requested copy length.

This patch adds the limit checks to fix this bug of over copying,
which affected only the ahash algorithms.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
Kim, this corrects the problem causing exceptions
for tcrypt tests 402, 403, and 404.
With this patch the tcrypt tests run through ok.

 drivers/crypto/talitos.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0f2483e..e058987 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1183,10 +1183,14 @@ static size_t sg_copy_end_to_buffer(struct scatterlist *sgl, unsigned int nents,
 				/* Copy part of this segment */
 				ignore = skip - offset;
 				len = miter.length - ignore;
+				if ((boffset + len) > buflen)
+					len = buflen - boffset;
 				memcpy(buf + boffset, miter.addr + ignore, len);
 			} else {
-				/* Copy all of this segment */
+				/* Copy all of this segment (up to buflen) */
 				len = miter.length;
+				if ((boffset + len) > buflen)
+					len = buflen - boffset;
 				memcpy(buf + boffset, miter.addr, len);
 			}
 			boffset += len;
-- 
1.6.0.4
