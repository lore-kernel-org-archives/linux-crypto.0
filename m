Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TSQ7UUC/"
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33358DA
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 10:43:45 -0800 (PST)
Message-ID: <676411df-cd7a-a1d5-4226-f67d0b50ea80@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701629023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBz9LymNCxeqZZMoXDw/zmthZk9wncxavL+5neEQduU=;
	b=TSQ7UUC/Hqi6LOte+31Y8ksb/IJpFzKPqfEQ8gz5XOfbEL1kViaZ+l2+ndj//e0trk16Qo
	zz6Kez4w0qC4fZUxwxzugJMWfKp6K3N+dVlkX3QYFckM0bGYWbbIEUmMIlkqb2TFkdMPYw
	pm6qWA49laKSHkWa2JjVadADD+WoCxs=
Date: Sun, 3 Dec 2023 18:43:41 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v7 3/3] selftests: bpf: crypto skcipher algo
 selftests
Content-Language: en-US
To: Simon Horman <horms@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Andrii Nakryiko <andrii@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, bpf@vger.kernel.org
References: <20231202010604.1877561-1-vadfed@meta.com>
 <20231202010604.1877561-3-vadfed@meta.com>
 <20231203105912.GE50400@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20231203105912.GE50400@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 03.12.2023 10:59, Simon Horman wrote:
> On Fri, Dec 01, 2023 at 05:06:04PM -0800, Vadim Fedorenko wrote:
>> Add simple tc hook selftests to show the way to work with new crypto
>> BPF API. Some weird structre and map are added to setup program to make
> 
> Hi Vadim,
> 
> as it looks like there will be a new revision of this series,
> please consider updating the spelling of structure.
>

Hi Simon!

Thanks for pointing it out. Actually with alignment fixes in BPF UAPI this
sentence is no longer actual and the test program is rewritten without
hacks. I'll remove this from commit message in new revision.

>> verifier happy about dynptr initialization from memory. Simple AES-ECB
>> algo is used to demonstrate encryption and decryption of fixed size
>> buffers.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> 
> ...

