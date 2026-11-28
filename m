Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840864;
	b=EBaPReVI1zM5eQ41b5rT8D5KKolUnP4IQ7cHPI35paEmhIAJEgENx5xEeI+DjczZJlg8
	 A2fAEgzRA7jUoeXJREsdkFddqYQOpx4XkYFCWlxvG0rZpzQeZCK+CVijxYnT18drzW02T
	 84qXTT9T6+E3cxgg0DVJo3+R9rSM6ok1sFeIkE+aW+PVjTsk5Wde2hQ86bkoNDRVPrHuP
	 FqsXb6lXn/zyXZHmWTNKU7c4yPWwMIrQNX7FokmFPCCAatX4jdH+mN8OLrR09mbKayLOf
	 MeJ7ZxW8p5spVjtsr4xbTD+lfbKqRfzpb2MG4WS1LbhnPIBvMXwI+Ofs/eHqnckOdxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Nv4bBI2nQTnAQa7VVyNNtpM5P6KUCDHBGIEl1IvOK2c=;
	b=UdYpxZS3kD0fpOEAdHD/GERmT/mpJfjpqUPrrs9PE+ky9pXpj1xNjlRUfZu/e35Xx7cs
	 5O+/3sS5YoXoJo/yqUDKrEAWhXXJ6xHYjN9SiuTfnYxmmECjtI8WUgebnKYLAarbMfNsN
	 qpz1SyIqVmMF1cuZtJRoKKUwtlQog1wGPAh1og+WEOcw13DDKMQKSfHoLfaSqkGkkxj5r
	 R1fME6pFBhmMU4JTUbZT9ykNXtIa9tHYlJ6zVG1u9WY5+R/OKboI8QJtXgSsWRuXYWesm
	 uhF98v7SlQGP7/3FaNplENH0m43HQpXiiiJ0DgFGwa0kYbkuZN1yw7WXFf/hYTzuV4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMJTReRx;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEA0606A31F
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CEA0606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMJTReRx
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b4021b572dso5358526a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840863; x=1796445663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nv4bBI2nQTnAQa7VVyNNtpM5P6KUCDHBGIEl1IvOK2c=;
        b=WMJTReRxElg6TswQ28vwxVENY4/pSeEcf2VP5WDOd7q/uBCt2o6Fe+xX6MMlY5467h
         dWoqhju+SnCv/AQCDfi8nlzfOdHFvH0zPJicaH6ozh2iqZdV3OooEuwB/MbhGskyynyt
         4GDVeDdOCdYQ8d0dpOzWyQh0Cx4e6uQcnGPhQAKvhPs/PzPqpHsJTks+Jy9innDT5bG+
         EMHyhTVvyYb6jshOSu5LeWoHqHDRMwkHZVL1eMx2S/3VDe7ASnfFXbq9wEO5Z3xDeYps
         UCRKUlWZHchYRltALhqP9cDbaYyffdp7+W5Q05kq/QmcxNE3kVPI3UuEAJKqmU7qKrg2
         kpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840863; x=1796445663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nv4bBI2nQTnAQa7VVyNNtpM5P6KUCDHBGIEl1IvOK2c=;
        b=iqHKFadjfT1UQ/ZhdEbc96iWuKmERFQ3w1ZZLmL3s7RNSkBkV6dQVUlRqb6nSnCeIo
         IvyC4iKyGvS9g3mOkZb2GF3mHc15S8ObGayl+RvBoRezvMtxZis1xp76Gh4TVjed+Fqv
         ZeUvijSS8+OP9h+BarIEgSuBU4zEXuvrbZ4RgLsxULO0EQCZCrcQN1+XSfuZ7sBi/WfV
         8oplawbbuUr4GQ+7ew9OHS9kHtJeeFpZJFfMU5UjSQKKg87VNImxCK6pab8FBMWpmsLJ
         KMduqMMnlMmOIdJzgdPah0zHuWhptAsF1jyIdApIL8aS4jxUHkHmxyG+ZvpBU5Mz0DY9
         6Iag==
