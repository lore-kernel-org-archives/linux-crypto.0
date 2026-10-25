Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792887102;
	b=08uiorJfrOivaNpFTw9H6Uz3FbI1sy1h3UrDQnvMcULtiw1+wINYfroG7ELWN7T4GVj2
	 ypAoobbcpMq8+I1sCBVekRKCiaefxA0VBlaYMwu1fTKtDvL/FdKjSnn6YzO5IrLpcJM0k
	 /sSaz8r4AcFfK3I0tDNrBmZR+ELRn/JH5NM0jvSQfv0mHU/5RqtkT1Gl4VQV0RptOJtv0
	 a8lsH5sz1AepY4dQAxz0BqjaCl5jBDruQw8932qA8Y5UOfFOijKiiX/i4aYn1bdeHCr4n
	 JUzc+FqFvshnaExgARDcPzbaKxFp3/JRPhFrvrjFdImxffSVmRKx3aEY/2CzDQZs3OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792887102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hyNNUZaRnakcEtdBWh6hHPbyrLmmMxNp/bH3C2xcpVY=;
	b=Xinz17cI85m32a6WMyDbkvJh4s7di2wnaPkrRUi0TrnGv8cer6zRn5fG3eKEFiiVZOJW
	 NMHyYY+7GgRkQ9Pc2GWMdYhA10GBiSIvejAnMh2luneFqEVzF3gcjWm3yuxpNYSfB8uBG
	 zcxvrX6ug6qGw1nYiLeFu5YOaJGeVPjcloQL3VXxuerkaIGsGt5xN40h4JkJF9gm0tcmj
	 mfSUg7r4TlEAzaXCgElz5OiCMSdoZgk1HWG7s5JAB3XE4uFwV4dBDoIcUttKh9Uz83r5Q
	 4M0BqxYjTKmxwXCKy3kXKpKEe0gcdcfSos1waIaWYUeURoFOfoZPWFYDojujPQKJa3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cyrrfm/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6F04D606A31A;
	Sun, 25 Oct 2026 00:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cyrrfm/L
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 59BBF1F01825;
	Sun, 25 Oct 2026 00:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792887102;
	bh=hyNNUZaRnakcEtdBWh6hHPbyrLmmMxNp/bH3C2xcpVY=;
	h=From:To:Cc:Subject:Date;
	b=cyrrfm/LuHwFLpOhIU5gkEif0YoAZzHEpEjo2eDLOvxhmjkTgSTqRDabx7jjPWZbY
	 OOn5vgrh10DqH2TSmFBu2b86u8+YlNu8OgTNyfUDDcz21n3bPpZ2KoBll9bBBokLJV
	 A6KTLmAs97hXSqu4L5JKYZrko3l2i0x9bBjE4PoW9MlYu2vxivxEvsJmeJ6ahQs5rF
	 ZhjVPPwZMIPkT8NGiCiVL4DB2nezv0RTCwpw6O8edRPPp/B4U5d96hU7DmI7fxM6ee
	 VYt1y0yEEUSjspHj2NJbOLKhVLjd9OcR/hsRw6z6nNL4kcgBAnTrQGlzEGvbg6Fw3w
	 4ROW54479cdlQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org (open list:RHASHTABLE),
	linux-kernel@vger.kernel.org (open list:LIBRARY CODE)
Subject: [PATCH v3 0/6] KEYS: Replace assoc_array with rhashtable
Date: Sun, 25 Oct 2026 03:10:08 +0300
Message-ID: <20261025001105.1824178-1-jarkko@kernel.org>
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

The keyring subsystem depends on assoc_array for searching keys by their
description, type and domain. It is the sole user of this data structure,
which has during the age of LLMs transformed into a maintenance nightmare.

assoc_array needs to be replaced with a data structure meeting the
following criteria:

1. Must be suitable for a sparse key-value store.
2. Must have multiple in-kernel users.
3. Would be nice if it had dedicated maintainers.

rhashtable is likely the best pick from the available options as it is
designed for a sparse key space, has dedicated maintainers, and multiple
in-kernel users.

CHANGES
=======

v3:
- Since David is away for the next week I decided to address the
  low hanging fruit that I reported myself.
- Unified and sanitized function and variable naming and removed
  unnecessary asymmetry e.g., by renaming keyring_remove_all_links
  as keyring_index_free, 'links' as 'index' and '_edit' as 'edit'.
- Flattened the implementation by refactoring out some useless
  wrappers and other constructs.
- Addressed continuation after triggered WARN_ON() on at the three
  sites that I've described in my email response to the previous
  patch set version.
- Reworked keyring_read() so that it triggers the scheduler between
  the iterations.
- Dropped "Assisted-by: LLM" tag because checkpatch.pl told me so.

v2:
- Tried to address all the issues pointed out by David and Eric. Tell me
  if something was ignored, as that would be an unintentional mishap.
- Updated and trimmed the source code comments.
- For assoc_array_edit I decided to go with two-element pointer array,
  which shifts a bit what David suggested.
- Dropped is_keyring flag. It was so obvious call so I mention it here
  just in case because too obvious maxes out my self-doubt ;-)
- Used cleanup.h primitives where I possibly could especially in order
  to make fallible initializations more bug-resistant.
- The already-ack'd bug fixes are included but will be dropped as soon
  as I've sent them over to Linus.

VERSIONS
========

- v2: https://lore.kernel.org/keyrings/20261023120953.1206778-1-jarkko@kernel.org/
- v1: https://lore.kernel.org/keyrings/20261016215326.4110064-1-jarkko@kernel.org/



Jarkko Sakkinen (6):
  KEYS: Expand key->{datalen,quotalen} to unsigned int
  KEYS: Reject descriptions larger than KEY_MAX_DESC_SIZE
  KEYS: Verify the key identity in __key_unlink_begin
  KEYS: Introduce keyring_is_empty()
  KEYS: Replace assoc_array with rhashtable
  lib: Remove assoc_array

 Documentation/core-api/assoc_array.rst        |  564 ------
 Documentation/core-api/index.rst              |    1 -
 .../zh_CN/core-api/assoc_array.rst            |  473 -----
 .../translations/zh_CN/core-api/index.rst     |    1 -
 drivers/md/dm-verity-verify-sig.c             |    2 +-
 fs/smb/client/cifsacl.c                       |    6 +-
 fs/verity/signature.c                         |    2 +-
 include/keys/keyring-type.h                   |    1 -
 include/linux/assoc_array.h                   |   88 -
 include/linux/assoc_array_priv.h              |  178 --
 include/linux/key.h                           |   27 +-
 lib/Kconfig                                   |   14 -
 lib/Makefile                                  |    1 -
 lib/assoc_array.c                             | 1724 -----------------
 security/keys/Kconfig                         |    1 -
 security/keys/internal.h                      |    9 +-
 security/keys/key.c                           |   32 +-
 security/keys/keyctl.c                        |    2 -
 security/keys/keyring.c                       |  940 +++++----
 security/keys/request_key.c                   |   24 +-
 .../dm-verity/test-dm-verity-keyring.sh       |    2 +-
 21 files changed, 491 insertions(+), 3601 deletions(-)
 delete mode 100644 Documentation/core-api/assoc_array.rst
 delete mode 100644 Documentation/translations/zh_CN/core-api/assoc_array.rst
 delete mode 100644 include/linux/assoc_array.h
 delete mode 100644 include/linux/assoc_array_priv.h
 delete mode 100644 lib/assoc_array.c

-- 
2.47.3

