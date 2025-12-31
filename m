Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECCF18E02A
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 05:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767157761; cv=none; b=gftTm0nicDJ0+WLwOP6nyzIT+InzW23Oenc/wy3o1uW4wjJFQbI+A2V8CM83BerV8uimKIcNll0jG8UTUUwF/1NFem8N8Ha9ixdHEqDNwt9r/Vtv7uOIWn1qpTbqMrFg3BZi0wgjyGLeTfsmOujmwkYstGw/VPABq1bxsEOojGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767157761; c=relaxed/simple;
	bh=7uspNdXbsimGhSop3aLS0pBSL1J4nWtfyBBVVglm/XQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HGuM5ExK4lR6t/aDV2rYhkXBw44XNf7Vjn/Jya39ergN6upo5YwrhgIPFaJBkBS3kCGdGoHxB/RapcZhqHUjzFrtXwDNTjdMvMblcP4rxFYfJB0ilbgmjdHD7HOVFjrwiEjTFbc+8HqMCZaPZsnWa6kZyovFK1VRf75eceynJak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f/YXHrRS; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f/YXHrRS"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso34215085e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 21:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767157757; x=1767762557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DI0k7hgIOB6FXoBmvQUNmPn4Ay/YstMhbmqFpQgeUc0=;
        b=f/YXHrRST3FY+LrYWCQ14oTgfShP0w3VDwR7wFkBu/O3faVL4gRhP+BE1dzCuL6z7s
         REr2zLde1/gJ3kaR5h53beutpH0EK00XJx8/+90xxN3pTn597AKCrcK7J4y+2YzvlCCT
         lkSq7/OXqkkdhbjUxH764oTaDK50jReqhYUIWmksjE+3uYhVNgO8iMRsS8DpPsn8XZdg
         CghXoTrURirVmaXgbpLkK4xQRx8UfKtUkHmAWBxKFqRz5gKLdO0Ep2Y8f5o37Pl9dBkQ
         o1fo68F5s0uAGSMguVcY5jglJjEYuiZ6uD6eh52alxsGvwjpt4n/ZPz0va0K2N7Xy2kB
         Qe2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767157757; x=1767762557;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DI0k7hgIOB6FXoBmvQUNmPn4Ay/YstMhbmqFpQgeUc0=;
        b=AxsUSM3yX5tIV+jmHV7gwZtMFWjgPwLc3/oFgH2IYfYr+v1cNn+TroIK+zBjQh4Bxx
         FjtVJ5OOR50WM4dhEbTOqVd7WC4vgHHtaChfZeO+WPkup50tp4Zu5w2D9nMbFjlkP6I3
         C3eMvQVb0Pv5IIyxT5hHaF+tum75uNS2uhajKN/6NZ9ThwvKJdU7AqGQw7w7coBRZK2C
         1Ienv6YEdrYRMzcR/pcdydpMGeqDB6bb3cVu05cShW+tOMwLOUMTZaZo47CGqYFJ18r6
         E2SAbhXvXrnynIDxZDpX/cNRHol3fe70XhIUzKmfSBp76GHPHciIf6BLilkg7EboOLIl
         1hXA==
X-Forwarded-Encrypted: i=1; AJvYcCUmtRSiUCVZHbnvO/ZpK+C8jCXS4G3D+/oUswuJyF9OFExrDLnWr4z7PiAkXRsyup+HekrrH+c6tm8UMbM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUT1KE9oqe2msC28xHxtjGXj2lrjgSbcg7J6E3Z4XfdwD409Qf
	NvBtd583LyONBjoG9AjVMBl4wtNBtdCr9fawquNH0lowGUcZ6TtLJEO87um/QZVArj8=
