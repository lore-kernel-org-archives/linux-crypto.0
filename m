Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95751F4727;
	Wed, 28 May 2025 14:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443394; cv=none; b=OM6V3Y4f2K1DTzOq4fYbS86LmDstdP3ghs19hoywvLQwA2IdiiIQr1O0XdJFD8cNSB4THKS/D3/oyLLWUzoYtOVhCWVdvQm0R7mgCxWUiEcTPUWF/ZRGWUcQjPHOhdEe/xle4SJflrwGkoj1D56sox/IX1tLMpFR0OaSiF+r7Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443394; c=relaxed/simple;
	bh=R+GbZ6nN6HjbsTbeOTTVLhsFdyWsq+06/Ht/0stBoYc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oJ6HiaDlw7YEHmAfT+kZrnCK1fzKq7AdrbI/mCTCkuv2WnBc/iQvm2H7hhtYs+Si2NqDYcXicqCdp02+C6142C0ryqnGmVB9IbZTE/YHw7Qwg1jSLFht6mgpAetRlGdTSwAWq8sktLKHRXGxVJth/NPVHZPPs1pYM4tSnwU6ABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 28 May
 2025 16:43:08 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Wed, 28 May 2025 16:43:08 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Frank Li <Frank.li@nxp.com>, Pengutronix Kernel Team
	<kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>, Thomas Richard
	<thomas.richard@bootlin.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH v3 2/4] crypto: caam - Support iMX8QXP and variants thereof
Thread-Topic: [PATCH v3 2/4] crypto: caam - Support iMX8QXP and variants
 thereof
Thread-Index: AQHbz97Tel4fhEuYF0q9EmqYDGkHbg==
Date: Wed, 28 May 2025 14:43:07 +0000
Message-ID: <20250528144259.2603914-3-john.ernberg@actia.se>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
In-Reply-To: <20250528144259.2603914-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2956B14453607C60
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The iMX8QXP (and variants such as the QX, DX, DXP) all identify as iMX8QXP.

They have the exact same restrictions as the supported iMX8QM introduced
at commit 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")

Loosen the check a little bit with a wildcard to also match the iMX8QXP
and its variants.

Signed-off-by: John Ernberg <john.ernberg@actia.se>
Reviewed-by: Frank Li <Frank.Li@nxp.com>

---

v3:
 - no changes

v2:
 - Collect review tag
---
 drivers/crypto/caam/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 766c447c9cfb..ce7b99019537 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -573,7 +573,7 @@ static const struct soc_device_attribute caam_imx_soc_t=
able[] =3D {
 	{ .soc_id =3D "i.MX7*",  .data =3D &caam_imx7_data },
 	{ .soc_id =3D "i.MX8M*", .data =3D &caam_imx7_data },
 	{ .soc_id =3D "i.MX8ULP", .data =3D &caam_imx8ulp_data },
-	{ .soc_id =3D "i.MX8QM", .data =3D &caam_imx8ulp_data },
+	{ .soc_id =3D "i.MX8Q*", .data =3D &caam_imx8ulp_data },
 	{ .soc_id =3D "VF*",     .data =3D &caam_vf610_data },
 	{ .family =3D "Freescale i.MX" },
 	{ /* sentinel */ }
--=20
2.49.0
