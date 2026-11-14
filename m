Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794645855;
	b=vRd4pCO9h8uUkPQvaMwaLuoIZAxBU3rAYbseoBXA7nvDyvKzNRpFueryWu0iHLlj6bC7
	 2QYiEFvttEHKYC/HxXM7jmuIJ3v86/1W3oB+xVd+9iJqTbL+KpBJLGKAsbMtFZPo5B4lQ
	 OqIXP+BXyWPRr2iQjxlTf/U3YY2khngsnKhz9y3HpRhslLjNo/7k8QUDWRAbxT+rKymR1
	 zprnMIHcGGIb4vRhJ+mqXBlROS2OSKpBDWk5DX0+gDoFX1WsiANlL4NxtptIGPZoCt04y
	 pQ4gVnlnPvDbM9g4RtasRZ8W0uFFmq8oEz24yQ5u6hqGKNvj/Soud6ZOMJgUmmpHi2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645855;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=MiPqIED5efnUKixNlzYaIYPcAjKmHwzTLvxt+3JrIus=;
	b=CS7J0aOR3ZxHyTveUnC6HCiaK/FiZW1fy9xovvIvfYEhzp/S/Nss9DxvqzLcyMCTVVlF
	 TdGDmGsoj8UPTWloQ8tJPs4V/ZMDBBv8iUeYNbu6ozSjwzy+tZO6rf9www7ZGOy1OMEFf
	 EwHQ140qy9vBVZoDNnBgBnlS61QJyEN0Fu8TgRLuSL7FTZyeMQXTBMXy4jEbQWRiPQsvL
	 dNjvfnMTNvHNwUH5+VVzd3mkS/y+DiUlWpvi5xBRc+mq4jX2lmI9cjqe+KSs2EUztjMxr
	 gE/zGeuAvf9Igj/ohAeb47rtCdLapcZ7QTYx49EFv0YkVi7ZbJzJbzngIgwqkoUo5gg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Df41rqn9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B82606A33F;
	Sat, 14 Nov 2026 08:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Df41rqn9
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794645855;
	b=zDSpCvD8+31prq9L9OFNd4n728YigL8qXrQp/A0X30qZuBGQRV5AIJ9TEe4hF/Vin2Dh
	 XRS2TicJ/tN419DrM7yVlXa4TArot5oBYT6NUguW2RSdBBiKaUWF105K5xQdUWA0zdkkA
	 jEzcp19g27F2QuQHBi2+DwEmJHqtpqV2UlTyRInHHz8svVRICEhHTsrO0W1NPFURtz0lf
	 +5D78XqEqxqvDphY68ORE8+odwI0nJhvLyzO7ztFL9CUGIrXFwa9eKBTrGfutk+44qM92
	 wjm15urJtINbIU0X729aygwzgp45xL5XAnpkCK+DQh6Eh6XgycnXOLeLAdivE63D+GQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794645855;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=MiPqIED5efnUKixNlzYaIYPcAjKmHwzTLvxt+3JrIus=;
	b=wllFqvuDKPOAXD+dE3WjW8WDaznpS5yPPR4jzIsfdiIt0DX0VZt9mjxSifOzbqrxpb/z
	 S7yZn2/8rwG/mGlTRVJmTOkUtDIXzjqaeU4iklmFNKdOYaB2GpPbqh5b2/P1Fhn79yNhJ
	 v6wumThtjMU9b69wgK7wU21gwH1vQVjMVc1e0wqgJqLSpdnm8eaKjfxXzXMULUnLdave6
	 H8euqFhPpyM+NTPoa4+MkW3sBYg9lgajMMNcD7gSIvwb+ov+TONsY+jQ2jLUqX+BnT6W9
	 HkddyeQhCzJ5JxIwUUlGJWWmKCzGPgmf0SnPV5y7HYiR0W0uGyBBmLoPLJaW/MtZKjw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E71CB1F000C4;
	Sat, 14 Nov 2026 08:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794645855;
	bh=MiPqIED5efnUKixNlzYaIYPcAjKmHwzTLvxt+3JrIus=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Df41rqn9eom032jxkTQTHYZbVOse5My1LdszKCRdGolxU5gOVwy7D1RzWoEP9Dk8j
	 WJ3KFIIeEbOkG2+hGYkfKCwvXlLvSaFZSqHP/3bf+NwALfVDCtsoVK0Y0d7+rMKUSE
	 oeFQyauOVNIULl6nbATOyVgX32oNPL9bTgZdNtGxzIwAhUtCDiqNgkNnsTH2xgZ9cr
	 DuDx2kj/MH3JEeeA+kAVacCpm1FfVk+2NmpYNKDi6lQ43rR1H6LdD8ohK9vSxGBnOV
	 YLbeZb5mwJJ7VCq9SVwngcECBv9CwWVf3Rxp6f51Wde0vFnrCaMBlP4nNi+uEwFRS8
	 +mZdP9OXtHuzQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 42A5049CFC;
	Sat, 14 Nov 2026 08:44:13 +0000 (UTC)
