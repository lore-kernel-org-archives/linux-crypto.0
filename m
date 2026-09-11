Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4EF3E7621
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 02:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094850; cv=none; b=lyikqHzVVBQTOAEUrcjHXsA++RapjRYxu9iKbiFuJVqNsxzGlo7xarWzRE1RFiKfa+eHUIQl/wtOiP4svix2F9gGGV08m1L0EuhMbpoA3e2m+MIW6scivdc6XVXmirGZQAYZ8j7iSPl7j0rjrotBYKibbaxhJLncxsgwLndpNyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094850; c=relaxed/simple;
	bh=Q+vE+X+sG/ZYk8rkcS5IYVR/ggcGiu0wbko6eWTdm1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bDqLsZy73cv1WrsSgnpQS+JNWKYFu/5ngtkdl8rROLepRaRODpeFxbv/Sct/+8EKr+w7jda/TOqmmYs0clJH1cYfaS+bqK8MXiogr0m/Kj/H68O3df0yCzbOULd8XTNbRrm4RH973cejL4/57pRw+eB1o5vzPxrpnJgS7/vLsQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KB+BmbwS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KB+BmbwS"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2db858d60e0so3846355ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 19:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789094848; x=1789699648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4VRnd7b8ZPPVwC55w7njfDr576OvKBxuHB8QDsx2Fm4=;
        b=KB+BmbwSTZHuPx0pP35Vp3NGj9m1+h0BBVGFgob1gVqIDdJwxNsj15uol0PCLhLwCc
         hxlz+XACn1ey8u6ybj2ynG3treyvdIOTYJA7wENFI8mZz8Dwd35Bt1axOc3SYGkKm0Y1
         hW9G8A3x3dJbAKvJli1ttuBlQVQ2mnZnuHr/uV4E9TslALNQBMStdH+gxVBViczNfs7u
         +HXSCzial1FIdnEwP6fzbC97QydglctiaeeQESjP+WBSJMeRMGQm8TqQaoWhd0K3T57D
         dugGl8KbjzwIb8usCY11uWzY8EbNEPLhjGAjHfLowF46sLowg8O2nZmuicHNP6dz4zD4
         lHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789094848; x=1789699648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4VRnd7b8ZPPVwC55w7njfDr576OvKBxuHB8QDsx2Fm4=;
        b=ShgIxoFl3ccy/wbMVPXW8iHAvvbtc+7iTgeaHXhd49VECwXDodNa6E3Y+8DDtxqvbk
         Vfjj98Q/C0hWLRDAlUDZUCOC+O3W0dnBuZ/BDdSPH6s2sUk3gimgOphStV7SEA5NOjG3
         0RUxEVtkeVbUjC3qHIzSFEaWn0VSvEBLACmylpM63AHLL/Dtyi5CynfCeTu3T525NjHs
         6Aa6H+XVOJ6obm+crmo9bJkkrqQ+Bt9xgnQlwrRlA8TBaRXB55La0dEcWiCReSrc0rf6
         UbqWEvejOd7Se0cd4h5zFdtdLXQGmuqsBi/KJDoI8MolHjltpbJLYhG6D5veBQh0fBH8
         CFGA==
X-Forwarded-Encrypted: i=1; AKwUvBzJtEUHKNrgPrfrPtlyOGD0R0/By+n3GyL3JiFSGRZ6aPnq9mwdKWy+Ou9YS9EFfE2oePxiCnbNvqhAs44=@vger.kernel.org
X-Gm-Message-State: AFuF++nH0E5FLNCt1f1KU6E0NR7MwbiQRYidM+eZDsLeP6U9NTNZXfMI
	cvrV6Hbq557emCar1HI306enjfdMehP9F7jRAwNJV6NLzlzAlmJU1A2N
