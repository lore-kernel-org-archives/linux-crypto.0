Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E589F37427B
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806909; cv=none; b=Jj8EQgMWB4MPh0HE6q+/uJOiJNm42oUp4hr51ts/X2bI2aZ+zOpnBaiK7n1vRQWVgX5HRnefBsE7tZotolbX8TO+s1lVxQkb1LEYZEOIb+EG1aolecGhZc7LgBr7mVOf/Ydx+qOso7IJRN6gslZ76cGnGkjtT0wAB9icezH/si4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806909; c=relaxed/simple;
	bh=bq2gWh1hWRAlT57D1zXSNbOueAtiEim7ETzHNFHN/Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5Xw3LJdGQVt2Z0JgPdRTyKD+bKi7487d3v/RxHdzzWqWi0wS8UDEt6/cZi8S/Y9RMY4V5/i1EvC6rN3/LWipEq5SGgqH5sMu0akau9bRMZ5hWelFoRZ2QgbT/jy0EwIfa5h5XC8TnibKkhwiZys5jE/54BS020yV1pnyHq8kzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fdA0r21N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fdA0r21N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yR/3u5W37RASrGsn/s3pQVQ78UUgH4ByCavV3b4UG3M=;
	b=fdA0r21N38x+v2UQLIZ9WgOzWypzyF/gGbyMtQrNNeIBCBkAH7jv3EsB2igOSoB1bm5R0u
	zwSo3epyzhY1kDhsD1gVzR3BS/SSw7j4pFu5qqw1G9nF2GyfOSX3B4rDzNGsDz+YRLxAib
	yGhcCmMtiIyZzytyFFCB9WOUCQp/uaY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-Q5KJK64ONCSJqyo1d-P09Q-1; Thu, 21 Aug 2025 16:08:24 -0400
X-MC-Unique: Q5KJK64ONCSJqyo1d-P09Q-1
X-Mimecast-MFC-AGG-ID: Q5KJK64ONCSJqyo1d-P09Q_1755806904
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so14275025e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806904; x=1756411704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yR/3u5W37RASrGsn/s3pQVQ78UUgH4ByCavV3b4UG3M=;
        b=Q+vhpmqKvSN8Is+S7gwd/ElegY8TogV49vcL13DBmm7cYaZaeyV/db6/CQXFtnHLuh
         ZMIrpZtWoCruIds7vJQG9ipf8AAguLzLE6fPtQWWIDPrkaCVtrTQ5qMDy9Usl2niC/F2
         pQtBu8X5rtHV0d3pNcYUrXM058v8wAyOoUuVpF49W97vPArYYTI5HSTNHBvYb3j4alUg
         hq+FHhJzzuWCEotv2j9sU04HXJp2Tf/zMZ1y6XhefW5bUqcbCbMLbFv/D6fZpwCcAGdE
         4gfelmNodHUXMwoBLfikrXf2/cg/iPvb3jZl1TZkMBFnAgV/mkDtdy8b7Ba9xl0zun/3
         RAtg==
X-Forwarded-Encrypted: i=1; AJvYcCWsMmGMON2nKjLzKMacX2pbrKX8lM0wV+oa2B5TJDXbry5mCT3jm0b20rg7kBCcmQcKfO+vvyWs9BIg1uA=@vger.kernel.org
X-Gm-Message-State: AOJu0YytT5CfzftPSC8SR1qFnuoYhf5C06dFuV4yB1klODtv2RGn2SaN
	x7s4Rmm/N8pxSl7bt5IrHN49k0ceb3smqb9P80rHryk0GY89r4gPd25ug56sv0Ln38bh4Z7yyIA
	g2KeUazNsPKdo3Rsob2QKVRLRuJZ0QzOL7fSEJY/6tDgBCHdnqvuSl7Up9zqTN9DTdg==
X-Gm-Gg: ASbGncs6DIZCjzgFPAuwsmXMY1xhI1BKFBOXcK0rZemJqo90klwGnPYgR4wtyV+xkRs
	t2JDaA76SggKBAOe6bQheBdMUbYBMV/dpfUpdTWgIOqloO7UhXrnjst8ZlzCziOkICjR9TKo5Mv
	hXuJ7bHm0d9fysdwmeINc3hWiVldGjvtVn87vXJz8+7dhjp/IRk+t66kjEvNHi5J4+Beeg2GyS+
	ag2sTP8dxwPdKMNQjDaWX7tNNueHMExFBpNF7Cx+Q3bG1KR4qgCcEifJpnXGLwiSveuMX+7NQ+K
	CcQxPDL2ze/8cqS1UzQTpvOzyHKZBv9EoGe3HVontWqFFsiVcRS8br9hCZelwJ8nUTJqPXqu2PI
	annDtTijR6de3/jaok4gZfw==
X-Received: by 2002:a05:6000:310e:b0:3c3:5406:12b0 with SMTP id ffacd0b85a97d-3c5d53b40abmr247269f8f.30.1755806903618;
        Thu, 21 Aug 2025 13:08:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+53ePp4gOBoZK5+aLlST4uu6G3xHtHBUa0vmdrbtPfJ4bf44S3Zn2IpCr0m84pAneAOD81g==
X-Received: by 2002:a05:6000:310e:b0:3c3:5406:12b0 with SMTP id ffacd0b85a97d-3c5d53b40abmr247245f8f.30.1755806903113;
        Thu, 21 Aug 2025 13:08:23 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0771c1708sm13032145f8f.38.2025.08.21.13.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:22 -0700 (PDT)
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
Subject: [PATCH RFC 27/35] memstick: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:53 +0200
Message-ID: <20250821200701.1329277-28-david@redhat.com>
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
 drivers/memstick/host/jmb38x_ms.c | 3 +--
 drivers/memstick/host/tifm_ms.c   | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index cddddb3a5a27f..c5e71d39ffd51 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -317,8 +317,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + off / PAGE_SIZE;
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index db7f3a088fb09..0d64184ca10a9 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -201,8 +201,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + off / PAGE_SIZE;
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
-- 
2.50.1

