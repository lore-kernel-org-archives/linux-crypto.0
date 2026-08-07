Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392024302E7;
	Fri,  7 Aug 2026 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101979; cv=none; b=rgTtl+zoroioHMNHH/Oqx2E63sB6L+cbbxZ3RmlCkfNRbnB937q3hypZDJxKhe7iVENyB4N4kI+qAI+E4bPpUzAUYLl0Le+YrohJb9XxqhEz1g77XpDUQCODGoWebDhqGFMZet93+3XhvEG509h23SFeOoKztPI6UZVk/gaamN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101979; c=relaxed/simple;
	bh=5YH4OupiPVo5NYgT2GzQ1B//oZTWncXO4yg7L+WC4DY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WovLSkx+pdP/clGl0eGeid9xKVBRGjW40qtY03A5fJLYYHP7VDteeYlCdJ8iPVTtR2rTwrefiWwFCaXCrPpPYEonVzJugwkmv0AwbVwmRYRh/5oLyKafFFeGlOnP6kLuMMPJbsOHO4ZxbJ58ZOYc4hqer4sU0dR/9UetBoPphXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ES4FOK5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ES4FOK5L"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D201DC19425;
	Fri,  7 Aug 2026 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786101978;
	bh=5YH4OupiPVo5NYgT2GzQ1B//oZTWncXO4yg7L+WC4DY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=ES4FOK5LmW3T1WfIV53jjdA0kIDZRbMqU8I1hY4H1zi18YMss+7jUPmBKrdCzAoL2
	 AlS9HDu4PLHHkrEpJHgcCDu+WLZmCL4AFcLNwA20i2mjF/kjV6Ys2iBicRxfyebWtd
	 tO01xjvajAXYDKfp+FYR2L8iip0yGI0mKSfGWMNW0mCmm62sor13+fpcl26zCpD1j7
	 XG21cu8wys+7f2WekdBYPVENXQOM6qmujbXVmuvd+GJYWgofjL/nH8bV5jvJM8VYVl
	 Ywu9YA7cqY7VPhTMIs0k+XJtWcqZ90ZVaseBaSvYlxqmzEzKBahS1/IDuv69/tNkVn
	 Fwo026wizYm7g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD357C2A09B;
	Fri,  7 Aug 2026 11:26:18 +0000 (UTC)
From: Pawel Zalewski via B4 Relay <devnull+pzalewski.thegoodpenguin.co.uk@kernel.org>
Subject: [PATCH 0/4] char: use named initializers for acpi_device_id
Date: Fri, 07 Aug 2026 12:26:07 +0100
Message-Id: <20260807-acpi-char-v1-0-742c450254dd@thegoodpenguin.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqAIBCF4avIrBNMS6KrRAu1qaZFiVYE0t2zW
 n68x58gYiCM0LIEAU+KtK0ZZcHAzWadkNOQDVJILRpRceM88TwFXmtVamOlHYSC/PcBR7q+Vtf
 /jodd0O1vAO77ATA9ONZtAAAA
X-Change-ID: 20260804-acpi-char-56316ab2bd03
To: Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Mattia Dongili <malattia@linux.it>, Weili Qian <qianweili@huawei.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Corey Minyard <corey@minyard.net>, 
 Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
 linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net, 
 linux-integrity@vger.kernel.org, 
 "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786101977; l=2628;
 i=pzalewski@thegoodpenguin.co.uk; s=20260803; h=from:subject:message-id;
 bh=5YH4OupiPVo5NYgT2GzQ1B//oZTWncXO4yg7L+WC4DY=;
 b=NA9cF3yI3G/BlKzZxVpLLEfNwbAVtxJvSfEditTvaz3eLv9d9F76mjHh+vdh51KaaXZBAOBBk
 pz0pPkhM/RMCL1CtormNODpEEEv98rEcOhrjklgX0piQSVvDX/KXx4q
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=W3zk1cb/wRnj6pNGbl3/2Zf3GmPA6IBpNHpDPyJ05k8=
X-Endpoint-Received: by B4 Relay for
 pzalewski@thegoodpenguin.co.uk/20260803 with auth_id=913
X-Original-From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Reply-To: pzalewski@thegoodpenguin.co.uk

This series is converting lists that contain the acpi_device_id
struct, which is defined in the include/linux/device-id/acpi.h
to makes use of named initializers (which they do not use currently).
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
initializers first. I already have patches that implement this and touching
a lot of kernel subsystmes that use the acpi_device_id struct and that list
keeps on growing. Therefore, I have decided to split the series per every
subsystem into:
- pre-clean-ups that convert the lists to use named initializers (this series)
- actual implementations that make some of the modules use the new driver_data_ptr

That way the task can be fragmented into manageable and independent
chunks of work and makes this effort easier to review.

Tested builds on a64 in Yocto using 7.2-rc6

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
Pawel Zalewski (The Capable Hub) (4):
      char: use named initializers for acpi_device_id
      char: hw_random: use named initializers for acpi_device_id
      char: ipmi: use named initializers for acpi_device_id
      char: tpm: use named initializers for acpi_device_id

 drivers/char/hpet.c                   | 4 ++--
 drivers/char/hw_random/hisi-trng-v2.c | 2 +-
 drivers/char/hw_random/xgene-rng.c    | 2 +-
 drivers/char/ipmi/ipmb_dev_int.c      | 4 ++--
 drivers/char/ipmi/ipmi_si_platform.c  | 4 ++--
 drivers/char/ipmi/ipmi_ssif.c         | 4 ++--
 drivers/char/sonypi.c                 | 4 ++--
 drivers/char/tpm/st33zp24/i2c.c       | 4 ++--
 drivers/char/tpm/st33zp24/spi.c       | 4 ++--
 drivers/char/tpm/tpm_crb.c            | 4 ++--
 drivers/char/tpm/tpm_tis.c            | 4 ++--
 drivers/char/tpm/tpm_tis_i2c_cr50.c   | 4 ++--
 drivers/char/tpm/tpm_tis_spi_main.c   | 4 ++--
 drivers/char/tpm/tpm_tis_synquacer.c  | 4 ++--
 14 files changed, 26 insertions(+), 26 deletions(-)
---
base-commit: 848acc8ffe1b7cd5f1bf427b93069becfebc2c9d
change-id: 20260804-acpi-char-56316ab2bd03

Best regards,
--  
Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>


