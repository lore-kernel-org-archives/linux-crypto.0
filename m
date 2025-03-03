Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B46C4A3C;
	Mon,  3 Mar 2025 06:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740984806; cv=none; b=ChuzWTcjG6OTN3Lj74YP+8Q3mxdyIIO0/b6+a6rVNTJWMotdaPKUQbqM3tD7JwjUVLDU3kpMs2drWVJgQTkM7L2samX4Wtf7kO9xDnqL+VUABxccXitDPD3BnGmM1lZIrZzZi+hB7G0Xxbk0kjAqHy1nBW6BzKEuOmHbBhsVtQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740984806; c=relaxed/simple;
	bh=EL7sb6RQjjKnZ9p0+ByLm7jviQvd8dJxPXeQMAaME2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyfxc/ImA5MihALK7JoX2ABChyUaXh1CcbtYABvyuGcCP5PcYwyhrO+s9NBj7GGtNYOUGwWlXVYBiJRnztW590vd4xTXvd7nsOMLjgwYNDx8QR4UC7O4NGpFMt7reiUhY26OrTLKqISfs55iFjoJgkVFRO3hpbdFv38r36467kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BX1pFVne; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BX1pFVne"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2235c5818a3so35764945ad.1;
        Sun, 02 Mar 2025 22:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740984804; x=1741589604; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VDfBl/g+euIY5A7idLgNTsyB1EqJtuEAA78H1xpF24=;
        b=BX1pFVne6UTdwp0FT59Y+Qbv2hzr2SgXKIuBL/fDRcAnKOqehtc6VFXe+nFZ7AXjHO
         7sMpw8Emfep2moB7uFiCniQzBKeerTDioqWYRuIoIU08BRHgDGxjV/gb02JFwnGzzdgc
         M2SjnyAAlT6LnXStohPsV780zskmGg0Z1LSsrLE+m4cyb1h83yOnHEsJjErHP+4Af7Ai
         3AOTTofRr2FBf6306ZjwX32ZgFcveAQHFRvChijVmgsVVbMNjl0EoP2R3VtEAYdsa7Zv
         Ax/JOlxtNnoNty5cnasgj8FpMnHUyXWIdi4fNERsoGyK/OfSxyDbg8SRuAwb6sjjTMvn
         VMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740984804; x=1741589604;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0VDfBl/g+euIY5A7idLgNTsyB1EqJtuEAA78H1xpF24=;
        b=orFNqNyRWOeTq2jj8nZ8LvunmzBeYBsjY9k1r8sSm2IF1ZeNJzVErJMYjLxG92g0KS
         x2xjryN13iJ3U+4LCHxBWI2/vodQ5OWSrDSoU8jIaNIBCkR2kIJP9hifyJo3uUPIFi9F
         05tfSyxPhz0qckubjroMDjriWf9jk5R+DcHus2n0tdzYjnU/1khRIG0xob2ONHNoiPKm
         /8IFGmkJnN+4uQE/lt/2SXxTkknNhAhTkCacF0tWMWPGnYq/DqT95D4frueYFSkZsjaJ
         86VD0eCj0rqYroHeO3cPVcpXrreu4T+pbi9BlqoZnmxOAHWjW/+gJAWlnuyFWzuWqOHF
         tpnA==
X-Forwarded-Encrypted: i=1; AJvYcCVaG+/TSc1ARydHyr9O1n9c08btTm/ohQG4Ll8Ak4ssg7uPjFnHiuEQ4eT9vZwsUgxWe/SqRi/pBQiE+c4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGhHIU+td36iEAilkKWLhYDM7ni5ABK3MNcV0Rizl1CiYGo1j4
	rvNIR61668UUGikWg0gUYWq/wz8et/yicVmA98R6JRu92eOBkIVJ
X-Gm-Gg: ASbGncvrScjqHVOJRIu+Xd0OUSPp0tYJDUj42gzChUKx9XyrXc57yBirP5OdXVU/RPi
	3++wXuskUKZYuQSM0/n75wM0w8dRlLf5fczT/R64EovOkCtCV1CDuev/MsvemHy6LCWxzFes4Ys
	W9YXYzZnnhIlHjs/GpvhLQhaX0K8nRixIlPMh5W2/GON8tq8QIsmBYPL84G2SUr47lS4DqTwW+s
	B11ryS0bw4dLKwcnFj3vvxAodl0pItmceCeMSqnewqirEurYwbq8Ep44RIMEXstKHWLmzkKczv1
	R07yTbB6xkJvLQI1O+f0XzunkxevOU+DAkWkpxh/2QW8y+heqfLC6fql9isA0nZkQ2HXcbPVXXB
	rYuvxQnp2BnnUhqTRfZP3ypxA55V+muJf
