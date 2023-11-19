Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mBrD3wgp"
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E77136
	for <linux-crypto@vger.kernel.org>; Sun, 19 Nov 2023 15:52:55 -0800 (PST)
Message-ID: <ee9e6afb-479e-d38f-9424-5c79feded44d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700437973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ge1ESl70XYT5mVJCTL6jYd0++iV00VntBKPAsXCCsDE=;
	b=mBrD3wgpdEviEZB2Y8gRoDomRsxMCkNEuqRsne8g4QP80QOeBrn9k5Xa05SVZBOImuHV4a
	R/ipDWylkH258pDk0FNWeK12mUNdP2bKNUaEpLfBjuVLEEmVnA1XfSyEpaSFzacLt8w0Lg
	bmxJJmNKByXD4E03VCWNHiSx0jS/ehI=
Date: Sun, 19 Nov 2023 23:52:51 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v5 2/2] selftests: bpf: crypto skcipher algo
 selftests
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Andrii Nakryiko <andrii@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Network Development <netdev@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 bpf <bpf@vger.kernel.org>
References: <20231118225451.2132137-1-vadfed@meta.com>
 <20231118225451.2132137-2-vadfed@meta.com>
 <CAADnVQ+tLbMppLNT7HOV5=k+8075qjjyO5wWEDvLRoPi5WALJw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <CAADnVQ+tLbMppLNT7HOV5=k+8075qjjyO5wWEDvLRoPi5WALJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 19.11.2023 21:58, Alexei Starovoitov wrote:
> On Sat, Nov 18, 2023 at 2:55 PM Vadim Fedorenko <vadfed@meta.com> wrote:
>>
>> +
>> +SEC("fentry.s/bpf_fentry_test1")
>> +int BPF_PROG(skb_crypto_setup)
>> +{
>> +       struct bpf_crypto_lskcipher_ctx *cctx;
>> +       struct bpf_dynptr key = {};
>> +       int err = 0;
>> +
>> +       status = 0;
>> +
>> +       bpf_dynptr_from_mem(crypto_key, sizeof(crypto_key), 0, &key);
>> +       cctx = bpf_crypto_lskcipher_ctx_create(crypto_algo, &key, &err);
> 
> Direct string will work here, right?
> What's the reason to use global var?

Mmm, yeah, should work. I'll update the test, thanks!
