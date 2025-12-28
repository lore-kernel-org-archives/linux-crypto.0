Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0AA3A1E7C
	for <linux-crypto@vger.kernel.org>; Sun, 28 Dec 2025 00:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766880068; cv=none; b=DinR4Vz6z4jcCFoDH3b5CkWQFdkewTkkmrFLP4RC7zjsGMQMyz1i55BTeDCfIx96GKzKqtx5Bq38C3tAFPK02vpTguBAexMB2fThf46QjsR/341NCK5WCv3BKGsXUmhJhkfcTg/Re3tX9b2iu9gzbv4qqffyGC3BRao1tXOWaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766880068; c=relaxed/simple;
	bh=KceAPIc48hxqgo6yTY/rZVbmzsMjQ7ZKU0RmTg2rG0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G3ysyA+pZzwXGBqqjqiUtg5qjN9BwTx5HW/qGbpCBROw3uZyPDVD03b7iXJBS7WqqBxu+f0pWwrQoBV8uWyq8WQhhhkIAoQdAVp05s84DUw7+kNVtykcO/SNq6Ec43CilMKTBdNNSgUjSIQc1IKcMsjelOmVKbkjPvX2KdUKnHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fC4tduyh; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fC4tduyh"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4eda057f3c0so91397541cf.2
        for <linux-crypto@vger.kernel.org>; Sat, 27 Dec 2025 16:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766880066; x=1767484866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jN+Xgh+BGKXL1cd1fC7WVWdvAsrIpESsHFXVEg3fNAc=;
        b=fC4tduyhxuEVDo9mkn/r4eCgSIpvy5WnbOdrD8rAwZALseR1PMOlzHi/B85eZ1UfsA
         7thPQa/Bf46AUS40rKTI+T6o1i60+UP5RNZR5M5xLpbUSWRsxpjodhuZJNwMMFMRfItX
         JKLNF2z0G0LPzg4TioKhajbIUm4MbpFE8Mqwh/OPFd1pjf+7phvSROCzf+LhBaeb/aTD
         x2Ej/iUE66w+4HyIlCL4suhJI2ldZxno9xjWhZXtXR5yvjuKIkuHlKarOgnnTxKhEwcg
         S0DtouCJF6YPp/W6p3Y6uvbmrGE9BZ2s3Crtk3hNRuttiwMn8397tTZI2d7PGu4WImPa
         6vPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766880066; x=1767484866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jN+Xgh+BGKXL1cd1fC7WVWdvAsrIpESsHFXVEg3fNAc=;
        b=IYwp9ph9e4Pug+nyThl8eo+YR/qNOD2QcbcVuHBmcBMqO8MOifh8p07koXpm2ErB8q
         LZU7aaE4DhwmdXvBmlX1HdhhRfaXzAIzWaHUW6jJqdz2ZBYbk4JehlU5UsiDG5w1TwYC
         bHFoEQB3pVa8eTPFSexhDxDAHoDixJZtCnv5K0Q/IrlSeSHxj3h3JhmH5a1sATMfkYSX
         XOAkRYftKy6jesD+HFRJtT6EQb5aEAuJavvQ9iKxlhoVU+2w/rUbXKs7FdWSlCeKEeG8
         0ZbHX8QmX95PkMFMPvnpDIRQzvL6WIYJzAg8ePVTLAc0bTu4Aanojbi2hNx4els+GQSD
         DEOg==
X-Forwarded-Encrypted: i=1; AJvYcCUiINTl/aopuJyxauQot2da4mwXhBpf0GrC9jUhOrB5zkbOfhlA0KuYfZcP6mY7SSTN8zUZ/9rXzhPPtEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0cpd04PCoDq/2NcUuQGHvfN/NrTohgDehvvzldX88jgl5Sb0l
	8to21dzD8NUDACA/ARj4u8RtKmBH4LBmzXpGcv+aWIOQ5OiCNwYfP8CI
X-Gm-Gg: AY/fxX5xj8XYuaCA5Mzw35sEPcKD/0xdncMhat31+inZZfxVi7+Bu8gl8tdg1OaZBXP
	FIl1A8QeKpp+VgLOMUoB4GwPgKtl8wI3LERI+sjA6QRw03Kls1cd4423FGCfIUmO1TB9+t0TApJ
	ocxfk8m88r0ARjOglPc6nTd8BVmeLRjLOVnHdewvz1pfzF7wvaPZ1w8TQo24wDQx2vyBUnnzyb4
	mkeUHgi80zj5/1M9qVvZ4UKxeavjicYUyMJnXTPKnywus0g9S1ymcf6QIsM8F+Ctfh8E/OXAnT2
	ahcREhzeR8UfOT/Ai3uNMwZ6w5imL7nQm4VekAgpMarUYGoE4baw+zO5in/hodWxJxej/A5zKEn
	B64FvyZRYXdeUFqn7gs11QtfwihyVJuxi5R83ty1O28loqqy4XV8LwYh6dxUW4y/n/0Gwh0rQw4
	nY+Yjubfvd5ndxi9G0jqCFxMbMB23ZQOtq5s/kXuWztlpPNQrgWVi5bqkYzSFbRnkxZyhjxA+3d
	fMk9G0C7bmH35+y2NOBA/gkqJnJcv3BDe6ObQ1+2yG//RxSGEwPvj+C9dBuOLFqFIieeCEW+APS
	kXOB3reVEJlkCd0iZaj/VU8=
X-Google-Smtp-Source: AGHT+IEuGf6f8YWf761Bu76xMAgDfzllU840RSiZ24ZlP0EI4cqzLjSg+Vfh/8QEP/PUpuL35u19WQ==
X-Received: by 2002:a05:622a:4c86:b0:4ee:1db1:a60f with SMTP id d75a77b69052e-4f4abcd08b2mr374289321cf.16.1766880066161;
        Sat, 27 Dec 2025 16:01:06 -0800 (PST)
Received: from KernDev.mynetworksettings.com (pool-108-51-198-109.washdc.fios.verizon.net. [108.51.198.109])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ad519939sm191612881cf.2.2025.12.27.16.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Dec 2025 16:01:05 -0800 (PST)
From: Alexander Bendezu <alexanderbendezu10@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Alexander Bendezu <alexanderbendezu10@gmail.com>
Subject: [PATCH] crypto: blowfish - fix typo in comment
Date: Sun, 28 Dec 2025 00:01:01 +0000
Message-ID: <20251228000101.12139-1-alexanderbendezu10@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling mistake in comment: endianess -> endianness

Signed-off-by: Alexander Bendezu <alexanderbendezu10@gmail.com>
---
 crypto/blowfish_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/blowfish_common.c b/crypto/blowfish_common.c
index c0208ce269a3..de9ec610125c 100644
--- a/crypto/blowfish_common.c
+++ b/crypto/blowfish_common.c
@@ -306,7 +306,7 @@ static const u32 bf_sbox[256 * 4] = {
 
 /*
  * The blowfish encipher, processes 64-bit blocks.
- * NOTE: This function MUSTN'T respect endianess
+ * NOTE: This function MUSTN'T respect endianness
  */
 static void encrypt_block(struct bf_ctx *bctx, u32 *dst, u32 *src)
 {
-- 
2.43.0

