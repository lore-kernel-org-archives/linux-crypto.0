Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B78388E66
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776347671; cv=none; b=OMQJixsMceaMS7R69iPh/SOLfbsIVU72fpFEydFHvi3ufP0NSmERe3BGiVYYSZYn7/mzUY+gsj2Qs3GS5anPyfO9JRyB5Ly2E1eqH8mFEmRqmi8PvRO664KmBtPqv61IGMnXHtRojn3XKvf00zQLzzfsySiw/gUfRVtEYE1sxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776347671; c=relaxed/simple;
	bh=5dFyc9ViG+IUPVU+ZTKPrFPBeru8WiIAA7c3t+2z4DA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=khFG1MFL+l4Mvqe7YfzvxMRb2bux30hvVcTt3USTcoPmz3qCk6DcZj2bJvz09aLuhqNWtO5f+yYhFdGX8jZehFdpPoOkoekfv65Tiyy3KGgydLAoVvS0ddV0bZ/9q1ZHuVtvCnryD6q8qVI9/SXymu70iYPUF71vzpYhvi4IMxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WMz1jt4U; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMz1jt4U"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82cd70febc7so5406429b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776347669; x=1776952469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hbv+oSdP3bIxxAxFi//tYgCtqT/PGPjRSP4DbveicnU=;
        b=WMz1jt4UfZfNu3a/KGPKQYGyerSmAmSCVT1egUyJGO5QsZht1lGGIBRKTbLujIkUUV
         EbnjwqdxKv6C6bmIH0iZ/3+Kt1Z8kyVdxP5pD4+aL5p9M3drrZRlzs+ahdr0lTChyd27
         pxW+hHOqiXLhSud7qE2wc/d0CK1wW5RvtwFdX3j3jcHQwa2xrIeuwldB/8jamyoRvmOJ
         K65msMaUiLqARDzNRhwubBgBCGcAwZAnYj5LWECg98PgVuMvnp0q2Htc9Rmr3SjeVIgu
         Dc50NkuBnV/xweunMR/GTSruaeJGoYKREgoh+pL3uY2D+o7EoIHfPukM19O3m0NsNzbn
         vXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776347669; x=1776952469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hbv+oSdP3bIxxAxFi//tYgCtqT/PGPjRSP4DbveicnU=;
        b=b7QJtAy6g3aTT/zzrSEVLCuLqVU0txfmCSL83kKKRPaIe2A2K6YVFo7n7iLggvDoQR
         Cns5BOXFWjNQsN3hLIvsL3OluvTEL7E55ZakLxiPkApWeU9oI+J9d/7aVI5nLXa9f1mP
         XTsXQnfsQ+ZhJ0bM5XUNsNq7gkJ3L/iCiUcfmL+B0y7zve4WgFL74rPpkRMb2ibmCJVj
         Yn/DW7ARk0wcuH1nGJEu+3/7cTAEmPRrZA81Zsl6J2Vw7Hj+iTfjo5v2YZ5QdnVG2cfv
         5GX1ww8rv1ch3A0ZtnZV7oVP0R1E1z6+CO0qSDCdDc+GeuQpw0/eZQsA190qt1lI5CTU
         44Rw==
X-Gm-Message-State: AOJu0YxMDa3U+mLGFQaaEuAWYGdarTS4CfqRw8F2u9WQqVAli2jmF8Ay
	oySRYlPTvPfx3r3oCZJPdcDXOQ0wfCs214GyG61wxZCe+ap1jTsSR9LKNQG+xA==
