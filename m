Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6F038B7A7
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 19:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574930; cv=none; b=TU5APykvYFx8B6lxZtDXHnhl9Ru/nfos9uDQzmel587EPY652PX5bS3EkQnDxvx4A2Et/JgDXRgC4Uknqp+6qi3oYXZyO5DUkrkdyckkoKgoQWWmXKU6VGyckQ+2wuKsc7xwS7rkKavlp58TJ0BYX7PDGJEXugRElz153wfJEM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574930; c=relaxed/simple;
	bh=xGOyn27kAb2aUQ2aktYzNNe4IoaFrQIOT8r1ok3Xtr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pDGBcKQPxDNpmsP3/MZlvIxfVh2e5W/3EWFFFFKTRvUoFg4oiUXocv70TOJxCbClti8YTaJ72aVxUBkJuvgGL+vt/Y7SsFaGslt10Lk7yVk1CY6u3QEne9ETxZGjV+47sYC4or6ZwDCaf33ZEEOst9hEezHQL7X19mZy3YQ1CVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=boesQUmc; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="boesQUmc"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-474560436c3so5379069f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 12:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1784574927; x=1785179727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5XDxWfj8KWZ9DgniRwAUL8R0m0HpW65KqxOgihYK1aU=;
        b=boesQUmcQve0LMfhp8Sq8RPEztONnkxYK9HAlpScNDaJZVI6NdiLf5cxWAozBZIvgB
         DpbTKWb/uSgIZxf7BsQDfbDxAfRq16VqzmPnhXrZWNzwZPSmPUXUO5gCVINPbhNPbVbo
         iUMPd4r+QKJV/JjOaSACnaOWS/9M8JgMFl6DKpmqVjjG0mqkKJ0NpNu72WllB9+EuoYF
         idCnNxdAv2bHOKs7ABSfxONA1R4/rFWwHGVdwKlHADqeT5ppGpmdEPIT3dYNYyzPLELp
         alKdijUvXcdFd9o8iAru8fXgfk1bFhrwdddU2VFskSfvypgzduhCAS1AeL9Cfv8c12pv
         GdvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784574927; x=1785179727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5XDxWfj8KWZ9DgniRwAUL8R0m0HpW65KqxOgihYK1aU=;
        b=ZalJi3yX1ET1TWKKjzpup+RczZMwOnF1/ILJLv1Jte699YfDKKuNXdQe5Juz5xE7Eb
         QDOCCxc/0jOCHxQK6MxBCEVXmWNg4bW528+a63Bk6N3d2ihAYtTcPgZ3RMnzTpkBi8qL
         J3+YCznab+WVxq+j/vOKUGlRACUg1X+SrP+EqzYJf70/pPBfKKYPqauczHt1XnyqJggr
         mFQuUPHl49U4Y5ySczcw61n8LnWLhkIoJ5Np1QJhKDLOvihRp1LSz8Ln3dwoWjnshjVG
         ATEjz79DMstjvHYVKrUws0CEsO6KCXUjqVAI6gzquqyvue9dhDop9UkgXcqdgw4NJLw8
         DLMA==
X-Forwarded-Encrypted: i=1; AHgh+RpPJiHk1ORUu4SOkWfacAyAKMbfFgzQkrx+rnTciTE6c9P7PilQ6FnR9FMW9ZvyFygx6vc9JF+knXBgfJU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW1Qt57woFw2jPrqGxxcRf1IiiFHBEURKrmft3RY/lvAG986ZA
	5ty1RiXu7BZytcuXDmNekRCCv7PYdSWltEWe1kOeHqPnTrm9YbxyPyF0adexSBF8nMXh
X-Gm-Gg: AR+sD13qtRZ8xnyEwCMUVj54IM89vPiTp47RDqS4zmJceATOrLcXZ5i3w+ZPSIJQaOp
	hRiWL9AZrG2rw4HABspIduDdRh7DUE5G2Laq0av4JrSvvBwHtfMEZHJTmQiOfqEfJOrnQnHBHkN
	47xywIZiYpxPL5tmS0AnQRVfRouPifdVNg2vBhQ+9vloQqAjcSrxvEOrKyXi8n7dTsDPcaDpXFH
	+YPpHTrCtvfzGW3M9MM0p4wCzR/6Iq7CEUewmfDQQkwFb0uZjC1wWOiAzcuwiK6Mhjcagg/3Tq1
	6aDfmkoxQKWQR6BsDArZmm5QSd96MXurdtEPYB9pmnKaN8kM2MReAbKcynjbkXK+AWg2J9281DW
	CubExydPHVTgdoh61QBeSjbrfcJ3jN0KCE6kKTzelDuhNzg9eQZNfZVVrdSTqlUx9n8V/FbsxOZ
	J2VefITaN20kEFb47EbDcvl5PBYulDJedbBIXWB7Y1F+Wngaf7ms5WWYRqdjSvYkHJRoWgOQaAl
	fEg0wPilqMsl0MSPVmkCBlD
X-Received: by 2002:a5d:5d82:0:b0:47f:59b4:390c with SMTP id ffacd0b85a97d-47f62329496mr17832694f8f.50.1784574927315;
        Mon, 20 Jul 2026 12:15:27 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ee926dsm30211503f8f.35.2026.07.20.12.15.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Jul 2026 12:15:26 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: stable@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Doruk Tan Ozturk <doruk@0sec.ai>
Subject: [PATCH 6.1/6.6/6.12.y] crypto: rsa-pkcs1pad: Don't WARN on an empty digest
Date: Mon, 20 Jul 2026 21:15:25 +0200
Message-ID: <20260720191525.15450-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KEYCTL_PKEY_VERIFY lets an unprivileged caller supply a zero-length
digest (in_len == 0).  keyctl_pkey_params_get_2() accepts the zero
length and the request reaches pkcs1pad_verify(), where the empty
digest is rejected but only after being passed through
WARN_ON(!digest_size).  The warning is therefore directly
user-triggerable, and on kernels built with panic_on_warn=1 an
unprivileged process can panic the machine -- a local denial of
service.  Reproduced as UID 65534 in a setuid sandbox.

Keep rejecting the invalid request with -EINVAL, but do not emit a
warning for the user-controlled length.

Mainline does not contain this code path; commit 1e562deacecc
("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") removed
pkcs1pad_verify() in v6.13-rc1.  This is a minimal fix for the
affected stable branches.  It applies as-is to 6.1.y, 6.6.y and
6.12.y (identical pkcs1pad_verify); the 5.10.y/5.15.y form is sent
as a separate patch due to the older req->dst_len spelling.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index cd501195f34a..225fcc3377dd 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -557,7 +557,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	const unsigned int digest_size = req->dst_len;
 	int err;
 
-	if (WARN_ON(req->dst) || WARN_ON(!digest_size) ||
+	if (WARN_ON(req->dst) || !digest_size ||
 	    !ctx->key_size || sig_size != ctx->key_size)
 		return -EINVAL;
 
-- 
2.43.0

