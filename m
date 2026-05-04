Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5F53DE459
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777908278; cv=none; b=a2hva1oSiSYbEd83KapM7uBQktG4wRiiYu8yJXcAQRePL+kqQ/iu1FFEW67kk+WxfgYl4EY0fGM06I0K4t/Yl5r3O71FoA+91pkZwCNmC2DTuJmdQdVXrW82AsBT1D9v/KwzaFYXMJ7cSKo84Y9bG0UgpI6hkwMzVXaNMVZfIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777908278; c=relaxed/simple;
	bh=mBTCRfmyLiiqDTNNeCwkkG8BW2ePxsRS+eMQ6c/jyEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pAn3Io28XggfNAI6TyQtWTWT2YncVkW8zDlbYYvO+/rL1Kn8GpraLdiY91gzeVkGkoqFu7UOVGt7JX++wdWmX9LO0OAXTpyhITa2rpROAeeoK8g5z35qa6AgqCQxDJKn+NymlPqXhgCz1tqensPZgZKkbu8GGckZ+XGW1p8zXPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b=Iw/Stqm/; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b="Iw/Stqm/"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-44c4cc7c1cfso1351667f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 08:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777908274; x=1778513074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s5L1gyrAMclmWaElGNBFaKeIDh6nrUu9GFr6ldCV0Kk=;
        b=Iw/Stqm/HlAsmJh1EkR4ve5UrnZsdbtDKiy/nujoPIyB3lIbYQo51V3nJxggAUbylr
         QZMwxu8Jyxztm0c4Utd4s7OCsBlEX5fuVa4f2tNcKqTrbofGpLMmwRUazJK4kRfQTRZX
         w0jc1k3rL8EaGNim976QE4/BKqz3ktHHs7fb3foxAe3NulCf209dTLMPTJ/EF4XyLQOe
         khQiVM8F82GHcu0jveCFO3QvmxQx3DSg9IpqaR5IcVwV93TFU3hKkbB8oebGQo+6SboS
         JGxleZy5F+KD4NO0yRtlX/Rh5bs4OxPgkR64NcnhECyysmKRtfcvbJzdz92FjSiddRUe
         hk0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777908274; x=1778513074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s5L1gyrAMclmWaElGNBFaKeIDh6nrUu9GFr6ldCV0Kk=;
        b=NC93fXt9wg5cDag95FjpeImozdHR3qyWL/VKN7NL9aLPVKGat1blreYM5BbZS8Rv04
         QWdpO0DgKef3hNPPhky6/GYO7NfWNX8KbhMsTJS17/g1x29oukfj7IEkH9tHfXm7e0kT
         R/tPn9u1QUcGnIBvmMTPTy3IVleW1aTKjKyKMpOeYjt3zDNYGDWo/XhCR41m1VLjavg1
         tC+SOfMigpqsD8yQs7097Grqt0wsLGaeS6eJ8VBt5wFpQVfRFqz8ZTomM+M0U3vHd/4M
         zCl3/njzKnOeZ0URDwKMYq0PV9xYbG1lZRjNOBzV0VZeb+JmKI+LmKoCTJqD3CMqvV5m
         m8Sg==
X-Forwarded-Encrypted: i=1; AFNElJ8k4KR/t2X3awH52ctuCwDxoAtjcb4f1Xi7yE4bFGt8osN9qjSotxzyNSZa+x8RMLYvK8f+Rk/joABkxsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPx3+TJSBgDUQyJBnTGdMnmClfhZndTSejb0BHGI4rfuRzOzUa
	O2dtMcQL5Q0DQsg/Hb0nyNY8WAWLQ2JVYk81ha455UA7w8VETXvtHJB6smN+qR9uArMQzIxtguH
	ybODL
X-Gm-Gg: AeBDietm5ebRs3JiLYPR1SdzSXhxQG68AyEIY5yHkDN2V92dmMkf25YBfnFiSk5ceog
	bpTqoFRPPIEt5xPwAB3N4HbAlgyFKLI7DQdHljDr1FuaUQ72XlYzKDeKP+GEws6fKRDohNQnb79
	kwYUUevv2Q0XESrvUMKaU/pRNB2I8UcIqiwc05hHbYdDGjftFBW3ccLeq7RY15o2g3E6lENwxFQ
	qMQpEktWoq1dhK28OACmoPccVio06tc0G7kqZeR4Al3z1I6UzheTniD3TVpaBHy3+r1hmEftb90
	Qk4PIKPsDtAaEKaitMfSVvQYyW5z4oyZ7BRjBiULreXztvMNj2+4ZPLZq7+2BH57hMCCClnikYf
	r6qrf7W14lnGqqDHzyVRWoAxbPToZXncal6tGADtgkP3fl3nr0ahbH+Pc1yI9AA0Jr9LdNtlpe4
	n+RjeeXM3A4/aWw8XZRJVGvBLZv9u29hHkdrPt/r6Cd0XzF/qTKfSZak4aJTKFVEUTs0m4bpXh/
	idahck2drB7XiaWgAwiaaFY6g==
