Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B56A36A35A
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779659253; cv=none; b=MJqgLTYqZHIj3IB4FJ57kVn2DGk+n2QA4IqQGnN38toZMfLwBQJcDQI2JzVMSMEm9CrEVeOwjL5621IsygYpbi7Yt563hBQmCZPLiWy4/Lt2/f9gRuo8TUtdB3BShldBHrFPjUbkrvxr2nFYbX8xKA3modr/CuypQTXAceAXM7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779659253; c=relaxed/simple;
	bh=Q3TFcvsOR3tC6jHXs9eznJTTcN9oNH9ndWopYpTr/ng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aWDUXve/FRYxr5jFIhx8/QibBrHep7Rrhmmn9zOW92H7/VCKLPcuU5nhA/iG9lM+7bS7PT4Vre68NVLTu8iX4h9v7c3GBPqZeOcqAAh9gyWfrioja7NfYM/zycKixjidRMJ91s+hO5X4+U+QGe4PHHnTn7WltZIjFes5j/VoN68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSysD3Ag; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSysD3Ag"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-83ef1d17904so9125258b3a.1
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 14:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779659251; x=1780264051; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BBNrPCcK/hxdGYqdZZfdYFA88g5If0AtOc7FUUSiNA0=;
        b=gSysD3Agi0uGNC0e+CEftrhOm4SpWXvPNDCOAoetRTrRSUs4exdxItV1xBpbd/Jime
         qO45wOSiceviHdM0qjzFLbYNflnYZEhYb0D+hyS2u2ZFd7IM/9Bt3nhuN/1oWVig/f2j
         77oNLw4k0hbI2C6Du7ubpS9PCgTx+p5SZGYWjW97Ix06xTz32GohlSAaqlY0JDCzpN4Z
         mVTVsbhLdkh1h3jPCKRL41gJvMb3g9cv8GQ5BcZXn0qlvhYH1whrvz9JW07sbQ9R3Ade
         a1jytQ2wtNyFie+CTu9Zb8R0mH2Mdibn1fnmsxXEbDVYsig5DZxPb9Sbu6w8Iw0dl0WN
         C2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779659251; x=1780264051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBNrPCcK/hxdGYqdZZfdYFA88g5If0AtOc7FUUSiNA0=;
        b=GObEkBc/9Db16+whrSd1CiQnugVMhfD7INKKLCLm0eJax7i0FF1u25GkSW5noMI+ug
         mbEQ1vq5QwqLEn4CJiRp3P7ZI5s3w4NeLh7d0vFQ7Vfy84TYNIMD503jqm98UKWOuHH2
         9qIMvqu3kEfAUSbI7kBl6Bt9T7yO+4nBzmK4uSsv0kqjIcDt9e3mONarpGfxfrojhRGt
         agwzGnCdfWlhr3Wxaj8NOVFskC7CYYoEMOFp4HofjEkdG0/RsDvU180ENlxZhYQ3ZUZr
         XRk/hxWd+06TM2UktlbuoGWgXQv1oTSJNSbaYl7qmuZIZr3peQvmiu60iDp8t9lKWbUi
         qpGA==
X-Forwarded-Encrypted: i=1; AFNElJ+GfAy6NK+CzXREaR3FSUbiCJkJK0V0n50k31N7iCEB8+M5nNBOvfIw30BAHQdlgb9WbgmnC5a89Uj5bhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfdlYTKXNIaoiycwz4QxKGqBWaxDtBSjvSHIHv0J8k/yC3h0lV
	sYGuKDZmhiQRkQ1ES4MdABTuXsuQx/ea7g7ZGdUduurli46ScKh/a/Vi
X-Gm-Gg: Acq92OH4RZeMNDW+L/kSUETnXweHKQk4axBa+shSS8zfWeurygCgTgkIx0XBur0as8G
	hokJtR7XTMpUvbN6Rrya8H2oHmMRbmalVz18Kw7kRtVXZtRkK4ReMPD5yssFiNE+4NMAGF0mI/7
	ZJ4AxMlACmBND64TOJaVmAMN2OF19kYJ6gUpKtjS3M4oV7cjZ3gByEvYXQWE8walpGTJNXMpGZq
	TWAyrboTi+REQxN8HLR1PzCAyrECK6pGi9swfqZfh7JCoa5llYPWQUKmgQOkBu00Utp78KCCszu
	A7i+0CCEX4UiPHoExG6a/2q9cMff7vuG7nMpGbDTcXtpYA5Rvq/Ps3N4Klj7+K8KtrnjH5z9PX2
	qJD0ocpdgv0xOcxAHObEjhYXZd36XF0xw7tq8o7nzNTd5FQw0Mj90RJ3xGgcYwBSNUHLtWe8cCS
	1wcMPLB19GFxngfJ+u5VC4PJoQu7/oLGukPA3r/rPLf93E
X-Received: by 2002:a05:6a00:bd0b:b0:83e:b443:9651 with SMTP id d2e1a72fcca58-8415f0f01cdmr11847419b3a.4.1779659251290;
        Sun, 24 May 2026 14:47:31 -0700 (PDT)
Received: from [192.168.89.2] ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ac9b74sm7415368b3a.3.2026.05.24.14.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2026 14:47:30 -0700 (PDT)
Message-ID: <8261b665-9ed0-4d26-81b3-2cdf55257236@gmail.com>
Date: Mon, 25 May 2026 06:47:27 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] crypto: eip93: handle request ID exhaustion
To: Aleksander Jan Bajkowski <olek2@wp.pl>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Richard van Schagen <vschagen@icloud.com>,
 linux-kernel@vger.kernel.org, Benjamin Larsson
 <benjamin.larsson@genexis.eu>, Mieczyslaw Nalewaj <namiltd@yahoo.com>
References: <20260524194528.3666383-1-hurryman2212@gmail.com>
 <20260524194528.3666383-7-hurryman2212@gmail.com>
 <e2242046-f08c-4903-a2ea-f21d3bb241cd@wp.pl>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <e2242046-f08c-4903-a2ea-f21d3bb241cd@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Hi Aleksander,

On 5/25/26 06:30, Aleksander Jan Bajkowski wrote:
> Hi Jihong,
> 
> On 24/05/2026 21:45, Jihong Min wrote:
>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/crypto/inside-secure/eip93/eip93-main.h
>> index 990c2401b7ce..5237b75bba62 100644
>> --- a/drivers/crypto/inside-secure/eip93/eip93-main.h
>> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
>> @@ -13,11 +13,13 @@
>>  #include <crypto/internal/skcipher.h>
>>  #include <linux/bitfield.h>
>>  #include <linux/interrupt.h>
>> +#include <linux/limits.h>
>>  
>>  #define EIP93_RING_BUSY_DELAY		500
>>  
>>  #define EIP93_RING_NUM			512
>>  #define EIP93_RING_BUSY			32
>> +#define EIP93_REQUEST_IDR_LIMIT		(U16_MAX + 1)
> 
> This looks suspicious. You are now overflowing the 16-bit field
> EIP93_PE_USER_ID_CRYPTO_IDR. Did you mean (U16_MAX - 1)? Best regards,
> Aleksander
> 
U16_MAX + 1 is intentional here because it is passed to idr_alloc() as
the exclusive end value, not stored in EIP93_PE_USER_ID_CRYPTO_IDR.

So this allocates IDs 0..U16_MAX inclusive, and the value 0x10000 is
never written to the 16-bit descriptor field.

That said, the name is confusing. I will rename it to something like
EIP93_REQUEST_IDR_END and add a short comment if you prefer.


Sincerely,
Jihong Min
