Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hDNVZNuf"
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E94A9;
	Sun,  3 Dec 2023 12:00:52 -0800 (PST)
Message-ID: <84d81e44-b3eb-c4d0-aad3-6014fd7cef43@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701633650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrcuaLhGqZyLcCzhjZbCK/3gCaj2ccG1Zvyabs5yjRI=;
	b=hDNVZNufE6YSFIU1lV56tX4eUvDPKxP/PH9VGERwhswSJqv0lSXJkRriWUAYeArvbT2M4X
	jTRb5nyR92hX7oJ0NpE4GXP/Ga0vyingFtx5RDfV8iZQ8dFxVwTzkzl35Tq6XV8ZohF4P6
	8v01eZJEJAW/VWDohj5ljebycZTU5vg=
Date: Sun, 3 Dec 2023 20:00:48 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v7 2/3] bpf: crypto: add skcipher to bpf crypto
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Andrii Nakryiko <andrii@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org, bpf@vger.kernel.org
References: <20231202010604.1877561-1-vadfed@meta.com>
 <20231202010604.1877561-2-vadfed@meta.com>
 <ZWqp4VF+4rX/plpX@gondor.apana.org.au>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <ZWqp4VF+4rX/plpX@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 02.12.2023 03:52, Herbert Xu wrote:
> On Fri, Dec 01, 2023 at 05:06:03PM -0800, Vadim Fedorenko wrote:
>>
>> +static int bpf_crypto_lskcipher_encrypt(void *tfm, const u8 *src, u8 *dst,
>> +					unsigned int len, u8 *iv)
>> +{
>> +	return crypto_lskcipher_encrypt(tfm, src, dst, len, iv);
>> +}
> 
> Please note that the API has been updated and the iv field is now
> the siv.  For algorithms with a non-zero statesize, that means that
> the IV must be followed by enough memory to store the internal state,
> i.e., crypto_lskcipher_statesize(tfm).
> 
> Thanks,

Hi Herbert!

Thanks for the reminder. I have read v3 of your patchset and AFAIU only arc4
is affected right now. All other algorithms still have statesize=0, so should
work without any changes. I'll make a TODO note for myself to add state size
check in bpf_crypto part once different trees are merged during merge window.

Am I right that it only affects skcipher and AEAD crypto will not be changed?

Thanks,
Vadim
