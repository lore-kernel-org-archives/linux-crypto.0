Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14072D97B9
	for <linux-crypto@vger.kernel.org>; Mon,  9 Feb 2026 10:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770633057; cv=none; b=n7Oy4HBwiz5DkcDExX+Nf58Bvd/98nzxVNEQV/1NFxinyPKnQSMhk7XrNSwnnKWUTv0t37XnJ8Kt7oQozPxinLkHae8yeCiKhT5loxYk+C1/h/HVYbbBKVujh7DTVaLYWKtJqCWwu8C1nZHGFr3Fbx73a+DgEkXKawiddXIjeNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770633057; c=relaxed/simple;
	bh=Qkv2uIASc//tWjpNFU6OM3TXVYeAhSTPGGdWFg2wHZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=af84yKoZFP8XmfP03PtzdmeyTImKgTyRtkMzotMfntB6xBmB6BpxNJqkFUqn25QB+oGQ4r3WVGmMaaSZQs/rA6iqgww0RLu9B0qL2LgJ5RqX9W8S5RyQjdyOlJ6UJ5Vc6mhUCHuEryWHfTYA3eYVLoAaaf2hxqnTN7ThTOWHTQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXMu6WeC; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXMu6WeC"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59dd4bec4ecso4901449e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Feb 2026 02:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770633055; x=1771237855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e/aAxMia+3E8ul6axWvd9DfTC9sOFxYn4HkjxTEIWwA=;
        b=PXMu6WeCAEbazAJ4mtPwQt6aP0l6qprkd5eUn8yTGslosGSI/BwHpaub9qs3XP0aJN
         kyQexrbQwf8B16wJHMeHAUP4TmRTH4WXfCbeNNvmU3rYbsfAW4uo5tYLNKCrMPNJ3+BK
         EMWjUk2jOHWmWFK+ThgZXEpcaNFigN0tC8ZgnGf5NLzIrYKbVxjzI7wdfCR4tPipd75x
         cStzcpPgDUz2EAX38jeAVfHkHEQENC8LAQcBwKQi3TICrQKcxkNZcXgn3cR++Eszy25Z
         //Ljjk/LHHDXChIMt8TQXEF0ypZl5XhLQKyk7nM+pasLe+/p1N1oTxA6P9BQV8b0lenN
         wujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770633055; x=1771237855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/aAxMia+3E8ul6axWvd9DfTC9sOFxYn4HkjxTEIWwA=;
        b=R21qoQD7D8AsLwqccsufMr6uG5hSt1BWRPMauEN94CpZzxOdmIAMI4xOwgXUcOUbZh
         Sye5keswSWS5HgOFQoXsSs9KzOL9dFdbTbpAr4w7hjUNwAQUSY+bcqMTeDTtvX2DU2gv
         gwI07jGEjoXtOdVSaSjUtBA3ocG4U9qs+WAJASoKFxJZsT2dnf9PNHzrVWHR5mBoMEan
         WYc2HZHOASOWxeBjJA+3OyhHnAzN63a716dfzxcmNm/DJvZoWKCM+wMFaDNA9ijrKeob
         g1o/Ul4mrR1Ei3AWlrY/4reslL6P0v/2uI0wx2sTWjrBN099Luo2evt+T/XtcF++z2MX
         T26A==
X-Forwarded-Encrypted: i=1; AJvYcCXEClrHvFNKb441YB16O0p/KVv6BjrqUYj4HyPz/5JFTfZErYVPJD1YDMBjwzYdC982CaeSHLdZEpsw5uM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAmQMgxYRJsyN4J/dYTmHWuV3+DOYDnYUuCSI8ye27OBvNjgBK
	xFgiK9X6OY4AwWpNYqbZCI11Q8IOBbGNwD4rlfIZ2OT+C+VIaV+MlQ8+
X-Gm-Gg: AZuq6aLo/i8ZG2v8v49AbDXJMiikprkp16LHPLvJgPSgVRpGSAtJMoj+/nvkb/2A1zT
	8Qwv6btO9ubIECHfHIdvBkCmUXIoYlfOjVMbh5hyp4MurPPcKmHjwij/vd/Arhk8LB9QIYoyHo4
	0KTuPaO2Tz2+kH9UUE1jlqq0Tk8REoa7zB+9DhVORNEGSpUtKSV/9iVboAd+kehxOsuq7vuB5ku
	XkNsxX2uS6SAqDhHnzhonW3PxjIP/CP6rXCUNR7ouQ49ebHIxOhPEUsal2M2JdG3MucjHlXOjDz
	XFwifXQ/94bP7wUcVxHA7OJFfjhsuEIBd9LHJYHrycLaIedj8vs2eQ6ZXRbXotS7iU50e1VHove
	eKgFDbWn4WTEas8vpWGZR4P/SfrysLwWIf2+Y3yMJDo+LH2PP2udceDsRQWiL8VND8QL4pkk2ai
	M5ewi95ISJKTxiK24LaSYw3QKGMsDfqSTPhG2EkfaVheWV23vpjRLanr5JbuEQTAKUXNwxSMvUQ
	7cuUKu6WY7GP6Q=
X-Received: by 2002:a05:6512:3e0a:b0:59e:50e7:1273 with SMTP id 2adb3069b0e04-59e50e71400mr576263e87.12.1770633054650;
        Mon, 09 Feb 2026 02:30:54 -0800 (PST)
Received: from localhost.localdomain ([176.33.64.73])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e44cf6ed9sm2494273e87.16.2026.02.09.02.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 02:30:54 -0800 (PST)
From: Alper Ak <alperyasinak1@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: ashish.kalra@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alper Ak <alperyasinak1@gmail.com>
Subject: [PATCH] crypto/ccp: Fix use-after-free on error path
Date: Mon,  9 Feb 2026 13:30:42 +0300
Message-ID: <20260209103042.13686-1-alperyasinak1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the error path of sev_tsm_init_locked(), the code dereferences 't'
after it has been freed with kfree(). The pr_err() statement attempts
to access t->tio_en and t->tio_init_done after the memory has been
released.

Move the pr_err() call before kfree(t) to access the fields while the
memory is still valid.

This issue reported by Smatch static analyser

Fixes:4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 3cdc38e84500..e0d2e3dd063d 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -378,9 +378,9 @@ void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
 	return;
 
 error_exit:
-	kfree(t);
 	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
 	       ret, t->tio_en, t->tio_init_done, boot_cpu_has(X86_FEATURE_SEV));
+	kfree(t);
 }
 
 void sev_tsm_uninit(struct sev_device *sev)
-- 
2.43.0

