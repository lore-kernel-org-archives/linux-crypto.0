Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79792F5A2A
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428868; cv=none; b=UKI1ZkY9gpYP9sDFSTr+R0UVMEKnCrtBjTahFKm8X+idEpQo3f8RFf7cVGIXgULb+VFsoFnMl0HtvJUmudqB9GvN25gHPokyiOpLA834fpgOdYCJ/009CbnosaYlIDN0FurHQunXvj5pWIrfxMug61L9NT7TmWtLoYFOlNEpFRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428868; c=relaxed/simple;
	bh=VZT8DjBw0pDi2d80lXPUn2i9zyAtOd6ztqK1+017c7E=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=g4VUmvXjtuV3v1MLtjvPbPVNJKJBpMb/PiAfOvHM+6W2E9OhRoW08Uz46DRSPCXGOyI9E0bq4DVVRh3MC3a9IGKdG8D/6CfZAZsSvJuktYhosk7+S0urCAwP2k2fwfmz/oDojNlWpcM/Pu4TexX9OW9pCyJH2mfed1X6gTuP7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=FCjp/uzS; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="FCjp/uzS"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4775ae77516so9903125e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 03:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1762428863; x=1763033663; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WmQCBkHqq42jVJNYRjft2vvRlX31c4/KY+a2FbtNOuw=;
        b=FCjp/uzSHiyRq8AMqZiHXV/emDTy59Os3xjVmcDUjWZfO1Ovp4iNB5bzS0h/gkmC5E
         QpfUNA+JMCHO0usxNTSxsDbXlOR4Oew8/PgkFgf72ilbJ+mHo1oqgi8Za1BUwhoo3Xc8
         wrZkNYMCnYJe8oor63PXdq17GDh1aZD1LAFCXhtNOLoL3sdkIzYgFWAwBUnojPLbNpcD
         CUTAn2JowLeeruRwA7gmSBRDz6Xbi508GmKZ6D85W+ixSgZGEKFtOzMk+srcUzEtqYQZ
         tpsIl2fyE9mY9FUVdj3p3AGmvpB1Bej+n5WmetzF/HWqXTpdStHoTx5hoOvcOwv309an
         FMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428863; x=1763033663;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WmQCBkHqq42jVJNYRjft2vvRlX31c4/KY+a2FbtNOuw=;
        b=ZlqKSPI7//hPw0AHtIWbZO8ArpONTvyz0lH+R/mgxNcJ0mou2CiA0wp/n/AphAgdhv
         wDTuzC1S0rwjDTsZhsA7DrNk1SU4pp498Kd2K6ZaObeL21Y6h4tFcTCc/eruNp74vQAS
         S8LlQ21G4CyV7KnDUEKne6QXy/3fjZoqt7PiJxT2qfiq7KZ/S185ZAKpQ/PTSV7Pjy54
         /ymlOCfxz7ZO9D/ztH5Nzz+sNBY7YsgiCwRaY1djlkhWLuDrT6YdiZIKJZkkwo0MEoPw
         SBSUYhrCDRqQnxXHk//jyFpkFO5saUsdpmMeS7y3gqtcoasIsf0Z4WriKut9Wb2yN5K0
         ggOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa5WG+Lu9jFypcKyfgG1Ox27S97U4GqhKHQK/6InhfV+f30Ts1Ev4OXTC4qKqDnPTCECdnRDjyWZYaHlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPzT/v/9BVmaH7EC7bXT5gCWa/cRBiKBxAMfnHetkj/J1s1hFo
	4fXrEGpA/u/vz5uX1nXoY7vR3TikEVkXLlqnVn7Ohbc7JuYavI6G9pzkt4pupJ/5ZS8=
X-Gm-Gg: ASbGncun0gSuwd9Nom/PozK8cSGbWinjUp/vm76Laij482HiyA9yXTGtFlu6aV38kja
	8HD75otEN+dzmaXiht5X4nimBX15J3fC0uuwCB5lzHk8h1Q4drsar9kmgg5gzGd6bmhkKieUnG6
	e568JJESKThs3ZKLKEvo/opJfKMn2n+PjHprUxVS3gMGpLhJ8voJpWE9er673Cz/MBy4Ur4PuRu
	CqEgdA61jyCx0qwLTZlptuY7SGTlLULNr7ylS4aYVorRCx3WzLBrnI2JoV05wkyWZT6itiZJz3T
	BPEoKfP9ZMPp2JmYxGai94E5oFVBIDm6+4JYP42/Dn+D4n+RRb4vM6m28pBsEFnnhTXPoWlR+Yj
	WM6ijou6FZm03XC1GTG10oJF7jcBlcopmEKouE/B3Ma5il2jdTh9veKS9+lqPOnOIy27m
