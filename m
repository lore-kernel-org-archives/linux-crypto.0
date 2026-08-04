Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F1A429033
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 07:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785829691; cv=none; b=S5yeWvNuKaG7fXnY/Cw9QJj0uI+bfpUmNmUVNXUAclCbjy8O0mcy3IZ3GCMS4/cClW7Yrjjkl8G01cUh3Uaje+Mk+70SqwL67e06fw345X5+VC0QekAjuHPuoptP0afBh1awjyYibsxqGzk0udROL+TpTV6a/yuyJ6z1mxxlsoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785829691; c=relaxed/simple;
	bh=nU+W7SDGH97PdLGSIseaAXJGwba3CvLcyXPysdkGHSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FDJ3qZIHfTDFawGyUwOnng+wD59nnHuhsKiggdhIvHW6jJyT4tGhKARHj7idMsE4BAd6JMkNlVri7iPC9jLW2LiqxEvYe8tDjgqummKKeCluM7kgWjw5NUlrTA7L3A2WkTKE5VAKhZOtRUF4fOw1wJc/rQ56rHMbpqkqPcrKBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RJa1Nn38; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZDDiLalw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RJa1Nn38";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDDiLalw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785829688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S2JCvWdBkPduFfWzd+eDY+HHzmDvS+I5il57IMK4KfU=;
	b=RJa1Nn3867bFR7CzS2ifaMl+qma3KqZHKh98MJZnvESbl/+yV0bJgTuaPRxOAwjWFrxERz
	jo8PIJDFB0La21X+PzDmVXYMQX3Xrh3FiFUgvdKlfjIo3RjiCwPwh2YhtfYqKKOh2zLMQc
	e++lG1p3GEMCg+6nUQc7V0SX8nYyS/o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-vFh-0a0FNU2_psvfo4zx1A-1; Tue, 04 Aug 2026 03:47:57 -0400
X-MC-Unique: vFh-0a0FNU2_psvfo4zx1A-1
X-Mimecast-MFC-AGG-ID: vFh-0a0FNU2_psvfo4zx1A_1785829676
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-472c330e555so2183438f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 00:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785829676; x=1786434476; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S2JCvWdBkPduFfWzd+eDY+HHzmDvS+I5il57IMK4KfU=;
        b=ZDDiLalw8pJRqK2iy/r+CRdCpJ5MA9jaP3wMkhC9nBl8PzuvALjg3ARlZ0IKaMJZtv
         Avy6MYCHMZqNI6iBQZigwdEGe1MJFmBnPLvDgiosGYslfyauB+8xIkttPWQFBAxNfXju
         fe7hb+oF55xmRLOVa76FBhxxhbJIxl0iZ6+9jg8YQrmUfHwrQFpjrwGAfNsmWgci2Zno
         qabSJbUMzIHkxfZfDOsPydBmPC2my5fgvmeHfZl9j6b+hyQG+SES/T+AcF4txQXMAG/Z
         i80riJm8hMFvM8pp2J+/hQlCZW6T1OSRd8+p1X6UIrQH2mZ8YEgFDXHSN3QGnMvtB2cA
         uBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785829676; x=1786434476;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S2JCvWdBkPduFfWzd+eDY+HHzmDvS+I5il57IMK4KfU=;
        b=PWGcSGhJCXITw7B/JySnRI691PZOxW9Da1jijc99NMJ5oA3FzvdTMNQgRou7wDk3ln
         zeX86IuWUAVEzyAMUT+CGeVlJq+dNzS9IT2NCIOaA3o4GquchEd7PHKJlFBDkYcz/blr
         aBmcX2kWQgtWY/M+ibI6rCipW1gooni0DMBx4BNoDwGl23mHMYb0VeAtkHxNHc6avHR6
         0hxMG+CTqqzc0usStF/LjAHTUV9QY+EYOpRTSFgIPhl9WscDzV8b+t2DK2dbUqeTT3zQ
         rfUyS3uXmigZAc/D0F0y9NyABCugRd4/Ik85KlI+LCUSC2txbJWXlN2C4jsW9xNjN39I
         HRfg==
X-Gm-Message-State: AOJu0YwNumLwPkV7sfpSRT6J01RtGMN22e6snmlUd6J0BCkburiPypME
	zasdS83yMXaZic8fP+BHhK3ckq8lVqXZGvvMMdMGXz1dm93E7bjQ2X/ijsryvQRxr2o+HsrC50y
	RBinkbDY/8yX4yaB9VpRjludXhC7uGEd1oK2Vs8+gmauVy4ZFNycc63+RNIPVOM+L0vx5OXgAYA
	==
X-Gm-Gg: AR+sD13hkge/Dl+LIfodj1eh9NxMl0IqHdEwEd+M/rGJiWN7Xczu9VM4hX53ZL4dPUE
	Rv+wmOvE8P5msDuRQxyDG4q1vuLBTEzoweD1X1WjbKqqEvvn/1ZKsiIpbCSCTnSr4vnkPwzNplr
	TQ6hla1DW7/rkBPKPxkjjguxQefbsVNiqsJYBoDiDwZqqgvDffFHjcwLwvXoTQB79BrBYw+6FOM
	7RvMFiHTyiqJkMxUbElqmt6T7e+PMJPcczc1Nrvw1FljPtO3YY7wiVWAc6LP8VJyk4whunaUgmV
	cI/mFP+IpvicJtTjPFwJDc/QGUPTrtVu0DA0eucq/rfd+2yTpDBntGgvy1MiMG2Pgw7fOIRL
