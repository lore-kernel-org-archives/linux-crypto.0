Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBAD2E762C
	for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2026 13:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786021262; cv=none; b=RyaK57NfkMuCHI6z79Q3i0b9dLH0Uo9PUQiDb3pqNz+r0j6UAY1IsmdL05TqJkJkfjhNoRH2ZAl/kmCF8nHChnRyJpgh2YOYljCb0WHiSkzcc7ZV9aVKYXeM3BD5Bh7en+HBW6OM6yJBhpbn8iLh1iy2nCqeGC+0Yf/K5csv06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786021262; c=relaxed/simple;
	bh=q1ZRPUvNDHV7iJdE58mQ/fIbmyHQnQmBFczO9z9Ajog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=apIFzubOso2d5GHTzlvnAPe6thnu/JIm6EuWw0kleg5lTycR0+SIF2QLRq4xpMPskDPd1GxVJZR7PHwKb0Ifzm/0wDIdvcJIEubp4Iy00/mqosSkb9Rw1DsbSJ8LYoojYSmfPZ/4YF0+cHf4kJ9ltDPT70sFDQz0iWVdboUqN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T7ln0GV8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=teenWHTF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T7ln0GV8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="teenWHTF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786021253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yUjFkzRbsyRzHJFFuK6edRfWw7bg7Op3i8nbxFWHmEE=;
	b=T7ln0GV8R3G1tIa1fxmFLeZ+2Cr5SG0wOcs9a12lsRgnzdnYZ5+vCkHw8H3WHS5SSgnv6x
	U6vUzuPbRnKikLDnD40oiHPATseJnx5phoY/GxI76674+3Le7IJ1+69eRlQtv6Rr0ty7Hn
	baVOg2uMaTHm2jXlYa71OAYAGnq4VGY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-JKPS2sqhMvWuZiPJh087aw-1; Thu, 06 Aug 2026 09:00:37 -0400
X-MC-Unique: JKPS2sqhMvWuZiPJh087aw-1
X-Mimecast-MFC-AGG-ID: JKPS2sqhMvWuZiPJh087aw_1786021236
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15fff01a30so161788566b.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Aug 2026 06:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786021236; x=1786626036; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yUjFkzRbsyRzHJFFuK6edRfWw7bg7Op3i8nbxFWHmEE=;
        b=teenWHTFCj4ymK1Fxt1+1ddWMDhfhaNAwDrMzo9R/5snKNnCxPbJUBGGg3NtjTqL65
         NyefOos8TTz1PooC6IfOZsv2CAuRQ441kqMiMYRt8v21wuG9qjzTJL0w0hmTTNWeY0HT
         8NKhWF1nD4HRZxfDDVZIlmd9Gu2Bt0HqqXJz+6z4DySGAy1/oXNepBLouJL87xFl4Kds
         F35ffsVahSzZtKi54YFwecL5qLefjl/ROeQDb1TqinikjivMeWHuOLB3hyt1mseDztAV
         9eAfXRfrBFX4x7I8BNjcne33H/7iqfThpMZKooUwOLW9ja2w7kNcenKtopVUfgETjdtk
         5OCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786021236; x=1786626036;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yUjFkzRbsyRzHJFFuK6edRfWw7bg7Op3i8nbxFWHmEE=;
        b=rjxRjHj4rRYg9lzgZ6OSa72MziZldI7ei0xrmSf9+ZWp4sfe2nnMZnjNJBPjpMqp5S
         MnbPKeijMcpDjW+oNQyLL+wfG5NBX0uk1fG7pJk1lZInrK85g9CZ+8ntJYP41OyZPj6c
         s3DlHlLjKljD86Hm32vqU7gfy3iyrkZsat5x5w2QWTtdG6zGz5BKRAPaWtFwYItICy1X
         6FPOhsJXgbHoDGGDX0aS9I5fjP/UP536Hw7QLIX77OkO0PCjAUj0fJ4mPHpANalACPNb
         40kwxdAuuk8OzZcvN18ZKmpUh+IYjEr/Lcs+f7Wu1imwQDXieOBt4P/v+ekdSLm/HLOl
         rkpA==
