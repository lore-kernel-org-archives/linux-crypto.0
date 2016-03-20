From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH] PKCS#7: pkcs7_validate_trust(): initialize the _trusted output argument
Date: Sun, 20 Mar 2016 23:23:46 +0100
Message-ID: <1458512626-2839-1-git-send-email-nicstange@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolai Stange <nicstange@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34568 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbcCTWXw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Mar 2016 18:23:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Despite what the DocBook comment to pkcs7_validate_trust() says, the
*_trusted argument is never set to false.

pkcs7_validate_trust() only positively sets *_trusted upon encountering
a trusted PKCS#7 SignedInfo block.

This is quite unfortunate since its callers, system_verify_data() for
example, depend on pkcs7_validate_trust() clearing *_trusted on non-trust.

Indeed, UBSAN splats when attempting to load the uninitialized local
variable 'trusted' from system_verify_data() in pkcs7_validate_trust():

  UBSAN: Undefined behaviour in crypto/asymmetric_keys/pkcs7_trust.c:194:14
  load of value 82 is not a valid value for type '_Bool'
  [...]
  Call Trace:
    [<ffffffff818c4d35>] dump_stack+0xbc/0x117
    [<ffffffff818c4c79>] ? _atomic_dec_and_lock+0x169/0x169
    [<ffffffff8194113b>] ubsan_epilogue+0xd/0x4e
    [<ffffffff819419fa>] __ubsan_handle_load_invalid_value+0x111/0x158
    [<ffffffff819418e9>] ? val_to_string.constprop.12+0xcf/0xcf
    [<ffffffff818334a4>] ? x509_request_asymmetric_key+0x114/0x370
    [<ffffffff814b83f0>] ? kfree+0x220/0x370
    [<ffffffff818312c2>] ? public_key_verify_signature_2+0x32/0x50
    [<ffffffff81835e04>] pkcs7_validate_trust+0x524/0x5f0
    [<ffffffff813c391a>] system_verify_data+0xca/0x170
    [<ffffffff813c3850>] ? top_trace_array+0x9b/0x9b
    [<ffffffff81510b29>] ? __vfs_read+0x279/0x3d0
    [<ffffffff8129372f>] mod_verify_sig+0x1ff/0x290
    [...]

The implication is that pkcs7_validate_trust() effectively grants trust
when it really shouldn't have.

Fix this by explicitly setting *_trusted to false at the very beginning
of pkcs7_validate_trust().

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 Applicable to linux-next-20160318

 crypto/asymmetric_keys/pkcs7_trust.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 3bbdcc7..7d7a39b4 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -178,6 +178,8 @@ int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 	int cached_ret = -ENOKEY;
 	int ret;
 
+	*_trusted = false;
+
 	for (p = pkcs7->certs; p; p = p->next)
 		p->seen = false;
 
-- 
2.7.3
