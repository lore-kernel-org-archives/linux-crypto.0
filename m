Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6131434DCCB
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806838; cv=none; b=qZK+vM2vSFmnCxp1Mfe9b0Lqa4Kp6Q0oxF5vr1ltgp6OfL29Ka/sdjDQvdoxoePlXvPlV5sMpPDDe3IWaw8rxt/FpbMjQIo2+KBqWBpbXshiF8mn8Da/kJtSA4qWX/ECKkG0gLTK/zygQ8kS1MXK8Mzq7PBLdTIJqd8V6ZPV4Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806838; c=relaxed/simple;
	bh=3FOM28sJXvbUF2Tn/5jLCVekviR1dLu1+OtM4m//AQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFANAA+rvWDvJ9ve9O8VjWz0GFHVAmf4EEGqy44WJl6pPkHZCri5wXeLltywBaEUHij088kQnLYHtlo8XcGyWTKqB04Jy59e+nbcjV5+ZTHSfeAPJCUVTQzgJQdZMDlSHDhDzcsuCKbvjgNVZx+009Wh2T/M9/L/ZMFXsWtolNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jFQCZDNa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jFQCZDNa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7sWLap5u4LkaWlbSo2T/W3JLtp2tuveUv2Z9sucaeo0=;
	b=jFQCZDNaXCjfuCFOMSw+joVXE5i8HKh26/0aTHu1hE/r+/I2vyG9ANXRFzBRe3hYDZvfxF
	3jbSt7Dn3tA5CHxhPG9/RqF8CyT+BYjgcRi5ku0nac2g0efFvorneXJf50Se3g69dJmp2s
	Lw7SSJzX5P65kxT4IZRI+Zl5HHBwvp8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-EytmVASsNW2XlB26xclcGA-1; Thu, 21 Aug 2025 16:07:14 -0400
X-MC-Unique: EytmVASsNW2XlB26xclcGA-1
X-Mimecast-MFC-AGG-ID: EytmVASsNW2XlB26xclcGA_1755806834
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d251so7730695e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 13:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806833; x=1756411633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sWLap5u4LkaWlbSo2T/W3JLtp2tuveUv2Z9sucaeo0=;
        b=s0epo5HTOn/NdZUu6Ukqbgd3+2hrKMG4TWfGXMmQFXj4FezCLDoL6z/8o72FHaf5kY
         Sp7Tkh+okr3PhtVzh7DlchZP4Dc7NmICrmTCP6Qa6nribSyvNTqEs88QpTfjXNfCIW4G
         lgxVGDckznuvkGmkVfW0HeRg5OrmHPRmqRdbDIXyQslJ8stpXwUnJ7ux5F4LxB8PsGOG
         R2DfHsvpr5N1xesKY0h0ttQAbMebR0O/d1gg3g88OQ0IO+q0o7UCxX1ykXErH9tXMTDN
         JWKTw6CoFwLOgQsc9dTLdSBQ+AtnPOJ+inbhna/Ik0sB3WrQhACamrENrF9DMAYqtbC0
         jHmg==
X-Forwarded-Encrypted: i=1; AJvYcCX5giJY4uQZy7s+JjsncyX76uiiaCvniebvtm4ozpjEmhxgbydaCDea+zqEETAgUnep2ljOuxcJmzKznQA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0SjhWQ0Ab3MlFkISR51VY1ng02MlBFtCjC4VD9/Oj0lRATuGw
	m3uiDhnd4VG5wLi/LAkC1E4mLPApqW2Ex8aPq06PZVeYWvXa8HveMtx9vz/IEzcd5bl2qijRmgx
	SHW2xYRJWOFv86oFAVqNk8RVSzq0ghgMADLGtNSyESAY1H09nxbSiRKAPkZ1ZqPiSHw==
X-Gm-Gg: ASbGncu+Vr8ebHVzii4sJUJ+dDHxNro+DCxuz/JEy9z/K1GBf5lHGyjX2ocPSx5sRhA
	uDB2DyOM3LXj5pP3yWGoHjjgGNwH/36z+fpqct1zefMCkpmtd1mg6TENUXd17oFbMEzbE+XIysa
	gyTQatP6MNj9y45pSUYDGeqxuXI6rapKDHKXW2o3baE/tDu/ZSoUSkQTO5Kl0aJZIJelnqAMLmv
	DZ5O3x+Y0s8BxpWY35CNU7hMJMiGAzMox3znUKmXFDVv5WCMzr+B11m8ZVHizVVm21NOjGHOHBq
	+cvWQ/KkQ0JhDgYZlcdPg1sG5jEtZSmCZK/zxddyaq07Shbjd7o2C1djCzoLOM0rkaZfxQfK9uQ
	3CgRQxmlSt0nXrQm0f2UWEA==
X-Received: by 2002:a05:600c:1d06:b0:455:ed48:144f with SMTP id 5b1f17b1804b1-45b5179669dmr2598165e9.14.1755806833337;
        Thu, 21 Aug 2025 13:07:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSutx6qbatKffMJ28UfT2ZDXFlSv+vNq81oYks3KAGI73zxxTWKo8ClwQ/mmPq6W0wDfVQow==
X-Received: by 2002:a05:600c:1d06:b0:455:ed48:144f with SMTP id 5b1f17b1804b1-45b5179669dmr2597955e9.14.1755806832889;
        Thu, 21 Aug 2025 13:07:12 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0771c166bsm12916801f8f.33.2025.08.21.13.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:11 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
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
Subject: [PATCH RFC 02/35] arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:28 +0200
Message-ID: <20250821200701.1329277-3-david@redhat.com>
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

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a64..b1d1f2ff2493b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config HW_PERF_EVENTS
 	def_bool y
-- 
2.50.1

