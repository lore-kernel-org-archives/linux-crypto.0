Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CEE2EACF9
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 10:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089781; cv=none; b=Q7TKaau3xVYIW1dfvbsfBoMz8j4AW2+3Lnhf/D8H0rWNrWzyB3vuXoxbUnS0iVHRyYs2N3e8JL/GBUQ/99wnEioND0XUWHTInAenPCjXoSq6s6MGf7/i0km9nnH6Zlfqjv7OeYdHB8XbJ7OPcqgrGS3tplfJLM6oHW+lhUPUdi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089781; c=relaxed/simple;
	bh=d79M2iBKtK7/e3UWQBP6Z7XMZcGHJdPNMKAqQ6Eyk7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZ1IpEAmU6UwYUmnLcnxzeSXM7WU6NvhX/76Cs69TVg0KezQKmnGxOPZcbLPKNew+QSAoaGq2+Nds3OX6zo3vS40BUOHPpoLVKp9K2K7HVEugIxVr7WXgywRUvNY9+Ios0eM6cVsB0SEgXzwdNeaSMijYHHLPblaZ65Tc5Pxz3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hx27djo6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LlNCUSCT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hx27djo6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LlNCUSCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
	b=Hx27djo6x77GeQQ1lgTSKc/rpiU1WdokGmJc/sZ5Z9orN3COn1wNf3Tzt0v86p+rfoMn0N
	CJDZRinML9rxytkRt0M/BsAcdQFYr5z95bCdTEFMaieVJ5oTRPJOGYcvDzUKKM+vqA40M8
	uAHiqfhGbM+tEVcYbRorSWHsEV56cf4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-QxeWDsneMWSpYQZxCJ-BGw-1; Tue, 30 Dec 2025 05:16:16 -0500
X-MC-Unique: QxeWDsneMWSpYQZxCJ-BGw-1
X-Mimecast-MFC-AGG-ID: QxeWDsneMWSpYQZxCJ-BGw_1767089775
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so57717985e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 02:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089775; x=1767694575; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
        b=LlNCUSCTByjGB0z6MsJ1GKRqOrCxKlKxKzGbqSTZscLcZoTmQ33rpW4PooijX2SKVN
         GdkPVv4kz1LwJMCcxDEH2rdpeJZYlU2q2NV15nRJomG3W4VdIg1TwNBnMdL6duDLsEj6
         SITH5U1beqZ3WfDoinZ5ccYNG8KVhPM25lpkP+r6vRtu77abiGOAOUNe1a4fZcHjaOow
         QyauQS7ID7RPNlGTYYk4/rDckAGeF6YvUt6WatWjvM/7XW0IxNcVX2ZRhqBuR/wR0Vo/
         DXHHdKifRDH6ve+UEv2h217bxnJzEdsyVFp7qYUm82SPivQVvNpJTZT/GD/aKchdj5cO
         BPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089775; x=1767694575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
        b=piQkE6S6MZ5ZW+BcOgfFVo2q9RYbimiT3OkQqe5ELF3a8ZTXkei8oHUfiCGbmcKYS8
         b926Ikm4i9Lx49btndeNeL590BT5a353JLCxmvVgFJU6iRKWglLmkTHPPxyWsh++iku0
         NUOZ39TvRwkFs3+5cG7U+R/WL+JVF/Ji0oTfsDM1thoSlhT6h3YV2d1UHaz5buK63WMP
         QowbXnn9Q38fJog7SxDmD7nk+3nN/5EPy4hSqbFgg+cbQ4mTYE1BaVqmViDUe7+giSGE
         YGH/iF2nZaUAZH9f7MTJhpM5+n/9v5sSYmpiYSVAh6DVm9JJUVpuCdQeLXc1/loMnWKb
         70Cg==
X-Forwarded-Encrypted: i=1; AJvYcCWjjucLvbH+0HrbdR8nRUwEkZ0829rCBeMZBdlteCec4ne8uHN/gAIzXaEDWyv7NTwfdQDmUX9lk8u7Eek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5JYlWguSt/Kt/VhBRG3IREYTSkXv0rH6pdYLpd3+cd1KhW85d
	3vkPhapQvukwzCmmHVicQDKLblp5hPDfysfNunwfbXH8Ea3LeZDiEs6UuSJti7uu6Cy6c8H3HEM
	Rpa1piK2WMGIIguJU0J0HdLs8Ny9tPMzuZaKonGuDHnCLvoTuG595cvMRe2YR4h4CGw==
X-Gm-Gg: AY/fxX7K6uLj33mqcoBBsEsv3Djy1FlKPKRlen0WwaZasfxd08f4h3ac2F7CZ3zumPB
	UbW/CHYPjGQ7UHvtZ0LC7Hzn0WeVq4NKOp/nKXC8Dv7+byAItQ0hn5NZsE54v5UEVh9oPdqEG8k
	uy90tjC0ADKkLRZ+oH9E3P//5TDIJ9q6np3gE6TECxxi1EtSLgOlst/8x50UYEedFvhThLytzIl
	54RMyVEUtZi+gmcGHPM7snCvphlg+pyhWiy8ZG96ewNt4YFnDFAgbdyHsv6xxuwN1YRVNWfTnqk
	/PqD2mb93UAorJfvBFsukldxyiUJL94iqf1u7ecuO1lKsFwDpL6DAIli3gt0cFX7J5QGMy5oMxa
	OrSQ6htlSQs9LQqgF2k0sY/9kmckyAMybtQ==
X-Received: by 2002:a05:600c:500d:b0:47d:576d:8140 with SMTP id 5b1f17b1804b1-47d5b261006mr54433955e9.24.1767089774869;
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhdLHPqUgLnPyVKN6hwhRQFuXWAPZjO+w56XwRJ3KNAI+UkHXfY0sXelHGWgys0dAYrWVbAg==
X-Received: by 2002:a05:600c:500d:b0:47d:576d:8140 with SMTP id 5b1f17b1804b1-47d5b261006mr54433635e9.24.1767089774436;
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be272eaf8sm630015255e9.5.2025.12.30.02.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:11 -0500
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
Subject: [PATCH RFC 08/13] vsock/virtio: use virtqueue_add_inbuf_cache_clean
 for events
Message-ID: <34e5e1af186fc92ab4ea6cf6c9f5550a40c9567d.1767089672.git.mst@redhat.com>
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

The event_list array contains 8 small (4-byte) events that share
cachelines with each other. When CONFIG_DMA_API_DEBUG is enabled,
this can trigger warnings about overlapping DMA mappings within
the same cacheline.

The previous patch isolated event_list in its own cache lines
so the warnings are spurious.

Use virtqueue_add_inbuf_cache_clean() to indicate that the CPU does not
write into these fields, suppressing the warnings.

Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 76099f7dc040..f1589db5d190 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -393,7 +393,7 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 
 	sg_init_one(&sg, event, sizeof(*event));
 
-	return virtqueue_add_inbuf(vq, &sg, 1, event, GFP_KERNEL);
+	return virtqueue_add_inbuf_cache_clean(vq, &sg, 1, event, GFP_KERNEL);
 }
 
 /* event_lock must be held */
-- 
MST

