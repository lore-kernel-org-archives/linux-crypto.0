Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37C450C280
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904252; cv=none; b=pKi8i3J0H/ppxyge2As5V94qRnwqsIeqYgND9+8fwjO35ZIGnTEOP2c3YqDzj3ROHtY5W1totnk83QpZtgqjScPoki7qDWuR2BY02+L0OyqCAFVBC1ozoQzB6bf9cKQ2wd1W8YenYqzqy4Lu6NsWux0GG7XhAb2okox7B4JHe9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904252; c=relaxed/simple;
	bh=59kDzY29XnAdYqJ9ZYSMDsg2Gwxh5pjxWMzFEpzvbLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kIwObR/P17EA0RLUw8qa6Xvwpd0a8nML+iB2VJ3AZWAvRIuRibgTtsKv+g1TtbxCisxJdUsuU9bfMcP/gdXTi1YDw2GzWpGV2N0D5H+aAXKud76lk41fkmRnJQqueqswgsDFlkziD830616w5vAT49s4iW3AOXeAYWkvUrprUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IBxJNxlE; arc=none smtp.client-ip=91.218.175.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IBxJNxlE"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=59kDzY29XnAdYqJ9ZYSMDsg2Gwxh5pjxWMzFEpzvbLk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791904248; v=1; x=1792509048;
 b=IBxJNxlEn1DXq6T44t1LTTZ0ghZFUpUN9Dy9oZ47KbhJvB3gID75QTOTJWJ13E21WnJU0nOk
 lTGWg8z5Lmfmr/fE7TiHxWXm1IpPYKh1PCmmuMiIYXHFnVosa/1FYxOAfQc1rzFZOstqPgTM9gE
 jhrObPpP4IZRAkNXoBsTfOWo=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id a4de6271a8b1d2c8;
	Tue, 13 Oct 2026 15:10:13 +0000
X-Mizu-Trace-ID: a4de6271a8b1d2c8
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
Subject: [PATCH v3 0/3] mm: zswap: reduce request contention on loads
Date: Tue, 13 Oct 2026 08:09:34 -0700
Message-ID: <20261013151007.2093943-1-usama.arif@linux.dev>
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
wait for each other. Patch 2, authored by Herbert Xu, enforces
MAX_SYNC_COMP_REQSIZE when synchronous Crypto ACOMP transforms are
initialized. Patch 3 uses an on-stack request for synchronous
decompression, so those loads take no zswap lock. This covers all
in-tree software compressors. Asynchronous algorithms keep the per-CPU
request and mutex. For software compressors the series allocates the
same number of requests as before; each per-CPU context grows by 72
bytes, and the load path is about 270 bytes deeper on x86-64.

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

v2 -> v3:
- Include Herbert Xu's Crypto API patch enforcing MAX_SYNC_COMP_REQSIZE
  when synchronous ACOMP transforms are initialized.
- Use acomp_is_async() in the stack-request patch and remove the
  redundant acomp_can_use_stack_req() helper (Herbert).

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
- Add Nhat Pham's Acked-by to the first zswap patch.

Herbert Xu (1):
  crypto: acomp - enforce MAX_SYNC_COMP_REQSIZE

Usama Arif (2):
  mm: zswap: use separate compression and decompression requests
  mm: zswap: use stack requests for synchronous decompression

 crypto/acompress.c |  18 ++---
 mm/zswap.c         | 161 +++++++++++++++++++++++++++++----------------
 2 files changed, 115 insertions(+), 64 deletions(-)

-- 
2.53.0-Meta

