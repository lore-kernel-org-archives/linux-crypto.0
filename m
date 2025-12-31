Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5857B224B12
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 04:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767156917; cv=none; b=IuRdfJ0dhiuEa67lA4uXMAhJnuK/RRw255ieYzc4X0SZPRkAIEKnmBte+1VL8BnXYf4sRvuMZ5M6BJ2j764xKAvQBqGDN3FDw0br91X0LPzz1mbb5BVLr5u2k4Gt6jYks9kY9Cn2WFZKJovetnbZUuqUD48lkCRvQ0Qa1qV1n3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767156917; c=relaxed/simple;
	bh=S+9t1lSb0j4Efkz0TwS248JbRQVgxcge3/o+iF0QNqs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Y9e9GnY5mp6EnMxRaKa0kBK7O4Ug33D3T/4QNf9ZfyTWuuABh/FAGnqShaZpMz1usS3zjKSTRmaSk8zvWoAxt5uPzDL+9GHFCgvHgKsBgbIU48LlAYT6nqmEAiRq7yVf85uA7Oneq65dzNcMiBlMT1s27jddyrJYPXE/5SuS6CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AR0Wz5FZ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AR0Wz5FZ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477770019e4so88365635e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 20:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767156913; x=1767761713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=j6JiNX4DyxHQ3Lh71drQeQ4TeiUI1sDQ4EAAd5MGan4=;
        b=AR0Wz5FZt8LTJvKrVga35U0sOBBDtJxbA7BvEGhi7JdEyxdlbe5GU4IwELaQE1TUT4
         eKcCuDvXZ+nvqj+UaLDBHIc6eUyYeb4NSuj7Jkg09E1Dona4ey9LDkQ1lH1fd0EHLpwj
         w6qlSansN3QcuOlkR6j4irffhBoSdpP272V8u6LsgQta6AufdODbteVOPVLXPm85qq3R
         +GTsLMDNtUi/p1vy7rdH+8yhEAavnU2Dtr2F5n9v2SBCiOGUbC73jsPTokpt2+xiYCBa
         PwFIwoDPxd78PTO9elVqW9seE4lB2kjk73zMUoVVUzGoUBLDDpz+43mDN0yCaYae1ylR
         N/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767156913; x=1767761713;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6JiNX4DyxHQ3Lh71drQeQ4TeiUI1sDQ4EAAd5MGan4=;
        b=oUJ4ULrK/1b/bht0s8I+U0vVRn6UPnV8dDDwkSAMQLBQmVfEcbi9pH4cEQEOOHD4jr
         kZWdqi7faMEqmE7iKJ0B/+qXgnOZk450p4vQeV73wd017eDtyy0T2bRcbF5WcrKfcViq
         SWaBQJOb0G+u4bVl0bK3aPPN6P4yhagR4bljuxhgDK+/emyRGNNyBr8NoOxM57FZcDK7
         xoOERQ+M7DtuxkxyfRUIx5XVw6VTWC5XLlsEW3b+WexswPV53hWh3fy/Ve087ezVrxIj
         cihcaYeClX8HcvCslsdLwgG8lQCiO76hCDZ6nRvKupPg+v3qOY0MUwPgaB5HTrQZ19HK
         uM1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVC0nMhrXJh0pW3pyM/71g3uG7dUVB4EFG83vUf63d39V+4tY/3r0hFN1A+yzH3DHOnaARtctL0Vp6bjPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdKQXqiDUC5dYO7RJXgi6iq4ONYqmQHTaMXst3DhTyU1N5NCfk
	v/n+8o8E8Z38vIe3wPodAzlcmdJJW6iXcMg+t7RDksAT1aPU+ui3RltBF+eeJucH/j0=
X-Gm-Gg: AY/fxX7YU58DN8wnVgR8XFk0QppNDw0aONv8UzycqpIE2c3YrYOdEGr1KexYb8Jh7e5
	LEb0ILQyN79hwcCQQHh7CkoxMwR3BABw3qI3QbvsKHZ2xqFHMFff9P24r7I3mw7K0yn8D5O1Mhv
	8aoHVAGap5uV4Ui8D4wkgicEgK1LjWtLh+MkE62aXSQK+SiHbi0YKpBkaMghr3Yi4ZIoIRt/pom
	Hofl6oZAa9q7OiAIRkfpUMlL+K7WDI9iLdrYdL4jUn6OtVVOgf3W6O+gcx9piNujrYLVjNjqmd1
	iPQQWRqgTgYytknFFvI5S9JuAz8+vyLUmK66lc4ptCqz7D/RecqqiIgVEsgjhFDsw12uje7BsYu
	pTwRXltWwiO2alMxdmyXQKvAN2Vzxmhit7zDnyMy62+dNvpv9IEY8AiMSQNPHuSPE98PEaW0FHt
	TnXTJ1huFXR6vqAjS6l7GU+29kTRkRMXv0l5BGs/U=
