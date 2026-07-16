Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269DD32F75B
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2026 02:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784170767; cv=none; b=uDPhT1YD9XX7o79h69tVRQjOJeZ71mVKuSp19Tt7rtPpRjZvCtfaZGo6OQHJxOuL5F2Op8NI7sl52RLx7F6U8jf7OicmGW41mQIZ6Af1ZK+YJxbPYMmoXNLwyX1B2mIW/IOBu8XWuengCUatdBeR0gqIY7I0qLWrXl7BdTwdkFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784170767; c=relaxed/simple;
	bh=dfN0xnxU2xSU//ywarTiKgKVa7ITz1cmABR8itdl+K4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HYEc2p5ft7qluf/vXUfUel/EHxOPCh1fg3qRRyWUxAeoRM0M4Vl5ZlWeYA8qjcOPZDMiux+/jqLqYonsa8JL4Yz4SAzommDIoZofmR6GNX+uMFQRcxPtsBDDn1N+Jl8ABoUO+aePQKe7L4pM6BwTwM4ujy51xy4KRGIzei3ufgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aS6j+6fP; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aS6j+6fP"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-475881b9a4bso2506007f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 19:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784170764; x=1784775564; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jht2rj9zaiTuww5m68XBLb1icRqRgz+HwQaBP5RP6Ok=;
        b=aS6j+6fP4wjN3UPjyG3KX91U1QWuXu1HYZmCKS7wNPaGQh9jHLUMbQub+4QNN8czy7
         E5Z7LF7r6s4EedClQz7+Z+IyAZ1uYRljOj+U/B81LWxU5pbnISOVnuWvAb1AWd+/+ovk
         x1LEBu4+qBF1Wic+c0DGaUmbvFl4X6U3O7U2A2gobLzALGWvrkzT2oWpzEqzhhWGUuiq
         Bj/s50uXPnxyKW6l2NDZ1Iocowd+J2OSsMNs3bJ3MUxpenz+/KesuguzaPzSe9AvRbFn
         wgSARynf6+IfreSWdPgXa/ua7dg27l0xmTwTCP5t1875Wjpu727g7ftz20OpVxh+eH2+
         c5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784170764; x=1784775564;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jht2rj9zaiTuww5m68XBLb1icRqRgz+HwQaBP5RP6Ok=;
        b=akoUfacoGHMx2MCSfaiudGrqlgJQjS4vaax/MTGpt8qmaQSrn4sULl2wHpxLqfx4Si
         u/EcTHZXMrNAD9CpaiCgTdQuDoQ4RRBrpX4D5H4SEGEZ3/3tT5saCH9KoeWtD4UML8LX
         bfdMHRmWBTMvs7PZ44DmYPOOs6Rvej9AN7QAXjRQ2ftER2EiQjlKn0099RXpigmBC1cz
         B/bV5HM58RhAA9SHSgIf2g5XpiJF4C7VWFIgElto6uxwqzyi6vnXzU/O9M450gehKb7V
         K4NKvsSHRyWPKP6YG2yYQMhV61rs7q8dPkkrEPsKhhES6Zmd+KMo0j8La1+AD45cPcQx
         jyHg==
X-Gm-Message-State: AOJu0YwaTz9huCDR+Ak/OsgLlKir0TwcPdKUg74TraCNUt6a+olmQw3f
	SoVaFI622jTCcokPjOj9B9XdNFOZU7hqkZ5EoQxysULj3yGdr6fVt3iO
X-Gm-Gg: AfdE7cnV9i+s2SuxdfGr7M5yTScY5XAnzpHKAKdPAQistw5HqGvGZlgJ84y5FmV4lI2
	Buydb5XChPNDrOujRJlUYvpyGs25tvf6w3/I/cdPdkGDjAL+A1IGkq3Bqo3s6RJAX9ebbNx0d8N
	/aEg2mKmzbtSQSmgUpYl41NxOaIBcn4f0RXX3LoRMdG2C5Sj4kC5kBv8VsljhezCUsVgx7xyreo
	Hoa7rqdE1go9Ze2qTSGpB6oG+JoGpLPVqYxu+GsOOrNMfmxmvsepNBw83u3ur9lI7cMS62NQVd7
	vqEvfxP24gcnrMPrmXJWQa0U6QVA+ry6Ev8Ngtc8QUFkFZSeq/Mnus9F7rMmXtMl1SNNz+Znb/G
	3OGd8cBMxIAanKdYBx9ye10MLtJ70AdAkXO+6jchLbn2Kkq+Ioio4SnRAKHF58ROxIGvXTO5DKx
	so+9TsQfsAjk4MWOA=
X-Received: by 2002:a05:6000:70a:b0:475:f100:35f5 with SMTP id ffacd0b85a97d-47f2dd3c70dmr21428109f8f.50.1784170764130;
        Wed, 15 Jul 2026 19:59:24 -0700 (PDT)
