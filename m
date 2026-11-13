Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794560612;
	b=kYdqbQsghlb/7FsGGYze8selPBWvW1bNmTAK0SzEhQ+PlnRuBs/09GEmoPnNjunSrrju
	 /aR6zUkJYNxOwA6F7Cuwozgt0eFp16NIU464nKncbPr8cLwy5nXBJg5AYO41h82J9LnfY
	 WDun/2fTFx0uXb7vaUwofdSZ477CENzS1o/ZJDX3jMwgejI0nPSYShLEsOrfzTIZnHPsK
	 e3J40D/q51zqfbKad2+uQGdZbTRN2qad78cDgUw7/FeVdlYb/RTeB3UXz2awU76XzhDEB
	 kP9maiY765U8kj/typfLH7kOzKdDdyANROSgAM0rS1X7fXzAxapveDXsYnS3oanlgdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794560612;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=IN2mFPnuQd6vKEXAVZ/AVu2voATkxJGZ8A+IFo/BFG4=;
	b=xBx5ZnQUfDkHP6zuUQOcSIMDgAWex/xABrnGBOKhip0fOQXQVx+HluZtQdrYi5S3yNEu
	 UxTuLk4i9ck2PLzBEvq5jOLo6P7xo/z1yCzgdlh/WS4n0bdmhJLsYdjLUvkvbiZtsp1cC
	 QH20m7B1HWWw2VTu/ubL/Gxlo0y0vT4c/ZfGwCJPj1zgy2Y8PmRD5Vvc1vU9Uwsnpt2H8
	 K7FxKkNtcABwOCTWQy860DnfAWwl6fj3EtNugcYCKHlUxOK3RCg2bgxQq4HI1lcGa2HTo
	 MyMzd8sHP7QRutMBybRm7vUKC7uWCAtrAN0/x7EFgeNwafRW5UOKeOLCpLXed3JD9RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=R3qleP5m;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AqAoMcXJ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A920606A887
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 09:03:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A920606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=R3qleP5m;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AqAoMcXJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794560610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IN2mFPnuQd6vKEXAVZ/AVu2voATkxJGZ8A+IFo/BFG4=;
	b=R3qleP5mlHEAfwDekOCyIL7wlJP1rta1HLNUEx7HKOJqhEhAwSVXNkIc8SB8oZg1DR0Y/p
	AbvsS1WxaMH1iR6n8zjhzL1lw+Oqr0GqzofLfYzSTA9LrXwYExhAVgyQe8x0UedyYYcCmH
	Ks+2AhfDodDzmqtsycQcT9fvzBltV6g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-4fifVpo0OJqlfwHL3Cx8Qg-1; Fri, 13 Nov 2026 04:03:28 -0500
X-MC-Unique: 4fifVpo0OJqlfwHL3Cx8Qg-1
X-Mimecast-MFC-AGG-ID: 4fifVpo0OJqlfwHL3Cx8Qg_1794560607
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4ba01393800so3871695e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 01:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794560607; x=1795165407; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IN2mFPnuQd6vKEXAVZ/AVu2voATkxJGZ8A+IFo/BFG4=;
        b=AqAoMcXJUmYEp8YvflJ7em/KCb/H8A0DT8scl8tfwFwtv/ton5gqZ8WPzAaktyYkP4
         scUfCN6QgTCkl3813slNliKnPQv78G7b+yAV34BGTig5YRGr4gD/qmWFVzix9JowAJOW
         JHrCfzeVz1fFJVzTIcnrEEE+ZXmpDSCLfJNulVghit0drDRxb06oFjJg0EF9i11pgl0T
         haa0jk1ab6h2HmFTOwzQxjpekrMFJt7ISXf6T0Uu2P2lP5rPAQkvD7ZCdwANMEhoEQ6o
         FjnAicBcR0Wz+04TKp+RZzZ2Xi9S1XkJg+A76k99jyqCVCusdeBNMOLbSSqjzem6hXT3
         ER0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794560607; x=1795165407;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IN2mFPnuQd6vKEXAVZ/AVu2voATkxJGZ8A+IFo/BFG4=;
        b=GWkLCe3GKAiHl1HhG6IkFdCk9l5Ojwz37khpZeeyRLFunauNzPvD/u5xmhyRVpR/IX
         aftSvA7d2K1QCXoN9FnT03BJ8NXdkcSbv1tduC3Z5Wd8UQrMbY1E7N2Tlu2nHw2Zloph
         KgwlsEC3IfH9HavLjUxzD1BiJPgreG/AtmabhzN7AkIqvJPIk5notSta8bZvcoN+pEpg
         WlTQofo8o2bfi8UBCgFqaux5UDIBAhTTOY4sSYGAANC4oFd8yVrAr+yfXVAAHsyKOevP
         vAyWIxW3miAT0ZLzozKvQgMzlJqqyYDCc1m3k1U/31vETXS7hD/QWRlU6ldX9mWF9uE1
         XP+A==
