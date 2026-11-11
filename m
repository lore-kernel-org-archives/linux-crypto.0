Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.196
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411359;
	b=BY2w6cGUGKqumtKvTiv9gYrNKq03SwoUpqVVynLGw2C3VNmKcmR5cTlFcAexROS4otIh
	 1d9rYCjOdrcgmDJDiVW8a/Mu4cQ1xW+/HFn7LVE67EZEmC5++QR+w7E5qkI+NiOaOw+Fa
	 9gxPsORUr7SiucpDxuLhZChswhZflSJffuqclcXCKALctUqbg9T4/WrYLwhkSuNHi+BcY
	 8pNYKk0o31ORSDCj5deOLdrs/XvpV4jN+dbOp4NaDrQdfiqBXH5XKAuTAFMU1MPbToRrw
	 Bytaf07fdr2hSqhuL+NcQJSGNi3ppu9qs7ftJJXr7WUr3OFVuJK2UIx0q9zGrCqt+/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411359;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fj67uJIexCq/nLllAUwirpRaTK68JNnZnw90fZ+XBzg=;
	b=mEmxvx11cUOje3QuUqXYpLJHzbSPWdV9PMBKeF7b2fV/pCf0gtkX/kV/Q1xkG7UjFIBo
	 BRtXoGQJMzIftguqFugCyjy3PUbPjY0yJgjWBULaJtYCaXQMR9pfgaL58ByNuOvkszgzJ
	 U8Vvga/OCA84fPCS5Y6KjDxlMVEIQ/rzPKXTD25souxJyNkZ7RrMjg5A5ePQSpjB7kJnL
	 NFp/CoE2U/xV8ql8409lcdYQqk1Qop8JCoDoO6MTRFLUSG3a7mBKN2F0FPDZIegXwIWk1
	 BTEJiXaBdk/xrDOb1E+sP8pC2UZBgle0Gktv8bxaNz+QJ5TN+Ppmx3WJCS28V+qwmWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lXqDEgFQ;
	arc=none smtp.remote-ip=95.215.58.196
Received: from mta1.migadu.com (out-196.mta1.migadu.com [95.215.58.196])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E08606A8AD
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:35:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2E08606A8AD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lXqDEgFQ
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cW3e6v6S8n5JercVte195CK4nR9zZ28vbmPV4+LMgoQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794411357; v=1; x=1795016157;
 b=lXqDEgFQs69ZIepWDgXjCTUbjhRebCFqTIyg6OfAeio52PM7KbzGOs/Pi0QGQZVL9e9q7AvC
 mQA1KvSgaj9bQc7FvHfUlBEc4KUpphQ1Y+/zzG4twzU12HWkhm/EqNdNJ04+K6q7MIN2LbWeygU
 neof1gSc+H7sy0KbubsK62rE=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 57900353a63a43d2;
	Wed, 11 Nov 2026 15:35:56 +0000
X-Mizu-Trace-ID: 57900353a63a43d2
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
Subject: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
Date: Wed, 11 Nov 2026 07:07:39 -0800
Message-ID: <20261111153532.1036709-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111153532.1036709-1-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
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

The zstd acomp streams retain their workspaces after the last transform
has been freed. The first is allocated during transform initialization;
additional per-CPU streams are allocated on demand. They are released
when the algorithm is unregistered.

In a 4 KiB-page x86-64 build, each stream requests 1,566,281 bytes.
If kvmalloc() succeeds via kmalloc(), it occupies an order-9 block
(2 MiB). vmalloc() needs 383 backing pages (1,532 KiB), 516 KiB fewer
per stream. Across 384 populated streams, that is 193.5 MiB less
workspace backing if all would have used kmalloc(). There is no such
gain when kvmalloc() already falls back to vmalloc().

Use vmalloc() and vfree() directly to avoid the high-order allocation.
This uses vmalloc address space, page tables and bookkeeping; the
figures above compare workspace backing only.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/zstd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 76bdaca327330..f012293919368 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -44,7 +44,7 @@ static void *zstd_alloc_stream(void)
 	if (!wksp_size)
 		return ERR_PTR(-EINVAL);
 
-	ctx = kvmalloc_flex(*ctx, wksp, wksp_size);
+	ctx = vmalloc(struct_size(ctx, wksp, wksp_size));
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
@@ -56,7 +56,7 @@ static void *zstd_alloc_stream(void)
 
 static void zstd_free_stream(void *ctx)
 {
-	kvfree(ctx);
+	vfree(ctx);
 }
 
 static struct crypto_acomp_streams zstd_streams = {
-- 
2.53.0-Meta

