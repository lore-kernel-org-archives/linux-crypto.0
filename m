Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6024E149C7B;
	Thu,  2 Oct 2025 10:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759402635; cv=none; b=lc8N/Xp15vsKOGaGgQWLLq9cXNgKumIJhFYR7vbJTbAPtsQdlRWMbpGJYVc/36qGfOgnd6X2EABwdREBSttABDBWruF6MFv4UKWw15wDqkMfh6/HY+pbf3VvSqA6j4bZQu2Tx660O/OVWmCWnJ4CHxz71yob+uumFQGwWV1uDcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759402635; c=relaxed/simple;
	bh=vb4CJXKjIP8Ior4EgVx6Qi8NH8Wh5PpPMwKXojQW4/U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uO1p1uSwoB52lSBcM8grV8ZDcHcC3AGhWvW1pb8zCtD9UVF+ZSPTP7dbk/x6XCCKE0GTZQETta9In3kJqSjb9kN/Iiyo+5PDjjOVM3tDHHssiWShPmAlZbIcjPrHmPEMALCJcNhzF+XKBLminvDBDx2AQ9IljuqT/v6QyUZjKGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RO6SeJ0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RO6SeJ0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C8EC4CEF4;
	Thu,  2 Oct 2025 10:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759402635;
	bh=vb4CJXKjIP8Ior4EgVx6Qi8NH8Wh5PpPMwKXojQW4/U=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=RO6SeJ0oDKP/joEVdAhI9Kz2e9Ehx5wQ9Qu+ObcPKA7gNobEfB0qzbPFZcEBiumGA
	 YSd3A+tnNNrHY+Kq9iwm8VA7F8Lj8PGWx0LdhzMzjYn7TsrXo4F9/v7ukIhFLWdQAf
	 bjKbhMBda9XNIZSEfSozSymndNk7239ZTu0klIwPxAZQBQ66LZuheLsBnNG9sKCit8
	 Z1a45lHwT8tPdonddNJXOZrvwn0dvFWbCgTVhASU/6Nn+hftydyOyxe2b1sfB8wzQF
	 eTzQN2v+DGSa9MmK8gH1wUYOsEVdMKg+4tb6E36GF6TXHK7DKV5IumFKKSe7LNT/eD
	 vkt7NY2z7L9uA==
Message-ID: <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
Date: Thu, 2 Oct 2025 12:57:11 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL] Crypto
 Update for 6.17]
From: Jiri Slaby <jirislaby@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Vegard Nossum <vegard.nossum@oracle.com>, netdev@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
 <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
Content-Language: en-US
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 02. 10. 25, 12:13, Jiri Slaby wrote:
> On 02. 10. 25, 12:05, Jiri Slaby wrote:
>> On 02. 10. 25, 11:30, Herbert Xu wrote:
>>> On Thu, Oct 02, 2025 at 10:10:41AM +0200, Jiri Slaby wrote:
>>>> On 29. 07. 25, 13:07, Herbert Xu wrote:
>>>>> Vegard Nossum (1):
>>>>>         crypto: testmgr - desupport SHA-1 for FIPS 140
>>>>
>>>> Booting 6.17 with fips=1 crashes with this commit -- see below.
>>>>
>>>> The crash is different being on 6.17 (below) and on the commit --
>>>> 9d50a25eeb05c45fef46120f4527885a14c84fb2.
>>>>
>>>> 6.17 minus that one makes it work again.
>>>>
>>>> Any ideas?
>>>
>>> The purpose of the above commit is to remove the SHA1 algorithm
>>> if you boot with fips=1.  As net/ipv6/seg6_hmac.c depends on the
>>> sha1 algorithm, it will obviously fail if SHA1 isn't there.
>>
>> Ok, but I don't immediately see what is one supposed to do to boot 
>> 6.17 distro (openSUSE) kernel with fips=1 then?
> 
> Now I do, in the context you write, I see inet6_init()'s fail path is 
> broken. The two backtraces show:
> [    2.381371][    T1]  ip6_mr_cleanup+0x43/0x50
> [    2.382321][    T1]  inet6_init+0x365/0x3d0
> 
> and
> 
> [    2.420857][    T1]  proto_unregister+0x93/0x100
> [    2.420857][    T1]  inet6_init+0x3a2/0x3d0
> 
> I am looking what exactly, but this is rather for netdev@

More functions from the fail path are not ready to unroll and resurrect 
from the failure.

Anyway, cherry-picking this -next commit onto 6.17 works as well (the 
code uses now crypto_lib's sha1, not crypto's):
commit 095928e7d80186c524013a5b5d54889fa2ec1eaa
Author: Eric Biggers <ebiggers@kernel.org>
Date:   Sat Aug 23 21:36:43 2025 -0400

     ipv6: sr: Use HMAC-SHA1 and HMAC-SHA256 library functions


I don't know what to do next -- should it be put into 6.17 stable later 
and we are done?

thanks,
-- 
js
suse labs

