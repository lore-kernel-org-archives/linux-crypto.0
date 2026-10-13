Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6ED5013DF;
	Tue, 13 Oct 2026 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897164; cv=none; b=l5Dnc4xyliq3xHGgXvDSLhhKoQmj7zVm/v0uzkx+g1ztKie6hLUN/uEYzC+IAE+P65U5Wz0com9y6fREqw1mnSdGQpi4A0FhrWxSOqjH/h+lynhZIOogyr7JnYVG7d/oCI4KOovpv82Sno98q6uxYyZ+PVfbgowMUOLNuzjUKRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897164; c=relaxed/simple;
	bh=b5p1q+0J54ocTEWb+YfhJccKxVz78gi5tobwaD9A1z4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tu1gHQc7YFeIenARvtYHA8+J16fRXTb8RCzeAUbmbMr0ecEel5/opZ9pG2f26cCIQJOIUwBkYNuHNLAKMfWTu6R2gy3Rla9onfPysbDI5NZrG6iohrSD30v9p0vxY94abOUgqLo8ingEZ9o9HmPrNC0zqjx7iZJ9O36apKMdhbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=127Cbu8V; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="127Cbu8V"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 0B39D1A1216;
	Tue, 13 Oct 2026 13:12:42 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D493960362;
	Tue, 13 Oct 2026 13:12:41 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D500911D713A1;
	Tue, 13 Oct 2026 15:12:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897161; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=FnEF8ehWhMJ7ztQYCLvo8Ohqd/+wtZvw0KmSBPYr1Mw=;
	b=127Cbu8V+MBf905Tl8cTsUzcbwcNQBHDcy5Gainjgis4jzzjcMOM7JlUGZROEK2ZCBtntE
	xysr9AmWD0mJHBM6oKyTw5ywZHwzOY9UxrQ/j73Vt0DFoCKcqgr9V9wOZkPdej7aBbEuKd
	9GH7GVcZBMVrhwV3oLYY8FfzDa3pFqc9qWVjirPhQQV3YxaGJyyq16ep7jxmRzDwSjrlZf
	OXHgDOiUZHg0dXQCEaT0i/6hPz+OqEJFH7bHM2LwgkvVzpXof3x3aKVN6vjY5kJk4LLJcz
	Wu+QV+0yOsD7lhw0JUf0eaqaWH8ZWNMH1NHS+7LCT4Y6qkNALvfxaPF/p3fDgg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:46 +0200
Subject: [PATCH v8 20/20] MAINTAINERS: add entry for talitos driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-20-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=754;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=b5p1q+0J54ocTEWb+YfhJccKxVz78gi5tobwaD9A1z4=;
 b=fs9SnT6c97iGHBVwoxyGJfnesz+KeeMi4OqJic1qbTF5CUrKbKgt7ETzcDBSuyelEh11ho0af
 QlsarHqiLriA+x+jYyd93fAl4ypv1NOp3PQBXMe5WZ4iPBLRRdPmiSG
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
2.56.0

