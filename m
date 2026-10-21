Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792616246;
	b=Lu5g4U6Yt/eJKFJt0Mf17QJb6uMZzr/vCbROqqDqVESh/ixiwzi2dS/vqcqq0b378hPi
	 HTe6R7O9EEAMPxNzQAvqKJJ42dD32buSSZo7LbZCrhlF3WJYcyqK7DAuWbuCHIlTsudiu
	 tApxS95IuBvcbg6e28E2mST8Ife68V/X3u9ceXtvG1MLYT/9bpln0z+MRLIr6bMTpg9aA
	 1f9ZsH2GPKk7iOyu86YECNPr1T/K/Ysmw1Jh9BQKiKutA/61nxdN8/5yhExCtq/gmJZQI
	 2RWIM0b9YxsIycUZDwIWMHObg4vezg6KqIC0tb9BKtAXZ+ofc9rpKs3NkALBmAm4qTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792616246;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=AMF4QHAGquMqZj2Vy845rVn3rz16W/4eYJ+XdOmh9/k=;
	b=vrLuHTpDjBdOnG7wsGDzBRNk5vMRAnFWFBcoo2oGn/SmkOiuZvWB/dpL8/WN6BNdThIV
	 xb7Dp7WaLjmkgMOsIhqapOlDoCCS5pesQRd5AITaWGWs05aYYFAxHMqnQzLFDumSJXdVy
	 z7KI1m6cyDOaELHpV1eL+QXMLOHBrfmxq3dSWyDsqlb4jl/g+FhZuwyFSQE+26u/+Z7A7
	 lAdmvlboBoFAn+RLSbhTzxzyu7noUdbnXh+x6XsKjBpAAdiy9V5OOGlhRLQXR8BSZ2Qgz
	 hv79xVW5GUmsLTUC2jvJqrtDLbrdLCaFZeshOnBUXOKogbT6mJNelKaKJ99hko0dlfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TpPXbtMD;
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE506606A31D
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 20:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE506606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TpPXbtMD
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso1170896a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 13:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616245; x=1793221045; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMF4QHAGquMqZj2Vy845rVn3rz16W/4eYJ+XdOmh9/k=;
        b=TpPXbtMDhK8DnIHR5IRl7yUlsvvL5rPDT4DiEwMLkZ226NR3RF9nrSh7K3+7imRKTN
         u7ZJh3lW4Wm1yfBTye1USFage3uFLmI+2blTMc5IoPOiUGQYt1TjmzXw7+oemrr11Hbc
         Le58JJu+ijlEGOlU+D/hwkDOoA6BOZ3FnnTnfJJQQw6vLCr84TQfX4BINFZyzdol/+Ui
         pY8arT6gsVgWYKaJgvEZEwNcmpl9OHlbhcfHUc3EXV1TIwddjLUz6PEnivaABGW5IQ55
         ewfFe24bb4De+iYZukruKEb+kl8EHnwKAzZcFV0RkWx+yWhvCpkBhDAJozG9yvI9ud4b
         V0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616245; x=1793221045;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AMF4QHAGquMqZj2Vy845rVn3rz16W/4eYJ+XdOmh9/k=;
        b=Gn1ztLjB+KmtPJlQ1Q9qi2oFM4xSMkBb2csRNUXVs4aI+RXwc3XsLp+GigJjNwLTmQ
         8v3oV3fErFJO2vLkBCLPqGcKAn8FYvtpH8z8mN/SocJNs1+2i6glg7m5ikFygDyrDIFy
         nkv38s6yNYpXCWKN5O8hyEV4SL6eCgx9TSGXT2tSJo0MH29m1dyZiSwHkwwCW3rmLTaU
         1XdFFRQGWbMQaZpBFidzx5gdgsbtspAQ6sMyMsStb/R47uBHJinGlDWqk9/ZX0YKwylf
         U5zH5Fxrw6l++F6rYnwZnLDF48VZZFjKQLdT8lTzT9ZGIxbTV6o4K0ssOqYE7IycCaUR
         tJdg==
