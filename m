Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F011FC7FF
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 14:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729001726; cv=none; b=CXtPKX0DI9IyuxaBXhGc7DsKyA/3gycWsBzlRULJxTm52tfNdIUd2xQL6IIrozA262i4NTDdxN+A3e3EFzZhBGeNC690Kgvx3Z3Yl3vbaieLu39knKOonsSMJAF61ejgo1ccNRQTrOSebaeuoEtqKtYYEs4zsUlKl/isqDK35EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729001726; c=relaxed/simple;
	bh=Ib19qhKfZgtXVkLGaJl2pnDiKSqreOd3YE4WgviG8Ok=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Y1Sp/GwVQS4TOe83fKjH9X1lWhfcKDBCp7BvBQxUsOyYgQGUkbOWvowcA+zhFxukjgAJ2VigxuYCtI9eGm85sPK2S+k4toVepwF2Dahukxgc/R1YgCwpUId0/MYBN/6sN8U8o1qkaQYW5XYilm6CIb9Pogku5RWb+q/ODGA56hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BAW8Hrx5; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BAW8Hrx5"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-37d47fdbbd6so2534698f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 07:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729001723; x=1729606523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GdXYJ/MtZy6zCCkDaNJ51+EggPkwCWK9sqph7g+p230=;
        b=BAW8Hrx57WzJk7wJ+OtVwmsSwFZgM3JhtCDN2ivSrIv8t9cY7WF6RrjyJXnM6/wlRM
         BzUTQvWRUZPaXaubjPcvH7ZRxlcTO+3rza+FFhRVSL2eFuKfnQL35UN7roWmsehLEDxy
         1jK6I8gG8642FNZtPptfJkrbnzF+fYjLkAU2J0yABZLc9tkOgMJN1wvEkJgKU1CNzmo/
         bH4XpKTq5FERg9sHsn5TtGpV5OqrKGO2xGAC4GGaeT5PdNXYWmFC/I4WySNVZVORWRoO
         f979X7lNif/DsUZ493+k86h4aLtZJBk074wlXOVREd8SJKS7Lj2Ql8RaCwwr0UIbwKfH
         3OAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729001723; x=1729606523;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GdXYJ/MtZy6zCCkDaNJ51+EggPkwCWK9sqph7g+p230=;
        b=SXMVSj9vg/efkPfR/Mdptr0BYJN7mi4hW36VfVvHjwXVRydLZFIY8B27Z1qy7piAsb
         kxAui4LDgP8L5fVdiJvLF8/cBeiIpZfPR8HSICcLwzV5S+7zY18mNyszX2Dc6s18Yo+B
         TxDfaMlg/sRxsiBad4aoQpINKlIP6kzWl5ev1IdXgRR5/1Ug7W49JUDlyOlUQidTTzGq
         O997OdawK5NX83vu3fHuA4hRiAIfE0x+vQaIjit+Ti/+2ItcnZurWT4fHdSp6j3iksV3
         g645yhjRPxuNmlAfz646MtaBA566cN8lhyfL561tVH0j+lsxQ5usbdV0itKEH+2oXPJt
         u77Q==
X-Gm-Message-State: AOJu0YwJ3+G/cNfEjP7lqgAswC2+og4UuHl/Sffz9wPmSn9SlUQz7Tqa
	P62UHk0geNSOxhLbBkcDTzI7QP6aHvM3H9/EiyazVY2OeM3ZnY5uFM5BjWvL8asxHOWlTy5UpZD
	KJh75RRbuPX/AecK1GWs0b4Cz0VWnyVzLG17gelMH+5R5Xo5KW2eApySAVpqzTq8EMlj4yEysvZ
	RDMjph+UZqbb7XCHHZt7s3lNhYVCuFrw==
X-Google-Smtp-Source: AGHT+IGSyRo/IZxE3GOPG6qdJsh8JjAAJuPHO025CDTb5BU2rpwxNCI/A9mBcOAHZliU/La14DRIHr0/
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:6000:12c4:b0:37d:47b8:2154 with SMTP id
 ffacd0b85a97d-37d86d8622dmr146f8f.11.1729001722786; Tue, 15 Oct 2024 07:15:22
 -0700 (PDT)
Date: Tue, 15 Oct 2024 16:15:15 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=693; i=ardb@kernel.org;
 h=from:subject; bh=b7Moy35xKvMQZcVaTi4cW3Vjms4Z/QgrlgAfM4Kvmo4=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIZ2v4tMx89SfDmsDsrxfz9/ow7aEjd0/y3B9/lTjMmbFK
 95szyI7SlkYxDgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwES86xkZbp9ckfBn2rmrmUY6
 J3Sergrzf+59/MFCrivPZBhnb3jYWMTw342De6NyR71dX5Kx9MO39ycJPPY05zvvseTNyVXHVS+ x8gAA
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241015141514.3000757-4-ardb+git@google.com>
Subject: [PATCH 0/2] crypto: Enable fuzz testing for generic crc32/crc32c
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

crc32-generic and crc32c-generic are built around the architecture
library code for CRC-32, and the lack of distinct drivers for this arch
code means they are lacking test coverage.

Fix this by providing another, truly generic driver built on top of the
generic C code when fuzz testing is enabled.

Ard Biesheuvel (2):
  crypto/crc32: Provide crc32-base alias to enable fuzz testing
  crypto/crc32c: Provide crc32c-base alias to enable fuzz testing

 crypto/crc32_generic.c  | 73 ++++++++++++++------
 crypto/crc32c_generic.c | 72 +++++++++++++------
 crypto/testmgr.c        |  2 +
 3 files changed, 103 insertions(+), 44 deletions(-)

-- 
2.47.0.rc1.288.g06298d1525-goog

