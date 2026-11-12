Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794502066;
	b=kAPjWydT4V0Z43zPj2lCCOdjKZyPmzyB1qw3506xWZpP5adTsi0BixsfI8/WO1D2c3fT
	 FKLgwC0rBupZl6LiRBs2dn0GZMDsaz+k8FQCpTCGVhzcBRKcwHisjD6ICxq8vhJhQAR2I
	 thkBVTIp2oe7lIHVLPJL5kPxsFhuR5ijdcqVB7H97YZm+MCi8ajGWdJLOkM/eyrddZZhh
	 Zn8VDUBcYGoV16emnkrr+1lMxTgB6mw04dhfOBFs8M9y3DSm6SVypr6dMSxnckYtkVos/
	 Ope8cTE7HBSLrXxK1xURZXlcF6XOne4W6xSRB9MzAnKkbOcUgbpoHqwSMPlkjzXaSxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794502066;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=gye6xNqFGway1d+vQ3pfKatGq8l2alYxmVtM490lIag=;
	b=uUPKIJCLo6uWzT+fL1ZF1qC5CBNMwKxypqw3d/wXJ2sizeczjNTELzigIpK+ViB3Js+v
	 0gHB+EbX2ZhT6QtpKnypAEU+5/WqUEkzBY4877owt1+UkBK4FS52Y1a7Mgy3xGtJJ1EjK
	 fvomaSIkidFz8JdSV/riR5KvU9P7z6mQZuckxyymCD++Wln+MrSojZavkgyojnkguoAU8
	 2azdPGiRlQwWuq1xq3SDd4gHI4O5jSY0WMDWc6nyAeWi9IQSmo9/mjGctz5WJxaC1maXq
	 vkJ3QhFe32Fu9pqHSnbtu/TIy4KcFr4GhDKnxIE6e3QSzlqUWEGDlYSjJ8j+fwmMSUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gc9DeQQQ;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A621606A32D
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A621606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gc9DeQQQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-490a0e72578so3308925f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794502064; x=1795106864; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gye6xNqFGway1d+vQ3pfKatGq8l2alYxmVtM490lIag=;
        b=Gc9DeQQQr0fJ2VeAJJ1fbXkJmpHah2kG6v/WmzCrG80fvsSQD/3tMDbBjorP5v1vf6
         sEU+gs+miOjR/9kc8vBh5eGTGlWxqVZ+ZWPEAiBV6Djz5YA5i8nWrdRVwQsTdCY/owTX
         Gh39nx28L7QcElSEt5sf5wDhmCRkhL5Fha3MvcyF1pSPBrCqeseIho0nCrJrEDhbpxha
         3+zJR43Fg6HZID/lg9XcFP8rwenajrdFnpXa5eMpYKFw13150t/sAHLbnKGc1yShJifz
         DlDwuV+f4xDr+z94TGhq/205dZI5hU3xoZZee0B0sAYXO3oGtXamGKzJYKlVshFOLQ9m
         HBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794502064; x=1795106864;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gye6xNqFGway1d+vQ3pfKatGq8l2alYxmVtM490lIag=;
        b=aChajZ32/v9qxVyneLVPAul1JXlaCF+8K5G9W5zeXXdelEfYqoY7WEPAdV0gALeIq+
         6g17JjDeJ2P8nytnu+sYx5AOWSLtz2fRBLjDwsrG3D5G4nXyy0i4P4lkgwJ2k0319Af8
         FiotMLVrPVIn7A44tAxyNAQY1cEaqtNviMqLN6OwyMEhHZKRTX01nhPkl5C5CtgcXGyP
         khzSGdQF7M0iROnb3sS4Td/mm+gdm7brCVqV/ZX55pf3AlyRSMCJwUFmg1K2vXobom3Z
         9XONSVSf5hAiQMctjYF62mow38kJVNRQsD085m5TFECyTeXo/vOlhRHejF6LoCbR6tpt
         mFkA==
