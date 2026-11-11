Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794388035;
	b=FjBKFe6iA5mhM8IzwMwAtmfdoyFxoEMxBC0rHyl8S4aMVKj++ls7W1Shfs4Yu+VG43W2
	 +9KAUQbDNBuMv7+09Wlxf3kgSunZ8OFOwXOQ6FATQ0nEBBWMQkZ5Zv1c6akuiwGzJnDAY
	 r6f3wYWbg9sOhsGHqsxI2TP33RzY/XpCOiiAVUjTDXxDcWIIy0uT6lCDQVEz77XsKjUX0
	 uEZw8TyWYRK4/1Zx6ZaUVfx261sXSOz/U097/St8GoJfaTNQH3FgpETAepb9WcXNusXEu
	 3xftwOY04Oks7anlpTwxn5cNagK4/se8LNLIi5hywN/W/klgs2S2nyX1e2MsxlNxX5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794388035;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7bWqdfYQDOOZNT4u6upFk/9Ul12VxKdb2Ez+LjvVceE=;
	b=tOGi1PhS2UZOIUt9Ctg8QLr93fwdFiiuf6cwI2DglMa2Xa3dnXTOP28wcKmpXpTKWn0V
	 q2rWKCcQzUuo2TNp7wIEuuAwmmAn1Nm1EZ1/XNDvUeuVIUHfIXohHy4eBr6oGysk+5YkL
	 B/Zan1A107noKOTfI7WvkLs9JlHhOpJt+J03XMM8gZyo+0OB5rcf1nTTCAghPCa6MwXcN
	 +DZg/Jf4+pY7JeRnNPp0SRaHTFV9CmG7/X/lN+s0ra5xyzNORjuysYgRIVvet9GPUoBRA
	 v29JO/Zbc7jLDtb4DKHurFh9YQ/On21AXALRxmZPPVoYahklCvJYxkX8xN+z4YMH3iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=bAvFYd75;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25562606A323;
	Wed, 11 Nov 2026 09:07:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25562606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=bAvFYd75
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=bAvFYd754U4txyH4Tl7Ug4uuL2zC8imMiyUeAukcKMwtwIPOoTHizs1IN+uSyh1EKTbW/2UXQXmY7
	 9xMfi3HgTjabL7Z1Iw5sFyikNgWk+kj292R3szKEQXGSQZDNjb41HvhFx3lwUwZjX0PBvEAF3Kt6Ta
	 QrgiaHM0rcAU/JeU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16af43040d39-b320e;
	Wed, 11 Nov 2026 17:07:13 +0800 (CST)
X-RM-TRANSID:2ee16af43040d39-b320e
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHB-W5100250 (unknown[36.137.216.21])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66af4303a7e7-d683f;
	Wed, 11 Nov 2026 17:07:13 +0800 (CST)
X-RM-TRANSID:2ee66af4303a7e7-d683f
From: Gu Bin <gubin@cmss.chinamobile.com>
To: sean.wang@mediatek.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] hwrng: mtk - runtime PM fixes
Date: Wed, 11 Nov 2026 17:06:57 +0800
Message-ID: <20261111090704.1699-1-gubin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
References: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sashiko review of v1 pointed out a pre-existing ordering problem:
mtk_rng_probe() registers the RNG before enabling runtime PM, so
mtk_rng_read() can run while runtime PM is disabled - both in the
probe window (hwrng_register() starts the fillfn kthread right away)
and on unbind (the devres teardown disables runtime PM before the RNG
is unregistered). Patch 2 moves the drvdata assignment and the
runtime PM setup above the registration, which closes both windows.
Patch 1 is unchanged.

Gu Bin (2):
  hwrng: mtk - use pm_runtime_resume_and_get() in mtk_rng_read()
  hwrng: mtk - enable runtime PM before registering the RNG

 drivers/char/hw_random/mtk-rng.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

-- 
2.55.0.windows.3


