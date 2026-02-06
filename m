Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DF330E0E4
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 19:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770406830; cv=none; b=E2K8iDYxPEZeZBvhEq/SyY69jHF0xUKM4bBuJ/1D5Wj2PUy8fLCRtrjuZjvkOGBwiUMHe0fmqVgNSDzY/szcCivEFkQf/k9zJb9xqLeo1ejbWj00pm6RWoBx9PLlwW/hjJZO/eNnhHdL3em78tyQ83dbXJoeIFNpUzySMLDwFUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770406830; c=relaxed/simple;
	bh=zUe66ZHFXqWbOjcsNIqqKQtM5EYLwQef9/mREPqKm2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUqpoSvq4BPfNVCdM8c2/loOH9u1gI2wZ/+Avk56HMrAi1PzudkPkdWQyR981HX9BJTQGxPd23tM79q85X4OxkFAaKJGJK9YSTzqs4OMEBkMTRB73ryErbR/jNm73yVRI/OIiAoaxkJYoJ68aeTiKAS2KI+BQL5CHEZ6+fpq6EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=SqeEpPv0; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="SqeEpPv0"
Received: (wp-smtpd smtp.wp.pl 27143 invoked from network); 6 Feb 2026 20:40:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1770406819; bh=+EvUkGikLGBVG5LNiJdmoCiaus9vguvrveELNY97Pqw=;
          h=Subject:To:Cc:From;
          b=SqeEpPv0BlEAhNqth5R+pVW07rUJPFpn9MKv+CRwCBlV+Av025KXHqFyldMsUnekl
           kELamoDdM004EiEZAeAdzO856R0hOxfrJ6zJcQ+nJsz88rDpqGYQuVyL4GSXqI5D0w
           imC9WEP6L4hQerhQEIj6fK8u9+HtD1iNzWpo64Xn5hJ6RMfVGKvFIcaSFxaCCb96GD
           b9koQkkdkEbHQRzzgoIwaiMnga39Z3OkhEqlA2f2fkR69snEXSOvrLdoxGo36KdV8r
           4lKpLbT1klOAmlMioz/iHDQGk8MCoh3Xcv6NyfaD66eZhpXysYvlKQxIFfcJ6RJEWz
           mHdFXapvGoRSw==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO [192.168.3.246]) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 6 Feb 2026 20:40:19 +0100
Message-ID: <3622af67-b083-488a-998a-29b8657be73a@wp.pl>
Date: Fri, 6 Feb 2026 20:40:18 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(des3_ede))
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
 alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260201112834.3378-1-olek2@wp.pl>
 <aYXKFtmVJCCZpUVw@gondor.apana.org.au>
Content-Language: en-US
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <aYXKFtmVJCCZpUVw@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-WP-MailID: 5428d022556c331c140129cf87531499
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [YNM0]                               

Hi Herbert,

On 2/6/26 12:01, Herbert Xu wrote:
> On Sun, Feb 01, 2026 at 12:27:08PM +0100, Aleksander Jan Bajkowski wrote:
>> Test vector was generated using a software implementation and then double
>> checked using a hardware implementation on NXP P2020 (talitos). The
>> encryption part is identical to authenc(hmac(sha1),cbc(des3_ede)),
>> only HMAC is different.
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
>>   crypto/testmgr.c |  7 ++++++
>>   crypto/testmgr.h | 59 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 66 insertions(+)
> Patch applied.  Thanks.

While resolving the conflict, the entry was added in the wrong place. As a
result, the test manager complains about sorting:
[    0.050891] testmgr: alg_test_descs entries in wrong order: 
'authenc(hmac(md5),ecb(cipher_null))' before 
'authenc(hmac(md5),cbc(des3_ede))'

Should I send a patch to fix the sorting? Or would you prefer to replace
the patch in your tree and apply [1] first, then [2]? That way there should
be no conflicts.

1. 
https://patchwork.kernel.org/project/linux-crypto/patch/20260131174020.3670-1-olek2@wp.pl/
2. 
https://patchwork.kernel.org/project/linux-crypto/patch/20260201112834.3378-1-olek2@wp.pl/

Best regards,
Aleksander