X-Received: by 2002:a05:6000:4304:b0:43b:8858:1146 with SMTP id ffacd0b85a97d-44bb62073b9mr18108417f8f.41.1777908274234;
        Mon, 04 May 2026 08:24:34 -0700 (PDT)
Received: from localhost (p200300f65f114e08197264a4bf9e813f.dip0.t-ipconnect.de. [2003:f6:5f11:4e08:1972:64a4:bf9e:813f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-44a8ea7cf6asm27113524f8f.8.2026.05.04.08.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 08:24:33 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Markus Schneider-Pargmann <msp@baylibre.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp - Define pci_device_ids using named initializers
Date: Mon,  4 May 2026 17:24:21 +0200
Message-ID: <20260504152421.2147027-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3557; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=mBTCRfmyLiiqDTNNeCwkkG8BW2ePxsRS+eMQ6c/jyEU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBp+LolDzRpK8wRwL1vSjXJsiuXKSCqvw6iQQJvz 6rwOs1vxx2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCafi6JQAKCRCPgPtYfRL+ Tn0XB/4r4//GL59ncvaNlSdy6qb7aJsWR7/qjqFpkviz5q3jjMAyVjvE8GpHrqt2Etkq++C74as xa5k+EYtn7sKf8uY5k9JtUqKJ1sz1s+qB4P/8OkjYn/oweswOR5t3DMI8wYUNChMbzTmWS6uf15 tkpQ/R9Fi305MJQtDqPMl4MR7UePJn54+0ozv8KSv1WdQZXdSZjxUd/8T8Mpg0HEYwlCkaWIseu HNN1fc+Sgh2IKCXYyMhu2RSOgEKaOYE2Fi+XCnvvHyx+DJpe4uNSyM8PQyNeoSK82i1Tyg/9hnp Qfn1/2iEYNa37ipCKbg/rKUTfwcYIZZ7aNJ0u1j4OEgQI5a/
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The .driver_data member of the struct pci_device_id array was
initialized by list expressions. This isn't easily readable if you're
not into PCI. Using the PCI_DEVICE macro and named initializers is more
explicit and thus easier to parse. Also skip explicit assignment of 0
(which the compiler then takes care of) in the terminating entry.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
Hello,

The secret plan is to make struct pci_device_id::driver_data an
anonymous union (similar to
https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/)
and that requires named initializers. But IMHO it's also a nice cleanup
on its own.

The anonymous union will allow changes like the following:

-	{ PCI_VDEVICE(AMD, 0x1537), .driver_data = (kernel_ulong_t)&dev_vdata[0] },
+	{ PCI_VDEVICE(AMD, 0x1537), .driver_data_ptr = &dev_vdata[0] },

(together with the respective change in the code when the value is
used). This gets rid of a bunch of casts and thus slightly improves
type safety.

Best regards
Uwe

 drivers/crypto/ccp/sp-pci.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 6ac805d99ccb..ede6ff9ad0c2 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -552,21 +552,21 @@ static const struct sp_dev_vdata dev_vdata[] = {
 
 };
 static const struct pci_device_id sp_pci_table[] = {
-	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
-	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&dev_vdata[1] },
-	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
-	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
-	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
-	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
-	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
-	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
-	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
-	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
-	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
-	{ PCI_VDEVICE(AMD, 0x17D8), (kernel_ulong_t)&dev_vdata[8] },
-	{ PCI_VDEVICE(AMD, 0x115A), (kernel_ulong_t)&dev_vdata[9] },
+	{ PCI_VDEVICE(AMD, 0x1537), .driver_data = (kernel_ulong_t)&dev_vdata[0] },
+	{ PCI_VDEVICE(AMD, 0x1456), .driver_data = (kernel_ulong_t)&dev_vdata[1] },
+	{ PCI_VDEVICE(AMD, 0x1468), .driver_data = (kernel_ulong_t)&dev_vdata[2] },
+	{ PCI_VDEVICE(AMD, 0x1486), .driver_data = (kernel_ulong_t)&dev_vdata[3] },
+	{ PCI_VDEVICE(AMD, 0x15DF), .driver_data = (kernel_ulong_t)&dev_vdata[4] },
+	{ PCI_VDEVICE(AMD, 0x14CA), .driver_data = (kernel_ulong_t)&dev_vdata[5] },
+	{ PCI_VDEVICE(AMD, 0x15C7), .driver_data = (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1649), .driver_data = (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1134), .driver_data = (kernel_ulong_t)&dev_vdata[7] },
+	{ PCI_VDEVICE(AMD, 0x17E0), .driver_data = (kernel_ulong_t)&dev_vdata[7] },
+	{ PCI_VDEVICE(AMD, 0x156E), .driver_data = (kernel_ulong_t)&dev_vdata[8] },
+	{ PCI_VDEVICE(AMD, 0x17D8), .driver_data = (kernel_ulong_t)&dev_vdata[8] },
+	{ PCI_VDEVICE(AMD, 0x115A), .driver_data = (kernel_ulong_t)&dev_vdata[9] },
 	/* Last entry must be zero */
-	{ 0, }
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, sp_pci_table);
 

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.3

