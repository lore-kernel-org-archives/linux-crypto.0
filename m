Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8832A2ECD28
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 22:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763678225; cv=none; b=D8/OeLL+CudMmy7pvRzD6NqZgz73bROIkwYM69SHWbzIzAXUX3+xDsJ6qi4vWLmD32s3cnZQiX2eu570xoUmPk57F9yVpjIkB7AER7SEdSkcpJa/lyNs32cD5/qKDESgRoKHOg9dPwnus2Xh8BQNWsqE7I7bNG9B4RQthzGaBpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763678225; c=relaxed/simple;
	bh=AcwuMcZ/RJFqblpVlPWKyfVp/SwXhjj1Ku4QknIGlW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aPfhnLZQoBuGBy2PO7rbOMfi3hO/RhSKxIGAAM05BNOkz24tMXahvMp7FYKb4v905yROJ8qgPvwKz3H89CzlL7eNu+EABL377FAdhxkraYcm2GLTVsdZi72/+4rOuFLkO8FP4w51+9KP2Bl4UijFyRzuuwstYAFXyRXo57Xyqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RgOMbhD2; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RgOMbhD2"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42bb288c17bso940186f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 14:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763678221; x=1764283021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=teHzbHAZt4K2w/tuw2YsIconSZped389koaKoK927cs=;
        b=RgOMbhD2Lo2pLWRPXs3aBFQvMHOq6MABjqbv3xby5ctGfm347SnhOxLVDGymWAuPc1
         thR0MWDyM7ciFjrj+/fmYnRQWy6hymEKs/M+sULcwuagt88ndpwucE+emblAS2zLY7nf
         gkJFwXB/iJzO3mDOY4y6hftELTvjwvZahE+aYUpNbFrLZl1KoxA3cX1Nzx85ITwDz7Ff
         5ew61T2oTqMI5lwLTOm1AIvGP5+Ncp/kFnXkBnvKeDM+H405xNcC++3ac2pzlAEAJ+du
         hGLrXmn5DkG+ryy/YhcSOIHCsxwGZ1ieXK5ffjvctdhHgGDuY4aEZZgn9BJC3ixam9Qp
         v55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763678221; x=1764283021;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teHzbHAZt4K2w/tuw2YsIconSZped389koaKoK927cs=;
        b=VLrP7pjcGRcM1v60tN0PK5OFmuG09kQEwlh2M+GXuwNQAro40MDGE/FsO4xF+zasKU
         wlOmO5cRNTOs0TzkYHuXPFkt+V+IXUHqwvKDbzF321m3eZsl0I36GxGD84YIe3AJP0hF
         gLcTuj7eNeTsB1hFeWWAilXuqB3NZWgtIf3AtL9U/uNKOcmyqw6+vprf8Gyn3WuC8h9D
         WJVcDYDGy/qf1oM6U/D2WAfGrPcltJ8Enycyjw3URJ9o8lnZV/lbxDE6UeAsW1Exivcf
         M95rhDZjXV3ClJRL8FEMXH7CvruutBMgSfPuwRB6+VhIHH/X57kOqlPStOj4dXISifLw
         UyOQ==
X-Gm-Message-State: AOJu0YxynhPb3vVcC7Esrc7xvCnZqmk2aKD4MuuAgrdvf1hNqT3GuK4d
	qzAfFIKk3MbAZvglKeXFyGmokCifn7LLkJ7YSohOWK17Ykz8kciT1HEHF43d1MduEI8=
X-Gm-Gg: ASbGncuU1HAeakEYu2nwIu+P1ona7DQcvgR1aWyBrcrOOH8K1654GdkhL4qEAOqfkkG
	qgIcIEVGO3Q9h7BeqX1kTtHcCl1rWflzC3skvOOqNnyVk/fJgEjvZYeoDa1Atuu1xJFDglG1EE3
	i/YXLKJcF8Jw8vgEdLkYNMMKk5cTUrELAhNbcqi1PfVHOuPddDCldbAsC+vaHP5/A4WuqNWmnhC
	vV8/hNtGJZzjAOKajTP9EOdPqKtur/U/UvlXqMjDQ6c//DQpF2BoEmBA+ThXKaiIkSOTaekxiuc
	XXOdbeRcXWYYBxc6YA5UHsb2z3eb6GIu4ED5WHzRNorjPnFKRJPCbE0hUtSAODZGPSZ0vrSEuVT
	wZYjs5Af9TaofgxTio5h4OnbSrWrlR0TVmp2U3mi6oN24DcDBdNx4qp/vJD3rBuyKgigPLyOIKr
	l/wpY5QZo4/hOKvaRpMyF/x5/AoqJcl3YDcJSZcng=
X-Google-Smtp-Source: AGHT+IEi30R7PUEVbcV7RZ1AGGSluhU9fB1gMEH2YtJ/it/mkxTjTJpP3f7nP1Hpolp5Du9gRTeh+Q==
X-Received: by 2002:a05:6000:612:b0:429:c54d:8bd3 with SMTP id ffacd0b85a97d-42cbfb43efamr1062637f8f.53.1763678220800;
        Thu, 20 Nov 2025 14:37:00 -0800 (PST)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def6321sm3584201a12.6.2025.11.20.14.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 14:37:00 -0800 (PST)
Message-ID: <832a46d9-8766-4fcd-a319-940e23a4d765@suse.com>
Date: Fri, 21 Nov 2025 09:06:55 +1030
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Questions about encryption and (possibly weak) checksum
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Daniel Vacek <neelx@suse.com>, Josef Bacik <josef@toxicpanda.com>
References: <48a91ada-c413-492f-86a4-483355392d98@suse.com>
 <20251120223248.GA3532564@google.com>
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
In-Reply-To: <20251120223248.GA3532564@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/11/21 09:02, Eric Biggers 写道:
> On Fri, Nov 21, 2025 at 08:28:38AM +1030, Qu Wenruo wrote:
>> Hi,
>>
>> Recently Daniel is reviving the fscrypt support for btrfs, and one thing
>> caught my attention, related the sequence of encryption and checksum.
>>
>> What is the preferred order between encryption and (possibly weak) checksum?
>>
>> The original patchset implies checksum-then-encrypt, which follows what ext4
>> is doing when both verity and fscrypt are involved.
>>
>>
>> But on the other hand, btrfs' default checksum (CRC32C) is definitely not a
>> cryptography level HMAC, it's mostly for btrfs to detect incorrect content
>> from the storage and switch to another mirror.
>>
>> Furthermore, for compression, btrfs follows the idea of
>> compress-then-checksum, thus to me the idea of encrypt-then-checksum looks
>> more straightforward, and easier to implement.
>>
>> Finally, the btrfs checksum itself is not encrypted (at least for now),
>> meaning the checksum is exposed for any one to modify as long as they
>> understand how to re-calculate the checksum of the metadata.
>>
>>
>> So my question here is:
>>
>> - Is there any preferred sequence between encryption and checksum?
>>
>> - Will a weak checksum (CRC32C) introduce any extra attack vector?
> 
> If you won't be encrypting the checksums, then it needs to be
> encrypt+checksum so that the checksums don't leak information about the
> plaintext.  It doesn't matter how "strong" the checksum is.

Great, that matches my expectation.

Thanks,
Qu

> - Eric

