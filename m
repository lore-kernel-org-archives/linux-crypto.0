Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512B432AACA
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592164; cv=none; b=S4ZhBQxhdbuhKKSNScB2NyT8/0UTHQ0M1iDYoQ+ius6nEBGZM8RsGF+z1BmdzUcDNXNzlsLo+NRPFMCzzVTc9bBzuq9wwCSfKgXZgZAHf+nfXIUlDBCs0U0kmSheR45/Zrm2waGBl5o7P89n273qDXRhdliqSqklvOi7PJ1D3y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592164; c=relaxed/simple;
	bh=gAmheY3BdyOTd5f22skV+ygZFPkYkHLxZlz8qlPKzQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RCOBGoWoCnHu/B1iVctExHZb7K4z+f9LjyIggFl7Uiv9+bqzjeTpYPyYnyUtLBkgZ4yVs4M2WrJmSf9aEow9yZbju5WL/8OsKaqzi2z9fmVdDLvoRIWNNl4HA5SUk+symF3Pa1qe4bU/fzPB1ZqLUipzL60A/p6QThhKKi4lRVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=GD/J9RgG; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="GD/J9RgG"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsp-006ypK-Qw; Wed, 19 Nov 2025 23:42:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=RPjl5M3K/tkNOzGdTBgvu8hHZsDSFSPtP5rvQki70cA=; b=GD/J9RgGPwKDAchM9K8Mxz8ffi
	mtY0CaYUIrh/Ik1edJxi7EmD/h/sZht0bKV8HeKd6QWw8gGmblgT1oWnqhgy90zVRkKouqi3pm+tm
	4azjYZ+F3G3ldL7OFIE7zsurowGZ05EEQskQBYZGv845ZoDx6tcJbtxlFDNXmZtotdhm5XOVwf/1T
	fMlHCG2SmhkRI0yHiCboRkphAaFbJ/LUXGZBLcCcfZheI4eNii6frmUUGNAAXRmti4IJyGlcEOW5v
	HqrF90FDfWB7pQvMMAtmgcpHvXkuQUQ2S60r0eh56Br8Ls5+dPQog2p6j6mpVXbuWWXDPic/k4Cft
	F2rLHYmQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsp-00084x-A3; Wed, 19 Nov 2025 23:42:39 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsb-00Fos6-38; Wed, 19 Nov 2025 23:42:25 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 14/44] drivers/char/hw_random: use min3() instead of nested min_t()
Date: Wed, 19 Nov 2025 22:41:10 +0000
Message-Id: <20251119224140.8616-15-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

min_t(u16, a, b) is likely to discard significant bits.
Replace:
	min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
with:
	min3(default_quality, 1024, rng->quality ?: 1024);

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 018316f54621..74c8eb1d9048 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -542,7 +542,7 @@ int hwrng_register(struct hwrng *rng)
 	init_completion(&rng->dying);
 
 	/* Adjust quality field to always have a proper value */
-	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
+	rng->quality = min3(default_quality, 1024, rng->quality ?: 1024);
 
 	if (!current_rng ||
 	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
-- 
2.39.5

