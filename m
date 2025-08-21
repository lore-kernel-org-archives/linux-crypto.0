Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B44A34DCD9
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806854; cv=none; b=tu/XVdsFjWjNLzdUhI2TOxEOgtqOfxRD17efP58ftMZicgGvmadM2VznJHgzpeeSNIERztNT/ws3Fpiea8xSr0UxxitipojNkiqSLnfGPP5yo8FtBRw+Us9rd7DSwtNQp4ppNVTz12CskOv/6SnUqg3PMqWeCU35rmYTraSqytE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806854; c=relaxed/simple;
	bh=s79Oeg502W4xdw3NRVnr9AKhHVyvkgzn8FY1ksnzdKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzuOQ82Y52KspX4++VVYaHe+69jfyWYVh81RI7w/gY4IPaxsVrM97K7d9nvRjvSpHXJlTjVrzchAW6GDOXz5ug0TWaEkABzEoLYpRBNgQZv7S4YBDVH9/v9F5iFj/SBBhQJRJmts/wHfFxnq9MPybfmsK/rFGJXX0PLb0STFSik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EefwOLeJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EefwOLeJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
	b=EefwOLeJaYEE4YIyOWMP6dZRF088fTzPpqOG1vMgx+x7xiXsIWh4xSLoaETXnH+BpEcZ28
	F0i/V+du33A1+3kFZCHikhjo/rtqdF0gd0aKKKaTfpbdkwsyYdxGPB3UUavDV80w4ZXek+
	GvzM9O44NLiF7XgF1oJLrUdahYnxebU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-yso0x_JkP86lVcUWy94Iug-1; Thu, 21 Aug 2025 16:07:28 -0400
X-MC-Unique: yso0x_JkP86lVcUWy94Iug-1
X-Mimecast-MFC-AGG-ID: yso0x_JkP86lVcUWy94Iug_1755806847
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso10516205e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806847; x=1756411647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A9Znt0atqEjtEUkbTSfKRsvBJ9rEcbnqI7Kn1XkJSrA=;
        b=cf2JZ0HTgO6fsF6QvJ5hleiZvslfRf1QSrMdKSGlizc21WjyWDtEiL9v7f7VF/tQoA
         QtK9+AZRfzPHQc0EN/z/bvhLW6yqEo/Ny/Q4gNOs8jKgGaOi9WrDxpie79oC24byqqJd
         qU24f1cZBblT+OZTY1yj6kSYWIkqJQbAxhJO+taa0VxJVIJPaJxN3re+58lJ09z61uDr
         GOAwRUw3bsyyxA0Ueal5giyrKMH/cEz7pj2dR/Z6u97abwaEoou9eXWi+zACX0eX4CSI
         KNEj7tc9vTrvSNeKI5JnneaT9Gh8G95Yh/vWkv89lZlQWuc98+DvFeVSADEibUYQKQ58
         xxvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNreF0Jp+t7QxxZoGflFuLAAdtgumYO8tVUYGUZ1fskLDgbVXQ+DjncZidR5fYwV1wUwx6bRt4f755Sv4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMGZKM90UMgcb7ZRsS5c31o/fbHr9Vt0i0oNzMIQcocJxc2a+A
	PCKLYrtSUc4k6YA7PfBG22EKa5T8vBnxw/sUWOjXLDX04kyghL1zcvnQasO73tLzk7dG6q5H5pW
	ZHj+3g7vfzWrVM3Kew9lWAh3HKK/rRU8AZDlnhDvKda9lBqytsJTNPgXBZyTpfL7kBg==
X-Gm-Gg: ASbGnctT0SYiBxkHymHZyA42+GKEEmUvs5NZsLNxaUQQd9OuEvJ0rslx2GIq57o3sA5
	VOpXjA/Wytrs7v5Xn2PN3foK8uPKAGNAWDkjcAeQ+JKq/i3ryurVyce5aa1wegW/VefllncGu+z
	fM1zKjh2Wydtzr1iJ9bLyQigcgHjyXfU0JzOzjxkJKeOW6omeUE0P7OYFq0p9cUEAjezRtfAC1O
	/65tPyYM7443ublarF00gDHarMgenzOzyaohlf+sBup+C4LwmGqg3o7X4E3zWg1+oGRm/g82PXC
	sjhrVSL48F8Ak0y+0XMIgJy0kQnjTLrj3LWMMqVHyrO6ED9uSi4kr7SHfMITt5BBWUaZivyQRN9
	WhRYnvnCfimJEhQyV7nxLXA==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2921955e9.26.1755806847196;
        Thu, 21 Aug 2025 13:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUeapMM5JkcwJNJXC+LM6ICHu4lGUEF2ir46AAuHXhYXAFzTcPIdec/q/lplZD/isU7mGEgg==
X-Received: by 2002:a05:600c:3552:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-45b517d26d4mr2921795e9.26.1755806846742;
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50d62991sm9535385e9.0.2025.08.21.13.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:26 -0700 (PDT)
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
Subject: [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page sizes in memremap_pages()
Date: Thu, 21 Aug 2025 22:06:33 +0200
Message-ID: <20250821200701.1329277-8-david@redhat.com>
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

Let's reject unreasonable folio sizes early, where we can still fail.
We'll add sanity checks to prepare_compound_head/prepare_compound_page
next.

Is there a way to configure a system such that unreasonable folio sizes
would be possible? It would already be rather questionable.

If so, we'd probably want to bail out earlier, where we can avoid a
WARN and just report a proper error message that indicates where
something went wrong such that we messed up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memremap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd8..a2d4bb88f64b6 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
+		      "requested folio size unsupported\n"))
+		return ERR_PTR(-EINVAL);
 
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
-- 
2.50.1