X-Forwarded-Encrypted: i=1; AKwUvBy4pCcALQbvRUHAaXsg6gmhnXtbbi7tkRvcz/0e/5600y6z/UOAzqqqwD3H3yL6qHNk17ze7xjyg+kwoXc=@vger.kernel.org
X-Gm-Message-State: AFq9FYJAfLplBkWqXxaMAGQn2BqMj1WlX97eOe7feBhsuliaEvgXTYVv
	DyyG+4DdVEkznm1pMAtQrVxRT+2EQ0vEZQBV7/gnXlmpr9Oo10xM8+tpJeH52MRiFGuvAr6jDKQ
	VAVd8u6+klYRQJQDmVtubtpD+yQ==
X-Received: from pgbj24-n1.prod.google.com ([2002:a05:6a02:61d8:10b0:cd6:9a6f:2802])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d08:b0:3c3:6f6c:aa21 with SMTP id adf61e73a8af0-3e287dd5c8dmr2833277637.11.1792616244847;
 Wed, 21 Oct 2026 13:57:24 -0700 (PDT)
Date: Wed, 21 Oct 2026 20:56:26 +0000
In-Reply-To: <20261021205626.3286270-1-suseendranb@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205626.3286270-3-suseendranb@google.com>
Subject: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
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
compression buffer to a single page") updated zswap_compress() to pass a
PAGE_SIZE destination buffer to crypto_acomp_compress() (so
incompressible pages typically overflow the PAGE_SIZE buffer due to
compressor metadata overhead) and check:

    if (comp_ret || !dlen || dlen >= PAGE_SIZE)

Because crypto_acomp_compress() previously returned -EINVAL on
destination buffer overflow, this check conflated destination buffer
overflow (incompressible page) with unexpected compressor failures and
did not set comp_ret = -ENOSPC when rejecting incompressible pages,
resulting in two user-facing issues:

1. When zswap writeback is disabled (e.g. memory.zswap.writeback = 0),
   zswap_compress() sets 'comp_ret = comp_ret ? comp_ret : -EINVAL' and
   jumps to unlock. Whether the compressor fails on destination overflow
   with -EINVAL or succeeds with dlen == PAGE_SIZE, comp_ret becomes
   -EINVAL. Consequently, incompressible pages are misaccounted in
   debugfs under reject_compress_fail instead of reject_compress_poor
   (leaving reject_compress_poor stuck at 0 and triggering false
   compressor failure alerts on normal incompressible workloads).

2. When zswap writeback is enabled, any non-zero comp_ret (such as
   -EINVAL from an invalid compressor context, -ENOMEM, or a hardware
   accelerator error) is treated identically to an incompressible page:
   comp_ret is cleared to 0 and the raw page is stored uncompressed in
   zsmalloc. This silently masks genuine compressor failures
   (reject_compress_fail is never incremented) and miscounts pages that
   encountered a compressor error under stored_incompressible_pages.

Update zswap_compress() to treat only comp_ret == -ENOSPC or
(!comp_ret && dlen >= PAGE_SIZE) as an incompressible page (storing it
uncompressed in zswap when writeback is enabled to preserve LRU order,
or rejecting it with comp_ret = -ENOSPC when writeback is disabled so
zswap_reject_compress_poor is incremented), while jumping to unlock on
unexpected compressor errors (comp_ret || !dlen) so
zswap_reject_compress_fail is properly incremented.

Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
---
 mm/zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..5f2a941fcaf1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -881,12 +881,12 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+	if (comp_ret == -ENOSPC || (!comp_ret && dlen >= PAGE_SIZE)) {
 		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			rcu_read_unlock();
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
+			comp_ret = -ENOSPC;
 			goto unlock;
 		}
 		rcu_read_unlock();
@@ -894,6 +894,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
 		mapped = true;
+	} else if (comp_ret || !dlen) {
+		comp_ret = comp_ret ? comp_ret : -EINVAL;
+		goto unlock;
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-- 
2.56.0.218.g1ec904b173-goog

