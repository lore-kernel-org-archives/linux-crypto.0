Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793808581;
	b=MVrt1rvismuJYbrGQMDoMsV28u6G8njyiBxjf2oO93rghglI+7TlKUuyZxQIqMK2kdrQ
	 uyNqf63Tbt7f/dwlB+DLA/Dcye3D4ZJk6j/AOXsziOtHWsy2QRqckjRpojOw94AKZ6LsU
	 wgHGaMM571E8l7OU7PMGhFx/7Ubyte3uE8XVQzWfO+cd2OI7RslroJnfi5/VzYWZWFtWi
	 dcE/HIhgVWCQ46RVSI+yE1ffVvjeiGkdbg+NC4iC4BBoP91OD5jvP/+UZ5o5QC4VOhiep
	 euHn/zyLwkiuY0jMdl+l9fUPfvKkVKIlElyy/sNTaM7O7IAknhMPt5HsQC7PI3WptrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793808581;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=1INLi47J6sX/9lLM2V2LXwNIoIOyuzH9kEeqmJr0oEc=;
	b=cu6a89HIgGeLDahx2a9x6DTtJThvH8nfQ3w7v8cpWxkzoHT/9l4mfFFIhEEJSLOdS2h4
	 lFuUJr/Ai5SoU4kEf1KkiyxaXG20xTKlXxQuOVw//RqQlCltc5Yn4wKRF7/T8yeCyJe4q
	 IgIoFa0fYR7fHOHV1TPliRx6ecSDdOYjPRzBp3DxXsDfJEShhk/GvnajqfobE/7RnhA/J
	 EU5jA860Ri8D3kjXQe4PBATmPYI79ptEr2K5dTPDocjkKEU2c9gc1mpeAv88z6qK3Ehal
	 bS63f4qfnzwf+g44VOPjGBtdEhC0qxgdRtTzt2tL29A7LxJmPFWLv5hLPhcsZKdOfCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=thegoodpenguin.co.uk;
	spf=pass smtp.mailfrom=thegoodpenguin.co.uk;
	dkim=pass header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LASKncoP;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBFC606A328
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 16:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DBFC606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=thegoodpenguin-co-uk.20260707.gappssmtp.com header.i=@thegoodpenguin-co-uk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LASKncoP
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so7397295e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2026 08:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20260707.gappssmtp.com; s=20260707; t=1793808579; x=1794413379; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1INLi47J6sX/9lLM2V2LXwNIoIOyuzH9kEeqmJr0oEc=;
        b=LASKncoPj+DC6eRfOvbvLJRVuD30FXYsGdf91pLHBjrH8tqqVZoeDgSZbQSo2wvvkY
         LW3BbUjIhOSPyvCMOM3iRo8l6s2i5YxVCD2QZi7ZEeJQDIItW8iAuWDIJ3OfQVOxfd/x
         vpbqabnxVDYnaO9daH6hmfSjfHSznyGvI6A6JtdTcRVcQBRWLAcRKtuad9slHsOKT+vq
         m8lr4fd+b+D+KIdnDh4vw3UnWkMgciAcxPSGUrLQfk9PBPDNgU0rW/TMYBkh1cR0n+Wo
         hspP8+/9qDf8Wy4922qY7GTy+8uFyUiYDu1P8I11E17ARYrHP/LPTno61GfWEq0xcm/h
         NhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793808579; x=1794413379;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1INLi47J6sX/9lLM2V2LXwNIoIOyuzH9kEeqmJr0oEc=;
        b=wTiooIUgNGrfayqADsNpA4M1ndH7f+zRglk9a52wwayVzva1KHMHae87XbJwco9a4v
         O0du/jSCFoZwAVNZP3xgNWxXznG8HHAqs/poqjLfdi39OKuG3VF6dRXXZ56qcXQu8ERu
         XPqbgAbjBO5OVtF94NFRI9rLhPKXZ9eWEedBavdnr5pmPYsQmytmbw3eCI4REBnoc4q5
         shenIXlVJl2dSZPrR1JdJ+vNYQmrxDpslood/yPgYbZlbLquQ8/XZmPWbGax9Tpc/A6Q
         U2slFZdEGExZY3yVuQaZga3NeSq3NtdG+iBoeilC0WcHZGuFHMYunBnZYmTFHzIakuVv
         C0lg==
X-Forwarded-Encrypted: i=1; AKwUvByvpCli8PcOmV3SFtVjqhVFggc1+AtEtxr8RA5F3Q/dGFfwzfSxJwxaA6MA1kEd6xf+eaOYnbOXOnD1a10=@vger.kernel.org
X-Gm-Message-State: APuU4Z8DNgAw1MTft2w0Ztp86+9HuFHWfv4wXo1rxiZ6cAxZWaGkTej4
	jNKIC27vY7PPSwGlOqK5rvmJAEZfmDOTDxq91srRcmLDXjB6vFMn5lVvNJm2OX0523s=
X-Gm-Gg: AYBFou3vK8Ica9f4p6kmM2Xqea8CokICOSP169fs3ueTlOVj32cyAOl6uRUaPmOKAie
	GLONRme9Xo/PkTFnAaWXRGKPk5CgzfI9E/gR0WAOkkSGCXC9FhlaYxgIXTBaV8bKoa34soHEoUv
	sF/pj+NaePTyKOCPqMpNmbJJ9Q4i8JqMQ2ZfGmiq1TBCBYkfzF+BbtGiTA7qJUz8Aiw29QsDCdl
	5+88QkFqlNog+grmLGYPb+Kb1WZwzbZUp0jTAAnWc7je2DtP9cuEh2MHKxx+oigFWuHBQ2opHn2
	qSFugnNjqNPbxHPLz/IYQPR4qxK63Lx7F+xNtXtUJ+zK2S4+DZfTAnNhR+wlOH+tO5Zlo3FvJ99
	fQeq5/AUPgiDPCRdDWzwXBSaYwXDz3BnAVhobgxl8UmtCegeytf8HpTVuJ6pww4E6cgMzM0nIVE
	0mag7iC0VJQulL+Miwu3+400XI4BG0pFbmdDZoDrGFj1zIzANbmocTW2XGd2YZkHVst7iIrhGqD
	zRsiEuiDGi6AcI9+i4NMfgL2jATAdCfY4bZR3tyDOq4/Q4DYjZrcVMKqClE41GW1cYDgC+pfJ2J
	ZcxPLBV5KuxCk2N40X2h51Fv65t3ESc6ruJLAcxRof/ncA==
