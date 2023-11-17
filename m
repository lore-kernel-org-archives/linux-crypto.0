Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EFH9+cEm"
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53745D6E
	for <linux-crypto@vger.kernel.org>; Fri, 17 Nov 2023 06:11:07 -0800 (PST)
Message-ID: <e4d76f14-5045-4935-b699-e84beb645652@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700230262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jvqlH893Qs090gMuZDW5woR6FI1KAQph3q4L6Hte+EM=;
	b=EFH9+cEmZcxTOoHKRuzmVXsgHzBoYX8ZmX9ShQV5ZQbC9O8C3SJL4bKxqHz3UM7U0Y6tN+
	Z18iX65If7sYZttBVniYAzy9v4gPLrKxhdKR74ii/Yc2b3Pm+gMH2alIsECUdwAQ/OU2Pb
	f2cpDgEN4OW1N3GzdC+YbgELU2uep8Y=
Date: Fri, 17 Nov 2023 09:10:59 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 1/2] bpf: add skcipher API support to TC/XDP
 programs
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Martin KaFai Lau <martin.lau@linux.dev>
Cc: kuba@kernel.org, andrii@kernel.org, ast@kernel.org, mykolal@fb.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <ZVblI/mbqFsdVI00@gondor.apana.org.au>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <ZVblI/mbqFsdVI00@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 16/11/2023 19:59, Herbert Xu wrote:
> Vadim Fedorenko <vadfed@meta.com> wrote:
>> Add crypto API support to BPF to be able to decrypt or encrypt packets
>> in TC/XDP BPF programs. Only symmetric key ciphers are supported for
>> now. Special care should be taken for initialization part of crypto algo
>> because crypto_alloc_sync_skcipher() doesn't work with preemtion
>> disabled, it can be run only in sleepable BPF program. Also async crypto
>> is not supported because of the very same issue - TC/XDP BPF programs
>> are not sleepable.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> 
> Please use the newly introduced lskcipher interface instead of
> skcipher.

Oh, sounds like we do have proper API to work with buffers directly!
Thanks for pointing to it, I'll send v5 soon.

