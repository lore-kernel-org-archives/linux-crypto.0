Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 567E2E56F;
	Tue, 22 Apr 2025 01:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745285466; cv=none; b=FgHnx6Rfy3XGWu1lfpf294c/sZB3HwSdv0lURJbZFV+4BrnWuhUFtqN48ozQppO9nx4+Jt7ig7BTN0Lr7INx0D4wCkxrywXZ+QkppC0hylVMQUFbJ4wNzUnfxGNgQPmJkZKXi5/Mmh8a1Hm1LFDR3LSvwUR7C0LSpYiFyJcMciQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745285466; c=relaxed/simple;
	bh=2tNz2kXv3jashg49t3WWsa6T2n5qO7jpbD0oOspi6CU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type; b=Q08W3SK9FamBg2fwyFHEufSvWajBPazR+tU54UC6AjJxuyRtrGEDKUfOouZgQ6atB6o/ihcBKbLX2SO6mZCfJn4E2ExlEloNteUBa4mIe8dzf3VI12Yz91GrL0XI28xOY0Z79JLtMTYe9gbR9d0YiDRCn9d7ykdNefAMJzn+p+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from [172.30.20.101] (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id B8DED60107F45;
	Tue, 22 Apr 2025 09:30:55 +0800 (CST)
Message-ID: <e7f3efae-3571-46c0-9035-2a763990527f@nfschina.com>
Date: Tue, 22 Apr 2025 09:30:55 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Language: en-US
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
In-Reply-To: <aAY0lyWzsRVDge_f@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/4/21 20:05, Herbert Xu wrote:
> On Mon, Apr 21, 2025 at 01:51:06PM +0800, Su Hui wrote:
>> @@ -433,7 +434,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
>>   {
>>   	struct aead_request *req;
>>   
>> -	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
>> +	req = kmalloc(size_add(sizeof(*req), crypto_aead_reqsize(tfm)), gfp);
> This is just wrong.  You should fail the allocation altogether
> rather than proceeding with a length that is insufficient.
>
> However, reqsize shouldn't be anywhere near overflowing in the
> first place.  If you're truly worried about this, you should
> change the algorithm registration code to check whether reqsize
> is sane.
>
> And that needs to wait until the algorithms are fixed to not use
> dynamic reqsizes.
Got it, thanks for your explanation.
This patch (v1 and v2) is wrong.  Sorry for the noise again.

Su Hui

