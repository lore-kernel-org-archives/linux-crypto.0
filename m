Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795459317;
	b=ui3h/w3nwanuwBETXOazGCs3+J3hA01iTE3AWJXJ2OOLccgIXFwv2gOp/RAnKzZpJdk8
	 K/OQxypK8VKfsvbbj6Z5roaLKPl8rdQMW6/3gDTySv8rMeTl1ZflkoyYBlROckCWX6hmu
	 YtKbV5Qj8EZ0tBEJ/Idy6nQSDuQAHcQMh1hvFm02EDcS7NJAXf9eXC83LZAoprCyaha3H
	 0e8cMhN57sz5ww6pJqvoK4vU+kvfB+lt0bvfyAKoQr9T6IG7UOqUz6gau0vssbGpKHxsI
	 3R6HbPJm+9z2raBa/i+I6znRy8fKg08HOblff9aOF0mAJRTGCdQPN2G7RstsZfzDKBA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459317;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=6HrLUrfwuiFFOmr5EytGTWpbXEC4l6L9WDEJOgI0ypw=;
	b=CintoI/5nmsOPbQCoowl7LyDyjvtu03pWm1YbKv9+NCtydcDkujJi8IFyVeo9xeZA9g9
	 ujRqg+Nz1uysp+p6vW1h34W479g4JUtlm62elsl7zqWVn1yH9FlJoSgdtGeP2tcN7sv5H
	 R4zmZoeDWSnQJ5eePP42PcCC+/UZEQgyfvrbRqh2zAvWplfvOYmiYthUOcxgcXfiWXNa5
	 V6huvqOKGiqsnxJfLCqUthqg74GHa0WpTwPYS+5m0Ue2rTEQyLxT06IEPrfAjZ1nEjiar
	 bqUaCiR+qsFwNIirFOKswUKg2tBXsCHbVTjn5z7MMxturgTOFpuqdeiN6o9Umt96jxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SnALd6/n";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DB1606A31F;
	Mon, 23 Nov 2026 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SnALd6/n
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795459316;
	b=j9OWKK7xbbjHx69IIf6NJRE4IwPa8UV+M2EIueU/u3TzznvfL/+O+piplnhE9oN2k8Bi
	 1qvGtKwKEhifghDZa1/Mcsz+2qk9r0vh5/DN6XPK/clJQHDjw3OzHeLnYRBIEb9SFMcbc
	 SggSK1fVyJFwl9rODrvo+GOeUkXuW/WunjfIKWDIjOFLAZtfU8+hT/Sp0pYu+iqZ8B/MJ
	 PQiI4th4X9RJLNesZQ+eLvEN5gDfnrGYXjA+FTTFnqtwmgeQ5t5jLim22L849+BatlBnN
	 zrCYL+5L15Oepl7VCa6TJOJz+AQ3TKUbmAf04Uu8FGe5eRC6qTfGmUwGwQrm2HPX7fg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795459316;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=6HrLUrfwuiFFOmr5EytGTWpbXEC4l6L9WDEJOgI0ypw=;
	b=iQxM7fPRJ6NZaQ8yG6OMRbL3fJXQt6i5Pj+0sdk8C4vrTsF+RgMRXJ8OeZbzJ4an2l+O
	 zFXu8xFCVskk5rKaCZIBR3eljyC4u9ZQToxgIvUx24Ag330IakdEqX5V9UyX9jAnJu7z9
	 vBMWkFidMLeX6IjFj6wVXPrfAvdsJepKRso7g7V5d8fIByY9XlBI5fzTOFGpllQFkvxQb
	 uZychnVzR/CojiRfHoHUjaMmk0kaeAVBn+WK+NmkS6JPeO+vt5SxYzt4jluqCtaszsFmb
	 FiWfC457fEdKhbKmzvtxyBnF9Eu/xaCw+ILhixvKq4iWPqKyxeGUGYDZajBTbq66Cuw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8FB391F01569;
	Mon, 23 Nov 2026 18:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459316;
	bh=6HrLUrfwuiFFOmr5EytGTWpbXEC4l6L9WDEJOgI0ypw=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=SnALd6/nIWd9wPvhyXa+EpMZS0ynoism/bdTv0kV3jiP8qfvmXzOiRRu1wPcLNetx
	 FC2nny3iKOx6FiYkQcyyIbxZiiVO1PNzUTomMzyI9wKcVXPHnkp/wIaikxFmFxLVUE
	 dgg7hhwxHpMXx0GbCcWx9h6Xel3JObBH9nJFx/kP/rzhyE6IgxorWyku/hVy9SjCOs
	 +w80NE75GaQt4FPf3pE4JcPmMAKlBNPhD15GwLQiWq2ijU+6GLnTTjxErzEy5bCZpx
	 xZfHmwRiMNdEyvCdzca6/k/fGZLEFC/OYGcRh4QjRlCJ8p9/YYIATH63FIJe4kMqM/
	 UdtkcUhSbYSYg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2114E4C5CD;
	Mon, 23 Nov 2026 18:41:35 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Subject: [PATCH 0/3] hwrng: Add Cortina Systems CS7542 random number
 generator
