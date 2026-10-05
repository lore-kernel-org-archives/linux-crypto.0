Received: from mail-dy2-f41.google.com (mail-dy2-f41.google.com [74.125.229.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1604BB7E2
	for <linux-crypto@vger.kernel.org>; Mon,  5 Oct 2026 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212615; cv=none; b=FsoPUz+YR6qrOV7vA4/1NKYd4HUVx0CYIJY8UkX0T4PbDWUzqrWLI/0fe5VdT7AmIIIRL94cAawUtnGzcMTynKU/T6p6aPJuEHooJkK0yuOe3qdO1QeGOF6Mb52EbvX5MeHnYtOFIIRSxMHeLqnQO4eiMsxYqw+PmEoM4pZB4MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212615; c=relaxed/simple;
	bh=NbwgF8HB32C6CTSgmUSYGhfsnpFr/uNAFvC75azPG9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qF6h8ADbYvZ/k+Mu3uV/NtmAXAaGhRqA5tPiu8CWPSzWIebOdAqSTpgf5+bzA8gdjjVYH+EM6a3ugfcNtTeyaUMugwTrR+WOkZaQZ2oSkaAy9GWzjThCy9F6yo6FRDKuygO1ayp6ojMYva4uRJwQhCby7zNAZ5RFlJ2jfwFyaOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GcbNFZbi; arc=none smtp.client-ip=74.125.229.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GcbNFZbi"
Received: by mail-dy2-f41.google.com with SMTP id 5a478bee46e88-34bffc8105eso2236549eec.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Oct 2026 08:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791212613; x=1791817413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w2wQ/G2NsTt77H0vEd1WVka3hOPCfr18QpjBWN9sEj4=;
        b=GcbNFZbizI55meM37dm2XA8jick7Z92BaOkS7D4DZc2bw9cXSBqhJNxQZo0y6sbdi7
         VcBv/HhETpI1AsRPtv0UZJaGJV1uVF8tnNG6+xrxEIbYI54+dxLCSJsbXu5+fzxLzNxX
         jDcxh5kjfYqcWU6dpGYvu/xak9FmAloNivUXuth4wB3HqccGEIDg3ORxTWNfycWr7YYn
         xxzg8gGrcduY1332VHEq41/eftRMEq1cw7z+WW4e2BvjTGm0k7mJbFDHGHxmjyHnLv8d
         d+H/RUxZ4gjVs9iOGe5GRxBpXDaWdtWwK8aqJoAmrhPxXh3CkwgAHfCCbAZljgNzo42C
         n35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212613; x=1791817413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w2wQ/G2NsTt77H0vEd1WVka3hOPCfr18QpjBWN9sEj4=;
        b=UrTy5/lnu+a/CnlUMNvtb1vPycdYdfSn33DQdL1AjTrO56t25Ek4SB5dAgqYz6vAQj
         6SbyKo54X6gXeeCd2rvBI79o0tsHaHeF2WD3qCh2vtOzQmXPuNXnT+GO/3jETTuhuCL3
         kmYz22/pdHYrgiZ42iAYiIONwQePWJoJP95bjpd41XuAhHhGUsFWo4zbiHR+Dovw0QBJ
         XzIJ1xQCuZBE9sZ+THh4RVQU9GMiK9wIBaYKGVyDTxEbjHiyOGOwYPGfQGHhfsLhQhqg
         Xwptt8U/KJeS7odCVdioFVPf1vuUrgNTKRSeX6DC8P7xd/4xlDJllqrjpKc1/AvsgVmZ
         Mb8Q==
X-Forwarded-Encrypted: i=1; AKwUvBwoGaM+6sYilhh6NQTpc8CzMGTN2TAdMzhjBh+ixaM+kA8th3N1//qyeuo6s5crwpBbXnMf90yQp/ATjwY=@vger.kernel.org
X-Gm-Message-State: AFuF++lOITWAor+/X7QBL/Z3kSty/fy19TKvUb3hs1ke5qipItSw0b+n
	iauG9wQbFngDCkiTg4qUSILdoQ/J+V+IfDpEoqVgIeratthmlqxpd+Nq
X-Gm-Gg: AYBFou1auFNLorh2xlA0qobvuVsdVHC0VvhORG4+uRCd98UoWL5BXLs1NiWvxTA0GLq
	qKE0JTQvZjvdOzqYUsVlvCt/E9S6h+2Bt1OgSq9JTTQh97ycUDKKn8WFi3wfAo8l50IZg4QZkeg
	f122IBGsY9+M6lAHzsWgd4ImQPIVVrZNUwafIUpNuj9W+RLwCbbO09UNbwhSjn+JHQTN8ueT/wP
	PPYZ/bDIGVZ/hlb3Mw16nDmf6+NcGcqFTU0pI7QRiFeA9Z/N4lxgwuH7MV8Cw2u+JUV7yXKtxbU
	h1Xublqn2t8kjoGiLt3Ub4FTY+F9bdvjaCVQv1h//ikrsVTBJt310/p1ZlSNlbmNehDk3Qat20o
	PFEJIqfms40bLyLeBSnfQHTo7LVPXtupfRwZ/xdgfS/LodiZp56nbkfh/bR+g5Vi0UIDjLrTTqD
	uo6J7F9LNEAkHouypdlswTVsc/Sd7K6TdqWvfhhk1xF32kHfQXAkG93Yt+ANgSj3E4fdkEePL0L
	JPYPYJzoHh74OCwgQ==
X-Received: by 2002:a05:693c:41d6:10b0:342:451b:c0cc with SMTP id 5a478bee46e88-34f1509e598mr13877273eec.6.1791212611886;
        Mon, 05 Oct 2026 08:03:31 -0700 (PDT)
Received: from kernel ([103.219.206.73])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351272a9360sm14886789eec.23.2026.10.05.08.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:03:31 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: ebiggers@kernel.org,
	ardb@kernel.org,
	Jason@zx2c4.com
Cc: skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH v3] lib/crypto: chacha20poly1305: zeroize state in __chacha20poly1305_decrypt
Date: Mon,  5 Oct 2026 20:33:24 +0530
Message-ID: <20261005150324.5621-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `__chacha20poly1305_decrypt` function does not zeroize the chacha
state, unlike its encrypt counterpart. The regular
`chacha20poly1305_decrypt` function handles this by manually calling
chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
the result directly without clearing the state, leaving the derived
chacha20 subkey on the stack.

Because this function is EXPORT_SYMBOL()ed, this is an ABI robustness
improvement. To ensure consistent and safe cleanup for any future
callers, move the chacha_zeroize_state() call into
`__chacha20poly1305_decrypt()` itself, so the helper cleans up after its
own state just like `__chacha20poly1305_encrypt()` does.

Additionally, moved the src_len check to the callers so the state is not
initialized on invalid inputs, matching the logic in
chacha20poly1305_crypt_sg_inplace().

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
Changes in v3:
- Remove Fixes and Cc: stable tags, as this is an ABI robustness
  improvement rather than a fix.
- Move the src_len check to the callers so the state is not initialized
  on invalid inputs.
- Fix whitespace and ordering of the chacha_zeroize_state() to match
  chacha20poly1305_crypt_sg_inplace().

Link to v2: https://lore.kernel.org/all/asMfBGbckJAhCa45@kernel/T/

 lib/crypto/chacha20poly1305.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index ea42a28f4ff7..c3995ac8acb7 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -137,9 +137,6 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 		__le64 lens[2];
 	} b;
 
-	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
-		return false;
-
 	chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
 	poly1305_init(&poly1305_state, b.block0);
 
@@ -162,6 +159,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 	if (likely(!ret))
 		chacha20_crypt(chacha_state, dst, src, dst_len);
 
+	chacha_zeroize_state(chacha_state);
 	memzero_explicit(&b, sizeof(b));
 
 	return !ret;
@@ -177,6 +175,9 @@ bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 	__le64 iv[2];
 	bool ret;
 
+	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
+		return false;
+
 	chacha_load_key(k, key);
 
 	iv[0] = 0;
@@ -186,7 +187,6 @@ bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
 					 &chacha_state);
 
-	chacha_zeroize_state(&chacha_state);
 	memzero_explicit(iv, sizeof(iv));
 	memzero_explicit(k, sizeof(k));
 	return ret;
@@ -200,6 +200,9 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 {
 	struct chacha_state chacha_state;
 
+	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
+		return false;
+
 	xchacha_init(&chacha_state, key, nonce);
 	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
 					  &chacha_state);
-- 
2.53.0

