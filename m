Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA072046AD;
	Wed, 12 Feb 2025 08:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739347748; cv=none; b=GOtijlAWL4/t6fK1yNGo+lE9whT/3EbacRiDrNZe8a5sOPoAKEmTT572u6bKoX+Aj6GJPS2gfFQGwAL2VKjDy3viaDcC9ZrotsLDLcw/z96qtLBfd7p0ukdQQOfVSkZ/Q5uM5als0ECqCkpfo5KqQAiXsFLlOIEBsiyDG2mkX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739347748; c=relaxed/simple;
	bh=hzT0JxmA3i2IqVtMi8UfiZA6vOY5R4unXhUpxwoj1is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RGZf3MznxyT154aLAYD1c1CGF0E0ryJeXRvubkru5/SdnELVW8hyK17mOU8ciTul/9/81WdoY4l0cZUKbp6Rxj5aU0V+8F6Wb5p6eGZryAOfVd20EnfNPB8NrEeuZEaKcKinozlDqw93NSQ+R5jxS79qnTXkTvlRNvwba79khPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i01zHflA; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i01zHflA"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2fa2c456816so7442197a91.1;
        Wed, 12 Feb 2025 00:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739347746; x=1739952546; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uzz/ztA8J5OEcraVsYIfYsDCP8O1/+bhCpXSvSiKTAk=;
        b=i01zHflAAfx9VhZO7cgcJv75v+eG2hGXJRyubZCvLpWly+mEvtiaVVBwVz2ZJv09Im
         h4ZZPBV/M2ccJquVUTAEaKQbt761gZyHMQwxxcJeopKgZAVaLL+8msMjeJIfIJm7s74Y
         emDJ3HST1UxRmXQAkTle0y1UAaKAKULkFBQ0FzEBQj/ANyW/4RpHrat6t6NT6vNT60jk
         aSAXDNslC3WcJGjEAcPzkTcYTwhO/R5CaEubHeJkJ5wAr/D5M7gQ4WyPQeejvrFGkXKm
         PV3M1Zng+pKzTulZzS7NLHSOyzmT/aCN3qfC8RWkv1SRt6kvY72+u7db9Umj/YSWAxwv
         j/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739347746; x=1739952546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Uzz/ztA8J5OEcraVsYIfYsDCP8O1/+bhCpXSvSiKTAk=;
        b=Y8/Ld1nuIcMZKVg5YJfyoETGh+DqBFfHzj6XHsT5nvoXc9gXy41s6E1aFlxALpamRT
         t8a2RRnMvO/06hDPEPyJAYkJ96Kexqrlwz25AhiWlbZlQqBbhO85SfuHXnhzABMRYriH
         OECguzoTVP0dJ0zGq/0x6b1WjSGlnLwiAhQw2TxI2avHx/X8VP0CrI/Bot6Npsf9JnXr
         W8P0V5j42YLApI9WZL0/Q9og9O7zoLM08ENo9VwwiYyuy4jYL+UlFE5QIXbfc0hRwM1i
         TVshaAs3JqQwbAw++XsFMG//arqLebDgFDQD5Qors3oy9BL2U3OTpMXFablX2tG9TLXB
         SWTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXd4sc3m2/OyZF4NDNGNTgT5yZjNE8MDSfWL5BNWYIqzGQrR/aVMS6xr1iYUok+Vv+zpPlP/Lyq3XIakus=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVAF1RRf7jaHAWFMLmvEWmjJxisinGGlRXyBTF70ngrHHjhmS2
	nVzTKAUA51OkdrMpUbS1do7S7ep4SP598+tVsJqVyII9XBgIYcVL
X-Gm-Gg: ASbGncs0M8SLl1cevoeif18ZCs1TJbMeUJtv/AC8vJv4i9KLBqRJUmkrKuGv56fwpIw
	Wb7xifXB7nCv1kYLToV119c/X15wMgZz5yMB2Bca0tCo4sFDS2LOjF8P03iRzEhe3bDbygu0WiS
	/20zKo7Kqgf0++jkKc6vFUZKJj/H72LwvbyzrPURfEm9IElDShAuhn8bDCUcCbZD9GuEuROA1V6
	vm0VUHILwkZUuC8VQcj7oOXpOc5PyEVjmK9IL54LoxLlDGuF2KW1a4OBQnioFWoy7t/COefPHJK
	77QGYan3+owfj8LUpwPPPv0Vtez/3vLfZlUZ3IT9Bl9RzA7vXQ==
X-Google-Smtp-Source: AGHT+IG2Bzz9E5EiedwHTMJWTWNMK7lgiuQCvQWlS4nGxBclsahMfq5ltIXb5KcmWhLepPoYJs0soA==
X-Received: by 2002:a17:90a:d64e:b0:2ee:db8a:29f0 with SMTP id 98e67ed59e1d1-2fbf5c603b9mr3426862a91.27.1739347746403;
        Wed, 12 Feb 2025 00:09:06 -0800 (PST)
Received: from [172.16.203.237] ([103.233.162.226])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98cfd03sm871927a91.15.2025.02.12.00.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 00:09:05 -0800 (PST)
Message-ID: <f827cbb0-f6ad-4397-9f30-ca43223c4853@gmail.com>
Date: Wed, 12 Feb 2025 16:08:51 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] riscv: Optimize crct10dif with zbc extension
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, ardb@kernel.org
References: <20250205065815.91132-1-zhihang.shao.iscas@gmail.com>
 <20250205163012.GB1474@sol.localdomain>
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
In-Reply-To: <20250205163012.GB1474@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/6 0:30, Eric Biggers wrote:

> Maybe use 'const __be64 *' and 'const __be32 *' for the pointer, and use
> be64_to_cpu() and be32_to_cpu().  Then the __force cast won't be needed.
Maybe this problem seems dumb, but I have no idea to adapt both riscv32 
and riscv64. I have tried to use 'const __be64 *' and 'const __be32 *' 
pointer in patch v4, but I forgot to test them in riscv32, and it turns 
out the code failed to compile due to my mistake of defining 'const 
__be64 * p_ul' and of course it wouldn't be work for riscv32. Maybe I 
need some inspiration for this problem, or I still think it better to 
use 'unsigned long const *' since it works fine in both riscv64 and riscv32.

Looking forward to your reply and guidance.

Yours,

Zhihang