X-Gm-Message-State: APuU4Z+vUOHNCzZ1rYdOI064yRJYtgmuyw3/Y88le+e6ov8hrFoYAD0e
	JlKGgKscfbuBUr48YVyQzxFLMcLJV8u2480CQLhetv5LRjJ1LSkvWz2DAOQfyQ==
X-Gm-Gg: AZFdTZeEsZOMC0wzMLH7l+OfACXx4VIRCZs85p6yiMmKiLfTLU11M1Hs5Zj2RGNXwsY
	H23gzbsNaRtu+7c5gyjfqVNDQ+CqWj4B9xg1HgS3pxAtj+xxkQ5Huycd8OjD+4JVMsKUMn/STH8
	O+kFIHflWIWcshhE6vauwnTvul8b44qBE0yZxqXpj0LUtYEnNoEMaHGm8E/K60mgmLJ0Uy/vUOV
	5GN8aS2Ql9Eb92FPJ2qMgbUV3/QyMzGrsL9Z4PEsLfPhkO5z9JF6BZrLameSy6lVkqYkrBxCQz6
	84oF+IWVEZ9E7+kULrmgKJplyUyUOxObsGh4GYm7zHPjxRmH0nncB1KlylT+uY3K9u3d/6ZVxqG
	hyaVrontXg6alvZ2X2LEvY1XcFx5a/BvMd+QWETTJ8//RfqgG5KvC/v3JXdXvgpWAqXY2pRV8S8
	g/qYDqUDV1wm9t6zQV26JqvesTKvn3K5gEtcyZt98TLIQ3zoewkVweafw3HyxbVgEZXpB0AcUVI
	YBWYYLEc/KdOOQKu7kYjk8sMvJvSIprPSl3n7Iw4O3GttZTBIiI3XNrEj4nidIGL+teDoJr79UW
	h6iistSj8m1yaPdfQqSrDvNVueRn7VfFl0phxtaFQymUHz5lHO/7u+WSwTKJYMJwOX09Xo0G8FL
	3Kko3iVSyd4CyqTp2gzCX9O9OizhbsB6qo9f3vr3vWghVAuaQOe77IFmXKiLqtkxcB5rHIaI6Cw
	gNTaiROzLfIH4lGfcy0VaJ66s=
X-Received: by 2002:a17:90b:3f0e:b0:3b3:bf8f:9cce with SMTP id 98e67ed59e1d1-3b41c905c98mr26228875a91.35.1795840862811;
        Fri, 27 Nov 2026 20:41:02 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:41:02 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 7/8] crypto: cesa - do not step empty hash operations on the non-TDMA path
Date: Fri, 27 Nov 2026 20:40:49 -0800
Message-ID: <20261128044050.722617-8-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
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

On engines without TDMA (Orion), mv_cesa_ahash_std_step() trims each
step of a non-final update to whole blocks and leaves the partial tail
for the next request. mv_cesa_ahash_std_process() asks for another step
as long as source bytes are left, so when an update fills its last
SRAM-sized step exactly and fewer than a block's worth of bytes remain,
it steps once more: that step trims its data to nothing and starts a
zero-length MAC operation, which corrupts the hash state. Multi-part
hashes whose update ends that way are wrong, one-shot digests are not
affected.

Once less than a block is left on a non-final request, complete it and
leave the remaining bytes to the cache, as for the last step.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/hash.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6fcd78427b71..b51315cd01df 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -297,10 +297,23 @@ static int mv_cesa_ahash_std_process(struct ahash_request *req, u32 status)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
+	unsigned int left;
 
-	if (sreq->offset < (req->nbytes - creq->cache_ptr))
+	if (creq->last_req) {
+		if (sreq->offset < (req->nbytes - creq->cache_ptr))
+			return -EINPROGRESS;
+		return 0;
+	}
+
+	/*
+	 * Less than a block left: keep it in the cache for the next request
+	 * rather than stepping a zero-length operation.
+	 */
+	left = req->nbytes - sreq->offset;
+	if (left >= CESA_MAX_HASH_BLOCK_SIZE)
 		return -EINPROGRESS;
 
+	creq->cache_ptr = left;
 	return 0;
 }
 
-- 
2.56.1

