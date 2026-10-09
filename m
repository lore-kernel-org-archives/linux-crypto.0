Received: from mta0.migadu.com (out-211.mta0.migadu.com [91.218.175.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4793624C1
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563513; cv=none; b=A22NIdRdzlOESi1lWiTj7OLsjFESrSyWPKDuUYpiGqpIXbDpTnerkNpJG3ukLO1Wdz+Mdnd4O40rXu106Ynhf7/qDGuoqiTBxcHt5r0FEUnA8+kBjrygiIXfj9d0CSDzqUXMNuHPUhDHV8EOczAmTF06XwPQ6nXSqirdlEBLHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563513; c=relaxed/simple;
	bh=d+8iFVNMD1VUbVl7hJhhwaUpwC1HzdCY/+ROH2IsebA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rw3z6HIamGYbNeU/lVg0aiQw4j85wZoKNJ4CoJWIuA4+g5fhNAVkeq+Gh9T3ZxeIpIEe6FcdH9YYcgOwcr/LP+h4HtowV3gs+z47C6s5W/KHOcrJOX1ICpW05/SOgZMM63QS1CMaD2CrThXSWOU9FoHWb7n6FahfDCDAxGutM1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kgNZs633; arc=none smtp.client-ip=91.218.175.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kgNZs633"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=d+8iFVNMD1VUbVl7hJhhwaUpwC1HzdCY/+ROH2IsebA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791563509; v=1; x=1792168309;
 b=kgNZs633RQ5yk31aFhuie2lrSsMkOEa1DDGqeVyGJiUN3eZbhJ7QjOMbHaxGSa8e5YV3GM5Z
 EPKepY64ZExRugegAoSOSVB452JclB2D/SM3fV4/q6U9aj5rdXNNG2ikfu5KBGFdsfjfrsd8WJn
 DBe8qYfp86Ybw2TjrQkQi5ig=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 1332819e0d967689;
	Fri, 09 Oct 2026 16:31:48 +0000
X-Mizu-Trace-ID: 1332819e0d967689
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
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
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 0/2] mm: zswap: reduce request contention on loads
Date: Fri,  9 Oct 2026 09:30:29 -0700
Message-ID: <20261009163146.83112-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stores and loads share a per-CPU acomp request and mutex. A low-priority
store can be preempted right after the compressor drops its stream
lock, while it still holds the zswap mutex, and a higher-priority load
on that CPU then waits for the store to run again. This follows the work
from Sergey Senozhatsky's zram series which splits it for the same
reason [1].

Patch 1 gives compression and decompression separate requests, waits
and mutexes, so loads no longer wait for stores, though they can still
wait for each other. Patch 2 decompresses with an on-stack request when
the algorithm is synchronous and needs no request context, which covers
all in-tree software compressors, so those loads take no zswap lock.
Asynchronous algorithms keep the per-CPU request and mutex. For software
compressors the series allocates the same number of requests as before;
each per-CPU context grows by 72 bytes, and the load path is about 270
bytes deeper on x86-64.

The series does not fix two related cases:
- Stores still serialize on the compression mutex, so a high-priority
  task that reclaims (direct reclaim, MADV_PAGEOUT) can still wait for
  a preempted store.
- On PREEMPT_RT the codec stream locks are preemptible, so a load can
  still wait for a preempted store inside the codec.

The numbers below are the slowest read per run, as a median (min-max)
of 5 runs. Each run is 12 seconds in a zstd VM with lazy preemption,
vm.page-cluster=0 and swap on /dev/ram0. With 1 vCPU, four nice +10
workers page memory out and read it back while a nice 0 task spins. A
nice -19 reader pages out its own buffer and measures how long each
read of it takes. With 8 vCPUs there are 16 workers, 8 spinning tasks
and 8 readers.

              Before series (ms)      With series (ms)
  1 vCPU      22.3 (21.6-22.6)        0.97 (0.72-1.4)
  8 vCPUs     314 (97-2542)           7.0 (5.0-98)

Reads over 10 ms fell from 26-35 per run to none with 1 vCPU, and from
3-18 per run to at most one with 8 vCPUs. The benchmark and test programs
were written with the help of an LLM.

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

v1 -> v2:
- Group the compression request and output buffer in zswap_comp_ctx,
  documenting that the compression mutex protects the buffer (Yosry).
- Move the existing synchronous and request context size checks into
  the Crypto API helper acomp_can_use_stack_req() (Yosry).
- Share callback setup through zswap_set_acomp_req_callback() and explain
  the two decompression paths (Yosry).
- Clarify in patch 1's commit message that codecs and drivers synchronize
  shared transform state internally (Yosry).
- Add Nhat Pham's Acked-by on patch 2.
 
Usama Arif (2):
  mm: zswap: use separate compression and decompression requests
  mm: zswap: use stack requests for synchronous decompression

 include/crypto/acompress.h |  13 +++
 mm/zswap.c                 | 161 ++++++++++++++++++++++++-------------
 2 files changed, 119 insertions(+), 55 deletions(-)

-- 
2.53.0-Meta

