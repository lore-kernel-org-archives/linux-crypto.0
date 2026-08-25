Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE9C356779
	for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2026 22:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787695584; cv=none; b=HcxZQM3vRuXxqAzMMpVf2xLMNy+grEbcpWvjVf9KsddCdxsIZ1Q8FIj6I8dzFKxlnwA7OHyPvjDN00YHvHV5pFIxATU3aHQGzgWe8rOEv6yhhlwY5pAwR+zR6z4kfTiblv84JuOxsD/oav61non+p0G44GAlN7Ht1ZVlm3qKBAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787695584; c=relaxed/simple;
	bh=gFBOFMo679ZDXmdW0dMMgBbOdsuuqwAEoQO4bDPF8do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f07j08UrWlsR9yi7YrYz79dWc+X1Q0msIbvte7pZ2KdEXhLPWcaf4C2z7nai0iUWeR0KH82oLMeTnlJwKudBTVn+xKg3+wDN3RJPH5/FNjUMB1xCgzBBRLW3FJJ3h6sIhwDjLgO1az0okgfsTHE8uq46R6NMx+IdUXqnCtDe9z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tM6eKWYI; arc=none smtp.client-ip=91.218.175.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tM6eKWYI"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gFBOFMo679ZDXmdW0dMMgBbOdsuuqwAEoQO4bDPF8do=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787695579; v=1; x=1788300379;
 b=tM6eKWYIiJlhYEjy4SDfYYjRJ0QhjipFJbNjAcsup1cX++HrwbUahKAvLrkS9CBdgZpH0GXO
 tTqRhboFz1a2pee4GqWTZrvNXSBkdDkQtzyJsOSiwEw4MIIBeRt7VXC+Hr2Wh2yqxPcHgQTgLwd
 nFaC3pjjTXPEfQozto+1MZOE=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (2a03:2880:10ff:59::)
	by mta10.migadu.com with ESMTPS id 6a51ded681de72a3;
	Tue, 25 Aug 2026 22:06:19 +0000
X-Mizu-Trace-ID: 6a51ded681de72a3
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: davem@davemloft.net,
	dsterba@suse.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	terrelln@fb.com
Cc: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/2] crypto: zstd - avoid initializing the workspace twice
Date: Tue, 25 Aug 2026 15:06:00 -0700
Message-ID: <20260825220616.3842633-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both zstd_compress() and zstd_decompress() set up the shared per-CPU
workspace as a C/DStream before walking the request, and then, when the
first source and destination fragments each span the whole request, hand
off to zstd_compress_one()/zstd_decompress_one(), which immediately
overwrite that same ctx->wksp with a CCtx/DCtx. The stream setup is
discarded without a byte having been processed.

That one-shot path is not a corner case: zswap always takes it when
storing, and takes it for a load whenever the stored object lies within a
single zsmalloc page.

These two patches defer the stream initialization to the first walk
iteration that actually streams, guarded by a flag because that iteration
can be reached more than once.

A 4 KiB crypto_acomp benchmark [1], twelve runs of nine 30,000-operation
rounds. Bare metal is an Intel Xeon Platinum 8321HC, turbo off,
performance governor, pinned to one core; the VM is a one-vCPU KVM guest
on a faster host.

                  baseline    patched     delta
  bare metal
    compress      52,283 ns   51,038 ns   1,245 ns   2.4%
    decompress     2,317 ns    1,998 ns     319 ns  13.8%
  one-vCPU KVM
    compress      16,675 ns   15,050 ns   1,625 ns   9.8%
    decompress     3,516 ns    2,265 ns   1,251 ns  35.6%

The guest numbers are larger because the two CPUID instructions in
ZSTD_cpuid() become unconditional VM exits there. 

[1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
 
Usama Arif (2):
  crypto: zstd - Avoid redundant cstream initialization
  crypto: zstd - Avoid redundant dstream initialization

 crypto/zstd.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)


base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
-- 
2.53.0-Meta

