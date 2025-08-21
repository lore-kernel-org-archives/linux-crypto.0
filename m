Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C6B3568F2
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806873; cv=none; b=AS40gH7VCC6FIxMPkbiuByJj3sGxRmwiZi1Kbsa1s6gKdpcukO/VZRhJNuKnSlYDT3HGcw/7ES1vPCWa+MZVTUjMcmHLLvbRWiZv9gaGVQF8+f5jIDc7LZ8O8B5ZgOBTFYDA32Cfr4ioyr0dEBAoiRmxxt2rZO+oVE02NQQYwjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806873; c=relaxed/simple;
	bh=g5Pqhen6+TGsZaJhVjcxjHrty8uEIOPaJGSbz6Iayeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAuDGXJqoO3d6HXPMrofd7nrPZ1zUub5/EkaSn6fLdU3bz964+v2RwL27mMtkBf0v6g6KBSutMGQfwjsewvFDXNACwZq3RrZaDaIdU49tNUiy9UIzaIUaiRgMgXTMXgqH9xowbCN4O53JcjmjuA3zz0+p43a7mvvnvzz8pq4YwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V14aL92f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V14aL92f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=V14aL92fhr2cohaK9176URi5fQltYntvanGd35+ks4+Pw5YFceM3LXpIFUfc5/RSfhPd89
	4Ss5da2evnR9BPvnZFmvd0vTpOrdORalxaqn5ZXrdg3j20c86106hIYiMGis5GkEfSfUAH
	S7aDkJOdL5pspYm7fEp9lh6t0uTx5dQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-adIUs4hIPX6WjWv_Jlflvg-1; Thu, 21 Aug 2025 16:07:47 -0400
X-MC-Unique: adIUs4hIPX6WjWv_Jlflvg-1
X-Mimecast-MFC-AGG-ID: adIUs4hIPX6WjWv_Jlflvg_1755806866
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0d221aso6547675e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806866; x=1756411666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
        b=EY47cvPrfM3O/ZRJa0Kt+K3j6GnR6HTAli4tUfktQQ7FbJx9qnsDAgERQMV+xt138A
         RpAPncBgI19cGABafBYatrTDRRX092HgrLtktYvxaveMy9MGO930060G577/HE33UPwX
         iSFYWtB/SUyPM4willO32k8zwdKS+Yhe/0xkAYG4bVKEJQ2niQ2Bg7JrILLIxGUwpDCD
         2imyBCzgr9bPchlTO1Fs58BP4z+DpGDPalBfQV65iNTG3vqUmZacE5JnCRq+VGNXK0Rj
         +1sEm2giRdrWOvcIU46+k2IIJzVzNQH7P24+fThJIt/EbXc4BvibY45N3M298vdnm+D7
         V2XA==
X-Forwarded-Encrypted: i=1; AJvYcCWqQ0t3HO1Jf/oAhBItUZPDUQWILPY+XMVqt8bxIO60GtZatUIQrv+7y4OqPyWPTIce3kKT/BmwZLiA2fU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtYptIo6XmIkGk3DOxCbceGhewbmdxWFhgy6fjTj8h5Jq+2ISB
	1yZ58Mmp/0zB+EWPm5LqFPnjoM2wPaYg9hk+F4z9WBqHrwSxhWXmTq+3pvyXB5FDgTtzo4UgfQ2
	eAABiPaPgSeWu+EBv+botDbDCYVp1f5+7KTd5OdB3yx1fsYyGWiGckVaNP5kQPjbL+g==
X-Gm-Gg: ASbGnctG3A+kOuBsD4PxUoxYsdnYaqsimCbvTn3DLkCvNsfsPK4z643JdPfVgI5+7po
	1ol4gA5XoMT4gt8tN/0dwELOth4JRHOcUz7ElbLx4Nh0mzZZwDBaYc3aglzi/HlP1a6emZOCSSt
	Qnf1xG5KNWhHCFbXv/a7S3yXcIc37SNFKL1qip44AO2KM+lLkw6TltbSH/ggpbeGPwmGWwvDLC6
	3g1bOnhY0kWr1+9+4Z8vEESqHvaPKQjrMkd7OXlSUooE/Yh3i8se9F/DxrXN2lfpcfgXbxOqBy0
	CbjPWFI5/LW8fk2qSinEl+MrJai23qLCzSCzbbB6OJVqUiIrwn+enfNql27JV+DPJRGzNyW+T5e
	9/QR13ZsMIx9s+/Xuv4T2Sg==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819685e9.26.1755806866203;
        Thu, 21 Aug 2025 13:07:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUtzGc4rPv18tjnV22wd1xjfGI25AJiVbHUBF3o7jj7YvZLrrv8XzLc39l/Z4dCqHj4yY2QA==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819075e9.26.1755806865726;
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dd0380sm8632985e9.10.2025.08.21.13.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
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
Subject: [PATCH RFC 14/35] mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Thu, 21 Aug 2025 22:06:40 +0200
Message-ID: <20250821200701.1329277-15-david@redhat.com>
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

We're allocating a higher-order page from the buddy. For these pages
(that are guaranteed to not exceed a single memory section) there is no
need to use nth_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/percpu-km.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index fe31aa19db81a..4efa74a495cb6 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+		pcpu_set_page_chunk(pages + i, chunk);
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages);
-- 
2.50.1

