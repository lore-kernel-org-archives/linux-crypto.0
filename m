Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E671237F208
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806926; cv=none; b=OG8y4XLTKg/2Qp+1AlA0eW9sgoKoBhTcwevLVA3gYT7fML+VtF3OXYyaKYdeRd6Pwvdc41NMqgIdxWYNu3nDJKfaMkI9HLiqs25SjGnKsOmzfewdZXKFx5iXxMct4dpB9UVSlqD3opIgaqNO9vqhgq1TDrf2T3aZYd5jhDOJo8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806926; c=relaxed/simple;
	bh=+AkJ4dNPQE9q5oho0ySkYtQ5iyrBmFIRoWrlEu7Fgds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tymbjWuAnoO3hbU0wrKrsa07CYJHCanSh2v4M7u4srZXespcA1cFOW9ND7PIFh12favs4nq4LZUNuZkKwvCKQgBYPhZDmEetQRHz1damfQzOCSey+LHeB3YtHhWX1+McUBYiCIWl3x/IBgx3bN+/oWGa7qn9e8cVwXsMFhLyGHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MNGPJu8i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MNGPJu8i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnKBChYNBt6k7pWFZ1VK2zlCQ3hhOdGhc0x5VCAB6rA=;
	b=MNGPJu8iTcM7AFqcPxSU7k89kw8yUjYmPnj/0ZTdp1dgCbA3tR8zbZ1oeBqvZAEYM6p6Mc
	rFaGyEDYwlxsl4wh3l7Cz+/uVi+BhcqGy7jP3ao08kfnXZEuczpTjT9BgcB2QaxaU06iKL
	6n8z1MW6+cNg4eVAoj3detMG+tECnPU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-3ynn_bePOo6VauEOGqngfg-1; Thu, 21 Aug 2025 16:08:41 -0400
X-MC-Unique: 3ynn_bePOo6VauEOGqngfg-1
X-Mimecast-MFC-AGG-ID: 3ynn_bePOo6VauEOGqngfg_1755806920
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0511b3so8304155e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806920; x=1756411720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OnKBChYNBt6k7pWFZ1VK2zlCQ3hhOdGhc0x5VCAB6rA=;
        b=BnRpwuLW0zSgcZXqb+WhLNZvN7OIL5tT8qeI3GUTxyniXXVwfNV85ILOoeyu6tvP2x
         StHyjeKmJKQXgAmXljQfL7cPyBFnNglmK7mtAEvga8I2KArusjKdRLC82oIp+VWRIxUH
         TuulmyvSqP10/HoHAkn8lV9tH2qqNiAdjgHik4X20leZzVN2+BpY85FpsOoie+cYTRwv
         CzdRlGKnPPFAAgmBwYnt5dUTEwEo8a3kW/wfoDkY9Kn+JEKQ/+AU4L8tK+A/+RP0EHGY
         CBHIXj25UeJw49TzeJ+DBegNJhDIOkDn+9Joy0BGy1LiLnGhAX3QR5HSffAKaP4wv6t1
         hl4A==
X-Forwarded-Encrypted: i=1; AJvYcCXVa0SwQoU0ZG8RiGB7OKe2pKLo/1rxH3mD2rmxsKuTTax+AdNsS7p7uzJ0Fc7ZeYe0j5C7b/RIUQLBO7I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9+wWS4Xu4jFhR+QHCCHFP/iz9lmVUNycz4/ZjCcuaqGkEOu4e
	1o+ZJzSZQEm8P8TJgf0erTuOBCmOvEMiEuocN1WXf/0+aIdB8ros9Z2V9Yw9S2soVlhNh8ib6p5
	1+4VJ/6nARbOXKkmE5vxxHaA7a2EeT1sWhAhNGhHavr0JGjijCXfUOtS7TlP9ITFjHQ==
X-Gm-Gg: ASbGncseV3wDCZcBd6uEsOdJPyXCvngd/ieSM/7ZHUoZF4iSEArRY+DyBaMR4nKG/aW
	udLOsvaApPoWaZMsdD8esz4aoA4TaZbK5IR0rkCPTXTLEB5QpfEG7pE9QMwP1UKnjEyeak/IgvC
	iL/TS6iKnwELK4uK02QLPCxKNkTfZp12GVu3rAYC7Vlf19X52QV/ohA7G5zVEH5AL3l4xSxr7Sh
	V+XySGyhTopvZEBG/ih06AT7o8FaRuAg/3Mcsj6F3+tRdVbE9VZyXJhS2wlxS04EwZ5Y5mL3iSL
	2VPFv0DvoSNXlkHuhinVQWKsrxizDa5F7EzmkBfekdNTgzwL3J2lC+gxJcyLHFoKoTquz0JGyMj
	Cqr1Qv2b1D3tMhl8N7TnlIw==
X-Received: by 2002:a05:6000:2405:b0:3a4:e841:b236 with SMTP id ffacd0b85a97d-3c5dc735246mr192355f8f.33.1755806920376;
        Thu, 21 Aug 2025 13:08:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrWn9aM0C/1GZBHvF1UL+fKz7WhllpDdsBGpm2GmVOIF4Yc/dULhABMcTdk4u9sLFplZdR3g==
X-Received: by 2002:a05:6000:2405:b0:3a4:e841:b236 with SMTP id ffacd0b85a97d-3c5dc735246mr192328f8f.33.1755806919917;
        Thu, 21 Aug 2025 13:08:39 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0771c166bsm12920369f8f.33.2025.08.21.13.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:39 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
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
Subject: [PATCH RFC 33/35] kfence: drop nth_page() usage
Date: Thu, 21 Aug 2025 22:06:59 +0200
Message-ID: <20250821200701.1329277-34-david@redhat.com>
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

We want to get rid of nth_page(), and kfence init code is the last user.

Unfortunately, we might actually walk a PFN range where the pages are
not contiguous, because we might be allocating an area from memblock
that could span memory sections in problematic kernel configs (SPARSEMEM
without SPARSEMEM_VMEMMAP).

We could check whether the page range is contiguous
using page_range_contiguous() and failing kfence init, or making kfence
incompatible these problemtic kernel configs.

Let's keep it simple and simply use pfn_to_page() by iterating PFNs.

Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/kfence/core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 0ed3be100963a..793507c77f9e8 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -594,15 +594,15 @@ static void rcu_guarded_free(struct rcu_head *h)
  */
 static unsigned long kfence_init_pool(void)
 {
-	unsigned long addr;
-	struct page *pages;
+	unsigned long addr, pfn, start_pfn, end_pfn;
 	int i;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
 
 	addr = (unsigned long)__kfence_pool;
-	pages = virt_to_page(__kfence_pool);
+	start_pfn = PHYS_PFN(virt_to_phys(__kfence_pool));
+	end_pfn = start_pfn + KFENCE_POOL_SIZE / PAGE_SIZE;
 
 	/*
 	 * Set up object pages: they must have PGTY_slab set to avoid freeing
@@ -612,12 +612,13 @@ static unsigned long kfence_init_pool(void)
 	 * fast-path in SLUB, and therefore need to ensure kfree() correctly
 	 * enters __slab_free() slow-path.
 	 */
-	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+	for (pfn = start_pfn; pfn != end_pfn; pfn++) {
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
+		slab = page_slab(pfn_to_page(pfn));
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
@@ -664,11 +665,13 @@ static unsigned long kfence_init_pool(void)
 	return 0;
 
 reset_slab:
-	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+	for (pfn = start_pfn; pfn != end_pfn; pfn++) {
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
+
+		slab = page_slab(pfn_to_page(pfn));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = 0;
 #endif
-- 
2.50.1

