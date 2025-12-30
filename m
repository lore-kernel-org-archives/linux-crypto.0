Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35382E0939
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089770; cv=none; b=pVWabbCRZTf4fVXzSzJM2z+6mbr2eo22vdX+Lq4u3bVj3D/wEZvaQAFPAXqDP49WOKrmuzWvGvNKJXRpkPCb8miuT/EDxrEUQISBk5iAnHhHGm1VUsPpi/rfqJOZr2wT8UuqpacsjSJOIIiOIStkYz+gLPsjwVr7wxCTX06yi3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089770; c=relaxed/simple;
	bh=LXvIBwQKlwN2aW+nel9nihwfIG/BNCGtqaNljMXS3c4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XC2DnrZKhhsnuZD8Ym4ncuHg9ZerbAGWeyopxhAQ0fc5yiJw7IAyZDkqULQCprekaVF7lFx1+F7r23IQbNiTxx1DoB4A6ArtVYg36y2FYDkIBne0UJDgqoMp3xO0CANJfpg1hx58xE8gaDPE4FWouvRJSOhLPXuftaGVvvTiHt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b5mWhlFM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bt254Tfa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5mWhlFM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bt254Tfa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CbbLRn5SB4hmqpKO67RyzNkOjJr20Ge6MiEXlRieQIA=;
	b=b5mWhlFMcAhJf5HHdiDR2c+GwG4NDncHv3QaphrnnAmHJ2W0f8uaXjGq84AqZaug3wk0Kw
	+McRoAikSlwp2cbFKxwPy8UVkWluP6Td3pu3JOuGxnd0zf9qfMYGbY4n4P+6ID1Ycf9BDo
	VF2YjugYxCwMlyrmE/gx6RMdieuiTG8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-mPzkw6TPMSqguRHZ54vbFg-1; Tue, 30 Dec 2025 05:16:05 -0500
X-MC-Unique: mPzkw6TPMSqguRHZ54vbFg-1
X-Mimecast-MFC-AGG-ID: mPzkw6TPMSqguRHZ54vbFg_1767089764
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43284edbbc8so1829770f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 02:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089764; x=1767694564; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CbbLRn5SB4hmqpKO67RyzNkOjJr20Ge6MiEXlRieQIA=;
        b=Bt254TfaH40bxBLxxz/5PJL5tMkim9plomSHRIKOLweJ0ULeIwYjMOOodWhM3WK//P
         UymTDcx5T/76e6zQA5wl6k6H93lMN9mTTgBmA5esGeKjeD1Mhg8ocnWjdfxPB9BBFgQF
         j3fdS68fB7LUzhD9scOZuWhrXFMLFMJDw/Yu3dQNCsu5cZRj7sVy1+rzWBHeB7BpvBFc
         wLynWNnvzZtHrWQVI8zQxRsCRzHZIIcWpvNGF2l+95QVNBecdrjYemcNz1AR1GJqfHNj
         ZXTLKRq/pX6OrNPTEiM8u/fjDpJWmP9UZgXfRWZqPtLtcBKSBJf8RrGd6bNB289+Fq2l
         m7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089764; x=1767694564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbbLRn5SB4hmqpKO67RyzNkOjJr20Ge6MiEXlRieQIA=;
        b=rnG3ttgii2ifyRnzkBwVGhn4a/ER5eBX0uiKQ7rgRUv2Kcd+gWhskaJpBx+HgOrb8X
         PVHPP3YhUHCnrnSCGAvMF3JUpLPOcMCt1f07qq+v1HY5a5TUx0a8w8TBAuylMkf26lbr
         BnylumLtJhhUIBlOuS09Hckqc+OpnLtOnmS5V6fE+xZqwzQjiwPys6wKn/PXIvbthZPO
         J3QSymLt/4hUVXgxVIYVjq79sX7BBfCXLK8ESoHE49fL8Au3ic6czT+KeAvucnyQTxJy
         dBqwbsNvRghfF38XuyfZTVDs4nrhCwobD+ekHcG9Xu84YtSef4u4CVUZcKNAFz0J6zRB
         W19A==
X-Forwarded-Encrypted: i=1; AJvYcCUxJHofkBwQOMk96drXA62I26vv5YHgl9XEaI877XtUUltDNKHvWim4H7U7fg9GMBkAkPNWvKSyNsmVVE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr4xtyHmNIYj8F0fXDiybdcMuhYHaNff6/x7HWlRb/kxoU1DVL
	Ma+G7c2UpWjrfegpdAQJh5Pa8zfiRf2hJcptfYY8rvTXlggO16I1utMnbfzYGZ+fcCFT4hRxZon
	p9bsj4+cUjM/u3FJNpufjyVcyuBauADnHE15mWcNTydrYwzPzlu/ZsGy/dcGpFjmhYw==
