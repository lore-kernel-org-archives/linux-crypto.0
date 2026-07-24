Received: from os-cillation.de (mx.os-c.de [213.165.83.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441E938AC88;
	Fri, 24 Jul 2026 19:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.165.83.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784920380; cv=none; b=bX+XxZ+GrIrkDT+fgcsf6bJvID0kBjmiovFUs4NWdBNXZRsw2CTT89OShGGQ1UxWj/wHwCUDvrRVv9fUyHOKgIi96yFO8uqbIX7zMGI54EDWuE0nsSkSKrqMo/BacYbczNdMnRfmr0AV78DwHLdwng2vsNVYSeYPCj+dK+RH8Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784920380; c=relaxed/simple;
	bh=sa9rLcmj31NVq/qF+eBU0MswrMLIolVsI2/RTadHn0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SS8gdj6CHd7ASWg4U2mSlyLgnbSMRQmKNbWBv49JWtkpws7mT10acA2RlGBgbCf/kArGdG6bGtZ7jWddrUimEbrTKYwYYcpDEgPwLPwuuB50KbUJ/UV5mZwuEmm+83Ue0teMN/BaPHPTBZNpb98pCopR2lnA5Nj/UVBqEJrMVRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=os-cillation.de; spf=pass smtp.mailfrom=os-cillation.de; dkim=pass (2048-bit key) header.d=os-cillation.de header.i=@os-cillation.de header.b=VBakHQ9S; arc=none smtp.client-ip=213.165.83.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=os-cillation.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os-cillation.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=os-cillation.de header.i=@os-cillation.de header.b="VBakHQ9S"
Received: from core2024.osc.gmbh (ip-094-079-177-042.um30.pools.vodafone-ip.de [94.79.177.42])
	by os-cillation.de (Postfix) with ESMTPSA id F0FDDC0381;
	Fri, 24 Jul 2026 21:12:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=os-cillation.de;
	s=202409; t=1784920376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Qki56/0rJqhGdoQVgC7oeD6qgG42mAGRt9AiirHKEl0=;
	b=VBakHQ9SUtViopQofAqkzI+/Gy1OPwBotn1r6pZKO0CWOqqpMhm+F2OD317UwK2r3Ia/dU
	2OsunUIBVpMg3BHihf42m6/LMBgTfn77iUcn/RaodS0+Zwra5d6Mcak52JkF3Y4d5RlqDT
	cKApezkXK1Q/7jCo/U34GUbZqauH0ey8gGh5TgN9tE8vcu9LDX8xDDlvaXuMSD9cX3RjdB
	QW+cYQNYZG+t6Sfh6ANMtRJdhytDTARWCYbhP7TXWj+f23kCGXRKYna5y7y2pjQtdL4kTY
	9aWdlJJFJnsUoJw9ifKVuSuVmVCkid7gCptLw9EcarwyKCB4IBxTQ0NFSMbHHQ==
Authentication-Results: os-cillation.de;
	auth=pass smtp.auth=os-c@schweissgut.net smtp.mailfrom=hd@os-cillation.de
Received: from [192.168.3.45] (hd2022.osc.gmbh [192.168.3.45])
	by core2024.osc.gmbh (Postfix) with ESMTPSA id 8B01D200952;
	Fri, 24 Jul 2026 21:12:55 +0200 (CEST)
Message-ID: <d3f65083-896e-4f79-87fe-95cace11c5eb@os-cillation.de>
Date: Fri, 24 Jul 2026 21:12:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Thomas Huth <thuth@redhat.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-2-ebiggers@kernel.org>
 <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
 <20260721195004.GA3383223@google.com>
 <19613c3e-9756-45fc-84b6-b650ba3723a7@os-cillation.de>
 <20260722194023.GB2118@quark>
 <10430138-05b6-46b8-b9d2-7cad5c371fc4@os-cillation.de>
 <20260724185116.GB1572592@google.com>
Content-Language: en-US
From: Hendrik Donner <hd@os-cillation.de>
Autocrypt: addr=hd@os-cillation.de; keydata=
 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 li+2
In-Reply-To: <20260724185116.GB1572592@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 7/24/26 20:51, Eric Biggers wrote:
> On Fri, Jul 24, 2026 at 08:19:02PM +0200, Hendrik Donner wrote:
>>
>> so i'm now on 7.1.4 with
>>
>>    PCI: imx6: Keep i.MX6 Root Port MSI/MSI-X Capabilities with iMSI-RX to
>> work around hardware bug
>>
>> on top to be able to tune queue settings. And to have a working ethernet
>> in the first place, without the patch the NETDEV WATCHDOG resets the
>> card all the time due to queues stalling. But now more than 1 CPU are
>> serving IRQs.
>>
>> With pcrypt
>> (seqiv(rfc4106(pcrypt(gcm_base(ctr-aes-neonbs,ghash-lib))))):
>>
>> Upload:
>> [  4]   0.00-60.00  sec   901 MBytes   126 Mbits/sec
>>
>> Download:
>> [  4]   0.00-60.00  sec  1.23 GBytes   177 Mbits/sec
>>
>> Without pcrypt
>> (seqiv(rfc4106(gcm_base(ctr-aes-neonbs,ghash-lib)))):
>>
>> Upload:
>> [  4]   0.00-60.00  sec   679 MBytes  94.9 Mbits/sec
>>
>> Download:
>> [  4]   0.00-60.00  sec   674 MBytes  94.3 Mbits/sec
>>
>> So counterintuitively pcrypt matters more again. I repeated the tests a
>> few times, those numbers are fairly representative. Every run is over a
>> 60 sec window.
> 
> Thanks for trying it.  Perhaps this is related to the iperf3 test using
> only a single flow?  Does that reflect the real-world case for you?

probably flow related, i would need a different test setup to create
different flows, but for example single file downloads matter to our
userbase.

> 
> I'm also curious whether you're particularly attached to AES-GCM, or
> whether you've considered switching to ChaCha20Poly1305 which would be
> much faster on that CPU.  This could be done either by switching to
> "rfc7539esp(chacha20,poly1305)" within IPsec, or by just switching to
> WireGuard.
> 

Unfortunately the technical specification the system has to comply to
says IPSec and AES-GCM and/or AES-CBC with HMAC-SHA256. CBC is on its
way out though and barely seen in production anymore.

> If none of those are options for you and you do want pcrypt to be kept
> around, could you confirm that you're solely using 'crconf' (run as
> root) to enable it, and in particular you're not relying on the
> misfeature of also being able to enable it as an unprivileged user using
> AF_ALG?  We can keep it around for a bit longer if really needed, but
> the unprivileged stuff definitely has to go.  We should also keep in
> mind that pcrypt does not get tested very well (as the crypto self-tests
> just test serial use) and historically has had a lot of issues.
> 

For configuring the IPSec related templates only crconf is used in
production. On that kernel configuration AF_ALG is completely off.

Test environments use CONFIG_CRYPTO_USER_API_RNG only, everything else 
concerning AF_ALG is disabled.

Regards,
Hendrik

> - Eric

