Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFD635083D
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806910; cv=none; b=U3hl12lMjVZ8eobNRJFdW4VDJ3gBZD9zLtLF+sYiVhZhz/L08QU8/5pWKm8m37kBX/PKnI1wEy1pmQpDrEjcqthZYIvMbmJiiM1VLmctMmZ21LFKpbLX3lRNTw2VXBDCS/ZVQmtEGt2kNr+3OeGa42zpoT8PVeEv44vohSpkI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806910; c=relaxed/simple;
	bh=r9aVOOwiYkYkJ2XxN3c4oDiixJCUuv2T31t2h3Fc0ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoXFa5yQVL8NTTNK+1/qKYONqyOA01KM4H2VSUD8nKQyO8Sc1n7RZ7MTWRPaCMSDwjsKjDkE/QrA3cI4k82hECZmE3Zxo0vVH55/nsqPMxxON9fQwo59Azv8p3p5qW+XYhG4rxkuO+s58F1XJBF/l+0qyxqyPlLFZShd88g5jqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SegElgJf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SegElgJf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=SegElgJfnbWZ+V+PvUxqUO7J+66jWn3Osn0eMN5a0MK+83rDJeP7yg8iLDoc0RS2VOWDVB
	Bad9ToZ30RKyBd0GmeTa3f/zwgCoE3GbnxNZkbKUQ2dxYFD5xjQGlgRoXrcbgrpjTmVLhW
	ZIfMEClPE0zQqBZYhfzD17lSdw1EKPI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-qaKZFOQIO9Ku7NRoDZgDBg-1; Thu, 21 Aug 2025 16:08:18 -0400
X-MC-Unique: qaKZFOQIO9Ku7NRoDZgDBg-1
X-Mimecast-MFC-AGG-ID: qaKZFOQIO9Ku7NRoDZgDBg_1755806898
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a256a20fcso8254375e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806897; x=1756411697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
        b=gW2HXYtD59rwpp8hrT39X+87GM6wfh+YTKSAWoCrfkinR6mAhffl8p9TY5BhN3ijPC
         FL2tN3gxKEHlQZuw4YKhNsJRzE9vbD4J4/aSjJ0lwAFrYSua35gTpJLVksuWXsH03+9I
         CrPuxMlSq8aH2W5Hz6hQRMvr1NGeaELQlMhPobteV3GOMRYStzn7G1mw4Dya/oDL6ZaR
         GUS3AqQAxe5VfWaO+TBajh4L6Qpjn0RdO+A/7rDosJ5TDpxSRWeG26WjLFKG1YnPcwWV
         4q+tr9O+ZHFaineUle6a33XsXxZCpT8sY+JK1VvVAjxuL6rjLO/WA5r6evCmo6+wj5u/
         9iNg==
X-Forwarded-Encrypted: i=1; AJvYcCXjJuSXFasMNWJ6V7AUtdcB3OjreNG8wQsnEXrN8ahSxchtrCcTDkgf+IVZEb9CwWl9WV1ZrSBhsMAApd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc7ardMSAgUV2m7HDUPc6b674URZUtHA9xu6XbZBWK0WSNKdqL
	sNgCcu/T9P7Lu657pMCbdmsEee4deU44vqLz/TDxmLjP0Ml54/MN7CtCZ9bdlCR7kIatg6hs+8j
	QyPPpW25WmecxBOa4LkDWKI+1Nfman1IANQgHGhiYjPecKcra0zJkP+bHmyaJE/3XKQ==
X-Gm-Gg: ASbGncv+QCBweOE8HIhmsatBWpR20PgiyzJodjwhZnusX3mMJz8njHIjpF9zw4i0N95
	25t2PEhMT67kQsD+q8xebaf9AF+LSxawf4j74zcUuX8uf8ygEui7zIwutJGEClGTvm82InbRBBf
	nXLNtiapOmkDLR5ATc7COSZ0NXKUgNjcy3M1KnDOa6WuMpQtgU5RdzosX3xSNh9Ro8t8QJrN/GE
	6FVNc9HoWy3dQvP8CKrhW3f3/ri4Nv0OphRo3/WEj9uc589GF6y6iKjKyLxO0fb3wqmgoyN9Z6y
	71PbarauT0adk7Ze/AlbBS3ehp25cvdYSMAfQJx8rulqu0J/1avGuwlqWW9X/Facld3cGGRAjS4
	zxus2N4ssGrYML+nSQA/Ksw==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2506145e9.29.1755806897468;
        Thu, 21 Aug 2025 13:08:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPdYXvWWhsiYzUao4v8GSpApokx2tOJxTxGWaryOs6bj53AmOc+7o5w7P2pIRGnKU6jzi+ow==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505625e9.29.1755806896948;
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a551sm8831035e9.19.2025.08.21.13.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
Subject: [PATCH RFC 25/35] drm/i915/gem: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:51 +0200
Message-ID: <20250821200701.1329277-26-david@redhat.com>
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

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index c16a57160b262..031d7acc16142 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
 	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
 
 	sg = i915_gem_object_get_sg(obj, n, &offset);
-	return nth_page(sg_page(sg), offset);
+	return sg_page(sg) + offset;
 }
 
 /* Like i915_gem_object_get_page(), but mark the returned page dirty */
-- 
2.50.1

