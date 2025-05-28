Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19623274FCE
	for <linux-crypto@vger.kernel.org>; Wed, 28 May 2025 09:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748422824; cv=none; b=SGq8kOLrpQHQh4lQj6BlGReDRmeZEtFa3MSQE5A2E+HUYYqJ6g7i0repVwc4rnByWVI0dpTOKBGE4bRQyacOgKPNdqiL57EW9gXyInmwdk9BzDi7rsFvTiBhW2CqQXyEJzlo/eyta/YEH5TQPyv7jaxlQlk6eYfSN3wi0hHZ9PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748422824; c=relaxed/simple;
	bh=t1e/HvfosFpsLoFkhIGG8ncpvv+6aZviJ2nKgmWiOW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwnDxF03nWchpmqqGZv20SKFkG2hMToFg91xcMju8keIpUHgcpt+hQIoEkIamnIp6NzoksIHurFCfuQ0rMokMCO6FgczZamzvqn/hAe5+yuMb0Rs2PjdKnfgtNg8SOe+9SVAVQkdVW4TQAd0j8OQzsbDiiuO5p7J3tOsa6t10Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K2fmwfCT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K2fmwfCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748422822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=64QsXwazpQwW+tOYOMo7hDdSauBGVg6nC6ZKTpmi0VI=;
	b=K2fmwfCTDs4dGc61cpflZabEFOjCWO6oam0nm+IY1Lvbu4lzezAithrhmsp2vOKWGMMiBJ
	UAcOhUN6o7hSsJ/3z4jDSmQVHpgbwJd+W4wiTQy9xXxlKpWMG9aSxVq2vP1DXNLWggV3l+
	CVn4NCFhicR0swLEFFd3vemDGlKeLVA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-Sjjtpq31OCKszEtHJDf8yg-1; Wed, 28 May 2025 05:00:20 -0400
X-MC-Unique: Sjjtpq31OCKszEtHJDf8yg-1
X-Mimecast-MFC-AGG-ID: Sjjtpq31OCKszEtHJDf8yg_1748422819
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a367b3bb78so2466691f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 May 2025 02:00:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748422819; x=1749027619;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64QsXwazpQwW+tOYOMo7hDdSauBGVg6nC6ZKTpmi0VI=;
        b=OCcNlJRmfD3UxSKnHgNxrnAFIS166xNiPPqrCm8FLeN7jvnjodv3WeEdE+sRbrCDZe
         j+FL/LPNUxJIfi8OXDN4GweyroCABMqzM4On1zWABlTJYrTR0VEFWOCWqVMtlJoYnFrN
         4bI8mOQ7q21yoBO1DXG8LFEbhkAbDbwUPOOyeQVuBtT4Dy63n9VU/+NwnVM9eTHT4/mR
         aSrLAPuX3s+GTbnYHUerqp/+OKrS1QhQK35SuMYwb15CFTdER7dParFP7Xuazf71CgAm
         LZ+WuQ1M6ibiQY2rPf45vVEtiFz1KvhZJKQrJ1xSFwWWmzWUFDG9S20zeZaJDMk09iEN
         Kb+g==
X-Forwarded-Encrypted: i=1; AJvYcCVab0CEhiPaokxRosV1XbthK3NTe3oiWWE6J7r+9d4xcN76i0glyLYMCqOZQHmTRxg8e4BLlSaq3JGNMB0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4HLVDsuSGHcnQhf78zptv9AUc3NAVR/H60etM5FCzdP0cJtRp
	ME4pH4ranGLsJA/ucghchZ28vnFicSu5OGCgHZamF5sXVCOUXvyjG/jkvE4vxCgEpkkysgIlZ28
	k8FCFSUqKsHp3IPE72lJKGKCzjPWiWpQ61xaFHjwQpMBp6GB7BUJVx8zT6u/CSwT9Zg==
