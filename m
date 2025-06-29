Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203E81CBEAA;
	Sun, 29 Jun 2025 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751227641; cv=none; b=ZqDlPD6GAbiWcu+W6ieuPVDykdFKXY4F1Rh4Nx92IY8I+95uW0PBIF/img0XVXE3x4Y0Lpar4DjkeZEnbZ1qaNpzM3WhU91JpgLPiOs0LTUKpdB2Pmr4EpHM8S+LYVNegw13hgAoSLuen1N475mQ4h8Igkfyw8/00RPpzc2cD0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751227641; c=relaxed/simple;
	bh=UIJ3X4D0ffKfruWJPoE5+zvCmo9HErX2i9Wp9Oi7R5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ls2hK+LUknz73jx9HB+6z8J76GWSfMhfcH4TcJg1ol8ubc7bMLPNiPdaCWF2lssNWVRIs1KbfUVM8JegCpnkcEWOkko9mLqotFy2yvg/k2WbvJTADAzbwQG2/uMinsPTu5ghh4yipedZyXQrhuzkE9Lp4Pnta2PtexxY+N2avZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.196] (p5b13a6da.dip0.t-ipconnect.de [91.19.166.218])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3810B61E64787;
	Sun, 29 Jun 2025 22:06:42 +0200 (CEST)
Message-ID: <4585b0e7-7172-476d-8cd9-012ca65daa9b@molgen.mpg.de>
Date: Sun, 29 Jun 2025 22:06:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kdf108_init() takes over 250 ms
To: Stephan Mueller <smueller@chronox.de>,
 Tim Chen <tim.c.chen@linux.intel.com>, Robert Elliott <elliott@hpe.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
References: <6d6b6bcf-cab8-695b-568a-c1372ac531ee@molgen.mpg.de>
 <MW5PR84MB1842811C4EECC0F4B35B5FB3AB709@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <2658706.V0ylg0ELTe@tauon.chronox.de>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <2658706.V0ylg0ELTe@tauon.chronox.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Stephan, dear Robert,


Am 26.08.22 um 09:47 schrieb Stephan Mueller:
> Am Dienstag, 23. August 2022, 22:10:01 CEST schrieb Elliott, Robert (Servers):

>>> -----Original Message-----
>>> From: Paul Menzel <pmenzel@molgen.mpg.de>
>>> Sent: Tuesday, August 23, 2022 9:52 AM

[…]

>>> On the Dell XPS 13 9370 with Debian sid/unstable, I noticed with Linux
>>> 5.18.16, that  `crypto_kdf108_init()` takes 263 ms to run even with
>>> disabled self-tests:
>>>
>>
>> ...
>>
>>> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-5.18.0-4-amd64
>>> root=UUID=56f398e0-1e25-4fda-aa9f-611dece4b333 ro quiet
>>> module_blacklist=psmouse initcall_debug log_buf_len=4M cryptomgr.notests
>>
>> ...
>>
>>> [    0.272127] calling  crypto_kdf108_init+0x0/0x149 @ 1
>>> [    0.530787] Freeing initrd memory: 39332K
>>> [    0.534667] alg: self-tests disabled
>>> [    0.534701] alg: self-tests for CTR-KDF (hmac(sha256)) passed
>>> [    0.534703] initcall crypto_kdf108_init+0x0/0x149 returned 0 after 262573 usecs
>>
>> ...
>>
>>>
>>> With self-tests enabled it’s only less than a millisecond longer.
>>>
>>> ```
>>> [    0.282389] calling  crypto_kdf108_init+0x0/0x149 @ 1
>>> [    0.541096] Freeing initrd memory: 39332K
>>> [    0.545674] alg: self-tests for CTR-KDF (hmac(sha256)) passed
>>> [    0.545676] initcall crypto_kdf108_init+0x0/0x149 returned 0 after 263284 usecs
>>> ```
>>
>>
>> crypto_kdf108_init() call its self-test function directly rather
>> that alg_test(), which implements that notests flag. Maybe it
>> should go through alg_test().
> 
> You are right that it does not uses the alg_test. This is because the KDF is
> just a helper and not implemented as a template. I initially wanted and
> provided a patch that turns the KDFs into templates which then would be able
> to go though alg_test. It was not accepted, but instead only service functions
> where accepted.
> 
> The reason for not accepting the template approach was that a complete new API
> is needed to accommodate the KDFs. Initially I called the API "rng" because a
> KDF and a PRNG are very very similar in nature: they take an arbitrary string
> as input (the seed/key/personalization/additional info/label string) and
> provide an arbitrary output (mathematically you can even use both
> interchangeably for the same purposes - although cryptographically speaking
> you do not want that). As this concept cannot be covered with the existing
> APIs, a KDF cannot be rolled into those existing APIs as template. Side note:
> the same question around such new API will appear as soon as somebody asks for
> SHAKE to be added.
> 
> A low hanging fruit would be to also deactivate the KDF test when the notest
> option is selected.
> 
>> Outside of that, check that Tim's x86-optimized SHA-256 module
>> is loaded, so it is used rather than the generic implementation.
>> One my system, that improves the kdf108 initialization time
>> from 1.4 s to 0.38 s:
>>
>> With sha256_generic:
>>    initcall sha256_generic_mod_init+0x0/0x16 returned 0 after 0 usecs
>>    ...
>>    initcall crypto_kdf108_init+0x0/0x18d returned 0 after 1425640 usecs
>>
>> With sha256_ssse3 (using its AVX2 implementation):
>>    initcall sha256_ssse3_mod_init+0x0/0x1bf returned 0 after 12148 usecs
>>    ...
>>    initcall crypto_kdf108_init+0x0/0x153 returned 0 after 382799 usecs
>>
>> That's controlled by CONFIG_CRYPTO_SHA256_SSSE3.
> 
> The test is performed during kernel boot time with the available
> implementation - the self test uses "hmac(sha256)". If the AVX2 is not
> registered at that time with the kernel crypto API, it will not be available
> for use. But it is not possible to hard-code the use of the AVX implementation
> or any other implementation as it is not guaranteed to be present.
> 
> The issue would be alleviated it would go through alg_test though.
As I didn’t notice this, or forgot it, for the record, this was 
addressed by Eric Biggers in commit 0bf365c0efdd ("crypto: kdf - skip 
self-test when tests disabled"), that first shows up in Linux v6.2-rc1.


Kind regards,

Paul
