Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794581121;
	b=3wafTLjVas0MuwJRtHvnsnaZrDM/lRcWjd8d7VB3rP3YBmEuXsgkHhvIMiIB+kg0uSGz
	 EaRk/exQZTV0bJn2GrVYkZoATyOZpvrrDsGoVokeo4bQM78UTRJrDRSb5NBvVFtCr1Ltg
	 ngMkoB5uj5MRD+PRPCU8GxjaHp0eggSfexnymBV0B5XhnIx15Wtul+IeO7b05k1c3mNom
	 ebJO60JXJAhsQDlUKjWCXAsQ/2DLUkAUX9iP8TF7LnvT2y+lm/ktwNfptXD2a7rmDzhZT
	 0pBQlKVprjU76+R6gfhzdmmS9JrbxTr7qiU20iEikJk+207lXk7rHcAFhRQg7hwuI/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794581121;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=d5B2zEeilJgntlVgXF/glstsFLQo0sZSqhK2VGBr1DA=;
	b=f4DpMIy91kU2EnrMh+JRQDmBpx4d2Kljs6ewSorgeRjnaH7wFsE50OKNyMHMG6xnQa/B
	 QKk8knCFrltbT8d9VX7z2yMdthnz2FBRcO18JKOkRfD6tD3Gd1NtnC/eGBFwoY1QR7BQl
	 hjBBMrgsAjGqO8YEM69jKjBYyBYCy5TNW8Az6mhEx/FdkmMPaANtB/izOK/5Tis7eh7Wv
	 JFzh3gUA7NgY95aC2axpT++OcO8XnuGspctu6z6MVQHU1fJkSx6uZZk2PvkhbJ40v138b
	 fGtgKk6WCumsdsEaotu4hbry28XOgDxPwYZDCSRYY9w9wgI5DHRtCe73qFCzneaA5uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LyiXPU3K;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YSCrjUmU;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E64A606A327
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 14:45:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E64A606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LyiXPU3K;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YSCrjUmU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794581119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d5B2zEeilJgntlVgXF/glstsFLQo0sZSqhK2VGBr1DA=;
	b=LyiXPU3KU4RxXuE1h1dzY7AuEg5He3eFhiLiVXUeCR1krZLQ1UKByUcWGcNjFbJ0Fax9XM
	PwDWSleVSv9o1oCPNdcL8lhzUi0+g/PrOLEzzfgMuElzhkV/ZWviiFJ4ySq0Id/2b58Cmp
	m5qlXY76k+BNzv0Fh+5rXzpcW5JBep0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-nsMBfZXsPHu7H835KFArUQ-1; Fri, 13 Nov 2026 09:45:16 -0500
X-MC-Unique: nsMBfZXsPHu7H835KFArUQ-1
X-Mimecast-MFC-AGG-ID: nsMBfZXsPHu7H835KFArUQ_1794581116
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4ba078f26f4so6381745e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 06:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794581115; x=1795185915; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d5B2zEeilJgntlVgXF/glstsFLQo0sZSqhK2VGBr1DA=;
        b=YSCrjUmUJkDNIvcfSJII77J7zw0Z3iRG0ld0D9F45GNFRj0a8KFus97fNc87rBdygU
         esJORXsOuifzHsK4Nd0PBlyySeDok3af19aqx0QYccVdL6/rZmc8BWJ6dcbl1uuPs60g
         eIKCuvnfPo9GtRTj/tbcqfL3rQ05Zrfxdop0RzpTrDjmA0xb5ntQBJfiN45OcWLxQvkM
         gpCtnk1F+4gge/C4yKspSCI03MCFI5UR8eJZxPJRhdUxV9jymKLJ+jmtC+ru+dA21I5d
         vdgxrg0LZqusSXGWf2Muh9XirFHakby3CaXS8mam8xPfCq2GhtdVnrWCq+SxBJDSyTJB
         pndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794581115; x=1795185915;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d5B2zEeilJgntlVgXF/glstsFLQo0sZSqhK2VGBr1DA=;
        b=PC95aVS31aTW/p3syze0wu2om0Qj/abIIMF2vLSqi+PX8t/n43AlTBKoccgTQxChTF
         15HvInbeulYQHlFQYLgkdcCb7pdDXGS9dhQ7ine+UWaeiXmdPPjlXCi52mTmTqctPtEQ
         CBebUbF34unKQ4Qyn8nqegfNcn1DkGijzS3A1nPHu8+SmML1/XBs6EXRxLKEP4V5PUPA
         DZvoHGuUB8sWOKvDw23G4TkKcommxkDYZANQqnGFX9uBoAG7pvciQTqpt5KZUDn2iPUN
         vCl1VwcfwT4qDEbRPksDQeKyu5sBn532xYGSWDtgJ0mzF24QYqFNp3CpReY5IPW+ptCg
         JAAw==