X-Gm-Gg: ASbGncu74p1WmrMqa4LmBPB1SiGhWpcxTPgk2BeWwiK5FJu9BM2IKcNRnGKMzZ9OOqp
	q2ocZsAb0di4xr2wk55ZYNpn59Ufj14IT4YUNqDyR7kUEHXJs2yDY4T8QRZyJGNxIJc78zSPVeR
	gmNFnfGX+RjMt1bvAZLaR8UPSMvjSU9L6HdYfQ5YHV394co5QjL4ACnuyxCrYK8PIY8SVfgOJDs
	cne8DzS+eWMUKS+AqpphrKWDfTzoEB2VKjlhBkqDzHRVPVETe404paTGrP0el82sjEubWKCPbwr
	a+eIUi77T0hg7gU54mVorSu4+nrvTceYnrvad672Eqe3rR/Si+ukKR8uieES
X-Received: by 2002:a5d:5f8b:0:b0:3a3:6595:921f with SMTP id ffacd0b85a97d-3a4cb4b822dmr12928263f8f.41.1748422818879;
        Wed, 28 May 2025 02:00:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjrV5vgUL5ysXDl7B3oxB4ovG+UqKk+QHfVQ+EndsK3P47vCbb2duzqpq4xfTjaqx9Sg54xQ==
X-Received: by 2002:a5d:5f8b:0:b0:3a3:6595:921f with SMTP id ffacd0b85a97d-3a4cb4b822dmr12928217f8f.41.1748422818345;
        Wed, 28 May 2025 02:00:18 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4eab0b596sm892079f8f.0.2025.05.28.02.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 02:00:17 -0700 (PDT)
Date: Wed, 28 May 2025 11:00:12 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, herbert@gondor.apana.org.au, jarkko@kernel.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca, linux-integrity@vger.kernel.org, 
	Yinggang Gu <guyinggang@loongson.cn>, Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH v10 4/5] tpm: Add a driver for Loongson TPM device
Message-ID: <gymx5tbghi55gm76ydtuzzd6r522expft36twwtvpkbgcl266a@zelnthnhu7kq>
References: <20250528065944.4511-1-zhaoqunqin@loongson.cn>
 <20250528065944.4511-5-zhaoqunqin@loongson.cn>
 <7ifsmhpubkedbiivcnfrxlrhriti5ksb4lbgrdwhwfxtp5ledc@z2jf6sz4vdgd>
 <afaeb91a-afb4-428a-2c17-3ea5f098da22@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afaeb91a-afb4-428a-2c17-3ea5f098da22@loongson.cn>

On Wed, May 28, 2025 at 04:42:05PM +0800, Qunqin Zhao wrote:
>
>在 2025/5/28 下午3:57, Stefano Garzarella 写道:
>>>+    chip = tpmm_chip_alloc(dev, &tpm_loongson_ops);
>>>+    if (IS_ERR(chip))
>>>+        return PTR_ERR(chip);
>>>+    chip->flags = TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_IRQ;
>>
>>Why setting TPM_CHIP_FLAG_IRQ?
>
>When tpm_engine completes  TPM_CC* command,
>
>the hardware will indeed trigger an interrupt to the kernel.

IIUC that is hidden by loongson_se_send_engine_cmd(), that for this 
driver is completely synchronous, no?

>
>>
>>IIUC this driver is similar to ftpm and svsm where the send is 
>>synchronous so having .status, .cancel, etc. set to 0 should be 
>>enough to call .recv() just after send() in tpm_try_transmit(). See 
>>commit 980a573621ea ("tpm: Make chip->{status,cancel,req_canceled} 
>>opt")
>The send callback would wait until the TPM_CC* command complete. We 
>don't need a poll.

Right, that's what I was saying too, send() is synchronous (as in ftpm 
and svsm). The polling in tpm_try_transmit() is already skipped since we 
are setting .status = 0, .req_complete_mask = 0, .req_complete_val = 0, 
etc. so IMHO this is exactly the same of ftpm and svsm, so we don't need 
to set TPM_CHIP_FLAG_IRQ.

Thanks,
Stefano

