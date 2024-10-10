Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96C919B3CB;
	Thu, 10 Oct 2024 19:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589522; cv=none; b=njvt2uAfH2d9aMDtaR0mTGEXelljAziZeRsi74anB3eEzSICkN0qYFXIaJ3mGdvXzHNZIg9G8M+St0myEJd7BBSNae5iw+h0Km7ZIM+zXZurnSxKUC9iJIhdi87+PpjczK+q0TB+Nqng8Ube17pDk0fE6bhOSCvTO4tGs4xNP7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589522; c=relaxed/simple;
	bh=h3X3S+eYf+25bscoXd9m+jvk8TX0AM7JXgW0XN0jifA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CF9Ob8UvZu4N1a8BEYVXYtx2P7Dcx5Yy917xIxtZb6xI/bSzP4SsDVBdY7lsxo75zHnOri8KSAV7F3OIIPPgRWSYjyi+u3dyaA4OzcFo/8yY6aTbqf4dQcl2NHBJI7ohuFqCAKnqtAPQH9cKTWuwFXn/tVAopym1DMj/fC6a+UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=azbCcRwr; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="azbCcRwr"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e5c6dc6eb4so456216b6e.0;
        Thu, 10 Oct 2024 12:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589520; x=1729194320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x7VAzWUyrabc25ojdM47fww1+LlKfxq5Zs/VBgo4m1g=;
        b=azbCcRwrdEfnfdSLM9Bmkt51iipqO61LWG03E+JX19Ajjdtier6YnL7VRI8ugKtO0N
         fNOcGXy2Ahxre67536P0ktgFUn3xcfmuUYMM7TV6Oca8Nb78IPnVIikLnbEDgh+EP+gf
         ojaHp9eoXmznEZ+NibXxoEvZ7QjvAQcLCxZLUKyEoP/KI4u0fz8Jhr3Gg4oI6SnXEfvM
         LBtaLw6/19f+QwFeAVHNzIJIJmVEVdNOFnXiE699okhirT/4Ip/ug0zeHhObXMn/yWQ1
         q+pM6yIKxm9Fv+eSTFom9QPEWA2npoogf8h2CeubTLWQ3RtgrOQVFBJJ0y0tunP0UkUm
         b1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589520; x=1729194320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x7VAzWUyrabc25ojdM47fww1+LlKfxq5Zs/VBgo4m1g=;
        b=k+YnHg6Do0wgSwLlxptz/lXCSKDh6tAAxAEXNTd5Whjuyg4behnPhuLBhThRIRdmsI
         JqrO07SBgykACEiOlJKEz2+BmVr/KDv+gyH6XVFy1LTe+80lXDinJ8ITZaAnMC4vW8qe
         jrQliDWGWqMLZM55JviIVQpOTvyPh/ha3spvbZMvwcnNp6fxJ6i1ikNJsgNsQ51irhL8
         376/iPcuo0vqmvm6sKSGZH5YpiadLsGDRR2WL1OVsxMEtBfSOUsjY+JVCgQvi06MQDIO
         N+rhiNyR2Yf7gip5n13wthRR1++gnxgFITDqFVNmK2B4k1FPFbWF0G7rA2/tBLrnf6MV
         5nyw==
X-Forwarded-Encrypted: i=1; AJvYcCXV9wWIF/S2+m55BMU+pMuEotx2TVUgCFeue7LBtWEtxhVgWX1GKGxQ7b8nKaXFriT5wFyE4ipXxdfG4ac=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTRDNyvnSSybxRJjGy3XcHhkaFPUUc1yM8727WEfIieznzMVzw
	pMwKXU2VM4IyoGuFoe/7VFzGkjd0uoL6oqgervFZbJC2u+rOiRCai3iFWxq4
X-Google-Smtp-Source: AGHT+IEBWdfgROdNDZOxuGM0IP82uynBCf/Se4zOMgMRv4mykVwPCEMZySZUE6I2/jCuQNwEsk/cGg==
X-Received: by 2002:a05:6808:2221:b0:3e4:45c9:ea02 with SMTP id 5614622812f47-3e5c90d735fmr216790b6e.18.1728589519741;
        Thu, 10 Oct 2024 12:45:19 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea448fe50csm1374762a12.29.2024.10.10.12.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:45:19 -0700 (PDT)
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
Subject: [PATCHv2 0/5] cesa: small cleanups
Date: Thu, 10 Oct 2024 12:45:12 -0700
Message-ID: <20241010194517.18635-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mostly increased devm usage and added COMPILE_TEST.

v2: fix wrong returns in clk_get conversions

Rosen Penev (5):
  crypto: cesa: add COMPILE_TEST
  crypto: cesa: use enabled variants for clk_get
  crypto: cesa: remove irq_set_affinity_hint
  crypto: cesa: move loop to mv_cesa_put_sram
  crypto: cesa: use devm_platform_get_and_ioremap_resource

 drivers/crypto/marvell/Kconfig     |  2 +-
 drivers/crypto/marvell/cesa/cesa.c | 79 ++++++++++--------------------
 2 files changed, 28 insertions(+), 53 deletions(-)

-- 
2.46.2

