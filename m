Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5235611CA9;
	Fri, 27 Dec 2024 22:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735338735; cv=none; b=elZ/3YfFmvscYbyj95Z9mTv9eIIyX1B6klUibidrkqdSN41/67QO0G5dg1xcjO1aifl2bwVnA+j4ltREaz4h9H5d8zdI1s+R257bQvFmoKszISsBR27j+OQHljGSMHj8jt7xuYfd2ERkV/d7I+iLFDBnSVddVNc2yA1xjUhWD/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735338735; c=relaxed/simple;
	bh=45HpuVPoOV7QB6aIPf97YkSWOlVcos4dDxR3fj1IOLM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=daZ67hfb911zC5aykU50esXH6OYyGlZZ9bGV0+r3SDty8g2DhuFXSXoxh54sZBiTXEBykUOCYdgOzarMdk8LJq2kCkcSdSRC8o51DXohe/wJGpIqHBwzE2KSgFqn7T3uXEbtiEnnkUJhctAjN1sH4eOscOixS09uw28h2chsBR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=SAbBmIzW; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="SAbBmIzW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1735338727;
	bh=45HpuVPoOV7QB6aIPf97YkSWOlVcos4dDxR3fj1IOLM=;
	h=From:Date:Subject:To:Cc:From;
	b=SAbBmIzWwGxvU8VJHhhAeAf5sdJfiPpkCsJMcv7sAlNhMcsqTkjtAhseWGQ43Ex21
	 fRebU2EBxKmLH/USwIK6+TQr211GY3vGx87xBFfe3jbUJJU8EkiGj6kSunaCN4qVCZ
	 PYlH9jBiBT2eWhIo4FVnvcxCgNVCEGRQJ/o2C2Po=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Fri, 27 Dec 2024 23:32:01 +0100
Subject: [PATCH] padata: fix sysfs store callback check
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241227-padata-store-v1-1-55713a18bced@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIAOAqb2cC/x3MQQqAIBBA0avIrBNSjLKrRIshp5qNikoE4t2Tl
 m/xf4VMiSnDKiokejhz8B1qEHDc6C+S7LpBj9oorWcZ0WFBmUtIJAkPS2gmtaCFnsREJ7//btt
 b+wDX3kXSXgAAAA==
X-Change-ID: 20241227-padata-store-eac9ea4518a9
To: Steffen Klassert <steffen.klassert@secunet.com>, 
 Daniel Jordan <daniel.m.jordan@oracle.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Dan Kruchinin <dkruchinin@acm.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1735338726; l=1048;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=45HpuVPoOV7QB6aIPf97YkSWOlVcos4dDxR3fj1IOLM=;
 b=TNW/eEPs9M78qLB8wF+8ipth7wjjs2HR+hLLTpVrqSUhZvPOmwCKjoNIX0nAw0oC63WzjwYA9
 OJP/ALHlazICw8kbRnzIVDuyzon8rYBt6MdQ/BSB9I2Y0JSyopQvzZH
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

padata_sysfs_store() was copied from padata_sysfs_show() but this check
was not adapted. Today there is no attribute which can fail this
check, but if there is one it may as well be correct.

Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d51bbc76b2279ca3ba51e5d0b0ea528bf0198374..cf63d9bcf4822ea3e8f923c0e11f49ac2197b706 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -970,7 +970,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;

---
base-commit: 8379578b11d5e073792b5db2690faa12effce8e0
change-id: 20241227-padata-store-eac9ea4518a9

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

