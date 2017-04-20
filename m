From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 5/5] KEYS: DH: add __user annotations to keyctl_kdf_params
Date: Wed, 19 Apr 2017 22:46:33 -0700
Message-ID: <20170420054633.14572-6-ebiggers3@gmail.com>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33485 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763296AbdDTFse (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 01:48:34 -0400
In-Reply-To: <20170420054633.14572-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/uapi/linux/keyctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 201c6644b237..ef16df06642a 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -70,8 +70,8 @@ struct keyctl_dh_params {
 };
 
 struct keyctl_kdf_params {
-	char *hashname;
-	char *otherinfo;
+	char __user *hashname;
+	char __user *otherinfo;
 	__u32 otherinfolen;
 	__u32 __spare[8];
 };
-- 
2.12.2
