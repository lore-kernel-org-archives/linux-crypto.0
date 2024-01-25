Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDCC2C68E
	for <linux-crypto@vger.kernel.org>; Thu, 25 Jan 2024 11:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706181566; cv=none; b=ry+0Y235bc37yk53F+K/dtyQiNJRlGWa4beSBiZCT9dM4JznZ8agVz7k+SMmyPSpVC3CN2J/Z6SB5w2CgAM5B7w4J/JZbMoxAc+iCAensvRfKB2kRsgOm04F/BbFHIXHSXEQ3FK+yXNlNRng8gvQs6z0Vp538moZQNQBBYK1IIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706181566; c=relaxed/simple;
	bh=xKAsoMcYtFoyZPEPpTE0PQGxfXqVqP/pt/GlEQ4Bizo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8dh7Sam5uBzjAHjHQSehxOTdvmMYXZSdQZXwHfu0Lr0BUQxgrEKK6jeIZ5o7qyN5SZcevetG3jFeHODYsbrUpyuJNcLPGraTsZjFIgpXxoBqYqWaUOgmTEGdAiQv8YCCOlWuXPK/iQePzDHkUt1HABGhVpQX0Lpz/zidzC31m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JY3dvuhI; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JY3dvuhI"
Message-ID: <a682b902-37a2-4d43-8f39-56ca213f6663@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706181562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8URD1vAOHrfsrYKDP5G3s1YP4WHQXpABy6Lvzc8bus=;
	b=JY3dvuhI05AEZr9tYAf6eR1MXe/uXQ+eBRG9klw71qQ49wt0jA69SHS87vhtky8eoD5N7P
	e96zcDc1oWQc/cxtjeKZv8LEJSxiRNMlniXHMb797AL88bYM+PpeyCLxxzlJF1XFkoqA/Y
	omXTF0mHtAwZd2B1u+j5Py6DuAURyMQ=
Date: Thu, 25 Jan 2024 11:19:17 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v8 1/3] bpf: make common crypto API for TC/XDP
 programs
Content-Language: en-US
To: Martin KaFai Lau <martin.lau@linux.dev>, Vadim Fedorenko <vadfed@meta.com>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 bpf@vger.kernel.org, Victor Stewart <v@nametag.social>,
 Jakub Kicinski <kuba@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20240115220803.1973440-1-vadfed@meta.com>
 <3d2d5f4e-c554-4648-bcec-839d83585123@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <3d2d5f4e-c554-4648-bcec-839d83585123@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 25/01/2024 01:10, Martin KaFai Lau wrote:
> On 1/15/24 2:08 PM, Vadim Fedorenko wrote:
>> +static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
>> +                const struct bpf_dynptr_kern *src,
>> +                struct bpf_dynptr_kern *dst,
>> +                const struct bpf_dynptr_kern *siv,
>> +                bool decrypt)
>> +{
>> +    u32 src_len, dst_len, siv_len;
>> +    const u8 *psrc;
>> +    u8 *pdst, *piv;
>> +    int err;
>> +
>> +    if (ctx->type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY)
> 
> nit. Does the indirect call get_flags() return different values?
> Should it be rejected earlier, e.g. in bpf_crypto_ctx_create()?

Well, that is the common pattern in crypto subsys to check flags.
But after looking at it second time, I think I have to refactor this
part. CRYPTO_TFM_NEED_KEY is set during tfm creation if algo requires
the key. And it's freed when the key setup is successful. As there is no
way bpf programs can modify tfm directly we can move this check to
bpf_crypto_ctx_create() to key setup part and avoid indirect call in 
this place.
> 
>> +        return -EINVAL;
>> +
>> +    if (__bpf_dynptr_is_rdonly(dst))
>> +        return -EINVAL;
>> +
>> +    siv_len = __bpf_dynptr_size(siv);
>> +    src_len = __bpf_dynptr_size(src);
>> +    dst_len = __bpf_dynptr_size(dst);
>> +    if (!src_len || !dst_len)
>> +        return -EINVAL;
>> +
>> +    if (siv_len != (ctx->type->ivsize(ctx->tfm) + 
>> ctx->type->statesize(ctx->tfm)))
> 
> Same here, two indirect calls per en/decrypt kfunc call. Does the return 
> value change?

I have to check the size of IV provided by the caller, and then to avoid
indirect calls I have to store these values somewhere in ctx. It gives a
direct access to these values to bpf programs, which can potentially
abuse them. Not sure if it's good to open such opportunity.

> 
>> +        return -EINVAL;
>> +
>> +    psrc = __bpf_dynptr_data(src, src_len);
>> +    if (!psrc)
>> +        return -EINVAL;
>> +    pdst = __bpf_dynptr_data_rw(dst, dst_len);
>> +    if (!pdst)
>> +        return -EINVAL;
>> +
>> +    piv = siv_len ? __bpf_dynptr_data_rw(siv, siv_len) : NULL;
>> +    if (siv_len && !piv)
>> +        return -EINVAL;
>> +
>> +    err = decrypt ? ctx->type->decrypt(ctx->tfm, psrc, pdst, src_len, 
>> piv)
>> +              : ctx->type->encrypt(ctx->tfm, psrc, pdst, src_len, piv);
>> +
>> +    return err;
>> +}
> 