X-Gm-Gg: AYBFou0BSxXKDo1CLKO6Skyy7QC+YmuOZn+qw4/HKVTcllw3hwzTWFDnVShQk0A53+n
	4uM4N2w+nBfowDDN1zl0WUfkExv5lJg5KD3m6YDuHs+SOYejeNRiLQzcednlT4OkPEk1/KTDyKQ
	Zda9YRzHQaicD5ZttNtoj+t+D9zAYvEPH4Mp2eQj2OlfyzQr7CO8EikrdYwvxxynkBjWN0Wm9VX
	DCrEf+SV4rg6XPXrDU4KX2Emk1bwHf2Y0DJguvKsYJ/XoSEGxsnNXpHZBZeeSQAwbCoivJWbJff
	CxFK5yugT+dX0gSqgLaNbN77AXInRqGiPV3i5pCfTyPNrWuO7kGVKmXd8AdxMgrNk9OQq6WQYM/
	0lxlqCTFHuhmqJLzzovUJaT+1LJFjI9VhNUnUio5JguEMVnD46P7tbpKdJ9KvqpUYwazJ28XTwE
	RdWWWTvtFpWGWX+g4YdwhErqbcHDRVxSzBdeHkCGf8T0cpUFEnk0vsxYIyOSHnyAIUqaii9I5Pj
	XPRZleFeZI9kV+A6Q==
X-Received: by 2002:a17:902:dac2:b0:2d8:f965:7e48 with SMTP id d9443c01a7336-2dd2a1bfaadmr39930245ad.1.1789094848007;
        Thu, 10 Sep 2026 19:47:28 -0700 (PDT)
Received: from toolbx.alistair23.me ([2403:581e:fdf9:0:13b2:851f:d9cb:44c5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cca26c2sm4129225ad.10.2026.09.10.19.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 19:47:27 -0700 (PDT)
From: alistair23@gmail.com
X-Google-Original-From: alistair.francis@wdc.com
To: ashish.kalra@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: alistair@alistair23.me,
	Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH] virt: coco: change tsm_register() to use a const struct
Date: Fri, 11 Sep 2026 12:47:07 +1000
Message-ID: <20260911024707.3485954-1-alistair.francis@wdc.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alistair Francis <alistair.francis@wdc.com>

The tsm_register() function takes a struct pci_tsm_ops *ops argument.
This eventually is stored in struct tsm_dev as a const, so we should
just change the tsm_register() register function argument to be a const.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 2 +-
 drivers/virt/coco/tsm-core.c     | 4 ++--
 include/linux/tsm.h              | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 46f2539d2d5a..48df8c579c74 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -339,7 +339,7 @@ static void dsm_disconnect(struct pci_dev *pdev)
 	streams_teardown(dev_data->ide);
 }
 
-static struct pci_tsm_ops sev_tsm_ops = {
+static const struct pci_tsm_ops sev_tsm_ops = {
 	.probe = dsm_probe,
 	.remove = dsm_remove,
 	.connect = dsm_connect,
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index e784993353d8..6b735ac2a814 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -57,7 +57,7 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
 }
 
 static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
-						 struct pci_tsm_ops *pci_ops)
+						 const struct pci_tsm_ops *pci_ops)
 {
 	int rc;
 
@@ -78,7 +78,7 @@ static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
 	return tsm_dev;
 }
 
-struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
+struct tsm_dev *tsm_register(struct device *parent, const struct pci_tsm_ops *pci_ops)
 {
 	struct tsm_dev *tsm_dev __free(put_tsm_dev) = alloc_tsm_dev(parent);
 	struct device *dev;
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
index 381c53244c83..6ac12de8c4d3 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm.h
@@ -120,7 +120,7 @@ DEFINE_FREE(put_tsm_dev, struct tsm_dev *,
 
 int tsm_report_register(const struct tsm_report_ops *ops, void *priv);
 int tsm_report_unregister(const struct tsm_report_ops *ops);
-struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *ops);
+struct tsm_dev *tsm_register(struct device *parent, const struct pci_tsm_ops *ops);
 void tsm_unregister(struct tsm_dev *tsm_dev);
 struct tsm_dev *find_tsm_dev(int id);
 #endif /* __TSM_H */
-- 
2.55.0