X-Gm-Gg: AeBDiev3A1R1HxsxmtxWAKsnPv7sl2hxY+b4ifngZYj/28ESXPOgYJubpHh79cBecXS
	7piRsG75dtq7iiP2FI668Vk6ivN3qtEqlMWPZOqlqixG4IXfSo/SEkcpuBHf943BpLOA9T6V2wC
	XwARpGUtw8wz/ioKCJgKK1SA+1S5M/rP9yHtZJ2749AurdT/Fq+0yzEqR95GQckh+KcDq0/mZ0n
	R944Md9BsEIgNhHlgpi1E0u494mPQ2a9yskkoNJVgtabW4Eb4TlE5B4pqRylnelpVJy6p1V7FZ7
	VPCB+MMNrrFCIujcnTMxElkNRTqdUJ98sMrbACFeu+uXpZiFhWMODDyyKBC3/QCAL3pC2mxb6Wz
	iLmngifRMrX9qHgiSrdSqoOybrKSdM/wVzwipoODNpDHpd8jsG7El72tNYfi4/BwF8Jeoy/tu+C
	D4u64YseZNB6OGJzVlowhKcsxf2xkXAyywj0/cCTGgZrxRRvPrU4K8sPuSK/d25HHc9h2jFqWCj
	t/5MTKjlCYRdw==
X-Received: by 2002:a05:6a00:e1b:b0:82c:20e9:fa53 with SMTP id d2e1a72fcca58-82f0c1d9fc2mr26207350b3a.5.1776347669169;
        Thu, 16 Apr 2026 06:54:29 -0700 (PDT)
Received: from localhost.localdomain (69-172-89-235.static.imsbiz.com. [69.172.89.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f66ea6950sm5148118b3a.0.2026.04.16.06.54.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Apr 2026 06:54:28 -0700 (PDT)
From: Dudu Lu <phx0fer@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	Dudu Lu <phx0fer@gmail.com>
Subject: [PATCH] crypto: krb5enc - fix async decrypt skipping hash verification
Date: Thu, 16 Apr 2026 21:54:24 +0800
Message-Id: <20260416135424.68785-1-phx0fer@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

krb5enc_dispatch_decrypt() sets req->base.complete as the skcipher
callback, which is the caller's own completion handler. When the
skcipher completes asynchronously, this signals "done" to the caller
without executing krb5enc_dispatch_decrypt_hash(), completely bypassing
the integrity verification (hash check).

Compare with the encrypt path which correctly uses
krb5enc_encrypt_done as an intermediate callback to chain into the
hash computation on async completion.

Fix by adding krb5enc_decrypt_done as an intermediate callback that
chains into krb5enc_dispatch_decrypt_hash() upon async skcipher
completion, matching the encrypt path's callback pattern. Handle
both -EINPROGRESS and -EBUSY notifications from backlogged requests,
consistent with authenc's authenc_request_complete(). Also fix
krb5enc_request_complete() to filter -EBUSY in addition to
-EINPROGRESS, matching the authenc reference implementation.

Fixes: d1775a177f7f ("crypto: Add 'krb5enc' hash and cipher AEAD algorithm")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
---
 crypto/krb5enc.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/crypto/krb5enc.c b/crypto/krb5enc.c
index a1de55994d92..2490343873a9 100644
--- a/crypto/krb5enc.c
+++ b/crypto/krb5enc.c
@@ -41,7 +41,7 @@ struct krb5enc_request_ctx {
 
 static void krb5enc_request_complete(struct aead_request *req, int err)
 {
-	if (err != -EINPROGRESS)
+	if (err != -EINPROGRESS && err != -EBUSY)
 		aead_request_complete(req, err);
 }
 
@@ -300,6 +300,24 @@ static int krb5enc_dispatch_decrypt_hash(struct aead_request *req)
 	return krb5enc_verify_hash(req);
 }
 
+static void krb5enc_decrypt_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return krb5enc_request_complete(req, err);
+
+	if (err)
+		goto out;
+
+	err = krb5enc_dispatch_decrypt_hash(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return;
+
+out:
+	aead_request_complete(req, err);
+}
+
 /*
  * Dispatch the decryption of the ciphertext.
  */
@@ -323,7 +341,7 @@ static int krb5enc_dispatch_decrypt(struct aead_request *req)
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
-				      req->base.complete, req->base.data);
+				      krb5enc_decrypt_done, req);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
 
-- 
2.39.3 (Apple Git-145)

