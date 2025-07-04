Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1171DF725;
	Fri,  4 Jul 2025 02:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751596927; cv=none; b=kbgdTYDrO4tpCh1njFScTwA8wRYWEW6E8H10ootrgIZ9iybvd4v8mzF1TCyGw7Y9aloe2MZytGhFNmVoXUUJXra6rxYdbrZ2BUTgT6oL8RFjdh/1Z3UUJ39NL560wI1cBNrvXcOEp0237yULdN+ohO+Ac6gP7YYdYMNyger3xgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751596927; c=relaxed/simple;
	bh=v1XVnqJQUcn6sALLisJ1BlBErGJpcSeLgRnAITE6LrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NXdcyUZEuOp83RAX+bX0kx2+X3BmX2eqILTsgXY3XMwI+bMVzYvdimRI7nWeR7K6qMseMhAdkQadzackIImgN7cEHfXmFdWiAqbWBC6Eg0lQciYScP5qYX9vS0sU/Kj9HTTLeUQ2ILa5PzNIS+VCoBRUmAtMkzyQnASoMNRNHsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1IX3xRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1IX3xRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62B2C4CEE3;
	Fri,  4 Jul 2025 02:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751596927;
	bh=v1XVnqJQUcn6sALLisJ1BlBErGJpcSeLgRnAITE6LrA=;
	h=From:To:Cc:Subject:Date:From;
	b=o1IX3xRjVj0mJChbUqCsyn+IZWT5YfZCpABgSsIZB7XG+XwSiUVtUHsCmRkkiGIJF
	 uTAISAw58gpnaIYXVVB0E5QcJ8u4YmFoGV1gNA8ZpT2DiIVDCPtQpGqOlB3Zta8t+G
	 xiKSDNpjRWpQtSecITUdNrALbNw4Pb+M2YNkJAB+Lpxg3WRhCU+umkj8+4NyFX0fWz
	 LmUTONgiFmSl5J7JwAujlWrhSoMpirZHQs73mlqjWoX+jxgGLSU0ftnEUoNf7Yhd+7
	 5VMH6L7UwQTln2p2tK/afpkeVFlr4XgftRhDxT+B5Yhni/BUnyhK2YdlLKbJxEMIkh
	 ZrZyd7UDM1K7w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] Small cleanups for x86 SHA-256
Date: Thu,  3 Jul 2025 19:39:56 -0700
Message-ID: <20250704023958.73274-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two small cleanups for the x86 SHA-256 code.  Applies to libcrypto-next.

Eric Biggers (2):
  lib/crypto: x86/sha256: Move static_call above kernel-mode FPU section
  lib/crypto: x86/sha256: Remove unnecessary checks for nblocks==0

 lib/crypto/x86/sha256-avx-asm.S   |  6 ----
 lib/crypto/x86/sha256-avx2-asm.S  |  4 ---
 lib/crypto/x86/sha256-ni-asm.S    |  5 ----
 lib/crypto/x86/sha256-ssse3-asm.S |  5 ----
 lib/crypto/x86/sha256.h           | 48 ++++++++++++++++---------------
 5 files changed, 25 insertions(+), 43 deletions(-)


base-commit: 5ecd15f4949fd36037725bd719b7d3f866291e6c
-- 
2.50.0