X-Google-Smtp-Source: AGHT+IHwrJ0Bmez936adXWPCRV+8RVc6i1HjyAM+ze8/4qWNJCAHMwpEooQ5K33kkR0L8GbXxESxDQ==
X-Received: by 2002:a05:6a00:2d1d:b0:736:4536:26cc with SMTP id d2e1a72fcca58-73645362c6fmr7093262b3a.23.1740984804256;
        Sun, 02 Mar 2025 22:53:24 -0800 (PST)
Received: from ?IPV6:2408:8411:5468:b0:ddf2:d4b5:e1cb:9275? ([2408:8411:5468:b0:ddf2:d4b5:e1cb:9275])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736657f9920sm67659b3a.50.2025.03.02.22.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 22:53:23 -0800 (PST)
Message-ID: <076b12ae-91c7-44a1-b616-f4b6d36f4d5d@gmail.com>
Date: Mon, 3 Mar 2025 14:53:17 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] RISC-V CRC optimizations
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
 Ard Biesheuvel <ardb@kernel.org>, Xiao Wang <xiao.w.wang@intel.com>,
 Charlie Jenkins <charlie@rivosinc.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>
References: <20250216225530.306980-1-ebiggers@kernel.org>
 <20250224180614.GA11336@google.com>
 <87ikorl0r5.fsf@all.your.base.are.belong.to.us>
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
In-Reply-To: <87ikorl0r5.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/3/3 2:56, Björn Töpel wrote:

