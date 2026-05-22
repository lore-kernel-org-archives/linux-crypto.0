Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C6E389DE3;
	Fri, 22 May 2026 05:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779427863; cv=none; b=B9k9IZYKRSUa+wlFZNqo9D+tewTpf7Z+nPA7Cw6/37GJLP9LkihXfdy8uOimbGpmEsxUwFL+3RTcLZHo9jNxeHmu26RujVR2QHqRpQSNz/ASHN8DBsqCMmkMti8k9qLI7cLFdGdXGxIXlpNmu2l2ooYIN9WDVDcpsGmBwEuj7e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779427863; c=relaxed/simple;
	bh=4a51hc2OqCTO0TD8iSPD8Qltbc9P/HKHbU9SClbKCj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BqAjv5ZZx+7gPI2Lf+Or0Y7+mf9IniDVG5EAh1vtpWfxASa3IMhJkfOHHZEXmLTttbBIWV3RunxwQ3YgiBtDQPK8r8MB4p0lhZSZjaMGLpBy1U+Mx04paGCDDxWrnIqpDgk7pFhi7rqLd2S2qtNmvEGU3NCefCu9M5RPxA79Om0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AqaEYa0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqaEYa0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01E81F000E9;
	Fri, 22 May 2026 05:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779427861;
	bh=8YCnnam31m4N89+V9ic9Yg6pDBZ5mnBZ7cSItXVc85s=;
	h=From:To:Cc:Subject:Date;
	b=AqaEYa0PiodfmveN3Z50Agvn52AsP3Dyij9bfuTwG0DnzmqNXYsaYaZBMswDJ8HvV
	 q7M+YL5HbMIzK1tYBkikxLruJ8cnmER0RFlSGDQtQgBks9+JgHZZh5ufbv0TEIWwwp
	 JA/N7PkzI7QFhDTZcaYZg4W5vDJR5Ij+faPRxt/jbzdJsgAmsJ2EZ58lRS9hqU72iE
	 tk7S8mztIVSD+79i15BzBAFJqRHtfnSJ+YYf/E9bIRY7n2oM/pt8ZxcQ963MNmg8DK
	 iu+DgBzHj0Y1Y7SJJxQ8ESMIaAWZiSZJ7FKnUsEHocWEFSldK1hIMsh/w+pEF4LaNA
	 2FhiUhz/Zig3Q==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next 0/6] Remove unused support for crypto tfm cloning
Date: Fri, 22 May 2026 00:30:22 -0500
Message-ID: <20260522053028.91165-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting net-next because it depends on
"net/tcp: Remove tcp_sigpool".  So far no commits in cryptodev conflict
with this, so I suggest that this be taken through net-next for 7.2.

This series removes support for transformation cloning from the crypto
API.  Now that the TCP-AO and TCP-MD5 code no longer uses it, it no
longer has a user.  And it's unlikely that a new one will appear, as the
library API solves the problem in a much simpler and more efficient way.

This feature also regressed performance for all crypto API users, since
it changed crypto transformation objects into reference-counted objects.
That added expensive atomic operations.  The refcount is reverted by
this series, thus fixing the performance regression.

A subset of this was previously sent in
https://lore.kernel.org/r/20260307224341.5644-1-ebiggers@kernel.org
Compared to that version, this version is a bit more comprehensive.

Eric Biggers (6):
  crypto: hash - Remove support for cloning hash tfms
  crypto: cipher - Remove crypto_clone_cipher()
  crypto: api - Remove crypto_clone_tfm()
  crypto: api - Remove per-tfm refcount
  crypto: api - Fold __crypto_alloc_tfmgfp() into __crypto_alloc_tfm()
  crypto: api - Fold crypto_alloc_tfmmem() into crypto_create_tfm_node()

 crypto/ahash.c                   | 70 -----------------------------
 crypto/api.c                     | 76 +++++---------------------------
 crypto/cipher.c                  | 28 ------------
 crypto/cmac.c                    | 16 -------
 crypto/cryptd.c                  | 16 -------
 crypto/hmac.c                    | 31 -------------
 crypto/internal.h                | 10 -----
 crypto/shash.c                   | 37 ----------------
 include/crypto/hash.h            |  8 ----
 include/crypto/internal/cipher.h |  2 -
 include/linux/crypto.h           |  1 -
 11 files changed, 10 insertions(+), 285 deletions(-)


base-commit: 1a1f055318d82e64485a6ff8420e5f70b4267998
-- 
2.54.0