Received: from tt.. ([31.223.44.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a940sm19511108f8f.12.2026.07.15.19.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 19:59:23 -0700 (PDT)
From: =?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	ebiggers@kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: [PATCH v3 0/2] crypto: algif_skcipher - fix AIO IV race in stable trees
Date: Thu, 16 Jul 2026 02:58:35 +0000
Message-ID: <20260716025838.2672-1-muhammetkaankilinc@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The AF_ALG skcipher AIO path passes the socket-wide ctx->iv as a raw
pointer into the async request. After io_submit() the socket lock is
dropped and the request is processed by a worker, which dereferences
ctx->iv only later. A concurrent sendmsg(ALG_SET_IV) on the same socket
can overwrite ctx->iv inside this window, so the in-flight request runs
under an attacker-controlled IV. For CTR and other stream modes this is
IV/keystream reuse and lets an unprivileged user recover the plaintext
of a concurrent operation.

Both patches fix this the same way: force the operation synchronous, so
ctx->iv is only ever dereferenced under the socket lock held by
recvmsg(). They are split only because the surrounding code differs
between trees, not because the approach differs.

v2 used a per-request IV snapshot for the async path instead. Sasha
Levin pointed out that this is wrong, and it is: for ciphers with
statesize == 0 - which includes cbc and ctr - skcipher_prepare_alg()
installs skcipher_noimport()/skcipher_noexport(), so ctx->state carries
nothing and the MSG_MORE inter-chunk IV chaining is carried solely by
the in-place req->iv writeback. A snapshot redirects that writeback into
per-request memory that af_alg_free_resources() releases on completion,
so AIO + MSG_MORE with cbc/ctr silently produces wrong output. Writing
the IV back from the completion callback instead is not possible either:
that would require lock_sock() there, but the callback can run in
softirq/atomic context, so it must not sleep. Forcing the operation
synchronous avoids both problems and leaves the req->iv writeback
landing in ctx->iv as before.

Mainline removed the AIO socket path entirely in commit fcc77d33a34c
("net: Remove support for AIO on sockets"), which is what closes this
race upstream: the sync/async split no longer exists there, so mainline
is not affected. That removal landed after 7.1, so 7.1.y is still
affected along with every older supported tree. That commit is a
tree-wide removal across net/ and does not apply to these trees as-is,
so this is sent under option 3 of
stable-kernel-rules.rst: a change equivalent to one already mainlined,
adjusted for the older series. The equivalence is in the end state for
this file - algif_skcipher never processes an AIO request
asynchronously - and the deviation is that these patches touch only
crypto/algif_skcipher.c rather than removing AIO socket support across
the tree, which would be far too invasive for stable. io_submit() now
completes synchronously, which is valid for the AIO interface; AF_ALG
async is rarely used in practice.

The patches are not tagged as a port of that commit, because they share
no code with it: the equivalence is functional, not textual. It is
also checkable: after patch 1, _skcipher_recvmsg() matches mainline's
crypto/algif_skcipher.c as it stands today - no msg_iocb branch, no
algif_skcipher_done(), a single crypto_wait_req() - down to the same
now-dead -EIOCBQUEUED check left in place in skcipher_recvmsg().

All seven currently supported stable trees still carry the async branch
and are affected. Please apply, in two variants because the surrounding
code differs:

  - patch 1 to 7.1.y, 6.18.y and 6.12.y, which have ctx->state, cflags
    and algif_skcipher_export().
  - patch 2 to 6.6.y, 6.1.y, 5.15.y and 5.10.y, which have none of
    those.

Each patch applies cleanly to every tree listed for it, as of 7.1.3,
6.18.38, 6.12.95, 6.6.144, 6.1.177, 5.15.211 and 5.10.260.

This is distinct from CVE-2026-31677 (a skcipher receive-accounting
fix); it is an IV-handling race, not a receive-space guardrail.

Reported to security@kernel.org on 2026-06-07 (follow-up 2026-06-19, no
response). As the mainline removal is independent of that report and is
not backportable, I am sending the stable fix here.

Verified on 6.19.14. That tree is no longer supported, but
crypto/algif_skcipher.c is byte-identical there and on 7.1.y, 6.18.y
and 6.12.y, so this exercises exactly the code patch 1 targets. Same
tests across three kernels:

                          MSG_MORE chained     AIO IV race over 200000
                          output correct?      ops: times the attacker
                                               IV was injected
  unpatched               yes                  2857 (victim plaintext
                                               recovered on all of them)
  v2 snapshot             NO, silently wrong   0
  this patch, force-sync  yes                  0

  - MSG_MORE chaining: two 16 byte chunks over separate io_submit()
    calls must equal the single-shot 32 byte reference. Checked for
    ctr(aes), cbc(aes) and the cryptd() variants of both, which
    exercise deferred completion. The v2 snapshot fails all of them
    (first chunk correct, second chunk encrypted under the stale IV);
    unpatched and this patch both pass, byte-identical output.
  - Race: a concurrent sendmsg(ALG_SET_IV) hammer against 200000 AIO
    encrypt ops recovers the victim plaintext on the unpatched kernel
    and injects nothing on the patched one.

This supersedes v1 and v2:
  https://lore.kernel.org/linux-crypto/20260705220112.2522-1-muhammetkaankilinc@gmail.com
  https://lore.kernel.org/linux-crypto/20260712022618.1665-1-muhammetkaankilinc@gmail.com

Changes in v3: both patches now force the operation synchronous. The v2
snapshot approach in patch 1 is dropped entirely, along with the framing
that it mirrors commit 5aa58c3a572b ("crypto: algif_aead - snapshot IV
for async AEAD requests"). That comparison was wrong: aead has no
inter-request IV chaining, skcipher does. Thanks to Sasha Levin for
catching this.

A working PoC is available to maintainers on request; it will be
published after the fix is picked up by the stable trees.

Muhammet Kaan KILINÇ (2):
  crypto: algif_skcipher - force synchronous processing
  crypto: algif_skcipher - force synchronous processing on trees without
    ctx->state
