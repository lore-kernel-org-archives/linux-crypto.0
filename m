Received: from mta1.migadu.com (out-243.mta1.migadu.com [95.215.58.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF993939CE
	for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 09:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328736; cv=none; b=Xl0OzPZKdXTUXpQNdOCsveg07TZAWMvPknWmp/ij4RQr9PF7za9LwI44luH9niaq/HnF9uBfdPaYNoThAaxn+hNuTYgn+wojb3jzrBD6AM/vePI3YuaSfAvJ3r6ANVx74mqoWbF1KQ5qcYGSt0qaJoTFt9lIHcaGJy8WH5Kz2LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328736; c=relaxed/simple;
	bh=G3lOU3SX8aj4e8CXfEFntD+e7GdXsWJztD5qbkcR9DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bS454vl2j0YJpgvCjipGVzjOt3c4nIkDN8fy6XnCe1VtGCXEo+UduP+19T3Os6K4ssiiGecUkPZfX2c5CxBzIt2MYPjL4pup7qbGwsGPom8ziSU653EaaExsFz/09QVgtY+u+/dVBYKBDREGH1tM5EUK3PPk7iEjNolJXEKQjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cj0+phUx; arc=none smtp.client-ip=95.215.58.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cj0+phUx"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=G3lOU3SX8aj4e8CXfEFntD+e7GdXsWJztD5qbkcR9DM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790328732; v=1; x=1790933532;
 b=cj0+phUxq5a8+ztUzpjqgMKlmONiVER2ZsXI4zVTipUq1Xsu+kj5uZYYQ2iHdZeScXqfjTZP
 720cxJwqqYUe2CO3n9SaeTS8oiUVZoNvc2NaBb24gAcvfY9BiGnAv2N2PRuo/pSjmlJacTDuMY6
 lM33Lr8uY0SWMMrD+8lKEGUo=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9f56d7cf1df32b31;
	Fri, 25 Sep 2026 09:32:11 +0000
X-Mizu-Trace-ID: 9f56d7cf1df32b31
X-Migadu-Flow: FLOW_OUT
Message-ID: <4be2206b-c6b7-49c2-9acc-de4f409e98dd@linux.dev>
Date: Fri, 25 Sep 2026 10:32:11 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rhashtable: specialize default comparison for constant
 parameters
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, justinstitt@google.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, morbo@google.com, nathan@kernel.org,
 ndesaulniers@google.com, Thomas Graf <tgraf@suug.ch>,
 nickolay.lysenko@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
 sched-ext@lists.linux.dev, tj@kernel.org
References: <20260924184733.2317353-1-usama.arif@linux.dev>
 <20260924221411.0fad5501@pumpkin>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260924221411.0fad5501@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 24/09/2026 22:14, David Laight wrote:
> On Thu, 24 Sep 2026 11:47:33 -0700
> Usama Arif <usama.arif@linux.dev> wrote:
> 
>> The inline lookup and insert helpers receive the rhashtable parameters by
>> value. With a static const parameter block, key_offset and key_len are
>> compile-time constants at the call site.
>>
>> The default comparison throws that information away by reading both fields
>> back from ht->p. Fixed-size keys consequently load the parameters and call
>> bcmp() for every object in the bucket, even when the compiler could use
>> scalar comparisons instead.
>>
>> The commit "sched_ext: Specialize the DSQ hashtable compare" [1] resulted
>> in a 2.9x faster DSQ lookup after replacing this path for its u64 key
>> with a scalar comparison. Doing that through obj_cmpfn requires every
>> fixed-key user to provide its own callback.
>>
>> Pass the call-site parameters to rhashtable_compare(), as
>> rht_key_get_hash() already does. Use them when key_len is a compile-time
>> constant. Retain the ht->p path for dynamic parameter blocks. A constant
>> zero key_len continues to take the runtime length from ht->p.key_len.
>>
>> This specializes the default comparison for all fixed-size users. With
>> Clang 22 on x86-64, bcmp() disappears from sched_ext, mac80211, NFSd,
>> TIPC, NFQUEUE, VFS superblock, pidfs, SysV IPC and hardware-breakpoint
>> table paths. The affected build_policy.o, sta_info.o and nfsd filecache.o
>> text shrinks by 512, 400 and 352 bytes respectively. Four- and eight-byte
>> keys become direct scalar comparisons; six-byte MAC addresses become a
>> four-byte and a two-byte comparison.
>>
>> Measure the VFS case with ustat() on a mounted ramfs. This exercises
>> user_get_super() and its super_dev lookup. Across ten interleaved baseline
>> and patched VM boot pairs, with five 3 million call samples per boot, the
>> average per-boot median latency drops from 477.2 to 462.6 ns per call, or
>> 3.0%. All ten pairs improved.
>>
>> No functional change intended.
>>
>> [1] https://lore.kernel.org/all/20260921171928.1639407-1-usama.arif@linux.dev/
>>
>> Suggested-by: Mykola Lysenko <nickolay.lysenko@gmail.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  include/linux/rhashtable.h | 20 +++++++++++++++-----
>>  lib/rhashtable.c           |  5 +++--
>>  2 files changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
>> index 57a2a29bef0e8..c9872965b753c 100644
>> --- a/include/linux/rhashtable.h
>> +++ b/include/linux/rhashtable.h
>> @@ -598,13 +598,23 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
>>  	for (pos = list; pos && rht_entry(tpos, pos, member);		\
>>  	     pos = rcu_dereference_all(pos->next))
>>  
>> -static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
>> -				     const void *obj)
>> +/*
>> + * Use constant params from inlined callers to specialize memcmp(). If params
>> + * isn't constant, it must be equal to ht->p.
>> + */
>> +static __always_inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
>> +					      const void *obj,
>> +					      const struct rhashtable_params params)
>>  {
>>  	struct rhashtable *ht = arg->ht;
>>  	const char *ptr = obj;
>>  
>> -	return memcmp(ptr + ht->p.key_offset, arg->key, ht->p.key_len);
>> +	if (!__builtin_constant_p(params.key_len))
>> +		return memcmp(ptr + ht->p.key_offset, arg->key,
>> +			      ht->p.key_len);
>> +
>> +	return memcmp(ptr + params.key_offset, arg->key,
>> +		      params.key_len ? : ht->p.key_len);
> 
> That looks strange to me.
> If ht->p.key_len/offset can be different from params.key_len/offset I can't
> see why that shouldn't happen when params is constant.

Hi David,

Thanks for taking a look!

They mustn't differ: the inline helpers take the same params that were
passed to rhashtable_init(). The only exception is a constant key_len of
0, which means the length is only known at init time (the BPF resizable
hashmap does this). That's why the constant arm has "?: ht->p.key_len".

So both arms compare the same bytes, and the split only tells the
compiler which copy to read. rht_key_get_hash() has done the same since
de91b25c8011 from Herbert.

> If ht->p is likely to be a pointer to the associated params, you are passed
> the params, they match and params is constant then you can optimise.
> But that needs the address compare in the calling code (outside any look).
> 

ht->p is a copy embedded in struct rhashtable, not a pointer, so there's
no address to compare. __builtin_constant_p() is resolved at compile
time, so there's no runtime branch either.


> David 
> 
>>  }
>>  
>>  /* Internal function, do not use. */
>> @@ -632,7 +642,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
>>  		rht_for_each_rcu_from(he, __rht_ptr_rcu(bkt, freq), tbl, hash) {
>>  			if (params.obj_cmpfn ?
>>  			    params.obj_cmpfn(&arg, rht_obj(ht, he)) :
>> -			    rhashtable_compare(&arg, rht_obj(ht, he)))
>> +			    rhashtable_compare(&arg, rht_obj(ht, he), params))
>>  				continue;
>>  			return he;
>>  		}
>> @@ -797,7 +807,7 @@ static __always_inline void *__rhashtable_insert_fast(
>>  		if (!key ||
>>  		    (params.obj_cmpfn ?
>>  		     params.obj_cmpfn(&arg, rht_obj(ht, head)) :
>> -		     rhashtable_compare(&arg, rht_obj(ht, head)))) {
>> +		     rhashtable_compare(&arg, rht_obj(ht, head), params))) {
>>  			pprev = &head->next;
>>  			continue;
>>  		}
>> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
>> index 6362896e4f099..9d9f03b59c823 100644
>> --- a/lib/rhashtable.c
>> +++ b/lib/rhashtable.c
>> @@ -548,7 +548,7 @@ static void *rhashtable_lookup_one(struct rhashtable *ht,
>>  		if (!key ||
>>  		    (ht->p.obj_cmpfn ?
>>  		     ht->p.obj_cmpfn(&arg, rht_obj(ht, head)) :
>> -		     rhashtable_compare(&arg, rht_obj(ht, head)))) {
>> +		     rhashtable_compare(&arg, rht_obj(ht, head), ht->p))) {
>>  			pprev = &head->next;
>>  			continue;
>>  		}
>> @@ -710,7 +710,8 @@ static struct rhash_head *__rhashtable_next_in_table(
>>  		rht_for_each_rcu(he, tbl, b) {
>>  			bool match = params.obj_cmpfn
>>  				     ? !params.obj_cmpfn(&arg, rht_obj(ht, he))
>> -				     : !rhashtable_compare(&arg, rht_obj(ht, he));
>> +				     : !rhashtable_compare(&arg, rht_obj(ht, he),
>> +						   params);
>>  			if (found) {
>>  				if (match)
>>  					continue;
> 

