Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45EE22F07
	for <linux-crypto@vger.kernel.org>; Wed, 27 Dec 2023 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q7Y7795a"
Message-ID: <4b2f3c71-738b-4b6f-9c38-b10f0c6c7ff0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703669321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FAjKd+UfTbwEkS6TOy8xK94TJjrGh/1CFpp3G699mKM=;
	b=Q7Y7795aJHGA5qgK9Nw5KUwdCKCraxwbH04AvkFoRWRc/Jld8OVmujbrlPQLhYHZ0mJHJd
	FrBaMgPxRWc5XWP8/peasJ4J5wOHPIppDJq5nxsQmbNHSjY4lAH1QJ1AxzJk9UrXwdGebm
	aqzkYmVbaNQ8yieh9LhcTwVMWA4zbxw=
Date: Wed, 27 Dec 2023 17:28:35 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] crypto: scompress - fix req->dst buffer overflow
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 nphamcs@gmail.com, syzkaller-bugs@googlegroups.com, yosryahmed@google.com,
 21cnbao@gmail.com, zhouchengming@bytedance.com,
 syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com
References: <0000000000000b05cd060d6b5511@google.com>
 <20231227065043.2730440-1-chengming.zhou@linux.dev>
 <ZYvtqW7TAm6mCelt@gondor.apana.org.au>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <ZYvtqW7TAm6mCelt@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2023/12/27 17:26, Herbert Xu wrote:
> On Wed, Dec 27, 2023 at 06:50:43AM +0000, chengming.zhou@linux.dev wrote:
>> From: Chengming Zhou <zhouchengming@bytedance.com>
>>
>> The req->dst buffer size should be checked before copying from the
>> scomp_scratch->dst to avoid req->dst buffer overflow problem.
>>
>> Fixes: 1ab53a77b772 ("crypto: acomp - add driver-side scomp interface")
>> Reported-by: syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/all/0000000000000b05cd060d6b5511@google.com/
>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>> ---
>>  crypto/scompress.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/crypto/scompress.c b/crypto/scompress.c
>> index 442a82c9de7d..e654a120ae5a 100644
>> --- a/crypto/scompress.c
>> +++ b/crypto/scompress.c
>> @@ -117,6 +117,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>>  	struct crypto_scomp *scomp = *tfm_ctx;
>>  	void **ctx = acomp_request_ctx(req);
>>  	struct scomp_scratch *scratch;
>> +	unsigned int dlen;
>>  	int ret;
>>  
>>  	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
>> @@ -128,6 +129,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>>  	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
>>  		req->dlen = SCOMP_SCRATCH_SIZE;
>>  
>> +	dlen = req->dlen;
>> +
>>  	scratch = raw_cpu_ptr(&scomp_scratch);
>>  	spin_lock(&scratch->lock);
>>  
>> @@ -145,6 +148,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
>>  				ret = -ENOMEM;
>>  				goto out;
>>  			}
>> +		} else if (req->dlen > dlen) {
>> +			ret = -ENOMEM;
>> +			goto out;
> 
> I think ENOMEM is ambiguous, perhaps ENOSPC?

Right, ENOSPC is better. Should I send a v2?

Thanks.
