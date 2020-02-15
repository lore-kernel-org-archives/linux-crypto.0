Return-Path: <SRS0=thAn=4D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4ABEC352A3
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Feb 2020 06:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2D4F2067D
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Feb 2020 06:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgBOGOT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Feb 2020 01:14:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56382 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgBOGOS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Feb 2020 01:14:18 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j2qiW-00D3pz-L1; Sat, 15 Feb 2020 06:14:16 +0000
Date:   Sat, 15 Feb 2020 06:14:16 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] almost certain bug in
 drivers/crypto/chelsio/chcr_algo.c:create_authenc_wr()
Message-ID: <20200215061416.GZ23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

        kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
                - sizeof(chcr_req->key_ctx);
can't possibly be endian-safe.  Look: ->key_ctx_hdr is __be32.  And
KEY_CONTEXT_CTX_LEN_V is "shift up by 24 bits".  On little-endian hosts it
sees
	b0 b1 b2 b3
in memory, inteprets that into b0 + (b1 << 8) + (b2 << 16) + (b3 << 24),
shifts up by 24, resulting in b0 << 24, does ntohl (byteswap on l-e),
gets b0 and shifts that up by 4.  So we get b0 * 16 - sizeof(...).

Sounds reasonable, but on b-e we get
b3 + (b2 << 8) + (b1 << 16) + (b0 << 24), shift up by 24,
yielding b3 << 24, do ntohl (no-op on b-e) and then shift up by 4.
Resulting in b3 << 28 - sizeof(...), i.e. slightly under b3 * 256M.

Then we increase it some more and pass to alloc_skb() as size.
Somehow I doubt that we really want a quarter-gigabyte skb allocation
here...

Note that when you are building those values in
#define  FILL_KEY_CTX_HDR(ck_size, mk_size, d_ck, opad, ctx_len) \
                htonl(KEY_CONTEXT_VALID_V(1) | \
                      KEY_CONTEXT_CK_SIZE_V((ck_size)) | \
                      KEY_CONTEXT_MK_SIZE_V(mk_size) | \
                      KEY_CONTEXT_DUAL_CK_V((d_ck)) | \
                      KEY_CONTEXT_OPAD_PRESENT_V((opad)) | \
                      KEY_CONTEXT_SALT_PRESENT_V(1) | \
                      KEY_CONTEXT_CTX_LEN_V((ctx_len)))
ctx_len ends up in the first octet (i.e. b0 in the above), which
matches the current behaviour on l-e.  If that's the intent, this
thing should've been
        kctx_len = (KEY_CONTEXT_CTX_LEN_G(ntohl(aeadctx->key_ctx_hdr)) << 4)
                - sizeof(chcr_req->key_ctx);
instead - fetch after ntohl() we get (b0 << 24) + (b1 << 16) + (b2 << 8) + b3,
shift it down by 24 (b0), resuling in b0 * 16 - sizeof(...) both on l-e and
on b-e.

PS: when sparse warns you about endianness problems, it might be worth checking
if there really is something wrong.  And I don't mean "slap __force cast on it"...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff -urN a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2351,7 +2351,7 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	snents = sg_nents_xlen(req->src, req->assoclen + req->cryptlen,
 			       CHCR_SRC_SG_SIZE, 0);
 	dst_size = get_space_for_phys_dsgl(dnents);
-	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
+	kctx_len = (KEY_CONTEXT_CTX_LEN_G(ntohl(aeadctx->key_ctx_hdr)) << 4)
 		- sizeof(chcr_req->key_ctx);
 	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
 	reqctx->imm = (transhdr_len + req->assoclen + req->cryptlen) <
