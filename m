Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C1D3D45F7
	for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2026 21:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556354; cv=none; b=u5ZexJnlS89/bu3f6wTonwe11iNYWfyinjLFqTkXW3Xz1Vi8H/fJpkLgWZVGVhKVpKg4oRTrumsAqZmEu4a3zvHJYDbILhitAZcQOmguWiL+w7UTBy7iIWh7bMVdtDX/OzgSuKbz+At3lXKEbhmXcOTT7Ckxte3LtFOj4cDTK/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556354; c=relaxed/simple;
	bh=dnpaGTQQCUnJd8SVCrQ8hx7tay7KER/6iMa2evn8Ob0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hEUiyCjqCezCKovnkUONmBaC02/aSh2KW2zibo6fh3vlBKmnd/RDP7dV3CEyn8F9OgVp1zC3k0aAdvurhsj14uJJI5F4brwrW2uJsdZRVOsYjba7n/wua34OR72TkirC3d0PFPTLG5PL25bRH+555Q6UhgWE7JPbPLTTQFjhwV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UEjoj1LR; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEjoj1LR"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso1758946a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2026 14:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788556353; x=1789161153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NCsjELXMOcoA9VCek0qtUTdxrcqWJGzf9e5WVEMS6fg=;
        b=UEjoj1LR0XX1PJJLRsajXZBDIpC2G8UoGhZEWSB+ud/NVah5r1t0O8QyPmoiMgWbiF
         5dOffmzUEUfqmqVsTertvFXaRpEse23u7V9OPhtOSqVMwu6Kuzu8gx6bYCv7yRIUzc6w
         G7llzKTeixKG0rPxg0iITKOgOZGgx7P4P7fiN2RPPcZyxTuhMl3tYAczXGR9UUcjXgWl
         tv3JJ8aeoevi2x+gNaIgGcCiKCDmAT1xYPt4tF/p1gsDFb/mqT++kHxemHRJluwRNzqZ
         plbNrop2Ae85J7WBSCV1O3QbZB7uPAsLE1yZXRpQftqMwmM81+XQVTSaeof8uhJYClza
         AbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556353; x=1789161153;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NCsjELXMOcoA9VCek0qtUTdxrcqWJGzf9e5WVEMS6fg=;
        b=PjNOqlCXFVt/EE6xVzO2flTEwsN2VnbA8R+qjcG3yJ+VXmHCXloIokITZSRjiOU6eW
         A+v9LqR8c/TfslFVJhmdlzILR0yPVHvHafr/msYElq8CpzlTWXXQZZXGk+QdbDnNTRtR
         Mi9QPkJ35mSdZnFp4s+CbYD9bpFLPbG/iRprfOo47g6aeJFdZhg9WfqPVM2CSkq4h2Ew
         IjZJ2fEOpXuD5e4osCsfRqjC6L2rQlzmGJ7NyYuDYmFD6icP8RFiG3Cspj6yTvSdFU5E
         oXEwHLIrtdG9WSIdvnIr8Z8EIOP5orvfQjrXYOaIiD2G/E0FFVy4vvstpMwuXG84f6/4
         WF4A==
X-Gm-Message-State: AFuF++n9I16a9VVmX+GkrJT1LcIKW6mlz+m7HgLP24VcqCHgfpD+rWzE
	CkGvLQ55ZWHW9FK9neQX9ZosFqMNazRq19BTkX0JPr0OIr75yuMCI9WtNmEzXg==
X-Gm-Gg: AYBFou0vq9YC+TRmMW7W2f/vve/QRDsc35k7Sh0NUMzBBwzuOurR0ieyDGV4vBXkLKY
	KVxEfuonbXHwmJ9S0YF8t1BEFe0DWbXJFMyL8aZ6g9Yj8GIGrEl/CF/7lQF8KrXynfXbYbrJmGK
	QZncw5nQ2skURT146DJSvUkjaM70orabIbj7Wfg3vdKco5B/VG4gQrnuFPpsh8zNQjBCLYu82df
	Cpdj2kN2SeZpORwTwgGsxM6+HJ8E+9Wo7EwbUcc3cy3RmUmbOiS9v066dN3T/7PE6gNMppA6+yh
	aG+3ZNdfezNdVjs9qHLpIc/D/yeZoTrQiEoA25DhS1h/f8JNZ7w5JuaAv661dsGfZBmJUPLnfdK
	vaRTodbmUzxSROgPEOFcfeCTKz1lAFjZYsEMI05OyfTp6uJnZ/g2N/obn0C5IvahLECgV4OVO2f
	7qEaQWz0TtTCMmtK+JOOT3viPV/NVfImAWUu1UpENFfW+1wo2V9rZyDbOPqERP5o14VHmEsQUWb
	zT0ZU7ySywCIL6ZAVjWQla6AdyOujmtzRb9u609TL9JltNQo9usDavbLoxzZ1O8epARCiNNTDF6
	acdmMEMBA4UR78ahIPZgNQ6v4G1k4Ao9uArm1g==
X-Received: by 2002:a17:90b:274e:b0:398:b1eb:136c with SMTP id 98e67ed59e1d1-39b2610fe62mr12902336a91.9.1788556352713;
        Fri, 04 Sep 2026 14:12:32 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08bcc081sm12288540a91.6.2026.09.04.14.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 14:12:31 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: talitos: request irq after tasklet_init()
Date: Fri,  4 Sep 2026 14:12:30 -0700
Message-ID: <20260904211230.81963-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The talitos interrupt handlers schedule priv->done_task[] via
tasklet_schedule().  In probe(), talitos_probe_irq() ran before
tasklet_init(), so an interrupt arriving during that window (a shared
IRQ, or a completion pending from an earlier transmission) would
schedule an uninitialized tasklet.

Move talitos_probe_irq() after the tasklet_init() calls so the
tasklets are fully set up before interrupts are enabled.  This matches
remove(), which frees the IRQs before killing the tasklets.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/talitos.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 41a87d7c30a0..da08cf9615c9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3481,10 +3481,6 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
-
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
 			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
@@ -3507,6 +3503,10 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 	}
 
+	err = talitos_probe_irq(ofdev);
+	if (err)
+		goto err_out;
+
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 
 	for (i = 0; i < priv->num_channels; i++) {
-- 
2.55.0

