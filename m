Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DD326E6E1
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490903; cv=none; b=t8R4gPf0v+ZfTnZhVqahQyRwAcp5O7V6rw2HRA+z+igtQZ6eWYivxauQp+dhypfgtQOjRcssvQ1lXtX8M9TcGpEv5L0nKgqSVRMwEUMPNlpnBZh16uMfPxiDzyMs+JuGi4ZK6djItqjkI/Mg3q1CuJuNml85jt+s7UrgdZHJOWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490903; c=relaxed/simple;
	bh=iuMEjfjDUMd4AbOPk1EOV0XIzooLS+4evH0xt/olMQc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cOMYtrSAf9pQWUqFSwvhvtyYr0iwUPF9T5HyFh95MNSr9DvVJpsUzx101C0b+XNIbF8ySh26a6D1p+cngtuKY+DIgqBRXEw/vZ4V/oXL0yBhobirA4N5RBmvaqPQ6dRMYzzTm1ohpcObhtlQ3f6n55QVyivCStsfGaaWhFRTRW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EGW338Sj; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EGW338Sj"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44b729aa7c5so839676f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490899; x=1780095699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ1t8TITeIzqYfvXIOImRBm/6eBqY77bSs40Iip+zDk=;
        b=EGW338Sj7P67oPHs2bKOzoi5qrv1pIRYkk2lvPXtqmC4QPOi/3bfsJM45jFjAU6r6X
         8imfR7kX4yG5WB1VXb9lYEtIMaOsa6dF4V72KybD0C4wq0C1nzKMD6SVRbdeBc59AKFN
         L3886Xunw30i0GJs7KTS3S8ITHjMHU5Qf3ymgAbj+w/YmkUQzYgOmHLYrIzoGvGilnxY
         jTNBXL+zIseJ5Yzc+Q3LOU7fi6rkCZInfBK0Xh+M7PeNm7NmMTZxudN5i2v/bvO86rxh
         Wfpx2gQ26JrhBcjrRLXER2nGg84lxBr+xpMGV9snizTGNJzVRW+DKbuK6mvzkT/Xi5kj
         saow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490899; x=1780095699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZ1t8TITeIzqYfvXIOImRBm/6eBqY77bSs40Iip+zDk=;
        b=hD1Gi9PDa+RGlyMdJ54G69ewOPuFpzebJBJ9T0BPz0FzOpgefN+KdQSr1WUfpPWVKb
         QH7N18j4h/VEXhiQ85XH9oFKkn2+WYf99xbkoDQV6fLQoEebiKonWQs1Wqnou9k7FOL6
         0w4sf6SY8Gfs8zQlFTUgCcFjud++VmOOonS82ft+Be2W550hb8lAdmMJ9fMpx7NqIrgi
         RhjR2V1/jrDBonleqQIFCKV3TFLyUAl6twsUgDIPI2qFUIBXXP+aJUuMy9qft9AMwNQT
         5dpCFvJ9AtKGVhi+8WSrAvBfSFqB1WixCAjjFhtOjMLKeheNSl7ibqu+FDDc48fZxS3u
         +c6w==
X-Gm-Message-State: AOJu0Yyec79tBjdGzNgDSQzqYMhLIvtPOm+uUGB2LPGXgom6KlMcZRIZ
	ANheDiR3ML6MPO/1D8+4Zh7juXsnhiHVVZzOsighYo/IM4HgYRQUC1Pw
X-Gm-Gg: Acq92OG9HawwXCWEtK1M8Ek9tf4VvoA3Aycn3UW6y6TSiTxv/piouq/Gh6fp0JG79XB
	J8FGXUeBJPXpa3N7VWIGy52UyjOiaxBZIwJYYAoCtfxupAnzunvVEYFP3xZXdgzgtag8zW929bT
	w1pMmshiqsDGL4p/caF7kIbUlj9TzLr/ijgDeeSsC60MZ0lrvGDFMF6kDjyDILQ3Nfp2RC1/dp1
	jhm2aJp4fw0tDz0dQrX3v+GkxI+5HTPC3tmKPk7tHAhCk4/M8u/iXnLyTz6F90uext/8BTWSdCu
	uh6r1oHeACK8hw2H3YZtkQZoORCnAXNGWjrylFolO3nG1AbyqG8sJnFfnV8UwON4ZtKl+6xGI3F
	Ep0D2w+HHQ5EntsUaynfPzQBQEqoa2IuUQYywFzOrNm3xi/HJnF6w+S/kwF5+7381RyMHP+90Oh
	GP2HxUnpDb/p2qElbO/ZkLuSRJQeuVhtDpfc0Q7EkCAJulBqyZmbh84tYTY/nimXfhsG6qRdGIi
	Q==
