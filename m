Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E922D7DC1
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807127; cv=none; b=L4ye0fsnMK5JE8Br3TqSyuhrW0L3Z6STpc0sA6+34QICvShuOBV40UOEtP5+Oe08Y1fRPjX+Bf+UnNJLghLjtJoYSHwrddgZnrxfgfu1eOCKXGaIDvz/PIkJVA0U7o66GBXBrmB9espfLh2ikLae4t6zO9EliubccWEASRO/b9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807127; c=relaxed/simple;
	bh=jeuBd6AEd//7dLky0U/9/K8CcfgAIF74DmeLEQ7xh6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E47yhMmWJnpnt2oCxM6ED6WE8YfDrnZgRHuwy6+5v0Zb8KkOa0ouyJYJcdtwfXq7XnZr9qAe/rxc1Uo0BL2taCua8Dw9ZpL6h57NCOle51yH1x7yOOXZ1rX7dWcYr3zholZhOwo2V4d3pFO1IhXbC3SD+YKtt5hTreCgIqJsUVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hAaDcgC/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hAaDcgC/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755807124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPs2EdTZ9fd3MpWdb0ATDCa6nUqfGtFMv2uyZP7L+uU=;
	b=hAaDcgC/AS2U/v3RYC5pzkV8bWIDr1/KRea5SH5aPGIz0/olRnlKWYDGK8+W+NhwaoTi/d
	36/rtGEzMuRB2IFxesZSbXbBVqUZX+wWWJ/DFxZhvdk35YL5Orxq1IepCjsZPrdQb5Xa6Y
	UMNCGZAVkoHsF3XPv3uMxXI0GWlcmCI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-zNWUFjUoN1uNqxw8fDWqvA-1; Thu, 21 Aug 2025 16:07:55 -0400
X-MC-Unique: zNWUFjUoN1uNqxw8fDWqvA-1
X-Mimecast-MFC-AGG-ID: zNWUFjUoN1uNqxw8fDWqvA_1755806874
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso7258575e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806874; x=1756411674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPs2EdTZ9fd3MpWdb0ATDCa6nUqfGtFMv2uyZP7L+uU=;
        b=c+rP4XvF/1maK3rPVxepai/ivAaAMYTNBJgX7Jewb1RkQZxeEnaijRG40Fa0EPwv7J
         mVpj7P+yGkN5W4xsNHhMYpV4QQXZQiqqp08Qc2V7gr9/Cy0/MheueykaL1ujwoJph3G9
         WoOWnoJBiIgqvj2zpeW03zlfqEIb1IAmOUz8YEaqG5POwbD3Usr5zIG8o/AjBRdcHWUt
         0niBoWxMpPTcA7ubF8ftL3HfjVBEXJ5+ldL76a528qx/Hzyf43SMC4fJVWs87G9nCFkc
         FYjAxykbQamT/7RFG4e4xsZkNOZVIN7LHXrl0+VDRfaDZ8xsqLV5BZoT/xYnHdY8BK7b
         6K2A==
X-Forwarded-Encrypted: i=1; AJvYcCXyHZ+8z334SZ4Kf5IdTd2rAMecRjYaxxO9TNxZH+oIaUabS3ojwCHdy1uT38wZjYX0P368sHtY3PACtTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGG8ucMs346esEJ4nREwg7Hv0ZYG5/Qjqsy7g3ATI5968TUPM8
	F3AUCFePRlLHtc0XK1GfhcDhwoe4omhKeEu071HUPdex23jhn5nezewRuxS7L3yo1jXOce5pHkB
	uByDafUSL5FM72hh29bgrhKmUDPoOAFV9b8pd5HP5kE2eEyHkk82dwAeE2XuR+Nv3sw==
X-Gm-Gg: ASbGncu09IcOQsLPmao3P4DwnfrB8WKAT/qFTJllMWxNumjPF9V6cEYehDg2i1RkkIr
	ecz9FXaIFYu/byGJ2ZJLYI7uKvBf7hkm8HcF56euwFS3AT6b4fKwgCjFj1U2lL0Zpk0XyK5rsLQ
	2XuL2bmf5v/Wq50BbNiDkCZoetexaBFpXW7JqNImTgzi5U8wb68Xd0j/T6b6kcOgQq8bmpuT1Te
	Gn9vjtlP8aUeDvClSvcHptTinVoJOFzKz9aJGWyJAACJIcUcW/dCCRBez8SKAjFN7Qk18XvHZpA
	kZyHQ7NE24Eu5V6KH+XKEI4be3vFPKC3c4xT8q7kT+IxXyaCly6InHM0ZtJ61A9SwUetB8e81DJ
	D5ZC/4ovwLwoUvXhTJmRswA==
X-Received: by 2002:a05:600c:1388:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-45b517d40f2mr2554385e9.24.1755806874321;
        Thu, 21 Aug 2025 13:07:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFo8ikhW4DoWVw60oDeAXqMRvn4UERlcVawLCjGel2pacwRc1R1ONhYVQm5EzuW0YIJQT4FDg==
X-Received: by 2002:a05:600c:1388:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-45b517d40f2mr2553905e9.24.1755806873856;
        Thu, 21 Aug 2025 13:07:53 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07487a009sm12690403f8f.11.2025.08.21.13.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:53 -0700 (PDT)
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
Subject: [PATCH RFC 17/35] mm/gup: drop nth_page() usage within folio when recording subpages
Date: Thu, 21 Aug 2025 22:06:43 +0200
Message-ID: <20250821200701.1329277-18-david@redhat.com>
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

nth_page() is no longer required when iterating over pages within a
single folio, so let's just drop it when recording subpages.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b2a78f0291273..f017ff6d7d61a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -491,9 +491,9 @@ static int record_subpages(struct page *page, unsigned long sz,
 	struct page *start_page;
 	int nr;
 
-	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
+	start_page = page + ((addr & (sz - 1)) >> PAGE_SHIFT);
 	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = nth_page(start_page, nr);
+		pages[nr] = start_page + nr;
 
 	return nr;
 }
@@ -1512,7 +1512,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			}
 
 			for (j = 0; j < page_increm; j++) {
-				subpage = nth_page(page, j);
+				subpage = page + j;
 				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
-- 
2.50.1

