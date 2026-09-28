Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335513C5536
	for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2026 06:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790577092; cv=none; b=SoW5viLrfmEDCFEyHGbBEhLvAwYKB9IyXeJ1e7Srvdqf6xTVFlZaaJ4sbQgJsDLeeEFxU4ydyL5mLfjxMNX903OeqoahY5aUYdGbv6Fe9BgjHBFiFxzjZ/3KEdiMyDYASB+ttoAQwpuTOKOZCLWiyzbpPf29KjI1iK/LwAM8smo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790577092; c=relaxed/simple;
	bh=MOM6rh/VxJomDENxVfQZur4f9xuvpadnAtBuvABwyE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XdJlFUhlOVoUc+Zrx/MxmAK4BAAjfSQtN58vGliP16OnY7EdiJmuCZ5Z0EY3ZEUKuehnBie6XK3KDjsgqJjnXowJpin3g1H60NZfZbHLKEGmC6ecxHTDrK8+aJa4Zp3MQt898jh7rw3AaFkqsrn3IvdjRIUZs05iAddR1lOXIlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MNd9Xezb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJxSSPHS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MNd9Xezb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJxSSPHS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790577090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=am4FV5zPzLpIgyayecCc1N4MqLF1/2ADTO13ltna5uY=;
	b=MNd9XezbQaZMqJrmMWhoavDRmqVILpkvdNXQYIoWYXfYsdCXBCtQAclA0IEEkzdsgB2l6Y
	Jx8ssdP2DBI2rr1yi8lrYmOhUrm0rCS+CtAZQw+wgWVTKGUvyZOw+W0FE0Zlus75U2qKKX
	JapxM1gvrP38/IeIWyCT50RyRbIq+Oc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-qfjiDh1uPfWDDe6TeCckAQ-1; Mon, 28 Sep 2026 02:31:28 -0400
X-MC-Unique: qfjiDh1uPfWDDe6TeCckAQ-1
X-Mimecast-MFC-AGG-ID: qfjiDh1uPfWDDe6TeCckAQ_1790577087
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48704504d61so596686f8f.3
        for <linux-crypto@vger.kernel.org>; Sun, 27 Sep 2026 23:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790577087; x=1791181887; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=am4FV5zPzLpIgyayecCc1N4MqLF1/2ADTO13ltna5uY=;
        b=EJxSSPHStMa9+bvS3vTz2+/esNzdKte7p++b8ozRIb1wSbLv0G6TrmOY2J9Wc6vGpF
         9w4SnP1UJ8bbGXjkLeFnTDl2+6rks36HRs5ZLHTb9kICYsYwKfQJ8oCGzBwurcz9EjF7
         D6JJlO9TgcYA7jYG44Su394ufnvGsAFjoRAYRA5KLpbDctFVg7Ii4t8ToSt2+/OE4ziR
         w0CIPUL0otglsyXHj1g9UiF1+N4EHnlHqIww0/isBEgGYrB6D1pKi7uo2ST6Jp3BzOrx
         SeUNRnNzxLN80wFsCTh8HEZ7WK69XohfOcnTBMTJq01EplU4l2CSUWg8wUcq1oV1AyoO
         jtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790577087; x=1791181887;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=am4FV5zPzLpIgyayecCc1N4MqLF1/2ADTO13ltna5uY=;
        b=OgsBb6Fa3JTg74gJFBtR7Oijw6RghO7twHynYRQvYIvk3ehtGrpuzu6NKiNWpRUvEu
         x1rScH4DlOfzYCreYEpVYacmsVzmPA8pYKW65EcVh9325dOVx/5i6r0bYEmRViTywOrh
         9cCrZIL62Iw1d5/QvhLy3hQLB5Bgp62JklobOHKgNEpm76bnO6XABY7sNlLVDvxJSEfM
         PtRte1MwSHoavzx+tyudDNgn/4qBTioGVyuI6h+WKTlBNPXX/2gusTZX1mCagaDF/D/R
         jRzALdQ1ayUYnUteY9l/AszIuSZOZa5bU+tjjbwKx2jSFeEoRaAEnbf/YhtRNpdNabWr
         /p2w==
