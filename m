Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C1350839
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806843; cv=none; b=OQ8Lqwzlq4nMJYdwG/E4sm+pKlSbPAn/oEr6x8sf9adomnX3fJUlRt+ZCTNthRnXLW1r4MVVij8qslVwt+hJ1WUKBMzCREwcq4S7x+32z4NI9Ob2G7+rqNU2hnrJ1az2BuaX0Kc/eFtB9PJtkCJwFGGmvRhl3W4VEK5vC0zbrKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806843; c=relaxed/simple;
	bh=rCgYuDQcQ3nJcWNFmOxD+pxeBEJSNoep86nFob2zhE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMgmIntHIfx6X45TqvSSn4M0A4PbI5v40uLuc54Yr6dbOgt57OzxGbH8reHuUtrlANzs1Mj9O70dtch4vZjeGD7SdiGjdlThkpr0ZN5z/SghGD3gWjsNBsysu/4WUctYScxNI8+B2nVx/4wlIpi2OPwRPj7nVro8Y8rvGx2fiKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FvhgezoK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FvhgezoK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zfh98TqNQqR9uCNr2hB5bEgIJ/15ql7Yv0zNbj5EC/8=;
	b=FvhgezoKXHMUZ2BWrsd04lTIP8unxj540pU946NcJnJJuOAbNKVsaPENFIHuD6kkJBPSKP
	p0LfaqPL9e5jofDyReCvBx3Ju+COG6jcSU+9UKHLRmnaECy4UXAUOU1zvMDtILyXgF/jdB
	8mDdg99mU8xQvc0YJu02PswwzrZb9Vk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-jkpsQGGVN0qYzwM6b_lWhQ-1; Thu, 21 Aug 2025 16:07:17 -0400
X-MC-Unique: jkpsQGGVN0qYzwM6b_lWhQ-1
X-Mimecast-MFC-AGG-ID: jkpsQGGVN0qYzwM6b_lWhQ_1755806836
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9dc566cb4so995970f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806836; x=1756411636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zfh98TqNQqR9uCNr2hB5bEgIJ/15ql7Yv0zNbj5EC/8=;
        b=ROR7vWbLOU87+QRGMDV2z6JQbnE2b2+EUaMfWtLxsbIgfSkII9LbEPVqxODUZX/xlr
         VGzNt2LC0MTRnpK0W6QdTVs091Grs2+DdEh78oFK5l3NgnCA+/njl7vwFy/zgJInZ9sS
         PoTiah8zkwkgxskI7oSkOfcfXRLvmEyZJAquol5v7Qr3oDkHrkPofbJ46sNJuSP62GyV
         PeSNo2iYty8hN8poi29iu2ZOcTDQVrV6Iif0aqGJM0ioDeVgmLlMWCyQBAQEebH88EV5
         kS4YmfENbt78cBEYQ+MCatcRt5l2o7G7sPAo9XGb8BzsONDX6uUkDHyGxgnjHgloFx5T
         QuhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVN1vAIyZP47u/YeLwhu0zeek60w3sDjXDbimc1DsMQ+iWcwMnc3TzpPe3X/VH4E8s8SJ0SW0odmcGxH1I=@vger.kernel.org
X-Gm-Message-State: AOJu0YysA4+2ri5TSdBfwXf0DuSY8megZR4gteXWfOjnnGoQhSZNwgXa
	8zkQ68YINTiqSGUo4U3pxf+MfDVHlsdGHwMxpgUOldmmWEINJyjNFDW+XMTZDnr2XfylWhz3DB8
	ajF85Cq1rv8lPqx3OuX4iQ2LGljuTgqmXQ0Qg5I1BQ4Vsw829Ebm/VrDJVsPu7Mb1rw==
X-Gm-Gg: ASbGncv1l3Ned0GwaXGutFAAYaenxZ96eIhZDdjTtsrpdyF/5/+o/mDXV6WPHN1LmXs
	ZBT36sQj0JbmeNHMrKZK6kTcqSqvMIzLR6QVRsGo/VhzHuQ7tQXqcEetS49SfUcTXqylb+3DwmO
	sE7wSDs8NkIEkHqHt2T/bU0NvJwslIOazR0CZUPG60D2QVKdz6eZjZnzv4o58AKhYk2KWumhWgk
	ZgoR6T6NEyMxBfTd02TOmn7loSy0Jkmi14L5fEU/zd1Zl6IXpe2Jp0NUdvZkMtges2q3/3DiDC2
	H9VImTJibdL7TSEXQ+kcq5SJh6Ko6d0V4w5njQDURqDbI+YEXeQCr385GGDkzsrTkexZfhDz8jj
	5ISlm4NXxqC0GVrW5O+1G+g==
X-Received: by 2002:a05:6000:1445:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3c5dcc0da36mr162996f8f.48.1755806836148;
        Thu, 21 Aug 2025 13:07:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpC+bUbLbCjHqucY3RiMYJPd72Xl9UYU3JmJwOiC1ZPXsKWXLLEiwWSHifO8HwGgrBWSbiEw==
X-Received: by 2002:a05:6000:1445:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3c5dcc0da36mr162946f8f.48.1755806835650;
        Thu, 21 Aug 2025 13:07:15 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dc00a8sm10958175e9.1.2025.08.21.13.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:15 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
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
Subject: [PATCH RFC 03/35] s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:29 +0200
Message-ID: <20250821200701.1329277-4-david@redhat.com>
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

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bf680c26a33cf..145ca23c2fff6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -710,7 +710,6 @@ menu "Memory setup"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-- 
2.50.1

