Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B23155A53
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145693; cv=none; b=W82n76BTrmFpg9kSsBJgsZl2taX/EdOhkqtxrME4k8xrHAnLJTIk410+uKILriZB9873hQM+D7w2OnzAz1vzwQplvbzIXpkJjNnWLYE6xFgbUFzJvsq/+pIFEd2U2M+7y53xba8z4uwKq8+kZHaLH+FLuKQcQ4TvLYAAq2oDlWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145693; c=relaxed/simple;
	bh=QdZESmhfftlpEVQahcIpjh8FCP+VbYIkQ0nBIND/vjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S3i4Sri3juSTBB4wO+daK3zgdzGL6R5o4N1suMI81n2+FU90GWnCuIubH/hxK3RTCzoXGGRfVFRgQ82rNijwoNni2HKIKI1Cj1ViwrROZeBVN4HRJleTyYJg+diFSbfGQm7tlZm6yN3LDSGk0ezXS4pqQbWj53A6dfhfJ9ywwUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=puqYrpH/; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="puqYrpH/"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 0854088246;
	Fri, 31 May 2024 10:54:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1717145684;
	bh=ywmgWnjL30EYt/MuxhcwoOkfzGrfhbBZytmaTjE4Urk=;
	h=From:To:Cc:Subject:Date:From;
	b=puqYrpH/xjOIMgIMVamSDiZta2T3W48g2YC3oYqo/lcXAHkyOYsW1hOvZ44AZYXUa
	 ubDkL58J1in5SR8mo3W+oc0QDdMc3WiBR1ArQqUTZ4RblKrjThPVZxZSml/RmFFk3S
	 tMDtP4vtRtlu1K6ZnD/zmDMzQlxiIvFpwzbnNevQaEgxmvJofiwjEHWqDRprUs7kSQ
	 nrgDHGiBLo5qWtxWfbGav8HboIT3QcR70+qCQeS+dXpVoObx+S/sMo293Mk5c+ao/1
	 SpViP2OMIhngjNPvu4lfVDi/hhoF2ZiIU3i7zhY4ggKh1ZaFsXGgRmdhWJxcMVlvTB
	 MvkzgZc/sFYsA==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v3 1/2] hwrng: stm32 - use pm_runtime_resume_and_get()
Date: Fri, 31 May 2024 10:53:22 +0200
Message-ID: <20240531085414.42529-1-marex@denx.de>
X-Mailer: git-send-email 2.43.0
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

include/linux/pm_runtime.h pm_runtime_get_sync() description suggests to
... consider using pm_runtime_resume_and_get() instead of it, especially
if its return value is checked by the caller, as this is likely to result
in cleaner code.

This is indeed better, switch to pm_runtime_resume_and_get() which
correctly suspends the device again in case of failure. Also add error
checking into the RNG driver in case pm_runtime_resume_and_get() does
fail, which is currently not done, and it does detect sporadic -EACCES
error return after resume, which would otherwise lead to a hang due to
register access on un-resumed hardware. Now the read simply errors out
and the system does not hang.

Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: kernel@dh-electronics.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
---
V2: Add AB from Gatien
V3: No change
---
 drivers/char/hw_random/stm32-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 0e903d6e22e30..6dec4adc49853 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -187,7 +187,9 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	int retval = 0, err = 0;
 	u32 sr;
 
-	pm_runtime_get_sync((struct device *) priv->rng.priv);
+	retval = pm_runtime_resume_and_get((struct device *)priv->rng.priv);
+	if (retval)
+		return retval;
 
 	if (readl_relaxed(priv->base + RNG_SR) & RNG_SR_SEIS)
 		stm32_rng_conceal_seed_error(rng);
-- 
2.43.0

