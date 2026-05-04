Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875A437648D
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777886429; cv=none; b=uEdzdBYCvjakXTjKc2+Mx48RFhjnn3ugYncBkua28rzRamJYaWXEm9lvrIpn4lZorGYKrPe9LBx3y04082JWzT5J3LEypsyXwhChDKjM8cbMLOJUUZmkDlRzdd6DSzOsMzrfPTEztPUm+H/JCwK61tuFb2ZU8466gpFGP9S6Bcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777886429; c=relaxed/simple;
	bh=6m1kumv5EuMAZ2Bknwu38IduIHyOgGYAFYB46EmSQLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kAZC9dAD27Z9OWMrvi+XkXgD8P8uEVuT2CByM2eGuHIt499xDQ3UKv27idUAPdVSBuUWZL1jH6kAh4YCXGOrlslCv5TP3rICbwyAblNVgx5O0T1DcWpOJeR69CdXmFQtWaDL66nDUk9JPfLrOyNtHo7j4eXV/FBElRi0TKUdCiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b=BFYMpKq3; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b="BFYMpKq3"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48909558b3aso41119335e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 02:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777886424; x=1778491224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GEZBHDvYUGwbcvZYIfIMs5nb3Ib8ZDK+ft3NQfFTWJg=;
        b=BFYMpKq36dxS5csk11/el2QL7Z041+h4ahvdaYUG8lUwkOE9qDoSZrxvD8pto9Bx+w
         VGOU17LOFF8nZchaLGCgQ24RdTEX4D3iZPKaZ74PVA73ZKWqzT2Z6VSe+1eoQcjHa/w2
         bUO1jXt66aHvxJIsN4hgX8gaQrY6K7GE5SiUPd8ufhDCVw+NALH/2mYKYAtihftgPuJn
         oL5DV0tbufJUrog4Cj+StHbrItXtSGkFzlTP2C+tSqPz6ZLASNS2SK39agsyt/LgTG0M
         sD3Mf82y51alShzeEvVExxOFBl+EzYq9+xA8xP8sBmQNFhhkE4o0+e4HYeOUDK3fxXna
         0ibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777886424; x=1778491224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEZBHDvYUGwbcvZYIfIMs5nb3Ib8ZDK+ft3NQfFTWJg=;
        b=hC9bB7dh3WyInsiRMKYk5FmJbPBGLHO3w9uMuYvt7Mcx+HutaCtFWyVI7uQVWewlxs
         KMxZYhBKviZ1PVHVewUfXCW3RJeY05Vfa341tHtMR6948U0ALNTl7WRHfgKDP2FWB1Tx
         BgXI9exXPdBzNUMapxYLSWxk1aEJYa5orRv3cJ/FfXO+bZGERm2IHfJAFKOZ1z7nEprX
         VIliX9ME7rIDogLYVV86EA5IXgs3RZb/6oTKSoXpyzOMt8+2qdswqd/mE3Eesx0kV6cw
         0pDO23Gg+0rKx2UVGlKMGZi92kaqtqWM7WmNa3W7AlgLlNd/SlULUzkN7H6IFNT0aZ/i
         P52g==
X-Forwarded-Encrypted: i=1; AFNElJ+ACMOZzeqlGTMFBZJ8DTRY0q1nXZrGRdiKPtz66w7HWYLv7Z5sa4xIg9VFX76YyvyEicjrhiOsQfQWUT8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqxeQ7vBSrmUlCbrtBOYOVF6OH7XhPdNzHC7Wcj5G4EvD3dvPu
	EZWRNpJQudPo3q6MQoPfmsHE2OtTLygq2z3L4kvmgnPGokS4gWpWWIsFrXMijshuR2WjQIGpCde
	7l6JQ
X-Gm-Gg: AeBDiet8IeYQpT2wIzMr6fQ0yFRgq+d7Ru+xe3O9ey9syHkKAnVkHFqtz17sF5P4u7w
	ulzDOFzIqd6FIYTTxOnCTvzYuIy/3HZ/VStue8+OPo8dkKIYaqv1nMsg1LYVV5Su6z+7T9jnRuH
	rk6VDaWWL753Ju7y25JhDWpCng+TuXl6uWKz7kRnXkQKCatP0YYz2+ocbi2+aSE8YySKRvwBfr3
	7voG75jcItFzhSiIqHEEkiYnDN9YVybBYomv5Ia0bUMZWJqm3JeZoaKSMr2lNpAW9RDTqpjdarQ
	eF77cFgHbrMOX9AYqAJVRMWw/IuJju+VokWPwoAgTTcTz/rD7S1CzQ07yRlxEMV9itwBDMe5QgW
	3iZ5TRp/FGCTGIzmXj8mmXvfC9fn8TXFFHloneGL7unkDnAVR+P8PXg8neD5yY6BybqgBDDWf+Z
	5bPgxlMSQzKGDDUc+P8I2xg1ivC6VSI43JWSjMk/gSogiGQhvHsC/5DomzlQQB9O3RmFQTkWX8W
	9BKDnmUncFd9OWP0hw31mUWwQ==
