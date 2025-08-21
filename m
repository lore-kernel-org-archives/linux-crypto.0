Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED73C370591
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806900; cv=none; b=UiKeJjd9v0bYGWajhP2DkkKFZbNMTYhgQ5uzX8zgMvAa9SExDTrUsCRwFSK4ItjAuZeyNOLYsu62nco5Tn7yrZfVIlu059BM/8pPAxpM4ckUhvboNwl+KKmUdxM2fwj76syhggcBASTPQfdhY8rJkj4D0mfyZcpTsoxvfFcKYBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806900; c=relaxed/simple;
	bh=o0B/aIsMAhafmNCelOfWp+ALdEBw0Dyti3dxNNba1Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA9HUj/3qBh0KPmHZxf/Ri999IyLc9myLCSuAqsZFnExMOY1yBEpxauj1wvv2AifoP7EqegX0/DCZeDEo7nK5Fy9E2/ErKx0GXqggeeGKMrUFw+rWwMZUJHx1n00I7cK6AlZRXbJ2ge/OFD5UVPKhH53we/QyXtKNprG29rIp5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iWxOjxrR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iWxOjxrR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
	b=iWxOjxrRN4x5VIWw+kp5y4YmvLNvjKSNKeylj1vK1XyCRY9sxWg0FfVqV/vfqPm/IW6yXy
	bmY/62DCOp3qmLfp5DLecQ+IHUdK47i4PcZPRKtgGc6+osTfaUU27E7W1fDGaDHCoZarZQ
	saYSRsBdiS/kD9py5e1jjBqq1zT3Ad0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-9RpimpZCNXWC4sKCCxU7Xw-1; Thu, 21 Aug 2025 16:08:15 -0400
X-MC-Unique: 9RpimpZCNXWC4sKCCxU7Xw-1
X-Mimecast-MFC-AGG-ID: 9RpimpZCNXWC4sKCCxU7Xw_1755806895
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc56225aso832778f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806894; x=1756411694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
        b=b+aE7yhMay6Zh1/F9WTHWZcA7YTGYPqlgW0KhKexmmGoQU5C4mw9CU5EMjSSKO9gzv
         Wh9ZU8IweiREwSAHZrdDls7hltK++32icek3PgNpXWdVFGzx0Vae7jbSe2w12P6T/Scr
         g0qAODsSR2MXrXPwYrqNMmacheOsvYdrlXoMmeoslS/TVdSLwTZy32S3FHKLJ0j5lLSO
         Mo/jCYojp+DoDTt4FJNoEvAOFnGvaiGTIULpHMLoL0Coe7ESRO4jML9cuWRMIH6qzmBt
         ZQYfixw4UBgD8e4HCt02dTakOrO5163EsstfQDYVQekQjGx1zJwN8cMOdpXJxfbJgZ/T
         Zklw==
X-Forwarded-Encrypted: i=1; AJvYcCU9A+hwEYAxcsaiDuCbCvOy8XsOLcejJJyD6zgNCa0B+C478JFshq4u6eGbGEGbZezfOYHQbgU1V9XGMv8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1urXw34IAAgv0Mjj2NpYV7EgDVN0P5BVELL9gSgHkEdJEE6IL
	XZvC7kAQ4PtjSXK9g4SDcfJZ4XBwvZ331rsTL446DR3mcY3uU9cpg/7T+3HlGs+FI8r4SwRI4I/
	xhUpdGrgJWonGHx5Ujt2iPo4Emk9rE4OsSymq5R/a8uqpowxl0Ppep7Ao0utNIOOfow==
X-Gm-Gg: ASbGnctqx8MTO3DzOP4XQ6Tf1Gkz3RGLrx9sathpI3e5eEwiaot/K/eWKr1B31k2+j4
	1f7LdQUDijrO28x/wqLxF+CzwTUt4AQLKIR59UrsvJ4BhVEWerG+XcYjO5NTYVo8Nw+z2GGtKyh
	X5J5ScwZ8rDS1Bals+fd0CUQhw1mveFEefZ8QfGwQHm9T0wbXWfg+9PWPXvunk0vtz++bOjhHOv
	HwAzatrJzpsd19cBpsSKHWLks1PeIUTaapx/lToMDm+3GOLZ8eHVFexF+xxuhh9US1E6v9CWWTz
	AbCJVGxtkayEeTQVycSuQzzVtH9p67SJWHRd0/xtn3aFviAopdP5BnkraM33851e52K0L2kK50Z
	5ZGdBIZ/rPR4rL66rtBAyMQ==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215857f8f.44.1755806894504;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYrE9N2OTZOZSEOVxEUY9xhX4UsF8UOhI+5wOqBRpd/3VSIxUjVMLdiea20BiXkc+w3FSZ8A==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215789f8f.44.1755806894010;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074e38d65sm12982954f8f.27.2025.08.21.13.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:13 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
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
Subject: [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:50 +0200
Message-ID: <20250821200701.1329277-25-david@redhat.com>
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

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/ata/libata-sff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 7fc407255eb46..9f5d0f9f6d686 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
@@ -631,7 +631,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 		unsigned int split_len = PAGE_SIZE - offset;
 
 		ata_pio_xfer(qc, page, offset, split_len);
-		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
+		ata_pio_xfer(qc, page + 1, 0, count - split_len);
 	} else {
 		ata_pio_xfer(qc, page, offset, count);
 	}
@@ -751,7 +751,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SIZE;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
-- 
2.50.1

