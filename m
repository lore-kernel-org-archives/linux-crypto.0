Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781699;
	b=pu9VLs/lhIe23UcaNEWZcdrAtNjEOuWMmO3Y3Ja7zafxXVv1NDYo9X3aME2yku/kiI68
	 9dSgMpMpSFUmr8gjTVtjeNdZR2Mgn95dBPBdBesnJs1UjXjf6dpo8b0UjG2TA92PmN6cc
	 DK6RCUxVLM4zCU2+9Tg+1ZXzBjNmZF5oarzB7nBE5qvEG/riJxlXk53zvgrI8IvfmFlRs
	 97GQmbIJst/qWU9ot1sT4gDnoQT/lwDOlMC5HUs9WFamAlag5ieUY/+PfemvrHu0WcG5O
	 NnTSHXUqtPG8SUlDjSluykvFaVNyzN60yvx9I53Xff63YddQHnmSFqf/tLnqKMwROUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781699;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KC0sI7U+oGi2L5pMJnKt6twXEoJzYwf8xpYFpCfd4vc=;
	b=K1d4BZI4ShlPHPaRbMn3Dd/0AaftTKcL/zawafVODQ/9nbB2sWU5iD6FevaADcoosh7V
	 1F7+DoU9rPOFBFNGEsZPuGQYrQLzKIb6yJ4ekDZHxn5jcMW+voMRnQb/40o8qxOFYbrtC
	 xUdxvyIQkSJ+PpnRUa8SNF8E+nTMzbE3TqvD7f0aY9+B0zE11mLYgC4S6f4WtrSyGRom/
	 f6t55D38zlSsxOH07MeFC5gJdduTGxKBZrcCxXXecH6GhKwV/6VCrJecbS69J3oJCofZp
	 7EZxKQcUhPZcenLNEgQCXtbNXWr0poDPikGJk7Gx/Uc2/qopBJMZmPB8w89oZfldsmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R2C2JuwP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9681606A327;
	Fri, 27 Nov 2026 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R2C2JuwP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0306F1F00893;
	Fri, 27 Nov 2026 12:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781699;
	bh=KC0sI7U+oGi2L5pMJnKt6twXEoJzYwf8xpYFpCfd4vc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R2C2JuwPdWPpGuGVNoVqDhIbANp5RRInz2EYIBNOhA+rONwrlCrmbQUDHz5QBcMOp
	 NAiwX6XlAxQokdQ8b/lv70p+GGaRzYJKG+HfjSLCIy4RGSXiJvm2npfpTTsvpywhJk
	 Tv74Kjj6BvdyLxTPKLRrtnve77xrmaitMMevCAi7/k7FFSwjpwwpgf7uuhXc59hRa+
	 LiD9yqnNW4Jsm6k1DZQQ/1TJMIR8RkvzaNCUJmKBO1fy7Xsc9CW3Uhp+qy9zKEp7q9
	 lq1YC7e24H5O/XyUQwsKx56A0osr5heD+Ldm9hgrZ+QIl9k/Vsil0yyn/nW8MjRgSK
	 7kZiLr6BLB/+g==
Message-ID: <sashiko-outbox-237340@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 09/30] crypto: amlogic - Move algs definition and
 cipher API to cipher.c
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-10-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-10-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:14:58 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] crypto: amlogic: meson_handle_cipher_request() left non-static
--

commit 06a3afc67de49fb3af60963406f5095479bba895
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Move algs definition and cipher API to cipher.c

This commit moves the skcipher algorithm templates and cipher registration
helpers into amlogic-gxl-cipher.c, making the cipher callback functions
static.

[Severity: Low]
In drivers/crypto/amlogic/amlogic-gxl-cipher.c (line 276) and
drivers/crypto/amlogic/amlogic-gxl.h (line 172), should
meson_handle_cipher_request() also be made static and have its declaration
removed from amlogic-gxl.h? Like the other cipher callbacks, it is only
referenced by the algs[] array in amlogic-gxl-cipher.c.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D9
