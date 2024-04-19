Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D7C8DD
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 05:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713502969; cv=none; b=ZzGv/VT1bTA3lCaz+eo5AOMlYdyjh2igRc8vgnCH7r7PlRW50Qlxiba9COPLT+zRZ+nhiO5ELKlcyfZ3mu98sjOOjYs0bW7n5XXlsQvkDgrIfqEdLmZaLfId0bkFeO1dbt2Js/T/isFR1cb23B7GiyHTbxDWgCpbQH+ERWwEyfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713502969; c=relaxed/simple;
	bh=u8NwNL1SHVvTlbkB6aviZs3CqGvTcDMVga3X7X1929A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVEdzRKv5x+KI2TVfsd9Ie8WWxtGM63QcqPcqDb7fBfgtfoJMEOJZMRU688Whhn7XlOyRyT3+uyOIm4J1lG6rgePI93VoEBphnrn3cvMyrUf+0uCe6Mtj+9v5FQTWxV/kXq4Aw+f9JtB1SgWSFyjAswlXndDgjbr9Z1eZKwQRuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=SLFL6bgx; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="SLFL6bgx"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 025A288629;
	Fri, 19 Apr 2024 07:02:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1713502963;
	bh=N8/EA3hDMebRjyBpAuXzGXG8aRiiHl6ioFyyZFh37vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLFL6bgxwDc6dhg4rCLT0ldEAeOVv9qTHjcms1mdX6MRdriGgh+6ok37zMH9mwHVO
	 ++/SqflUc+q9vLZVx0G5pI149VR8Jn/0OHzQQHAJDlCzg/RZxJaNiVJwUMaryKR+On
	 RYYe1Q3CYAAF2QM1kZw+7B3PrhIT0bTTZmos4Y1AB7h1yf1Km4jBe0r3JU3DKnluAp
	 6C0uNpCv8Pu85btZAsGFIoAHHUnOybqN0JLjEyvu5k6tJcRRuTYJDTt4RSps1VERNR
	 rRWBTuzqRhRV2hmr5+KkQ7Hi6RQpIRtdotE4HowZ8kEmTkhC84QouRIRvvIRTgnMQP
	 wA3eiSUOfx0EQ==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 2/3] hwrng: stm32 - put IP into RPM suspend on failure
Date: Fri, 19 Apr 2024 07:01:13 +0200
Message-ID: <20240419050201.181041-2-marex@denx.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240419050201.181041-1-marex@denx.de>
References: <20240419050201.181041-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

In case of an irrecoverable failure, put the IP into RPM suspend
to avoid RPM imbalance. I did not trigger this case, but it seems
it should be done based on reading the code.

Fixes: b17bc6eb7c2b ("hwrng: stm32 - rework error handling in stm32_rng_read()")
Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: kernel@dh-electronics.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
---
 drivers/char/hw_random/stm32-rng.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 1cc61ef8ee54c..b6182f86d8a4b 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -220,7 +220,8 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 				if (err && i > RNG_NB_RECOVER_TRIES) {
 					dev_err((struct device *)priv->rng.priv,
 						"Couldn't recover from seed error\n");
-					return -ENOTRECOVERABLE;
+					retval = -ENOTRECOVERABLE;
+					goto exit_rpm;
 				}
 
 				continue;
@@ -238,7 +239,8 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 			if (err && i > RNG_NB_RECOVER_TRIES) {
 				dev_err((struct device *)priv->rng.priv,
 					"Couldn't recover from seed error");
-				return -ENOTRECOVERABLE;
+				retval = -ENOTRECOVERABLE;
+				goto exit_rpm;
 			}
 
 			continue;
@@ -250,6 +252,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
+exit_rpm:
 	pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
 	pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
 
-- 
2.43.0

