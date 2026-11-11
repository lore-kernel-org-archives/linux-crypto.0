Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411361;
	b=ogTzkodzHTPxEsvq5TrTDSdUFt/pGERYZMsUibu9Gxn+i69WvTpogOfkOIZI037mNtVJ
	 eKcwvA9aaME/y93bG7eao6ysP2raLObdZeWM1RXy1U1l3+/ng/+khKfQYe12hRUcpJj56
	 qIqVcOxpLa+8rK2dgPK1R6LEqsFn0ovCbHZfpw+aaKmvWVVMHlItMINJH3ogHJpwuhtZ8
	 skGNgVgKG/oJsDUsSMObX3wkjT5pZ1SIpSnq4T6XNOd6mu+7OAUv44HryFqVwYjxKUJRi
	 qLznPB+1g4c7ATQMMO2OMAf8v7TXSQLziM5UUHFIVAdu31fGvWBFdsrX3CLagVMfrHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411361;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ymrbQazdLeg+pCGWurk8n0D0XL5o29ESgMmIKPn6rw0=;
	b=ZIIiARwm985o8O1eTAYZRw8l+83T304tNDBPpaTrJLQ9PLyMGDEr4X89EbrtYW/MUEsy
	 ltrNXBehieMXUus/glTXgHYv8R1bv+zqtv79QaknAuWnS+ZwqYENLJlycCX0hBpUhG6Qb
	 wxcbdcg0hKTajVfcbH0X9BAuQYht7uVcjR/GTUqeeNERyZ92t9rdawfXc8/fMme3fjusZ
	 4AvdH4wgCicQ+MoniE/AQlrbeog1eEgCgOGP16l9LWZE7PBxlEB9QnNivJe/Q/+OEn/3B
	 +7MFafvVBaBiQ6KU9R6CIPwMev/fA1YLQEE2D0O06+I6LTuXYguUGnpskqlISmPK0kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="JG/SU1Jf";
	arc=none smtp.remote-ip=91.218.175.114
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA54D60A3809
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:36:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA54D60A3809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JG/SU1Jf
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=B4avA2HMujRiEbRvCpZxZXa2sgy7oVdlWYyRAX8qanU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794411359; v=1; x=1795016159;
 b=JG/SU1JfyZfJp6rRj2Cg0JsuugkZ86L8wxwJDSTG6D/eGP8A18fshrbwthMgADSH4ICWAktQ
 3f6/j1ihVo+FJ/xBdXoKuJCEELyDoXF+ewJqE9rMVZf96wY9lSiXwoYPdiQzxLs569sLSAgOOWq
 7efZrvHX2EzQbuWCALmtJV5Y=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 9c1c4dea31d188d1;
	Wed, 11 Nov 2026 15:35:59 +0000
X-Mizu-Trace-ID: 9c1c4dea31d188d1
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
Subject: [PATCH 2/2] crypto: deflate - use vmalloc() for stream workspaces
Date: Wed, 11 Nov 2026 07:07:40 -0800
Message-ID: <20261111153532.1036709-3-usama.arif@linux.dev>
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

The deflate acomp streams outlive the transforms that use them. One
stream is allocated during transform initialization; additional
per-CPU streams are allocated on demand. They are freed only when
the algorithm is unregistered.

In a 4 KiB-page x86-64 build, each stream requests 145,320 bytes.
If kvmalloc() succeeds via kmalloc(), it occupies an order-6 block
(256 KiB). vmalloc() needs 36 backing pages (144 KiB), 112 KiB fewer
per stream. Across 384 populated streams, that is 42 MiB less
workspace backing if all would have used kmalloc(). There is no such
gain when kvmalloc() already falls back to vmalloc().

Use vmalloc() and vfree() directly, as the crypto lz4 implementations
already do. This uses vmalloc address space, page tables and
bookkeeping; the figures above compare workspace backing only.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/deflate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 710ebba7ce850..a8692532a65da 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -20,6 +20,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/vmalloc.h>
 #include <linux/zlib.h>
 
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
@@ -40,7 +41,7 @@ static void *deflate_alloc_stream(void)
 						     DEFLATE_DEF_MEMLEVEL));
 	struct deflate_stream *ctx;
 
-	ctx = kvmalloc_flex(*ctx, workspace, size);
+	ctx = vmalloc(struct_size(ctx, workspace, size));
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
@@ -51,7 +52,7 @@ static void *deflate_alloc_stream(void)
 
 static void deflate_free_stream(void *ctx)
 {
-	kvfree(ctx);
+	vfree(ctx);
 }
 
 static struct crypto_acomp_streams deflate_streams = {
-- 
2.53.0-Meta

