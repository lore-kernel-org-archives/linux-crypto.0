Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917FA36CC7B
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806895; cv=none; b=O8MszIGGrnmvDWFi2zzRBAzScr8MJSHREww9g+UJGZkpqKMcDYWkAHeiUkdKm79adQhvNxJKOP8bni9s4EjINXTR1goxppGCIigM3y5LPeutAZm4oRPrEcfP0RRJDiMrHZ9FOeOpCIdBiD1DfyxUUOOZWQKvj1ZpA8h6ekUlR8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806895; c=relaxed/simple;
	bh=35i5s1BcLEONuxohRPeqiFHOreLIpfTF289+ZIXZu/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8gFAGS5Q7VjzlclU6oSlPbHMYPB7TM7ssWGe8PKEtgrRTI7CA88WPM/Rr91o9a7l2MUp7+n2LoPJ9BDBDBDj2Dot0u/Rxsj768TCG7dPL1Ai/QEifj1NVtrQaZhv5HBPgTKP4cgFCUs1y7pCKh0BraLwa0+HY+9S9RAVkaEyo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ciIX4g6i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ciIX4g6i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
	b=ciIX4g6i//BGOiIYy77+Y2LCADCnTpyAtQwRYdLQhT9b0BGVdkLWx+61HPAi5DBscvcTNs
	sjAVbnPUW7YPn5mkLzG3FnfXPjxAajVehNcZp10XQnqtg+jgcZHacunvTl8sa7kL5fAPv/
	BwfjvRtEFu6yIByUvweX9PEX4iWhudk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-9NKn722yNNCZfpkbG_NPiA-1; Thu, 21 Aug 2025 16:08:10 -0400
X-MC-Unique: 9NKn722yNNCZfpkbG_NPiA-1
X-Mimecast-MFC-AGG-ID: 9NKn722yNNCZfpkbG_NPiA_1755806889
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9e4f039ecso759584f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806889; x=1756411689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
        b=qyT45CaZK9KSeQSv9OZeuSvZyDnxpHqc9sF2EM5mz3wvE9+rOcRL7Ihvfw3kyvDJgA
         dJSMUz8VdSxaJyJJabWQ1INt+dza1hM2XnL951X1m232JZsk89hXDp8Ks8FOQ7I55RSv
         aOBL5Z03gPGdU0tnAo494s1boHFNYfiAa8C7hvmuewRiP3ibaOmYstrlmaOnVSlPqQCm
         o0WlXd0IOpQxIE74kjQoyrq28fgRuqWbhYeOU42jxTcu4KcPG/ElrSCR5N+cpdcBfYfq
         LTS4+NCcY3Es5/voOGjEHaog9SISDwrE/MGZZT8SUvwk2KbISulYS8va6y1tT/j+y9cs
         NC5g==
X-Forwarded-Encrypted: i=1; AJvYcCUtOdcvL+NoO/Lc8P1449aeBrMUbVrXNUnlKplwkZ1rnq3GU36rlfFf2mmGw1XKKnE2hXPWryVZJg8v0/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYzpg0qyMdoAcEavnG61bgOporHeLopa7xUR5FiemgqUcWyPkI
	mGtaX7GFJItS4tGmd/0sOVzkthC/wigRGMvx4o8ZDirpLVXkGy37hKUsojlAsYLgRSvItQXtxw6
	bLzz+I+z75v5nkajewrv2Y/Nwpjwm26llJ1LPaJGDahZvh+7XxxeGoGXZ3vuHP3l5Fg==
X-Gm-Gg: ASbGncu1kc4jwDsr4m97Kq2+RAp/UNWAqxv1cuKSrvr+qDqujAzZUqNQ2hauYjkzcyG
	nGIFSoJxe2W/AvWRX0Ec/8UYtBfWqBYNysDhawfK5jeWWpkxwdCkvwBBDoCjuHwtdjlI4O1ayLL
	23ZWsn2R900bQUIoULcn19mg5lEIXc5p3d4RZUnaXVJL2YGf5ma7gBfYbVWRmcaAJqe7xKnhtHF
	9rCcetOaWsCyYObbDZQ14yVDqc+liyO8Y/xpRs9wjNNy0/hX4uGsqRoNACYkXtlo2dne3qU0kWg
	1Rd2DBBisLQulkMb72JR5Jk7LQA5VfWcVKzFJmObfcGkJsxye9Hdo3jVFpZQqYtnyH+vqFPPxqO
	5qd2AfNOeU5EoMpEIpSWKcA==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151934f8f.9.1755806888881;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeHEkncn914iQLB6IDJFbFllUgyuseH1VcCPvg+Bdgchh7CcvmYDhAXktPsYS0hqHcr6hQuQ==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151916f8f.9.1755806888456;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e2790a8sm21120815e9.1.2025.08.21.13.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:07 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
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
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 22/35] dma-remap: drop nth_page() in dma_common_contiguous_remap()
Date: Thu, 21 Aug 2025 22:06:48 +0200
Message-ID: <20250821200701.1329277-23-david@redhat.com>
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

dma_common_contiguous_remap() is used to remap an "allocated contiguous
region". Within a single allocation, there is no need to use nth_page()
anymore.

Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
ranges.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 kernel/dma/remap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 9e2afad1c6152..b7c1c0c92d0c8 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
 	if (!pages)
 		return NULL;
 	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
+		pages[i] = page++;
 	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
 	kvfree(pages);
 
-- 
2.50.1

