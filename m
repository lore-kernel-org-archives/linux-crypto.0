Received: from avas.easytechitalia.it (avas.easytechitalia.it [213.217.29.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAF737FF5A
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.217.29.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789842913; cv=none; b=SVB8pRJA2lqFpSgiZTMNygGZ9H7JK/IiKncduFH45ZtH9418/6+Ple+nh//SnjpIGYAhU8Pc1TF3KEfYp/eQzQKgsoFtuSu7R+KG01PGrYGrqIU9nV+RQAtCyanETZaKEzSc7YBx+S99Pa8c6Gq26vM63HCRmDWfRwSsJZ4qPPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789842913; c=relaxed/simple;
	bh=0netRUk/M7cVQpufzVRnVZMGugTnuh5C4b0V79bu/30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jayOSvQnHz49RU6XWVFw513OnzdTRZxbLKhWBbc4Xg5UzmkoTKqaBbgD7kj2NDNme8glEbU31Zj0+d1dD9MLTEihb2hRWz7cZiGLra5NDJJS72WYRsvTZ+nKUD5cmSi6ZHX5Wlbyjh+QG3/GCYI4/TRYtY6yZJPJXXjBubz1jfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it; spf=pass smtp.mailfrom=mtsistemi.it; dkim=fail (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b=sXQwgqYg reason="key not found in DNS"; arc=none smtp.client-ip=213.217.29.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b="sXQwgqYg"
X-Envelope-From: <info@mtsistemi.it>
Received: from ngmx.easytechitalia.it (unknown [185.76.140.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by avas.easytechitalia.it (Postfix) with ESMTPS id 4hnJ7f34jlzGnvG;
	Sat, 19 Sep 2026 20:34:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id D671D17C481;
	Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10032)
 with ESMTP id rLyopI9A9Guq; Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 6C1F517ABF9;
	Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 ngmx.easytechitalia.it 6C1F517ABF9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mtsistemi.it;
	s=AD82E3E6-03E3-11EF-83D2-AF8217D6D3C6; t=1789842805;
	bh=zTBEkOf0B//CvHn67VmZrsOSIy0ytB+JoqSByPP7pFg=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=sXQwgqYguEbnexLtu8/0dB1JCR7gGKdkMHLqYIFabZKGiCCsRQggJFN0azgHeC6Md
	 Zk7mTdcmIjbiPgvdru7jMbFQ0Cm0qZqzOAlu7zGwfupfaqeBoR2xDtsiKVKrlk1q9g
	 BXB4LLkKu34CRbAr4Y0lJFfnuXVZsRQL+TLwrHM81NzAFX2KlhM87Cs507O7Rkmjp7
	 RTQabZm5AbmtWIIiVfwFyB5UVW8IBc266TozmL/P9U/8O7QQhvxKXm/H2XkAtTMWEn
	 9xC+ORh7SmatVauFLOrIzqbFljPzEY5FR/g790bWsb+yZYiQh4DivWNsR51sg3aMdy
	 cNzGi4wh90niA==
X-Virus-Scanned: amavis at ngmx.easytechitalia.it
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10026)
 with ESMTP id CzNvE0wKTGfL; Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
Received: from [192.168.56.1] (93-38-124-109.ip70.fastwebnet.it [93.38.124.109])
	by ngmx.easytechitalia.it (Postfix) with ESMTPSA id 1624117DC3B;
	Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
From: Mattia Tadini <info@mtsistemi.it>
To: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 [PATCH 3/3] crypto: ccp - add support for the AMD BC-250 secure processor
Date: Sat, 19 Sep 2026 20:34:50 +0200
Message-ID: <178984289057.12336.14231912476412105961@mtsistemi.it>
In-Reply-To: <178984289056.12336.17662860552012704364@mtsistemi.it>
References: <178984289056.12336.17662860552012704364@mtsistemi.it>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Easytech-Libra-ESVA-Information: Please contact Easytech S.r.l. for more information
X-Easytech-Libra-ESVA-ID: 4hnJ7f34jlzGnvG
X-Easytech-Libra-ESVA: No virus found
X-Easytech-Libra-ESVA-From: info@mtsistemi.it
X-Easytech-Libra-ESVA-Watermark: 1790447694.55578@JRDQiHYutCwk5HnWkFq8Zw

The AMD BC-250 (Cyan Skillfish, a Zen 2 APU) carries an AMD Secure
Processor at PCI 1022:143e which no entry in sp_pci_table[] matches, so
the device is left unbound with its memory windows disabled.

The register layout was read off the device rather than assumed. With the
memory decode enabled and BAR 2 mapped read-only:

  CCP version  0x00100 =3D 0xFFFFFFFF   no CCP engine behind this functio=
n
  cmdresp      0x10544 =3D 0x80000000   pspv3/pspv4 mailbox, and it is li=
ve
  bootloader   0x109EC =3D 0x001C0102
  feature_reg  0x109FC =3D 0x00000002
  inten        0x10690 =3D 0x00000001
  pspv1 offsets            all zero   wrong layout
  pspv5-v7 offsets   all 0xFFFFFFFF   wrong layout

That is the pspv3/pspv4 layout. SEV is a server feature and is absent
here, and while the capability register advertises TEE, the ring never
comes up on this firmware:

	ccp 0000:01:00.2: tee: ring init command timed out, disabling TEE suppor=
t

so the board gets a psp_vdata with platform access only. Platform access
uses its own mailbox (pa_v1, C2PMSG_28..30) and is unaffected by the
missing ring.

With this the PSP initialises and answers:

	ccp 0000:01:00.2: platform access enabled
	ccp 0000:01:00.2: psp enabled
	# cat /sys/bus/pci/devices/0000:01:00.2/bootloader_version
	00.1c.01.02

Dynamic boost control is kept in platform_features and probed. This
firmware rejects the command, which the driver already handles without
failing the probe:

	ccp 0000:01:00.2: msg 0x65 failed with PSP error: 0x4
	ccp 0000:01:00.2: dynamic boost control is unavailable

Signed-off-by: Mattia Tadini <info@mtsistemi.it>
---
 drivers/crypto/ccp/sp-pci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index f79df33..cf26b81 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -477,6 +477,21 @@ static const struct psp_vdata pspv7 =3D {
 	.intsts_reg		=3D 0x10514,	/* P2CMSG_INTSTS */
 };
=20
+/*
+ * The BC-250 uses the pspv3 register layout but has no usable TEE: the
+ * capability register advertises one and PSP_CMD_TEE_RING_INIT never
+ * completes. Platform access has its own mailbox and is unaffected.
+ */
+static const struct psp_vdata pspv_bc250 =3D {
+	.platform_access	=3D &pa_v1,
+	.bootloader_info_reg	=3D 0x109ec,	/* C2PMSG_59 */
+	.feature_reg		=3D 0x109fc,	/* C2PMSG_63 */
+	.inten_reg		=3D 0x10690,	/* P2CMSG_INTEN */
+	.intsts_reg		=3D 0x10694,	/* P2CMSG_INTSTS */
+	.platform_features	=3D PLATFORM_FEATURE_DBC |
+				  PLATFORM_FEATURE_HSTI,
+};
+
 #endif
=20
 static const struct sp_dev_vdata dev_vdata[] =3D {
@@ -547,6 +562,12 @@ static const struct sp_dev_vdata dev_vdata[] =3D {
 		.bar =3D 2,
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 		.psp_vdata =3D &pspv7,
+#endif
+	},
+	{	/* 10 */
+		.bar =3D 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+		.psp_vdata =3D &pspv_bc250,
 #endif
 	},
=20
@@ -560,6 +581,7 @@ static const struct pci_device_id sp_pci_table[] =3D =
{
 	{ PCI_VDEVICE(AMD, 0x14CA), .driver_data =3D (kernel_ulong_t)&dev_vdata=
[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), .driver_data =3D (kernel_ulong_t)&dev_vdata=
[6] },
 	{ PCI_VDEVICE(AMD, 0x1649), .driver_data =3D (kernel_ulong_t)&dev_vdata=
[6] },
+	{ PCI_VDEVICE(AMD, 0x143e), .driver_data =3D (kernel_ulong_t)&dev_vdata=
[10] },
 	{ PCI_VDEVICE(AMD, 0x1134), .driver_data =3D (kernel_ulong_t)&dev_vdata=
[7] },
 	{ PCI_VDEVICE(AMD, 0x17E0), .driver_data =3D (kernel_ulong_t)&dev_vdata=
[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), .driver_data =3D (kernel_ulong_t)&dev_vdata=
[8] },
--=20
2.55.0

