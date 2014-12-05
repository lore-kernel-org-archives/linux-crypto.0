From: "Joshua I. James" <joshua@cybercrimetech.com>
Subject: [PATCH] staging: crypto: fixed style error in af_alg.c
Date: Fri,  5 Dec 2014 14:38:40 +0900
Message-ID: <1417757920-11886-1-git-send-email-Joshua@cybercrimetech.com>
Cc: "Joshua I. James" <joshua@cybercrimetech.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54990 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLEFiv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2014 00:38:51 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so19531274pab.33
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2014 21:38:51 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Joshua I. James" <joshua@cybercrimetech.com>

Fixed style error identified by checkpatch.

ERROR: space required before the open parenthesis '('
+               switch(cmsg->cmsg_type) {

Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6a3ad80..b01deb4 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -405,7 +405,7 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 		if (cmsg->cmsg_level != SOL_ALG)
 			continue;
 
-		switch(cmsg->cmsg_type) {
+		switch (cmsg->cmsg_type) {
 		case ALG_SET_IV:
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(*con->iv)))
 				return -EINVAL;
-- 
1.9.1
