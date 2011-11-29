From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/16] KEYS: Permit key_serial() to be called with a const key
 pointer [ver #2]
Date: Tue, 29 Nov 2011 23:43:35 +0000
Message-ID: <20111129234335.13625.31247.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com, David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab1K2XxT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Nov 2011 18:53:19 -0500
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Permit key_serial() to be called with a const key pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/key.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/key.h b/include/linux/key.h
index 183a6af..f87b51b 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -271,7 +271,7 @@ extern int keyring_add_key(struct key *keyring,
 
 extern struct key *key_lookup(key_serial_t id);
 
-static inline key_serial_t key_serial(struct key *key)
+static inline key_serial_t key_serial(const struct key *key)
 {
 	return key ? key->serial : 0;
 }
