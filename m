Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5F01D278C
	for <linux-crypto@vger.kernel.org>; Wed,  6 Nov 2024 08:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730880833; cv=none; b=RpLpiZgZ8p/qcVjnLNoHECEgW981YJ0Zdkog5ekEdloirZze0/u/UilGxF9p83Vu6ZR60wJhLszaSXMR+Alk7nRU6ChuKU/pGUGQluMbVaJHg9It1sZJXFdMcZpY+v1cuypQhGov/D9FMt3+wcYh0ba70Mnsgp9egOy8zbtq6U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730880833; c=relaxed/simple;
	bh=IiVxXzi6cf1LmPboJPt94NJr13UCP0qfsLiOmx2zt5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C7YJGyDp+dLs0/olmIGm1IHPjYpTic+LVA4A1aWjut7Phu4x+s5If4goApkfU4PnlrqqEhM+JQFTvQufdiGMTvydiPXtOlVGrL6nreHvv7rsNUTC9++8JKQYPpPNBpm4WOLUYuNUwlFk++JYaEeHOiGTBmToQElYIjBDlzklSZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ehUuWGGZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ehUuWGGZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730880830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u2secMimeI4+f4dvxa0WxHbdFtZeWJOJ8zwpB2N9L3U=;
	b=ehUuWGGZJ/U863VXX9dIqO6S3SjmecykBvJb3I+QkqpL9iFEHI7nby7jo0Sd/xPn4g7sE9
	Sb9M5qabQItdxxttl+XlJHSPn9crpw+eqO1+ATh3PoYs0aGp+R7aiBGZABcc9tNF8SwbnQ
	7PvokHuR532jokHCHiyU22ggVhVJQ+4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-y5Bv6OEwO2etoZQY-q5ySQ-1; Wed, 06 Nov 2024 03:13:49 -0500
X-MC-Unique: y5Bv6OEwO2etoZQY-q5ySQ-1
X-Mimecast-MFC-AGG-ID: y5Bv6OEwO2etoZQY-q5ySQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4315cefda02so47067895e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2024 00:13:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730880828; x=1731485628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u2secMimeI4+f4dvxa0WxHbdFtZeWJOJ8zwpB2N9L3U=;
        b=IYgT5PELqLBLgaZR5Or5G9+Va39HVySyeSuswxkZs04P/7EYbTyk1ziPLrm7W7LQ1M
         a+oQV0orkpt4hC78zzCzc7L6NdhLVuouce4Nl7ZgbNGxeaY0g9s7RFhn11F9TZgNQLOO
         rhOryaYzBpo7x7PJa68g6ciZrZBsUTWUfUnqp/U7jJBsWDAsEmx3dQs4EMsiQ6vvzwqa
         685XrUhsVP+uQ+Vr68jTV9fkgA6x5ccJ4qbq3+Kkbi95JuaHcRIoSBXn4n7YIsXkze9V
         G4n4osWGogG/zil4mZMUCR93kRlMU4mZSzppLkJ9A2/EDf9+MEJ8UGwbF4uYJeqASync
         m7kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdilB2o9aY8cJdVg7PxX9/FYShKgMzEx7TCav9S59LfAgeVVWtsmSp7oJlQXFXspqkIdH7GIeKrIN4C9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQG3jH/nz/Q2coNNOQ4FY2Pu0lyY43TdkGbjyLS7DSXUc4SuQ0
	YReg66Cph3Sd9gPG5wOEnuO91gfvN9qZqbX7aTO7NgwlymrB7WBhAgCEGFt5hCf1cbDksm5CpBh
	rto1/xCQWexrtYo2cghYAOlVqkSUtR8nib895B6YKI57O99cD+soFMfX539reuAFR9jG1pQ==
X-Received: by 2002:a05:600c:5115:b0:431:7c78:b885 with SMTP id 5b1f17b1804b1-4327b6f954emr187771655e9.4.1730880828393;
        Wed, 06 Nov 2024 00:13:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEDbzGtgbC+limkqrDb3bgxn8MtUgaok9LxE3/Aqw87YDkCd2Xwwy8yw7eixK0KNLGFNgNJg==
X-Received: by 2002:a05:600c:5115:b0:431:7c78:b885 with SMTP id 5b1f17b1804b1-4327b6f954emr187771455e9.4.1730880828017;
        Wed, 06 Nov 2024 00:13:48 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen9.rmtde.csb ([2a02:810d:7e40:14b0:4ce1:e394:7ac0:6905])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10b7c2bsm18387226f8f.23.2024.11.06.00.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 00:13:47 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] hwrng: amd - remove reference to removed PPC_MAPLE config
Date: Wed,  6 Nov 2024 09:13:43 +0100
Message-ID: <20241106081343.66479-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit 62f8f307c80e ("powerpc/64: Remove maple platform") removes the
PPC_MAPLE config as a consequence of the platform’s removal.

The config definition of HW_RANDOM_AMD refers to this removed config option
in its dependencies.

Remove the reference to the removed config option.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index bda283f290bc..446c2def055e 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -50,7 +50,7 @@ config HW_RANDOM_INTEL
 
 config HW_RANDOM_AMD
 	tristate "AMD HW Random Number Generator support"
-	depends on (X86 || PPC_MAPLE || COMPILE_TEST)
+	depends on (X86 || COMPILE_TEST)
 	depends on PCI && HAS_IOPORT_MAP
 	default HW_RANDOM
 	help
-- 
2.47.0

