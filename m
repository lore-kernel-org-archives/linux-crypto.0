Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7295695
	for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 15:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577795; cv=none; b=f/3CFF2lJKbm1B++l8u2Ajl4T3eF1bQkQc0UP2sWoztpTmRvoTaFluKePhmM6GY0ENx8NaUHWYbIEWbH3RdmasgJfrKaVk9xzt2+1BIGXg2Akdwfiyso5ipyMLAeejTCYhSNc51qiu7SxXXzNDE06dadFkv82ThDhZLykYFsCA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577795; c=relaxed/simple;
	bh=ZsCPFXC9R6NQL97nYWlCY006QYpTpfOsDxb5I2LLUOE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a8GEsvofGVGa2yHFN40Z+g7cgqHmydVYGulsZbTeSQ+QwD25cquSwGwqnJE+T+2m7NTHxCwbGuSs/bvbi5iypxMUcqiWQwA9oCBN18gV4PaqpuPAhWbQ9xxgyMXZVUP6Z/ytLIIsmozieBZyjPsM+xbCEyVmxR/0PjejgWHHTQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJ7ja//h; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJ7ja//h"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b6cfffbb1e3so3320004a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761577793; x=1762182593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bOWeTrE1BXy5AjZlTLFESliT17UYj7Zas8RzdCqx+Q0=;
        b=kJ7ja//h1GuoShmdPrCSmyeJEW9lvcDD9TjI7HmOoqCiqUww61jtinmFyFPki9aVRB
         XgmaLqmysom2tx/vUAfxD79ODDCZbfnnqYwHvIdnK+vcABfymOOvyqqiRRWun8hkXVRI
         qDrCOxp8pXBPb9o1Fp9D4isFqnu7mMnHnCgLIusz7m/+j+WpKQUQ87HEx13fi3u9jl6t
         X1ltlZ5Mlk6tDKI5MOpscQiB+XZk86RFKweU6kmzejVblEu4mf+QL1gDbijVQ+1Q0mwP
         HKTrnEPib67AbFuJ961hiJsyReugDUHr7V+/RynxjsSbG0jpyGhGRQN+ZEM/vxRzEh5E
         ODVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761577793; x=1762182593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOWeTrE1BXy5AjZlTLFESliT17UYj7Zas8RzdCqx+Q0=;
        b=OdcPv3AGMoOvRGEASpguINBzqvTMEtrmisfCbiq4w9b0jcYtbxpWfn6lBKYM7E24Y6
         +e7keNIbILrOO9GXkcvGNlURNf+9o6US3d9cA2ohg2flcpy9f3CE5Chg2E6sZQzoeEo+
         Gkmd5BS3JKaWoIV5MNvbRjqmMoYkzaugFPrE9+74u3Y1vIs9D8HexaPwmNq0NjWUlRE7
         ouw7vzQnLAtkxWiYpK8yFyPVEWbuYh/HlEUwV/K4BXnWMY4WNo5AjQa8AjyYJ9CkLk+j
         S0iT4UCjVZDxB1I71tD5uWjW4wJFeh8faxP9rCnpxS9AJ4ZbdGBauI1UNaYb01JG0HhY
         QoCg==
X-Forwarded-Encrypted: i=1; AJvYcCWpBUlwFvzrI3Bd6ymAbKrWw3dM7KGECk7UBRbZa3zJ2bklgqWe/svUQJeESXqoby1Sn1zM/msXXnw9ovk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQEWXVS16bUlPlldVzozq/7MBDl5frV45mP5ZtO/dduXOcN9dY
	9tNRIk5HHFwoKqLut/Dm9zoKQ/ncQn+EZrSHgFh/1v4OUKaNbcD0Sy0I
X-Gm-Gg: ASbGncsN7raIo5zt1WUnnC6o3mCr+ptKiPdUg6Cn2ZRvgMn+/ZmsZ/DzPBQeVVb0u0/
	MBjMTpqGD0TQHMgyrK4cLi3ULcuE/x3RYQC1qWHk92kyIQCeepPulwE57wOvV544Rx01crA0RSV
	GlsbkF4M4nD5Y+X5OpLtUTTTcLrU7S+SZncf5/YvFPJ8vfQCENpPoof29FvSS02KfryYBLxJCEf
	R3qKC/MSEYj8AcMahY6Z08fTr2cKgIg3UCvlgpKaWlkCBB6Y0lW7QnjKESHpYB6y/swCv/1aRMM
	mOKYuypz2Su8wnIJd3tj3T0D9npQ04OR+0TH6ougZPeqEvING7I6Q/iZoKHPGkuyQHbtZmbhaXn
	yhH8ow/MdzGZXtsQlw+cuoroHgkf34SLC+He3RPfrc90XKvjeSmIJtG7amuS7lCLuar5dHbGW3+
	BKj7hr2oiYefEqtJNF/UH9wOaeA4EspM/2
X-Google-Smtp-Source: AGHT+IHm+qmEs3k8KDkI28OdIfpmmkZKiOOzJFODhG9t1YR8Za920Qncpnz3yBINujjAHcwPpw/fHQ==
X-Received: by 2002:a17:902:ea01:b0:252:a80c:3cc5 with SMTP id d9443c01a7336-294cb3d6169mr3033825ad.22.1761577792933;
        Mon, 27 Oct 2025 08:09:52 -0700 (PDT)
Received: from localhost.localdomain ([124.77.218.104])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29498e4113fsm84234275ad.90.2025.10.27.08.09.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Oct 2025 08:09:51 -0700 (PDT)
From: Miaoqian Lin <linmq006@gmail.com>
To: Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kai Ye <yekai13@huawei.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linmq006@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value
Date: Mon, 27 Oct 2025 23:09:34 +0800
Message-Id: <20251027150934.60013-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The qm_get_qos_value() function calls bus_find_device_by_name() which
increases the device reference count, but fails to call put_device()
to balance the reference count and lead to a device reference leak.

Add put_device() calls in both the error path and success path to
properly balance the reference count.

Found via static analysis.

Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/crypto/hisilicon/qm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a5b96adf2d1e..3b391a146635 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3871,10 +3871,12 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 	pdev = container_of(dev, struct pci_dev, dev);
 	if (pci_physfn(pdev) != qm->pdev) {
 		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
+		put_device(dev);
 		return -EINVAL;
 	}
 
 	*fun_index = pdev->devfn;
+	put_device(dev);
 
 	return 0;
 }
-- 
2.39.5 (Apple Git-154)

