Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.185
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411354;
	b=IScoUubuIg1EouPx5WY92pSGy8KzoPq8iHYPNZwGPHs+IblwymP3i3etkoLMXRKhW3Lo
	 PPsAo93s8rsDAh2njfDOmTSKL0AxQur0T3W/41wV8p/AEapqk4rmAEoe4BWo19b2l6HMn
	 Hv73sI/QVwox6ZA3kerNAoGv30+JHNMj+1PuRVZrna+L68PaRog8m3JRKqBet+6Dx9LQm
	 5vLxXvujRS1BmY9xefP5w57jtXU6w7Cph5fJvZchflQ53LGg779lvFF3MxWgm0jyUlsKt
	 J5vgi3qLGrntHd7B/l63oT6zGO4LtbntlWEfGUHlGDjTN4debn17IhTrXTvWxVMJcnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411354;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Vz84Kwwxu/OXORILPVs0FJv1ASydR/NK4sfzJcCSGcc=;
	b=tqTSRlCcUIn31X2VzXsnTI97kXjjbrb353snZyLveVjiu4+lGdCHnVdxoCOIciAeSDf8
	 v5xOcsF3HmspDOdx79IVEqAzhOCy/lKQbxAKsroAP7Q4r22D+18sDE2ldvM2nhQXccAYH
	 gG3sZCjKvSsmyFddV8C1Bz0q5BSE1o3rZ3izzIlQvsUoyD4aegeWhPZ5b9pCEE8qBDL+1
	 hsk5ymw86oU/P4IKLY+BGz7pfT/QAfEE5xCpUK3Svr7P1hmbycPdyDQslitbF7t2JiA1j
	 eltkt8SpGlzbGXC3VMdLF+JXL5w7KIG5+MqPBNfrhvCfXF8yVTtD6PhruNmE+kynjfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FuOjHULe;
	arc=none smtp.remote-ip=95.215.58.185
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D798D606A336
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:35:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D798D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FuOjHULe
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aX9pIIbzr0WUjOOk9ufqdHhoopyWbM7JVXWDvohF98Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794411351; v=1; x=1795016151;
 b=FuOjHULeZ4ZA4/WVPcUF3X0QnNLWtVcic5UB2IwZMDHmSZZNODuGnY07gPZ2fn/9NiQ+iqiL
 /ZOiLmqaNti3Ez5r5JkCMX9rZ+s7ryIILNBDQTLBIyXF1Vl3Lkf8Q4XlNRArwEGfBOMojs30KyW
 bbLw85cRuWKYTmzTzK5D4ipg=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 5069cfac4354fb9b;
	Wed, 11 Nov 2026 15:35:50 +0000
X-Mizu-Trace-ID: 5069cfac4354fb9b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	terrelln@fb.com,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/2] crypto: use vmalloc() for large stream workspaces
Date: Wed, 11 Nov 2026 07:07:38 -0800
Message-ID: <20261111153532.1036709-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
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

The zstd and deflate acomp implementations retain per-CPU stream
workspaces until the algorithms are unregistered. On x86-64 with 4 KiB
pages, kvmalloc() can back them with order-9 and order-6 kmalloc()
blocks, respectively.

Use vmalloc() and vfree() instead. For a server with 384 CPUs, if
we have streams on all of the CPUs and kvmalloc() takes the
kmalloc() path for every stream, their workspaces use 193.5 MiB more
for zstd and 42 MiB for deflate.

In five before/after boot pairs on a 96-vCPU x86-64 VM with 8 GiB RAM,
the test populated both algorithms crypto workspaces on every CPU. All
192 baseline workspaces used kmalloc() without these patches. The patches
reduced workspace backing by 48.375 MiB for zstd and 10.5 MiB for deflate
—58.875 MiB combined—in each pair.

In five before/after runs in a 4-vCPU x86-64 VM, median compression
and decompression throughput changed by less than 1% (-0.93% to +0.64%).
Inputs were 4 KiB and 64 KiB synthetic buffers containing pseudorandom
data or a 50/50 mix of repeating-pattern and pseudorandom bytes.
The differences were within the observed run-to-run variation.
 
Usama Arif (2):
  crypto: zstd - use vmalloc() for stream workspaces
  crypto: deflate - use vmalloc() for stream workspaces

 crypto/deflate.c | 5 +++--
 crypto/zstd.c    | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.53.0-Meta

