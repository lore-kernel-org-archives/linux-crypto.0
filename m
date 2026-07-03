Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A60C272801
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 03:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783047664; cv=none; b=qLuFWlcd6g9aYHkrlxuorgr2B3YQgmUsCwH03z//5DQlmO+XbmiIeh2jGpHlzllGiNdqSR956IFr8XsYQB26+ao7NZxwwqNdLqw7MPK66vrC4aa6Zu9xOzy9l9vWhgwMrCConhxIgfsQ+h9jKtWAIhebFMGq3nzB9YLZv1q//lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783047664; c=relaxed/simple;
	bh=6NjfDtvfguHyET98XVCFvMjKd8ovYZdUgW7vZatG5EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3Y3kttcRCBK0Z3jzhLgP0gGnjlMJaHWugLXpx3jcSYAgkCerS0Rj6euK90j9AU/ACRypVq00bqM0dCSHnisLs3H0+finYPrxysyfVyZAN40hNBbHkPwMCblEfEOqoxi4rCLayVItSgRQ+QOBloXcx+g8hWdA8eT215/kxSajjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=YWMb62w4; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="YWMb62w4"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49241dbf9c1so426735e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 20:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1783047661; x=1783652461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yTs/XtijO8c54KRJepqsfIing448R27R7obvVm8uj2U=;
        b=YWMb62w4LgZS/WeqADa/plP29wbXVWRvJUCIeWTp8eTl8SRn3iohCU58xHX812eB/H
         PuU6NllLTxpo5fBCBJZ9n7O4scCY/nYPiH0KQtyfxRB0aLaErR3wa4teTCa5OzQIF5Sp
         hLdji4C2E/zC2l/e1mXyehuqEbcWeIsrxYAKj9Ezr3B/pd3ba3aydYxu0+eGt6VHoEl9
         F7OY500wgs3Jc6LINYK9oFmuraeNH9vFNSmBoY7qB2EPTMhQIQNCM7WV1ATGLFBCJgcq
         anokeRj62+e31rOFKJ7kMHvrt8kbw/A/5fgXaNekYl7SoCM4BC35Qn/Mfq0jeGZrPMb3
         9mdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783047661; x=1783652461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yTs/XtijO8c54KRJepqsfIing448R27R7obvVm8uj2U=;
        b=fdAadGpyGpi7W5DbWvEwRe4SiRT+82DoSRoTMtl8ZRSt9uPVD/F6dhXJ3SkhcloOnb
         Bs954X4wmZpF0ko+pNCRfApSlX4zF7b60jxJVfHx/Y1/iyqr0RmWxuWAOlg/HPdJhZwt
         JLpLsz8EhBn/z6fkX7BojPYk+BPiJJ0Ah/6zya1lqqxMUY4TiA1EbrqQxQDqEykFJbHi
         Y2Dq5FyqDrX7CioxHuyX0C7ebywxlU5Tvg8FwPfHNz/gtxQGHOG6GNuMJSyscT9F3q6p
         0clflqqxoRq9CSPw4aVo4LpoKFRhe0yoITUe+hNZDNlYAyOMIF0sYIqhULza89c+dyfe
         SI+Q==
X-Gm-Message-State: AOJu0YwRrCmAeaS14O9XPE9uK05YURvAYcP751enFFPlY2clFJ/hxK1h
	D5AJEs63OG2qu2/7blWVQNN2RDCYLpvj22uRdlP01/oKR9ja1Qn8loAQwUyf+8U4og==
X-Gm-Gg: AfdE7cnEn9xB/L7fzLUeYH5ul/9Af9H0AYW08rouLcbEDFnVTK9UkkCKZbLnoJp3cIs
	nboME7Fa644Eb/FNCEGtaTzUnogoux8pkSe5G8ZvGyQ/VaFU9+tLGun88R3Y8UHIb4H8/wGnyCw
	4xqx+abXaZ59dWMC1rZIlsmvUrGVlm+HVmpzNH9sFGWQLH2YCFahaGb7bkaJMZgFJXopVthdSJd
	PK0Xpxc6OLGpWgaWG3RDHRM9OBdGN3mTVuL2mvixxwWUDC0WYvsXPD1tf/s4U+Dw5SI6T3Ec80t
	ZvFTtlLT6hQWKZxGR9PM1l79e1DxAM3zrrCw/N7t5XdmIx/AfStI8NsWIMJSw0/K0otbsOh4gGP
	k4XkJd118J7fWmlkr3u/GZQ1IEOieIA4djzC4B4PkyWFD3CniEgS04oQ4Vkc6DYFrVMLcA0d7Ml
	h16icB1YckHJqsqIeXT12AuNUkuR1qZJvcaD/duXbtTAbkrJj7wt4GygAZ
X-Received: by 2002:a05:600c:2e43:b0:493:c14a:a1ca with SMTP id 5b1f17b1804b1-493c3cd4aeemr75130465e9.3.1783047660863;
        Thu, 02 Jul 2026 20:01:00 -0700 (PDT)
