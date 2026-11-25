Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629989;
	b=sY81MHrdJ2UvspfO7Ov87nXCyqij0Y8KPpuF8neTi4gHZlyFuW1TpWbtuzsJzrAChCgy
	 Y8ynoztbpkTcM8gkxHG3iV/tWjGOzB0YGiwz9/E/+sqH5kP4XQo+oDPvRs4pJkrNLbk+U
	 YEXA9pxFgas/JH/LTaQr+i8FSjuRdt61BKQ5tceOEUMDmtcQF9cm8i7dqn+KA3H8PtiwR
	 j7mWHLXU7PL8I53R13kHqRrL0SondzAI57LH3x0xd3/luuSZA1+LT5qvEhN7nT4aG0epp
	 bzvOXjn6CBt20hM4YaYhztShyNYb3hmZPemBWHU3fs6M2mjW6Kw5lyry+fXnCqs+yGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vwVW9YYt52UiA2UrUYRcnOGpfUWCz+wNtn31rCLdqFI=;
	b=D5okhRcwNq3o7dTpVPl4NvFxYYajxXHcg2whabO01poH/piQo+FPs1QokaNGTTJFELQE
	 G46qgurx3AFn14E+3Y9Toc3yWt8ruafb8J1v20yugvBuWEvnPgCkmWPo00vXXYJejly6A
	 nJWCWtI4m+L33Fzi19m/XtB6fBQcFaD2tSFVQIBnggFc77u0pT6/KAqxT+hGv082h5xoT
	 nsZycQUrwn+G0s+Omc7Px8b0f6eSBzrDJkFXvWzavKMaCebyIsB3+VBtUVP3H0hkcH7qG
	 bq2PHsTBwQw89/4SF7lwZSTXlGYdj4g4/SfFdd6/1My1Bq5reHJ9Sno7cj9qm8SX7Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dvLsqJg7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9AED5606A32C;
	Wed, 25 Nov 2026 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dvLsqJg7
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7DF011F000D8;
	Wed, 25 Nov 2026 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795629989;
	bh=vwVW9YYt52UiA2UrUYRcnOGpfUWCz+wNtn31rCLdqFI=;
	h=From:To:Cc:Subject:Date;
	b=dvLsqJg73toqPo0JCwKO5eJMco5MqUX3xpeeKN1JNRHYm5qAoXjaNrEkqBYKxxpoW
	 TwN9wfxMVbTQWwgny92HNmGs1UN3epIx8rSqPfxUOTutiuywAix/arXzHfTHbWIb0+
	 MEBPc1JwFvirC0CwP9OpY59WXyOf/6KjBOgm+vB05WD2Wm60nfvp240y8EJzI/o2kP
	 +6UONVFj8voG9q/lOVvpNVh2oUNALlb+Zls3I/eZhgSP8as407R/Wgk3BOpK3gqVPB
	 4TLPncSNJFagiTT0LLYSashWMdkV4DjBOcWJ10PT6CWs3U7eXnySX1b+AFIMguI9rS
	 hwduqdbq/R+Rg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v3 0/9] KEYS: trusted: asymmetric keys
Date: Wed, 25 Nov 2026 20:06:06 +0200
Message-ID: <20261125180616.1854753-1-jarkko@kernel.org>
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

Extend TPM 2.0 trusted keys to load ASN.1 TPMKey [1] asymmetric keys
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

CHANGES
=======

v3:
- KEYS: Move CONFIG_KEYCTL_PKEY factoring to the beginning of the series
  and make it an off-by-default prompt instead of selecting it from
  CONFIG_ASYMMETRIC_KEY_TYPE.
- trusted: Make CONFIG_TRUSTED_KEYS_ASYMMETRIC depend on
  CONFIG_KEYCTL_PKEY instead of selecting it.
- trusted: Use unsigned int instead of u16 for data_len and min_len in
  tpm2_unseal_cmd().
- asn1: The reason for not supporting implicit tags was that it follows
  what other functions do in asn1_encoder.c, and is that way coherent.

v2:
- lib/asn1_encoder: Remove unreachable !bytes_len branch in
  asn1_encode_integer_bytes().
- tpm: Bounds-check ECC coordinates, defer state updates until after
  validation, and verify subsequent TPM2_RH_NULL primaries against
  chip->null_key_name in tpm2_parse_create_primary().
- trusted: Reject trailing or truncated TPM2B bytes in tpm2_key_decode() so
  tpm2_load_cmd() and tpm2_asym_load() pass the same blob length.
- trusted: Avoid 32-bit param_size wraparound in tpm2_asym_rsa_decrypt()
  and tpm2_asym_parse_signature().

VERSIONS
========

v2: https://lore.kernel.org/keyrings/20261124194043.1651679-1-jarkko@kernel.org/
v1: https://lore.kernel.org/keyrings/20261124120044.1481752-1-jarkko@kernel.org/

Cc: dm-devel@lists.linux.dev
Cc: keyrings@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: David Gstir <david@sigma-star.at>
Cc: David Howells <dhowells@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ignat Korchagin <ignat@linux.win>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Morris <jmorris@namei.org>
Cc: James Prestwood <prestwoj@gmail.com>
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
Cc: Sumit Garg <sumit.garg@kernel.org>

Jarkko Sakkinen (9):
  KEYS: Factor out opt-in KEYCTL_PKEY
  KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
  lib/asn1_encoder: Add asn1_encode_integer_bytes()
  tpm: Export tpm2_create_primary()
  tpm: Add persistent hierarchies to tpm2_create_primary()
  KEYS: trusted: Extend TPMKey support
  KEYS: trusted: Reject zero-length keys in symmetric consumers
  KEYS: trusted: Factor out TPM2 blob loading
  KEYS: trusted: Add asymmetric key support for TPM2

 .../security/keys/trusted-encrypted.rst       |   25 +-
 crypto/af_alg.c                               |    2 +
 drivers/char/tpm/Kconfig                      |    2 +-
 drivers/char/tpm/tpm2-sessions.c              |  239 +--
 drivers/md/dm-crypt.c                         |    2 +-
 include/keys/trusted-type.h                   |    5 +-
 include/keys/trusted_tpm.h                    |   16 +-
 include/linux/asn1_encoder.h                  |    3 +
 include/linux/tpm.h                           |    2 +
 include/linux/tpm_command.h                   |   13 +
 lib/asn1_encoder.c                            |   56 +
 security/keys/Kconfig                         |    9 +
 security/keys/Makefile                        |    2 +-
 .../keys/encrypted-keys/masterkey_trusted.c   |    5 +
 security/keys/internal.h                      |    2 +-
 security/keys/keyctl.c                        |    2 +-
 security/keys/trusted-keys/Kconfig            |   10 +
 security/keys/trusted-keys/tpm2key.asn1       |   19 +
 security/keys/trusted-keys/trusted_core.c     |   20 +-
 security/keys/trusted-keys/trusted_tpm1.c     |   26 +
 security/keys/trusted-keys/trusted_tpm2.c     | 1341 +++++++++++++++--
 21 files changed, 1591 insertions(+), 210 deletions(-)

--
2.47.3

