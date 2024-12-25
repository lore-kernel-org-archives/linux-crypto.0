Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E82581;
	Wed, 25 Dec 2024 00:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735087376; cv=none; b=uB0KmOmpiErDRmGAAuxOUGDyYKaddoBykVCT0WmhoikL+UCnR5P1/EarrTW+IRylTzSChCmdu0SKm2sTsc3jZH9lWON11qMwW9PrOxiyMR7do7Km3tG7RHtj5AOX8pAUNJnCObjUBAeFoDdl4Djt0c2XJZQ45cI+UtbFGzgtEUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735087376; c=relaxed/simple;
	bh=Yo6UQr3YW6n9giSPcHchY0IDf7VXrlXRw0BqmghHZLA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cwDnNgL757Ym3XyQv6G74RsQDeAm0qiYIjPhC4boOWagQTksH5isHx9IybkMgUO1lRpvrqvPnbDaBBvJglQiBXoLS8MmQuJakUhsknqcFUaSFq1YoLwYAvd+wvKgs52+AR51lzTA7jS8m9AolNwmYjkf5Ch12vYf5nFmTiKrDVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iO2N3AJH; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iO2N3AJH"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4afed7b7d1bso1546761137.2;
        Tue, 24 Dec 2024 16:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735087374; x=1735692174; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aPtsGzN9vlAF3C0EglMMT3Hpykpwo+yq0jpc2gYnW4w=;
        b=iO2N3AJHapjdLT5JmFPRysB30ignf0UY4ydIBkDn8XoAvTh3babTGZ0lPZGCohQ4+q
         k4YsV7hYxbE3QbwwdhIQ+ke24J7aqQLmDOItl4J+xbr3lS2i36BsR7IBGQ+wpI3dGxMX
         9jFvUcDPE8Yk4hQWLXIMulrh3C1Fxvnsdvgr1y+BbA6xYmb368fczEvP+h4d9L4fl2IT
         mqSpqrjPDIFjZyOpOIgqbzT3nZy2yiP8HL1MnpIc3uP+Ai+/4UZlSEGBk+SQkLJW7vAg
         U0mWiRURGlj/62obXLZV7W/z2Nc4Dm2UIeCYl+alA/kiOF/0nY+g2RH7/WRn/dLqPikS
         lrzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735087374; x=1735692174;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aPtsGzN9vlAF3C0EglMMT3Hpykpwo+yq0jpc2gYnW4w=;
        b=N6yb5ygkG72V3a5mRlL4kG9eT7RWWdMjJfJeoO9DlbjLXOshg954BLXlVGdYP+aZTE
         ISo0W/gZO9aPhXYfMVuVELVsx6uJX3CExETpt2HwKXMddj5jIP8sm5x/Vphjhgp2sIVu
         DFAPYTf+3+YpCEcRoT4gG/vzCa9H7VjuFiMeAXwh0VzKw4an9E6aetSOu2uin0iJ+CLF
         ncnLKsUyEjajLms9z59Ez6X+1tP4ju3LIGOcLs+0yH7g/XhDm9Kk5Eg0sR5ci/OAoEHR
         ohLzzor4piUOuk8sgH6QUpQr7Tz9phhHDJhfJ1mYhSMqZt8mhiKDO4DSG93gz+djG9be
         X1Bg==
X-Forwarded-Encrypted: i=1; AJvYcCWLqPqDyBObb+ixKYOtoR4yV1lp1sXyLluD8zrMX3yJFWDt/7lu5uYn40q1PnELPqlgATR+rzqCMfq01t4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3ZHAQi0H3TiNoisoiCanzYCzpdsUBzgyRKvgx6viuiWPWlxhP
	Tps9R6/SzbnB0xRGqjkyDE7Rs+FI8Lb02ebxU6a+kQJIlhUi/U2mCVHMmQ==
X-Gm-Gg: ASbGnct0YVQ0YjDmTwaQJa1/yUC55uwzCGczmGneISFICETwlvqv2dMibnKCRRRk6IP
	cJVLkQO/o6IJ3TSixMUHAzs7NNVDBrc9XPxzVMsSpz4g9f82LCmEilPe68g+cQNSG0TRT1w3yEx
	JM6cryNM5zwZBwKFKYJ1TZbF21NNFgEf9yN/9T7Ife5yQgGwZE38A5Uj6w5nmkP9PxVSUz3JF5h
	MN7jDRHQVze9tBtgiwixTLC7pQ9bs//nGTujjIXTjqCCyzM/9t2rA==
