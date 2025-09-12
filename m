Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80AD242D9D
	for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 07:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757663214; cv=none; b=WuLqmxp4ACZh8RgZ5DyxDUa/UBDb/DAUhiWfI1hgXivo2e/f1Z9RoGQWTs21NBg/wBpkGlEFSCrTXk/GUp0brC7OgXQmtT/gF2axr+n8FeRQyel2cfkXi8U0Mt2robSw1SUl6M/mo6E0jY9V8zNtzxoPxNBStRZ9kYxIG7aJ14o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757663214; c=relaxed/simple;
	bh=9yoMY6f/O5Kdo0NFe6sZTx5s/b+R/IevS2MD/nCV13s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aD1ULJBqj1MYiEsO1+dqq4636QZADJ49Odxcd5OxIkTDSIPswG/nauhleo/lFuY7nnRS+/XM5jQpjlJ+DArJhW/SFYh7rcoa/kGbv/8z6LI6oxoXi7ON6uuKc7Cie+vbbta4I81BMkpoM+hbfgn5n25Cc+T4KNi37+uirikijSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MBM5u+Na; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MBM5u+Na"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757663210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vvaALMZ4+zN7uBMG4oemyZs/dyL2tuTURio8S2qM/9A=;
	b=MBM5u+Na7ieUbBnc1PRAB0K5i+dCpnTryqO9S0oAKL/HY9tMEuQtpdnXDJM+oM8oy/WW09
	ijSZo/Y58c008HQOV31I9FK1sZrDFEgfDmLpSEHVa1HmZ3h5oPNORIxkvqqfkdHJYfFWb+
	WbnsiG6o4g0uvrwomBKTu4bmhPkl9Ew=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-bcqNDMxAP-WRbET7v36X6g-1; Fri, 12 Sep 2025 03:46:49 -0400
X-MC-Unique: bcqNDMxAP-WRbET7v36X6g-1
X-Mimecast-MFC-AGG-ID: bcqNDMxAP-WRbET7v36X6g_1757663208
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e067ef24aaso1043199f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 00:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757663208; x=1758268008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vvaALMZ4+zN7uBMG4oemyZs/dyL2tuTURio8S2qM/9A=;
        b=G682rDm4i7GipO2s5n/TeFWUQPFJ1rc/EuXV7tz0eIJ81JFMvc7B2al5GAuhPgzGWB
         2pUYVfcV0tsaWkO3cfydX0dhgUONJtwyoDgkyh5MlNVMCK/qGrk8tJwV7uauoqYj8Hl0
         EaYb/rBpKIp13r5tMGeL8CnNs6JqJrEgxKQJPcZLChZdW0e0qZvOJcw+H49K3H2ahwiY
         Rd6WQg5QIxPlIOOpNb3WgBrIdsvKmTOufl/NSl9JSJWLk1slQFRWb905InADVKGV95qX
         hwYuybcQPSmd2XFBr1lkJ8o1tgiE0h9VBD5b1OccRjuopUeYp1L1ysW6aWCLpz/DrGgG
         8BRA==
X-Forwarded-Encrypted: i=1; AJvYcCWHoAL2E5HbkQ10+qYp8LzTJKqI/0iyel05tRsG7TWwL62Gyux53gEtyfHbQtSCu6jWETrL5q4/7jfeshU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1WLoKnj/nD/dzI2YGxicVrKeR1cyMyIdQRyMLAFwFsK4SLMm4
	8X81b1pvQzZpJ/2IZJIcRuHAMuDKN20VERLn8DITSfCopJg5AEeJf1kyNOs1RaZWsC3WvEAYmTZ
	+uelyHyiAEVJveKXucEJBi8u8OGhZ+mKKnouKTCICOV/30azVN8MiJhlTHMLIAA/dRA==
X-Gm-Gg: ASbGncu1rfbqbdmumdXwJ2pgYBDKFb4yYZKPjSqowkwRYUSkvkCPRWX7V1OfDcFjA3s
	7VpgKIaZpAyMJS5pSwx86Wn2CA2Bs28D+fg51Mn49F0NUdnS88T8XhvyCWlqG5ToRslsHunxfJG
	TrTQAGSG1Parsk+leyLEQ+1qXHj/cn5p2YBNAWweQWovtwty0AWAuk7d9S5MelBq7WMSbtGFrQ7
	3uF2FJhmLGx8XHx/fpDWPwOqEQnjI3XZpc3WUu1VUUXO4mgYu7YUzWC4maVzsdWXjHjEwLg2Oj3
	mdbBQqGE0kAUfN60x6kos8/nUEsEbtN3SDwOgRKwaisHkd2r0nnCABakNEzRjSMr0YLS3k8y0IU
	RvJsSTiD1lFrvWw==
X-Received: by 2002:a05:6000:2891:b0:3e7:620e:529e with SMTP id ffacd0b85a97d-3e7659ecaa7mr2028793f8f.43.1757663208170;
        Fri, 12 Sep 2025 00:46:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFm21ubE8d+dHPSjquWE3BgW1E1TkX8hsLoEa0HPJgLnT8FY+Bw9Zzo9lF6e6QuFVRZXGNdUA==
X-Received: by 2002:a05:6000:2891:b0:3e7:620e:529e with SMTP id ffacd0b85a97d-3e7659ecaa7mr2028771f8f.43.1757663207787;
        Fri, 12 Sep 2025 00:46:47 -0700 (PDT)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:1622:5a48:afdc:799f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd424sm5362628f8f.36.2025.09.12.00.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 00:46:47 -0700 (PDT)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Lee Jones <lee@kernel.org>,
	linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] MAINTAINERS: adjust file entry in LOONGSON SECURITY ENGINE DRIVERS
Date: Fri, 12 Sep 2025 09:46:38 +0200
Message-ID: <20250912074638.109070-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit 5c83b07df9c5 ("tpm: Add a driver for Loongson TPM device") adds a
driver at drivers/char/tpm/tpm_loongson.c, and commit 74fddd5fbab8
("MAINTAINERS: Add entry for Loongson Security Engine drivers") adds a new
section LOONGSON SECURITY ENGINE DRIVERS intending to refer to that driver.
It however adds the entry drivers/char/tpm_loongson.c; note that it misses
the tpm subdirectory.

Adjust the entry to refer to the intended file.

Fixes: 74fddd5fbab8 ("MAINTAINERS: Add entry for Loongson Security Engine drivers")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa7f80bd7b2f..a1339a8bb705 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14537,7 +14537,7 @@ LOONGSON SECURITY ENGINE DRIVERS
 M:	Qunqin Zhao <zhaoqunqin@loongson.cn>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
-F:	drivers/char/tpm_loongson.c
+F:	drivers/char/tpm/tpm_loongson.c
 F:	drivers/crypto/loongson/
 F:	drivers/mfd/loongson-se.c
 F:	include/linux/mfd/loongson-se.h
-- 
2.51.0

