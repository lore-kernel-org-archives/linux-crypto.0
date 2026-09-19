Received: from avas.easytechitalia.it (avas.easytechitalia.it [213.217.29.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BA53382CD
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 20:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.217.29.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789849541; cv=none; b=qfxCXdsesbcelTEBGwZ0EKUZ4RZKVQlxRua/hoT1J7a5J4zt4QjXVIdaacrLeIh2yF/EaSDNM9rRtwHBhuLWCU/tRkKcLaRQhagJnvTUS0D3BJi+JcWnGojfTyTLuA/9MAjjT9dO7hZaV1mjF8CCqIYERbdHCU2aQqBKoUXb86c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789849541; c=relaxed/simple;
	bh=yOXeJJd/b20XDxghZTOz2Fqv/7LDR/U58cmsUId4Bz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ILDLD5V1g68cMnPJO8Lr0gpfjTMQVx+us2My9xIiWMUByEzCXNIzYzNbwtzMsByfhUvYn4+Di4ZHzUrmOlmu4x6AMKpoLgh6k8X3ra+nf1lM+wXtCZivyX6YvLE4+bWnvOd6qkwoWPC2rdq64Oo+8NexfB4S6E8X+Rb3x6luwAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it; spf=pass smtp.mailfrom=mtsistemi.it; dkim=fail (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b=NlcchfCd reason="key not found in DNS"; arc=none smtp.client-ip=213.217.29.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b="NlcchfCd"
X-Envelope-From: <info@mtsistemi.it>
Received: from ngmx.easytechitalia.it (unknown [185.76.140.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by avas.easytechitalia.it (Postfix) with ESMTPS id 4hnLbL1zcVzGnvV;
	Sat, 19 Sep 2026 22:25:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 6113717ABF9;
	Sat, 19 Sep 2026 22:24:05 +0200 (CEST)
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10032)
 with ESMTP id UsflyHODju7j; Sat, 19 Sep 2026 22:24:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id D973F17C481;
	Sat, 19 Sep 2026 22:24:04 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 ngmx.easytechitalia.it D973F17C481
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mtsistemi.it;
	s=AD82E3E6-03E3-11EF-83D2-AF8217D6D3C6; t=1789849444;
	bh=YUZUkggZdipMz4WTH81mS0qxWx3Tl+mExRDMQGKjwWc=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=NlcchfCdOOqqIsA/xhVIBBfZ7ARvUzaoHq8HF+xiRMIp2noKktkp0LFsLQMHA8eta
	 jWTkHtlsLWCh95RzPAr0cI8CflEGA3LrbzUHbt2yIqEUcjoLZ6kwr1gj2fCvlXo9Tq
	 tF+69WpSrnZ0LxgrIdMVLPydsbfS4i6ORlHH9XPxxjDuJaykUXji2DQwh6A3tXLcNB
	 Zm1FA6Tr+aX7c3IEwCzGN8uYha12jn2EmGSYMgHSwXkwArrnVDMwlskDhar8H2p8C1
	 F2+BA7A5V+/Le9a6n/hI0TO05s/WqTGLhjhhZUYBvjM6Wm/gJORh478F+0J+Iuc9zd
	 MyNei1j3Z1o7Q==
X-Virus-Scanned: amavis at ngmx.easytechitalia.it
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10026)
 with ESMTP id Onk0wWTobQEm; Sat, 19 Sep 2026 22:24:04 +0200 (CEST)
Received: from [192.168.56.1] (93-38-124-109.ip70.fastwebnet.it [93.38.124.109])
	by ngmx.easytechitalia.it (Postfix) with ESMTPSA id 79BB317DC3B;
	Sat, 19 Sep 2026 22:24:04 +0200 (CEST)
From: Mattia Tadini <info@mtsistemi.it>
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: ccp - fix NULL dereference in
 psp_firmware_is_visible()
Date: Sat, 19 Sep 2026 22:25:30 +0200
Message-ID: <178984953065.33228.16836522994898001211@mtsistemi.it>
In-Reply-To: <178984289056.12336.3953267527334867198@mtsistemi.it>
References: <178984289056.12336.3953267527334867198@mtsistemi.it>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Easytech-Libra-ESVA-Information: Please contact Easytech S.r.l. for more information
X-Easytech-Libra-ESVA-ID: 4hnLbL1zcVzGnvV
X-Easytech-Libra-ESVA: No virus found
X-Easytech-Libra-ESVA-SpamScore: s
X-Easytech-Libra-ESVA-From: info@mtsistemi.it
X-Easytech-Libra-ESVA-Watermark: 1790454335.91928@OJ9BPvnsyIGy6eW0Q8JD9Q

The cover letter for this series did not reach the list: the three
patches are in the archive, [PATCH 0/3] is not, and no bounce came back. =
Resent
here so the series context is in the thread rather than nowhere.

The AMD BC-250 is a Zen 2 APU board (Cyan Skillfish) sold as surplus mini=
ng
hardware and now used as a small desktop by a fair number of people. It c=
arries
an AMD Secure Processor at PCI 1022:143e that sp_pci_table[] does not mat=
ch, so
the device has always been left unbound with its memory windows disabled.

Adding the ID turned out to need two fixes first, both of the same shape:=
 the
driver decides what to bring up from the hardware capability register alo=
ne,
and then uses the psp_vdata pointers for those features without checking =
that
this device has them. On this board the two disagree, because the firmwar=
e
advertises a TEE whose ring never comes up.

Patch 1 is a NULL pointer dereference in the sysfs is_visible callback. I=
t
oopses during probe. It needs no new hardware to be reachable in principl=
e:
any device whose firmware sets the TEE capability bit while its psp_vdata
carries no tee data hits it, which today means pspv1 and pspv2 parts. I h=
ave
only observed it on the BC-250, so I have not added a stable tag - please=
 add
one if you think it deserves it.

Patch 2 stops a failed optional sub-device from taking down the rest of t=
he
PSP. Without it, a psp_vdata that deliberately omits TEE gets nothing at =
all,
platform access included.

Patch 3 adds the board. The register layout was read off the device rathe=
r
than assumed, and the numbers are in the commit message.

Tested on a BC-250 running 7.2.6. Before:

  01:00.2 Encryption controller: AMD Device 143e
          Memory at fe700000 [disabled] [size=3D1M]
          Memory at fe884000 [disabled] [size=3D8K]
          (no driver)

After:

  ccp 0000:01:00.2: enabling device (0000 -> 0002)
  ccp 0000:01:00.2: platform access enabled
  ccp 0000:01:00.2: psp enabled
  # cat /sys/bus/pci/devices/0000:01:00.2/bootloader_version
  00.1c.01.02

with the platform mailbox answering commands. Dynamic boost control is pr=
obed
and cleanly rejected by this firmware, and HSTI reports nothing because t=
he
security reporting capability bit is clear. There is no CCP crypto engine
behind this function: the version register at 0x100 reads back all ones.

The series is against v7.2.6 and touches only drivers/crypto/ccp/.

Mattia Tadini (3):
  crypto: ccp - fix NULL dereference in psp_firmware_is_visible()
  crypto: ccp - do not start PSP sub-devices without their vdata
  crypto: ccp - add support for the AMD BC-250 secure processor

 drivers/crypto/ccp/psp-dev.c |  8 ++++++--
 drivers/crypto/ccp/sp-pci.c  | 24 +++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 3 deletions(-)

--=20
2.55.0

