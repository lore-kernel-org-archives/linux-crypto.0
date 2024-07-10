Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6DC18FC98
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2024 10:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720608874; cv=none; b=ZzYOYXx7EFEHYtE3aCm9dBxgATpUmv/3sxl6Ozollr0xUVld+UgN6XbAAzb3UzRE8b72oSz+Dkm85kCdlKknbzkNbPjDJfZb84wQ8L2RkLq+ZcRQnfInAReAfCgXI0Y4k1vvcUtWeYWNWnjlcvS2VHrwS8BeaVIqo8qP96CWpjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720608874; c=relaxed/simple;
	bh=g/Z8swP+y6kHNA6kDxmKESjyxjf4EdQpf0o45pfJAV4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IWtQEJIpK0AIUGN8NAbgXk6YyDlwCqtfkwV6B2sYeaPYYxaqg0/j5b5l4T6g0OqSZztzt2SxVsRSq+GHjJZT4ycia0iSDTm44n8jj69I+aepfHvMcP+3ZDzsMfzX32NqVdK7LZPr2zF5/DBu7nFrexUm3xCX9Se985f1blaHcYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VAz7Sl8Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VAz7Sl8Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720608871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UACuPcdZcKado8V67RiC59MQG9qi61DDAS+Lk0oK73w=;
	b=VAz7Sl8Z9E7Z40s3/DRfec7dlSBWtgiG/xJ2FpYaCLLgSiRWeI+11PJPa07zi7sEfLcLPS
	Zr/g5l8UGarYxHwAX9IGVGtDtbFlMmOZfeVJvv5dws0wnK+L8TJ1unCW696aC1nHjoGr5T
	+S+CGXJXR2AiH+k5+tdnnoR7yxoENYk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-Gq0UvDTAN92kdivSKIrqWQ-1; Wed,
 10 Jul 2024 06:54:28 -0400
X-MC-Unique: Gq0UvDTAN92kdivSKIrqWQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4881A19560AA;
	Wed, 10 Jul 2024 10:54:26 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EBD619560AE;
	Wed, 10 Jul 2024 10:54:25 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 51E5930C1C1C; Wed, 10 Jul 2024 10:54:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 4E47F3FA91;
	Wed, 10 Jul 2024 12:54:24 +0200 (CEST)
Date: Wed, 10 Jul 2024 12:54:24 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev, 
    dm-devel@lists.linux.dev, x86@kernel.org, 
    linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
    Sami Tolvanen <samitolvanen@google.com>, 
    Bart Van Assche <bvanassche@acm.org>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    Mike Snitzer <snitzer@kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH v5 00/15] Optimize dm-verity and fsverity using multibuffer
 hashing
In-Reply-To: <20240611034822.36603-1-ebiggers@kernel.org>
Message-ID: <7097bafd-e146-99a5-7f86-369e8e2b080@redhat.com>
References: <20240611034822.36603-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi

I'd like to ask what's the status of this patchset.

Will Herbert accept it? What's the planned kernel version where it will 
appear?

Mikulas


On Mon, 10 Jun 2024, Eric Biggers wrote:

> On many modern CPUs, it is possible to compute the SHA-256 hash of two
> equal-length messages in about the same time as a single message, if all
> the instructions are interleaved.  This is because each SHA-256 (and
> also most other cryptographic hash functions) is inherently serialized
> and therefore can't always take advantage of the CPU's full throughput.
> 
> An earlier attempt to support multibuffer hashing in Linux was based
> around the ahash API.  That approach had some major issues, as does the
> alternative ahash-based approach proposed by Herbert (see my response at
> https://lore.kernel.org/linux-crypto/20240610164258.GA3269@sol.localdomain/).
> This patchset instead takes a much simpler approach of just adding a
> synchronous API for hashing equal-length messages.
> 
> This works well for dm-verity and fsverity, which use Merkle trees and
> therefore hash large numbers of equal-length messages.
> 
> This patchset is organized as follows:
> 
> - Patch 1-3 add crypto_shash_finup_mb() and tests for it.
> - Patch 4-5 implement finup_mb on x86_64 and arm64, using an
>   interleaving factor of 2.
> - Patch 6 adds multibuffer hashing support to fsverity.
> - Patches 7-14 are cleanups and optimizations to dm-verity that prepare
>   the way for adding multibuffer hashing support.  These don't depend on
>   any of the previous patches.
> - Patch 15 adds multibuffer hashing support to dm-verity.
> 
> On CPUs that support multiple concurrent SHA-256's (all arm64 CPUs I
> tested, and AMD Zen CPUs), raw SHA-256 hashing throughput increases by
> 70-98%, and the throughput of cold-cache reads from dm-verity and
> fsverity increases by very roughly 35%.
> 
> Changed in v5:
>   - Reworked the dm-verity patches again.  Split the preparation work
>     into separate patches, fixed two bugs, and added some new cleanups.
>   - Other small cleanups
> 
> Changed in v4:
>   - Reorganized the fsverity and dm-verity code to have a unified code
>     path for single-block vs. multi-block processing.  For data blocks
>     they now use only crypto_shash_finup_mb().
> 
> Changed in v3:
>   - Change API from finup2x to finup_mb.  It now takes arrays of data
>     buffer and output buffers, avoiding hardcoding 2x in the API.
> 
> Changed in v2:
>   - Rebase onto cryptodev/master
>   - Add more comments to assembly
>   - Reorganize some of the assembly slightly
>   - Fix the claimed throughput improvement on arm64
>   - Fix incorrect kunmap order in fs/verity/verify.c
>   - Adjust testmgr generation logic slightly
>   - Explicitly check for INT_MAX before casting unsigned int to int
>   - Mention SHA3 based parallel hashes
>   - Mention AVX512-based approach
> 
> Eric Biggers (15):
>   crypto: shash - add support for finup_mb
>   crypto: testmgr - generate power-of-2 lengths more often
>   crypto: testmgr - add tests for finup_mb
>   crypto: x86/sha256-ni - add support for finup_mb
>   crypto: arm64/sha256-ce - add support for finup_mb
>   fsverity: improve performance by using multibuffer hashing
>   dm-verity: move hash algorithm setup into its own function
>   dm-verity: move data hash mismatch handling into its own function
>   dm-verity: make real_digest and want_digest fixed-length
>   dm-verity: provide dma_alignment limit in io_hints
>   dm-verity: always "map" the data blocks
>   dm-verity: make verity_hash() take dm_verity_io instead of ahash_request
>   dm-verity: hash blocks with shash import+finup when possible
>   dm-verity: reduce scope of real and wanted digests
>   dm-verity: improve performance by using multibuffer hashing
> 
>  arch/arm64/crypto/sha2-ce-core.S    | 281 +++++++++++++-
>  arch/arm64/crypto/sha2-ce-glue.c    |  40 ++
>  arch/x86/crypto/sha256_ni_asm.S     | 368 ++++++++++++++++++
>  arch/x86/crypto/sha256_ssse3_glue.c |  39 ++
>  crypto/shash.c                      |  58 +++
>  crypto/testmgr.c                    |  90 ++++-
>  drivers/md/dm-verity-fec.c          |  49 +--
>  drivers/md/dm-verity-fec.h          |   9 +-
>  drivers/md/dm-verity-target.c       | 582 ++++++++++++++++------------
>  drivers/md/dm-verity.h              |  66 ++--
>  fs/verity/fsverity_private.h        |   7 +
>  fs/verity/hash_algs.c               |   8 +-
>  fs/verity/verify.c                  | 170 ++++++--
>  include/crypto/hash.h               |  52 ++-
>  14 files changed, 1440 insertions(+), 379 deletions(-)
> 
> 
> base-commit: 6d4e1993a30539f556da2ebd36f1936c583eb812
> -- 
> 2.45.1
> 
> 

