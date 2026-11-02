Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.202.192.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793619612;
	b=ahAEtsKuMrejdfAlGI4+/re8RHwZjAW2dkKZq695K9Z6uqJ4J7LG45/L9AUJ4Fgm/rGa
	 5r7MoO4JM0jC6jw5xdwaI7LUwHzNbUlFikgQQCQgJPpKDzC/k+5oKfdnqCqoS86W98mBf
	 tSCABCwp1Tg4McjWGQSD4EpgE+698Lk7gKEmmt+4v4HsIxV7+Y8Jb6vhyNuahtbxHzIQj
	 BLIgbRSqPcD7qoaOrkC8ZrK41MshszJEicU/4IUAgLrivDZankhQnzh4b7WX8oF4Qwwm1
	 qKzm4nKLIv2lyHrgCnnPHennwJmfW6lc9NICO9/HssKBWFk8w/pmxXqteFXVfXCoXBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793619612;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=HkDGJkW7e7nieytZUHfLlPhB1tNwjlDDq6U2eIvQe/w=;
	b=0aff60C1BpG3hElkwr/IifKOFzJwGPsALLooSbj+wLLkwdao1i/zzLa7izBhlOQUZ1T8
	 k2mudw29dei+vzezX/WmP87ckMYKZhetpFgdG3Ww9AxwA2g6JvnE30P4+oxEWowX1sQvV
	 TmhqIxZnBI+Z6BIta0+KrbUMcSaFONuj3rgtGW+OyhFKMSfBYHroxaa5BWe9LxeE4PdnH
	 tqXTUYjX98R6mOre44wrwpO0HfPH9bT6T/VUw9tABbYB6U1rlqkt6R4ofNhRBbXDM1ggl
	 66kieQ3eAR6vrn2banlj9r95O8UPf1t+ugulOyZdJbtYO/w/AQJi078k3iSf2SKZ/Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=strongswan.org;
	spf=pass smtp.mailfrom=strongswan.org;
	arc=none smtp.remote-ip=109.202.192.35
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2ED606A335
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 11:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D2ED606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strongswan.org
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 87E4D5A0005;
	Mon, 02 Nov 2026 12:39:57 +0100 (CET)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id ooKRHlb_JfWo; Mon,  2 Nov 2026 12:39:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1793619596;
	bh=FM1P7kUm8Ii/2dJK0+Tva+U1E/DVdVTs3+511m15htM=;
	h=From:To:Cc:Subject:Date:From;
	b=PEwWUr18H61FUyPO0QsfpjZHYu4qJ3QoL5TXHVPHGygWUyH1ekAUXkZDz2xv7pIZY
	 YrN+0MQoETIbyReYs6+bjLixns4XmSWW8MBvhg8QeVELg35t30u2DuZb358X1ndCR6
	 to/m0XgHOdAp4HdCaIqJCFGGC+rzul3txI4A8LI69zOw74n7mqGL2l2zqkxgrVFssx
	 NE6hktdwuLTiFtBhkZJFr3d3M+d8S22cYc57Uf9clPmHEHDtwInpKSWMQcSlQTBNyE
	 bqdZ1is99Re03YjatVmC2hOo7HmCucHx5Xm7NeE93ztQ82yty7H/vWn1JWDse74PDV
	 F/J1NgcLqWqww==
Received: from ee00200a.home (unknown [185.12.128.224])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 39C265A0004;
	Mon, 02 Nov 2026 12:39:56 +0100 (CET)
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: [PATCH v2 0/3] lib/crypto: x86/chacha: Add a 16-block AVX-512 function
Date: Mon,  2 Nov 2026 12:39:23 +0100
Message-ID: <20261102113926.2765176-1-martin@strongswan.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is v2 of the 16-block ChaCha function for 512-bit zmm registers.
Patch 1 renames the assembly file, patch 2 wraps the 8-block code in
a macro, and patch 3 adds the 16-block function on top.

I previously mentioned a larger series with more AVX refactorings to
shared macros along with a 4-block zmm variant. That needs some
more work, so here is just the 16-block variant.

v1 used embedded broadcasts for the final ChaCha state add. This comes
with a minor regression on older Intel chips when used in the 8-block
variant. Therefore I kept the state words in registers in the macro
version used by both 8/16-block variants, see patch 3.

I don't have a Zen 4, which splits zmm instructions into two 256-bit
halves, so I can't tell how the 16-block function performs there.
If anybody has access to one, numbers from there would be great.

Changes in v2:
 - Rename chacha-avx512vl-x86_64.S to chacha-avx512-x86_64.S
 - Generate the 8- and 16-block functions from a shared macro
 - Drop the cpu_has_xfeatures() and X86_FEATURE_AVX512F checks
 - Keep the state words in registers for the final add
 - Benchmark with the ChaCha KUnit suite instead of tcrypt

v1: https://lore.kernel.org/linux-crypto/20260722153247.630519-1-martin@strongswan.org/

Martin Willi (3):
  lib/crypto: x86/chacha: Rename the AVX-512VL assembly file
  lib/crypto: x86/chacha: Wrap the 8-block AVX-512 code in a macro
  lib/crypto: x86/chacha: Add a 16-block AVX-512 function

 lib/crypto/Makefile                           |   2 +-
 ...x512vl-x86_64.S => chacha-avx512-x86_64.S} | 730 +++++++++++-------
 lib/crypto/x86/chacha.h                       |  28 +-
 3 files changed, 477 insertions(+), 283 deletions(-)
 rename lib/crypto/x86/{chacha-avx512vl-x86_64.S => chacha-avx512-x86_64.S} (55%)


base-commit: c90bb21618db40f1f30a1c0ed58d4f46b27dba26
-- 
2.53.0

