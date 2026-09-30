Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F0E517BD9;
	Wed, 30 Sep 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788027; cv=none; b=IYYpHeO5W4yRz0T9NGeqjYVu6JvWPov4nPT2TxTWT1sgQGLaaVzuRgCW2KKQNqcbOkIs163SCxtKUEdedoh/TnWB6Pz8FvwyJCSCJ8YMCfFxbA6NbiedXr431AwJujveY6N4GlGbKuuurgtF8Sgcx0yVsVJ5MqMIwvnawEJtJ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788027; c=relaxed/simple;
	bh=Eje0GkhqlVuGoHPUffeu/Os8V+rmoQVwPj57/NuhmXA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fB2kCkL3gyb2ZzPGYElI7W0Xk3i2VqRm/pR6DfVLN9vgiTozHDUCxm0/21ApeHUPbnmdwU5mjGQfU1LBmn78vVJJc6PpQBEkHbX9dek9S2KOlML1qOi5ptAIlzhNNQibNz35RAHHaLCz3tNI4aJxOezZB7ejm+vE/EHyY6dpmSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A90IL+PJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A90IL+PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C101F000FF;
	Wed, 30 Sep 2026 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790788026;
	bh=gV1VZo5ChHO2fSyCyOJqPRlEK6//5s/BjQbyvHz21vw=;
	h=From:To:Cc:Subject:Date;
	b=A90IL+PJqzP+WdwF/zaT/g2pFgC4XgPOvn6pfIJUwBflbRHMskuNE6C83nBhPKGiw
	 g/63LPFZigZIaPNrLCnvfqg9/w2c+Y5eXwREtVzDQKypLh0xtn0EY9o03v92qdtSOE
	 uEW/EFXujNtxyWClkkg33Q5mB2rzq/XE+JF4VwZuY6pI5QP4dfs+gjSlkjQdU9vrFC
	 pNYtXdTo8aeD+GPX7/LqsuUbHA3T90uzuyBqRzPIPddgVn57LEiwqm51fT+AYznvyK
	 9U+9Ws+FZx1YU5WsQEij6ezbVY0TLQL+DcRFtcc9gg59b6WtxCeE/PKdardNRAwfx2
	 Q2aNZtK74qcaA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] AES library fixups
Date: Wed, 30 Sep 2026 10:05:39 -0700
Message-ID: <20260930170542.140403-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A few small fixups on top of
https://lore.kernel.org/linux-crypto/20260927224418.109759-1-ebiggers@kernel.org/

Eric Biggers (3):
  lib/crypto: x86/aes: Set RNDKEY in aes_cbc_encrypt_aesni()
  crypto: aes - Boost priority of encryption modes further
  crypto: x86/aesni-intel - Add transitional selections

 arch/x86/crypto/Kconfig    | 12 ++++++++++--
 crypto/aes.c               | 12 ++++++------
 lib/crypto/x86/aes-aesni.S | 25 +++++++++++++------------
 3 files changed, 29 insertions(+), 20 deletions(-)


base-commit: 69897f5e8552af8835a2c8a36aa7d597e1cf6689
-- 
2.55.0

