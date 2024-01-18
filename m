Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A562C843
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597664; cv=none; b=bLLSB6kVMbmkNvqJefeM1AtTC6OhNHpeciFOA8OKq60Y6SIzPja0uYsRTcOlUkRyCWy2wqVOgAjjUfd0LhGxqCuXCSiaLdhXfwvG8BuJ4AyCHiwle/xKbduZH88jUDDUhMLgpl/NFZjEyQ6LRYqlf9drT4M4gLhWp7/ZnYhI6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597664; c=relaxed/simple;
	bh=esEuVtsGnTmd0hkaLNKKp1YZntXpEFU6zENBP770TFE=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=FEVAROfwP8kK9eH1ucfPYzaHXGuLWetvbAj317Pq4lfwnE2dEpgnzno/PG4DACCM+DwE7bEQ67zj07fQ2v65MsmANudDAApA8Ew5ZCYP5/AGSn6yRBnc3HUXDx8XeGDOFEDVYWiuhPsooiSULleI9tY0v4Zfgz4wA9BZ5WhUDz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dC0uuvG2; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dC0uuvG2"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc24de01bd9so2630594276.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597662; x=1706202462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rOaubHCN0d/JbHeeyKhI2Cii265DwIb3nT8U1KTfMHU=;
        b=dC0uuvG2gTDmVJXshQ14JKXfWV3JCCSYpZhstZDb+oCvyNGC7zlwgyb1wR9+pQG6T/
         V3bfmbjjdHK82cd+Y2X39Qz0Iy2KSvF27NjZjHrp1Sr75CWG2wbXHGFiYhzMRrQpkmd4
         Zl7hD+0zNZhE2WO13MgToOsU4+BajAfUb+n57QorYFDAdspPAFtKTAsrdT0gCVqPvq7P
         i/8U9JzIle49ks+YHhCXLJzJn/+FTni7yJtwAqTmi4WMU5hTk1CJArk4p5MNn2wkG/G1
         wa7FXpJYEOJXkHcvBWZZbk4vcxmT6ppaOKkNWQ2MkSavyFy+V+rTU6yp8GlkOEY0kpqo
         lUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597662; x=1706202462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOaubHCN0d/JbHeeyKhI2Cii265DwIb3nT8U1KTfMHU=;
        b=GV+VQ2T6Ft1QwLAw4kBcpWVTJeYR3xrlyy9REXiLPJbPurWDu3PM3/NQ582yuFhwvo
         ZTMeer4Ez/Z1SqbIBltOE5OnOVeAxW4QxXEGJN/rehRm6SSSKhQjMe4mAbfp4EtY9z2Z
         FEpTNSFueutTdSOfxO6ndGabOKewcPIE5XuURAOeY4eOlXPIuLjiMc9PAvA+stH8X9LZ
         e+wKJzy1oBJsMTDFm/UrgMUfl8x6xLuZhcXM3o3m8nHcWx5TvonxgnNv7w/Nl4kvGJYY
         UidgIChveevfoAOWZF4+vTULtpsNQlnQkoMzrEqoNPJU4yGCNLGEZKJ9ZDWVjvIYzt//
         aU6A==
X-Gm-Message-State: AOJu0YwVKIXuTsxfoKO/QsUXeKb+0xcCLT+tx7I3cKxUaeRI4vV1ljNJ
	fYJxo+n7u7xIue6+v+PshM2ANX16WRFe0TfGf8UmLmFUbmlvmGqAPzZSeEkBM3VvQW1pfEDMkSb
	0bIfTl2LtWc8VeFxJZt9JLX5FFwB32W5afK5/1DZQaULCGvbH+CcNlg4MmINiRPLQZlDz2ykvzU
	5fqtY9ySPjfBLJfGhVfyjkUY3U7jOUVg==
X-Google-Smtp-Source: AGHT+IHM6SQvc5VkcIa9M59oWVSyxOnSY1QtA/erkBYS5yGmK6Kt14fMjuRsbozq1O3Nr8+Cby/i8Ve1
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6902:2705:b0:dc2:3411:6424 with SMTP id
 dz5-20020a056902270500b00dc234116424mr477264ybb.2.1705597662157; Thu, 18 Jan
 2024 09:07:42 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:31 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1868; i=ardb@kernel.org;
 h=from:subject; bh=8krDFuO6ohSM5gr3lqbU2dJ0WRAj0VbK0XKYMUR2NTg=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1PRHblMnpFydMvO9y8MT/1sOPy11/7lJ8t61LQHdb
 rMcTjDKdZSyMIhxMMiKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJaHsw/PfP/7J00ZtaY7v7
 sjk7xb8E7wu686NMmVF2/p8Z8v0Fjx4wMrzT//i+caHsr1Un2ad+bT4c+ifc+dQlwQYOjdeTZxy 1+8sPAA==
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-12-ardb+git@google.com>
Subject: [PATCH v2 2/8] crypto: arm64/aes-ccm - Keep NEON enabled during
 skcipher walk
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that kernel mode NEON no longer disables preemption, we no longer
have to take care to disable and re-enable use of the NEON when calling
into the skcipher walk API. So just keep it enabled until done.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 22 +++++++++-----------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index c4f14415f5f0..b177ebea7d09 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -182,17 +182,16 @@ static int ccm_encrypt(struct aead_request *req)
 		if (walk.nbytes == walk.total)
 			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-		kernel_neon_end();
-
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
-			if (unlikely(err))
-				return err;
-			if (unlikely(walk.nbytes))
-				kernel_neon_begin();
 		}
 	} while (walk.nbytes);
 
+	kernel_neon_end();
+
+	if (unlikely(err))
+		return err;
+
 	/* copy authtag to end of dst */
 	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
@@ -240,17 +239,16 @@ static int ccm_decrypt(struct aead_request *req)
 		if (walk.nbytes == walk.total)
 			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-		kernel_neon_end();
-
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
-			if (unlikely(err))
-				return err;
-			if (unlikely(walk.nbytes))
-				kernel_neon_begin();
 		}
 	} while (walk.nbytes);
 
+	kernel_neon_end();
+
+	if (unlikely(err))
+		return err;
+
 	/* compare calculated auth tag with the stored one */
 	scatterwalk_map_and_copy(buf, req->src,
 				 req->assoclen + req->cryptlen - authsize,
-- 
2.43.0.381.gb435a96ce8-goog