> Eric!
>
> Eric Biggers <ebiggers@kernel.org> writes:
>
>> On Sun, Feb 16, 2025 at 02:55:26PM -0800, Eric Biggers wrote:
>>> This patchset is a replacement for
>>> "[PATCH v4] riscv: Optimize crct10dif with Zbc extension"
>>> (https://lore.kernel.org/r/20250211071101.181652-1-zhihang.shao.iscas@gmail.com/).
>>> It adopts the approach that I'm taking for x86 where code is shared
>>> among CRC variants.  It replaces the existing Zbc optimized CRC32
>>> functions, then adds Zbc optimized CRC-T10DIF and CRC64 functions.
>>>
>>> This new code should be significantly faster than the current Zbc
>>> optimized CRC32 code and the previously proposed CRC-T10DIF code.  It
>>> uses "folding" instead of just Barrett reduction, and it also implements
>>> Barrett reduction more efficiently.
>>>
>>> This applies to crc-next at
>>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next.
>>> It depends on other patches that are queued there for 6.15, so I plan to
>>> take it through there if there are no objections.
>>>
>>> Tested with crc_kunit in QEMU (set CONFIG_CRC_KUNIT_TEST=y and
>>> CONFIG_CRC_BENCHMARK=y), both 32-bit and 64-bit.  I don't have real Zbc
>>> capable hardware to benchmark this on, but the new code should work very
>>> well; similar optimizations work very well on other architectures.
>> Any feedback on this series from the RISC-V side?
> I have not reviewed your series, but I did a testrun the Milk-V Jupiter
> which sports a Spacemit K1 that has Zbc.
>
> I based the run on commit 1973160c90d7 ("Merge tag
> 'gpio-fixes-for-v6.14-rc5' of
> git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux"), plus your
> crc-next branch (commit a0bd462f3a13 ("x86/crc: add ANNOTATE_NOENDBR to
> suppress objtool warnings")) merged:
>
>    | --- base1.txt	2025-03-02 18:31:16.169438876 +0000
>    | +++ eric.txt	2025-03-02 18:35:58.683017223 +0000
>    | @@ -11,7 +11,7 @@
>    |      # crc16_benchmark: len=127: 153 MB/s
>    |      # crc16_benchmark: len=128: 153 MB/s
>    |      # crc16_benchmark: len=200: 153 MB/s
>    | -    # crc16_benchmark: len=256: 153 MB/s
>    | +    # crc16_benchmark: len=256: 154 MB/s
>    |      # crc16_benchmark: len=511: 154 MB/s
>    |      # crc16_benchmark: len=512: 154 MB/s
>    |      # crc16_benchmark: len=1024: 155 MB/s
>    | @@ -20,94 +20,94 @@
>    |      # crc16_benchmark: len=16384: 155 MB/s
>    |      ok 2 crc16_benchmark
>    |      ok 3 crc_t10dif_test
>    | -    # crc_t10dif_benchmark: len=1: 48 MB/s
>    | -    # crc_t10dif_benchmark: len=16: 125 MB/s
>    | -    # crc_t10dif_benchmark: len=64: 136 MB/s
>    | -    # crc_t10dif_benchmark: len=127: 138 MB/s
>    | -    # crc_t10dif_benchmark: len=128: 138 MB/s
>    | -    # crc_t10dif_benchmark: len=200: 138 MB/s
>    | -    # crc_t10dif_benchmark: len=256: 138 MB/s
>    | -    # crc_t10dif_benchmark: len=511: 139 MB/s
>    | -    # crc_t10dif_benchmark: len=512: 139 MB/s
>    | -    # crc_t10dif_benchmark: len=1024: 139 MB/s
>    | -    # crc_t10dif_benchmark: len=3173: 140 MB/s
>    | -    # crc_t10dif_benchmark: len=4096: 140 MB/s
>    | -    # crc_t10dif_benchmark: len=16384: 140 MB/s
>    | +    # crc_t10dif_benchmark: len=1: 28 MB/s
>    | +    # crc_t10dif_benchmark: len=16: 236 MB/s
>    | +    # crc_t10dif_benchmark: len=64: 450 MB/s
>    | +    # crc_t10dif_benchmark: len=127: 480 MB/s
>    | +    # crc_t10dif_benchmark: len=128: 540 MB/s
>    | +    # crc_t10dif_benchmark: len=200: 559 MB/s
>    | +    # crc_t10dif_benchmark: len=256: 600 MB/s
>    | +    # crc_t10dif_benchmark: len=511: 613 MB/s
>    | +    # crc_t10dif_benchmark: len=512: 635 MB/s
>    | +    # crc_t10dif_benchmark: len=1024: 654 MB/s
>    | +    # crc_t10dif_benchmark: len=3173: 665 MB/s
>    | +    # crc_t10dif_benchmark: len=4096: 669 MB/s
>    | +    # crc_t10dif_benchmark: len=16384: 673 MB/s
>    |      ok 4 crc_t10dif_benchmark
>    |      ok 5 crc32_le_test
>    |      # crc32_le_benchmark: len=1: 31 MB/s
>    | -    # crc32_le_benchmark: len=16: 456 MB/s
>    | -    # crc32_le_benchmark: len=64: 682 MB/s
>    | -    # crc32_le_benchmark: len=127: 620 MB/s
>    | -    # crc32_le_benchmark: len=128: 744 MB/s
>    | -    # crc32_le_benchmark: len=200: 768 MB/s
>    | -    # crc32_le_benchmark: len=256: 777 MB/s
>    | -    # crc32_le_benchmark: len=511: 758 MB/s
>    | -    # crc32_le_benchmark: len=512: 798 MB/s
>    | -    # crc32_le_benchmark: len=1024: 807 MB/s
>    | -    # crc32_le_benchmark: len=3173: 807 MB/s
>    | -    # crc32_le_benchmark: len=4096: 814 MB/s
>    | -    # crc32_le_benchmark: len=16384: 816 MB/s
>    | +    # crc32_le_benchmark: len=16: 439 MB/s
>    | +    # crc32_le_benchmark: len=64: 1209 MB/s
>    | +    # crc32_le_benchmark: len=127: 1067 MB/s
>    | +    # crc32_le_benchmark: len=128: 1616 MB/s
>    | +    # crc32_le_benchmark: len=200: 1739 MB/s
>    | +    # crc32_le_benchmark: len=256: 1951 MB/s
>    | +    # crc32_le_benchmark: len=511: 1855 MB/s
>    | +    # crc32_le_benchmark: len=512: 2174 MB/s
>    | +    # crc32_le_benchmark: len=1024: 2301 MB/s
>    | +    # crc32_le_benchmark: len=3173: 2347 MB/s
>    | +    # crc32_le_benchmark: len=4096: 2407 MB/s
>    | +    # crc32_le_benchmark: len=16384: 2440 MB/s
>    |      ok 6 crc32_le_benchmark
>    |      ok 7 crc32_be_test
>    | -    # crc32_be_benchmark: len=1: 27 MB/s
>    | -    # crc32_be_benchmark: len=16: 258 MB/s
>    | -    # crc32_be_benchmark: len=64: 388 MB/s
>    | -    # crc32_be_benchmark: len=127: 402 MB/s
>    | -    # crc32_be_benchmark: len=128: 424 MB/s
>    | -    # crc32_be_benchmark: len=200: 438 MB/s
>    | -    # crc32_be_benchmark: len=256: 444 MB/s
>    | -    # crc32_be_benchmark: len=511: 449 MB/s
>    | -    # crc32_be_benchmark: len=512: 455 MB/s
>    | -    # crc32_be_benchmark: len=1024: 461 MB/s
>    | -    # crc32_be_benchmark: len=3173: 463 MB/s
>    | -    # crc32_be_benchmark: len=4096: 465 MB/s
>    | -    # crc32_be_benchmark: len=16384: 466 MB/s
>    | +    # crc32_be_benchmark: len=1: 25 MB/s
>    | +    # crc32_be_benchmark: len=16: 251 MB/s
>    | +    # crc32_be_benchmark: len=64: 458 MB/s
>    | +    # crc32_be_benchmark: len=127: 496 MB/s
>    | +    # crc32_be_benchmark: len=128: 547 MB/s
>    | +    # crc32_be_benchmark: len=200: 569 MB/s
>    | +    # crc32_be_benchmark: len=256: 605 MB/s
>    | +    # crc32_be_benchmark: len=511: 621 MB/s
>    | +    # crc32_be_benchmark: len=512: 637 MB/s
>    | +    # crc32_be_benchmark: len=1024: 657 MB/s
>    | +    # crc32_be_benchmark: len=3173: 668 MB/s
>    | +    # crc32_be_benchmark: len=4096: 671 MB/s
>    | +    # crc32_be_benchmark: len=16384: 674 MB/s
>    |      ok 8 crc32_be_benchmark
>    |      ok 9 crc32c_test
>    |      # crc32c_benchmark: len=1: 31 MB/s
>    | -    # crc32c_benchmark: len=16: 457 MB/s
>    | -    # crc32c_benchmark: len=64: 682 MB/s
>    | -    # crc32c_benchmark: len=127: 620 MB/s
>    | -    # crc32c_benchmark: len=128: 744 MB/s
>    | -    # crc32c_benchmark: len=200: 769 MB/s
>    | -    # crc32c_benchmark: len=256: 779 MB/s
>    | -    # crc32c_benchmark: len=511: 758 MB/s
>    | -    # crc32c_benchmark: len=512: 797 MB/s
>    | -    # crc32c_benchmark: len=1024: 807 MB/s
>    | -    # crc32c_benchmark: len=3173: 806 MB/s
>    | -    # crc32c_benchmark: len=4096: 813 MB/s
>    | -    # crc32c_benchmark: len=16384: 816 MB/s
>    | +    # crc32c_benchmark: len=16: 446 MB/s
>    | +    # crc32c_benchmark: len=64: 1188 MB/s
>    | +    # crc32c_benchmark: len=127: 1066 MB/s
>    | +    # crc32c_benchmark: len=128: 1600 MB/s
>    | +    # crc32c_benchmark: len=200: 1727 MB/s
>    | +    # crc32c_benchmark: len=256: 1941 MB/s
>    | +    # crc32c_benchmark: len=511: 1854 MB/s
>    | +    # crc32c_benchmark: len=512: 2164 MB/s
>    | +    # crc32c_benchmark: len=1024: 2300 MB/s
>    | +    # crc32c_benchmark: len=3173: 2345 MB/s
>    | +    # crc32c_benchmark: len=4096: 2402 MB/s
>    | +    # crc32c_benchmark: len=16384: 2437 MB/s
>    |      ok 10 crc32c_benchmark
>    |      ok 11 crc64_be_test
>    | -    # crc64_be_benchmark: len=1: 64 MB/s
>    | -    # crc64_be_benchmark: len=16: 144 MB/s
>    | -    # crc64_be_benchmark: len=64: 154 MB/s
>    | -    # crc64_be_benchmark: len=127: 156 MB/s
>    | -    # crc64_be_benchmark: len=128: 156 MB/s
>    | -    # crc64_be_benchmark: len=200: 156 MB/s
>    | -    # crc64_be_benchmark: len=256: 156 MB/s
>    | -    # crc64_be_benchmark: len=511: 157 MB/s
>    | -    # crc64_be_benchmark: len=512: 157 MB/s
>    | -    # crc64_be_benchmark: len=1024: 157 MB/s
>    | -    # crc64_be_benchmark: len=3173: 158 MB/s
>    | -    # crc64_be_benchmark: len=4096: 158 MB/s
>    | -    # crc64_be_benchmark: len=16384: 158 MB/s
>    | +    # crc64_be_benchmark: len=1: 29 MB/s
>    | +    # crc64_be_benchmark: len=16: 264 MB/s
>    | +    # crc64_be_benchmark: len=64: 476 MB/s
>    | +    # crc64_be_benchmark: len=127: 499 MB/s
>    | +    # crc64_be_benchmark: len=128: 558 MB/s
>    | +    # crc64_be_benchmark: len=200: 576 MB/s
>    | +    # crc64_be_benchmark: len=256: 611 MB/s
>    | +    # crc64_be_benchmark: len=511: 621 MB/s
>    | +    # crc64_be_benchmark: len=512: 638 MB/s
>    | +    # crc64_be_benchmark: len=1024: 659 MB/s
>    | +    # crc64_be_benchmark: len=3173: 667 MB/s
>    | +    # crc64_be_benchmark: len=4096: 671 MB/s
>    | +    # crc64_be_benchmark: len=16384: 674 MB/s
>    |      ok 12 crc64_be_benchmark
>    |      ok 13 crc64_nvme_test
>    | -    # crc64_nvme_benchmark: len=1: 64 MB/s
>    | -    # crc64_nvme_benchmark: len=16: 144 MB/s
>    | -    # crc64_nvme_benchmark: len=64: 154 MB/s
>    | -    # crc64_nvme_benchmark: len=127: 156 MB/s
>    | -    # crc64_nvme_benchmark: len=128: 156 MB/s
>    | -    # crc64_nvme_benchmark: len=200: 156 MB/s
>    | -    # crc64_nvme_benchmark: len=256: 156 MB/s
>    | -    # crc64_nvme_benchmark: len=511: 157 MB/s
>    | -    # crc64_nvme_benchmark: len=512: 157 MB/s
>    | -    # crc64_nvme_benchmark: len=1024: 157 MB/s
>    | -    # crc64_nvme_benchmark: len=3173: 158 MB/s
>    | -    # crc64_nvme_benchmark: len=4096: 158 MB/s
>    | -    # crc64_nvme_benchmark: len=16384: 158 MB/s
>    | +    # crc64_nvme_benchmark: len=1: 36 MB/s
>    | +    # crc64_nvme_benchmark: len=16: 479 MB/s
>    | +    # crc64_nvme_benchmark: len=64: 1340 MB/s
>    | +    # crc64_nvme_benchmark: len=127: 1179 MB/s
>    | +    # crc64_nvme_benchmark: len=128: 1766 MB/s
>    | +    # crc64_nvme_benchmark: len=200: 1965 MB/s
>    | +    # crc64_nvme_benchmark: len=256: 2201 MB/s
>    | +    # crc64_nvme_benchmark: len=511: 2087 MB/s
>    | +    # crc64_nvme_benchmark: len=512: 2464 MB/s
>    | +    # crc64_nvme_benchmark: len=1024: 2331 MB/s
>    | +    # crc64_nvme_benchmark: len=3173: 2673 MB/s
>    | +    # crc64_nvme_benchmark: len=4096: 2745 MB/s
>    | +    # crc64_nvme_benchmark: len=16384: 2782 MB/s
>    |      ok 14 crc64_nvme_benchmark
>    |  # crc: pass:14 fail:0 skip:0 total:14
>    |  # Totals: pass:14 fail:0 skip:0 total:14
>
> That's a significant speed up for this popular SoC, and it would be
> great to get this series in for the next merge window! Thank you!
>
> Tested-by: Björn Töpel <bjorn@rivosinc.com>
>
>
> Björn

I am happy to see that crc-t10dif can achieve remarkable performance 
improvements under the optimization of the ZBC extension. It has been a 
great honor for me to contribute to such impactful work.

Zhihang

