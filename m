Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105A84409
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270861; cv=none; b=fPsWt+YimwCEJLZBepdfgzPNUW4PBSfNGNb0Ok97jdCrTqbRGRFppZ4AZicN1Qgvhr5FbOWThJub0dyG7HoVGBR/pLAAEbR5J9Ywi4knzbqilVy0juc1nqfzZ1EhyMRaiwIZuabvIcV0xnspZZk9knmCc9hTU9ALSUwOY6GWY/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270861; c=relaxed/simple;
	bh=x+3GHAL1s1rBGYNdAAe80kuC5EvqQnQt8dgXYN2M8gs=;
	h=Date:Message-Id:From:Subject:To; b=EJPuAH3B2GIR078v7lm/8CWIEAnSnrvbuCBr3Kr8s+NG6SmS+Ay88PGvpMx8Flv/mPCL4FK6hkAb7kxnrMgALO95SyGDPF1malr37GfzE8QUuSgkzmZP4yNqJiBo0kVovdVKn/sejiLg+k2l4h2dVMc7VbhHNLg+t3COqIUwVvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfKh-003ip6-2s;
	Sat, 10 Aug 2024 14:20:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:20:52 +0800
Date: Sat, 10 Aug 2024 14:20:52 +0800
Message-Id: <cover.1723270405.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/4] crypto: lib/mpi - Add error checks
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series reverts MPI library extensions which are buggy
as they carried assumptions from user-space that memory allocations
always succeed.  They were used by SM2 which itself has now been
removed.

Ironically most of these library functions were previously in the
kernel in a non-buggy form but were removed because they were unused.

About half of the extensions remain because they have found uses
beyond SM2.  For those error checks have been added.

Herbert Xu (4):
  Revert "lib/mpi: Extend the MPI library"
  crypto: lib/mpi - Add error checks to extension
  crypto: dh - Check mpi_rshift errors
  crypto: rsa - Check MPI allocation errors

 crypto/dh.c                   |   4 +-
 crypto/rsa.c                  |  19 +-
 include/linux/mpi.h           |  87 ++-------
 lib/crypto/mpi/Makefile       |   1 -
 lib/crypto/mpi/mpi-add.c      |  89 +++------
 lib/crypto/mpi/mpi-bit.c      | 168 ++---------------
 lib/crypto/mpi/mpi-cmp.c      |  46 +----
 lib/crypto/mpi/mpi-div.c      |  82 ++++-----
 lib/crypto/mpi/mpi-internal.h |  21 +--
 lib/crypto/mpi/mpi-inv.c      | 143 ---------------
 lib/crypto/mpi/mpi-mod.c      | 148 +--------------
 lib/crypto/mpi/mpi-mul.c      |  29 ++-
 lib/crypto/mpi/mpicoder.c     | 336 ----------------------------------
 lib/crypto/mpi/mpih-mul.c     |  25 ---
 lib/crypto/mpi/mpiutil.c      | 184 +------------------
 15 files changed, 151 insertions(+), 1231 deletions(-)
 delete mode 100644 lib/crypto/mpi/mpi-inv.c

-- 
2.39.2

