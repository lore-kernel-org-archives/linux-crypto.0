Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF14238F624
	for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2026 06:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576704; cv=none; b=dzVPmbcpHpg+7U+q6b+OPgsD0TpQ6Gywfz0Pf4xNJcBG4HsOAeKA8oj0jdEJ62RGebjiCgSgsiqMdYlgYJGbNi3q+l9aMiwCCEk2OjwVNzaFqd3d5IsOYEiGPTQYuy5XwnCWQtWeHaGGizBoqaYc6ypVO96NorHtFH32kiJFBvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576704; c=relaxed/simple;
	bh=KZb4zjaYKCS4prlQQxqBP05QDUbZxcdOc3sMTeygcKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWnzLwCPkIbwKurUjXEm/MVorOwntSV90Ph70E7kVA5TfmsKxeo5HOQ4DcKsHi7gjATlik1AqhCDPzN3a/o/y+d227uAKYelEuftGPbEcBcBpUj+DcWd9Hy2FQxpZM6egc3QKKM0Tv8KS4cMiKGA9873+uEmCwOt/SfnbPcKbGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YH8T5SQy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSV3Pije; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YH8T5SQy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSV3Pije"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790576700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H3RYVBRS6lci+skHKVw9nj7+rFhqDojBssvDAah2vNM=;
	b=YH8T5SQy2kFLCmHK/l+BihyvXhu7LqPaMlHp/veoLfC9jOx3YVr733BA0j2fch47fykkuC
	NpcaaZpIrq0zZlnb7W7WfRKIQGF2yP2Sy9999wE16YmxBWZpDTd7GA5StvAwMnsHlcqgTa
	IZjtCwhPzamBSdL2s4IPHkBsOSaUUbs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-EfqF3xbMMnOhfKg01Fktzg-1; Mon, 28 Sep 2026 02:24:58 -0400
X-MC-Unique: EfqF3xbMMnOhfKg01Fktzg-1
X-Mimecast-MFC-AGG-ID: EfqF3xbMMnOhfKg01Fktzg_1790576698
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a0037a1c05so5957345e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 27 Sep 2026 23:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790576697; x=1791181497; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H3RYVBRS6lci+skHKVw9nj7+rFhqDojBssvDAah2vNM=;
        b=fSV3PijeKuXbh9fcXYL62lk19FgWwyUgddKRuIO+CgtQDuzXIKh0qWNdmDw1sJ+6tW
         pANsBpBSqbHIpgT+YJnnLLChpET96EOLL4fV7h5XOclt/Icb/v9sILwBX1gVD+dHzptU
         RB8RMSZs1fNvwQfSEnU3Zq5lSMTnDaJ6PKUJ3MtaxyeuSgtQ1KhkzV8T8wBBd1u6iNNV
         s+m8sTlcoHvEGuxIv/RXa5oBGZIA0D262k7LXuWCt3ccwRmXEYOgIS5JdYpshQdeWytD
         CN1lK4evVk6+I3vAuZqm6WxMVuhqjLsbI4lqhXOOgpbYH+jq3iJAt9sjFDC7oh0G8IwQ
         Cy+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576697; x=1791181497;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H3RYVBRS6lci+skHKVw9nj7+rFhqDojBssvDAah2vNM=;
        b=el0Xvoz/0H6hlbkul/GZqC6dVyxi0fXSRI8M/sQ8HtRjXXEC+imAshjaqDIWx9ek/E
         JNFTdnUzJXbbsWUR4ZOV6IWFPM7Pyjl7fq/uXVD0Gw7THj8LiSdXJVq4H5lpKZ6fYwUf
         juzruALSIDF9SA9G4oBCLyXXwdtoiSII/1QZKupuKsrQEAe7W3V7P+GkR/AnBSgw6VVx
         vIoqTgJ9EFTx9XOy2YTg08tSurB92v8oUUmZgPtz+6pXlakDspKi617Q73H0HgYCGOss
         tuaeljotFwmG6uIlPsYPYuMACCEVH81tLsWla7NtAeiGjvjH8XcLYH0V6R/xXCoX48B7
         eV0A==
X-Forwarded-Encrypted: i=1; AKwUvBzK6z+OOpEJXY0l58WPos0jJx/cIyI5u58JxjRUguQAp1qXNkmJImhhX0RSP+xy89O2N1jXPA4WtGG/KU4=@vger.kernel.org
X-Gm-Message-State: AFuF++luOBxkFQ7Oxnf/y/dX8OdOpt6PIGslycs7HDxTxR68pv+vyGTN
	lqPONQUTVwO+lwtDjT0ThHEXLlliTh8PctENAlM2NfQGwgFYrTjG2qowbKLpCCCFck+keHoL69b
	9FUMMnfaZ9D+bQc2rHoqoNrvzXvz7y9FE131eCsNQojHKX3CJUnr+7aw8yRNvFMxNXg==
X-Gm-Gg: AYBFou3ih7qF8x22ANIVwloR+AGsNBbso2VBAj1q0wI0+FZZo8fKnljCo8O2BpJ0f9M
	19gsA1WMLB97ApzIHdHnWiijnuBDJIlOhmf5riSLX0r5/dESqDUm4HnDRDzP/wzq8oHgAdjXhBe
	Bvt7Nx7h/BqYVkr4G6QWcqvLgtF9dXBBRPt5hByRyLZVGOD5cNkUNlI56sUh5ENsoyzxBT8TF5H
	ECNWqxz6x1LiYKIOb47MEzQ3Go+2WG6OICW0Fbc6Al8MBxyXGGAEXe4+AzDrNFzE4AGjYZLnXO8
	1bf1IyKNBJdQRoHq/rLetf6A4KeDsg33WSu8WsxIlXzX7rvGdU3HUtqp2DojW6liKJuT+F2T
X-Received: by 2002:a05:600c:8484:b0:49c:fe46:7219 with SMTP id 5b1f17b1804b1-49fe66d8135mr202359695e9.20.1790576697530;
        Sun, 27 Sep 2026 23:24:57 -0700 (PDT)
X-Received: by 2002:a05:600c:8484:b0:49c:fe46:7219 with SMTP id 5b1f17b1804b1-49fe66d8135mr202359635e9.20.1790576697232;
        Sun, 27 Sep 2026 23:24:57 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00178174dsm108202995e9.10.2026.09.27.23.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 23:24:55 -0700 (PDT)
Message-ID: <b2142da1-31e4-4d53-9ae3-c00c8301b0f0@redhat.com>
Date: Mon, 28 Sep 2026 08:24:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] hwrng: virtio - use snprintf() in probe_common()
To: Thorsten Blum <blum@kernel.org>, Laurent Vivier <lvivier@redhat.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260926055853.4868-3-blum@kernel.org>
 <20260926055853.4868-4-blum@kernel.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260926055853.4868-4-blum@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/09/2026 07.58, Thorsten Blum wrote:
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

Reviewed-by: Thomas Huth <thuth@redhat.com>

