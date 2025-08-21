Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125F22C026B
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806850; cv=none; b=oU6qxsGuV4mtG1RMb20jhK25k0VZSbGpd5+o65Cz/fWMCbjuBxswKFOynsCAK9vlI54HuftigqLwjl81eJYWPzCoAooHpgWyC0kGUAOIzL/Rs1THGrsu1ixvEOTXwHNzJv/xuk0SRfpWnMw+tXatKwIJ7xiH9L6aRUhQBXcVn/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806850; c=relaxed/simple;
	bh=hFKonsreRzgICf2+ZQw2cwOexdUd6KjiPB+Q505LSVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv2Aw7EEFrJlBiMTpLcg/7wlPPAHJ96PSWBI934886JdhOnQkENS0SkLJn2H0Ber08f15XrWHeqeK+vasIrlVHwTKs2VCju48j7KYXFYqCCkhHvswPKWtv6vqyaxgqfU9rDwyIgN/wC/B+n2JamDnPtDnio8gYYxDWt9eU5s+Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hqj+QMG7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hqj+QMG7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=saIpwl0G6zoDDZA6kqzaAKGDHCkLp/ivw/dNNi90asQ=;
	b=hqj+QMG79ODfG4eUbMrHzgLHZfYNM/YAniUug5TXi1+i/7DKQZq93AAcmXZQlOeTnSVZUM
	Qofd/lVCMsCQS7i+Eabxscm0itwYLvDU3v89as6lK/AG2vL3frU+va5WPqmCGA/kPBaUnB
	oO7/wA0dWp1Dc9jvDbdfTbTpY4sJlQI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-6JlewCtGMuaWyor8gG7eKA-1; Thu, 21 Aug 2025 16:07:25 -0400
X-MC-Unique: 6JlewCtGMuaWyor8gG7eKA-1
X-Mimecast-MFC-AGG-ID: 6JlewCtGMuaWyor8gG7eKA_1755806845
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d251so7739895e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806844; x=1756411644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saIpwl0G6zoDDZA6kqzaAKGDHCkLp/ivw/dNNi90asQ=;
        b=vWY5adjC7B+LoOhYoGLdDmx5wITikBm4tfvnTf/oy7GMAs76cMAoBjDRwO9kb+ky9K
         LDbSwJotvmtcowno25i/P9Pv6pnltH1bqqVhbDsqzqNtyPhLPeB9rklQgsYFuSbMzG/F
         CDl0qO+3RCaZvff0DEmxJWVKDPvNYik+kaVDkDHXVjE2BqP9w5bKCi4/lMX/PyVtlfyG
         5w7sE6yo9gdQCNaq0KwFmUDjDT2USPNjqa7dFVSyHYErJc+d2jtzS4nN1+7H0Sp4j80f
         5Hx9vqzhJnNTYxhuzRyKOfQoYeHLZB7KHkQ+wSTfYjYxCilF3pzMw1nXI2GegEZnIocO
         KBeQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+qRfIs4iO8UfaW/f/9TB9idz+ykpAOr/lpD6YFHee8xKtjh5S0F4d9vwPl+Oh8XZwOrQ8QDtdaQEnUPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDHY8XXP2hTA9RmmWz80IUG+gz6+mY5la/00jhrvtg5Ukd8zGb
	ss+W7FHOviOEQSUEyLLdMqHFRT3TU75jp+UVDI/yJhupAAbOJVd3s3MDLl17GAQY11qIswWGxbT
	q35EBAR6GJVsxsAYvxAhXbbGwIQYzoFy1q+CTQQYXsM+gB2TqrA7+UaWmqLjUh/eR9w==
X-Gm-Gg: ASbGnct9WiXf6gLm9jREse9D2GjcSnDx+X4aoMvRbYI5SxkVsZwu2N7mwU4Mi7mEZwF
	namSZGsXgJAXVJIV53o3uPnIzptim7fxdMfi/tSSzA0F3NzQlg3yD3lM24vLnxWkQGQBQdp8NXS
	FnJSZ0XwJuww2qk+v8bzkJ+PImfp+r/jO8Re2btp9GVCrfUSO59Yci8ZHonJlAAN4WvROn4LLDq
	8CIyPf3CuKvCtWcczK/rTs5hImfi6ojlPXe3khuv7TMcDt8uf+Rj92qyX3SVyq5fAA92Jmo3PGh
	qzkxncVFg3mmEwaVmPwH6Lk7X7D8YVf2xLUTjie1XUfJTUbeS3PybUEQPlvS10A9/urpkl9YKLf
	6uOHVknROz0HgZAVTadeVtw==
X-Received: by 2002:a05:600c:35c3:b0:456:285b:db3c with SMTP id 5b1f17b1804b1-45b5178e768mr3050145e9.3.1755806844549;
        Thu, 21 Aug 2025 13:07:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwjTyvRglWWHHllkR7aRLdEFYS2lmKXV2DYH9bn4L7+YG6UNdB0HbBuiJbZZ1vy18QyYWFNg==
X-Received: by 2002:a05:600c:35c3:b0:456:285b:db3c with SMTP id 5b1f17b1804b1-45b5178e768mr3049835e9.3.1755806844048;
        Thu, 21 Aug 2025 13:07:24 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074e38d65sm12980909f8f.27.2025.08.21.13.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:23 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
Date: Thu, 21 Aug 2025 22:06:32 +0200
Message-ID: <20250821200701.1329277-7-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let's reject them early, which in turn makes folio_alloc_gigantic() reject
them properly.

To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
and calculate MAX_FOLIO_NR_PAGES based on that.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 6 ++++--
 mm/page_alloc.c    | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 00c8a54127d37..77737cbf2216a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
 
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #else
-#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
 #endif
 
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ca9e6b9633f79..1e6ae4c395b30 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			      acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
+	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
 	int ret = 0;
 
@@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 					    PB_ISOLATE_MODE_CMA_ALLOC :
 					    PB_ISOLATE_MODE_OTHER;
 
+	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
+		return -EINVAL;
+
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
@@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			free_contig_range(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
-		int order = ilog2(end - start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-- 
2.50.1

