Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715970;
	b=5UXI6bR7nLTI/5PBh0n1kdhFTZbulO1mcNroQs/hwl1u8hW7Zaxms+uOgf/zEZ7n7pTR
	 CVrjMg1g+dOegTSLjWAMbfKAaOAgEKq2wcYXr3k1z+a0JKkaa0kcM5rhG4a+C6wrAotww
	 ln5+WMbtULN4OutFmynl6syA0MMDD0pnBQ/KdqJH6B1x+dTE6HMfyBjnGeFgV1eNG10cm
	 5rRPDW4y3TuOR1QISQk+X0LJvCuhhESw3PogE4TNCjI3rdzx0QBdyQ8UYOFsFW/AEVmlx
	 LR7aYVzv3kOrEWFiTHUSCAiXeHTOvhq75OIFc6gbVhXtivnzVCdLkzMA/yUd48MyXRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715970;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SP+PsE8Ru4U+3pCKdB8/8ut6hXzWlTRuTLeApszTcIU=;
	b=F2ZQP506esc4OL70mxeNpQBSoX5Hp2ewdO1rwXRHEuukaF/MQQr5fkzcHLIKbzeqkgFy
	 FhQOHyEbT02OlmtSxBgafQsav1V1krP55HsFiIcOnped1vXAc6uhRIgV+3drqBjLAZ6vo
	 woLNqXLCjRx/3+ja2UGhlKaK5kn12HTYtvERSV41+dLiWbDTqhN7GL6s8ZkncTJl9g91r
	 exr1gJCojNwcCtRbNmT6uunC52JyERrU25bni27O8+Q/6OH+HMx7iEBsHn2DUDL7s9Q0x
	 X+qwGhuosiF+GGEJFoTiCHjkTXD/Z42Cu9ixOnK19pKeVFtbNlzqyhalCw3D1AgFEdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YaHi5cR7;
	arc=none smtp.remote-ip=91.218.175.112
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BE4606A324
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 14:26:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96BE4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YaHi5cR7
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e4dRfO2AklgdwU7Ax1baawDTLW3B5X1MgsMszdfEn0w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793715967; v=1; x=1794320767;
 b=YaHi5cR7BLL3kSm9QyMD6IvLgxrXUGjQG7/SqJWzCm2WzFzZhyONHi8FPdjtOJk4qBGtFzGG
 kUjC4kf2hI0RoP7sX43XiNI3hrc3E6tOctdbNbZyDbre2NqoFVOkam2lJx6loXVKlDQ2DE0i8lm
 Q9I7zUhYUe25GVDd/+Ls1CWo=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 313b1a0531fdd4a8;
	Tue, 03 Nov 2026 14:26:07 +0000
X-Mizu-Trace-ID: 313b1a0531fdd4a8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and decompression requests
Date: Tue,  3 Nov 2026 06:25:58 -0800
Message-ID: <20261103142600.279899-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com>
References: 
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 12 Oct 2026 17:21:40 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:

> On Fri, Oct 9, 2026 at 6:31 PM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > Stores and loads serialize on the same per-CPU acomp request and mutex.
> > A low-priority store can be preempted as soon as the compressor drops
> > its stream lock, while it still holds the mutex. A higher-priority load
> > on that CPU then waits until the store runs again, which can take a
> > long time when other tasks are runnable.
> >
> > Give compression and decompression their own request, completion wait
> > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> > compression, so group it with the compression request. Independent
> > requests can share the per-CPU transform; the codecs and drivers
> > synchronize their shared state internally. Loads can still wait for
> > each other on the decompression mutex, and stores still serialize on
> > the compression mutex.
> >
> > acomp_request_free() ignores NULL requests, so drop the check in
> > acomp_ctx_free().
> >
> > This follows the proposal from Sergey Senozhatsky for the same split
> > for zram [1].
> >
> > [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
> >
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> I have a question with regards to this patch. Is the intent to allow a
> decompress thread to run concurrently with a store thread for a given process?

The request is shared by tasks using the same CPU and zswap pool.
These may be different processes or threads of the same process.
Each operation still runs synchronously in its caller.

The motivating case can happen entirely on one CPU:
1. Task A compresses page X and releases the codec's stream lock.
2. A is preempted while still holding the zswap request mutex.
3. Task B runs and faults in an already stored page Y.

With the shared request, B blocks until A runs again and releases the
mutex. Separate requests let B load Y while A's store is unfinished.
The codec/driver still synchronizes its own shared state.

> If so, I wonder if incurring context switch/PTE/TLB shootdowns performance
> penalty is worth it?

The switch to B already occurs with the existing code. This patch adds
no worker threads, forced migration, PTE changes or TLB shootdowns.
It avoids B's subsequent wait on A's request mutex. The 1-vCPU
benchmark in the cover letter exercises this without CPU migration.

> 
> With the proposed change, will zswap_store() continue to run on the "old" CPU
> (i.e. the one to which the process got migrated), or is it a requirement that
> the "old" process is in sleep state? If so, should we codify/document this
> requirement?
> 

There is no requirement for A to sleep. A can remain runnable while
preempted. Its zswap_store() invocation resumes in the same task, on
whichever CPU the scheduler selects. If it migrates after selecting
the context, it retains that pointer and the corresponding mutex,
as the existing code does. The same task cannot execute on two CPUs
at once.

> On the new CPU, is the same process "runnable", and if so, how do we ensure that
> the "higher priority" decompress is handled while the zswap_store() prior to
> preemption is still not done?

Normal scheduler policy decides when B runs. Once it runs, the split
removes its dependency on A releasing the shared request mutex.
A load starting on another CPU already selects a different context
today; migration is unnecessary for the benefit described here.

Existing folio/swap-cache locking still orders accesses to the same
page. The example above concerns two independent pages.

Thanks for the review!
Usama

> 
> Thanks,
> Kanchana
> 
