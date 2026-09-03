Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAAC4E80D8
	for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2026 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450154; cv=none; b=KZ48zNwGC9vgZbrChBb82OzrqrZKWaVpiN87RQQf/PqcVUN1wPo5cz54nVd0f9xlf3RLpPwBrH0q6bnzJjzGrR8/biHjW4pXKt/Va6NxhUysKEEb7ObTawOrphkTsFsju0KR5xZOhlqW8sIVSmBUt+mTfnJkgS+HXHCXQwgz8+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450154; c=relaxed/simple;
	bh=7fppAZeChUxooPl+rWGwhu1bfVHc8dwbjHhvmyHa0gc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Otfos42Nakrj1o/vfscgYnTOyFQQzFYosD5O3ORXzR2eRI/rttHAGI+8ca/BZNhtSfdpNd4X/Tfow/D8iAyyH8GnQh5p2LYAqwrLih6QekUyyc+nSg4wylLXl2p/4gu1olJocJ9PaAW0aY/cTgg+IatrU5do1J2tmTCQWAVM/xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=C7amkO7B; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="C7amkO7B"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbedf433a99so50867a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2026 08:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1788450152; x=1789054952; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q7VpLbdfdRaMXmxM4Mf8jv+lQMVFUzyhevVNALl44og=;
        b=C7amkO7B4w7aX7uiGHO4Uj4JL0+QZ458uGkRN5GXjJ4JYUq/uClQeYAHWKz8ckuJr0
         Q/9ycw6jmFx/gkUiYBEyFYOG99z5qn2p3gIqbi9WlITw3Qy35UCiKzChKnJHe70SGHXk
         xTy/motZ39tUTSX98pRDVO/usay1eJYuOOj8NAl0RezRRC++n5B22kwHoFsr0bk53j/K
         kNJg4vwpJVOUhJwcyeLMEazZ67IQqHceP4oLck2tHKBtbf4e0hYKKaGznbA0xtfT21Kw
         uq4aV3Tig2WH4h/7bA5VjB7I5nM7BayTZPH6vi7r65AQQXJEqu9hjh+aWL4bJ5DvQFxN
         Rbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788450152; x=1789054952;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q7VpLbdfdRaMXmxM4Mf8jv+lQMVFUzyhevVNALl44og=;
        b=bOsnBrXAApZ9iPCtDnblhLTZrUYh0yhh/9ALsHn5+NbWbsbP/LsgNQcpIYGPJGW5oo
         m0GmNA5LaaIIF6Ew49HU/q3E5rpIQ3RF909mqNEvEGCaIJrTJ0qOQ/ixXK6H+XMChFa8
         2gh3d6sRD0e2maezR91SYwMxB7DmV1dBHD+x6QGLWsEGmGmx2alqHVNBPH8XbGaPSGRo
         K7PFsBEvzWcBmR2UarGsIe4ulBrrPO2ggDfSFrnQMsLtVPNAxnaBnK6y4TClonMT/XNz
         fVzTiG+slfFEXZjUNt0YWP7nvVdkebCh+TAgJy7SVGaPoyTHtUbAOnEAIh5AbMCCR8bI
         RoJg==
X-Gm-Message-State: AFuF++naM0zjvDaShTAr2Q3rySYJxRHDviv/04BNaSGAdlhWPFHHwKEc
	9ka8M2ocJDPwFo1+Urot1ntkCOogLw8bAJ5Kgtf84CfEyBgV/d0lPRKq5Rojhh8iNIc=
