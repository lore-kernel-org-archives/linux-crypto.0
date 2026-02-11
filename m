Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0C442049
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770830429; cv=none; b=LZKu3T+FkzZzTU3lqM0yT2WyQTo6xfaeAnpB4tdxpd1ei2ecgFIuuYpi5J2pxwpGnA8WiPCRdtruhfcUklZI5f773yoU6QVfKXBZZRbkMtwcHaJ/lro3LC9lCNF0KBq8lbC0soPgTgxTHvcUS3e3CKSxtIhUGcxa6ZgXm/O8t7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770830429; c=relaxed/simple;
	bh=m3wXLJLiAnf5L1nLpoGpVPvqvPzIjyzQBCh6lxzUvDQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=JgD38awQE8F3HqaTFhWhfCkUlJO/M4Pvgv/B4+VjJK2I+oiqRphFEljtrGzufJyAbzuaxHHZnvZd/oFRtY8AvyznvhnAPGOzXYDW81zLbkYe01n2/+6h+aFgxHkEqkoYQJKZ0HjuT0S1QFdQ2TXE0cBNc8bcJHa6qV7k4O0k/ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=qG8oYq2u; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="qG8oYq2u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1770830428; x=1802366428;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=m3wXLJLiAnf5L1nLpoGpVPvqvPzIjyzQBCh6lxzUvDQ=;
  b=qG8oYq2uT3ZsICexPljCrnkMRmtZuB9jSon6myZPhghgTrgpGrp3H/3l
   aprGAnV+/4acApiWzelpxAK1UGpDo7u0mVrb1SE5rdotHoaNKyN6pOYlH
   3d8Ne10XRQ8+jR9OFgbhbXFUcPXcd9FmwV8zEjMa+gEf04Uw5qkPwljgi
   eLHd/KfyxdRnOFt+YEwk1D0RzvHbDEl8+1DLaOJvoq6LOklG3Wq2tlnve
   q6h6yAn9KkdLRPUSceyFQGwnADlId0hiJiWCsH2rR7/Yq7d3UdEM7RYB6
   pUbWxC4vDPOBjDqwibEgomqS4LBn2OM40Xo1kykxn88+a8QzANFiPaU7y
   w==;
X-CSE-ConnectionGUID: 3uqK18o6SxKNJj+wGx10bQ==
X-CSE-MsgGUID: Bygq3nTvRFS6P44h1XwMig==
X-IronPort-AV: E=Sophos;i="6.21,285,1763449200"; 
   d="scan'208";a="53269188"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 10:20:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.87.151) by
 chn-vm-ex4.mchp-main.com (10.10.87.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 11 Feb 2026 10:19:31 -0700
Received: from [10.10.179.162] (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Wed, 11 Feb 2026 10:19:31 -0700
Message-ID: <4b44aa36-cbee-4f19-90d7-0591d8e4ae90@microchip.com>
Date: Wed, 11 Feb 2026 10:20:17 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AFALG with TLS on Openssl questions
From: Ryan Wanner <ryan.wanner@microchip.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>
References: <25e13e64-f39c-44b4-9877-1e3b6caed458@microchip.com>
 <aXw8-J2KRklumOa8@gondor.apana.org.au>
 <6768ba1e-8051-4623-8d9a-4c3835011755@microchip.com>
Content-Language: en-US
In-Reply-To: <6768ba1e-8051-4623-8d9a-4c3835011755@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On 1/30/26 07:51, Ryan.Wanner@microchip.com wrote:
> On 1/29/26 22:09, Herbert Xu wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On Thu, Jan 29, 2026 at 09:28:51AM -0700, Ryan Wanner wrote:
>>> Hello,
>>>
>>> I am working on kernel v6.12 and trying to use
>>> authenc(hmac(sha256),cbc(aes)) for a TLS connection. The driver I am
>>> using atmel-aes.c and atmel-sha.c both do support this and I did pass
>>> the kernel self tests for these drivers.
>>>
>>> It seems that afalg does not call the authenc part of this driver, but
>>> seems to call aes separately even though authenc is detected registered
>>> and tested. Can I get confirmation if this is supported in afalg? From
>>> what I understand afalg does not support hashes but cryptodev does. I
>>> see cryptodev call both sha and aes while afalg just calls aes.
>>>
>>> I do have CRYPTO_DEV_ATMEL_AUTHENC=y CRYPTO_USER_API_HASH=y
>>> CRYPTO_USER_API_SKCIPHER=y CRYPTO_USER=y this is a SAMA7G54, ARM CORTEX-A7.
>>>
>>> I also would like to know if authenc(hmac(sha512),gcm(aes)) is
>>> supported? I would like to add that to the driver as well but due to the
>>> issues I highlighted above and no selftest suite for authenc gcm I do
>>> not know a good way to verify the driver integrates with the crypto system.
>>
>> It certainly should work.  I suggest that you check /proc/crypto
>> and see if your driver algorithm is registered at the correct
>> priority for it to be used in preference to the software algorithm.
>>
> 

Re-sending question due to email bounceback error.

Is there a optimal priority? I have tried setting it to 4000 and 300
both give the same behavior.

Another qurestion about af_alg and algif_aead. Are these supported by
opnessl? I am using openssl 3.2.4 and only see aes-*-cbc supported with
the config that I mentioned above is this correct? And does af_alg
support hash acceleration?

Thank you,
Ryan

>  > Cheers,
>> --
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>>

