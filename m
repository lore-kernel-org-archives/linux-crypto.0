Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E86838B7A7
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 19:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574938; cv=none; b=TZ2/L6MBx4qvU5UIKUmUsP9RdYdaWk0yg3T2fV3Qz9obVgbobaPugLF1nfOp3u+RkIOnvx/8qxMiM+Xu6Iw5r+R2CCAid4QYCfVrC5CDDEqpisGTRvtpdoDo2gOyx+U94t1Z8KNp72y3u8yNu+r0j+vdrIdEonYd3QHYN16IOmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574938; c=relaxed/simple;
	bh=n4rtoVBivuuxT8maYZ6GjwI9IH0POieenNXxUQeibjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aAh077UVRiYTOKOmxELGl7TKow3sf0CUnF9yaYyC8bEoEAaUbVjahMBDyjxbQv/YoMYHCx5kRdA353fg2n14l/AUokOfySrNo7TAj2TEYkKX4DcQsGeFu+D7e7yhMbeKd3ihSv2mQkZ/nVJR02YrCpW9Bpb3qDdNPlobxROLwuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=u9lMWM72; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="u9lMWM72"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so46605755e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 12:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1784574936; x=1785179736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7MPEl8CVn5sXC9/GdUGvs1DC58WkPmH4mOB5joq72dw=;
        b=u9lMWM72G/OAeZj78uLjzvqNXEjN7oH/OyKK6cZkqzBt/cbhh/BapH4YoEkuUBZLzQ
         278JUNxVn5eDSq+DHDkc1q5HaJzd4YDqZT68/sEsFO9zNirEtT1xGRA+zt8BpY6wLS1n
         a5kYY75Bklki2CzDMux+kJsbbo3CC8AMl6Oei23JXm4WBI/t4udQzvEn40pm5tlZOjWA
         c81+Y+FdHqKNjnlGX71tqpdQhsUqBi38+WnbbvbesIfAsblqj63AXtJ6KpK4j1BGUu2I
         IAhANa07xu8ELHGjOqWFMHcHBazaWUQKaLcAHtqnB4YknNrKR744glFWs5dkw30jEwiB
         0y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784574936; x=1785179736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7MPEl8CVn5sXC9/GdUGvs1DC58WkPmH4mOB5joq72dw=;
        b=baDYzbvckM6IcvFRpw1BzbLpeSNocAtqQ2Wr3OBYivQ5Nb3IumX/09tXlrUa/XGmOt
         FnxYWr050j0JAayIaGR10ZOwEvhu+T2BAuMQHSwFErr5RtpafoXxHyBLjX4Y56n0EJrc
         bpmZkeUBcwxdSeTJ8nN0AgrdON5UqBfcY81q9kJ2GjTBR2johyknjJeJkPYBzjEJJnUp
         ePoeLJgNgdfiZowF0iv93edWi53ZIthbKAaDY3VwoSm+yOJ5HXalEG7iKTDnD7lta7Sn
         1xNQFqizhnw8Wf9V+aW71U9ljHNdAlcWC9Qcbq/jSM1dEMaoTv7u9i/W4G5URRaZmaqq
         fHGg==
X-Forwarded-Encrypted: i=1; AHgh+RqA4JYSd/N14FX46z1bc1X17FVcnFX9O3ujCuTk6VfUc4MudI59J/+c2VszTSTGp83cmsIZPu6mkx3uUsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP6BqhcpepaCo4nDO/QjcFPPPYX9GBZz+89WtwkFb4p19mL7zq
	DU6PC8xP2M2PnqGj25GnXqK5A+OPIhkl7lxecADL5fOWAoqJeCvubNlfdjmvIb+VLVX2
X-Gm-Gg: AfdE7clChxCWMYHeiBAJt6s+ZgineYBArdkeOYCli9Ennb5ToZauM7s4SJBftjScfGF
	LQyDovMOx1ZtqUV3Bq6MTywgF9JLTsToXNVD9Fc8krOKxuH71r5w2mkZsjsaN4G9eFJNcc5OiKP
	Xb5e+qilYcVgA1ByRgEQQPGYveQnJpP+F3fvNtJrcdVDJ5BNbcz5HR18yvWo7BqHUOM6RzDQOkS
	J7gD7ECpdRLg7qvHW/2MNNmQr8G4Cbabt6ZXUnfryuOJX/MxB8pYTXXcQHBP1FcRLuRUpU3EBeN
	y47vcUoddBOIhJVeOFM3hwLDFGXI5wpTcM3vtYnD0w9IFo0gGMAM3PFoxVPenu0Bg0aC+Tr6D/g
	6sFPWlmALiU3esaIOs+dBvkW2/m6+0HGA4HA1CXVqvsqisBxQWqqjn2NRfoxgrLt+MWzmxAslLs
	ecQbg5vPJEYeyH+spRGpOPzzClV7cyvMECD9Q9c1BskYvOSAApz+MEcb4ioJs6uFbeedcuD3P9m
	EgAVZRxKqU+7TsrEjoBJXUlVwTMmP8ns3KfxCTRNzscMg==
X-Received: by 2002:a05:600c:3153:b0:493:e97c:216e with SMTP id 5b1f17b1804b1-4954a41382fmr186525145e9.39.1784574935532;
        Mon, 20 Jul 2026 12:15:35 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e49500sm34232061f8f.2.2026.07.20.12.15.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Jul 2026 12:15:35 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: stable@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Doruk Tan Ozturk <doruk@0sec.ai>
Subject: [PATCH 5.10/5.15.y] crypto: rsa-pkcs1pad: Don't WARN on an empty digest
Date: Mon, 20 Jul 2026 21:15:33 +0200
Message-ID: <20260720191533.15971-1-doruk@0sec.ai>
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
WARN_ON(!req->dst_len).  The warning is therefore directly
user-triggerable, and on kernels built with panic_on_warn=1 an
unprivileged process can panic the machine -- a local denial of
service.  Reproduced as UID 65534 in a setuid sandbox.

Keep rejecting the invalid request with -EINVAL, but do not emit a
warning for the user-controlled length.

This is the 5.10.y/5.15.y form of the fix, where the length is read
directly from req->dst_len rather than cached in a digest_size local.
Mainline does not contain this code path; commit 1e562deacecc
("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") removed
pkcs1pad_verify() in v6.13-rc1.  This is a minimal fix for the
affected stable branches.  The 6.1.y/6.6.y/6.12.y form
(WARN_ON(!digest_size)) is sent as a separate patch.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index e2f4ccbd71dd..d10076bb6ec2 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -535,7 +535,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	int err;
 
 	if (WARN_ON(req->dst) ||
-	    WARN_ON(!req->dst_len) ||
+	    !req->dst_len ||
 	    !ctx->key_size || req->src_len != ctx->key_size)
 		return -EINVAL;
 
-- 
2.43.0