X-Google-Smtp-Source: AGHT+IHvkn/UqHdAbpO5Z7TPw3D2l2hZ15S6rONa7RsN3x7C+TBBN23FzbojrQHxWPIo9kksZRLHZg==
X-Received: by 2002:a05:600c:620d:b0:479:1b0f:dfff with SMTP id 5b1f17b1804b1-47d19549f5dmr416579065e9.10.1767156913483;
        Tue, 30 Dec 2025 20:55:13 -0800 (PST)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cb25sm319044435ad.56.2025.12.30.20.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 20:55:12 -0800 (PST)
Message-ID: <9d21022d-5051-4165-b8fa-f77ec7e820ab@suse.com>
Date: Wed, 31 Dec 2025 15:25:08 +1030
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Soft tag and inline kasan triggering NULL pointer dereference,
 but not for hard tag and outline mode (was Re: [6.19-rc3] xxhash invalid
 access during BTRFS mount)
From: Qu Wenruo <wqu@suse.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Linux BTRFS <linux-btrfs@vger.kernel.org>, linux-crypto@vger.kernel.org,
 Linux Kernel <linux-kernel@vger.kernel.org>, kasan-dev@googlegroups.com,
 ryabinin.a.a@gmail.com
References: <CAMVG2svM0G-=OZidTONdP6V7AjKiLLLYgwjZZC_fU7_pWa=zXQ@mail.gmail.com>
 <01d84dae-1354-4cd5-97ce-4b64a396316a@suse.com>
 <642a3e9a-f3f1-4673-8e06-d997b342e96b@suse.com>
 <CAMVG2suYnp-D9EX0dHB5daYOLT++v_kvyY8wV-r6g36T6DZhzg@mail.gmail.com>
 <17bf8f85-9a9c-4d7d-add7-cd92313f73f1@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <17bf8f85-9a9c-4d7d-add7-cd92313f73f1@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/12/31 14:35, Qu Wenruo 写道:
