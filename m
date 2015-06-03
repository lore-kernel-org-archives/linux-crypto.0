From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] Doc:crypto: Fix typo in crypto-API.tmpl
Date: Thu,  4 Jun 2015 00:01:20 +0900
Message-ID: <1433343681-10060-1-git-send-email-standby24x7@gmail.com>
References: <20150603032848.GA3126@gondor.apana.org.au>
Cc: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, corbet@lwn.net,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33161 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbbFCPBe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 11:01:34 -0400
In-Reply-To: <20150603032848.GA3126@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fix some spelling typo found in crypto-API.tmpl

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/crypto-API.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 5b05510..9e56773 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -119,7 +119,7 @@
 
     <para>
      Note: The terms "transformation" and cipher algorithm are used
-     interchangably.
+     interchangeably.
     </para>
    </sect1>
 
@@ -1563,7 +1563,7 @@ struct sockaddr_alg sa = {
 
    <sect1><title>Zero-Copy Interface</title>
     <para>
-     In addition to the send/write/read/recv system call familty, the AF_ALG
+     In addition to the send/write/read/recv system call family, the AF_ALG
      interface can be accessed with the zero-copy interface of splice/vmsplice.
      As the name indicates, the kernel tries to avoid a copy operation into
      kernel space.
-- 
2.4.2.339.g77bd3ea
