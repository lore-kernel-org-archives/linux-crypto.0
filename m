Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922775;
	b=w77oUJrffE0kW9keli3JfjkVg3b+UxUb2XipwwfCa5GEk9XTWfKZCzkXyes69XLbMGl8
	 SdxIay0NVAgdsvgg1kAJY4nMRJP9sn8cUouAkWJ0VI/5onxEPVVfRNzbI5CEXP7TDyu7V
	 cnsKcfV+tPxiv+umsgP8XNQeNhij1skOn69mYKWJEjXKA5wx+WtunShG6U0E1FPOFxx53
	 Y35/zjoTKjslC2SLAko7aFv9nbu7WoeF5eFKWgXCEPHomGYC+fWLt9Caze6Rjb/m1pM69
	 matsaJo73TDNj6Sa3J7jd/s3bgg0Jt+LeBYxUwU5xxJ/IijSPjv7CRu2U0hUBnfxmiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922775;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=qLTpOuSUgJgyz5rC4zL16SxOL/r7JctEcaWYeU1vdrc=;
	b=rJ7laS6hV+UDDG8UupnfNO1060Wcz8ORiPv2LRL8TB8ATd8Z33Uwcr5dvev25H5msFA+
	 w8fPBbI7tUiM6du/bcmuZXhHVmeuWfu/f8PN2hdIGm9BmttNKNPQZB8/gDLy1tLJn9dR5
	 PptCy4FHAciWqncnV1RzJAF8lKNqwOOsnxXQ8aU8QyM5pddqqbO9rRx4HBGmFQlF0IenF
	 ktFmAQEr88qMWkS2uIQ/veIKGR0t2hL4fOHzSoA1DrktUS0d5sKAiOe4wj1ORtGNO8jEi
	 /VQZO46xrTii/XLwalEqJ69waev/9EbAsj1O+ud3ndTlXnNqGE9ar8kJ96vJYRA6q8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dC+ilGlb;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B43606A32A;
	Tue, 17 Nov 2026 13:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78B43606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dC+ilGlb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=qL
	TpOuSUgJgyz5rC4zL16SxOL/r7JctEcaWYeU1vdrc=; b=dC+ilGlb5kyHCSba7t
	m2EWHs1KXzds0YNiMeAGGQrrtk+kfxreF3veEm2MZh+u+/qq02m4pqIUQNLuIHZ/
	dD+a7IpnWurWe52cIx3r4dMfr2/5NArztGQ2b3fbmBMDyuMP91YZuWY+IJsl+P9v
	QfkVJuaFEbzjhW1Qo240cFAHE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3H5vmWPxqUY4XIQ--.65082S2;
	Tue, 17 Nov 2026 21:38:47 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: olivia@selenic.com,
	herbert@gondor.apana.org.au,
	kees+treewide@kernel.org,
	sgoutham@marvell.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH] hwrng: cavium - Fix PF register mapping leak on probe failure
Date: Tue, 17 Nov 2026 21:38:44 +0800
Message-Id: <20261117133844.1410587-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
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
X-CM-TRANSID:_____wD3H5vmWPxqUY4XIQ--.65082S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr4rZrWkuF4UKFWDZF1kZrb_yoWfuwcEvr
	4j9FyxuFn5Gr17Gw15CrWFv3y0grn8ur4Sgrn2qa4fZ34fZr4UKr1kZrn5X34UWrWDGF98
	KryDKr42kr9rCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRA73kUUUUUU==
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7Qcpl2r8WOcqWAAA3P

cavium_map_pf_regs() maps the PF registers with ioremap(), but the
mapping is not released if devm_hwrng_register() fails. Call iounmap()
before returning the registration error.

Fixes: 680efb33546b ("hwrng: cavium - Check health status while reading random data")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/char/hw_random/cavium-rng-vf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
index 14eb74a70f89..e0f9ce01a896 100644
--- a/drivers/char/hw_random/cavium-rng-vf.c
+++ b/drivers/char/hw_random/cavium-rng-vf.c
@@ -236,6 +236,7 @@ static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
 	ret = devm_hwrng_register(&pdev->dev, &rng->ops);
 	if (ret) {
 		dev_err(&pdev->dev, "Error registering device as HWRNG.\n");
+		iounmap(rng->pf_regbase);
 		return ret;
 	}
 
-- 
2.25.1

