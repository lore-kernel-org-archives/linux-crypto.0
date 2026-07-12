Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A8367B7B
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 02:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783823302; cv=none; b=PES5Hn+v0pPxWs93etJfRFQ76SCUZcp/RNMBhw2jot00+DoRSoiAmpvsh9Ur3fUXLqvBqAveLWrnRAotWDpNkHKle4EI9S/fK+1d6oRKdc4ut4iOjq+xR8HBSTcGtdsP2f68hdEX/SUaShAyBhiyocHD+CPUpNkqH9VXsRBxP6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783823302; c=relaxed/simple;
	bh=/XXi4/Iro3IimjfiTkhAtvZ2AEOIhA7z95+0uqEhaZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kghy7KbnYdE1KS4SF00C6Jy6XwB3l/rmC5tVKldviysYxHdfHB9VVHz9/f+7VWGPdC1k2ib3XjOEnBy53WTsP7hDWIEGkhzA2SBjzL+gYyxLrWqNbTJNEEOba9nbv3ntK7A05ru9Yc6VW+aTfFlkOUpGOlU/PCok8RYFX8KS3MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADve2VIA; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADve2VIA"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493c5220cb7so15798055e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 19:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783823299; x=1784428099; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9v2xjaJT4SDDaxVyK0ICK4aUWCNaYWLWaDqH0+d+J7M=;
        b=ADve2VIABaerRPVpR2MQFEe1rDzOsMNkOH26YZbKNkU4XzhvqCU1jPD7dzxqITGhp+
         acRAqbsjTU6ehYv1xtp+GugBqVBv3So4HpIkkx6vsCzql/AsZ4bosynnIU3c8Qly6b4K
         jb9Vyq4gkxyMiYfqGdVpUGgqiPhvoMLyD14YUHio49RGcUVbI/I7xYkYWekhIk0KHI/T
         XWvlmzVM5RkIxgsSTtl39kKhJYh2pclbAyTKcpkhUwG60sNKK8n0xZ+RTudVfgA/o6/R
         +HcaBhJ7C/hGjUeTIEPUC9TmgHCAmOyZ9MSD8AgGnkHcdwM1FnbY4LgbBra7/2UG8W4t
         7x9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783823299; x=1784428099;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9v2xjaJT4SDDaxVyK0ICK4aUWCNaYWLWaDqH0+d+J7M=;
        b=AetnpsO4IMWj5DslASbZAlaPhhfaHA6IVT/FjkAv9g57FqPxXmzBQC5n6mpjo/AjGt
         WzA1gGyb+TNfWrzxi5Dchqutc0NiJVEB2f79g8XI2LsoKm0zVliGpYiU5F/XPretc979
         mOqCGxjqf4YM7hFEB/sV2sxvmzyvcMmCS/oQXo/3iMLHf/FDTyhNi+WkZhL+qCb83cOX
         AgohLCaU7ggmb0Oy32nhDUHVR0ho7TRUrrgKHT7q46r3uTPYAoRWqTbY4cjEDjvvxTOV
         8QSyeZlE1NmOprEfIqnaTJlRzRX+wPNVdtTtENgahL3lnSQbfARsY4Qvh3YwZJRz6Y7i
         +0xg==
X-Gm-Message-State: AOJu0Yyq1AX4R1T8/dpeq85A0tELFr2RrQgtbDlNeMp7YmUnmTkd2XOr
	ZzDng06LYRSNmiYPAyOqlCH9/xRLhFIf2JNSfIGSZWAHG3rJ4Mi3gBXG
X-Gm-Gg: AfdE7cl/n5McO41Z+ORgThNF5DovrRcJy1Ve+U1fYAmTlmywVjT/sOFgaTotIidoR6k
	4374R3eJUuwlikkdBkBhM4j6lzAmZ5CM/qR8uDbBSLvGLGUickaHegyiF/Fedcr1qVvfBZLchzc
	pSa4U7s/D595Q1vEXCTqcEfToAZRXk6Z/my1Gdu+S3Dh5clJ9SWSICykUaGIXMQdI2ORxcdpjPd
	Xs9ao7xeWCuvtz09RUjYIjykmCYonvP4Ybmd57P3cQB0yuChcEmnw7Yru+WJZyzsCauDjDGSAa+
	d1+TYa1rgh/xlvLpk9SYtoRXvuGR7Q3KQBx5ddV4+K9WeWz2ny/X/hkvvMN7SuV7mA5a1dSUBYO
	+Npap02yefSjncv1/n2R7pkjUAIVY4mPvhoiHPi5wruuCZbGF6tk2CwHHNwz3vUwNxJkrwmeW+l
	DZnqohfUpDiSiEzLlO9k0/jK8DEQ==
