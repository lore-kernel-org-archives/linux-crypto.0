Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726245;
	b=Fvax69CJgnM8UkGTIIMcKXaTM5CozNukTeoCtO+pAhR8J/dd57llPcvUhwxMgAzXQxAp
	 TQF+P2A0d4p+QUizBqP+9mBlkeucsBs82jQXANBNuk0myB7fFEG/dngNaPE1fPdtvo07Q
	 ajI3sEkqQS92AsLFpg5dJ5dveNPmvJ/I9JjchkUsVBAeIqq6We20TSNX+PZ0FR4KLstdJ
	 NGxkuU5q+nxqhXA39BF+3JVKGzbxLaK0l0CiHjinI1bkVzUj2tbs2o4JrTJj6BdG1V2Fz
	 pazbhRV5tOTDPvXdWlHJh702NcVwTuOEKBewbWkaoMHgOuhV2NjoiTbDoe+XAzlehvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=47uctfknZAl1bwr9V1MsOoUGRw1jsR3MWRhX9WJ8Zn4=;
	b=CGKvaHQOeB9d3BiVYqew+aRN2+DyYMdyJWlIYlaNW9kTwqhc+8/5hcS/AstutRvhLFKe
	 ethVBWygNQcsi+5b2jSIVaZ34kVwFFVuFXP5/yvY02WbOUyxK8IYzR2VLr5+hQtBB/aIO
	 GiqI9nLCxqTIzVamMcb61LoprujLttZsBiuJhEKBixAx3gNXxwPXVwpBUgwJHcJAuUQP4
	 E7NZ4EiDes1mwbX5QTieNKtZrycYKn8wacNhzXjcS3mKAdQ4wrdlKADA06rV9kaskiCbN
	 RJhzyYzYx0eXTZfxm9bz7YwNhHv006GmrFROU3P5wpkZ8dyGMCRBLi0lIRCw552eTog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tkey1PZs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id ECD4D606A31C;
	Thu, 26 Nov 2026 20:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tkey1PZs
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CF4441F000C1;
	Thu, 26 Nov 2026 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726244;
	bh=47uctfknZAl1bwr9V1MsOoUGRw1jsR3MWRhX9WJ8Zn4=;
	h=From:To:Cc:Subject:Date;
	b=Tkey1PZsS/r5Ig1mJsJfIQfxOtheg9etjeiL+zLzdj293jMj+tAC3KOvcd0jFhrg2
	 Eyn4M5rawQDtR9pEI843Uc9KLNbv3zJrdvXhTALXswuwXzUy2UUpfrCob/VXP09/It
	 qao3k115uFacV8+sQBMD3wb9HINZOXKlURxi+EjL7BardSkh2mEcDeCjrZ/ty+0bLi
	 Of+YzbDFdSEBfVu5AuL16QTM6YOH5HwMCyXxukizRBPvhet+xo/ygR8ZRBjxrgfFQt
	 nPVoSo7nUkOw+np3DGjqU/dHGP90xwTWVhP64aH1KWEHJuGASU1Ze9ZU+qhmnaIxcQ
	 LjsCnHMympi6Q==
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
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v4 00/11] KEYS: trusted: asymmetric keys
Date: Thu, 26 Nov 2026 22:50:10 +0200
Message-ID: <20261126205021.2200819-1-jarkko@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
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

v4:
- KEYS: Turn CONFIG_KEYCTL_PKEY into a hidden helper symbol selected per
  subsystem: add off-by-default CONFIG_ASYMMETRIC_KEY_PKEY for software
  asymmetric keys, and switch TURRIS_SIGNING_KEY,
  TURRIS_OMNIA_MCU_KEYCTL, and TURRIS_MOX_RWTM_KEYCTL from
  CONFIG_ASYMMETRIC_KEY_TYPE to CONFIG_KEYCTL_PKEY (remaining default y).
- trusted: Default CONFIG_TRUSTED_KEYS_ASYMMETRIC to y and select
  CONFIG_KEYCTL_PKEY.
- trusted: Split "KEYS: trusted: Factor out TPM2 blob loading" into
  separate patches for public_len bounds checking, the private backend
  pointer in trusted_key_payload, and TPM2 blob loading.

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

v3: https://lore.kernel.org/keyrings/20261125180616.1854753-1-jarkko@kernel.org/
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
Cc: Marek Behún <kabel@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sumit Garg <sumit.garg@kernel.org>

Jarkko Sakkinen (11):
  KEYS: Factor out KEYCTL_PKEY
  KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
  KEYS: trusted: Validate public_len before reading key attributes
  lib/asn1_encoder: Add asn1_encode_integer_bytes()
  tpm: Export tpm2_create_primary()
  tpm: Add persistent hierarchies to tpm2_create_primary()
  KEYS: trusted: Extend TPMKey support
  KEYS: trusted: Reject zero-length keys in symmetric consumers
  KEYS: trusted: Add private backend data to trusted_key_payload
  KEYS: trusted: Factor out TPM2 blob loading
  KEYS: trusted: Add asymmetric key support for TPM2

 .../security/keys/trusted-encrypted.rst       |   25 +-
 crypto/af_alg.c                               |    2 +
 crypto/asymmetric_keys/Kconfig                |   11 +
 crypto/asymmetric_keys/asymmetric_keys.h      |    2 +
 crypto/asymmetric_keys/asymmetric_type.c      |    4 +
 drivers/char/tpm/Kconfig                      |    2 +-
 drivers/char/tpm/tpm2-sessions.c              |  239 +--
 drivers/firmware/Kconfig                      |    1 -
 drivers/md/dm-crypt.c                         |    2 +-
 drivers/platform/cznic/Kconfig                |    3 +-
 include/keys/trusted-type.h                   |    5 +-
 include/keys/trusted_tpm.h                    |   16 +-
 include/linux/asn1_encoder.h                  |    3 +
 include/linux/tpm.h                           |    2 +
 include/linux/tpm_command.h                   |   13 +
 lib/asn1_encoder.c                            |   56 +
 security/keys/Kconfig                         |    3 +
 security/keys/Makefile                        |    2 +-
 .../keys/encrypted-keys/masterkey_trusted.c   |    5 +
 security/keys/internal.h                      |    2 +-
 security/keys/keyctl.c                        |    2 +-
 security/keys/trusted-keys/Kconfig            |   11 +
 security/keys/trusted-keys/tpm2key.asn1       |   19 +
 security/keys/trusted-keys/trusted_core.c     |   20 +-
 security/keys/trusted-keys/trusted_tpm1.c     |   26 +
 security/keys/trusted-keys/trusted_tpm2.c     | 1341 +++++++++++++++--
 26 files changed, 1604 insertions(+), 213 deletions(-)

-- 
2.47.3

