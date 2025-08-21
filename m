Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCCA37E8FB
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806929; cv=none; b=G+ojUUWB2TWUhaRSr6VWi/Psh8J3aOT6y9A2J3BVbS+uVCZhJKZAbcSAwo7FZtaTmUeHc/S2QsXOPVImeNpDOm+GmW1EGZCFw952dBRQIpTo0x/aI9hYonrGNGqrD/xnDF+SKAhNCrxT3p1wQZh0el+ySEKZ+oUNxIuK2M5R9dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806929; c=relaxed/simple;
	bh=izYuZWtM9expuJ4aw1W3JEFW5k9djBINp3Pti4HydYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNAGz+dyRl/Dth80sbTSD58wezNH2x5H1kCcOTwq/HZ5Y+Ow9MUDybTINaAuDbieXD1Y9KTdsLoGgG5WJdPBoxy+IFRldg10UO7gV5hWknloJIGI9Tt9CQbK1S9Qwpaouz+IiAym/IPioEbFC/IiveggEqKke5jIuMiAiLsHXdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfFLyn1A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfFLyn1A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=BfFLyn1A3XUVMIK7uWjBslQ/m5F4eZHOGDiQuVm47rEGkd1Qi3fOYJdvSTYrt0cvWmMHVK
	oliEGHlLVDNhj7HJNikH54vLF1sA8w7ojbTlg2u+aeEWboEMIDKE99cXIcQ0FTla0A7+Kb
	WFYeNfLl6kwIgaKllu8wQf/1LOPGMk4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-l1R7Vh5APX6nNRl876N9wQ-1; Thu, 21 Aug 2025 16:08:44 -0400
X-MC-Unique: l1R7Vh5APX6nNRl876N9wQ-1
X-Mimecast-MFC-AGG-ID: l1R7Vh5APX6nNRl876N9wQ_1755806923
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9edf2d82dso666860f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806923; x=1756411723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
        b=I35siJVwdSUD3qidALv932aTrigKT3icuzKKOCxpmF5RYvDI6h0gtRM/CMdJMOWhsb
         CucmstPYZpu1thmMwl41e9rh9yT1ysZH1HG66bZILZ8Y5tlf/LZ7a7Pjb1EjGyNKMF9m
         r1sqQciShJcmqf1A3o+raZesFrUh6WhvpiQyz0u8Xi7fqSHzVkKAjCgk5vuFoLK2YFV3
         mNQIZLvqNlxcdMfrBbSK9Fl+edflPJIdA019cx662rsx3i/jtXZqe/jnGgLXaJQQCDNt
         xH5iqMlAm2EGywux+0EV72DDFJZtkwD+jYz4PHY2x6gBOH9n19yvDAXQCstyRvpU9lQW
         Vbzw==
X-Forwarded-Encrypted: i=1; AJvYcCUP2iphyckyqz60X8nolCYjjpa0i409clLdaJwQ4WIpURXT6TAYhDzCuUfoWO8KATr5yfvPBb5YYBBYw4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPZp1ItOPNLx8AYG0atel9MHLwdLVfr3N4cb6c4YTC1/RJUSVC
	mm7XD/PA7rEMcwUdU6WrCDWt9Vji/pHN8E7yI0tpiTXWGaOq9wdQGAhZTJZvPJL2kmrvX1GiYYh
	RQmbYAr2V+fkHneg0iv9PHXDPE/CRLsWQqs8Bk72q9d+ofY8/kZ9MfVdkDXTVMAsyhA==
X-Gm-Gg: ASbGncs9+sErZck5377CEA3gN90y5Q48GlFKtaSV3LyjWKO6lQah3Z4WRkyIIE87iX+
	tDe1H0srvu5j6q9MuGzlXzj9+d7Z1Ex7yXxzGen7xINAOP9FKK1wwqq2Qu9r8RjGWfUoEqw9W7a
	ChLvCGznjmyd5KiT/MMbkHpGW5OPIaHQdiJ4wc74gsD2wLAwNlXZo0SBq4LqKoxNPNEWYYHpDx/
	NBaVVSLqxCsb/Qd+7rUlmtpNHR5K6prdsufC5Ecyi3od1kGG86FaqcBn5e9LLf4Rp5WOpOnsujB
	krli+FdVhp3ZMGIDOp3bsub146KvNUyGzAOndKtOBNfbCWM8YbSxSpXhStsV3SN8HUaZHK/QDZY
	OycAJ9WoaPJ72kM3bg791YA==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204694f8f.33.1755806922963;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnHzRKC08dohUKQD/XdldMc6IWYVddiLtTh8Yidep5vx+5++gzVG23SiimMwYZ+HldR36Zkg==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204645f8f.33.1755806922505;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a587sm10028205e9.18.2025.08.21.13.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
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
Subject: [PATCH RFC 34/35] block: update comment of "struct bio_vec" regarding nth_page()
Date: Thu, 21 Aug 2025 22:07:00 +0200
Message-ID: <20250821200701.1329277-35-david@redhat.com>
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

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer
comparison.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/bvec.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa201..3fc0efa0825b1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
-- 
2.50.1

