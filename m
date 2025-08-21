Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABAB372881
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806906; cv=none; b=ewu9Pz9b4w6free2XdjCziylOkyCp2+rFO5w3E4EOKHpN1F5RWRL3Ka08RgL6Sl40KonhMdo31Q8m3reGa0llpSBsIAatEzqVVQ8YEH44P2U4d8Kr6an06zVTqW2pqUanGI8B+eQV0jnoutd5onqjRw+GoW5WDZ/XUXzyKLgFUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806906; c=relaxed/simple;
	bh=sP22NtXAK7RUwr0f+hWxIzaLt9EECIyrZ2EEKfR5Am4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/lUuxtPTRNdvT2o5N09yWOfs4br44byvRKxrTzDrPGzfZOQydJVIR4ourpp115SCTgYVFghdfG/ON4VHhRSVoEY6H7T+laAUt2ZoGULLvRwtWqjXLYPoCXC9o2KuyuhqUIhbH6eQ95pa7uHOBASDynq9Ls/5hSlh1qG/7MRvKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iR/oSPSg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iR/oSPSg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
	b=iR/oSPSgotn3w7gSZ8IN65NugEH7zKymwEGExo73kIyx4LvVBZOIOc/ya0c0PEjV6+4A3E
	Od/E1wJsSFywd4SfXXGIU7VWbOiP9y6Hd/5K3vin39dj7b2jDVC8PdKpp+bppsJZVTmIQB
	O8IAiquQYtXosa19I2ZbFoxbK696qzU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-MGY4Hx32M3-smuKugzNvrw-1; Thu, 21 Aug 2025 16:08:22 -0400
X-MC-Unique: MGY4Hx32M3-smuKugzNvrw-1
X-Mimecast-MFC-AGG-ID: MGY4Hx32M3-smuKugzNvrw_1755806901
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0b2b5cso10141375e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806900; x=1756411700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
        b=ZYgTEx2LROv/67LmZmRDISR1qc7W72Z6vtGVBdivjMr30sswLyfAlag+vA8rdg9hsI
         HMs9pikqFg2jfqgrlRNmu9MoLKXNquseq/kJ/RuRpHfjI9silkBsFPyNLo2bVPPtyFsw
         xrDVWrG+DNcTIucnV+JD/47QW3HRbrmtaUKQxc+NW0D8CDQUuiBG4wZJJUUAhR5EfEwK
         rBCe7ZSkeJ6XvZijvyqQ8rRawDJ4PI72ocN77PST0i7xqBNcfGNmLLHvnrxhmPRgMZoG
         VHPYMM1NCAzJGpkJhxsLFWN1Zh3HY5UnzeUjWn8tg2uowgoSRiNAvUQx5MVkcrxm0nOV
         tBCA==
X-Forwarded-Encrypted: i=1; AJvYcCXxeiNmbu3Ko4nA7ny3FxFXySqN76xY4XwjUcf9XcA5YreAsnyfCNqqFIlTweQreErf5WjYFNcinVcIFKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDuT1boHmZLlijqM7xsgDoQm2gJgYnzKjJ1M5+wi1ZtXhmOfAh
	JcP0Uq568r7xdAEmbFHC9tikkWKwW0MC4QP9mlST0+dqlAWmqbIBTAzBLB+sjtRlKKp1QPuPreI
	3OAU5C2lNRvgfshZZiu0qDZtcCVHCJf7q8Dogeyn4teAgIlK6m74UAi4SViPnrkNWuw==
X-Gm-Gg: ASbGncu2d+Zm1PGyGRa5HeSutQ+ynDeLXH4hsEsOkKm2qI7dF9Lvjt3TlaETP248QHQ
	xbE3BhG0FehBxx0/HV6e9hebkLQmmDbs+uNSEADJ7IGylGxHG5g961eWNVtdl3Q4P7s8g79f1XK
	2N2ZTxTcG0YGvYShVszaCHBZSgeG61mSERztTjM1rGvu3yLaHv9ZQtFcCqrS1vQ153w+4tWom1S
	0+uipKskSnGLIEGwZaCxjKJIUG9x/+KkXw7Bq2fkqbtOr54HKWb66hy2ZxBnYFmJ4qPwiUAE2ew
	D9bNl2nIeC1X92LswOg4qwehqLqt+e3mUTibyAjZnAgI4MxmQElRL1RiyOLJtLFX1jdoh3T8lqV
	e4r36DaTejPIDUcEnVtq+rg==
X-Received: by 2002:a05:600d:15a:10b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b51f2fe8dmr510145e9.2.1755806900271;
        Thu, 21 Aug 2025 13:08:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpV2b3uhR/IYbmrTMgtg0gx1wkF4+JdBDenNBBSMhYf9nynPUCNMa8PTADPxo4/liFiw6TqA==
X-Received: by 2002:a05:600d:15a:10b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b51f2fe8dmr509915e9.2.1755806899756;
        Thu, 21 Aug 2025 13:08:19 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07487986fsm13999227f8f.1.2025.08.21.13.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:19 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
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
Subject: [PATCH RFC 26/35] mspro_block: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:52 +0200
Message-ID: <20250821200701.1329277-27-david@redhat.com>
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

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/memstick/core/mspro_block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c9853d887d282..985cfca3f6944 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -560,8 +560,7 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
 		t_offset += msb->current_page * msb->page_size;
 
 		sg_set_page(&t_sg,
-			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
-				     t_offset >> PAGE_SHIFT),
+			    sg_page(&(msb->req_sg[msb->current_seg])) + t_offset / PAGE_SIZE,
 			    msb->page_size, offset_in_page(t_offset));
 
 		memstick_init_req_sg(*mrq, msb->data_dir == READ
-- 
2.50.1