X-Gm-Gg: AY/fxX4XqR/IQqkz5wMfC1HD6DBKvcj73GX20Swd1KBm7KmgAIvw+v8h36+CTaC9BwL
	rOFqMOUZ7SG/hOOxbWoD7JYIJhc4bglgpcpgnK527YdPALw4ATDZIJVdHrJXsnIt5UMMLwrHYvO
	BGJqtVmqLBqEMD9hNjrN/XhQAEcORJTNDZ0vGMZcXD3+wP9U7MgmWJ28X9Ns4WvIVPCwn2ML+uE
	PQ+pl0aQmCYDTXhVzLKA2p+3vf/FRTS4rUuvEmyzoof7Mbv7Q1MI+0/3hL/S+S8CBVgpa+crp/q
	+wnQsxEsaJlzZUP3jKsADMCNuvfGPm2GECP/lPjlOwllnbyeUZRXqOJ/DUqeNcx5bYJDBREQZii
	KtIZpvZJ3JSN2EU1Knr6OqZlipXi7JFMLrOVJgdlXQrsnoV7KAFoNvL36Z+ZcN8DvKiHf96s6tr
	PC0Ixg92d7RrqpaLFkVUL1E/NYKgvPclTANp/TW3E=
X-Google-Smtp-Source: AGHT+IFSef2aMjOCZGiXaCxi2Igicwoyhqhjno+GXu6eUEHCj9Gse5EYWzTfjdNlvctTRctY6fvSNA==
X-Received: by 2002:a05:600c:6388:b0:477:63db:c718 with SMTP id 5b1f17b1804b1-47d19557cd2mr408312175e9.16.1767157757357;
        Tue, 30 Dec 2025 21:09:17 -0800 (PST)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c65d71sm320207135ad.17.2025.12.30.21.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 21:09:16 -0800 (PST)
