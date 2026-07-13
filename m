Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AAA35C193;
	Mon, 13 Jul 2026 22:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783981984; cv=none; b=Up0SGIB+ArYRXUXq6Vg3BAaNs/dbl1s1LeYC+fI/nW2lMhjdlF4phV5K44e5QWDqQxA04O6KLFK8dYdni4LYqtdvC4dSRJYGwZChgHRR2lyA36qes+puWbkbswUnrpRUTCAnJd9QOhSuHLD/2SRXd6Pf25+nQTxWTGub8mjG/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783981984; c=relaxed/simple;
	bh=eVgrdkp+IkCcBWyh/5xNJPO+GYBKa48h2CG5NPgq7iw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hUB8QA8S+80DA+5yE+l/POWY/Dg5xpY7lNs7Gj+cdeIhjxqSxr7PBp1HIMG9/i4x+pUegDswrKSbkqeBrXpORNaEXnImKXO12LsDSy3UGtWemtIhcbw0yxIPIlqR1JC2f2mrP5qbobaeDPgF19qGYI3+4j8n2BmzsA9t8fOcaas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJLQ+r8m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJLQ+r8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C087F1F000E9;
	Mon, 13 Jul 2026 22:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783981983;
	bh=jyrevr0mYQx4DdKRNQjlXoTvAanJy6P03yeRHAvAQD4=;
	h=From:To:Cc:Subject:Date;
	b=CJLQ+r8mdfOFfvT0QXhfSDhUfC+02cbeH0/KJ1AcLLi16XY/mMBSnr8DNqMk3N0BT
	 Ewh2wihvQGsTwv5LXn52s0giEvYbMoAbIMLaxXuXNZU0BluduqMKewGVtx/r2YzDXd
	 Dc85w6FcJ7+BtqPVSiKllAlMy5pr6gOrAezHHsBwh4VHaa5xNIBIsMHs48ZbG+0mRI
	 xhWP67A7vrMID9O58HrdYoUFpyYWImO7K3Z5cZtlmO7/BKwrNIBNUuFLNzCakYhH9I
	 30TczHxzvLHFP9v4Vd5UEvpjnhnD3z00uSCutWMVqj5DgZmV8cvRd6BiG+ZiMmSk4z
	 p3TIvf4kFHMNg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] Remove pcrypt
Date: Mon, 13 Jul 2026 18:32:32 -0400
Message-ID: <20260713223234.24812-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series removes the obsolete 'pcrypt' module, along with the
serialized job support in padata which was used only by pcrypt.

Changed in v2:
    - Added patch that removes the serialized job support from padata.

Eric Biggers (2):
  crypto: pcrypt - Remove pcrypt
  padata: Remove serialized job support

 Documentation/core-api/padata.rst           | 145 +---
 MAINTAINERS                                 |   7 -
 arch/loongarch/configs/loongson32_defconfig |   1 -
 arch/loongarch/configs/loongson64_defconfig |   1 -
 arch/s390/configs/debug_defconfig           |   1 -
 arch/s390/configs/defconfig                 |   1 -
 crypto/Kconfig                              |  10 -
 crypto/Makefile                             |   1 -
 crypto/pcrypt.c                             | 394 ---------
 include/crypto/pcrypt.h                     |  39 -
 include/linux/padata.h                      | 145 +---
 kernel/padata.c                             | 902 +-------------------
 tools/crypto/tcrypt/tcrypt_speed_compare.py |   7 +-
 13 files changed, 18 insertions(+), 1636 deletions(-)
 delete mode 100644 crypto/pcrypt.c
 delete mode 100644 include/crypto/pcrypt.h


base-commit: 0f26556c5eeea62cc934fa8938b148aa5844a6b6
-- 
2.55.0

