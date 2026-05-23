Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8217E33E35B
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779538542; cv=none; b=uHpPgKiH0lWb+yv8S+TmyYm9k3s86kpWlO6biUU/LBQByccLJzgRz2PKPFRacgbNNqH4cT/2MaNw+suQuJegjh5GCa7yaTyQyJ+g5U4C96Z57EYR/o62mePakCXByUyW+HAiog4+81l70yQshG2KbZQRWpzt+uZQnvD/QR71Rvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779538542; c=relaxed/simple;
	bh=WhlLcVVQjPEplzTRwPQy01UeCnAZv2FoMEU1WX5UEfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dEkx4RG7j8q6qnwde7UweZTpDtkmlT+bCeXCojLx412KrmMNI/jo2dxMvZBvGGLdgQF7caBIubLn6x+hj0yapUpaU1ODSxTOsEkX3zlGN8PGATRRxsgjSiDe0qVBLIYE2UzuIqVzwJUlSB78YHUnvbgc5cm6AqLJFuuEEtCWPDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jt2/qmco; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jt2/qmco"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ba17c8cfacso84627255ad.2
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 05:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779538541; x=1780143341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DK7qqqpT4fnZlS3XGu6aIqnYT1MOPYfSV+g6L0GEpFY=;
        b=Jt2/qmcot64yPJ0VtmTXTp0qPREKBhDCt9IuYIdrMiluV8X5By8vGaC1S3TKy6aCyM
         v4hmUl9355+tz/ODSd+DEPfST5uEAOdfdYPOuag/zFDQRQMmDZfe6zyZ0g2TBmLNiIrT
         cV3awhasHJDSQOM1uYsNmK+9Zf54nM2V6AO3WDSwL9XhBfw1Yz4FbObgaCMlVN9g3A4V
         y8mlRr+UkaJWX/SLrouy+FmOdyO955UQ9FnWTCPdhiIjk5ldc/tJHcYDeu4X3CM2DEUn
         WkA1bAnqecMF3+g2IYYqnW7U8dH0DKp9axU3HASL42p9VUhQJpsPssSwXSeli0nqjonw
         VZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779538541; x=1780143341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DK7qqqpT4fnZlS3XGu6aIqnYT1MOPYfSV+g6L0GEpFY=;
        b=bKASOz4aocQbTMiDP3ZtZhwR0UzswtrS1BaZvV7TLYf14Kzo6AsbMGWj8omwZUMQrJ
         Gs/PeHg+zDkikWVkiWIcf1lgFZUhpVFFgsy28MlfyYiQgy8XvX7/BRXnBiMoO7xBh+Kw
         Cri2tB2GRnrQUeEpAHH4UJmYokDF0wxIF7YcdPMNbBtFpDEXgdYVw3k94M9xOVIgXirw
         LdjWfviZVNtqQuM7wepwsPPBAIFHTEA2eSlMePCUDzVu3EuAYiDGe0W1nGDoL4/3M5LJ
         CqoL4x2RK7eHTlgp7UwTfUrOS+p9jcGIIoIhd/BGFIq3gXh9sJPRTnL3m9w0jKR6C4mZ
         WdkA==
X-Forwarded-Encrypted: i=1; AFNElJ/7kIlXtFGq1vR/vxuxXj9X6sBnaszoKgOPFsSZLbgj4FBpbF17di3EMOxp6ig6Y7kZfFmsZHSLMZAXQlw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaNM9iyuUbOo96t0PE8lGuDgmbE5thHoNj+5YeZvugeuMAJ+AL
	olvP0KGim2SyCOmTJn0agZQJwEknvA6K0G2L/aFRLLpMgmU/14l6xsT2
X-Gm-Gg: Acq92OFwWzSXRRiHg/rSCcXzcq+j7KZiMkiTWklKiy4ZI9aQGZ3UkkZ18dNtof+lTMa
	F+36qQyATmfFBEwkN1RzQiwo93Eu7zK05IX8qWz6Q1+YE0Q5Ehasl4nrxXnOiYD05bhPTBgvgzC
	0+EkqYY/0CXBVRiPTJanyr4BleBxlPuUlBECaGcTwfcEqd1o/rZ8RQRA84nbSVjUYaHCFsQR4po
	q/SzDbbKM7vYaVDSGYe1zHEcqct+wP/ZD89l0lqnrVfLMPoeM8uEvstoA27NPAoeMDIkID0AFrp
	aGiaU8CFuWehuVXUVF8ONtKZ8ldjTaAZxLchi31es73q2yNFfVNdRuNu5+S8sJ2DPCyoGLMBK+B
	uFwy61XulLKcT3kN2e/BL4RgGEh1UUE/ZS1UEIBbhGx3l0CEn/C8SsQGzCvBZKtD0oLBwAOBmY5
	bF6Wnc2lbATBRHXr0YPBuu+wjD
