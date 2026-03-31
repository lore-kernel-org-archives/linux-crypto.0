Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75F13E1216
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774959741; cv=none; b=Lr/gGUf3w4Cn+u603y6c3vuSIO+vtG5ANVdVtEoLldUnx+BFb/kMPrBC0wCIzeokbhnmSWdx+bJ5GX44sqJy6bnxxJZyo/3ydZrbfUQpIMWt4zwB5F6knQdsuuZmfvVcLVNYY6whT1u83Sg8lshe/fyhfLDT8hleMytoLP69n2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774959741; c=relaxed/simple;
	bh=yBZY08O+PquoIPkc9X1R3mmq3ZSMTpZWXuFFS2nK6Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Iajw9jn2ZO2Udw+sjDJOY/zVQGJCE5spM43uDPs8f22iaY8uZJztJ1NzdHtpkJMv/zn0m4E7rbP2mp6E77kZnf+104mYPqJL+ygfL447bMJ3h+AX3EznbkBAyWqGZyAYmZgnvkXRVViwAiBust9KTaxNNaUr9kapjIEqqBzPtbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hofufR+S; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hofufR+S"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4887ca8e529so5326275e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 05:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774959738; x=1775564538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=R8DsriGRZc/vlEI1YAFmA+byoc1+oLgtee4dpAnNTZY=;
        b=hofufR+S07q6x1DJ2I8xz9+0B1SSTOonrLkb/h9bpmBT6HJ9HPOs5mDEqrHeq/2ibd
         NjMapTPg2SodMAl95Buz170U0GfjlOH7NvLM99frZOQZufKMgytrm4hlXRGxprnkWtAP
         xpTRZ7xLdBs5umnrwIhyqNJ6qETOqE3umtqvbpeBR0G4xhOs8IGYzYmkTU4wWZHENs7E
         eC5XXAYWIKcSk5AJmXlUGtuNUYNgoqZYgdP9IBgjvhjAXfjOKa5g+tKiYbukinNjvphz
         86hz4/rllTS6FmJM5BVA8easeT1Dd+/qh11sZJMZqOs4eLytugdnxGMA1D1MAUHlAQxB
         stXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774959738; x=1775564538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8DsriGRZc/vlEI1YAFmA+byoc1+oLgtee4dpAnNTZY=;
        b=YFpRD0kaW4VP+b1gNA6yLb3oKj+gXACkxY+pD0y+TBJKcAUNLA9KGgy6xO/AR4+Wqf
         vFLAs72ArlY6in338beNHAFDAcDzXisNcP/D9F868Ik+7Q6LOv8faffjN4xGnSCXfMFh
         gl1N//fCWLw+VgECsT6Q1WCzrdOEplpRCbrPL1vzv1MtZ9OnHA56Gqtdg7guet5O6dnM
         U1B2rxafuxmKuacEd7fgHeeQ80nx3WMnSetP5QrrvwkJ+COowiF8Cq8p9ZHuUA16RYsI
         NuRROAz+sgHpA1DuRUXGqsCLUbAyb+MNbm9hKXtyAmbVkUX0Kao/XQDhQAlIVv4JAVhW
         qB8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7k/J9Mv623Cfq0I1JZ31EY1s0na8rMk5hKPiUVJjhYXoIv270LDaPWxmJ0wxPHKoaLiAqYvSb6GKn0/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvSE3k2Vt9cEJDGiAYiJpdXJFcfRdSfsqRBqospWt3NO5mPYo/
	pByuM7HexJe79o1s11E7Hc8/4ONGUHMsm/9Q1BGztziNWUMqhsTKwx4A
X-Gm-Gg: ATEYQzxRPjYm+pHk1Q9eWDMcmHtoCI5KK7XhGRupa/ylCzQMVIhMOY3uoSta/VTZd2R
	MEkLQ2p4L0Eoonqv1x2l7QnkjNMG8K4eB0Tmy+kusRfL33+5S8hL88BFVy1l6HvJ17nLBaZMD8R
	8LakX6sIvkCfoagCf6UP/bN+1e1j72c4H9ZRykr54WxgWydfDwxBdQOdHLawHPxVGtSXxpTMyET
	/NgaF2lLc2IQ8RyCkf63u0nLgPh5ItxWGFR6dz0MGVDYfes2LqlZv7n49HwR53nGz4fUGb/gCmb
	7qleo8RG5O2Tat92q7YgTfU+wm80iWunex+9Ut6z1I/VWZy+MA+0nQ4qj7gdwgr/CgLbaYwi9/v
	8o485YLQ0j+NlWB+kSq+QmLfxObXdXvKya+zPkvacvgtBPCfvsbnlktLi3eVFcDD6b/beDvX8y8
	FCEKG2IVxJxjCMiNZ1G03phIaEGsYEu9HOBsWI7X5Q8vPufA6Jx3TWQPU=
X-Received: by 2002:a05:600c:83c3:b0:485:3428:774c with SMTP id 5b1f17b1804b1-48878281a4cmr56435855e9.4.1774959737714;
        Tue, 31 Mar 2026 05:22:17 -0700 (PDT)
Received: from nixos-office (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887aecf6e6sm16977185e9.13.2026.03.31.05.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 05:22:17 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
From: Julian Braha <julianbraha@gmail.com>
To: dhowells@redhat.com,
	rusty@rustcorp.com.au
Cc: lukas@wunner.de,
	ignat@linux.win,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Julian Braha <julianbraha@gmail.com>
Subject: [PATCH] keys: cleanup dead code in Kconfig for FIPS_SIGNATURE_SELFTEST
Date: Tue, 31 Mar 2026 13:22:14 +0100
Message-ID: <20260331122214.103145-1-julianbraha@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is already an 'if ASYMMETRIC_KEY_TYPE' condition wrapping
FIPS_SIGNATURE_SELFTEST, making the 'depends on' statement a
duplicate dependency (dead code).

I propose leaving the outer 'if ASYMMETRIC_KEY_TYPE...endif' and removing
the individual 'depends on' statement.

This dead code was found by kconfirm, a static analysis tool for Kconfig.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
---
 crypto/asymmetric_keys/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index e50bd9b3e27b..6a2f664046ef 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -95,7 +95,6 @@ config FIPS_SIGNATURE_SELFTEST
 	  verification code, using some built in data.  This is required
 	  for FIPS.
 	depends on KEYS
-	depends on ASYMMETRIC_KEY_TYPE
 	depends on PKCS7_MESSAGE_PARSER=X509_CERTIFICATE_PARSER
 	depends on X509_CERTIFICATE_PARSER
 	depends on CRYPTO_RSA
-- 
2.51.2