X-Received: by 2002:a05:600c:1d02:b0:4a0:1c94:7042 with SMTP id 5b1f17b1804b1-4ac16bc4731mr408199185e9.8.1793808579070;
        Wed, 04 Nov 2026 08:09:39 -0800 (PST)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:458e:d526:4eee:2f63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4527fed5bsm85089815e9.3.2026.11.04.08.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 08:09:38 -0800 (PST)
From: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
Subject: [PATCH v2 0/2] mfd: use designated initializers for acpi_device_id
Date: Wed, 04 Nov 2026 16:09:29 +0000
Message-Id: <20261104-acpi-mfd-v2-0-64b9dee3baaf@thegoodpenguin.co.uk>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0WNQQ6CMBBFr0JmbUmnJlVceQ/DorQDjMaWtEA0h
 LtbYOHyJe+/v0CiyJTgViwQaebEwWdQpwJsb3xHgl1mUFJplGcpjB1YvFsnjDa2cqj1BRvI+hC
 p5c+eetQHp6l5kh23/Wb0nMYQv/vXjJt3ZFGqf3ZGgcLlL1VVuUzX+9hTF4IbyHcT+9KGcnpBv
 a7rD6JmhzW9AAAA
X-Change-ID: 20261030-acpi-mfd-a6ac9d16671b
To: Lee Jones <lee@kernel.org>, Chen-Yu Tsai <wens@kernel.org>, 
 David Rhodes <david.rhodes@cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Mika Westerberg <mika.westerberg@linux.intel.com>, 
 Zha Qipeng <qipeng.zha@intel.com>, Qunqin Zhao <zhaoqunqin@loongson.cn>, 
 Thomas Richard <thomas.richard@bootlin.com>, 
 Andy Shevchenko <andy@kernel.org>
Cc: mfd@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-sound@vger.kernel.org, patches@opensource.cirrus.com, 
 linux-crypto@vger.kernel.org, 
 Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>, 
 Charles Keepax <ckeepax@opensource.cirrus.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793808577; l=3284;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=VoE1Fm0xZu0mayKQlGhQQZLIaRumf/QdmutseQMZPwA=;
 b=uybqUEyxjF7iAKy9pKtXAKAQ4dhu98wji8c2TC5h8NLcf/sZMMgMUqqVTNiO6oIJkkWAN26vq
 nWMg9/1QuTnB3bWLAzs8CkPtkkNt8REQo+74FNLy12d6dPmtivfG8A+
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

This series is converting lists that contain the acpi_device_id struct,
which is defined in the include/linux/device-id/acpi.h to make use of named
initializers (which they do not use currently). This work is part of the on
going effort in the kernel associated with device-ids [1]

The plan is to convert acpi_device_id::driver_data to have an anonymous
union, similarly to what was introduced for PCI and I2C device ID tables.
The goal is to increase type-safety (most of the existing casts are gone),
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
- pre-clean-ups that convert the lists to use named initializers
  (which is this series)
- actual implementations that make some of the modules use the new
  driver_data_ptr member

That way the task can be fragmented into manageable and independent chunks
of work and makes this effort easier to review.

[1] https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylibre.com/

Signed-off-by: Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>
---
Changes in v2:
- Split Intel LPSS into its own patch.
- Added a review tag from V1.
- Link to v1: https://patch.msgid.link/20261102-acpi-mfd-v1-1-d61029971be8@thegoodpenguin.co.uk

To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee@kernel.org>
To: Chen-Yu Tsai <wens@kernel.org>
To: David Rhodes <david.rhodes@cirrus.com>
To: Richard Fitzgerald <rf@opensource.cirrus.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zha Qipeng <qipeng.zha@intel.com>
To: Andy Shevchenko <andy@kernel.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: Thomas Richard <thomas.richard@bootlin.com>
Cc: mfd@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-sound@vger.kernel.org
Cc: patches@opensource.cirrus.com
Cc: linux-crypto@vger.kernel.org

---
Pawel Zalewski (2):
      mfd: intel-lpss-acpi: Use named initializers for acpi_device_id
      mfd: Use named initializers for acpi_device_id

 drivers/mfd/axp20x-i2c.c              |  2 +-
 drivers/mfd/cs42l43-i2c.c             |  8 ++---
 drivers/mfd/intel-lpss-acpi.c         | 58 +++++++++++++++++------------------
 drivers/mfd/intel_pmc_bxt.c           |  2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |  4 +--
 drivers/mfd/intel_soc_pmic_chtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_crc.c      |  4 +--
 drivers/mfd/intel_soc_pmic_mrfld.c    |  4 +--
 drivers/mfd/kempld-core.c             |  6 ++--
 drivers/mfd/loongson-se.c             |  2 +-
 drivers/mfd/upboard-fpga.c            |  6 ++--
 12 files changed, 50 insertions(+), 50 deletions(-)
---
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261030-acpi-mfd-a6ac9d16671b

Best regards,
--  
Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>

