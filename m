Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F211EF08D;
	Thu, 30 Jan 2025 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254789; cv=pass; b=GyXadc0xx6mmDRoKE3p/m2CWR11s8XlTzz9L6rdKhYxZ2nmqApbJ6oGh0pb+kcQjFi4x8Q7uKTgfHa6lOsosSUTc9q4YpzWElJP4SpgDmnnDj+hDwotZ9O0vkqiy3z6CC5/LvebEMcUL1LfoKL18U9zVavsVFBb43xd2QpaYDw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254789; c=relaxed/simple;
	bh=ywECwYkKqif1Ptbyg7/tnBA60CTtZe8pnU0bMU4PIwQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YrGlx63E4CkVDtOitv0yMVvtYrXWRde7n8XUNUj85DXKs534F89ODOOTes3G0QXLZigtxgSbWO/fJjtuRnbieQVDK0RI4NgJdH20Ycs27w6E7VReX0tekwoID6fT9ivsg6L2+Ph+ZePrw9jiPyWh0PZjb+/ah+6LKNxKGCRP4Nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=jLm1UI5r; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="jLm1UI5r"
ARC-Seal: i=1; a=rsa-sha256; t=1738254761; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Afs9I66P4nPDOHHXiYSbFue8gfjFNvFdsY9Ez4F6h2G1pKI1oCAbFcGK9hP63OYYfW9bDL0NuJe1wi4WxvB/L3UreF2Vq/SRXk9dM8IKigtru9T+1dQ93H80EVX74NFDv2lnORKKoUG8xhl5RExjGa4U6lj8Jt9PulpcXNOdUhU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738254761; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4P85b1Yewhr0bG0AVZgypW6WQK0tyFtk1cdyI+K42D8=; 
	b=PW63N3zADGMcw5WzavUGXAqwpDQ+FHjxDE7juX8eKXR08Mbe9ftY5y/djcypmTkICp82A0pMzSAA+bjExZTbPzFVFuh3vDx9RoPmSEU7auDBFHFFVWw5tmBQp3bS2b82BijXA1lwKB0Az1S9Ktwm+FmJorXVd7IO/hqsaaB21WQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738254761;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=4P85b1Yewhr0bG0AVZgypW6WQK0tyFtk1cdyI+K42D8=;
	b=jLm1UI5rW3l+RWZAg/nN290f1ftUNWa4KyJwUIooqu+hquGkCsbfFP3H9ptklXB+
	lm8MUSjF9awrkFDjNW2tpsDEkhgFPMlGSqyGx3MoImrycN9OF1z3OfCe3lzmQR701SF
	vWf92AEaENaoVroKisWvWveuSQJMPtolkXMJ8Amc=
Received: by mx.zohomail.com with SMTPS id 1738254731433421.4839172231101;
	Thu, 30 Jan 2025 08:32:11 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 30 Jan 2025 17:31:21 +0100
Subject: [PATCH 7/7] mailmap: add entry for Nicolas Frattaroli
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250130-rk3588-trng-submission-v1-7-97ff76568e49@collabora.com>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
In-Reply-To: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

Add my new Collabora E-Mail address as the main contact.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index 17dd8eb2630e6216336047c36037a509beaa0731..07dc4846c451d0f36e27fe67e224791cd48bfef9 100644
--- a/.mailmap
+++ b/.mailmap
@@ -525,6 +525,7 @@ Nicholas Piggin <npiggin@gmail.com> <npiggin@suse.de>
 Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
 Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
+Nicolas Frattaroli <nicolas.frattaroli@collabora.com> <frattaroli.nicolas@gmail.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>

-- 
2.48.1