Date: Mon, 23 Nov 2026 21:41:33 +0300
Message-Id: <20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMPQ6DMAxA4asgz1jC5qeiV0EdSDDgDqGKoUJC3
 J3Qjt/w3gEmUcXgmR0Q5aumS0igPAM/92ES1CEZuOCGiEt0FXp71BXjGsOE1JNrR/JD2TKk6BN
 l1P037F5/2+be4tf7Aud5AT2b1DVyAAAA
X-Change-ID: 20261123-b4-cs7542-trng-1a1b9f1cd392
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459294; l=2873;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=+5fdkP17MS5TugucRLc1SqQw0TM5TWxx5LmS9OinWPM=;
 b=EFCNN0/CVf4KaFDdPKiaayM2jbxBRe5MW+HGmsu9zePsIYfmrkoTcPS1ib5beUOjZ5cqYckJf
 NHISGsOTHKzBmTAzSFmdwY7uo8ot2660zzP6z6qMzLYAj7ZxTldlKVx
X-Developer-Key: i=filipp.dunsky@gmail.com; a=ed25519;
 pk=JAYP8e2rJ54DHOmhNtXud8rl1igAaAXoOHxtJmVXI1g=
X-Endpoint-Received: by B4 Relay for filipp.dunsky@gmail.com/20260930 with
 auth_id=1085
X-Original-From: Fil Dunsky <filipp.dunsky@gmail.com>
Reply-To: filipp.dunsky@gmail.com

Add the Elliptic random number generator integrated in the CS7542,
based on the GPL vendor and OpenWrt implementations. The driver has no
platform Kconfig dependency. Its shared global scratch bit is updated
through a syscon regmap rather than an overlapping raw ioremap.

Polling is bounded. A nonblocking read starts or resumes a pending
transaction and returns immediately if data is not ready, instead of
entering the blocking poll path. Partial output and failure cleanup
preserve the caller's buffer bounds.

The existing OpenWrt quality setting of 512 is retained for review.
The output tests below only check access and obvious stuck output;
they do not characterize entropy or establish this quality estimate.
Feedback on that inherited policy is explicitly requested before
publication of a final version.

The three patches are the binding, the driver/Kconfig/Makefile and a
MAINTAINERS entry. They apply to Linux v7.4-rc4 without the pending
CS75xx platform or clock/pinctrl series. The TRNG syscon phandle can
refer to a generic syscon; the local board integration uses the new
CS7542 global-control binding being prepared separately.

Validation:
- binding schema, example compilation and style checks passed
- strict source checkpatch with --no-signoff: no errors/warnings/checks
- complete minimal ARM vmlinux and modules builds with both new
  drivers built in and modular, COMPILE_TEST=n, without the platform
- actual driver functions tested with mocked MMIO/regmap and UBSAN
- exact sources booted in a Linux 7.4-rc4 RAM integration kernel on
  Almond+, with platform v9, clock/pinctrl and the accepted watchdog

The first nonblocking read returned EAGAIN and subsequent reads
provided 4096 bytes. Output was neither all zero nor repetitions of one
16-byte block; no entropy estimate is inferred from those tests.
The final combined RAM test recorded 16 checks with no failures and
returned to installed OpenWrt 6.18.64 through the watchdog. Both CPUs
were online. The firmware was not flashed. Earlier incomplete or
experimental alarm runs are not counted as this successful test.

---
Fil Dunsky (3):
      dt-bindings: rng: Add Cortina Systems CS7542 TRNG
      hwrng: Add Cortina Systems CS7542 TRNG driver
      MAINTAINERS: Add Cortina Systems CS7542 TRNG support

 .../bindings/rng/cortina,cs7542-trng.yaml          |  38 +++++
 MAINTAINERS                                        |   7 +
 drivers/char/hw_random/Kconfig                     |  11 ++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/cs75xx-trng.c               | 159 +++++++++++++++++++++
 5 files changed, 216 insertions(+)
---
base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
change-id: 20261123-b4-cs7542-trng-1a1b9f1cd392

Best regards,
--  
Fil Dunsky <filipp.dunsky@gmail.com>


