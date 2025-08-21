Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F96F36CE1D
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806849; cv=none; b=pqTO5pT9qpe8fO31sXsaJr+5O2kxBAhCtusQ/HAwwSUNJ5jtWCoPvnCAIHeZ7OJZ8G84c0+rtDtdwsZ7lh9fer2wfiYAkU9Zmjk2U/DkD/FLHBIG5CctqwDnTER5/C3REboiQL+uaDlKxM9BjkPKuvBsBtTCQ3UkpjDiuS4agxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806849; c=relaxed/simple;
	bh=Cw7Tggvlta2Xmlg9ZVygUv1C92bk8NKTD0n9SH6aeIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRf/Qrv6elxW1FwPiUC7OXdB9DsbvDPd9ZFZdHlS/bX9e7iKUmQtXJLPutXUxFETaIGuxnkmTBti3jKXhbITctUUoDEqsG4QtUBUoxH+JDXmSQW7v5axd/rOsTQsTHTHvLnZvdmGD2xkxq9JUfZA4pgFu4KKPw1h/GAjTC4fZ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aSkau4t7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aSkau4t7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
	b=aSkau4t7gl41BThKEJ5GfrLlPH0vOD6I290zx6Xt00rjOUMB6kw4cIGo/ewGOF62/4cZio
	lrLfuicnQFJrlDZtozJLfRqDyRf4omcCNNuuDrx/xTwJWCxAgif5lNagJ5Ec+Z8+oSiva6
	AJyCsYpLnbXo/TD62n/gopd7ZgbKZGo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-yRgA0VqlNd2I7ZzdVqm2hA-1; Thu, 21 Aug 2025 16:07:20 -0400
X-MC-Unique: yRgA0VqlNd2I7ZzdVqm2hA-1
X-Mimecast-MFC-AGG-ID: yRgA0VqlNd2I7ZzdVqm2hA_1755806839
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b4d6f3ab0so8375805e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806839; x=1756411639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
        b=SU8lvyGzaDQEjnbbJxlAZpViahs1B21juep12WKkvftLUejMW5iwXpbXbvB7SXW3ef
         GzNarp6xveG3xWGjdFXP9a5IbGnbTE0AMQmTbosA99UX9nZFdGuS/17C3R9GV1ER+xUY
         NNfELSe91PK7BQ6ti4z+ilxBB/puEnX9HlsGxTWAPs8saYdDx1tNZpZe2uuOlGgrfYUs
         WOjdbNRCeS4TznLqwI2wqp+WL1MJVR/rIBxdnXnbQQJxvu6loRs4TvMrdAOM5zR9q6E0
         9O3/3GNIiVwRCJVYYG86KoM2ySIqc8rnHerYbAu5c5SVBfiFo70Gt+yMmLT44zfwWZUJ
         6MxA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ5G77WjaXjBnkTsqDYUig8w4J6G5Z8IY6ofZmrs/E7GPWcO2yKHmZx/TOuOeybhRZbgyosrDlck0cm5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjITrujPIKDj6DFvcZlxVVBKwChzE9Dh28fTKuqRiKXAsWfLkc
	pW+MXfgL2hb++rrj7bz9P/f7l3O6XOrw/2F4iau7O8ucIaK3GeX9NE5w8BoRA3YlIaLMb5zjlJC
	pZRsA6E0KtrvGIOE+0po4trUBrrwUZMofOCP6b/xArUmQ50zsI+ZHVxXjFQp1eErzvA==
X-Gm-Gg: ASbGncslLKvQtBg26RO34o5oXVYFCkBMkTuDvCqUGQlEgnWcwQ78gdWOaiOjJ2yqCqk
	iCklnClGvEqrmX2gKe762885o9NldkWEDXz/1Sz35Ox/m+PffZcg7K+V9LvFni6NvsbvrXGryXd
	gna95CazuTEye/684VQQk9xIF4Cv+hS//l9NmGevELcIvJeve8htVTPCjKZB4MbJqKgmifPO3KC
	gkHtbqUm96tvLmTJnDPVEmk5AAbvwOldhnJWE8E1bxY6rzPP82jDvk8gI1oARuC+Wd7CIfbB73p
	fFdvaeBB9G1k7/69R/QP6RN+zqB4iK8VUHzQG4NsAFv4CWayL3avv0ET590rY3MDJGuxeP16REx
	qPZeMwCiidZzzl9V4fx08fw==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845625e9.7.1755806838965;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMhnqxttMNkrL8PAxIX9Mfq64uKkvY2MjzJ39LtAH2Yg7PxwVl8kOZ6CXLaaMF5rYTxrWwyA==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845125e9.7.1755806838506;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dea2b9sm8988005e9.15.2025.08.21.13.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:30 +0200
Message-ID: <20250821200701.1329277-5-david@redhat.com>
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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100e..e431d1c06fecd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
-	select SPARSEMEM_VMEMMAP if X86_64
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool X86_64 || (NUMA && X86_32)
-- 
2.50.1

