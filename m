Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793793216;
	b=FQ21hQz57OYSB59DkxiotaADWQz8f8hbe/tSWate5D7Uu3StgxgimHfkQnP0zwRV9Ydg
	 cve4I2Xq9+HvrDV1KLEhjQlkXdG1eHX57pghX8Frts5V+YYx8TdVjodx1LcjoPUysf1Ff
	 VsfWA0G5WtUMtfkw8RK5G/p2YljTytUlZKMbZ79EbVBqLAuyYq7v0z9j6te9+2p9pHYa/
	 qzl0VubK2ZG7a1npAI1NB+iy3QZ+JSjTdYquBhpEFeFhNvgzOJ+8vdlPBLc/sDWLxNKz4
	 FHjjji0h6/pjluFp+5a5QeLFPKH3eLeivwRGkEfqcadgcQH1pD5122AE6oaF7ed7dUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793793216;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=I7g8O9XnBkOnRo4UInvEGJ58/pb8j1Hf4MI5iyCwU3U=;
	b=KN4SU7v5qJDhTIt5KMj50q+tKP0F/p1z0K0CsXE9VnOUr00uK1dIVwhfoJx83bw4n9Xh
	 oFcmTBKsEHsk0P+qKkyRfF5JHR5M2bADTYI3mavDTWu1QK3u6UEMIwGGaVsPpP0cyzTV+
	 qZYe3NHLkBpJYgKGtiKcF6DUxTIuThJ+d+U+FRfiaBoXU2Hhm3ByDiZFyWLk+PihDGdxl
	 x746NfVF/lfCpMxE0M+CaC8FjBI0FnLcCe4oYY3eeNQHXgihCW6JAGZ3tO/lcotvMRDiT
	 VBpME6yWR3J0M5RT1u17K1PhH3tQtsnn/N8CKmhlf/EUTUMeKbnnYZPyStaSQke38FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=STWBsNjy;
	arc=none smtp.remote-ip=91.218.175.138
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472D8606A331
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 11:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 472D8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=STWBsNjy
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ci2Pt7fChn/3//APtQJ06s/FAY3b1ZNy/PHgjeitdbk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793793214; v=1; x=1794398014;
 b=STWBsNjy3OEtxWmyE5iaSLwm8DvkGZrHmsrFyq66NcpMmt2CgrDej3GNo9bb9XpKcUwddJn5
 TY1G23S7w4JmV6Adwmp02sV6HWQs3XoYGMIK9JkKINLq8K5r9E9IksdnvIKyK+g/LCUkocIsmYs
 iR8pic90BS8Z4GNlRrpQphpw=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id faccf47d409c8a15;
	Wed, 04 Nov 2026 11:53:34 +0000
X-Mizu-Trace-ID: faccf47d409c8a15
X-Migadu-Flow: FLOW_OUT
Message-ID: <9a335f59-79ef-4c32-b6f6-1e66dc03cc2e@linux.dev>
Date: Wed, 4 Nov 2026 11:53:29 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, dsterba@suse.com,
 hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 nphamcs@gmail.com, terrelln@fb.com, yosry@kernel.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org,
 herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, kernel-team@meta.com
References: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com>
 <20261103142600.279899-1-usama.arif@linux.dev>
 <CACpmpodmeJB5FssJdfFxF+A2PkrC+=hnWGn=F_fTbbEtDfRF_A@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CACpmpodmeJB5FssJdfFxF+A2PkrC+=hnWGn=F_fTbbEtDfRF_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 03/11/2026 22:05, Kanchana P. Sridhar wrote:
> On Tue, Nov 3, 2026 at 6:26 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> On Mon, 12 Oct 2026 17:21:40 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:
>>
>>> On Fri, Oct 9, 2026 at 6:31 PM Usama Arif <usama.arif@linux.dev> wrote:
>>>>
>>>> Stores and loads serialize on the same per-CPU acomp request and mutex.
>>>> A low-priority store can be preempted as soon as the compressor drops
>>>> its stream lock, while it still holds the mutex. A higher-priority load
>>>> on that CPU then waits until the store runs again, which can take a
>>>> long time when other tasks are runnable.
>>>>
>>>> Give compression and decompression their own request, completion wait
>>>> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
>>>> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
>>>> compression, so group it with the compression request. Independent
>>>> requests can share the per-CPU transform; the codecs and drivers
>>>> synchronize their shared state internally. Loads can still wait for
>>>> each other on the decompression mutex, and stores still serialize on
>>>> the compression mutex.
>>>>
>>>> acomp_request_free() ignores NULL requests, so drop the check in
>>>> acomp_ctx_free().
>>>>
>>>> This follows the proposal from Sergey Senozhatsky for the same split
>>>> for zram [1].
>>>>
>>>> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
>>>>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>
>>> I have a question with regards to this patch. Is the intent to allow a
>>> decompress thread to run concurrently with a store thread for a given process?
>>
>> The request is shared by tasks using the same CPU and zswap pool.
>> These may be different processes or threads of the same process.
>> Each operation still runs synchronously in its caller.
>>
>> The motivating case can happen entirely on one CPU:
>> 1. Task A compresses page X and releases the codec's stream lock.
>> 2. A is preempted while still holding the zswap request mutex.
>> 3. Task B runs and faults in an already stored page Y.
>>
>> With the shared request, B blocks until A runs again and releases the
>> mutex. Separate requests let B load Y while A's store is unfinished.
>> The codec/driver still synchronizes its own shared state.
>>
>>> If so, I wonder if incurring context switch/PTE/TLB shootdowns performance
>>> penalty is worth it?
>>
>> The switch to B already occurs with the existing code. This patch adds
>> no worker threads, forced migration, PTE changes or TLB shootdowns.
>> It avoids B's subsequent wait on A's request mutex. The 1-vCPU
>> benchmark in the cover letter exercises this without CPU migration.
>>
>>>
>>> With the proposed change, will zswap_store() continue to run on the "old" CPU
>>> (i.e. the one to which the process got migrated), or is it a requirement that
>>> the "old" process is in sleep state? If so, should we codify/document this
>>> requirement?
>>>
>>
>> There is no requirement for A to sleep. A can remain runnable while
>> preempted. Its zswap_store() invocation resumes in the same task, on
>> whichever CPU the scheduler selects. If it migrates after selecting
>> the context, it retains that pointer and the corresponding mutex,
>> as the existing code does. The same task cannot execute on two CPUs
>> at once.
>>
>>> On the new CPU, is the same process "runnable", and if so, how do we ensure that
>>> the "higher priority" decompress is handled while the zswap_store() prior to
>>> preemption is still not done?
>>
>> Normal scheduler policy decides when B runs. Once it runs, the split
>> removes its dependency on A releasing the shared request mutex.
>> A load starting on another CPU already selects a different context
>> today; migration is unnecessary for the benefit described here.
>>
>> Existing folio/swap-cache locking still orders accesses to the same
>> page. The example above concerns two independent pages.
> 
> Thanks for explaining the motivation for this change, and the detailed
> analysis! Is it possible that this could cause compression contexts to
> be starved of compute resources under memory pressure, potentially
> causing deadlocks with page-faults in the worst-case scenario? 

The split removes an unnecessary dependency between unrelated pages.
Under fair scheduling, runnable reclaimers still get CPU time, and a
fault needing memory can perform direct reclaim itself. Faults on a page
being stored still wait for its folio lock, so I don't see a new deadlock
cycle here.

> Since
> compression is inherently slower than decompression, could this be
> making it easier for swap page-faults to preempt compression.

On non-PREEMPT_RT kernels, software compression already runs under the
codec's stream spinlock with preemption disabled. The delay addressed
here is after that lock is released; the split does not make active
compression newly preemptible.


> On a
> related note, should direct reclaim (only) be allowed to use a
> non-preemptible context via a spinlock?
> 
I would keep the current split. The codec already protects its stream,
while the outer context must remain sleepable for asynchronous
completion waits. A spinlock cannot safely cover those waits.