X-Gm-Gg: AY/fxX5KohhsMU5ul6tBpJQPlzakklqmbr0P2xKZvh0v+rA8YmSsVi07PtB+xGxqufF
	wmm1v1pNl6Vy1mvH7OQxmBk9mZliJpxZX7hf4db/NzY4EMJW0Fx6yDUOwhURo2Xxrf8dgWbll6I
	I+1hyOhxoUSDVvIU5POSdZQl5veOmSKVOY5oADmVaEqhlsHC+sHMoc+SZ1g5UtzEv+BX3Ra/+c3
	+yxGck1TXsyih1GmwDqKBghVOcfEkjIBCDhKg2nIOiwrjPYFEI+f+Re/87zmPkqujlt40TO813x
	Df/Odxvo7lAc5hb1W05i8Qd0TEBxpUIi1v1ApdFB3HGgzX0tp+w2PzvVf+CWg0fbUG4owMvJ3Ng
	JbWfCe0YzjScAjeIrvsgaYvm7d023gs+3sw==
X-Received: by 2002:a05:6000:200e:b0:430:fcf5:4937 with SMTP id ffacd0b85a97d-4324e4c3e1emr38658330f8f.7.1767089764004;
        Tue, 30 Dec 2025 02:16:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHK1atjAKrkdoWQy4jxFj2rw+qTn5U0Lh0sTEHql45jv1yC6jgv8gOxch8xQ2S/3gi1ay54uA==
X-Received: by 2002:a05:6000:200e:b0:430:fcf5:4937 with SMTP id ffacd0b85a97d-4324e4c3e1emr38658276f8f.7.1767089763428;
        Tue, 30 Dec 2025 02:16:03 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1b1bdsm66936468f8f.8.2025.12.30.02.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:03 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:00 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 05/13] dma-debug: track cache clean flag in entries
Message-ID: <c0df5d43759202733ccff045f834bd214977945f.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

If a driver is bugy and has 2 overlapping mappings but only
sets cache clean flag on the 1st one of them, we warn.
But if it only does it for the 2nd one, we don't.

Fix by tracking cache clean flag in the entry.
Shrink map_err_type to u8 to avoid bloating up the struct.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 kernel/dma/debug.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 7e66d863d573..9bd14fd4c51b 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -63,6 +63,7 @@ enum map_err_types {
  * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
  * @paddr: physical start address of the mapping
  * @map_err_type: track whether dma_mapping_error() was checked
+ * @is_cache_clean: driver promises not to write to buffer while mapped
  * @stack_len: number of backtrace entries in @stack_entries
  * @stack_entries: stack of backtrace history
  */
@@ -76,7 +77,8 @@ struct dma_debug_entry {
 	int		 sg_call_ents;
 	int		 sg_mapped_ents;
 	phys_addr_t	 paddr;
-	enum map_err_types  map_err_type;
+	u8		 map_err_type;
+	bool		 is_cache_clean;
 #ifdef CONFIG_STACKTRACE
 	unsigned int	stack_len;
 	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
@@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
 	return active_cacheline_set_overlap(cln, --overlap);
 }
 
-static int active_cacheline_insert(struct dma_debug_entry *entry)
+static int active_cacheline_insert(struct dma_debug_entry *entry,
+				   bool *overlap_cache_clean)
 {
 	phys_addr_t cln = to_cacheline_number(entry);
 	unsigned long flags;
 	int rc;
 
+	*overlap_cache_clean = false;
+
 	/* If the device is not writing memory then we don't have any
 	 * concerns about the cpu consuming stale data.  This mitigates
 	 * legitimate usages of overlapping mappings.
@@ -487,8 +492,14 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
 
 	spin_lock_irqsave(&radix_lock, flags);
 	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
-	if (rc == -EEXIST)
+	if (rc == -EEXIST) {
+		struct dma_debug_entry *existing;
+
 		active_cacheline_inc_overlap(cln);
+		existing = radix_tree_lookup(&dma_active_cacheline, cln);
+		if (existing)
+			*overlap_cache_clean = existing->is_cache_clean;
+	}
 	spin_unlock_irqrestore(&radix_lock, flags);
 
 	return rc;
@@ -583,20 +594,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
  */
 static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 {
+	bool overlap_cache_clean;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 	int rc;
 
+	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
+
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);
 	put_hash_bucket(bucket, flags);
 
-	rc = active_cacheline_insert(entry);
+	rc = active_cacheline_insert(entry, &overlap_cache_clean);
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST &&
-		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
+		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+		   !(entry->is_cache_clean && overlap_cache_clean) &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
MST

