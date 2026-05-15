Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A769A392803
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 11:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778842953; cv=none; b=PE4b0xsM9D13aPlGf4ixpunODaTO1f949Qe8cNgMs/lPj08xv2yIqEg1vIyTLPJdzWuxvsv4LWshTwwPsDiiRAqCq0MnJb2CDi1u4joiK7LXGYsSr45dROQOPCugs3fdNKnLAhw5AMypDGbty1jC/KfV2LWF+KkMQ2t6/9wEEQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778842953; c=relaxed/simple;
	bh=1VVmTrxLANcNrbmtA9jer+iU7f8E5tJonJdKYGFdLIw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PUmAmS9TBjPzYdSZsXpX3Q/6fHIVSZ4m98RQ79qnAAqcn44GvQkgtXbdWwiHys9ESXIrHfNcXmnYzf7tZDUyLweOfpLha179Le/o6TCYkeuMzLXtREXx8lOkRqg+od8OVGgSfvo0P4Sot06lOoD3PPqfkjPJ4Kl5qEk8E2hHA+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=joUQTR4A; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="joUQTR4A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:To:
	Content-Type; bh=FzQ+IVCJ8DZCHlotAaZljsZ4u0kCy4Nrun2GgxcGPsY=;
	b=joUQTR4AyulPmpwPsxi0Jb3DIQZAvCvGK17fcah0yzFoxDVcsbeL4PN1YOtdlC
	NyH96NK+K+7L4uSH1TxiAotU3yswaPXd0Q1SQ8ECJpe9N4FAVYbkh8MA7ynDftw1
	h7DmQUT/K0CcKYDcM7frGY7uge7nJcYq6V73bsRyZXZEM=
Received: from [127.0.0.1] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3XykX_QZqABqkBQ--.46078S2;
	Fri, 15 May 2026 19:01:43 +0800 (CST)
Message-ID: <8aaa00f3-d8e0-4de0-918b-1f025b632eb9@163.com>
Date: Fri, 15 May 2026 19:01:43 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] authencesn: Refactor in-place decryption
From: Scott Guo <scott_gzh@163.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, Scott GUO <scottzhguo@tencent.com>
References: <20260515083645.4024574-1-scott_gzh@163.com>
 <4e9aee15-62e6-4d71-a836-250c5376a8fd@163.com>
In-Reply-To: <4e9aee15-62e6-4d71-a836-250c5376a8fd@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3XykX_QZqABqkBQ--.46078S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF4kuFWftw13Ww1ruw4fuFg_yoWkXrc_WF
	WvyF9xJw4DWF4kAasxXFyDJ34xWr47XF1Yka1IqrZ3GFy7GrykuFn2qry7Z3Zruay8Grnr
	G398X34fJrnxZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREWEE7UUUUU==
X-CM-SenderInfo: hvfr33hbj2xqqrwthudrp/xtbCxBegPmoG-RcrXQAA39

Another thought: even with this fix, Fragnesia should still funciton. It 
just block current PoCs which pass in the page cache in the position for 
auth data.

Avoid changing the auth part would not be enough because attacker would 
still be able to link a page cache page within the cryptlen part and 
override it with the 4 bytes from sequence number.

在 2026/5/15 18:41, Scott Guo 写道:
> BTW, this should fix the Fragnesia vulnerability.
> 
> 在 2026/5/15 16:36, scott_gzh@163.com 写道:
>> From: Scott GUO <scottzhguo@tencent.com>
>>
>> This patch set introduced the sglist_shift_{left,right} helper
>> and refactor the sequence number handling for authencesn
>> decryption. Avoiding write to the auth part of the sg list.
>>
>> Scott GUO (2):
>>    scatterlist: Introduce sglist_shift_{left,right} helpers
>>    authencesn: Refactor inplace-decryption with sglist shift helper
>>
>>   crypto/authencesn.c          | 38 ++++++-----------
>>   crypto/scatterwalk.c         | 79 ++++++++++++++++++++++++++++++++++++
>>   include/crypto/scatterwalk.h |  6 +++
>>   3 files changed, 97 insertions(+), 26 deletions(-)
>>

