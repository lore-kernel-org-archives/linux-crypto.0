Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81F2483804
	for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 09:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790329084; cv=none; b=Lj534yt+cTQ7nASjEiIkC1hqoxaM+cI/8Rku4OAXWYwIvkWGEHEfhsol6vbcEfsRM+2HkYG85u4SzJ8BanBvx6xuzXb+X7be7nqFvVfScpIR/HBM78RTDluhXA+m3KubELCzwc6KH1NvtqRralaIBdUxFzhE2Em1CQeVqtd9eVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790329084; c=relaxed/simple;
	bh=GVuf0RwGAnGw1eOY1Wiz9rpD1Ddtfsnx5TiLkQhY7AI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X5LBrEBr0LwUyU1n0l3i7yAiq6eJtThpF3tMmapkw7c9Gd93BwVgNEtf2K+O+jQdiqqTL78Ci+2JKJmNy9f4zcHLhZ1JeRkEAZ+HIP2Tc98simXGZk9FbKp72cZzXAJ/tNQdgwuPoBLiW/xd/IMPFWKHF3DAY2n7fJp4k7DJZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IS4Tg+L0; arc=none smtp.client-ip=91.218.175.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IS4Tg+L0"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GVuf0RwGAnGw1eOY1Wiz9rpD1Ddtfsnx5TiLkQhY7AI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790329079; v=1; x=1790933879;
 b=IS4Tg+L0Kzl7QHAiWW4oxb1DHTs04Bp7GVr2vta6iZPcQ4c8LNPlje+dDUHyb+Ol+wnwOAug
 3p11Z2VaYMKQKaFEHCThYsGNrP1HgA0JOLjWmfYwIeDeTNcnZxcGQWJXSMbd33WkRYjYhLR2/1S
 WyxHpZWeMnTAi6ZAxqIhwrqE=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c7f8fb00bf703aa8;
	Fri, 25 Sep 2026 09:37:59 +0000
X-Mizu-Trace-ID: c7f8fb00bf703aa8
X-Migadu-Flow: FLOW_OUT
Message-ID: <840c4c37-99a5-44dd-8b33-67057ee23731@linux.dev>
Date: Fri, 25 Sep 2026 10:37:55 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rhashtable: specialize default comparison for constant
 parameters
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, justinstitt@google.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, morbo@google.com, nathan@kernel.org,
 ndesaulniers@google.com, Thomas Graf <tgraf@suug.ch>,
 nickolay.lysenko@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
 sched-ext@lists.linux.dev, tj@kernel.org, yatsenko@meta.com
References: <20260924184733.2317353-1-usama.arif@linux.dev>
 <arW6ibT1RkVCqTdT@gondor.apana.org.au>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <arW6ibT1RkVCqTdT@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/09/2026 01:04, Herbert Xu wrote:
> On Thu, Sep 24, 2026 at 11:47:33AM -0700, Usama Arif wrote:
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
> 
> Nice work, I'm glad that someone is looking at the assembly :)

Hi Herbert,

Thanks!

> 
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
> If there is no obj_cmpfn then there is no obj_hashfn.  If there
> is no obj_hashfn then params.key_len must be non-zero.  So this
> could become unconditional, perhaps with a comment.

That holds for the params given to rhashtable_init(), but not for the
params passed to the fast-path helpers. The BPF resizable hashmap
passes a constant template with no key_len and no obj_cmpfn
(rhtab_params in kernel/bpf/hashtab.c), and sets key_len only in the
copy it gives to rhashtable_init(). Without the "?: ht->p.key_len",
its lookups would memcmp() zero bytes and return the first object in
the bucket. rht_key_get_hash() has the same fallback for this user,
see c9429bf56405a. (I added Mykyta the author of that patch in CC.)


> 
> Thanks,

