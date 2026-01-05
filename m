Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBB6327C13
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601412; cv=none; b=KtFbbrMLKdxK+H3BYT6F/6hL6bkgDm5xeDqQHs8Qpd841bafFHj7lL2M8jpmP+ECs4uYvtdjKQpO2upJSpoa2O0RyEVk5ZzdXUeB+nX3/MEoTPkW0xLRo/ZvZWSYye87nYoNoozf1+CTSXbGW3JH4q/guaFEoSob6hlwA49nFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601412; c=relaxed/simple;
	bh=m98JsLLlZnpLuynLg3Syt9uCZ7QvI0/Lv10M2IDOLnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rsH+KlkH1aMrF2MTJcoId8Mfc+53xzhde2j/xEYtv9c1JFGBKcW5/ZRmHxYg2FDINY8/EKB5vhF4mx57sRqLCOnVVp+P/Sf3Zge6/XpzwW+INoO68YusCLKNE5h7O4uLFfLkpktDNEHmtt+vasnEUHu0KSbzKhoVgLIqAvtQxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYx6RUs6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HNFt2K4n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYx6RUs6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HNFt2K4n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I9g6na9OJuiciu3rQw6J7JsbFxwpCGTH1jubl50jggg=;
	b=cYx6RUs6goTCeNY6aVjYx4YQS+ptNWYGgTbCMRXb5PRiY2lkA1apxrYhN0AxiumV7LBBBx
	FmJcuAkjj68Rrek1YWBGWyn+h/uK9jApFFWVtLwi6OLNalnuM3UW6EYKXmtWaCokZXoNDf
	Di1SYtL7U0HIk1/BBsvLv38zbHZtl+I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-F2YxBDKVNriHZZNrsY8hKg-1; Mon, 05 Jan 2026 03:23:27 -0500
X-MC-Unique: F2YxBDKVNriHZZNrsY8hKg-1
X-Mimecast-MFC-AGG-ID: F2YxBDKVNriHZZNrsY8hKg_1767601406
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4776079ada3so122521315e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 00:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601406; x=1768206206; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9g6na9OJuiciu3rQw6J7JsbFxwpCGTH1jubl50jggg=;
        b=HNFt2K4nrKwtmV5zxL9p1IDWtYF6/CRC55HJdhLX6m3fggaCCbMmekZDKVQeGoSITW
         RZZgbEGUcgdzte4iaGro3BeuE0f77uJN9NyA8u5GtVYMabjpU+1BX3VFPthMgKY5WqaA
         lgIg880J3bPrGGeXDaTu7uxcjT55B6xlWG0BgjSQuQiHROeKazcumFp1r1J1O5O8K7sF
         0jOXhX4tytfpcSJjWoSK1vKehMyplHa4NJ4RsoPN2fhXS8AiOehW+KOCcZkBVWeQ3iMb
         86CMUlvBfaedLWcxKcEEUvjEb5CgXx9M95W6GgTz50qJ8vaUwJXnr6cM4sHTdH2HFzbl
         3pow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601406; x=1768206206;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9g6na9OJuiciu3rQw6J7JsbFxwpCGTH1jubl50jggg=;
        b=PPAUmE0xs2p8MrOxTmOLLJ896PgVmV8tOUHZ7wrhaiITq+sXrpYPvVyRo0Hf7f/zHq
         wiTvwe4Vmn9/Zsz0HsnkJVl4UY40hx9GE0doM15JsfQr1dS+DQVdwGRczeRLVLk+exRz
         iCT50ZDeR4ggG35Azz0Aj4tlS7XCELAP0V4mUrzmfULM1SDl8JQsj+JvikZC0onCZTpP
         hirPOuFbkDFSObV/0XPrXgLwueSOKaeLiE/qi1xXOCAYCaLjPpEG7Jocc5cewTezd8iM
         g9MF6xY8VyKF65LsyXq9/KVFSJ7rw+x4sw1uOwfWsF7BQi3ky3fUxDx/DXvgMR6DLxbM
         JHRQ==
X-Forwarded-Encrypted: i=1; AJvYcCURxJPl4rw68qsvtlnmvfGOiQpuptGZAkxd8/nPQWoChrSCB/Ou4VFDLvk56yBiX9gg+BFSVr1EUwgezGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeX2lziBu7jzq+hzN1632jGThDGLOWEDMxIxcr0xihiNvk3Pk1
	3oYTAtYHwGFehGB/+CeUKNoIbuk74A7WFd/yHC+3tZLf+Q/N0bGMQTUNjC2sZnX1kQ6reUWUD7C
	B5vHtfwd1h+AUpTUiX3lVlFOYQvqrR2zSlur2f1dxqy7kpwUi2b5AHe/dBQuqVVxBkg==
X-Gm-Gg: AY/fxX7ToUEQdWz1BqS4mp9hLduBLeXHTmprWSU4U2qwi99oyNSS8ODWDucEwzjGyd8
	fr3yKPTJPf8hvImZ+msUQRC6H6wlX86mSm58avq7FLQKOCryO2NJBC1hpG0GvOPa8faVpEAadF4
	ZkxjunTWN/tDlfxINqjyczr+1+TEEgjq3rpELC0Dz0mMWq7HkhNShm3gHAefiDW2rXXW48xWH4d
	2wsFv9WmWRO5LUqv77fc23THUtNdjhNDL7Sgu4t+mma779TxTk/tn2nCTZGGESpUw+A0z80qbSk
	W/lzj19fMuiaVFU7axHHqtJpxsb1u+nXgePitJEFb0xMgXNcKlr0IQYAQabOsygvKXfQekOzz0A
	/ijJvr6Xys+tGRVKktlRWsU8Cpqvu2PvILQ==
X-Received: by 2002:a05:600c:4446:b0:475:e007:bae0 with SMTP id 5b1f17b1804b1-47d1956f896mr633168595e9.16.1767601405664;
        Mon, 05 Jan 2026 00:23:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGv7DIcbBq1VkvqQ23EJm44n2GxyGgRTRuTvRGBj8avn63Zc8/z+R9wImAFB24DC8Gpann5cw==
X-Received: by 2002:a05:600c:4446:b0:475:e007:bae0 with SMTP id 5b1f17b1804b1-47d1956f896mr633168065e9.16.1767601405201;
        Mon, 05 Jan 2026 00:23:25 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6c08f56dsm51171265e9.9.2026.01.05.00.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:24 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:21 -0500
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
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 08/15] vsock/virtio: use virtqueue_add_inbuf_cache_clean
 for events
Message-ID: <4b5bf63a7ebb782d87f643466b3669df567c9fe1.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
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
index bb94baadfd8b..ef983c36cb66 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -392,7 +392,7 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 
 	sg_init_one(&sg, event, sizeof(*event));
 
-	return virtqueue_add_inbuf(vq, &sg, 1, event, GFP_KERNEL);
+	return virtqueue_add_inbuf_cache_clean(vq, &sg, 1, event, GFP_KERNEL);
 }
 
 /* event_lock must be held */
-- 
MST