X-Forwarded-Encrypted: i=1; AL+hErGZcRXQHZ3wpOwFNffS2iwUqMPZbtvdj+J1L/5nCSZCiLTSCILdY1Sq5McRnmTptIfUByk+D9JwJbUEvxQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9MKPWYjVkz5YDnXE1RRsJd948C0NACBEIHmWRCktxJDoF7lRwU
	Hk+0UhNInG9Mi6gtSiehi5UV9gswfhTmfFyag8x2/3mSQYYDb1E0vsVO8IwqP0TbOz0uFFfYcHU
	2A1iITWukzDg2zUDfPXWO/w03OGwh/09eWEb0eFN0AXbg+GLzBFU4i+/7Gqzkj4KrhA==
X-Gm-Gg: AYBFou1ixXAROc7yVcicO5XS8i37Vr16QQW/axpTKLtRbdqLuNq65xekIhfIqV+F3p5
	CmLDj3hl4lmzlrPvhYjNs4DwUmdw0udUUNU1UETayQx+wqDIPwrSkZ67j0AjGT05+9uPajnIsSu
	SMVXrNL8icoiw+VRWmVjwnwPMt9dfyE3tMvPYxZ73QLdrVSqReRvAB7o8SQZEvxCXs1+ffRHrAC
	y56n+b0E6+xho94PY0PaQHfboZpYREy2fPu+vdxIX3S1OBaEvcHIdVbJXYBcFx4l5diiv5CI4lN
	i/VnuAmUQOPmZhDilwhi/RZrJYS5ZgJ/Np4NhLFMW+lwmPTHm1RAku8Xo53X/SexgH5oEbBuczv
	R6YsnU6wAH9vLxFNBzlJc3AyKyhcvjoq0X4uRAw+b7YDV
X-Received: by 2002:a05:600c:628c:b0:4bb:5345:606b with SMTP id 5b1f17b1804b1-4bb55a7f885mr53671385e9.31.1794581115604;
        Fri, 13 Nov 2026 06:45:15 -0800 (PST)
X-Received: by 2002:a05:600c:628c:b0:4bb:5345:606b with SMTP id 5b1f17b1804b1-4bb55a7f885mr53670855e9.31.1794581115212;
        Fri, 13 Nov 2026 06:45:15 -0800 (PST)
Received: from [192.168.0.9] ([47.64.115.75])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8d66esm5005578f8f.57.2026.11.13.06.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 06:45:14 -0800 (PST)
Message-ID: <ff20eb2c-4bfe-4960-a642-c9e366a3524e@redhat.com>
Date: Fri, 13 Nov 2026 15:45:11 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qat - clear fw_loader pointer on adf_ae_init()
 failure
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 qat-linux@intel.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20261103100126.534424-1-ahsan.atta@intel.com>
 <545910af-9ff4-4fcc-92bb-43a56f88753e@redhat.com>
 <avchnYuwouXKyRgS@soc-PF5467PW.clients.intel.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <avchnYuwouXKyRgS@soc-PF5467PW.clients.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 13.11.26 um 15:41 schrieb Ahsan Atta:
> On Fri, Nov 13, 2026 at 12:20:47PM +0100, Thomas Huth wrote:
>> Am 03.11.26 um 11:01 schrieb Ahsan Atta:
>>> adf_ae_init() stores the newly allocated loader data in
>>> accel_dev->fw_loader before calling qat_hal_init(), as the latter
>>> publishes the HAL handle through that pointer. If either
>>> qat_hal_init() or adf_ae_reset() fails, the error paths free the
>>> allocation but leave accel_dev->fw_loader pointing at freed memory,
>>> so the device is left holding a dangling pointer.
>>>
>>> No code path dereferences that stale pointer today. This is therefore
>>> a robustness improvement with no observable failure behind it, hence
>>> no Fixes tag.
>>>
>>> Clear accel_dev->fw_loader when the allocation is released, and fold
>>> the duplicated error handling into a cascading goto chain. Report the
>>> error returned by the callee rather than a generic -EFAULT;
>>> adf_dev_init() still maps any failure to -EFAULT, so this is a
>>> readability improvement and not a functional change.
>>
>> The -EFAULT in adf_dev_init() should likely also go away: EFAULT means "Bad
>> address", i.e. a page could not be accessed. Thus it's likely the wrong
>> error code for most cases there.>
> 
> Hi Thomas,
> With this patch adf_dev_init() would still return -EFAULT when
> adf_ae_init() fails.
> 
>          if (adf_ae_init(accel_dev)) {
>                  dev_err(&GET_DEV(accel_dev),
>                          "Failed to initialise Acceleration Engine\n");
>                  return -EFAULT;
>          }
> Let me know if you would like me to add your reviewed by tag.
Yes, sorry, I didn't meant that you should change this patch here, my 
comment was rather meant as a suggestion for another future patch.

  Thomas