X-Received: by 2002:a05:6000:2208:b0:47f:d072:87d8 with SMTP id ffacd0b85a97d-47fd7257d77mr35665454f8f.0.1785829676112;
        Tue, 04 Aug 2026 00:47:56 -0700 (PDT)
X-Received: by 2002:a05:6000:2208:b0:47f:d072:87d8 with SMTP id ffacd0b85a97d-47fd7257d77mr35665375f8f.0.1785829675678;
        Tue, 04 Aug 2026 00:47:55 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41e2abbsm41552388f8f.9.2026.08.04.00.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 00:47:55 -0700 (PDT)
Message-ID: <b4d28139-941d-4b36-808d-5c41d370a237@redhat.com>
Date: Tue, 4 Aug 2026 09:47:53 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: eip93 - use struct_size() and flexible array for
 ring allocation
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 open list <linux-kernel@vger.kernel.org>
References: <20260803224028.87631-1-rosenp@gmail.com>
 <8e0dc8db-bfb7-40f4-b6f8-fc773e8b74f1@redhat.com>
 <CAKxU2N9=qABcpCoQSJ+LeLu0nZj-XBdhetoecwsfRGky+Vgc9w@mail.gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CAKxU2N9=qABcpCoQSJ+LeLu0nZj-XBdhetoecwsfRGky+Vgc9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 04/08/2026 09.18, Rosen Penev wrote:
> On Tue, Aug 4, 2026 at 12:11 AM Thomas Huth <thuth@redhat.com> wrote:
>>
>> On 04/08/2026 00.40, Rosen Penev wrote:
>>> Embed the single ring as a flexible array member in eip93_device
>>> instead of allocating it separately. This simplifies the probe path
>>> and uses struct_size() for a single allocation.
>>>
>>> Assisted-by: opencode:big-pickle
>>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
>>> ---
>>>    .../crypto/inside-secure/eip93/eip93-main.c   |  6 +----
>>>    .../crypto/inside-secure/eip93/eip93-main.h   | 22 +++++++++----------
>>>    2 files changed, 12 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
>>> index 1a8dabc4ada4..e62785952b0d 100644
>>> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
>>> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
>>> @@ -415,7 +415,7 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>>>        u32 ver, algo_flags;
>>>        int ret;
>>>
>>> -     eip93 = devm_kzalloc(dev, sizeof(*eip93), GFP_KERNEL);
>>> +     eip93 = devm_kzalloc(dev, struct_size(eip93, ring, 1), GFP_KERNEL);
>>>        if (!eip93)
>>>                return -ENOMEM;
>>>
>>> @@ -436,10 +436,6 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>>>        if (ret)
>>>                return ret;
>>>
>>> -     eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring), GFP_KERNEL);
>>> -     if (!eip93->ring)
>>> -             return -ENOMEM;
>>> -
>>>        ret = eip93_desc_init(eip93);
>>>        if (ret)
>>>                return ret;
>>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/crypto/inside-secure/eip93/eip93-main.h
>>> index 990c2401b7ce..5f0f51081743 100644
>>> --- a/drivers/crypto/inside-secure/eip93/eip93-main.h
>>> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
>>> @@ -92,17 +92,6 @@
>>>                                                    EIP93_HASH_SHA224 | \
>>>                                                    EIP93_HASH_SHA256))
>>>
>>> -/**
>>> - * struct eip93_device - crypto engine device structure
>>> - */
>>> -struct eip93_device {
>>> -     void __iomem            *base;
>>> -     struct device           *dev;
>>> -     struct clk              *clk;
>>> -     int                     irq;
>>> -     struct eip93_ring               *ring;
>>> -};
>>> -
>>>    struct eip93_desc_ring {
>>>        void                    *base;
>>>        void                    *base_end;
>>> @@ -131,6 +120,17 @@ struct eip93_ring {
>>>        struct idr                      crypto_async_idr;
>>>    };
>>>
>>> +/**
>>> + * struct eip93_device - crypto engine device structure
>>> + */
>>> +struct eip93_device {
>>> +     void __iomem            *base;
>>> +     struct device           *dev;
>>> +     struct clk              *clk;
>>> +     int                     irq;
>>> +     struct eip93_ring       ring[];
>>> +};
>> This looks weird, too. If there is always only one "ring", why don't you
>> embed it without the "[]" into the struct eip93_device directly?
> keeps all callers the same. -> vs .
So it's basically keeping the patch small and generating many WTFs for 
future reviewers of the code vs. having a bigger patch now and better 
understable code in the future. Not my decision (it's up to the 
maintainers), but FWIW I'd rather go with option 2.

Anyway, if you want to keep it short, wouldn't it also be possible to 
declare it as ring[1] instead and then keep the sizeof() instead of the 
struct_size() ?

  Thomas