> 
> 
> 在 2025/12/31 13:59, Daniel J Blueman 写道:
>> On Tue, 30 Dec 2025 at 17:28, Qu Wenruo <wqu@suse.com> wrote:
>>> 在 2025/12/30 19:26, Qu Wenruo 写道:
>>>> 在 2025/12/30 18:02, Daniel J Blueman 写道:
>>>>> When mounting a BTRFS filesystem on 6.19-rc3 on ARM64 using xxhash
>>>>> checksumming and KASAN, I see invalid access:
>>>>
>>>> Mind to share the page size? As aarch64 has 3 different supported pages
>>>> size (4K, 16K, 64K).
>>>>
>>>> I'll give it a try on that branch. Although on my rc1 based development
>>>> branch it looks OK so far.
>>>
>>> Tried both 4K and 64K page size with KASAN enabled, all on 6.19-rc3 tag,
>>> no reproduce on newly created fs with xxhash.
>>>
>>> My environment is aarch64 VM on Orion O6 board.
>>>
>>> The xxhash implementation is the same xxhash64-generic:
>>>
>>> [   17.035933] BTRFS: device fsid 260364b9-d059-410c-92de-56243c346d6d
>>> devid 1 transid 8 /dev/mapper/test-scratch1 (253:2) scanned by mount 
>>> (629)
>>> [   17.038033] BTRFS info (device dm-2): first mount of filesystem
>>> 260364b9-d059-410c-92de-56243c346d6d
>>> [   17.038645] BTRFS info (device dm-2): using xxhash64
>>> (xxhash64-generic) checksum algorithm
>>> [   17.041303] BTRFS info (device dm-2): checking UUID tree
>>> [   17.041390] BTRFS info (device dm-2): turning on async discard
>>> [   17.041393] BTRFS info (device dm-2): enabling free space tree
>>> [   19.032109] BTRFS info (device dm-2): last unmount of filesystem
>>> 260364b9-d059-410c-92de-56243c346d6d
>>>
>>> So there maybe something else involved, either related to the fs or the
>>> hardware.
>>
>> Thanks for checking Wenruo!
>>
>> With KASAN_GENERIC or KASAN_HW_TAGS, I don't see "kasan:
>> KernelAddressSanitizer initialized", so please ensure you are using
>> KASAN_SW_TAGS, KASAN_OUTLINE and 4KB pages. Full config at
>> https://gist.github.com/dblueman/cb4113f2cf880520081cf3f7c8dae13f
> 
> Thanks a lot for the detailed configs.
> 
> Unfortunately with that KASAN_SW_TAGS and KASAN_INLINE, the kernel can 
> no longer boot, will always crash at boot with the following call trace, 
> thus not even able to reach btrfs:
> 
> [    3.938722] 
> ==================================================================
> [    3.938739] BUG: KASAN: invalid-access in 
> bpf_patch_insn_data+0x178/0x3b0
[...]
> 
> 
> Considering this is only showing up in KASAN_SW_TAGS, not HW_TAGS or the 
> default generic mode, I'm wondering if this is a bug in KASAN itself.
> 
> Adding KASAN people to the thread, meanwhile I'll check more KASAN + 
> hardware combinations including x86_64 (since it's still 4K page size).

I tried the following combinations, with a simple workload of mounting a 
btrfs with xxhash checksum.

According to the original report, the KASAN is triggered as btrfs 
metadata verification time, thus mount option/workload shouldn't cause 
any different, as all metadata will use the same checksum algorithm.

x86_64 + generic + inline:	PASS
x86_64 + generic + outline:	PASS
arm64 + soft tag + inline:	KASAN error at boot
arm64 + soft tag + outline:	KASAN error at boot
arm64 + hard tag:		PASS
arm64 + generic + inline:	PASS
arm64 + generic + outline:	PASS

So it looks like it's the software tag based KASAN itself causing false 
alerts.

Thanks,
Qu

> 
> Thanks,
> Qu
> 
> 
>>
>> Also ensure your mount options resolve similar to
>> "rw,relatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvolid=5,subvol=/".
>>
>> Failing that, let me know of any significant filesystem differences from:
>> # btrfs inspect-internal dump-super /dev/nvme0n1p5
>> superblock: bytenr=65536, device=/dev/nvme0n1p5
>> ---------------------------------------------------------
>> csum_type        1 (xxhash64)
>> csum_size        8
>> csum            0x97ec1a3695ae35d0 [match]
>> bytenr            65536
>> flags            0x1
>>              ( WRITTEN )
>> magic            _BHRfS_M [match]
>> fsid            f99f2753-0283-4f93-8f5d-7a9f59f148cc
>> metadata_uuid        00000000-0000-0000-0000-000000000000
>> label
>> generation        34305
>> root            586579968
>> sys_array_size        129
>> chunk_root_generation    33351
>> root_level        0
>> chunk_root        19357892608
>> chunk_root_level    0
>> log_root        0
>> log_root_transid (deprecated)    0
>> log_root_level        0
>> total_bytes        83886080000
>> bytes_used        14462930944
>> sectorsize        4096
>> nodesize        16384
>> leafsize (deprecated)    16384
>> stripesize        4096
>> root_dir        6
>> num_devices        1
>> compat_flags        0x0
>> compat_ro_flags        0x3
>>              ( FREE_SPACE_TREE |
>>                FREE_SPACE_TREE_VALID )
>> incompat_flags        0x361
>>              ( MIXED_BACKREF |
>>                BIG_METADATA |
>>                EXTENDED_IREF |
>>                SKINNY_METADATA |
>>                NO_HOLES )
>> cache_generation    0
>> uuid_tree_generation    34305
>> dev_item.uuid        86166b5f-2258-4ab9-aac6-0d0e37ffbdb6
>> dev_item.fsid        f99f2753-0283-4f93-8f5d-7a9f59f148cc [match]
>> dev_item.type        0
>> dev_item.total_bytes    83886080000
>> dev_item.bytes_used    22624075776
>> dev_item.io_align    4096
>> dev_item.io_width    4096
>> dev_item.sector_size    4096
>> dev_item.devid        1
>> dev_item.dev_group    0
>> dev_item.seek_speed    0
>> dev_item.bandwidth    0
>> dev_item.generation    0
>>
>> Thanks,
>>    Dan
>> -- 
>> Daniel J Blueman
> 
> 

