Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521669;
	b=q4AIeslkZqwWmWYsrTdxWNiB1lDWLxGnbxtfjUrL12dpyrvYs21bQs7XbgrP8kjVIqf4
	 6FqMYUz0+ZmiMsZ3PG6Jm0YGikGfYtQJNy14vtVj6aBFNwR6FJvQze/DC7w1jB9c3fElv
	 1M9HfOBwduS1cB/gkth/vzOkttdCKF0PTUj3VCwrSYHuKLBT/QEZFs5Rdy0EKckvZNwk4
	 w3/i7fxMXieTLQm0+DlZGgmpsQakVclT64t9GC1UFwnxcsSmeKiqxsrN+0Gc8znWAtZu5
	 n1h3jYh1NwQWmx+AD7pw2RrcOWBiTTzjtMahyPCueEeHv8E57ZOa5FKeFi1zAMeQdkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G3HDr+rlUwMTz5EXde1gL4gZLnJyvEJHBt9n0Z6ARZQ=;
	b=WJFIJyT/4VgT6PfbzuRsDLSQ9CSgrZRcKo8CW8WgUzOqMpyiWxxTAq5TjcCi0YtHNZxy
	 hi/aAGfuaJLgFKUxXN+H64H+nnHD6ockxtGVjJs7NlKoL7kDmE4JR+EjmHI00RQhKmB34
	 4RJcyQhzSseNa/WBX+cBS5YX3xazsZ7LpMfmeV4yzhuiBcXgPlj0o0fNsHKReIaJqy9h0
	 J0szBKIIiq1tuGXwZnh3Sjzmsbh+3W2yypHaOZfqd+CxDPkSE+nMu4J5MP4skzW+DrMPT
	 sVaL3BquSSh+Ab68h/WkjJh42lLDeT0b5nyChQDunrrObgbN2KftC+RtKzicvybDwnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GNTb5Qoz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 94DAC606A31E;
	Tue, 24 Nov 2026 12:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GNTb5Qoz
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8EAD21F000E0;
	Tue, 24 Nov 2026 12:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795521669;
	bh=G3HDr+rlUwMTz5EXde1gL4gZLnJyvEJHBt9n0Z6ARZQ=;
	h=From:To:Cc:Subject:Date;
	b=GNTb5QozUrSxKzyzzcv4Q2v8rkGNOqMbQ72p7tucOe3ayS3iNCjw3EcGTpfTi3nWM
	 yLYmeb13NYLhXxMnMjPoZCcS7/M+Foiq5R6HfBmUbwiHlNyX14BIWOzZr2jdN7KYJ9
	 OsVmLomDFU0QjapgGcaqT4Z1WQpFRNssOcg8iDgkFEZ+PmHL6QCemEcIGo7ts7wvNn
	 I+JG6Gwx/JyiPr1eKvzZZWHN7ITbVE/+2+7VaxskuwBbPJvQujJ9EUytj7v0fH/FZC
	 ETureQXTNn3Jg0jmy31RNXP08r1ZjEVvw3GQQUwZvN/62MH4PG1bEWf9yrbhj2i+GW
	 5/osVEamRrKhw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 0/9] KEYS: trusted: asymmetric keys
Date: Tue, 24 Nov 2026 14:00:35 +0200
Message-ID: <20261124120044.1481752-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OVERVIEW
========

Extend  TPM 2.0 trusted keys to load ASN.1 TPMKey [1] asymmetric keys
(OID_TPMLoadableKey, 2.23.133.10.1.3) and expose keyctl pkey-operations
directly on key_type_trusted. In addition there are some TPMKey
interoperability fixes.

I.e. this my old series with a twist: instead of introducing a separate
subtype for asymmetric keys, factor out pkey-operations into a separate
CONFIG_KEYCTL_PKEY-feature, and wire asymmetric operations to
key_type_trusted.

This work was originally derived from [3] and is direct offspring of
[2].

[1] https://www.hansenpartnership.com/draft-bottomley-tpm2-keys.html
[2] https://lore.kernel.org/linux-integrity/20240520184727.22038-1-jarkko@kernel.org/
[3] https://lore.kernel.org/all/20200518172704.29608-1-prestwoj@gmail.com/

Cc: dm-devel@lists.linux.dev
Cc: keyrings@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ignat Korchagin <ignat@linux.win>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>

Jarkko Sakkinen (9):
  KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
  lib/asn1_encoder: Add asn1_encode_integer_bytes()
  tpm: Export tpm2_create_primary()
  tpm: Add persistent hierarchies to tpm2_create_primary()
  KEYS: trusted: Extend TPMKey support
  KEYS: Factor out KEYCTL_PKEY
  KEYS: trusted: Reject zero-length keys in symmetric consumers
  KEYS: trusted: Factor out TPM2 blob loading
  KEYS: trusted: Add asymmetric key support for TPM2

 .../security/keys/trusted-encrypted.rst       |   25 +-
 crypto/af_alg.c                               |    2 +
 crypto/asymmetric_keys/Kconfig                |    1 +
 drivers/char/tpm/Kconfig                      |    2 +-
 drivers/char/tpm/tpm2-sessions.c              |  203 +--
 drivers/md/dm-crypt.c                         |    2 +-
 include/keys/trusted-type.h                   |    5 +-
 include/keys/trusted_tpm.h                    |   16 +-
 include/linux/asn1_encoder.h                  |    3 +
 include/linux/tpm.h                           |    2 +
 include/linux/tpm_command.h                   |   13 +
 lib/asn1_encoder.c                            |   62 +
 security/keys/Kconfig                         |    3 +
 security/keys/Makefile                        |    2 +-
 .../keys/encrypted-keys/masterkey_trusted.c   |    5 +
 security/keys/internal.h                      |    2 +-
 security/keys/keyctl.c                        |    2 +-
 security/keys/trusted-keys/Kconfig            |   10 +
 security/keys/trusted-keys/tpm2key.asn1       |   19 +
 security/keys/trusted-keys/trusted_core.c     |   20 +-
 security/keys/trusted-keys/trusted_tpm1.c     |   26 +
 security/keys/trusted-keys/trusted_tpm2.c     | 1332 ++++++++++++++++-
 22 files changed, 1558 insertions(+), 199 deletions(-)

--
2.47.3

