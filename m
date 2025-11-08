Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1CD1482F2
	for <linux-crypto@vger.kernel.org>; Sat,  8 Nov 2025 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762613866; cv=none; b=VcdeApNOLWBN3eRFn6NUBi238hffCTjTRKM3ZU6RIbsfD0QHOJcMD/5hUj+bABQILdc0RXEug3nwlhYP0ucYb55shYGAZCGnhHeCufHWgpCipzvGRGfPr5PvduvIsYlx1ooNY0KFoZ+LYyivuEkrTItgexH5gViOfsDMUtOUGzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762613866; c=relaxed/simple;
	bh=9xG33c5hbKQopH0CAV0Bn0I3IvIDemsAuYVKtmP6i7c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jnQPX8BJcoKtnBul7nEueJxbB0XC8jNucrJA/KPxYjFfibAd3mO+f7rH/3jRko5VyZizjBGRWyWuS+fTYT7llA1/gbPSq4pZFGNrJp3d5yjXIrHnnMDfoqVe6Z8Hwxit6XsUurNyxfSkB89iQYSwlt98KZEA5X5L/NbvBNbnrnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hk+y3vZg; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hk+y3vZg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762613852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eF83UrrqufcAO5fdD9HeFwWyXs7e6m4eqdJQzQl2LxA=;
	b=hk+y3vZgpvqCd9e5Wbs/aQ0g7Bm+r8iEYQfWVKuM1o+aY+FSCp+YXoRnuUOZaEb8PrWBBF
	mIQ9EGTQ8rmebv8zAT3RxsW8qR/xSccYIM9A4qN/hMMmg5auO2p4ab6w9zvhusMkSG9ZcR
	eBJJxJpi0W1ugbzE4EvbW2C1u1XMSus=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: zstd - Remove unnecessary size_t cast
Date: Sat,  8 Nov 2025 15:57:07 +0100
Message-ID: <20251108145707.258538-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use max() instead of max_t() since zstd_cstream_workspace_bound() and
zstd_dstream_workspace_bound() already return size_t and casting the
values is unnecessary.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/zstd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index ac318d333b68..ff21cab382ba 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -38,9 +38,8 @@ static void *zstd_alloc_stream(void)
 
 	params = zstd_get_params(ZSTD_DEF_LEVEL, ZSTD_MAX_SIZE);
 
-	wksp_size = max_t(size_t,
-			  zstd_cstream_workspace_bound(&params.cParams),
-			  zstd_dstream_workspace_bound(ZSTD_MAX_SIZE));
+	wksp_size = max(zstd_cstream_workspace_bound(&params.cParams),
+			zstd_dstream_workspace_bound(ZSTD_MAX_SIZE));
 	if (!wksp_size)
 		return ERR_PTR(-EINVAL);
 
-- 
2.51.1

