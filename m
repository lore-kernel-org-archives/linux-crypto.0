Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316293;
	b=i3IlScKU/URd8mx7r34XH7n5txxx2QE8/xn+u9iZajI4KlKExIhK1B61ibRJOcFvXrot
	 kG+Z4p5fsuy/Qgzfy62QzYwZifHz6nOzDI5ddD/9FEpu4GzeG5IbEzd2AN2UlA/BO8X/i
	 myIvbFt4gZRAiHgVMbahSMh0CRhfAqvh1JnD2KElEUlhiskB5Ubaqgw7MUuUf9l6QseiR
	 adgtDNJcj1OE14DXkrRNwhEFclOABoTAZFaDKLlxBfBG8hwyXrl1R8wUtRiegpW0J5qp3
	 saDPJO/PY3ZQgqyQNylXkhVeo2xJcAM717qPRXYq7cjKYwv7rrORDeMGMRb1mf/7l3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T4tAZftUJD+d2YSvM7rMpcgvS5AUl5bH4MhnH2rAVZs=;
	b=R4hWAxT/Ru0AZu4fg08ymm1tc481dZLLbEgRk7TwattnGe5Z59UrFyM9CymsR3u6Ss3X
	 NioU8xv4NAfpmgtKdZGWZe5AD6NZ5GCkZGuNeBej2E+17OLhN4p6JW9i1pTrYQ3p36ePU
	 vVDYFWwqu7yq5AZV7xtvMrVO4cateFMlXyEM5nFK8LCGP2+LSvVmeEo0c9vOFkY0DEHdS
	 4s8uChGr8mS/6OOsZ8umCRlLpJCdFgFJtd9wXFupw32u0Dlh1QEmAZpBNeTMOnrzHPsk3
	 zfho0+PMUP/oKROyYaotd8U5m0nkJRKnmHKAGXHjGur6Vc4H8FPd+lvhoonuZk39gRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P0yLEDyt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 559A5606A31A;
	Thu, 29 Oct 2026 23:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P0yLEDyt
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 544ED1F00A15;
	Thu, 29 Oct 2026 23:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793316292;
	bh=T4tAZftUJD+d2YSvM7rMpcgvS5AUl5bH4MhnH2rAVZs=;
	h=From:To:Cc:Subject:Date;
	b=P0yLEDytLCB5JBaRXK0Bj5B678m6YrW9DCGxJ5LkdJ5GC1tGzZX8feuiXn2dHoOcC
	 6GBqZYAUhPyHPFCkyoBD3RwjP1i5djqLBBb58vq9I6UHxlorlbV1i1GkkaKy6ZZjDj
	 w8iMhHXMXYDrPASggqpZmiClYYOIN/L/qNEkx7uvB73/HUsrBVHrVErD3LPVznWjjE
	 ayE1z6oWHPFDIO+8P4HPtaJHlXe389E0PkXeGxhHUfrM7uVA7EHGBS25Z7u/5bhXeH
	 q7S6ukmUbPAbTncLMXpqCgaEcB1m9FSQD/SLYnMtqXj0/gc6N+wdFnpPQLg+ECskxD
	 CxCSpbQk/lY0g==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:ASYMMETRIC KEYS),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_))
Subject: [PATCH v4 0/3] KEYS: Replace assoc_array with rhashtable
Date: Fri, 30 Oct 2026 01:24:08 +0200
Message-ID: <20261029232437.2581640-1-jarkko@kernel.org>
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

v4:
- Eric Biggers: Correct the kerneldoc summary for keyring_is_empty().
- Eric Biggers: Truncate keyring_index_key hash to u32 and drop index_id.
- Eric Biggers, David Howells: Use a proper struct instead of a two-element
  array to pass the edits.
- Eric Biggers: __keyring_link(): Call key_put() in the rollback of
  rhashtable_replace_fast().
- Eric Biggers: Retract from using __free(kfree) in keyring_get_index().
- Eric Biggers: Reuse keyring_link_key() in keyring_obj_cmpfn().
- Eric Biggers: Document why keyring_index_free() uses queue_rcu_work().
- Eric Biggers: Fix the commit message for "KEYS: Replace assoc_array with
  rhashtable commit message".

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

- v3: https://lore.kernel.org/keyrings/20261025001105.1824178-1-jarkko@kernel.org/
- v2: https://lore.kernel.org/keyrings/20261023120953.1206778-1-jarkko@kernel.org/
- v1: https://lore.kernel.org/keyrings/20261016215326.4110064-1-jarkko@kernel.org/

Jarkko Sakkinen (3):
  KEYS: Introduce keyring_is_empty()
  KEYS: Replace assoc_array with rhashtable
  lib: Remove assoc_array

 Documentation/core-api/assoc_array.rst        |  564 ------
 Documentation/core-api/index.rst              |    1 -
 .../zh_CN/core-api/assoc_array.rst            |  473 -----
 .../translations/zh_CN/core-api/index.rst     |    1 -
 drivers/md/dm-verity-verify-sig.c             |    2 +-
 fs/verity/signature.c                         |    2 +-
 include/keys/keyring-type.h                   |    1 -
 include/linux/assoc_array.h                   |   88 -
 include/linux/assoc_array_priv.h              |  178 --
 include/linux/key-type.h                      |    1 -
 include/linux/key.h                           |   29 +-
 kernel/bpf/keys.c                             |    2 +-
 lib/Kconfig                                   |   14 -
 lib/Makefile                                  |    1 -
 lib/assoc_array.c                             | 1724 -----------------
 security/keys/Kconfig                         |    1 -
 security/keys/internal.h                      |   14 +-
 security/keys/key.c                           |   22 +-
 security/keys/keyring.c                       |  977 ++++------
 security/keys/request_key.c                   |    8 +-
 .../dm-verity/test-dm-verity-keyring.sh       |    2 +-
 21 files changed, 462 insertions(+), 3643 deletions(-)
 delete mode 100644 Documentation/core-api/assoc_array.rst
 delete mode 100644 Documentation/translations/zh_CN/core-api/assoc_array.rst
 delete mode 100644 include/linux/assoc_array.h
 delete mode 100644 include/linux/assoc_array_priv.h
 delete mode 100644 lib/assoc_array.c

--
2.47.3

