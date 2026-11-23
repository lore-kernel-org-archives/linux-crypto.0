Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795393516;
	b=xgCRToRUsdefwXlOsaHXzQCLOsBTnsGERc73mFAVgHZi84NTT0903YzCoTTV1bigpV31
	 TB3b3FY22QFG/+/M7teIU7VhU5cZTPbgzRwD9lgJoKy4teoxoqN/WBn/ZAUmCOEKG3qGu
	 2ZjBZ1/FVHBQODdhYAa34KcyNC7bdntJuWJwIsY27vvjHvmTsRSIpl+NNWwWb3+JFJZJa
	 y/YcOe7n0cO105k4IuLIOmpyzLQnYrZ2vPQql0uTXNcWaJ7sx+B8uWjvxysJZ40A1DfxX
	 QZMp9Ur/0UGi8mROzTGix/FcwtjUo2YBjD3GPF7JuIhWLugboS+Ul6WEiIAzRlCnq7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393516;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=mNi3Pj05CGsYEOdmgVQU43MsXqlDog8eO7vY1bFFNz8=;
	b=H3J0IBkF5b9kFJsk+54owKeOzfzkGbTgFeyMaeCbl70FAlUb9R1OUoN6aKiP4vol6eus
	 KD2QBAIeOP9YxiZBuqbG5mu9/YlAg2tTYoCmSgZH04NQCdGwBIxkt1AWdjc0zm2rLiOkp
	 znQdCFyMBCAiFQO+lDwImkIYMhuPVL44epqe/Y7+P60WhnQIgJeZTlItBbFer+1Hetgh2
	 9rubSKEfxyHnkdlM1Sz1kHDAYzTEKe5AdUjMW0TrMfq0mk2SIiyOFhjWlXj3yZ0f7ruHB
	 gq+3/qsXLZQUAQEjyu+4PwXcBzAXf46c7kzdHA04xhq4jjptPAXOmZfg9xj+B80/XcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=moerukM7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744D1606A31A;
	Mon, 23 Nov 2026 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=moerukM7
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795393516;
	b=vtWm/x6N/8x0ZfaclbI4bNeGNxTadQb70U3zfg0f3/pB5GDJ42pZ+BQKOPwOccfOLT/o
	 f4DuVchgAvSETj/JnubuWhVE7ZV3bV5f4AWyVaEDBuM32jewelycdNN15q3+hXlCPKoN6
	 sz2lGAYPpyWk6ENActxbFpGFwagKT2UtttxZGG2ZSzn6NS7oNciibw+i+aOVUhbVTfiGK
	 jvodzJbia3ZkwcWfbbbnU9L02oSyGfaXsGRHYjZqYt1HqJ6BtUXxvHlkdRUhII2QjAnfB
	 N3xTHBh8BCkRA2zs6fMCwvIlbrSuImE8L9xtL3pMEabR8vp8M5r9xG5NADHuSch5vNQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795393516;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=mNi3Pj05CGsYEOdmgVQU43MsXqlDog8eO7vY1bFFNz8=;
	b=UMN0zonV17BlvBrW2r93vG59hPibKG8PV6iRYcu7FIofbW4j+IdF2DuFByce3QfBb6P5
	 +c3nYhUP0M2GIs97DmYHJzejCItDoSF4cGZEyyUMXfcTqn28MKpsNqdLXTXGjN3iZyKxu
	 Ia6e60hObol4ltisV8U5mt+zg8/9jBKqy34trMKZxq9c5o9hM7/yPpKRLw3A+LOVZChw3
	 IBzX+OhDNph6BsHhBqLDzq9iMfPDvgV0cL7+SnTNzV5SDtG4aFx3xJGHeNXgEgkL71VIi
	 1HJf+kZfv+7jfg08KR0EmNwrryYr9HZKOypsbgSzfOn9P+hYXid2QH+kBjbzXcnUuaQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 403661F000CA;
	Mon, 23 Nov 2026 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393516;
	bh=mNi3Pj05CGsYEOdmgVQU43MsXqlDog8eO7vY1bFFNz8=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=moerukM74iTxFpwzAPQ0DwYsOpTGrqhe7usGkqMA1+B0GIs9fF3jIfiLL89HMi1qC
	 onwART7oMOBdPUqHR30Lg4MOpk7bk4Jvkcfo1J2/BXq1gd7P2aWmA80uxxJQB/lX8T
	 d3COi4xWlyV1/3d3GiiWa4ieeGUIjZ3lDB/1iBkCWt0r/7dXR9V0yLfzlaVltNqqBa
	 xH+6q7ZvdyUkFLIR8O6bslTJBLoif9u7Ww2hC9fKEhlcst7EgucexbU0SR7xEjptRI
	 eMPtfUmcru78Igybd78bzKRoKw67TndpMPdixYd4eSzsNFFHSi4ZC1itN4YK7mJ9hs
	 wwNHuncvQdL3Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 942A64C251;
	Mon, 23 Nov 2026 00:25:12 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Subject: [PATCH bpf v2 0/4] bpf: Don't spin on rhtab bucket locks with IRQs
 disabled