X-Google-Smtp-Source: AGHT+IHnGFjTZCysO/3IL83klEg0iWc82qrT0/YH9JfaI+/oaOJM3VLGt44LrBB6NO88nAKFPjNXzQ==
X-Received: by 2002:a05:600c:5249:b0:46e:37fe:f0e6 with SMTP id 5b1f17b1804b1-4775ce14b16mr59856885e9.30.1762428863190;
        Thu, 06 Nov 2025 03:34:23 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:d9de:4038:a78:acab])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb40379esm4389459f8f.9.2025.11.06.03.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 03:34:22 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH v8 00/11] crypto/dmaengine: qce: introduce BAM locking and
 use DMA for register I/O
Date: Thu, 06 Nov 2025 12:33:56 +0100
Message-Id: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKSHDGkC/x2MOwqAMBAFryJbu5AoEfUqYqGbp27hLwERxLsbb
 AammHkoIigitdlDAZdG3bckdZ6RLMM2g9Unp8IUzlpT8in7mgCW1bNHlMDi0IzWTqhMQyk8Aia
 9/2nXv+8HeBO+qmQAAAA=
X-Change-ID: 20251103-qcom-qce-cmd-descr-c5e9b11fe609
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Udit Tiwari <quic_utiwari@quicinc.com>, 
 Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
 Md Sadre Alam <mdalam@qti.qualcomm.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Dmitry Baryshkov <lumag@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6129;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=VZT8DjBw0pDi2d80lXPUn2i9zyAtOd6ztqK1+017c7E=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBpDIexFrYNzcmVKfajeDvFY8fI0d2v4+XCRF/Ja
 lmtImJLgYCJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaQyHsQAKCRARpy6gFHHX
 cn/eD/4to27edxvPrrlR+95XXl9OFo7b1gAf8AszSDyxSXOGIHcuH3wimg4DOy0NwQTRyyEyYS/
 tkcl4o7Zruw7XyiNGfg4F6uobDs645hZbt/U57ZtVSgoBRjRHeKNVd2JexB4FyRbGYgu4yhrQRZ
 6JATqN8QsaXjQpdljml4VL1ke9UyBrMESdPS45U2Yng2vq9y0zhs3TwjQYzXwv8rJKv1ofmwVAP
 L0lca3FsG1CuAl4IfuAsWakavOqFIVq8KKVWMbPumhFgtpBLrLNZRSYJOqpel0YBuR/i/rdRxqv
 Tzmmrh0Bw5PdJKRpkpyaR3DOT1OYa9cvkVNSulmt7ifFjL16IBrLPNtoe7VfiwJTThPg9T2Yx2x
 Cvf8LdFHFW2mT4J7/E85U+FH/aZ0QEeMX3k7yyf0tSD2IXV72WpXNf2+cDnoluJ5vhPrhlh53IM
 itlZUssCR6FRcIZe8JYQ343xcjSrP+2Pin/T4Mob0j1xKZSm/EeqDepxH/xeluBNp0J756SjnEB
 ZFk+IRxg81PaMfcFySbfZ2IzOxWlini9OXywAz64DnVvJGK/3lIFHL4MM6OvfkL+D084i8l7D4a
 hLpj01hTqlfV6+fpI/kVPU0CPzQXM9dkXnsEHz4YmWog2ZT5/Ez/dphiu1U4fyV1GCvFzbjoAme
 1wIJNhM6SSO1ffA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

Currently the QCE crypto driver accesses the crypto engine registers
directly via CPU. Trust Zone may perform crypto operations simultaneously
resulting in a race condition. To remedy that, let's introduce generic
LOCK/UNLOCK flags in the dma engine API that allow linux to request a
DMA controller lock for the duration of the transaction.

In the specific case of the BAM DMA this translates to sending command
descriptors performing dummy writes with the relevant flags set. The BAM
will then lock all other pipes not related to the current pipe group, and
keep handling the current pipe only until it sees the the unlock bit.

In order for the locking to work correctly, we also need to switch to
using DMA for all register I/O.

On top of this, the series contains some additional tweaks and
refactoring.

The goal of this is not to improve the performance but to prepare the
driver for supporting decryption into secure buffers in the future.

Tested with tcrypt.ko, kcapi and cryptsetup.

Shout out to Daniel and Udit from Qualcomm for helping me out with some
DMA issues we encountered.

Merging strategy: either an Ack from Vinod or an immutable branch with
the DMA changes for the crypto subsystem will work.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
Changes in v8:
- Rework the command descriptor logic and drop a lot of unneeded code
- Use the physical address for BAM command descriptor access, not the
  mapped DMA address
