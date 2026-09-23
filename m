Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A7854EEC3
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176802; cv=none; b=Kiij/6LDwlE4QUZEVWr5xUbTtUX0baNpNmxx/FM/ooswFYLCE8yGe1RFjgWUZdn5Nm0+bPa9EFj5EWI4hn0SaeGgVUo9+Nwa5XwTKssEgTjZ/D8nL61wbvjQYGtyfh1feWMcHu1M8PAFQ3eAdtF0wrR8cZ5wz9LEVy87yjQC56s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176802; c=relaxed/simple;
	bh=RhmXl3o9AEJHf4cRc6Z6Vr8c6k6nCxAjUcagIiCZW6s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gG5ZuLdiPbJRrsjLUmFD8TN4PSup3vmy66noNe+IkM/T2ZTe0yBjWn7bkKBXskRS6qdNWAJsumehR5FACPFv41Q7Nly5BHGJ0g23RvBrIoGuYs2yW8h7VEW5dwvhpo5C/dUKLeLeUuxG+apWVthkQJZ+UyujeBJeUMp20F918k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=BVTdJpcD; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="BVTdJpcD"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id D16CE4E41048
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 15:19:58 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A647860580;
	Wed, 23 Sep 2026 15:19:58 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 058C1103293A6;
	Wed, 23 Sep 2026 17:19:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790176797; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=LnQXfNYZOYzL4bIDkcswTsJNPsN8lEiy6QszH3hhbpE=;
	b=BVTdJpcDkgdOkgV4fsz3+pnCsl01wXYnSfzqpYzD9JuutEWUfinYSOGf3WalZXddoE+yb7
	sx19sby0G8etK5uwumzZu5mZw9fNGL9Tw57mYbRuHjyb2Sa83s0qzRcXCnOKr/CuMTUYmn
	L2DS1znRPwhTphkpmaRIdabXikhjQniQ7k8Z0oJX7BpRjr0se9JAUFlyc1MnnQpNhK/21w
	Y+6I9c2PH9/89fqRljzKnDklE4D+R7YODjmfJmoXX755tM8KTMgbR12Eb8aCFiblvwbdRx
	3JyW1EC0KrOa160wUo0AUqF3nj12T71HPtXX+A2J57D6SRLV8btGm+zQZYDJqQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 23 Sep 2026 17:18:56 +0200
Subject: [PATCH v7 20/20] MAINTAINERS: add entry for talitos driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-7-3-rc2_talitos_cleanup-v7-20-9a45261fc097@bootlin.com>
References: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
In-Reply-To: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790176746; l=754;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=RhmXl3o9AEJHf4cRc6Z6Vr8c6k6nCxAjUcagIiCZW6s=;
 b=dPhrLtZh94g1Ojcbi3Kd0bFbwdJU3/D5ytj9nZ1a71tguZOjlzTTr8KALRvuh63AHMqd2XR0I
 KT9PufwvyphCvW1R89xxIw0TSL7izLk5R+UzJlVBZbh+bf/yFZ3VsDP
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

An entry is missing for the Talitos crypto driver.
Add it with myself as maintainer as I have worked on this crypto h/w
device.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6215fcb07770..c2f3ac4a572f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26639,6 +26639,12 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/system76_acpi.c
 
+TALITOS CRYPTO DRIVER
+M:	Paul Louvel <paul.louvel@bootlin.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/talitos/*
+
 TASKSTATS STATISTICS INTERFACE
 M:	Balbir Singh <bsingharora@gmail.com>
 S:	Maintained

-- 
2.55.0