X-Forwarded-Encrypted: i=1; AKwUvBw1W7RFyy5/Biuu7NiioZngwmUxbvwou7JSw+32iCEJFp/muNJlmygZG2ZZKQZVXPKQPp1eL2ZcbZGQFNs=@vger.kernel.org
X-Gm-Message-State: AFuF++noQuzztC3tGiQMC3EEL7F4U6M9NApbw9GnF+hV13bumi2Au1Na
	bMUrNjjrDc+fHCE1KEC39kWwSSUosUcYfP0gfJnz2DKyN/TR9ld7mxtVq4tH96VJ4MzIiGdpiOg
	DPMRh4J6ekEjWMCz7FQnaWwjAXyaxxe25d19Q8hQWoOoYqDUUrnsLGOPURinUj2HxIA==
X-Gm-Gg: AYBFou0vlDyJKEVRt/fhyAmX3AlaszniNYsSCZ7NVqM4r03Rw/WUwkzVYtw6qyWzIqI
	vya4z83a6YDU3EQFCQhM5fiVF+LEDIUR1SmCMK/u77HmQ26yky65cF9QilJ1rpJpZPHcTwEyuZG
	YmlqC+ok5NjXvcz756yok/lxyevtarNwzGfDNO51ChLfkH3Of9Gd0P5sR1CapPBtyOFkjkMzLW+
	vzNm/Mrp2oBk41cOrT+TtW9cjLTFUWReNdVebSSDkrfXQQ3Orrziosi7j3K63y393cLYlbyvLo+
	C6cqzQzUzKzdrpI9ZU+KqYQ7oHDfpeaw1u4qvh6/nnjRCo+5dFzByp0/8gJcu7chN61ncp6KdPE
	kAaJSmBnyV3JjoXhMPEEC8nVNYr0oQ+i8YYH0yFH3/68=
X-Received: by 2002:a05:600c:3494:b0:49f:ff73:9971 with SMTP id 5b1f17b1804b1-49fff7399f4mr64210045e9.18.1790577086790;
        Sun, 27 Sep 2026 23:31:26 -0700 (PDT)
X-Received: by 2002:a05:600c:3494:b0:49f:ff73:9971 with SMTP id 5b1f17b1804b1-49fff7399f4mr64209625e9.18.1790577086278;
        Sun, 27 Sep 2026 23:31:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e10:ef90:d92c:7e4a:47e6:1b23? ([2a01:e0a:e10:ef90:d92c:7e4a:47e6:1b23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017656cesm110644755e9.3.2026.09.27.23.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 23:31:25 -0700 (PDT)
Message-ID: <f49cbe7d-79b1-44a3-bc26-9182284a74d6@redhat.com>
Date: Mon, 28 Sep 2026 08:31:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] hwrng: virtio - use snprintf() in probe_common()
To: Thorsten Blum <blum@kernel.org>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260926055853.4868-3-blum@kernel.org>
 <20260926055853.4868-4-blum@kernel.org>
Content-Language: en-US
From: Laurent Vivier <lvivier@redhat.com>
Autocrypt: addr=lvivier@redhat.com; keydata=
 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
In-Reply-To: <20260926055853.4868-4-blum@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/26 07:58, Thorsten Blum wrote:
> While the current code works correctly, replace the unbounded sprintf()
> with the safer snprintf() to follow secure coding best practices.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>   drivers/char/hw_random/virtio-rng.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index 5b1b23b5596a..f9982217247d 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -162,7 +162,7 @@ static int probe_common(struct virtio_device *vdev)
>   		err = index;
>   		goto err_ida;
>   	}
> -	sprintf(vi->name, "virtio_rng.%d", index);
> +	snprintf(vi->name, sizeof(vi->name), "virtio_rng.%d", vi->index);
>   	init_completion(&vi->have_data);
>   
>   	vi->hwrng = (struct hwrng) {
> 

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

