From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ASN.1: check for error from ASN1_OP_END__ACT actions
Date: Sun, 26 Nov 2017 23:15:28 -0800
Message-ID: <20171127071528.25456-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:41145 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdK0HP4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 02:15:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

asn1_ber_decoder() was ignoring errors from actions associated with the
opcodes ASN1_OP_END_SEQ_ACT, ASN1_OP_END_SET_ACT,
ASN1_OP_END_SEQ_OF_ACT, and ASN1_OP_END_SET_OF_ACT.  In practice, this
meant the pkcs7_note_signed_info() action (since that was the only user
of those opcodes).  Fix it by checking for the error, just like the
decoder does for actions associated with the other opcodes.

This bug allowed users to leak slab memory by repeatedly trying to add a
specially crafted "pkcs7_test" key (requires CONFIG_PKCS7_TEST_KEY).

In theory, this bug could also be used to bypass module signature
verification, by providing a PKCS#7 message that is misparsed such that
a signature's ->authattrs do not contain its ->msgdigest.  But it
doesn't seem practical in normal cases, due to restrictions on the
format of the ->authattrs.

Fixes: 42d5ec27f873 ("X.509: Add an ASN.1 decoder")
Cc: <stable@vger.kernel.org> # v3.7+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/asn1_decoder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/asn1_decoder.c b/lib/asn1_decoder.c
index d77cdfc4b554..dc14beae2c9a 100644
--- a/lib/asn1_decoder.c
+++ b/lib/asn1_decoder.c
@@ -439,6 +439,8 @@ int asn1_ber_decoder(const struct asn1_decoder *decoder,
 			else
 				act = machine[pc + 1];
 			ret = actions[act](context, hdr, 0, data + tdp, len);
+			if (ret < 0)
+				return ret;
 		}
 		pc += asn1_op_lengths[op];
 		goto next_op;
-- 
2.15.0
