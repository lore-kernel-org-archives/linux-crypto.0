Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B553A7852
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777908753; cv=none; b=lVDYxewJ8hPPShc4asfWxV+8wl4xidUawwekUQHj53o08sZxeRvYmqagorxH0FP/RgtHpN5rFjNGTACHghp8ddT4dUhZ53QGfZUCliqcUaU4x/iLIE1X7WYnE72Yb333k7rMDObIKqMyPbY4g/ybBnPqQEKpvMSlgCJ8JKAv13k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777908753; c=relaxed/simple;
	bh=QGcYmlsl5RvvVmnabE6/9QQf8rqlWO0cIVN9ARkaFg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lnaknjHdiK1mNUNkHYd/Xf1bEghlCnLwDGgJ2Yc9PdRFW+uz7ExB54daiAjVWRZjL9dntcEK3/guoU5MaADaYPQ24Szsfoz+nkQztTN5aiXsCu1223cqPfGnpj/4t1zSgjAYtSF5DscADaySZL129PpgO6/t5KJR9/8iJ7NIoVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b=RS//jtrV; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b="RS//jtrV"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4890d945eb4so29366485e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 08:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777908750; x=1778513550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=utfy0mtNce7fPeWpBMSkKi3btzcQcdRcgWFFBdltgGE=;
        b=RS//jtrVHpvI4D4LRfzkU2DuOzKiHa2wXUI0ojYpby2APza0qvLtMquKnKH2bLJcS4
         GJRZ8mzQD+PhQZ8IFeY1J47Kn+BCLgk4jzWXyvQ41gAVgkZ47CTu5aN6GyidUYWhIFK9
         QjLPDCvQY55Ad7f9mt6w3nerRD1Qcg5E2Ty73c8/aK2Hc7atFYW0MWGbs5tjDqd9i0cA
         3mEGfPvTyV922QTwzPi/GEvt+4WSFY9osH1e1CQEakhK9lUqglLDel/MhxVYQrX0amLd
         UAtRBbieCC2FfssCg5v6YX1MWMeWIZmscmQziNA6c/Ms6ehjRaycP121k/B0X2wIuJmB
         pm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777908750; x=1778513550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=utfy0mtNce7fPeWpBMSkKi3btzcQcdRcgWFFBdltgGE=;
        b=MV75FwWrjqzcLPZnbMlNGplIbl5mMmPY0QfjYdv92fIBfCCIhnRnXM91hKNRLWPwl2
         opji2KzovNCx8rU5U0AqhMTUbhxdH0qqfviDr0fNlr5+g9myLpzG7GMwdY8ZrO72Aa8f
         srirNIodXdOoH89N32be2AFLHD/AaYZhysWwfu6qxZb8CuzLOEoebUJJH3c+u+R9C5p8
         rwryABbCDiBtbFzQCZIMYuVtGwIc/rtu/ptVbbY0nS7dyWbU0TPmlkFNPM0TeV0Cx3a9
         kL34+kxNPVS8fSEXHCSt3Jrtsi8bQTysgz8PnQd90/rYMQvv+sV6uq5B3OSLrVdF8dBB
         RrnA==
X-Forwarded-Encrypted: i=1; AFNElJ/LMRBv+yuWQbaga/m18ixeOMhhAIGjbGIO1kJ/uv0bb6wd6j1eu+JIiE8h3u9YWI60TRru89AHKnnTQHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsT5nYCsDlitmgK1/YqyhPGGE3aDrUthlgxW9ioEShoXf5DlkT
	eL0cOhcKEdMNoFCb5eLhccIOu+Ud3z4C3Mxs14xo8I7j8nnG0+TXHfBg9QQ50qBMj38=
X-Gm-Gg: AeBDietChEPkbVUopwQKkCo3BLQem857WDzm7HlmVyhn8vWhbOT+1nDVdFnEV0EijTG
	PmyPj+FypoTlVIFkEkkpavvQkCn8MmINejIxZVl3qIcLgdKkAjyTqSK8ZD7YPTnhRG6PFfjC1Eh
	E/LXGS59GxQhUUBSWUPY61+pNVH3e9Prsk4McHvzH5t86MCVX73vQSHd3reB6Ew4iijaFLnexCt
	Tc6D8YfmWDXYfhD4bu/OEYB0M+DFVthP9BDCOMnaNop12U1vo4fagSnD//0SOlYWx5VIbmvgAfq
	k13uNPd8rBUZ2736ppG2Gt1lWoeCutVrvivepgaoiF2VHbLsHjwpA2swakIRp1pTnRFIQKtnh1K
	M2plQoZZkYRvKZampE/JjPvfCCKLCrpn5kKrajDiuehHHH0LaBnHplswT1VT84PThoxGSbp4Tsc
	JSNWYA3r1VeHjPlamTRMkCZTWmsB23aodgkMu1mYtpjH8sg9fiomznIi5uZaphrFpiebwD9ZQzl
	adbIDxSg0Pke5Qf5AZMBkqGTE4Oq4EUBFbu
X-Received: by 2002:a05:600c:45cd:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48d1424f973mr335335e9.9.1777908749685;
        Mon, 04 May 2026 08:32:29 -0700 (PDT)