X-Received: by 2002:a05:600c:2d95:b0:488:c014:34da with SMTP id 5b1f17b1804b1-48d1174dc42mr8558625e9.26.1777886423934;
        Mon, 04 May 2026 02:20:23 -0700 (PDT)
Received: from localhost (p200300f65f114e08f5a4175dadf07882.dip0.t-ipconnect.de. [2003:f6:5f11:4e08:f5a4:175d:adf0:7882])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-44a9879ef45sm25677526f8f.32.2026.05.04.02.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 02:20:23 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Markus Schneider-Pargmann <msp@baylibre.com>,
	Andres Salomon <dilinger@queued.net>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-geode@lists.infradead.org
Subject: [PATCH] hwrng: Drop unused assignment to pci driver_data
Date: Mon,  4 May 2026 11:20:14 +0200
Message-ID: <20260504092015.1955605-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2538; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=6m1kumv5EuMAZ2Bknwu38IduIHyOgGYAFYB46EmSQLU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBp+GTPDrJ7yrG84eSxDPr5+gKotioavGotB3ddM tLRDpfBt52JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCafhkzwAKCRCPgPtYfRL+ Tu2xB/9R2IJIdTYzCPRfQXHuuPJtS6NSoReXd9LG/nYPzm6OI0BPZ+Zq8SVQ8XEgo++jcXBNulB eM21p2HQDG7ieWmxqLGWpg7mA7cHZLucn8UsdBmbj5ie6XCPDi8g2B1FG4CcwVdfsZK6w6+7FiE CkjKY1kAGPQm/vbNfS6mVl5pqQ2dxDNxfmk4c1xgpAWF9cEu7XxMPTO/Pd55vESEGkJut8Gpeny UGfuRbpMX1dji5Z0H27X0KHwIrQlVzNyej5wqRBIDuiVl7wmu0RM1DcLF5Z7BAkPdNY2/gGwMhF qC3FJnG7FL6xXTsyw1F+ZFSNgVqGwXvVuDgbsow/Jhw8SAR/
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Explicitly assigning 0 to driver_data in drivers not using this member
has no benefit. Drop these and similarly depend on the compiler to
zero-initialize the list terminator.

This is a preparation for making struct pci_device_id::driver_data an
anonymous union (which makes initializing using a list expression fail),
but it's also a nice cleanup by itself.

It was verified on x86 and arm64 that this change doesn't introduce
changes to the compiled drivers.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/char/hw_random/amd-rng.c    | 6 +++---
 drivers/char/hw_random/cavium-rng.c | 4 ++--
 drivers/char/hw_random/geode-rng.c  | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 332d594bdf70..dff80daae587 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -47,9 +47,9 @@
  * want to register another driver on the same PCI id.
  */
 static const struct pci_device_id pci_tbl[] = {
-	{ PCI_VDEVICE(AMD, 0x7443), 0, },
-	{ PCI_VDEVICE(AMD, 0x746b), 0, },
-	{ 0, },	/* terminate list */
+	{ PCI_VDEVICE(AMD, 0x7443) },
+	{ PCI_VDEVICE(AMD, 0x746b) },
+	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
diff --git a/drivers/char/hw_random/cavium-rng.c b/drivers/char/hw_random/cavium-rng.c
index d9d7b6038c06..3e2c042009f6 100644
--- a/drivers/char/hw_random/cavium-rng.c
+++ b/drivers/char/hw_random/cavium-rng.c
@@ -73,8 +73,8 @@ static void cavium_rng_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id cavium_rng_pf_id_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, 0xa018), 0, 0, 0}, /* Thunder RNM */
-	{0,},
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, 0xa018) }, /* Thunder RNM */
+	{ },
 };
 
 MODULE_DEVICE_TABLE(pci, cavium_rng_pf_id_table);
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 1b21d58e1768..ae63eff64344 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -46,8 +46,8 @@
  * want to register another driver on the same PCI id.
  */
 static const struct pci_device_id pci_tbl[] = {
-	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES), 0, },
-	{ 0, },	/* terminate list */
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES) },
+	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.3

