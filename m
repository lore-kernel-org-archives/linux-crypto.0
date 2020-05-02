Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408F0C47254
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 209DB2192A
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397629;
	bh=DNH8HL7hR1z4xDcsrk0vwGxoghDmgXVHhKNAUdwhCMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qEKiQ4cWBTfJgMsPMspBVFsL8jVCs794e7qYsLqqv1xzFFFPRgJmbHpeif8FjJ+bH
	 MiQD59Jt2sZimCev0MdIOrQaLpxJu3DHnuem4hj8dBgO9TlxXkWVajuoD8a/C7Ydgj
	 XD7D5GC12G36pJgfOtf4hWEB6vcWZHuTFg4yKRkE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgEBFdr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgEBFdq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:46 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD4E52071E;
        Sat,  2 May 2020 05:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397626;
        bh=DNH8HL7hR1z4xDcsrk0vwGxoghDmgXVHhKNAUdwhCMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioPw0U6l6P5ers4ni090dUqsLG8mEYUwGrMBCkQbXNyCcm+gedmvM9881pYACQla+
         rpcv3YLfWJYN7wmTj+UPkHKCsTPa15qpS5mwMtCS6n1nOQoSW8lC4nt+jTingAGfDX
         rvM0jjIRXCRHlS+EmS/yhY6Fc/8H+KS2KCSX5FQ0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org
Subject: [PATCH 18/20] sctp: use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:20 -0700
Message-Id: <20200502053122.995648-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of manually allocating a 'struct shash_desc' on the stack and
calling crypto_shash_digest(), switch to using the new helper function
crypto_shash_tfm_digest() which does this for us.

Cc: linux-sctp@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/sctp/auth.c          | 10 ++--------
 net/sctp/sm_make_chunk.c | 23 ++++++++---------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 4278764d82b827..83e97e8892e05a 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -741,14 +741,8 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 	if (crypto_shash_setkey(tfm, &asoc_key->data[0], asoc_key->len))
 		goto free;
 
-	{
-		SHASH_DESC_ON_STACK(desc, tfm);
-
-		desc->tfm = tfm;
-		crypto_shash_digest(desc, (u8 *)auth,
-				    end - (unsigned char *)auth, digest);
-		shash_desc_zero(desc);
-	}
+	crypto_shash_tfm_digest(tfm, (u8 *)auth, end - (unsigned char *)auth,
+				digest);
 
 free:
 	if (free_key)
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 09050c1d5517e7..c786215ba69a54 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1666,17 +1666,14 @@ static struct sctp_cookie_param *sctp_pack_cookie(
 	       ntohs(init_chunk->chunk_hdr->length), raw_addrs, addrs_len);
 
 	if (sctp_sk(ep->base.sk)->hmac) {
-		SHASH_DESC_ON_STACK(desc, sctp_sk(ep->base.sk)->hmac);
+		struct crypto_shash *tfm = sctp_sk(ep->base.sk)->hmac;
 		int err;
 
 		/* Sign the message.  */
-		desc->tfm = sctp_sk(ep->base.sk)->hmac;
-
-		err = crypto_shash_setkey(desc->tfm, ep->secret_key,
+		err = crypto_shash_setkey(tfm, ep->secret_key,
 					  sizeof(ep->secret_key)) ?:
-		      crypto_shash_digest(desc, (u8 *)&cookie->c, bodysize,
-					  cookie->signature);
-		shash_desc_zero(desc);
+		      crypto_shash_tfm_digest(tfm, (u8 *)&cookie->c, bodysize,
+					      cookie->signature);
 		if (err)
 			goto free_cookie;
 	}
@@ -1737,17 +1734,13 @@ struct sctp_association *sctp_unpack_cookie(
 
 	/* Check the signature.  */
 	{
-		SHASH_DESC_ON_STACK(desc, sctp_sk(ep->base.sk)->hmac);
+		struct crypto_shash *tfm = sctp_sk(ep->base.sk)->hmac;
 		int err;
 
-		desc->tfm = sctp_sk(ep->base.sk)->hmac;
-
-		err = crypto_shash_setkey(desc->tfm, ep->secret_key,
+		err = crypto_shash_setkey(tfm, ep->secret_key,
 					  sizeof(ep->secret_key)) ?:
-		      crypto_shash_digest(desc, (u8 *)bear_cookie, bodysize,
-					  digest);
-		shash_desc_zero(desc);
-
+		      crypto_shash_tfm_digest(tfm, (u8 *)bear_cookie, bodysize,
+					      digest);
 		if (err) {
 			*error = -SCTP_IERROR_NOMEM;
 			goto fail;
-- 
2.26.2