X-Received: by 2002:a05:600c:474d:b0:490:3d89:4bd1 with SMTP id 5b1f17b1804b1-49042ae9a03mr34525745e9.5.1779490899184;
        Fri, 22 May 2026 16:01:39 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:38 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v4 00/12] crypto: atmel - introduce shared i2c core client management and capability-based selection framework
Date: Fri, 22 May 2026 23:01:22 +0000
Message-Id: <20260522230134.32414-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series introduces a staged refactoring of the Atmel crypto I2C
drivers in preparation for a shared core-based architecture. The goal is to
consolidate I2C client management and selection logic into a common
atmel-i2c core driver while keeping ECC (ECDH) and SHA204A client drivers
functionally separate but interoperating through shared infrastructure.

The series moves existing ECC-specific client tracking into a shared
management structure, relocates allocation and selection logic, and
introduces capability-based filtering for hardware selection. This allows
individual crypto drivers to request hardware clients based on supported
features while still benefiting from a unified least-loaded selection
strategy.

Subsequent patches extend this base by:
- migrating client management fully into the core driver,
- introducing explicit capability advertisement by each hardware client,
- updating ECC and SHA204A drivers to participate in capability-aware allocation,
- and cleaning up probe/remove paths to ensure consistent lifecycle handling.

No functional behavioral changes are intended at this stage beyond internal
refactoring and preparation for future feature expansion. The series is
designed to preserve existing crypto functionality while gradually
centralizing shared logic in the atmel-i2c core layer, reducing duplication
and improving maintainability across all Atmel crypto drivers.

Note, this series is a more elaborated part of a bigger refactoring,
sketched out here:
https://sashiko.dev/#/patchset/20260512224349.64621-1-l.rubusch%40gmail.com

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
v3 -> v4:
- sashiko feedback[3]
- fixes and patches reordered
- fix: cover a possible memory leak at deregistration and subsequent reregistration
[3] https://sashiko.dev/#/patchset/20260520155703.23018-1-l.rubusch%40gmail.com

v2 -> v3:
- sashiko feedback[2]
- ecc: reorder setting ready flag in probe()
- i2c: unconditionally call flush in unregister client function, to avoid UAF for multiple devices
- i2c: fixed a sleep-in-atomic bug by moving atmel_i2c_flush_queue() outside the spin_lock section
- sha204a: reorder calls in remove() avoid UAF flagged risk
- sha204a: rephrase commit messages
[2] https://sashiko.dev/#/patchset/20260519204803.17034-1-l.rubusch%40gmail.com

v1 -> v2:
- going over Sashiko feedback[1]
- rephrasing commit messages and titles
- fix: introduce a ready/state flag to address the UAF risk
- fix: add kpp lock and refcnt to impede overwriting global driver struct
- fix: explicitely clearing rng cached buffer in return branch
- unregistering ready state by dedicated function
- reorder Atmel ECC related things and atmel I2C at beginning
- reorder Atmel SHA204a related things behind introduction of cap
- patches dropped: NULL checks in remove functions
- changed to EXPORT_SYMBOL_GPL
- additionally to alloc hw client also migrate freeing it to core driver
[1] https://sashiko.dev/#/patchset/20260517180639.9657-1-l.rubusch%40gmail.com
---
Lothar Rubusch (12):
  crypto: atmel-ecc - fix use after free situation
  crypto: atmel-ecc - fix multi-device kpp registration
  crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
  crypto: atmel-ecc - rename driver_data before moving it into atmel-i2c
  crypto: atmel - rename atmel_ecc_driver_data to atmel_i2c_client_mgmt
  crypto: atmel-i2c - move client management instance into core
  crypto: atmel-i2c - introduce shared teardown helpers and fix queue
    flush
  crypto: atmel-ecc - switch to module_i2c_driver
  crypto: atmel-i2c - move shared client allocation logic to core
  crypto: atmel-i2c - implement capability-based client selection
  crypto: atmel-sha204a - integrate into core management tracking
  crypto: atmel-sha204a - switch to module_i2c_driver

 drivers/crypto/atmel-ecc.c     | 177 ++++++++++++++++-----------------
 drivers/crypto/atmel-i2c.c     |  77 ++++++++++++++
 drivers/crypto/atmel-i2c.h     |  18 +++-
 drivers/crypto/atmel-sha204a.c |  48 +++++----
 4 files changed, 210 insertions(+), 110 deletions(-)


base-commit: 49e05bb00f2e8168695f7af4d694c39e1423e8a2
-- 
2.39.5