From: Arun Iyengar via B4 Relay <devnull+aiyengar1990.gmail.com@kernel.org>
Subject: [PATCH 0/2] crypto: ecc - Fix P-521 public key generation
Date: Sat, 14 Nov 2026 08:44:12 +0000
Message-Id: <20261114-ecc-p521-small-scalars-v1-0-7b114f076b33@gmail.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQrCMAyA4VcZORtoio7iq4iHNo0uo26jURHG3
 t06j9/h/1cwqSoG526FKm81nacGOnTAQ5zugpqbwTvfE9ERhRmXkye0RywFjWOJ1bB3lHMIjkN
 K0OKlyk0/+/hy/dteaRR+/m6wbV99o+HEegAAAA==
X-Change-ID: 20261114-ecc-p521-small-scalars-601dd880c8bb
To: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
 Stefan Berger <stefanb@linux.ibm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Erwin Pawliczek <pawliczekerwin@gmail.com>, 
 Arun Iyengar <aiyengar1990@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794645852; l=918;
 i=aiyengar1990@gmail.com; s=20261110; h=from:subject:message-id;
 bh=s/LhpwHvt85EydqWoJFpNYvfgoCBmP/uoS1ROXm5kcc=;
 b=lJW3yZ+EzBLCAxAaFW+n4QfoqajhwxxjfNDyRbxDH52TVcvIsagGMvsHBVjiTQYeHgusT/Cke
 cV8blHRizvZB+ftFvqsLdFcQjaPbOz0wD2NXEPBtSjuFNTFsHiZPEMa
X-Developer-Key: i=aiyengar1990@gmail.com; a=ed25519;
 pk=zXpRgUTrhaFe6jLyPqbBy3ccfkj04w0g2690Wv3mg+0=
X-Endpoint-Received: by B4 Relay for aiyengar1990@gmail.com/20261110 with
 auth_id=1480
X-Original-From: Arun Iyengar <aiyengar1990@gmail.com>
Reply-To: aiyengar1990@gmail.com

Two P-521 fixes for crypto/ecc.c. Patch 1 keeps the random initial Z
from commit cd65eaf17841 below 2^521: with 576 bits, every P-521
ecc_make_pub_key() call fails with -EAGAIN. Patch 2 fixes the scalar
multiplication for scalars below about 2^259.5. No in-tree caller is
affected yet.

This series was developed with Claude (Anthropic) as a coding assistant:
it wrote the code and the commit messages. I reviewed it and tested it
as described in each patch.

---
Arun Iyengar (2):
      crypto: ecc - Keep the random initial Z below 2^521 on P-521
      crypto: ecc - Fix P-521 scalar multiplication for small scalars

 crypto/ecc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)
---
base-commit: 8ba9044ff0bf4a5789216496019fad614eeafd45
change-id: 20261114-ecc-p521-small-scalars-601dd880c8bb

Best regards,
--  
Arun Iyengar <aiyengar1990@gmail.com>