X-Received: by 2002:a17:903:388c:b0:2bc:a577:70c2 with SMTP id d9443c01a7336-2beb06292f1mr83238405ad.31.1779538540585;
        Sat, 23 May 2026 05:15:40 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56ce4easm41746305ad.30.2026.05.23.05.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 05:15:40 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	netdev@vger.kernel.org,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH 0/3] Add packet-mode ESP offload for Airoha/EIP93
Date: Sat, 23 May 2026 21:15:19 +0900
Message-ID: <20260523121522.3023992-1-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds the missing plumbing for ESP offload engines that
operate on whole ESP packets instead of only exposing AES/HMAC through
the crypto API AEAD interface.

The normal ESP software path can already call into accelerated AEAD
algorithms, but packet-mode engines such as EIP93 can also generate and
consume ESP packet framing: padding, pad length, next header and ICV.
That needs a slightly different XFRM offload contract so the netdev
driver can hand the skb to a packet backend rather than trying to make
hardware fit the software trailer layout.

Patch 1 extends the ESP offload infrastructure for packet engines while
preserving the existing behavior for drivers that do not opt in.
Patch 2 exposes an EIP93 ESP packet backend for encapsulation and
decapsulation.
Patch 3 wires Airoha Ethernet GDM netdevs and DSA user ports to that
backend through xfrmdev_ops. ESP GSO and ESP TX checksum offload remain
disabled.

Runtime testing was done on a Gemtek W1700K2 running OpenWrt with the
same changes applied on top of a 6.18.31-based kernel.

Test parameters:

  - Static IPv4 transport-mode XFRM SAs between the AP and host.
  - ESP transform: auth hmac(sha1), enc cbc(aes) with a 128-bit AES key.
  - iperf3 TCP test, AP as client and host as server:
        iperf3 -c <host_ip> -P 4 -t 10
  - The host always used normal Linux XFRM software processing.
  - With AP ESP offload disabled, the AP also used the Linux XFRM
    software path; in this setup, EIP93-backed AEAD crypto was still
    available to that path.

Network-relevant test setup:

  - AP: Gemtek W1700K2, Airoha AN7581/EN7581, 4x Arm Cortex-A53 at
    1.4 GHz, 2 GiB RAM, airoha_eth wan (GDM2) netdev, 10Gb/s full-duplex,
    MTU 9200, EIP93 crypto and IPsec packet engine present.
  - Host: AMD Ryzen 9 9950X3D, 16 cores/32 threads, Open vSwitch,
    MTU 9978, backed by a ConnectX-6 Dx 10Gb/s full-duplex link.

AP to host iperf3 result:

  AP offload      Sender          Receiver        Retransmits
  on              918.2 Mbit/s    913.6 Mbit/s    0
  off             782.4 Mbit/s    778.6 Mbit/s    3569

This is a 17.3% receiver-side throughput improvement for the AP TX ESP
path in this setup, with retransmits eliminated in the offloaded run.

Jihong Min (3):
  xfrm: extend ESP offload infrastructure for packet engines
  crypto: inside-secure: add EIP93 ESP packet backend
  net: airoha: add EIP93-backed ESP XFRM offload

 MAINTAINERS                                   |    1 +
 drivers/crypto/inside-secure/eip93/Kconfig    |   10 +
 drivers/crypto/inside-secure/eip93/Makefile   |    1 +
 .../crypto/inside-secure/eip93/eip93-ipsec.c  | 1413 ++++++++++++++++
 .../crypto/inside-secure/eip93/eip93-main.c   |   69 +-
 .../crypto/inside-secure/eip93/eip93-main.h   |   38 +-
 drivers/net/ethernet/airoha/Kconfig           |   11 +
 drivers/net/ethernet/airoha/Makefile          |    1 +
 drivers/net/ethernet/airoha/airoha_eth.c      |   51 +-
 drivers/net/ethernet/airoha/airoha_eth.h      |   69 +
 drivers/net/ethernet/airoha/airoha_xfrm.c     | 1474 +++++++++++++++++
 include/crypto/eip93-ipsec.h                  |  132 ++
 include/linux/netdevice.h                     |    3 +
 include/net/xfrm.h                            |    8 +-
 net/ipv4/esp4.c                               |    6 +-
 net/ipv4/esp4_offload.c                       |   29 +-
 net/ipv6/esp6.c                               |    6 +-
 net/ipv6/esp6_offload.c                       |   29 +-
 18 files changed, 3324 insertions(+), 27 deletions(-)
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-ipsec.c
 create mode 100644 drivers/net/ethernet/airoha/airoha_xfrm.c
 create mode 100644 include/crypto/eip93-ipsec.h

-- 
2.53.0