X-Gm-Message-State: APuU4Z9ZPJc+T3A5KKVpn0514Dass4Nl/uI1bA8g98RHX9woyhIlMgIq
	5bUGLzO7UObedOhtP94UbuYAlTEYyc+dtLgpeGTc5PEPyunot9DVz1D/gKpmCg/ro0lRUIrpRHv
	nCx+DjcX0o2SGNa4LaaRlHKPgzyaLnFwyQ1sNrLHNRjLyQFu7rRFKeMwc95aDpfrjAP6Chm5clx
	Xu+t1kiyMlAHjpdf87WC41Jc6X0Qfh8yGD6A==
X-Received: from wrbdd30.prod.google.com ([2002:a05:6000:161e:b0:48e:5bd0:12a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d84:0:b0:48a:f59f:8b70
 with SMTP id ffacd0b85a97d-499c8b70ad9mr10928954f8f.46.1794502064073; Thu, 12
 Nov 2026 08:47:44 -0800 (PST)
Date: Thu, 12 Nov 2026 17:44:16 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2071; i=ardb@kernel.org;
 h=from:subject; bh=IvMu+pgzs5BzMNjtJfkJhVNyDhUvuAKYVZqGwZjteT4=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGr17OOgvkHKyPgbhwsfuxVS77ns2MkCvKgHkLZDypmijVnal
 4h1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmr17OMACgkQMG4JVi59LVy2ygD/em11
 eKRCjRQK+3nABhbwyKWuAoVPVgIuUaRV8eCjnjgA/11EtzY4VgxkqRzmF7sV5R3vWvnwhlcS/3C TrhXrEsYI
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112164419.1769428-4-ardb+git@google.com>
Subject: [PATCH 0/2] crypto: remove aegis128 support
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Antonio Quartulli <antonio@mandelbit.com>, 
	"=?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?=" <omosnacek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Ard Biesheuvel <ardb@kernel.org>

Remove aegis128 support, which has become obsolete.

Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com>

Ard Biesheuvel (2):
  crypto: x86 - remove aegis128 support
  crypto: remove aegis128 support

 arch/m68k/configs/amiga_defconfig     |   1 -
 arch/m68k/configs/apollo_defconfig    |   1 -
 arch/m68k/configs/atari_defconfig     |   1 -
 arch/m68k/configs/bvme6000_defconfig  |   1 -
 arch/m68k/configs/hp300_defconfig     |   1 -
 arch/m68k/configs/mac_defconfig       |   1 -
 arch/m68k/configs/multi_defconfig     |   1 -
 arch/m68k/configs/mvme147_defconfig   |   1 -
 arch/m68k/configs/mvme16x_defconfig   |   1 -
 arch/m68k/configs/q40_defconfig       |   1 -
 arch/m68k/configs/sun3_defconfig      |   1 -
 arch/m68k/configs/sun3x_defconfig     |   1 -
 arch/s390/configs/debug_defconfig     |   1 -
 arch/s390/configs/defconfig           |   1 -
 arch/x86/crypto/Kconfig               |  11 -
 arch/x86/crypto/Makefile              |   3 -
 arch/x86/crypto/aegis128-aesni-asm.S  | 602 --------------------
 arch/x86/crypto/aegis128-aesni-glue.c | 286 ----------
 crypto/Kconfig                        |  17 -
 crypto/Makefile                       |  20 -
 crypto/aegis-neon.h                   |  17 -
 crypto/aegis.h                        |  79 ---
 crypto/aegis128-core.c                | 577 -------------------
 crypto/aegis128-neon-inner.c          | 343 -----------
 crypto/aegis128-neon.c                |  60 --
 crypto/tcrypt.c                       |   7 -
 crypto/testmgr.c                      |   6 -
 crypto/testmgr.h                      | 444 ---------------
 28 files changed, 2486 deletions(-)
 delete mode 100644 arch/x86/crypto/aegis128-aesni-asm.S
 delete mode 100644 arch/x86/crypto/aegis128-aesni-glue.c
 delete mode 100644 crypto/aegis-neon.h
 delete mode 100644 crypto/aegis.h
 delete mode 100644 crypto/aegis128-core.c
 delete mode 100644 crypto/aegis128-neon-inner.c
 delete mode 100644 crypto/aegis128-neon.c

--=20
2.56.0.567.gdb80ae8cd5-goog