- Fix the problems with iommu faults on newer platforms
- Generalize the LOCK/UNLOCK flags in dmaengine and reword the docs and
  commit messages
- Make the BAM locking logic stricter in the DMA engine driver
- Add some additional minor QCE driver refactoring changes to the series
- Lots of small reworks and tweaks to rebase on current mainline and fix
  previous issues
- Link to v7: https://lore.kernel.org/all/20250311-qce-cmd-descr-v7-0-db613f5d9c9f@linaro.org/

Changes in v7:
- remove unused code: writing to multiple registers was not used in v6,
  neither were the functions for reading registers over BAM DMA-
- remove
- don't read the SW_VERSION register needlessly in the BAM driver,
  instead: encode the information on whether the IP supports BAM locking
  in device match data
- shrink code where possible with logic modifications (for instance:
  change the implementation of qce_write() instead of replacing it
  everywhere with a new symbol)
- remove duplicated error messages
- rework commit messages
- a lot of shuffling code around for easier review and a more
  streamlined series
- Link to v6: https://lore.kernel.org/all/20250115103004.3350561-1-quic_mdalam@quicinc.com/

Changes in v6:
- change "BAM" to "DMA"
- Ensured this series is compilable with the current Linux-next tip of
  the tree (TOT).

Changes in v5:
- Added DMA_PREP_LOCK and DMA_PREP_UNLOCK flag support in separate patch
- Removed DMA_PREP_LOCK & DMA_PREP_UNLOCK flag
- Added FIELD_GET and GENMASK macro to extract major and minor version

Changes in v4:
- Added feature description and test hardware
  with test command
- Fixed patch version numbering
- Dropped dt-binding patch
- Dropped device tree changes
- Added BAM_SW_VERSION register read
- Handled the error path for the api dma_map_resource()
  in probe
- updated the commit messages for batter redability
- Squash the change where qce_bam_acquire_lock() and
  qce_bam_release_lock() api got introduce to the change where
  the lock/unlock flag get introced
- changed cover letter subject heading to
  "dmaengine: qcom: bam_dma: add cmd descriptor support"
- Added the very initial post for BAM lock/unlock patch link
  as v1 to track this feature

Changes in v3:
- https://lore.kernel.org/lkml/183d4f5e-e00a-8ef6-a589-f5704bc83d4a@quicinc.com/
- Addressed all the comments from v2
- Added the dt-binding
- Fix alignment issue
- Removed type casting from qce_write_reg_dma()
  and qce_read_reg_dma()
- Removed qce_bam_txn = dma->qce_bam_txn; line from
  qce_alloc_bam_txn() api and directly returning
  dma->qce_bam_txn

Changes in v2:
- https://lore.kernel.org/lkml/20231214114239.2635325-1-quic_mdalam@quicinc.com/
- Initial set of patches for cmd descriptor support
- Add client driver to use BAM lock/unlock feature
- Added register read/write via BAM in QCE Crypto driver
  to use BAM lock/unlock feature

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

---
Bartosz Golaszewski (11):
      dmaengine: Add DMA_PREP_LOCK/DMA_PREP_UNLOCK flags
      dmaengine: qcom: bam_dma: Extend the driver's device match data
      dmaengine: qcom: bam_dma: Add bam_pipe_lock flag support
      crypto: qce - Include algapi.h in the core.h header
      crypto: qce - Remove unused ignore_buf
      crypto: qce - Simplify arguments of devm_qce_dma_request()
      crypto: qce - Use existing devres APIs in devm_qce_dma_request()
      crypto: qce - Map crypto memory for DMA
      crypto: qce - Add BAM DMA support for crypto register I/O
      crypto: qce - Add support for BAM locking
      crypto: qce - Switch to using BAM DMA for crypto I/O

 Documentation/driver-api/dmaengine/provider.rst |   9 ++
 drivers/crypto/qce/aead.c                       |  10 ++
 drivers/crypto/qce/common.c                     |  39 ++++--
 drivers/crypto/qce/core.c                       |  28 ++++-
 drivers/crypto/qce/core.h                       |  11 ++
 drivers/crypto/qce/dma.c                        | 158 ++++++++++++++++++++----
 drivers/crypto/qce/dma.h                        |  15 ++-
 drivers/crypto/qce/sha.c                        |   8 ++
 drivers/crypto/qce/skcipher.c                   |   7 ++
 drivers/dma/qcom/bam_dma.c                      |  64 ++++++++--
 include/linux/dmaengine.h                       |   6 +
 11 files changed, 304 insertions(+), 51 deletions(-)
---
base-commit: f3dfcffe2756f05cbae80ffdaa0ddf951e08431a
change-id: 20251103-qcom-qce-cmd-descr-c5e9b11fe609

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

