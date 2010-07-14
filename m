From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCH v2] crypto: talitos - fix bug in sg_copy_end_to_buffer
Date: Tue, 13 Jul 2010 19:11:27 -0500
Message-ID: <1279066287-11349-1-git-send-email-lee.nipper@gmail.com>
Cc: Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43362 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0GNALa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jul 2010 20:11:30 -0400
Received: by gxk23 with SMTP id 23so3546104gxk.19
        for <linux-crypto@vger.kernel.org>; Tue, 13 Jul 2010 17:11:29 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In function sg_copy_end_to_buffer, too much data
is copied when a segment in the scatterlist
has .length greater than the requested copy length.

This patch adds the limit checks to fix this bug of over copying,
which affected only the ahash algorithms.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
Acked-by: Kim Phillips <kim.phillips@freescale.com>
---
This is version 2 of this patch,
with changes per Kim's review: unnecessary parenthesis removed.

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
+				if (boffset + len > buflen)
+					len = buflen - boffset;
 				memcpy(buf + boffset, miter.addr + ignore, len);
 			} else {
-				/* Copy all of this segment */
+				/* Copy all of this segment (up to buflen) */
 				len = miter.length;
+				if (boffset + len > buflen)
+					len = buflen - boffset;
 				memcpy(buf + boffset, miter.addr, len);
 			}
 			boffset += len;
-- 
1.6.0.4
