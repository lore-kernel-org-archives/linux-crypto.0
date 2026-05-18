Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C6B329C57;
	Mon, 18 May 2026 06:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779086946; cv=none; b=XIYmb+fwfZz8/2X1YwkPSHreHMNaQ7XLtdQKO/929oOJlMaXpDVLTd55P7xgTum28JiJF5iPvb2Tgj/uRfBkCSFJW8JsBvnZ44XLAg8ovfocTbJPfRoKfrrCOU56HU+5EkcJUb3XHp1uBb48h7lD+R0RVuazbm4HJgL44jzdEGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779086946; c=relaxed/simple;
	bh=5Bwvn3tyJWkXDwcuh8yJbtR5dDmTbHFH6B0/lOnohx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g5kIk9DZydM8M3xaO12bd5MsKfHNnP0H77P+XrY3TR48fivQHK+AylPoG21RzSM4LK1SdRANK5RaTUpXMb7RVT0WneenaF4GIXNP7i8c5m2pKRcoLqTWqpxicGB590qY8ToE2uHRMPpigHfkGabk6+CXafRWJ679mDRGaeHxGFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Inb9zsWs; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Inb9zsWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=oSzeC+DoQWAdoUQJPBfx930SyUC+lW5/J/zVH9kFj70=;
	b=Inb9zsWsts0uL1V7x1okYreD8b2Cv1ZdnVAb2JP/7d/D7ZgArK7DohUg9DeBsQ
	iDC6JIEaesqelgwE5f8IrBP/mmCn9v6XYYuT2xlfUW+ceZu+qHNUs55qZIS4PdH2
	UrmXRbepXNUGgDg+jgwgxzcd6GLRrVJTRgffTtfj55XGQ=
Received: from [127.0.0.1] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgA3HKpItgpqppMoEA--.51388S2;
	Mon, 18 May 2026 14:48:41 +0800 (CST)
Message-ID: <4fb33a60-7e62-4c73-b82a-e990dea7212d@163.com>
Date: Mon, 18 May 2026 14:48:39 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] authencesn: Refactor in-place decryption
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
 Scott GUO <scottzhguo@tencent.com>, netdev@vger.kernel.org
References: <20260515083645.4024574-1-scott_gzh@163.com>
 <4e9aee15-62e6-4d71-a836-250c5376a8fd@163.com>
 <8aaa00f3-d8e0-4de0-918b-1f025b632eb9@163.com>
 <agp6lDddmDZaoH6L@gondor.apana.org.au>
 <9f625d9d-6820-442e-9527-1b2802309993@163.com>
 <agqEvY4xJYjbZVDI@gondor.apana.org.au>
From: Scott Guo <scott_gzh@163.com>
In-Reply-To: <agqEvY4xJYjbZVDI@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgA3HKpItgpqppMoEA--.51388S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF4rAr13ur48CF1kZrW7CFg_yoWkKFg_uF
	98t34kC39rA3WkXw13tw4vgrZrGr95Wry5Za4Dur17Kr98Xrs8J3WvqFZav3WUCrWfKr98
	CFsxX347Zw1SvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRRCzt5UUUUU==
X-CM-SenderInfo: hvfr33hbj2xqqrwthudrp/xtbCwwncemoKtkkeSwAA3m

Then the problem comes down to whether ESP will be able to identify all 
the path and mitigate all of it.

I am also wondering whether this in-place crypto + SG list method would 
have simular issue with other crypto such as SKCipher. Copy Failed, 
Dirty Frag and Fragnesia is ultimately an attack that craft specific 
bytes with encryption and decryption. Attacker would potentially be able 
to archieve a collision attack on say the record for root in passwd file 
and use it on any machine where their passwd files are in a simular format.

在 2026/5/18 11:17, Herbert Xu 写道:
> On Mon, May 18, 2026 at 10:55:38AM +0800, Scott Guo wrote:
>> BTW, I am wondering whether we should disable inplace decryption for now? I
>> think that to mitigate vulnerabilities like Fragnesia, maybe something has
>> to be done on the memory side. Maybe something like forcing a pagefault when
>> trying to write to these pages?
> 
> I think stopping ESP from putting frags into the dst SG list would
> be prudent until the whole stack has been audited.
> 
> Alternatively switch from the black-list to a white-list approach
> and only allow ESP to do in-place processing of packets from a
> source that's known to be writable.
> 
> Cheers,

