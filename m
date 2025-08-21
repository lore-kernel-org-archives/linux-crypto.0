Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70048353341
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806933; cv=none; b=faTw7x7MGqF1J6BBJWMf849a4RjBUM9ln9myZ/3zpPPKipx7Mfx08BLkSDogKAUt+zZZl5pRSKGXniKREoXakbmLuZOze4cL3CbQTeDLKm1XUwKUcgTRzJTnVtM+GW7RHxiPUYFTe2ZpKGp/29tcQIDzCrdZLTwKInpIji7tCxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806933; c=relaxed/simple;
	bh=tCsSQl+WRq69JZRVPLbubBOBHgSgQIUjNop92vdLyr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qtv/ZQ8ftddiMQXGKDPqdi9j4Kqm2q02dBcBwPAkotFiWWMbrMM4SOejdGoDdR3BwyAX3IsDuO1DBia9an2Uo7GERXz20r1P7GHYf7erGsPrxc+XyVSOUSZ5JW10U9NbyExke25eFMJQBIh8Wm5IiY5NjDl645wFnP7uROrcsXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OT4cSAeO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OT4cSAeO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wK69Pd9CHZjKZhmlaft7kkJNdToX7IH/S9WvVIRScQg=;
	b=OT4cSAeOO2dw46n6r6MUn6VQt0gdeZq06RV8GeRnoUlSVuOP21HvS0RkceFOPmZWv7RwCg
	XlWJX90QSMGkWvBbxlnDo5ixM1Ia0np4CLthowZ04W8qU8DeutGi86WeTtrritUKm/rxBI
	8uYnUmFJMSGPJjXXkTeJyDisAvf/3YQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-dyNJfxwjNfmct2z2Thkb5A-1; Thu, 21 Aug 2025 16:08:39 -0400
X-MC-Unique: dyNJfxwjNfmct2z2Thkb5A-1
X-Mimecast-MFC-AGG-ID: dyNJfxwjNfmct2z2Thkb5A_1755806918
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e4f039ecso760162f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806918; x=1756411718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wK69Pd9CHZjKZhmlaft7kkJNdToX7IH/S9WvVIRScQg=;
        b=GMDTs9oxmICOM+NOWRNrii1K7aN+uGQkrnmqaV23uWSvOAn2LWLCTw8zf67bgv86zn
         J/QyYFBk1QETygYsXS4rrWc/TgAMNBlUFV+8pUZbi4hY6CrUPq8h3ef6cAfQThIgGXzA
         2+3VGRuAfl/aEYZhQiblsIKrEO3prIfc44e3apzAnFWFaRXX0KjsvZgwmYrAdj4fKew0
         GlRXOStvclu+DLEYp/CWyI41NS1sSt0E5pE9bkTShmYG5yPrhKs8nl/HywAXh/X3WoHg
         qtqNDgC5ZOpUhLE9uQwswe46Be2grhiGcwCNZaaicJrgDHcX4Hp6BfvFcmpq6lUtLaZw
         jALg==
X-Forwarded-Encrypted: i=1; AJvYcCV+ZkEKg/GuFTxO1vhee7AjvxNGgE53cmQi/wAux+q7SdpfWac5JwSbBWKkBzc6PRT4SN50rffmBHRinU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWJFXdy5uCL88wIg6wMzVu4Kvf43PwEPX/zO9MRwKwVXZONzAe
	xmW88XFkx2PnaVQRmPENp8DSLLb8yt02RSJA62OruCJN4aJCtR14PLpgHvp4eA2ndIz58CEYb9O
	7I3GPYyhaLubqCCPH4/HxhCaKUdLrCKuuEkRBzbaep7Eoh7cs92JERisNBul3FIQcCg==
X-Gm-Gg: ASbGncvU9GW37FDlRd5s+1gkHjRPUkJ32nzUT4ISWw1zWPpaimvWR6eX/oWZlAqGcyH
	1tEWRUdZWyAUy8iY6UeVmHSkx9z5BUmYPN8jqDa0ahkGK4OEDIvQhiHCxO9ke2aWAkbjUqNwK8a
	GWKmFgAjkMgGoq7nfHDyzFdw+Bh1+ixLz5zbXOMRrXmZru+Vg3jyTBBedkUrXQrRnrzha498XzK
	8bylbe9E39vWv2V2vIQ4sSX3DniFuRoSCtvFMrAktw782OSXcmK4R0huKAxYxPoMGHAEokkbH5B
	pYtTCaULma+jACtd+XW9ueKuqh1GZgVuZURfzJsRT1FA2gHZTCrJ68Gpn4V27vFAZSMwcvzgwTR
	o0Z1V/R1rpKYUVwosCAw1xw==
X-Received: by 2002:a5d:64e9:0:b0:3b8:d7c7:62d7 with SMTP id ffacd0b85a97d-3c5daefc298mr218338f8f.16.1755806917871;
        Thu, 21 Aug 2025 13:08:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETBfJ8klmP3LMs+G3FmlUfLKA9Qlb/rzelQ5gyETYamNwKefh2PCq6Da3p1XS4Ia+K1NPGrw==
X-Received: by 2002:a5d:64e9:0:b0:3b8:d7c7:62d7 with SMTP id ffacd0b85a97d-3c5daefc298mr218279f8f.16.1755806917364;
        Thu, 21 Aug 2025 13:08:37 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c4ccbf04fasm3355197f8f.7.2025.08.21.13.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:36 -0700 (PDT)
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
Subject: [PATCH RFC 32/35] mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
Date: Thu, 21 Aug 2025 22:06:58 +0200
Message-ID: <20250821200701.1329277-33-david@redhat.com>
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

There is the concern that unpin_user_page_range_dirty_lock() might do
some weird merging of PFN ranges -- either now or in the future -- such
that PFN range is contiguous but the page range might not be.

Let's sanity-check for that and drop the nth_page() usage.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index f017ff6d7d61a..0a669a766204b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -237,7 +237,7 @@ void folio_add_pin(struct folio *folio)
 static inline struct folio *gup_folio_range_next(struct page *start,
 		unsigned long npages, unsigned long i, unsigned int *ntails)
 {
-	struct page *next = nth_page(start, i);
+	struct page *next = start + i;
 	struct folio *folio = page_folio(next);
 	unsigned int nr = 1;
 
@@ -342,6 +342,9 @@ EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
  * "gup-pinned page range" refers to a range of pages that has had one of the
  * pin_user_pages() variants called on that page.
  *
+ * The page range must be truly contiguous: the page range corresponds
+ * to a contiguous PFN range and all pages can be iterated naturally.
+ *
  * For the page ranges defined by [page .. page+npages], make that range (or
  * its head pages, if a compound page) dirty, if @make_dirty is true, and if the
  * page range was previously listed as clean.
@@ -359,6 +362,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 	struct folio *folio;
 	unsigned int nr;
 
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, npages));
+
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_range_next(page, npages, i, &nr);
 		if (make_dirty && !folio_test_dirty(folio)) {
-- 
2.50.1