X-Forwarded-Encrypted: i=1; AHgh+RoGSvq0T6TgAd0FUZI4VEcNIMNHcTNAVW1PlzkuiElaWc0Fmj56S+DNEKtZ+BXNDb5YcUTpst8xYS9cvdo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq4QIMpXr2OUtFDW+kIgB3hr++BVFmI6K2+xGoSdH1Ww6kjMs0
	o497yA0FWKSbCfebnHWYKFfML6cGzf4Ij8UQN4cconVq/wT/8mNsTU4vCoiPYlhSilTAJLLGFJm
	bCAiXatQqpbCjno1LHejr/boirZCYaX+C8RMozo3FRysxFk2jDzNkHZRVEkwOZjilSg==
X-Gm-Gg: AR+sD11+OECv/O2xGmn4GgU57Xp1fYXCP+5NZheF1g0uM772tupojFIekI3Rn5DRzwP
	+b97UTDjOPJJru0P1k0k9s2bm3ubvaVxA4HAAxSsT2ImuLGeue662EyfUnxHB3lrxvhWIcJ3ZJz
	voSD4cUtorIWarK0+/qcN8vVPFw8w4bzFly/t3CajrDdDY8BNjhMscQXIIXhonULFPEpsJUlWqi
	PZF4DRYGZNhVTH2E3ioONqwu9ry4XdKh7WC6PneYklImr7v87n/rnc507Du29Hv+abvQxdr/MCC
	aZjryJpAgNL75xlAJhtK+4NQ7NS+8nJooR6u0J6qomF6+eK9YPBkJkSWfRPc1ZCeqACzhkIo
X-Received: by 2002:a17:906:9f85:b0:c19:6d4a:425b with SMTP id a640c23a62f3a-c2073364454mr67804166b.18.1786021235729;
        Thu, 06 Aug 2026 06:00:35 -0700 (PDT)
X-Received: by 2002:a17:906:9f85:b0:c19:6d4a:425b with SMTP id a640c23a62f3a-c2073364454mr67797166b.18.1786021235090;
        Thu, 06 Aug 2026 06:00:35 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c203645a3b8sm241386266b.56.2026.08.06.06.00.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 06:00:34 -0700 (PDT)
Message-ID: <e02abf8d-7cfe-4673-8764-9893183b81a1@redhat.com>
Date: Thu, 6 Aug 2026 15:00:32 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] Bluetooth: SMP: clear the aes_cmac_key when done
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
References: <20260805143611.818559-1-thuth@redhat.com>
 <20260805143611.818559-5-thuth@redhat.com> <20260805204613.GG3438@quark>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260805204613.GG3438@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/08/2026 22.46, Eric Biggers wrote:
> On Wed, Aug 05, 2026 at 04:36:07PM +0200, Thomas Huth wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> Clear the local aes_cmac_key structure via __cleanup() function
>> when we're done with it to avoid that sensitive data could leak on
>> the stack.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   net/bluetooth/smp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
>> index 031d3022cb1e5..ed30ca0d773f1 100644
>> --- a/net/bluetooth/smp.c
>> +++ b/net/bluetooth/smp.c
>> @@ -164,7 +164,7 @@ static inline void swap_buf(const u8 *src, u8 *dst, size_t len)
>>   static int smp_aes_cmac(const u8 k[16], const u8 *m, size_t len, u8 mac[16])
>>   {
>>   	uint8_t tmp[16], mac_msb[16], msg_msb[CMAC_MSG_MAX];
>> -	struct aes_cmac_key key;
>> +	struct aes_cmac_key key __cleanup(aes_cmac_zeroize_key);
>>   	int err;
>>   
>>   	if (len > CMAC_MSG_MAX)
> 
> Well, the reason I didn't add a memzero_explicit() here when converting
> the code to use the AES-CMAC library is because this same function
> already puts the raw key on the stack without zeroizing it.
> 
> I guess the __cleanup trick makes zeroizing the struct trivial enough
> that we should just do it anyway.  But it is always a bit awkward to be
> "fixing" something when the same problem is still present.
> 
> Perhaps you'd like to expand this patch a bit to zeroize the other data
> too?  (There is the 'tmp' array in this same function of course, but
> there may be other places that need "fixing" too.)
Sure, I can add a line to clear tmp[] here, too.

And I agree, there are other spots in this file that likely need fixing, 
e.g. smp_e() already clears struct aes_enckey aes, but misses to zeroize its 
tmp[] array, too, that again contains key material, I think?

But I think I'll rather tackle those in a separate patch series, since this 
series here is clearly aimed at aes_cmac_key & aes_cmac_ctx.

  Thomas