Received: from axion.fireburn.co.uk ([137.220.119.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef183e7sm199495015e9.2.2026.07.02.20.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 20:00:59 -0700 (PDT)
From: Mike Lothian <mike@fireburn.co.uk>
To: rust-for-linux@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	linux-kernel@vger.kernel.org,
	Mike Lothian <mike@fireburn.co.uk>
Subject: [RFC PATCH v2 0/3] rust: crypto: library AES-128 / SHA-256 / HMAC + RSA
Date: Fri,  3 Jul 2026 04:00:50 +0100
Message-ID: <20260703030056.2763-1-mike@fireburn.co.uk>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260617150143.2152-1-mike@fireburn.co.uk>
References: <20260617150143.2152-1-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the crypto bindings, rebased onto current drm-next --
no functional change from the version prepared but never sent after
v1's review (see "Changes since v1" below for what that review fixed).
It adds a small, reusable kernel::crypto module so in-kernel Rust code
can hash, MAC, encrypt a single AES block, and do RSA public-key
encryption:

  1/3  sha256(), hmac_sha256(), Aes128 (key-prepared-once block cipher)
  2/3  aes_cmac() over the in-tree AES-CMAC library
  3/3  rsa_pubkey_encrypt() over a new lib/crypto RSA primitive

Patch 1 binds the library crypto (lib/crypto) functions directly
(SHA-256 / HMAC-SHA256) and uses one rust_helper_ shim for aes_encrypt()
(its transparent union is unbindable). It runs synchronously in the
calling context with no allocation and is the independently-mergeable,
self-contained contribution.

Patch 2 adds crypto::aes_cmac() over the in-tree AES-CMAC library
(<crypto/aes-cbc-macs.h>) -- the one mode of operation the consumer needs
that lib/crypto already ships -- rather than building CMAC out of bare
AES. The 128-bit key is prepared once and wiped after use.

Patch 3 adds an RSA public-key primitive. Rather than bind crypto_akcipher
(which Eric flagged as a very bad API not to grow), it adds a small
lib/crypto entry point -- lib/crypto/rsa.c, rsa_pubkey_encrypt(), the bare
RSAEP primitive c = m^e mod n [RFC8017 sec 5.1.1] over the MPI library --
and binds that directly: no akcipher tfm, DER key encoding, scatterlists or
async completion. The caller applies its own padding (RSAES-OAEP, ...). It
is gated by a new bool CONFIG_CRYPTO_LIB_RSA (selects MPILIB); because the
Rust wrapper is exported from the built-in kernel crate the symbol must be
in vmlinux, so the option is a bool and the wrapper is
#[cfg(CONFIG_CRYPTO_LIB_RSA)]-gated -- a kernel that does not configure it
gains no dependency. A from-scratch constant-time/allocation-free lib/crypto
RSA (Eric's longer-term direction) is left as future work.

All three were factored out of an in-kernel Rust DisplayLink DL3 dock
driver (which needs SHA/HMAC/AES-CMAC for HDCP 2.2 and RSA for the AKE),
posted alongside as drm/vino ("[RFC PATCH v2 00/6] drm/vino: DisplayLink
DL3 dock driver"); the intent is to land both upstream. The module is
generic. Compile-tested in-tree against current drm-next. Source:
  https://github.com/FireBurn/vino-scripts
  https://github.com/FireBurn/linux/tree/vino
  https://gitlab.freedesktop.org/FireBurn/linux/-/tree/vino

Changes since v1 (Eric Biggers):
 - Drop the bare single-block ECB helper that re-expanded the key per block;
   Aes128 now prepares the key schedule once and reuses it for a keystream.
 - Add aes_cmac() over the in-tree AES-CMAC library (<crypto/aes-cbc-macs.h>)
   instead of building CMAC out of bare AES (now patch 2/3); the vino driver
   drops its hand-rolled CMAC for it.
 - RSA no longer binds crypto_akcipher. v1 exposed an Akcipher transform;
   following Eric's guidance to drop that API, v2 adds a small lib/crypto RSA
   primitive instead (lib/crypto/rsa.c, now patch 3/3) and binds it directly.
   A full constant-time lib/crypto RSA is left as future work.
 - Rebased onto current drm-next; no other functional change.

Mike Lothian (3):
  rust: crypto: add library AES-128 / SHA-256 / HMAC-SHA256 bindings
  rust: crypto: use the in-tree AES-CMAC library
  rust: crypto: add an RSA public-key primitive in lib/crypto

 include/crypto/rsa.h            |  15 +++
 lib/crypto/Kconfig              |   9 ++
 lib/crypto/Makefile             |   3 +
 lib/crypto/rsa.c                | 102 +++++++++++++++++++
 rust/bindings/bindings_helper.h |   4 +
 rust/helpers/crypto.c           |  37 +++++++
 rust/helpers/helpers.c          |   1 +
 rust/kernel/crypto.rs           | 169 ++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   1 +
 9 files changed, 341 insertions(+)
 create mode 100644 include/crypto/rsa.h
 create mode 100644 lib/crypto/rsa.c
 create mode 100644 rust/helpers/crypto.c
 create mode 100644 rust/kernel/crypto.rs

--
2.55.0
