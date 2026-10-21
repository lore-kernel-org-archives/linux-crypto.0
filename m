Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792616228;
	b=p+4iZiFsDTgWO1rj5lzYOPqDBDor6Ub3EvcrRAcOdwFyTQKUBPilcU+l+zHDw32Tqknw
	 szikcNRcn+0H8xoHD8YPn8oXD9LKfB9eEUMOcvAnC6BioXzIiTdwfqalAUgbaiuBMWHix
	 UdDS+lan+UbDPCk9ANKVwiid02xXTC4coBpR33C1AFoaXRHau4G7nXkwcQXYaYX8Bo+3H
	 3IqHsB/cNjk3iPFChFdaVvdyS2D2MUIIAyVUKMd8ejs8uIERDLD4WJmAu6HuWZkZEwJSu
	 ImsS/XW/32L4Pm+EI2K28K+1ADO6JnU33811fu714GBgDOnRTr4ik2AKYL7FZ8M0OZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792616228;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=TjGoXIwxwvYJCfSB4uUwJbeswXlbVh5GTXRCoqO+ToQ=;
	b=4mbzSAOTq2FW2gncmLSETZmAjHboofqxs3qXfdtyBAWJxC5FpXRhqSGgoF3Cp+oYUR3E
	 XkRZFx5rsijeCK1dKnKGHCd+KmMKvXkWzloJ5pu+/HTCfiFxF5F7IwNWWK5aYCj27Xzgz
	 /0Hz9qjUTF8ROB8M03Ql3pOyXhs4fPRPwabfx4YDlKIr6uTDhOHcizmPI/W1Vfo6wHEP9
	 BqnMJN8DxOBedfWfArk3u+KL/lvkdEYMZe+EXRH3c+tqpf9hOrz6angaGn6uuBsAmRP1Z
	 YjhdkwzBdRX6Ow2LkQRJapDExGVAzTi7QaldDQs+9AauMDGeEsKyQF3q+LaEX0ORkzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=umQqFLME;
	arc=none smtp.remote-ip=209.85.214.200
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB46606A31A
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 20:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABB46606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=umQqFLME
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2dfb24dfedfso10856865ad.2
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 13:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616227; x=1793221027; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TjGoXIwxwvYJCfSB4uUwJbeswXlbVh5GTXRCoqO+ToQ=;
        b=umQqFLMES1JPk4420IiZfNB632/zKzT4sUli4e84ALhzsGfTMxij98Ebgf4YZBFddi
         UY0aT6RxGWFJxA2T6p2sbTyG287UseVXX2ncIGOgoti5UqCbHVrKTtaiYpNNI+j4LAar
         nGb1FSgj2y7WGclgeYpYjjHYrzorVhnjHzudMRVFbZet4qdhmSOE9r2lIB50BxOjOeI0
         xm7ybJbYUG3nnmz0yOrH/6Xyb4ebFEvx19bFprxv0GGmp6ei1HuRfEp5Ec+tLJ061gW+
         cegn0mkiT6X4OMftE1OFDD0ia7mB95JVk2JEmld1h0LzLCea9Drn92lKVpK6mCZFaaCQ
         C1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616227; x=1793221027;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjGoXIwxwvYJCfSB4uUwJbeswXlbVh5GTXRCoqO+ToQ=;
        b=KE8jTTttRW+iVjfvWpwiV7kWhzictMxCZID6ZaP4VipSo68p7OIa1j8wMoLhAk9uBw
         4LLVwX1Gibri+SOdp5ELXaTLr0w9mkVxr2Ksn09UlgZ0l9SRcx33oEei/S2qMaSQs50f
         ah75D6JQxniVIA7kd7BrZmWLDkYD6F3UWQ/VjVQFuSD1zp44lzlIAdkNrMyfBeM4/gmi
         qivGYp0C+EmCziF3No+up9UEn0vxSagA946faNi2rZ4pZK/rEGzY8vBuRccSZVIjiiPt
         0EDeMW+qxb97URnTuBRuPAVle/6hzhddDe1zCaizBAWBYYDGsnsvW1yoVKI0lV7g3Nu4
         I/FA==
