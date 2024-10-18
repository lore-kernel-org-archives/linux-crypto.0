Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B7520E312;
	Fri, 18 Oct 2024 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729271033; cv=none; b=pKrVjabIsrVSaAbb8OiCx5irIgz9RSSCC9kZZ7vnPlEBYCih67gBHz9icDfwBqdH4MS0JadgI9LUNg2UOWcRhnI1ZCSse0vyNyZeTITAyJ0R/18ddJ3zVtRVtWes0mJwQXp3si8mg7aL3knMQQtBqvJflc56+ZmuMCOB1G7Gu3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729271033; c=relaxed/simple;
	bh=af4nOxEDaAlJUk79W7/JLGCDf5ANyyNU0ZTLqOFFHlA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=dsaUdal631TnuaUNmUS85SuI4edyGOAw8rcJcASFx+3yqqkb0hkr0L6bOc+x6yCMwrnogXTuQHREdAEPsiyjzCYyouHekMvTez6IZ6A6IElFIe9Thx2IMOM0mwHxUvYzUscl7XiWjvh8a2KoZ3Yt35SnqrhSLptF+7DaBsXC0p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IT9DkDV9; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IT9DkDV9"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-37d43a9bc03so1620421f8f.2;
        Fri, 18 Oct 2024 10:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729271030; x=1729875830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SfKZpln6Wwby+6k34LZ6rWt4fai/cejuJdZ/Dg/sby4=;
        b=IT9DkDV9tSfdK46VKtt+pLgpYBxtKVcgeLTtm83tkRFY9WI2i7joBTSs67GtdIxZ26
         jqAjyyHY/NxfqFghvFDmPtpZFgxmlvt+5HJpfkyAMLBUuUNS+3nTu2/XJ9IiEOwFHEaO
         AYpLVcCc/ahPb0GCOExKbkIE+CzBo6ef06FBgXI5ivzkhZU3lJmksqU/C5MrNSKeizx8
         3UgrZaLwmui0Dtmh/mkTkYfyUS6JrjnasqZsUsYAmGVlnEvnIJk/aPvvpDBeJI9DAeQR
         ORupYAh9NmHrVGFBfJvh4PnOsdJxyzA3R9ndH+hNFYilPECqKs5ZldlCWWj5sahkBsvE
         XaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729271030; x=1729875830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfKZpln6Wwby+6k34LZ6rWt4fai/cejuJdZ/Dg/sby4=;
        b=vqpICrlXDQ6qQ5ihNFmJLAnc4vohKf8Pvyyfmku/csi0mWp1a6d2C0P5FPPxXmc7Vp
         SAEFVR1QjLx35es2kg3cVrAh/E0Cd3avWeb5xfoo+bJoVl83ku4iOb0/qfdfz+jPx0ch
         Yo+h+B9gxaXRRoN4pRR+PtsDEQslbnNuNxF119J9QstsPxUH4/Ysbm5OXsKmRxzInuUE
         dTLdgmN2fpJivtz82WbBbZ61sU1qMYmwHz5Nad4fI9ZDjISuxvCMTzOaA5cd1gfCKcGE
         K2KTAE+Xehq7jEDVJqQ89fR576NKS2M9ig4BEgiiHyAUC3OvnsJKaGU44GClbsta7BYB
         r/Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUhAsLWwc1fTp+OzA+PaisrakrvZgxnXCaKaa4+LlrI2FyIeLQNeGV6bDQzKbZVp7SsarqzocauNyM96jU=@vger.kernel.org, AJvYcCWtjDLROj3dcLidzIrDrf2AUbhjZPNe9zBY4nym1YyUF3fUoalyZhJZGxJRMwoCVMoqDpv+UNU3/1+MM/Ds@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6YEgwE12UqSWkHUSTiFdVB6WcQAgm8k4KOp9uzqtMNOsblhJb
	RJrXLtUJ8ElziptYL3XdGHJQeLIA2BJK+xsZt+L6Se8+qGFGD14S
X-Google-Smtp-Source: AGHT+IHh24BwjL+H2O9TSvYfQkICv7T8oN8MvPb7afjAbBO+kBCCjFPjdmIU6JcBFnB4oJsH1nayAw==
X-Received: by 2002:a05:6000:1181:b0:37d:5274:7878 with SMTP id ffacd0b85a97d-37eab6ee5afmr1740865f8f.38.1729271028219;
        Fri, 18 Oct 2024 10:03:48 -0700 (PDT)
Received: from localhost ([194.120.133.34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ecf0ed341sm2406051f8f.72.2024.10.18.10.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 10:03:47 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: George Cherian <gcherian@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	David Daney <david.daney@cavium.com>,
	linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] crypto: cavium: Fix inverted logic on timeout end check
Date: Fri, 18 Oct 2024 18:03:47 +0100
Message-Id: <20241018170347.647896-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Currently the timeout check will immediately break out of the
while loop because timeout-- is always true on the first
iteration because timeout was initialized to 100. The check
is inverted, it should exit when timeout is zero. Fix this
by adding the missing ! operator.

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 6872ac344001..48f878460f41 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -44,7 +44,7 @@ static void cpt_disable_cores(struct cpt_device *cpt, u64 coremask,
 		dev_err(dev, "Cores still busy %llx", coremask);
 		grp = cpt_read_csr64(cpt->reg_base,
 				     CPTX_PF_EXEC_BUSY(0));
-		if (timeout--)
+		if (!timeout--)
 			break;
 
 		udelay(CSR_DELAY);
-- 
2.39.5

