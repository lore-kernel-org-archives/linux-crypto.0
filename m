Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C543563D4
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 03:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787799847; cv=none; b=cEZ7q02tvwLHl9JJR56YcNSV+VoBW+eXGIXbpZKtdCUFOzSqJCEMxoYm2lkXf3UjGcCuWGc80tLUy9EbbJO/YU9itFxpcIDy80t7R62SYNDXfHYWv/H1uq8O6SzRX0Trdi5GSm8itOV0npeaKoeuSvdrk7IDHo2YiTfg3t4POU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787799847; c=relaxed/simple;
	bh=KB/s53fpR8bYW2S9AFiDp+KTuR1QlCWexudnFeU+zJs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=k65TuDwv1OwxZ9+WAT+cnNGAt6iQdv+qcijXzHBak2w5HKLdTDdct1Cr+RaY0ztnyQtA49ZYRbWRRR2ZNWuNy66oLW1R++F/Qz43xzWJGOL/kyGX2Qfx99IuhtPTu7WswA6ogN1KvY1+6DQtW28CGDYzjpeQnywmbAy9ShVnLr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQYRDJpD; arc=none smtp.client-ip=74.125.227.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQYRDJpD"
Received: by mail-pj2-f5.google.com with SMTP id 98e67ed59e1d1-39661faa189so634929a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 20:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787799845; x=1788404645; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8IZxxHU2+jwDwkPsWh2fIZMMI25APJT2DIAv+xJo05w=;
        b=JQYRDJpDFBFpSVGqwy0JmKBy+RvLmzHlTqkI4MK+7AgmF5AwK6J4LCom/CfQZQiSYv
         vPj+6jk0006fC6wCgbuvqRCZAwW+pLuc7cWFihDePbEBOoXY8pcbbC/CzR8uh1/aoJVj
         T9lIka5TqxqEOVTgoHVkqHvM+QCARB9bS7ciipvoZEmR4C/oAmXyoeYYrVQoSKPOSB6x
         xPxaLT0kcuBQkvBpnpsPpUN+LpPaO0EwM88jW60/xbmgsZeM92H5/UoPBZtTANir3CaD
         OMHmWwn+Pn31ZVV4Ol/wQeytXkHkehb07dB7pwRR/Z13JjuEC2EL5T2NNSv602PCrh6h
         6D7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787799845; x=1788404645;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8IZxxHU2+jwDwkPsWh2fIZMMI25APJT2DIAv+xJo05w=;
        b=Xj20mVri1Kh9rIHVkJ6RVIec4MDJk518n3pbNvjHPFSKYDclzngqbVv3LfHJhos2Sv
         Xj0FC1ZXGQEIKG0hmGxR7vV8K/UF5Wpw5GG0Re78I9L1w3eHtOkVfsc+XqCja8LJ7ECA
         KNnnvbKn7dXiI/sHmO2Iu8QuAh2teajz6dzhHyqMvzLUmfyjrzc3rUXxN3LEiBFf3Q1q
         D7CM8M8H8Ci7W64BYGP047v7hTapfkWIJTDJC1saAXBt7KPdWFG2cBvIKybBnx1RBmyf
         7YnJB0Z08w2h9m3sUmgmVFK/nVScCxwEwyUzxyUfcFIacHTh3TpxJaG5XGm/jUMih8jC
         hYTw==
X-Gm-Message-State: AFuF++kyAykqNrpCBRoV6W25QMVROUJlOFFUHLnIy97ySC1eCV4XKsgq
	hQXUipkqnW6MGrk3JvBVzF+xmg4s2SfIHE2UVjJnrOc9vKPVZ+BCKJ0BG1uRgkm94ASD6Q==
X-Gm-Gg: AR+sD115MwOKjLQby6ZEA8TUFz72rIjmZJKhgaTQ/M9sW/YIDNcjeEsQe/yRYSF4O3+
	7YcAz1hmyIfCqdgzfm/AWXQGweVEEYIXHrJwOlqkjutnpd2dXZ5YB4oCR2yPDaML0y6AX3rkyqP
	fjMtCjT5FTCvfB3gTAjItqiXETjEKNV8vhOZfYpwuJiWs7z4z6+fI0dQxZZotTRfVfTe0+VU5Z9
	YvsJTA6vtGWnLRh4GcZxo8f+4Fpb0YqpyyccMJhagV0mAxo6iN9cv4Fj4fqrwTsgr4C7qJ+Kt9C
	+DpnLx2HUE8suJVkg+zm4Xmi58r+o2jzWDv3qZJyPsZGSshp/2GpNPWzIQV9IViH8PveajtMt0S
	Zy2KBRF2xuUXv3AMCEzCVicHHulGVI5MtcjQn45d4fIoT7iVt956ICjsoSg9QbbYvPBaHccq8TC
	242xC3+4dc9UJABqy3Uacfl4lI8VpJkQO2ZRrsJnVQ7JV4pjvmiCEdt6DL6hA6g7I7p44=
X-Received: by 2002:a17:90b:2604:b0:38e:ad9d:1151 with SMTP id 98e67ed59e1d1-3966d18ec9dmr24576642a91.4.1787799845013;
        Wed, 26 Aug 2026 20:04:05 -0700 (PDT)