X-Forwarded-Encrypted: i=1; AKwUvBzzUNcrXESRgYdIpaWNLDvWT9/2VS4kwhpxdVGicustba79g8iXwWMesCCEiD5oFCVmPnX1Z41VO8rz3VU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJhB/7wZMJbKYc0rJEW/5TTqEgUZBBTsaonfgleKAXfU0k7tRa4
	/cgnh3IlGVi/15O0kKqHmnvVm+aw/+gU+Tk9aV7aORq2U4s8F7Dp+dfYLWuGeZqYklXXxXLg6z/
	iKKAMdHDSNJzt7EcCCAghg85xiw==
X-Received: from plot22.prod.google.com ([2002:a17:902:8c96:b0:2e9:8ef0:cf73])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:26c8:b0:2e6:7c6:8d40 with SMTP id d9443c01a7336-2ea43c0b534mr25135175ad.27.1792616226856;
 Wed, 21 Oct 2026 13:57:06 -0700 (PDT)
Date: Wed, 21 Oct 2026 20:56:24 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205626.3286270-1-suseendranb@google.com>
Subject: [PATCH 0/2] mm/zswap: distinguish incompressible pages from
 compressor failures
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suseendran Bhaskaran <suseendranb@google.com>
Content-Type: text/plain; charset="UTF-8"

Commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
as-is") and commit 0b1bf60c324a ("mm/zswap: reduce the size of the
compression buffer to a single page") updated zswap to pass a
single-page (PAGE_SIZE) destination buffer to crypto_acomp_compress()
(so incompressible pages typically overflow the PAGE_SIZE buffer due to
compressor metadata overhead). Because the single-buffer software
compressors return -EINVAL on destination buffer overflow and
zswap_compress() checks 'if (comp_ret || !dlen || dlen >= PAGE_SIZE)',
destination buffer overflow (incompressible page) is conflated with
unexpected compressor failures, causing two user-visible bugs:

1. Broken debugfs telemetry when writeback is disabled
   (memory.zswap.writeback = 0):
   Single-buffer software compressors (zstd_compress_one(), lz4, lz4hc,
   lzo, and lzo-rle) return -EINVAL on destination buffer overflow
   (whereas the multi-segment streaming path in zstd_compress(),
   deflate, and 842 return -ENOSPC). Furthermore, in zswap_compress(),
   'comp_ret = comp_ret ? comp_ret : -EINVAL' forces comp_ret to -EINVAL
   even when comp_ret == 0 and dlen == PAGE_SIZE. As a result,
   incompressible pages are misaccounted in
   /sys/kernel/debug/zswap/reject_compress_fail instead of
   reject_compress_poor, leaving reject_compress_poor at 0 and causing
   false-positive compressor failure alerts in monitoring.

2. Silent masking of real compressor failures when writeback is enabled
   (memory.zswap.writeback = 1):
   Because zswap_compress() checks 'if (comp_ret || !dlen || dlen >=
   PAGE_SIZE)' and unconditionally clears comp_ret = 0 to store the raw
   page in zsmalloc, genuine compressor errors (such as -ENOMEM,
   -EINVAL from an invalid context, or hardware accelerator errors) are
   silently masked as incompressible pages. Users see 0
   reject_compress_fail events, and pages that encounter an unexpected
   compressor error are miscounted under stored_incompressible_pages.

Patch 1 updates zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to
return -ENOSPC on destination buffer overflow, matching the streaming
path in zstd_compress(), deflate, and 842.

Patch 2 updates zswap_compress() to treat only comp_ret == -ENOSPC or
(!comp_ret && dlen >= PAGE_SIZE) as an incompressible page (storing it
uncompressed in zswap when writeback is enabled to preserve LRU order,
or rejecting it with comp_ret = -ENOSPC when writeback is disabled so
zswap_reject_compress_poor is incremented), while jumping to unlock on
unexpected compressor errors (comp_ret || !dlen) so
zswap_reject_compress_fail is properly incremented.

Suseendran Bhaskaran (2):
  crypto: return -ENOSPC on compression destination overflow
  mm/zswap: classify compression dst overflow as poor compression

 crypto/lz4.c     | 2 +-
 crypto/lz4hc.c   | 2 +-
 crypto/lzo-rle.c | 2 +-
 crypto/lzo.c     | 2 +-
 crypto/zstd.c    | 5 ++++-
 mm/zswap.c       | 7 +++++--
 6 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.56.0.218.g1ec904b173-goog