X-Google-Smtp-Source: AGHT+IEG5OWU4lmmw2CSERgAeNUICKnNnP1aMvzQzKDaOOmO1oJGbb0SIfTfZ48VcSc2Nat18QVGAQ==
X-Received: by 2002:a05:6102:508d:b0:4af:e0d4:70df with SMTP id ada2fe7eead31-4b2cc49c342mr12487673137.27.1735087373502;
        Tue, 24 Dec 2024 16:42:53 -0800 (PST)
Received: from alphacentauri ([2800:bf0:82:1159:1ea9:11b1:7af9:1277])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4b2bf9b9191sm2034674137.13.2024.12.24.16.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2024 16:42:52 -0800 (PST)
Date: Tue, 24 Dec 2024 19:42:49 -0500
From: Kurt Borja <kuurtb@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: [REGRESSION][BISECTED] Double energy consumption on idle
Message-ID: <aqhq6okzqa56w3x6hb6xvhajs3ce6suxfrycjcmojpbrbosvzt@65sxbbnksphj>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

When I first booted into v6.13 I noticed my laptop got instantly hotter
and battery started draining fast. Today I bisected the kernel an ran
powerstat [1]. It comes down to

Upstream commit: 6b34562f0cfe ("crypto: akcipher - Drop sign/verify operations")

These results are reproducible on my system 100% of the time, and the
regression is still present on the latest upstream commit.

Please tell me if there is more info or test I should provide. I can
test any patch candidates too.

Happy holidays!

~ Kurt

[1] https://github.com/ColinIanKing/powerstat

Before commit 6b34562f0cfe
==========================

# powerstat -R
  Time    User  Nice   Sys  Idle    IO  Run Ctxt/s  IRQ/s Fork Exec Exit  Watts
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------ 
 Average   0.0   0.0   0.0  99.9   0.1  1.0 1926.9  335.5  0.1  0.0  0.2  24.94 
 GeoMean   0.0   0.0   0.0  99.9   0.0  1.0 1818.4  330.9  0.0  0.0  0.0  24.94 
  StdDev   0.0   0.0   0.0   0.0   0.0  0.0  650.8   60.1  0.2  0.0  1.1   0.21 
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------ 
 Minimum   0.0   0.0   0.0  99.8   0.0  1.0  737.0  267.0  0.0  0.0  0.0  24.71 
 Maximum   0.2   0.0   0.1 100.0   0.1  1.0 3675.0  543.0  1.0  0.0  8.0  26.21 
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------ 
Summary:
CPU:  24.94 Watts on average with standard deviation 0.21  
Note: power read from RAPL domains: uncore, pkg-0, core, psys.
These readings do not cover all the hardware in this device.

After commit 6b34562f0cfe
=========================

# powerstat -R
  Time    User  Nice   Sys  Idle    IO  Run Ctxt/s  IRQ/s Fork Exec Exit  Watts
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------ 
 Average   0.0   0.0   0.1  99.7   0.2  1.1 3280.0  408.1  0.3  0.1  0.4  57.64 
 GeoMean   0.0   0.0   0.0  99.7   0.1  1.0 2948.2  395.1  0.0  0.0  0.0  57.63 
  StdDev   0.0   0.0   0.1   0.2   0.1  0.3 1594.3  142.8  1.9  1.0  1.9   0.88 
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------ 
 Minimum   0.0   0.0   0.0  98.3   0.1  1.0 1353.0  278.0  0.0  0.0  0.0  57.24 
 Maximum   0.3   0.1   0.5  99.9   0.9  3.0 8216.0 1386.0 14.0  8.0 14.0  64.24 
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------ 
Summary:
CPU:  57.64 Watts on average with standard deviation 0.88  
Note: power read from RAPL domains: uncore, pkg-0, core, psys.
These readings do not cover all the hardware in this device.

Aditional Info
==============

