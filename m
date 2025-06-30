Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3312472A4
	for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751277307; cv=none; b=uWIxIECN50B66u2PMC3Jf9LhMN3n1E21JJjsFC/1hoWPjOJGPZzYq7vXe0ubEwRto4lVgiuaqYI5uWiP5/5lnAbfu059cM9VFdg2bcTcesBYIqNY9XLZNr5fOE9503A/Q2GRk+RdYgTUb4MtCiIOvCTEcfxxaANSVWQ9AN76Qng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751277307; c=relaxed/simple;
	bh=0PuwYRU65+rPcr6EqI4gz5+o/nz3zFEwP+cDO+KX260=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4rj4yudPfmZDK93NJ6acZT6N3v80H0ccPTZY3lzCD8YQD30SJTxajgAVK7865/Plr6DWovzqE61MYIzRi3JuNzHPpWviEsNPSCK421WCfA3Bc3cf0O9PoU5sxw6JK6Jmvrhunp4zqlBfrtQhBUbSAiaaTWGEQ8WDZemofsC3DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=fW5UGTRU; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="fW5UGTRU"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5561ab55c4dso406468e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 02:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1751277303; x=1751882103; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LfQy8ADCiBLlHkAJSuBLrY0Q7GgPSdM7/euzAA8eQg8=;
        b=fW5UGTRU5uQV1ZEuxIU58L492ss3fMhWoD47CG0wQ1MVoHX4uYv4bAVt5luqnMpeH/
         JmohjePacxyH13iFLcHcEJVLz9WkIjxNq47NrbB6ZTLdKPEkbDzU/biFlvuf45amehc2
         1bPD/vk+w8EeIzeWPvs7hQbgw2ahsexnp+8ezuQlk+NNZZaLHvhzyH9yd3KIltG+cGO7
         ynX32N5YkUbjN2YSXDzPc3FYbD8Mtszd3HW3f9rUjb+uOqgkzPCCYkwdnL8JfFEUHRks
         atpVzkf/4NWx8F6MCQcV6N5n1FZxX1uYwDIMrWr14ZBGVln5AkTvUDMCu3fwWeJUf30B
         hsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751277303; x=1751882103;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LfQy8ADCiBLlHkAJSuBLrY0Q7GgPSdM7/euzAA8eQg8=;
        b=I7AU9QJXmNdZHlUZSdlpizR8ZEL67bBlODHAHK/4k/fjXjWmySNH0BP0ha+BFo4tD1
         VLkJ//nuhqgAsHeDwitPuToTOz/wkmBFYdiXxdSlvuhP9463yM3oTjyA/n/lAZB6cSFQ
         ag+Lu8uCoWXuRjY5lA0sJISt4SheN4BnDnE0A7VIHIRZ6J28P9V6xmwQfn7VN8vqVjaG
         0ZCI4wKX2uBYCQnJP61asIBI+MKkxhAKqxuG50XxrfrRLfWXIYKYIHD7Uwtl/84QyCWB
         KsEQ8X4CKvhdcOLK8j4B/ZTkKfOozYMQphV+WHtDiE87sMU8va6jTsZyVW0XWfrB3K6s
         gtew==
X-Forwarded-Encrypted: i=1; AJvYcCUIXvHOXHgFmpXUC9WqMMItjM7o4R6Uk56hxJ2pBSLsEB+TjjprpqnVwAn6OOOmetisMjoFhISX2bdx29g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx27RCU9OPoibhj5+Ds23zOpIARBVx5L80B2CB18n2woHH31P2Y
	d9Funo7PfVASTl7XpZa+0WQgbYYmHVzGvf8p3npf6aEtr3jokeoU+NmiXQyYJB7qTBxHt6e6Nhe
	3EVYn
X-Gm-Gg: ASbGncu0hUCuKutha1101HYoBxn1+JKZh+zBxNlTCfIr2iXLpl2B2qWqdP7lKGUGSOi
	CdvFJtbas9NFNr9t70sSOyExJq11Tlab68n4KKqzMFlKMshC/83jx4NC+Gu4OtEJjRi/icbKgYN
	i2pxc7KoS7o7xGSaqmW7UI07A6Exn9kkVNfnrAeofCi7WjGQz2v9kdzNij577QCDgw0aaXeMKjz
	OrKEJ+/t8/jLWxllynLzzHVUtw9VhA3a+KYdbYqwCKj20LDrJyNsg2CxCfreO40wNnadYrtVZMm
	IZNtwZ2BfGJoAj3/efdq+ha2Jwqz5ZY7TO9ZCum2ghfoZZa0TNZVA/XlUG4i/PJHV5reHzwvwoE
	ElXAMc4LGLKfpdS9Y3v3y+YKjUDwqew==
X-Google-Smtp-Source: AGHT+IGPZA425rUTyu65BDLRuYis8nH5rdwyfHes60yjnoP9ss0FZbb0z/p5yM8y5tYGOxjb92a6GQ==
X-Received: by 2002:a05:6512:3503:b0:553:241a:b93a with SMTP id 2adb3069b0e04-5550b89f457mr4656463e87.31.1751277303047;
        Mon, 30 Jun 2025 02:55:03 -0700 (PDT)
Received: from [10.0.1.129] (c-92-32-242-43.bbcust.telenor.se. [92.32.242.43])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-32cd2deacd9sm12834901fa.11.2025.06.30.02.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 02:55:02 -0700 (PDT)
Message-ID: <f4fc05a3-e6b3-4951-bbb6-370d3e2e68d0@cryptogams.org>
Date: Mon, 30 Jun 2025 11:55:01 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
To: Eric Biggers <ebiggers@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>
Cc: Zhihang Shao <zhihang.shao.iscas@gmail.com>,
 linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 herbert@gondor.apana.org.au, paul.walmsley@sifive.com, alex@ghiti.fr,
 zhang.lyra@gmail.com
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol>
 <48de9a74-58e8-49c2-8d8a-fa9c71bf0092@cryptogams.org>
 <20250625035446.GC8962@sol>
 <CABCJKudbdWThfL71L-ccCpCeVZBW7Yhf3JXo9FvaPboRVaXOyg@mail.gmail.com>
 <fa13aa9c-fd72-4aa3-98bc-becaf68a5469@cryptogams.org>
 <CABCJKucHNWz6J9vvDvKh_Je8eQTJO_1r0f6jsDTsDmfaxdBygg@mail.gmail.com>
 <20250627215151.GA1194754@google.com>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <20250627215151.GA1194754@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>> Would it be sufficient to #include <linux/cfi_types.h>?
>>
>> Yes, but this requires the function to be indirectly called, because
>> with CFI_CLANG the compiler only emits CFI type information for
>> functions that are address-taken in C. If, like Eric suggested, these
>> functions are not currently indirectly called, I would simply leave
>> out the lpad instructions for kernel builds and worry about
>> kernel-mode CFI annotations when they're actually needed:
>>
>> # if defined(__riscv_zicfilp) && !defined(__KERNEL__)
>>          lpad    0
>> # endif
> 
> These functions aren't indirectly called, and I'm intending to keep it that way.

In which case lpad will be executed as nops. Anyway, does 
https://github.com/dot-asm/cryptogams/commit/e6ae2202268d995e78fa5d137dde992bdff1b8e8 
look all right?

Cheers.