X-Received: by 2002:a05:600c:4e48:b0:490:bbc4:76a6 with SMTP id 5b1f17b1804b1-493f881ddedmr43809845e9.21.1783823298830;
        Sat, 11 Jul 2026 19:28:18 -0700 (PDT)
Received: from tt.. ([31.223.44.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6d5055sm252027875e9.5.2026.07.11.19.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 19:28:18 -0700 (PDT)
From: =?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
To: sashal@kernel.org,
	herbert@gondor.apana.org.au,
	ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	stable@vger.kernel.org,
	=?UTF-8?q?Muhammet=20Kaan=20KILIN=C3=87?= <muhammetkaankilinc@gmail.com>
Subject: [PATCH v2 0/2] crypto: algif_skcipher - fix AIO IV race in stable trees
Date: Sun, 12 Jul 2026 02:26:15 +0000
Message-ID: <20260712022618.1665-1-muhammetkaankilinc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260705220112.2522-1-muhammetkaankilinc@gmail.com>
References: <20260705220112.2522-1-muhammetkaankilinc@gmail.com>
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

This is the skcipher counterpart of commit 5aa58c3a572b ("crypto:
algif_aead - snapshot IV for async AEAD requests"), which fixed the
identical race in algif_aead. The fix here uses the same approach:
operate on a per-request snapshot of ctx->iv instead of the shared
pointer, for the AIO branch only.

Like the aead fix, the updated IV is deliberately not written back to
ctx->iv. Writing it back from the async completion callback would
require lock_sock() there, but that callback can run in softirq/atomic
context (a hardware skcipher driver may complete from a tasklet), so it
must not sleep. Back-to-back AIO operations that relied on the implicit
IV carry must instead set the IV explicitly per request (ALG_SET_IV),
which is the documented usage. MSG_MORE chunked chaining is unaffected:
it is carried by ctx->state via crypto_skcipher_export()/import(),
independent of the IV snapshot.

Mainline removed the AIO socket path entirely in commit fcc77d33a34c
("net: Remove support for AIO on sockets"), a broad net/ cleanup. There
is therefore no mainline commit to backport: the sync/async split that
creates this race was eliminated upstream along with the path, so
mainline and its replacement are not affected by this bug class. This is
submitted directly to stable under the documented exception in
stable-kernel-rules.rst for fixes with no equivalent upstream commit.

The supported stable trees split into two cases:

  - 6.12.y and 6.19.y carry ctx->state, so a per-request IV snapshot is
    sufficient (patch 1).
  - 6.1.y and 6.6.y lack ctx->state and chain the IV in-place; there a
    snapshot alone would break MSG_MORE chaining, so the AIO path is
    made synchronous, matching the upstream removal (patch 2). Patch 2
    applies to both 6.1.y and 6.6.y.

This is distinct from CVE-2026-31677 (a skcipher receive-accounting
fix); it is an IV-handling race, not a receive-space guardrail.

Reported to security@kernel.org on 2026-06-07 (follow-up 2026-06-19, no
response). As the mainline removal is independent of that report and is
not backportable, I am sending the stable fix here.

Verified on 6.19.14 (patch 1):
  - Race: with a concurrent sendmsg(ALG_SET_IV) hammer against 200000
    AIO ops, the attacker IV is injected 0 times on the patched kernel
    (v1 baseline reproduced plaintext recovery on 2857/200000 ops).
  - Correct usage still works: a known-answer AIO test (raw io_submit,
    AES-128-CTR) with an explicit per-request IV passes on both
    ctr(aes) inline completion and cryptd(ctr(aes-generic)) deferred
    completion.
  - As expected, relying on the implicit ctx->iv carry between two
    separate AIO ops no longer chains (this is the intentional
    behaviour change, matching aead); a negative control confirms the
    test is not vacuous.

This supersedes v1:
  https://lore.kernel.org/linux-crypto/20260705220112.2522-1-muhammetkaankilinc@gmail.com
Changes in v2 address Sasha Levin's review of patch 1: the IV snapshot
is now limited to the AIO branch, and rather than writing the IV back
under lock_sock() in the completion callback (which can run in atomic
context), the fix follows the aead sibling and does not write back.
Full per-patch changelog is below each patch's --- line.

A working PoC is available to maintainers on request; it will be
published after the fix is picked up by the stable trees.

Muhammet Kaan KILINÇ (2):
  crypto: algif_skcipher - snapshot IV for async skcipher requests
  crypto: algif_skcipher - force synchronous processing on trees without
    ctx->state