# inxi -Fz
System:
  Kernel: 6.12.0-rc1-00010-ga16a17d3eaa4 arch: x86_64 bits: 64
  Desktop: KDE Plasma v: 6.2.4 Distro: Arch Linux
Machine:
  Type: Laptop System: Alienware product: Alienware x15 R1 v: 1.24.0
    serial: <superuser required>
  Mobo: Alienware model: Alienware x15 R1 v: A00
    serial: <superuser required> UEFI: Alienware v: 1.24.0 date: 08/08/2024
Battery:
  ID-1: BAT1 charge: 61.0 Wh (100.0%) condition: 61.0/87.0 Wh (70.2%)
CPU:
  Info: 8-core model: 11th Gen Intel Core i7-11800H bits: 64 type: MT MCP
    cache: L2: 10 MiB
  Speed (MHz): avg: 800 min/max: 800/4600 cores: 1: 800 2: 800 3: 800 4: 800
    5: 800 6: 800 7: 800 8: 800 9: 800 10: 800 11: 800 12: 800 13: 800 14: 800
    15: 800 16: 800
Graphics:
  Device-1: Intel TigerLake-H GT1 [UHD Graphics] driver: i915 v: kernel
  Device-2: NVIDIA GA104M [GeForce RTX 3070 Mobile / Max-Q] driver: nvidia
    v: 565.77
  Device-3: Microdia Integrated_Webcam_HD driver: uvcvideo type: USB
  Display: wayland server: X.org v: 1.21.1.15 with: Xwayland v: 24.1.4
    compositor: kwin_wayland driver: X: loaded: modesetting,nvidia dri: iris
    gpu: i915,nvidia resolution: 1536x864
  API: EGL v: 1.5 drivers: iris,nvidia
    platforms: gbm,wayland,x11,surfaceless,device
  API: OpenGL v: 4.6.0 compat-v: 4.6 vendor: intel mesa v: 24.3.2-arch1.1
    renderer: Mesa Intel UHD Graphics (TGL GT1)
  API: Vulkan v: 1.4.303 drivers: N/A surfaces: xcb,xlib,wayland
Audio:
  Device-1: Intel Tiger Lake-H HD Audio driver: sof-audio-pci-intel-tgl
  Device-2: NVIDIA GA104 High Definition Audio driver: snd_hda_intel
  API: ALSA v: k6.12.0-rc1-00010-ga16a17d3eaa4 status: kernel-api
  Server-1: PipeWire v: 1.2.7 status: active
Network:
  Device-1: Intel Wi-Fi 6E AX210/AX1675 2x2 [Typhoon Peak] driver: iwlwifi
  IF: wlp59s0 state: up mac: <filter>
  IF-ID-1: virbr0 state: down mac: <filter>
Bluetooth:
  Device-1: Intel AX210 Bluetooth driver: btusb type: USB
  Report: btmgmt ID: hci0 rfk-id: 0 state: down bt-service: disabled
    rfk-block: hardware: no software: yes address: N/A
RAID:
  Hardware-1: Intel Volume Management Device NVMe RAID Controller driver: vmd
Drives:
  Local Storage: total: 1.38 TiB used: 366.32 GiB (26.0%)
  ID-1: /dev/nvme0n1 vendor: SK Hynix model: PC711 NVMe 512GB
    size: 476.94 GiB
  ID-2: /dev/nvme1n1 vendor: Western Digital model: WD BLACK SN850X 1000GB
    size: 931.51 GiB
Partition:
  ID-1: / size: 914.81 GiB used: 365.67 GiB (40.0%) fs: ext4 dev: /dev/dm-0
  ID-2: /boot size: 1022 MiB used: 662.3 MiB (64.8%) fs: vfat
    dev: /dev/nvme1n1p1
Swap:
  Alert: No swap data was found.
Sensors:
  System Temperatures: cpu: 49.0 C mobo: N/A sodimm: SODIMM C
  Fan Speeds (rpm): cpu: 2000
Info:
  Memory: total: 16 GiB note: est. available: 15.28 GiB used: 3.2 GiB (20.9%)
  Processes: 337 Uptime: 10m Shell: Zsh inxi: 3.3.36