Message-ID: <eb8d0d62-f8a3-4198-b230-94f72028ac4e@suse.com>
Date: Wed, 31 Dec 2025 15:39:11 +1030
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
 <9d21022d-5051-4165-b8fa-f77ec7e820ab@suse.com>
 <CAMVG2subBHEZ4e8vFT7cQM5Ub=WfUmLqAQ4WO1B=Gk2bC3BtdQ@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
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
In-Reply-To: <CAMVG2subBHEZ4e8vFT7cQM5Ub=WfUmLqAQ4WO1B=Gk2bC3BtdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/12/31 15:30, Daniel J Blueman 写道:
> On Wed, 31 Dec 2025 at 12:55, Qu Wenruo <wqu@suse.com> wrote:
>> 在 2025/12/31 14:35, Qu Wenruo 写道:
>>> 在 2025/12/31 13:59, Daniel J Blueman 写道:
>>>> On Tue, 30 Dec 2025 at 17:28, Qu Wenruo <wqu@suse.com> wrote:
>>>>> 在 2025/12/30 19:26, Qu Wenruo 写道:
>>>>>> 在 2025/12/30 18:02, Daniel J Blueman 写道:
>>>>>>> When mounting a BTRFS filesystem on 6.19-rc3 on ARM64 using xxhash
>>>>>>> checksumming and KASAN, I see invalid access:
>>>>>>
>>>>>> Mind to share the page size? As aarch64 has 3 different supported pages
>>>>>> size (4K, 16K, 64K).
>>>>>>
>>>>>> I'll give it a try on that branch. Although on my rc1 based development
>>>>>> branch it looks OK so far.
>>>>>
>>>>> Tried both 4K and 64K page size with KASAN enabled, all on 6.19-rc3 tag,
>>>>> no reproduce on newly created fs with xxhash.
>>>>>
>>>>> My environment is aarch64 VM on Orion O6 board.
>>>>>
>>>>> The xxhash implementation is the same xxhash64-generic:
>>>>>
>>>>> [   17.035933] BTRFS: device fsid 260364b9-d059-410c-92de-56243c346d6d
>>>>> devid 1 transid 8 /dev/mapper/test-scratch1 (253:2) scanned by mount
>>>>> (629)
>>>>> [   17.038033] BTRFS info (device dm-2): first mount of filesystem
>>>>> 260364b9-d059-410c-92de-56243c346d6d
>>>>> [   17.038645] BTRFS info (device dm-2): using xxhash64
>>>>> (xxhash64-generic) checksum algorithm
>>>>> [   17.041303] BTRFS info (device dm-2): checking UUID tree
>>>>> [   17.041390] BTRFS info (device dm-2): turning on async discard
>>>>> [   17.041393] BTRFS info (device dm-2): enabling free space tree
>>>>> [   19.032109] BTRFS info (device dm-2): last unmount of filesystem
>>>>> 260364b9-d059-410c-92de-56243c346d6d
>>>>>
>>>>> So there maybe something else involved, either related to the fs or the
>>>>> hardware.
>>>>
>>>> Thanks for checking Wenruo!
>>>>
>>>> With KASAN_GENERIC or KASAN_HW_TAGS, I don't see "kasan:
>>>> KernelAddressSanitizer initialized", so please ensure you are using
>>>> KASAN_SW_TAGS, KASAN_OUTLINE and 4KB pages. Full config at
>>>> https://gist.github.com/dblueman/cb4113f2cf880520081cf3f7c8dae13f
>>>
>>> Thanks a lot for the detailed configs.
>>>
>>> Unfortunately with that KASAN_SW_TAGS and KASAN_INLINE, the kernel can
>>> no longer boot, will always crash at boot with the following call trace,
>>> thus not even able to reach btrfs:
>>>
>>> [    3.938722]
>>> ==================================================================
>>> [    3.938739] BUG: KASAN: invalid-access in
>>> bpf_patch_insn_data+0x178/0x3b0
>> [...]
>>> Considering this is only showing up in KASAN_SW_TAGS, not HW_TAGS or the
>>> default generic mode, I'm wondering if this is a bug in KASAN itself.
>>>
>>> Adding KASAN people to the thread, meanwhile I'll check more KASAN +
>>> hardware combinations including x86_64 (since it's still 4K page size).
>>
>> I tried the following combinations, with a simple workload of mounting a
>> btrfs with xxhash checksum.
>>
>> According to the original report, the KASAN is triggered as btrfs
>> metadata verification time, thus mount option/workload shouldn't cause
>> any different, as all metadata will use the same checksum algorithm.
>>
>> x86_64 + generic + inline:      PASS
>> x86_64 + generic + outline:     PASS
> [..]
>> arm64 + hard tag:               PASS
>> arm64 + generic + inline:       PASS
>> arm64 + generic + outline:      PASS
> 
> Do you see "KernelAddressSanitizer initialized" with KASAN_GENERIC
> and/or KASAN_HW_TAGS?

Yes. For my current running one using generic and inline, it shows at 
boot time:

[    0.000000] cma: Reserved 64 MiB at 0x00000000fc000000
[    0.000000] crashkernel reserved: 0x00000000dc000000 - 
0x00000000fc000000 (512 MB)
[    0.000000] KernelAddressSanitizer initialized (generic) <<<
[    0.000000] psci: probing for conduit method from ACPI.
[    0.000000] psci: PSCIv1.3 detected in firmware.


> 
> I didn't see it in either case, suggesting it isn't implemented or
> supported on my system.
> 
>> arm64 + soft tag + inline:      KASAN error at boot
>> arm64 + soft tag + outline:     KASAN error at boot
> 
> Please retry with CONFIG_BPF unset.

I will retry but I believe this (along with your reports about hardware 
tags/generic not reporting the error) has already proven the problem is 
inside KASAN itself.

Not to mention the checksum verification/calculation is very critical 
part of btrfs, although in v6.19 there is a change in the crypto 
interface, I still doubt about whether we have a out-of-boundary access 
not exposed in such hot path until now.

Thanks,
Qu

> 
> Thanks,
>    Dan