X-Gm-Gg: AYBFou1b8dRzo0hSuI6D5hA0CMnol9V9P46RqTB0ynAxmIMHhE10cUrfVgjhu+qQX43
	vKpHIQCsKrjE2P1ky6BWIgBXOt69+63VqTUNi9Hn+H/3fBjK8hIfkc705hSFRYmZ3LjtpDrmOd2
	jIqiqwJrx79XPuqmoheDnpKdPetz/HgIXPW5d6ZReJDWFuEHSmwNtnbpkoG6m0A+l/Ah8UM4Lna
	bEW76W52Cene+lu34N7yxhGOoHPC1CvYBy4Dl7oQiACCrXNZxKJaqLOclDll6AoHAb4H9zNRkoL
	2ZRcvsCHeC0AtMGTf274+rFhOjWVAhu1HjIwP/gwyDkgzrkGutHd+kuDN4meElVMUwt12q2fnjy
	7rhuVkspzh7SCg7aGvfYR1K6xTVTerYjOCD6d7Mh9GAYseKWbguaRd5EhM1dvSIgKCfS4A24vzg
	AmBFIg55wQ879tgTMwcxmrG0Gs7pAgp+Js/HJTdCoctRhK204PzJ++1Dl1JsmF/4BXvRKusEZlh
	nSLcw==
X-Received: by 2002:a17:90b:1c07:b0:398:9be5:b41e with SMTP id 98e67ed59e1d1-39b232e2f86mr724416a91.25.1788450151857;
        Thu, 03 Sep 2026 08:42:31 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:521a:d95c:2f1e:64be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14324356931sm522926c88.4.2026.09.03.08.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:42:31 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Subject: [PATCH 0/2] crypto: use designated initializers for acpi_device_id
Date: Thu, 03 Sep 2026 16:42:15 +0100
Message-Id: <20260903-acpi-crypto-v1-0-253cc6fd9836@thegoodpenguin.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFeVmWoC/yXMQQ5AMBBA0avIrDWZlki4ilgwBmNB0yKkcXfF8
 i3+D+DZCXuokgCOD/GyLhE6TYCmdhlZSR8NBk2BJWaqJSuK3GW3VZEu+hyzQaMxEAvreJDzu9X
 Nb793M9P2LuC+H6zk/FtvAAAA
X-Change-ID: 20260903-acpi-crypto-c16d403f1022
To: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788450148; l=2070;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=7fppAZeChUxooPl+rWGwhu1bfVHc8dwbjHhvmyHa0gc=;
 b=iGtdnQej8tebA3hOpURWq045vZyBw8e23H2zOCZMV9bxp4YnlyPwbfMhXA3Mb3sSbFR0qh2VO
 aygW4aab4E5CEaX9nt9nMOCb8oiX1/rXgbray7OkOIh0fcshBJQ9mq/
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

This series is converting lists that contain the acpi_device_id
struct, which is defined in the include/linux/device-id/acpi.h
to make use of named initializers (which they do not use currently).
This work is part of the on going effort in the kernel associated
with device-ids [1]

The plan is to convert acpi_device_id::driver_data to have an anonymous
union, similarly to what was introduced for PCI and I2C device ID tables.
The goal is to increase type-safety (as most of the existing casts are gone),
to improve readability and to make use intent a bit more clear:

```
union {
	kernel_ulong_t driver_data;
	const void *driver_data_ptr;
}
```

But for that to work all lists containing the structs need to use named
initializers first to avoid triggering -Wmissing-braces. I already have
patches that implement this and touching a lot of kernel subsystmes that
use the acpi_device_id struct and that list keeps on growing. Therefore, 
I have decided to split the series per every subsystem into:
- pre-clean-ups that convert the lists to use named initializers (this series)
- actual implementations that make some of the modules use the new driver_data_ptr

That way the task can be fragmented into manageable and independent
chunks of work and makes this effort easier to review.

Tested builds on x86-64 and a64 in Yocto using 7.3-rc1.

[1] https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylibre.com/

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
Pawel Zalewski (The Capable Hub) (2):
      crypto: ccp: use named initializers for acpi_device_id
      crypto: hisilicon/sec: use named initializers for acpi_device_id

 drivers/crypto/ccp/sp-platform.c       | 4 ++--
 drivers/crypto/hisilicon/sec/sec_drv.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
---
base-commit: 940de590b839f71d6dc846160534bf202401b8b7
change-id: 20260903-acpi-crypto-c16d403f1022

Best regards,
--  
Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>

