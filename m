Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34812258EDE
	for <linux-crypto@vger.kernel.org>; Sat,  8 Nov 2025 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762603719; cv=none; b=W+6SzqiScjI6kOjY4nLfuc6f+uNkVszaoK8MXXnk8VN0zK4D9JH2+s7+1y61JBDbTy9KkwsroOhpuKtzfF0mhtnvrkwk8xZoxlTwqZebTsecJAM+hxc/wjQBjvx0Bkxt43QgqNi132DRaljBjHCfKwqmti8vFjIzjUu80aBfKsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762603719; c=relaxed/simple;
	bh=UeAuYzp5w/kNpO2Y1lfqmjD+AzszZK30e4xHApd0hnw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iEKmn9z23QD/ay4hOsYqrgHtEdOear4Iw3FtX3HiqFZpuynAUTbV+yNoWh3K3R4uu3/qw/rjXAmgDAQJ93VFdOe9iZFxyUbMqueJLlQ6gQpo2EH1vho996kW/VoKSZQqBz70COK0ZfT6vOooFGd436qLo+/pzUyGuURXbDY9Nyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IbZqLFLJ; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IbZqLFLJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762603705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iNDhGraN2FxVWRX/u8N3yNNBJFy+JEcFlHyTlUoRMYM=;
	b=IbZqLFLJTEcf18ziOrKOLp2f38virq4Y5Te/y2vBm7fmLx+BfN04R1RPXPPivPXKKnzU5H
	FMrgIcatDY2+7JNwAQYN32r9Pw7pSLWeBynxkg6pRMe/p2Ck+cEwLZZsXqgBoG1EPngkX4
	BC//RJmpEjUdKZpeCX145RHDu5qD5wA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: zstd - Annotate struct zstd_ctx with __counted_by
Date: Sat,  8 Nov 2025 13:07:40 +0100
Message-ID: <20251108120740.149799-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the __counted_by() compiler attribute to the flexible array member
'wksp' to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Use struct_size(), which provides additional compile-time checks for
structures with flexible array members (e.g., __must_be_array()), for
the allocation size for a new 'zstd_ctx' while we're at it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/zstd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index ac318d333b68..ace7a82ea45a 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -10,6 +10,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
+#include <linux/overflow.h>
 #include <linux/vmalloc.h>
 #include <linux/zstd.h>
 #include <crypto/internal/acompress.h>
@@ -25,7 +26,7 @@ struct zstd_ctx {
 	zstd_dctx *dctx;
 	size_t wksp_size;
 	zstd_parameters params;
-	u8 wksp[] __aligned(8);
+	u8 wksp[] __aligned(8) __counted_by(wksp_size);
 };
 
 static DEFINE_MUTEX(zstd_stream_lock);
@@ -44,7 +45,7 @@ static void *zstd_alloc_stream(void)
 	if (!wksp_size)
 		return ERR_PTR(-EINVAL);
 
-	ctx = kvmalloc(sizeof(*ctx) + wksp_size, GFP_KERNEL);
+	ctx = kvmalloc(struct_size(ctx, wksp, wksp_size), GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.1

