Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD1D226D17
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 04:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765254782; cv=none; b=o/kGq8WzHJ0xWnMz7MVxhIP5od0OTJHDQ39E/gSeByAzL6Tn7AiboBTaq6Fazv5dxER0qtJLY2gVNmQsLOVLUYBgV/mWza6ZGoy0sXGLdGBxihY5K0EbauUKpqKkathwBzaB37AczDNUOYT5p3HFjX4ZmRJMQz7eTWq3r3JwZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765254782; c=relaxed/simple;
	bh=IR1GJIw1WogTr/OB4lNYncQ1ZxCQwr6Kq+gJH+Iw0t0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TPNVqt5nfSaPp+JL6mJbCAwQE60EB2LdE88prh/VgG/pVBi+b4p8l+LJ7ULKRKsea0ONTyxSczg6rXjHv3LtnIjhY2Yb1kkRyOl8iVEjm3mS5HKAFuzKxdTICMP6g191C40PKRk5L9IOtkiiXBlJPQYxJZ6r7hOlEyTFC4PwXUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aa6kHL1D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGjEYRBU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aa6kHL1D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGjEYRBU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765254779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D7tlj801JGEwEviglxOLZTOSOnNkUWu4oKsf3XJ8MAU=;
	b=aa6kHL1Dt5u3jh8VWsdoMjOqn/04BUwO36pVlyZ15CqMyxanpdDQzubOp8m5BTvqaicHck
	LP5+TdlJn+yI6OITEFM3aTdSOx/iBerZMT5za4mBK8jfV0CqZSoNPWvFKMX5ko3pI2wYMP
	1tzblQ1PScWtxNt2WLFGoOFYjYonUYM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-IoQtqwItPKKWMvgTmNsCHg-1; Mon, 08 Dec 2025 23:32:58 -0500
X-MC-Unique: IoQtqwItPKKWMvgTmNsCHg-1
X-Mimecast-MFC-AGG-ID: IoQtqwItPKKWMvgTmNsCHg_1765254777
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34992a92fa0so6716419a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 08 Dec 2025 20:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765254777; x=1765859577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D7tlj801JGEwEviglxOLZTOSOnNkUWu4oKsf3XJ8MAU=;
        b=cGjEYRBU9uyXGvVJR7FkTj8tlz5qNRfRxY5qLuguciAqWUBhWPnvzihuidLf12atnw
         HfKq9E4kAIlWVpy2C7EEp++Kl3V9tSOiJsf4dGbZa/EwkKsNnJXLjv79UTiURXLqGS6T
         /W5YjgwgnEeXIiC4//PlaA+6oM8rrg0YumdGHgyWNrZJW48hRgfhS4Jh/lz3/vIZI6GU
         vrydqTYquhtXd4w9wsj4zRxKeVaCF+Bxz4ItfAXKedP+v//suwT5LboRA7C1qmZOy6jN
         hkBj8lCqSXVSrrz3Fy8/gPG0nCqHYEWYwAKD33xYegRRFoppHe/0edmyNpLY78IPsqLp
         A9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765254777; x=1765859577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D7tlj801JGEwEviglxOLZTOSOnNkUWu4oKsf3XJ8MAU=;
        b=lQxwrwwr54qBGKOqRSLUWh0GFk02aIsS1O9zrfMMz2F3reC/AAjfnaizZa24Qm3qsr
         greV0WgAiu+dGB7Rl9/+AMfCxRz6swrFqGTRgL2EQwhbH3z7Oo0UKYkVY85Gzg7ANSmR
         CbHkXaEMZlJBKtsFCAB46ITAzYSoTswOjpk8OApANS6OEs5X8jnGo82SUBiY7HQF1fwq
         q+skO6fl0HMzIqj3HHfOcdZhaIC9KRt/9XdmXv6/4pSedIk5J9F8JVajt2bc99W1kXZV
         8KadwheHrpXAL2PCo5laY1r8xnauageFMivkQ5BeXBBQgzNdyys4bx/RtccAW8oiNrRs
         xhBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAX42L2eXJFcYni1u/Tdi9mkkI46F3to6uEaV8nC/7+ipnTbRKHUV6duRnA9jNK1cj50PgAiA887j5ye0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAkCndB/9a3yq+xQ/nBJFt09tcVoVa+C/02Bq8kBknzrqumNbe
	kIiy+MpGqA6LTRVFkFRaaVAyHGYT+U+tLRgPUxmG3ZfuME3z4U8qdwUSeEzhrQM+KWef8c+g8zg
	3dmIMh3HFNKM/bjCAutpEcOXYMkHqGjr06mNKTXlSs+dANEkGV2XVIVvSD8dmDIg1keArTyV6Cs
	x7MjF8eDTKqbUEXXRRuV5XRYqd+orY1LKmH70MciX1LdW9QAU3kY4=
X-Gm-Gg: ASbGncsrd99sd28OVQwaOzpudXHfA1P3k95bsufKOJmia8BQCr4PxH731gfroKT4X+5
	sdygS9PNECVmmB1F9Zl014UTO5ngts6oacTNQy18gYFwC79mGALScmvCB+0ZyU7a74Uz0jSpCit
	yjRfeiTAZoqxS3BcdBnAKyq0+fdWU957wIAtJRZ5rhphnWtWJnXgi7fXDZWVm53eDPpg==
X-Received: by 2002:a17:90b:4b02:b0:340:e521:bc73 with SMTP id 98e67ed59e1d1-349a24e1417mr6855256a91.5.1765254777254;
        Mon, 08 Dec 2025 20:32:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEdw0M8LAPWgyO/elXlfshz40Rlioju2PuyFc9XLzszeCdo7ctlmBpq76QMP0pwFL39U8NEhUcTgC3HIYBdbo8=
X-Received: by 2002:a17:90b:4b02:b0:340:e521:bc73 with SMTP id
 98e67ed59e1d1-349a24e1417mr6855241a91.5.1765254776843; Mon, 08 Dec 2025
 20:32:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251209022258.4183415-1-maobibo@loongson.cn> <20251209022258.4183415-2-maobibo@loongson.cn>
In-Reply-To: <20251209022258.4183415-2-maobibo@loongson.cn>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 9 Dec 2025 12:32:45 +0800
X-Gm-Features: AQt7F2oiXNzEXvaoIJ5PYmQS-SgPLwwMhAbf5fZFgBwLJ4Ewmxplg8YGZKVBbKg
Message-ID: <CACGkMEu3rhZy6hiZ14AvXgXLz2KvwvcU81KNrP_XsM475ZM=Nw@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] crypto: virtio: Add spinlock protection with
 virtqueue notification
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	wangyangxin <wangyangxin1@huawei.com>, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	stable@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 10:23=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> When VM boots with one virtio-crypto PCI device and builtin backend,
> run openssl benchmark command with multiple processes, such as
>   openssl speed -evp aes-128-cbc -engine afalg  -seconds 10 -multi 32
>
> openssl processes will hangup and there is error reported like this:
>  virtio_crypto virtio0: dataq.0:id 3 is not a head!
>
> It seems that the data virtqueue need protection when it is handled
> for virtio done notification. If the spinlock protection is added
> in virtcrypto_done_task(), openssl benchmark with multiple processes
> works well.
>
> Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

