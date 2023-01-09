Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531DFC54EBE
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 21:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbjAIVOD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 16:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237981AbjAIVMn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 16:12:43 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E3777ADF
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 13:08:41 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so10167864wms.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2023 13:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VjiYxol0UlpN19kTUs+sSn5eQ9eumRPyWwhTVbAm3NM=;
        b=HENpSiMQ5wTk1q+vNHgQ1DQwXKi7pkSma3Brl7DbwYdY7K5OH7UnVwhqtSA0l4A2zk
         zh/3fnQGvVBimNnb49dV5xtjo7zdGYiVCJEoQlQhU2dlwGgQqE69Qk/xN0ip25PMGOfo
         tknz16N6UtKCfWusSCre/bdPkwDfwzxy3LlwS7cjSqf8HnA5v+dsTGPlEhMeaJ7ycK7T
         OnGWm+SAgmb9tJhyAhzCQgWL50a83yDyoRAW/uofILcxiZIHVIegPSE9PhZVQQP6jR+p
         DJA/ezngVdlcn5Jw4nLKleZYkCGhtERiYdud28rKm4WJ7i4bkEw0Vgg/wMTxvhq2kAye
         wprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VjiYxol0UlpN19kTUs+sSn5eQ9eumRPyWwhTVbAm3NM=;
        b=fUGS5XWo3vMjkxfVvUDAcbDnUKEC8s2heVQ5S9LRqZmQxB+x7+nr7EnwXzPjXPZnUL
         357KAbK/T+zYIWLqxtLYO+7fsSDLqQ+IJjAmMbJqilRp/a3si5lKHaRwwb0zE8KOwIAW
         7uNIipwxKzUYGEDtLJjfO3F1jWKCCeskSELBNECa79WSvMLKJpTiQ7AOnleJLjEd63Yv
         zx0touptGfxn7rNqkvwNM+sU9kfkKXFsj57haf71me9bJZA+ypvYlNoPEI7MpdXxKyue
         b3N8TmIwGlUplGo0phMOlM9Yx/GZdLweNl6gP9NzZ2Y4a1wti+CCUt0cyBZzARv/ixNh
         IGGA==
X-Gm-Message-State: AFqh2kp42ZHETSIXWfvBFRYDTHw6/F50DDhiKwqUEMdrRf6mWaaw2yUU
        ndSjbrUHXU+4CWRCIQ7KXSIG5w==
X-Google-Smtp-Source: AMrXdXvq3f1yfzc7obUZ8s8GPpwYCBrPBLs811ZKIpNtqPnIGPbR3hsAhbT0ayWPMKPnVXHB7LSf2g==
X-Received: by 2002:a05:600c:35cc:b0:3d3:3c93:af34 with SMTP id r12-20020a05600c35cc00b003d33c93af34mr57833164wmq.2.1673298520520;
        Mon, 09 Jan 2023 13:08:40 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id iv14-20020a05600c548e00b003b47b80cec3sm19629250wmb.42.2023.01.09.13.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:08:39 -0800 (PST)
Message-ID: <262dd341-5b6e-875c-0ded-03b5135ea9ad@arista.com>
Date:   Mon, 9 Jan 2023 21:08:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/5] crypto/pool: Add crypto_pool_reserve_scratch()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230103184257.118069-1-dima@arista.com>
 <20230103184257.118069-3-dima@arista.com>
 <20230106180427.2ccbea51@kernel.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20230106180427.2ccbea51@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/7/23 02:04, Jakub Kicinski wrote:
> On Tue,  3 Jan 2023 18:42:54 +0000 Dmitry Safonov wrote:
>> Instead of having build-time hardcoded constant, reallocate scratch
>> area, if needed by user. Different algos, different users may need
>> different size of temp per-CPU buffer. Only up-sizing supported for
>> simplicity.
> 
>> -static int crypto_pool_scratch_alloc(void)
>> +/* Slow-path */
>> +/**
>> + * crypto_pool_reserve_scratch - re-allocates scratch buffer, slow-path
>> + * @size: request size for the scratch/temp buffer
>> + */
>> +int crypto_pool_reserve_scratch(unsigned long size)
> 
> Does this have to be a separate call? Can't we make it part of 
> the pool allocation? AFAICT the scratch gets freed when last
> pool is freed, so the user needs to know to allocate the pool
> _first_ otherwise there's a potential race:
> 
>  CPU 1               CPU 2
> 
>  alloc pool
>                     set scratch
>  free pool
>  [frees scratch]
>                     alloc pool

Yeah, I think it will be cleaner if it was an argument for
crypto_pool_alloc_*() and would prevent potential misuse as you
describe. Which also means that I don't have to declare
crypto_pool_scratch_alloc() in patch 1, will just add a new parameter in
this patch to alloc function.

> 
>>  {
>> -	int cpu;
>> -
>> -	lockdep_assert_held(&cpool_mutex);
>> +#define FREE_BATCH_SIZE		64
>> +	void *free_batch[FREE_BATCH_SIZE];
>> +	int cpu, err = 0;
>> +	unsigned int i = 0;
>>  
>> +	mutex_lock(&cpool_mutex);
>> +	if (size == scratch_size) {
>> +		for_each_possible_cpu(cpu) {
>> +			if (per_cpu(crypto_pool_scratch, cpu))
>> +				continue;
>> +			goto allocate_scratch;
>> +		}
>> +		mutex_unlock(&cpool_mutex);
>> +		return 0;
>> +	}
>> +allocate_scratch:
>> +	size = max(size, scratch_size);
>> +	cpus_read_lock();
>>  	for_each_possible_cpu(cpu) {
>> -		void *scratch = per_cpu(crypto_pool_scratch, cpu);
>> +		void *scratch, *old_scratch;
>>  
>> -		if (scratch)
>> +		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
>> +		if (!scratch) {
>> +			err = -ENOMEM;
>> +			break;
>> +		}
>> +
>> +		old_scratch = per_cpu(crypto_pool_scratch, cpu);
>> +		/* Pairs with crypto_pool_get() */
>> +		WRITE_ONCE(*per_cpu_ptr(&crypto_pool_scratch, cpu), scratch);
> 
> You're using RCU for protection here, please use rcu accessors.

Will do.

> 
>> +		if (!cpu_online(cpu)) {
>> +			kfree(old_scratch);
>>  			continue;
>> +		}
>> +		free_batch[i++] = old_scratch;
>> +		if (i == FREE_BATCH_SIZE) {
>> +			cpus_read_unlock();
>> +			synchronize_rcu();
>> +			while (i > 0)
>> +				kfree(free_batch[--i]);
>> +			cpus_read_lock();
>> +		}
> 
> This is a memory allocation routine, can we simplify this by
> dynamically sizing "free_batch" and using call_rcu()?
> 
> struct humf_blah {
> 	struct rcu_head rcu;
> 	unsigned int cnt;
> 	void *data[];
> };
> 
> cheezit = kmalloc(struct_size(blah, data, num_possible_cpus()));
> 
> for_each ..
> 	cheezit->data[cheezit->cnt++] = old_scratch;
> 
> call_rcu(&cheezit->rcu, my_free_them_scratches)
> 
> etc.
> 
> Feels like that'd be much less locking, unlocking and general
> carefully'ing.

Will give it a try for v3, thanks for the idea and review,
          Dmitry