X-Forwarded-Encrypted: i=1; AL+hErGGg6N7vahNqVf2CRt2Ngd2uIEVFjZfYIM+MKpHb26OlM1aE1+gYCkcbb3SFe8B3de8ozi3cU064J1Z2xk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+NNeGrvwxjZ03nUV5J9NSX7cfTFpykwsIsEB1atkUu1W/7WfYQ
	o/4q+cBiG7LgDv7wH9CGUVq5vdI0/5HcK9fHLRTHRiGZH3zOMVNDPiTwqZLWw3Y7cmHrX8CjCIW
	mTlRGw3b0wnp9/wYu30FLUcJFeur2jC6wPKgeWB9RMMDwMbZ1rH5ABInzOhlesyrpRA==
X-Gm-Gg: AYBFou00+Dv5tUr/hLz56bNh6TTwAaD/NL7vNblCGw5RPsVv9Zy8itj8/MWeRRv9p32
	LA9g3aG4J/bp0JmzKDjIXUh8dEdGSy9HWGDFod9X6SjmQFkRs9Ueh3I26XdIkSX2Lh725YZL8/J
	R0JWWI8Vkv4FEdLJFUyDZgwfNwMwKqUPLy4rAK2aNjUWFX/xsPQdIo8gYvbxqube2U1uF0I/rEb
	YiEvdeFQ08yFgkHZV4falMtdFBrjrI3JYm9UJnahDZDwlqjnS1bNK8dHaQpUbylqcFdQxoYSU2v
	FSdKOK3R56QOBxjuWb5g3/L5MWjcuSBfX1rXxwx0prO3JTP5ENIji3s3SFL90I9fqipjJY3mZJv
	LECmdhs+TEYpiqAB1nox7bDNayDhgDrT8FlGuUlGcqIF+MQ==
X-Received: by 2002:a05:600c:1f90:b0:4a1:7d9b:d4ae with SMTP id 5b1f17b1804b1-4bb55a45050mr35631385e9.5.1794560606923;
        Fri, 13 Nov 2026 01:03:26 -0800 (PST)
X-Received: by 2002:a05:600c:1f90:b0:4a1:7d9b:d4ae with SMTP id 5b1f17b1804b1-4bb55a45050mr35631095e9.5.1794560606485;
        Fri, 13 Nov 2026 01:03:26 -0800 (PST)
Received: from [192.168.0.9] ([47.64.115.75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb566220edsm61931075e9.0.2026.11.13.01.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 01:03:25 -0800 (PST)
Message-ID: <d8e52741-8275-47bd-997c-7b5339a1d213@redhat.com>
Date: Fri, 13 Nov 2026 10:03:24 +0100
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
Subject: Re: [PATCH 1/4] lib/crc: Don't include <linux/types.h> in NEON
 intrinsics code
To: Ard Biesheuvel <ardb+git@google.com>, linux-kbuild@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Eric Biggers <ebiggers@kernel.org>, Nathan Chancellor <nathan@kernel.org>
References: <20261029135020.272082-6-ardb+git@google.com>
 <20261029135020.272082-7-ardb+git@google.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20261029135020.272082-7-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 29.10.26 um 14:50 schrieb Ard Biesheuvel:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The kernel's definitions of uint64_t and int64_t in <linux/types.h> are based
> on [unsigned] long long, whereas the ones provided by <stdint.h>, which is
> included by <arm_neon.h>, are based on [unsigned] long on arm64. On 32-bit ARM,
> a similar mismatch exists for intptr_t.
> 
> Including both into the same compilation unit currently only works because
> asm/neon-intrinsics.h overrides the predefined macros that the compiler's
> freestanding <stdint.h> uses to define these types. In order to be able to get
> rid of those overrides, stop including <linux/types.h> into the CRC64 NEON
> intrinsics code.
> 
> Instead, use <stddef.h> for the definition of size_t, and rely on
> <asm/neon-intrinsics.h> to provide the u8 and u64 types used in the prototype
> of crc64_nvme_neon(), which is shared with code that does include
> <linux/types.h>. Use uint64_t for the arrays of constants that are passed to
> vld1q_u64(), so that they match its prototype regardless of how uint64_t is
> defined.
> 
> No change in generated code.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>   lib/crc/crc64-neon.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
> index 4753fb94a4be..1267df1310be 100644
> --- a/lib/crc/crc64-neon.c
> +++ b/lib/crc/crc64-neon.c
> @@ -3,7 +3,7 @@
>    * Accelerated CRC64 (NVMe) using ARM NEON C intrinsics
>    */
>   
> -#include <linux/types.h>
> +#include <stddef.h>
>   #include <asm/neon-intrinsics.h>
>   
>   #include "crc64-neon.h"
> @@ -11,11 +11,11 @@
>   u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
>   
>   /* x^191 mod G, x^127 mod G */
> -static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
> -					0x21e9761e252621acULL };
> +static const uint64_t fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
> +					     0x21e9761e252621acULL };
>   /* floor(x^127 / G), (G - x^64) / x */
> -static const u64 bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
> -				    0x34d926535897936aULL };
> +static const uint64_t bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
> +					 0x34d926535897936aULL };
>   
>   u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
>   {

Reviewed-by: Thomas Huth <thuth@redhat.com>