Received: from localhost ([117.71.111.40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1992e05sm745403a91.15.2026.08.26.20.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 20:04:04 -0700 (PDT)
From: Evanshenf <archwse@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Zhiqi Song <songzhiqi1@huawei.com>, Longfang Liu <liulongfang@huawei.com>,
 Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Subject: [BUG] crypto: hisilicon/hpre: RSA request never completes during
 signed module verification on Kunpeng arm64
Date: Thu, 27 Aug 2026 03:03:27 +0000
Message-ID: <178779980745.730913.5616603289665364629.hisi-hpre-7980@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

I observed a permanently stuck RSA request in the HiSilicon HPRE driver
while a signed kernel module was being verified on a Kunpeng ARM64 server.
The lost completion subsequently blocked module loading and all PVE API
workers which invoked ss(8).

This was observed with a Proxmox kernel rather than a vanilla upstream
kernel.  I have not yet reproduced it on a mainline build, but the relevant
HPRE and rsassa-pkcs1 paths appear unchanged in current upstream source.

Environment:

  architecture: arm64
  CPU: TaiShan-v120 (Kunpeng)
  system product: J353 G3
  HPRE PCI ID: 19e5:a258 (four PFs)
  kernel: 7.0.14-6-pve
  kernel package: proxmox-kernel-7.0.14-6-pve-signed 7.0.14-6
  CONFIG_MODULE_SIG=3Dy
  Secure Boot: disabled

Trigger and impact:

PVE executed:

  /bin/ss -Htln sport =3D 5900

This requested net-pf-16-proto-4-type-2, which resolves to inet_diag.
Verification of the signed inet_diag module selected HPRE because the
registered algorithms were:

  pkcs1(hpre-rsa,sha512) priority 1000
  hpre-rsa                priority 1000
  rsa-generic             priority 100

The first modprobe has remained in uninterruptible sleep for more than ten
hours.  Its stack is:

  rsassa_pkcs1_verify+0x284/0x3a0
  public_key_verify_signature+0x1e4/0x2b0
  public_key_verify_signature_2+0x20/0x48
  verify_signature+0x48/0xc0
  pkcs7_validate_trust+0x23c/0x300
  verify_pkcs7_message_sig+0x10c/0x190
  verify_pkcs7_signature+0x78/0xe0
  mod_verify_sig+0xac/0x150
  module_sig_check+0x104/0x190
  load_module+0x48/0x2a68
  init_module_from_file+0x110/0x168
  __arm64_sys_finit_module+0x220/0x398

All later ss processes became blocked in call_usermodehelper_exec() while
waiting for the same module request.  This exhausted all three pvedaemon
workers and caused PVE API login requests to time out with HTTP 596.

HPRE debugfs counters isolate the lost completion to one PF:

  0000:3a:00.0 send=3D3  recv=3D3
  0000:3e:00.0 send=3D25 recv=3D25
  0000:7a:00.0 send=3D1  recv=3D0
  0000:7e:00.0 send=3D1  recv=3D1

For 0000:7a:00.0, send_busy_cnt, send_fail_cnt, invalid_req_cnt,
abnormal_irq, aeq_irq, err_irq and dev_timeout are all zero.  The QM status
still reports "work".  Its completion IRQ vector has received zero
interrupts; the assigned CPU is online.

The signed kernel package passes dpkg verification.  hisi_hpre is not in
the initramfs and is loaded automatically through the PCI modalias.  It is
not exposed through UACCE and is not passed through to a VM.

Possible cause:

hpre_hw_data_init() directly maps a single full-size RSA scatterlist with
dma_map_single() through hpre_get_data_dma_addr(), without checking the
DMA/cacheline alignment.  rsassa_pkcs1_verify() uses the same scatterlist
as both source and destination for the child akcipher request.

HPRE already has hpre_prepare_dma_buf(), which allocates a coherent bounce
buffer, but the full-size RSA path bypasses it.  This resembles the recent
rsassa-pkcs1 alignment discussion, where it was noted that the underlying
accelerator driver must handle unaligned buffers:

  https://lore.kernel.org/linux-crypto/20260731024446.786329-1-changwei.zou@c=
anonical.com/

I cannot prove from the current stuck system that alignment is the only
cause, so this is a hypothesis rather than a conclusion.  Independently,
hpre_is_bd_timeout() only records elapsed time after a response callback;
it cannot recover a request whose completion never arrives.  The synchronous
crypto waiter therefore remains blocked indefinitely.

The production workaround is to blacklist hisi_hpre and reboot, which
causes signed-module verification to use rsa-generic.  The current request
cannot be killed or recovered without rebooting.

Would forcing unaligned or in-place RSA requests through the existing
coherent bounce-buffer path be an appropriate first fix?  Is there an
existing HPRE/QM recovery mechanism that can safely time out the request,
reset the affected queue, and complete or fall back to software without a
late-callback use-after-free risk?

The corresponding Proxmox report, including a sanitized diagnostic
attachment, is available here:

  https://bugzilla.proxmox.com/show_bug.cgi?id=3D7980

Please let me know if a mainline reproduction, additional HPRE registers,
or testing of a candidate patch would be useful.  The affected production
host is currently being kept unchanged so that more read-only evidence can
still be collected before the maintenance reboot.

Regards,
Evanshenf
GitHub: https://github.com/Evanshenf
