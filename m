Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E2EC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 08:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8803460273
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 08:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhKOIv3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 03:51:29 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:11874 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhKOIvM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 03:51:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1636965900;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=dEwNsM/llNTIV+Si5Dcb8gDkUHsSuOYvF0SFRvigExw=;
    b=oyf+Sk3AGX9QIX2XVCLjHe4gBfzUHcGPPV6us6dxqhYwV5eEWpfwILnV+zZHN6jUAL
    TC0zTOlhOhec7EzFKRAh2nvi3aJ+mj0NyTZoaIm5NvHSOnPxq/qweuOffQZG2REsWvSj
    rgOIUe1ZD7BtOItg3dPvawQk7cXd9BTHiHy4jfOLrf6xPEbKEzgTlAR4BhrAh7oXi1Jk
    HY7St5ZYItgQtxiKNi/Z5ti8quX6pjb1H05duOuiT3xRWyTu1Q0cJiBkcLhOOcjGdwkh
    K64qmcP8d39Gq+fkb9DG98m7MiY9Rz+lWgOo78jRlqQnpfLUIOFslIDIlP4aS1gTfXOC
    NU6Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvTOeuXTEc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxAF8j0U8q
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 15 Nov 2021 09:45:00 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings <keyrings@vger.kernel.org>, simo@redhat.com
Subject: [PATCH v3 3/4] security: DH - remove dead code for zero padding
Date:   Mon, 15 Nov 2021 09:43:53 +0100
Message-ID: <3323567.LZWGnKmheA@positron.chronox.de>
In-Reply-To: <2589009.vuYhMxLoTh@positron.chronox.de>
References: <2589009.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the specific code that adds a zero padding that was intended
to be invoked when the DH operation result was smaller than the
modulus. However, this cannot occur any more these days because the
function mpi_write_to_sgl is used in the code path that calculates the
shared secret in dh_compute_value. This MPI service function guarantees
that leading zeros are introduced as needed to ensure the resulting data
is exactly as long as the modulus. This implies that the specific code
to add zero padding is dead code which can be safely removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 security/keys/dh.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index 1abfa70ed6e1..56e12dae4534 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -141,7 +141,7 @@ static void kdf_dealloc(struct kdf_sdesc *sdesc)
  * 'dlen' must be a multiple of the digest size.
  */
 static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
-		   u8 *dst, unsigned int dlen, unsigned int zlen)
+		   u8 *dst, unsigned int dlen)
 {
 	struct shash_desc *desc = &sdesc->shash;
 	unsigned int h = crypto_shash_digestsize(desc->tfm);
@@ -158,22 +158,6 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 		if (err)
 			goto err;
 
-		if (zlen && h) {
-			u8 tmpbuffer[32];
-			size_t chunk = min_t(size_t, zlen, sizeof(tmpbuffer));
-			memset(tmpbuffer, 0, chunk);
-
-			do {
-				err = crypto_shash_update(desc, tmpbuffer,
-							  chunk);
-				if (err)
-					goto err;
-
-				zlen -= chunk;
-				chunk = min_t(size_t, zlen, sizeof(tmpbuffer));
-			} while (zlen);
-		}
-
 		if (src && slen) {
 			err = crypto_shash_update(desc, src, slen);
 			if (err)
@@ -198,7 +182,7 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 
 static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 				 char __user *buffer, size_t buflen,
-				 uint8_t *kbuf, size_t kbuflen, size_t lzero)
+				 uint8_t *kbuf, size_t kbuflen)
 {
 	uint8_t *outbuf = NULL;
 	int ret;
@@ -211,7 +195,7 @@ static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 		goto err;
 	}
 
-	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, outbuf_len, lzero);
+	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, outbuf_len);
 	if (ret)
 		goto err;
 
@@ -384,8 +368,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		}
 
 		ret = keyctl_dh_compute_kdf(sdesc, buffer, buflen, outbuf,
-					    req->dst_len + kdfcopy->otherinfolen,
-					    outlen - req->dst_len);
+					    req->dst_len + kdfcopy->otherinfolen);
 	} else if (copy_to_user(buffer, outbuf, req->dst_len) == 0) {
 		ret = req->dst_len;
 	} else {
-- 
2.33.1




