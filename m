Received: from avas.easytechitalia.it (avas.easytechitalia.it [213.217.29.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E769D38F920
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.217.29.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789842916; cv=none; b=pGf/jVHMbgze8j+YcsrM9+eZLB6JnYzl2/Rmsrv0jFLb/N/Xi+UBVehHo3UUCmrMnF3npBgDjA+ha8r/OmrYctG/NrkLiFOld61Oq+Xy4IaEa5shmQtNeYTSjHSFCF9awbH94uu9FBT7vGY24AAv+sVPBBqVkwqnh+C2Iq579Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789842916; c=relaxed/simple;
	bh=iJ8hMfknuRSR1UFxEQdFNe3E1zJLeY/EVwpn7KP2W/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i0dAQmFrWh2G70YiU3GEMflSUvHllk7ceZ/YmmJ5BlqaGG77sxr4aYALW8cpgHE6NOu0GCCQ2NwCX9KZ6zl9bae8gUHxcuIqhVPIfZMbODtlD1dmUQG41QSj+WstICOQPZwfCFb0QRDuVmqzc0hj6dFFnt0yfCoUyItTa3+heu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it; spf=pass smtp.mailfrom=mtsistemi.it; dkim=fail (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b=KfKMJaSR reason="key not found in DNS"; arc=none smtp.client-ip=213.217.29.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mtsistemi.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mtsistemi.it header.i=@mtsistemi.it header.b="KfKMJaSR"
X-Envelope-From: <info@mtsistemi.it>
Received: from ngmx.easytechitalia.it (unknown [185.76.140.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by avas.easytechitalia.it (Postfix) with ESMTPS id 4hnJ7d6pyMzGnv7;
	Sat, 19 Sep 2026 20:34:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id 584A217C481;
	Sat, 19 Sep 2026 20:33:25 +0200 (CEST)
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10032)
 with ESMTP id tYSPIRuwO6ir; Sat, 19 Sep 2026 20:33:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by ngmx.easytechitalia.it (Postfix) with ESMTP id D76EB17E253;
	Sat, 19 Sep 2026 20:33:24 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 ngmx.easytechitalia.it D76EB17E253
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mtsistemi.it;
	s=AD82E3E6-03E3-11EF-83D2-AF8217D6D3C6; t=1789842804;
	bh=OToAcRMHZPT2zKKJHhISRmvOT/8lcJHrS3an9zrUspk=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=KfKMJaSRHNYteqPLakxJ1eSN0Y4NR/+R8noxOd2kbKh9ZSsPTnsu89UH46CcKabWS
	 TQ39Kvp/O86McxxyJs8lFjo+OImWBPe2H7aUriD4X0qdB6z2Kwv96eR5NhvGdE+rG5
	 JflY6nTKS34iURqoL7CXJqbQrw9U6286VNws4Ava7kyxLeVrVW7eLmeQaBLSUwCn7z
	 XKP6pyRk6O6AkYsA7LMKHfutlZdbuzY1bGWqDilIgKjyoYZMVsaNWSDiKYXJ84kSMb
	 V91ICda5dTRlmANDYT2GCtczDcz2YGaqCm89Uea21/MdLQG+GYl3HLL7QErQ8B8Knp
	 +In5VPCDMBtNA==
X-Virus-Scanned: amavis at ngmx.easytechitalia.it
Received: from ngmx.easytechitalia.it ([127.0.0.1])
 by localhost (ngmx.easytechitalia.it [127.0.0.1]) (amavis, port 10026)
 with ESMTP id N1I3pRVkKX3d; Sat, 19 Sep 2026 20:33:24 +0200 (CEST)
Received: from [192.168.56.1] (93-38-124-109.ip70.fastwebnet.it [93.38.124.109])
	by ngmx.easytechitalia.it (Postfix) with ESMTPSA id 71B3217DC3B;
	Sat, 19 Sep 2026 20:33:24 +0200 (CEST)
From: Mattia Tadini <info@mtsistemi.it>
To: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 [PATCH 1/3] crypto: ccp - fix NULL dereference in psp_firmware_is_visible()
Date: Sat, 19 Sep 2026 20:34:50 +0200
Message-ID: <178984289056.12336.3953267527334867198@mtsistemi.it>
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
X-Easytech-Libra-ESVA-ID: 4hnJ7d6pyMzGnv7
X-Easytech-Libra-ESVA: No virus found
X-Easytech-Libra-ESVA-From: info@mtsistemi.it
X-Easytech-Libra-ESVA-Watermark: 1790447694.55174@Lxvwa6d2nLCoUGKRwo37fw

psp_firmware_is_visible() decides whether to publish tee_version by
testing the TEE capability bit reported by the hardware, and then reads
through the driver's own tee vdata pointer without checking it:

	if (attr =3D=3D &dev_attr_tee_version.attr && psp->capability.tee &&
	    psp->vdata->tee->info_reg)

The capability register describes the silicon. The vdata describes what
this driver was given to drive it with. The two can disagree: any device
whose firmware sets the TEE capability bit while its psp_vdata carries no
tee data dereferences NULL here. The attribute group is registered from
probe, so the result is an oops during module init:

	RIP: 0010:psp_firmware_is_visible+0x6c/0x80 [ccp]
	 ? __pfx_init_module+0x10/0x10 [ccp]
	 sp_mod_init+0x1a/0xff0 [ccp]

This was hit on an AMD BC-250, whose PSP capability register at 0x109fc
reads 0x00000002 and so advertises a TEE that the board has no working
ring for.

Check the pointer before following it.

Fixes: 2e424c33d8e7 ("crypto: ccp - Add support for displaying PSP firmwa=
re versions")
Signed-off-by: Mattia Tadini <info@mtsistemi.it>
---
 drivers/crypto/ccp/sp-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index ede6ff9..f79df33 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -80,7 +80,7 @@ static umode_t psp_firmware_is_visible(struct kobject *=
kobj, struct attribute *a
 		val =3D ioread32(psp->io_regs + psp->vdata->bootloader_info_reg);
=20
 	if (attr =3D=3D &dev_attr_tee_version.attr && psp->capability.tee &&
-	    psp->vdata->tee->info_reg)
+	    psp->vdata->tee && psp->vdata->tee->info_reg)
 		val =3D ioread32(psp->io_regs + psp->vdata->tee->info_reg);
=20
 	/* If platform disallows accessing this register it will be all f's */
--=20
2.55.0

