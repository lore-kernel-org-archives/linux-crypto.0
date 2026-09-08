Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8BD4AA1DE
	for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881851; cv=none; b=XIOzOyqzUkXE/Q/wKo5MdjUzNJfUUT44/bZv47rlsidIa017yP3ZUgcfaml0DUMgrrO6eFi3Y57XyKL/woRFjyr0houQVAilzGP1ljvPWTgagpRhAMcdUp9zzuU4rdA1OYfvxardfhFwHIBQ24ZMOKycaRmHE2ymJw/JehuIS30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881851; c=relaxed/simple;
	bh=3F5irEjcISX4qX8MMi5ghXCJUDGX2AOsa87ikrXlkOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyrgxdnhqyXkNZ62K94xRq5/ZmOBRxdNU3/t6s4/ND2O2H2ZE/ScZvGhVDyINiXnfq5ek5ZB5Z1kys8KVMX5m9k2quOnbIJ9i3zblSpL4P+QqENIgEtSMYmKd1EKWFiWDMboggVpMafAU+zbvRtdwd6DF3ljLKiJY2bucn42tdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eZ3PFfqJ; arc=none smtp.client-ip=95.215.58.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eZ3PFfqJ"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3F5irEjcISX4qX8MMi5ghXCJUDGX2AOsa87ikrXlkOM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788881840; v=1; x=1789486640;
 b=eZ3PFfqJvqeo/i9kY0Ajclq8VcPADd0tdr1qJzPiXNDVHEtOC13S+IwRP8vqdKI9RnHayKi6
 IbvTaU0doRb9sqeCgL63goIAtedqm5qrQ0407IbrxU3pkO3po87RyA1Lkrk6DjULfUn/qaaqaSZ
 xgTYFHShOCDQkNEU6ZmWmolk=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 5be14b208c221cb5;
	Tue, 08 Sep 2026 15:37:20 +0000
X-Mizu-Trace-ID: 5be14b208c221cb5
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: davem@davemloft.net,
	dsterba@suse.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	terrelln@fb.com,
	terrelln@meta.com,
	cyan@meta.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH 0/2] crypto: zstd - avoid initializing the workspace twice
Date: Tue,  8 Sep 2026 08:37:13 -0700
Message-ID: <20260908153715.3063790-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825220616.3842633-1-usama.arif@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 15:06:00 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Both zstd_compress() and zstd_decompress() set up the shared per-CPU
> workspace as a C/DStream before walking the request, and then, when the
> first source and destination fragments each span the whole request, hand
> off to zstd_compress_one()/zstd_decompress_one(), which immediately
> overwrite that same ctx->wksp with a CCtx/DCtx. The stream setup is
> discarded without a byte having been processed.
> 
> That one-shot path is not a corner case: zswap always takes it when
> storing, and takes it for a load whenever the stored object lies within a
> single zsmalloc page.
> 
> These two patches defer the stream initialization to the first walk
> iteration that actually streams, guarded by a flag because that iteration
> can be reached more than once.
> 
> A 4 KiB crypto_acomp benchmark [1], twelve runs of nine 30,000-operation
> rounds. Bare metal is an Intel Xeon Platinum 8321HC, turbo off,
> performance governor, pinned to one core; the VM is a one-vCPU KVM guest
> on a faster host.
> 
>                   baseline    patched     delta
>   bare metal
>     compress      52,283 ns   51,038 ns   1,245 ns   2.4%
>     decompress     2,317 ns    1,998 ns     319 ns  13.8%
>   one-vCPU KVM
>     compress      16,675 ns   15,050 ns   1,625 ns   9.8%
>     decompress     3,516 ns    2,265 ns   1,251 ns  35.6%
> 
> The guest numbers are larger because the two CPUID instructions in
> ZSTD_cpuid() become unconditional VM exits there. 
> 
> [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c

Hi,

Just wanted to check if there was any feedback or review of the series.

I think its a nice optimization and even with the CPUID instructions
getting cached [1], this is still needed. The improvement in baremetal
is not coming (just) from CPUID instructions.

[1] https://lore.kernel.org/all/20260901110850.1805747-1-usama.arif@linux.dev/

Thanks,
Usama
