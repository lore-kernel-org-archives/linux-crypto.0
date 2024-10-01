Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8591CF7B0;
	Tue,  1 Oct 2024 23:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727825155; cv=none; b=Jhk2SeZpTi/anLZqp6jubnfZK9je2EJdfSNOMTb9e4yJphaAoHids5dI25SIj4epUiZNq51xrDAnoecQ9fvNzqm8NCpStAH8/XAiYcVs0IVdRAyRl094kh2JveBtjNQasBmeItmp4jEmPeE356DRUSKcumjEtEeRo3tRyfJuwec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727825155; c=relaxed/simple;
	bh=ArRz35Yt7ZFFgfkFYLXbuIMfBfmHY/Q182Ohi1Zp3o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfn0nuo0WIuVt/BFfDrxlhc3p4t1R4M0nhBpElnHKfVAXUdsgMvQx1TUqFEjIlEzi58iUfW5lNYabDRhkf1QFzCrsTMmu/3+Whia8Knc5y2u/jtqgcZfDbA6pNwxA4+pmXs2cSlVb5I7ST+LZ9I5V0kSzZqMjpqlLG8JOVreNNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l1QbBcko; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1QbBcko"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71b20ffd809so4608771b3a.0;
        Tue, 01 Oct 2024 16:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727825153; x=1728429953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1dl0UbOAYtW+oGiWzYdokj0qHo7wDE4qgLOCCPNp8yc=;
        b=l1QbBckojdyvYzbuM7GeZ8VfQ64haFiZoqXbNYZVbeiYspVsfAJNvBbaiDhdaw4Ijw
         Ju72eHiPiVLERVip316BQtV0JiyGhw349VggktLlOQepqJYjn8MuTiqpxg504wZG/H9Z
         ICXDOOywpZvezpThxbKh1q8HS8grcfP93Jz8ajYwR8u4idIkiLKqKCXo/GJ91+obBdyk
         TUztJ2ZfERZl4FD5f1/RLzbc0W28sHB0I6ZTt9mguzFvHwD0BuYHwYwiPx20ABqp+vmh
         lsbfAzjrOLkW+SvSMyN5oMARKgSpjS6oGy6F+t8pUe8vpy7i9s+w/ULJE+APdQ97/osh
         3nWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727825153; x=1728429953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1dl0UbOAYtW+oGiWzYdokj0qHo7wDE4qgLOCCPNp8yc=;
        b=Y3zrRK918nBqtxd32EgO4Ulb+5LiJqGnIbm2zzhCR6wXUs/o14hWXz5mZYpWGJ3uE+
         DY1/wmS6NjquDtPF4A6xE4ogsRqxJi7K9C9zgN7FxkmxA9jqo9rrhalBH0R44e5y2nfS
         50DXV6lZMuC1GaZsCuAcupHMkvju5wOFw+IFO6cByrlf/kHgDqkxL+GM/bBQpYzvUC6O
         s5YTyxbnlZWaOXMO3cL+LJ5RvmU7njLJ8wYVxRp4XgcTEe9OBB/lESKAtTNqc8j98tV0
         yCQPc47VxmHRCleFekEflXycZM5xfmjH6qlPDLO+2hAWwQbLWGbeATbShBFLHnOvPvNj
         jJOg==
X-Forwarded-Encrypted: i=1; AJvYcCWrBEIkJc0sWvlVRxp/6GzoRQFV68GNUVIAowzMiiie6c15URGUG4OiezO86BgToD3nlqO+of+dNCx47RE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaLHMRW5O7dk7nLtKd5Ugg5pOd8s+85I7xTwwjyQTPt9mBF7/H
	v10cmKGUg29s+WmgjenXR6qEPPyPF9A+ulkWiWDDlWCP8Dpdz+bCHqtMRW3q
X-Google-Smtp-Source: AGHT+IGdwiKi4+brGE+41TPt+Grt9y/Wi4E/nZjbXQyz8LCkFNHssRNb+gk+ncqBZiTrAP319TOXwA==
X-Received: by 2002:a05:6a00:1496:b0:714:1bce:913a with SMTP id d2e1a72fcca58-71dc5d5312fmr1931972b3a.21.1727825153244;
        Tue, 01 Oct 2024 16:25:53 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26539c5asm8628143b3a.210.2024.10.01.16.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 16:25:52 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/5] crypto: cesa: remove irq_set_affinity_hint
Date: Tue,  1 Oct 2024 16:25:45 -0700
Message-ID: <20241001232547.355947-4-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001232547.355947-1-rosenp@gmail.com>
References: <20241001232547.355947-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is unnecessary as the irqs are devm managed.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 1c90e65c89d8..6098518e136e 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -562,11 +562,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	return 0;
 
 err_cleanup:
-	for (i = 0; i < caps->nengines; i++) {
+	for (i = 0; i < caps->nengines; i++)
 		mv_cesa_put_sram(pdev, i);
-		if (cesa->engines[i].irq > 0)
-			irq_set_affinity_hint(cesa->engines[i].irq, NULL);
-	}
 
 	return ret;
 }
@@ -578,10 +575,8 @@ static void mv_cesa_remove(struct platform_device *pdev)
 
 	mv_cesa_remove_algs(cesa);
 
-	for (i = 0; i < cesa->caps->nengines; i++) {
+	for (i = 0; i < cesa->caps->nengines; i++)
 		mv_cesa_put_sram(pdev, i);
-		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
-	}
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
-- 
2.46.2