Received: from localhost (p200300f65f114e08197264a4bf9e813f.dip0.t-ipconnect.de. [2003:f6:5f11:4e08:1972:64a4:bf9e:813f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a8eb694fcsm302558015e9.3.2026.05.04.08.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 08:32:29 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Markus Schneider-Pargmann <msp@baylibre.com>,
	George Cherian <gcherian@marvell.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Kees Cook <kees@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Amit Singh Tomar <amitsinght@marvell.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: Drop explicit assigment of 0 in pci_device_id array
Date: Mon,  4 May 2026 17:32:21 +0200
Message-ID: <20260504153221.2151136-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3634; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=QGcYmlsl5RvvVmnabE6/9QQf8rqlWO0cIVN9ARkaFg0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBp+LwFRarwqJCQ+DumAADbwHiX9Z8uEPDyILaLL I/EQz1ZBqGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCafi8BQAKCRCPgPtYfRL+ TqOqB/47adE8HaQccGNkZCkaulpMT7uI9fB5y3jGE6mqThAE6Inxtwyk7LphAvloY/LDCUhlE64 dMKhWFopMoXKMlqx4qec+tNX2vpqBN/5L42T+PIbq4KRN7x+uzdy7pV3OS3GChIz3uz34e6QIuB D8xLz68bVlnnaH1Io1ynxobMFcjjr5fldXHt2QR9t7xmOwXHILK6B4ToeM6+o5sgG915os3oPcF XVofXduro7FSFkzi05X0aZHJv2vMKw8kFBd7t8hgAwzq+yqYPM1HbZCaJP/6kGMlGOJLwVWfspO GB1ufYN730N+Pa0p2E34NsEXxkfs0hW92UysB89lzUvjv3uL
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Assigning .driver_data for drivers that don't use this struct member is
just noise that can better be dropped. The same applies for an explicit
zero in the terminating entry. Drop these.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
Hello,

this is a preparing change for making struct pci_device_id::driver_data an
anonymous union (similar to
https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/).
This requires named initializers for .driver_data, but dropping unused
assignments is still better and a nice cleanup on its own.

Best regards
Uwe

 drivers/crypto/cavium/cpt/cptvf_main.c             | 4 ++--
 drivers/crypto/cavium/nitrox/nitrox_main.c         | 4 ++--
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   | 4 ++--
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 2c9a2af38876..6af2650b1ebe 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -835,8 +835,8 @@ static void cptvf_shutdown(struct pci_dev *pdev)
 
 /* Supported devices */
 static const struct pci_device_id cptvf_id_table[] = {
-	{PCI_VDEVICE(CAVIUM, CPT_81XX_PCI_VF_DEVICE_ID), 0},
-	{ 0, }  /* end of table */
+	{ PCI_VDEVICE(CAVIUM, CPT_81XX_PCI_VF_DEVICE_ID) },
+	{ }  /* end of table */
 };
 
 static struct pci_driver cptvf_pci_driver = {
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 8664d97261fe..e474c84d8d38 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -38,9 +38,9 @@ static unsigned int num_devices;
  * nitrox_pci_tbl - PCI Device ID Table
  */
 static const struct pci_device_id nitrox_pci_tbl[] = {
-	{PCI_VDEVICE(CAVIUM, CNN55XX_DEV_ID), 0},
+	{ PCI_VDEVICE(CAVIUM, CNN55XX_DEV_ID) },
 	/* required last entry */
-	{0, }
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, nitrox_pci_tbl);
 
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 587609db6c69..5cc5c84069a9 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -957,8 +957,8 @@ static void otx_cptvf_remove(struct pci_dev *pdev)
 
 /* Supported devices */
 static const struct pci_device_id otx_cptvf_id_table[] = {
-	{PCI_VDEVICE(CAVIUM, OTX_CPT_PCI_VF_DEVICE_ID), 0},
-	{ 0, }  /* end of table */
+	{ PCI_VDEVICE(CAVIUM, OTX_CPT_PCI_VF_DEVICE_ID) },
+	{ }  /* end of table */
 };
 
 static struct pci_driver otx_cptvf_pci_driver = {
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 858f851c9c8a..62b08116f808 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -460,9 +460,9 @@ static void otx2_cptvf_remove(struct pci_dev *pdev)
 
 /* Supported devices */
 static const struct pci_device_id otx2_cptvf_id_table[] = {
-	{PCI_VDEVICE(CAVIUM, OTX2_CPT_PCI_VF_DEVICE_ID), 0},
-	{PCI_VDEVICE(CAVIUM, CN10K_CPT_PCI_VF_DEVICE_ID), 0},
-	{ 0, }  /* end of table */
+	{ PCI_VDEVICE(CAVIUM, OTX2_CPT_PCI_VF_DEVICE_ID) },
+	{ PCI_VDEVICE(CAVIUM, CN10K_CPT_PCI_VF_DEVICE_ID) },
+	{ }  /* end of table */
 };
 
 static struct pci_driver otx2_cptvf_pci_driver = {

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.3

