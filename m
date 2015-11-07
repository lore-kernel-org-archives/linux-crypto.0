From: Sandy Harris <sandyinchina@gmail.com>
Subject: [PATCH 1/7] A couple of generated files
Date: Sat,  7 Nov 2015 09:30:36 -0500
Message-ID: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Theodore Ts\\'o" <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35542 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbbKGOaq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 09:30:46 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
---
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index fd3a355..dd80bfd 100644
--- a/.gitignore
+++ b/.gitignore
@@ -112,3 +112,6 @@ all.config
 
 # Kdevelop4
 *.kdev4
+
+certs/x509_certificate_list
+scripts/gen_random
-- 
2.5.0