Date: Sun, 22 Nov 2026 19:25:11 -0500
Message-Id: <20261122-bpf-rhtab-irqs-disabled-v2-0-207aedcc2215@columbia.edu>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNTQ6CMBCFr0Jm7Zi2kgquvIdh0Z9BxiBgC0RDu
 LsFD+DyvXzvewtECkwRLtkCgWaO3HcpqEMGrjHdnZB9yqCE0lKKE9qhxtCMxiKHV0TP0diWPLp
 c59qVJGpSkNZDoJrfu/kGaQTVr4yTfZAbN+eGNRzHPnz2/1nu8N+rWaLEsjjnvtRGFIW7ur6dn
 pbNkfwE1bquX8j9x9XYAAAA
X-Change-ID: 20261103-bpf-rhtab-irqs-disabled-c4646c9e0fe2
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Mykyta Yatsenko <yatsenko@meta.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, bpf@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, tz2294@columbia.edu, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795393512; l=1885;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=Cdk7sFLE8Ms1z4MWODP6tHICAcN6MvIKq/Q+cx9TxjA=;
 b=QyYqJhTCgCxEks59roKvMT4SIBstHsjhnIxEryfr9INyqeC5lbUDBSQ6oPuQ4tjfrpB4lRR+z
 oVc1iV/TsnpBD7LzTsVaP0lWipwJWgMeQj752iWKnKn9mJvarl6D5mf
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu

A BPF program with IRQs disabled can run inside a bucket lock's critical
section on its own CPU, e.g., a kprobe on the hash function the resize
worker calls with the lock held.  An insert or delete of that bucket
then spins forever, and a lookup can retry forever.

v2 follows Alexei's trylock design (patch 1) and Mykyta's lookup change
(patch 2), turns it on for rhtab (patch 3) and adds a selftest (patch
4).  The kvmalloc(GFP_ATOMIC) in rhashtable_insert_rehash() is left for
a follow-up.

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/rhashlock.c

---
Changes in v2:
- Trylock the bucket lock with IRQs disabled instead of failing every
  insert and delete (Alexei)
- Drop bpf_disable_instrumentation() from rhtab (Alexei)
- Don't retry lookups with IRQs disabled (Mykyta)
- Add a selftest
- Link to v1: https://patch.msgid.link/20261103-bpf-rhtab-irqs-disabled-v1-1-9874d96a088c@columbia.edu

---
Mani Tofigh (4):
      rhashtable: Add trylock_irqsoff for callers that can't spin
      rhashtable: Don't retry trylock_irqsoff lookups with IRQs disabled
      bpf: Don't spin on rhtab bucket locks with IRQs disabled
      selftests/bpf: Test rhtab deletes from inside a resize

 include/linux/rhashtable-types.h                 |  3 ++
 include/linux/rhashtable.h                       | 45 ++++++++++++++++++++++--
 kernel/bpf/hashtab.c                             | 17 ++-------
 lib/rhashtable.c                                 |  9 +++--
 tools/testing/selftests/bpf/prog_tests/rhash.c   | 34 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/rhash_resize.c | 34 ++++++++++++++++++
 6 files changed, 122 insertions(+), 20 deletions(-)
---
base-commit: 84afebd853437e44cb71f718be11d90e4c1a59dd
change-id: 20261103-bpf-rhtab-irqs-disabled-c4646c9e0fe2

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


