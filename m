From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AES-NI GCM - handle zero length dst buffer
Date: Thu, 18 Jan 2018 20:38:50 +0100
Message-ID: <3135206.iU7W5QhZxW@positron.chronox.de>
References: <2389839.8lvrU0lKhj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58404 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932730AbeARTix (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 14:38:53 -0500
In-Reply-To: <2389839.8lvrU0lKhj@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

GCM can be invoked with a zero destination buffer. This is possible if
the AAD and the ciphertext have zero lengths and only the tag exists in
the source buffer (i.e. a source buffer cannot be zero). In this case,
the GCM cipher only performs the authentication and no decryption
operation.

When the destination buffer has zero length, it is possible that no page
is mapped to the SG pointing to the destination. In this case,
sg_page(req->dst) is an invalid access. Therefore, page accesses should
only be allowed if the req->dst->length is non-zero which is the
indicator that a page must exist.

This fixes a crash that can be triggered by user space via AF_ALG.

CC: <stable@vger.kernel.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index a5ee78d723cd..34cf1c1f8c98 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -824,7 +824,7 @@ static int gcmaes_decrypt(struct aead_request *req, unsigned int assoclen,
 	if (sg_is_last(req->src) &&
 	    (!PageHighMem(sg_page(req->src)) ||
 	    req->src->offset + req->src->length <= PAGE_SIZE) &&
-	    sg_is_last(req->dst) &&
+	    sg_is_last(req->dst) && req->dst->length &&
 	    (!PageHighMem(sg_page(req->dst)) ||
 	    req->dst->offset + req->dst->length <= PAGE_SIZE)) {
 		one_entry_in_sg = 1;
-- 
2.14.3
