Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C4221481B;
	Wed, 19 Feb 2025 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989467; cv=none; b=d19bZMwWgawk+TKw4v5I7dW64ElJ7OD+hu/jFPFYsJhD4HqNPnsx6bqGfnq69Nk3cbNej3IDgA2EJ306bXsQ+pJV9BtA+3jZXEqprpb94Fnwt7kL7TUZeq9Mabb3pZVeA08k0UQnYuhtq/y5Mfq34czs5+MduQ05ldQvfUeJ/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989467; c=relaxed/simple;
	bh=MnAffNGuOsgnzdGST98He9D12GmU6n41qfc44ByLtiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j5VqRwoPvkuzNMdh85UBR/wameYTqVhYvozBMpEiaHsSJdZgE5GsrqZQ1LBKUe8avCsXdLmn5NNyj0GJlf7DC4JsjrThpYf1ltYdDvNdilsXZnr881kMv38wWsDEXnccFK4Zs6JuzePTAU+CXwN18WuQCKhbnLrx63kxWPTmbrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPGrKe6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPGrKe6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028C7C4CED1;
	Wed, 19 Feb 2025 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989467;
	bh=MnAffNGuOsgnzdGST98He9D12GmU6n41qfc44ByLtiI=;
	h=From:To:Cc:Subject:Date:From;
	b=YPGrKe6WopB9r+cQOljZNncGAxLtvjs3kio1C1TPdc1hr5wc2IbmljIQ0HIEX04u5
	 Lo+MhcAOBaa4xQGvYOWA1fTchQLK0wJHUeTDJO+rqPEWbb0G2Rs+3zODzKXdbHFEHO
	 ne8dna6ynngvy3kN0Q25j5APWOgUyFK4nFHbqMIdE0GqwsTFlLnAslFB0mxEOENvxp
	 OeYVVv7U53y2gY960MRCRVbISIynQVsS3K8AQ1ZP4m82n0EntuYkCvheWCc42ZgTq3
	 MJFX8zb4motA1Z3Q3jnmi84MIphZQC4ld8nvPh/oqubwLXHN3qAETDG0oLANRCjMXv
	 jQ6ejMsHRSyaw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 00/19] crypto: scatterlist handling improvements
Date: Wed, 19 Feb 2025 10:23:22 -0800
Message-ID: <20250219182341.43961-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crypto-scatterlist-v3

This series cleans up and optimizes the code that translates between
scatterlists (the input to the API) and virtual addresses (what software
implementations operate on) for skcipher and aead algorithms.

This takes the form of cleanups and optimizations to the skcipher_walk
functions and a rework of the underlying scatter_walk functions.

The unnecessary use of scatterlists still remains a huge pain point of
many of the crypto APIs, with the exception of lib/crypto/, shash, and
scomp which do it properly.  But this series at least reduces (but not
eliminates) the impact on performance that the scatterlists have.

An an example, this patchset improves IPsec throughput by about 5%, as
measured using iperf3 bidirectional TCP between two c3d-standard-4 (AMD
Genoa) instances in Google Compute Engine using transport mode IPsec
with AES-256-GCM.

This series is organized as follows:

- Patch 1-5 improve scatter_walk, introducing easier-to-use functions
  and optimizing performance in some cases.
- Patch 6-17 convert users to use the new functions.
- Patch 18 removes functions that are no longer needed.
- Patch 19 optimizes the walker on !HIGHMEM platforms to start returning
  data segments that can cross a page boundary.  This can significantly
  improve performance in cases where messages can cross pages, such as
  IPsec.  Previously there was a large overhead caused by packets being
  unnecessarily divided into multiple parts by the walker, including
  hitting skcipher_next_slow() which uses a single-block bounce buffer.

Changed in v3:
- Dropped patches that were upstreamed.
- Added a Reviewed-by and Tested-by.

Changed in v2:
- Added comment to scatterwalk_done_dst().
- Added scatterwalk_get_sglist() and use it in net/tls/.
- Dropped the keywrap patch, as keywrap is being removed by
  https://lore.kernel.org/r/20241227220802.92550-1-ebiggers@kernel.org

Eric Biggers (19):
  crypto: scatterwalk - move to next sg entry just in time
  crypto: scatterwalk - add new functions for skipping data
  crypto: scatterwalk - add new functions for iterating through data
  crypto: scatterwalk - add new functions for copying data
  crypto: scatterwalk - add scatterwalk_get_sglist()
  crypto: skcipher - use scatterwalk_start_at_pos()
  crypto: aegis - use the new scatterwalk functions
  crypto: arm/ghash - use the new scatterwalk functions
  crypto: arm64 - use the new scatterwalk functions
  crypto: nx - use the new scatterwalk functions
  crypto: s390/aes-gcm - use the new scatterwalk functions
  crypto: s5p-sss - use the new scatterwalk functions
  crypto: stm32 - use the new scatterwalk functions
  crypto: x86/aes-gcm - use the new scatterwalk functions
  crypto: x86/aegis - use the new scatterwalk functions
  net/tls: use the new scatterwalk functions
  crypto: skcipher - use the new scatterwalk functions
  crypto: scatterwalk - remove obsolete functions
  crypto: scatterwalk - don't split at page boundaries when !HIGHMEM

 arch/arm/crypto/ghash-ce-glue.c       |  15 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c   |  17 +--
 arch/arm64/crypto/ghash-ce-glue.c     |  16 +-
 arch/arm64/crypto/sm4-ce-ccm-glue.c   |  27 ++--
 arch/arm64/crypto/sm4-ce-gcm-glue.c   |  31 ++--
 arch/s390/crypto/aes_s390.c           |  33 ++---
 arch/x86/crypto/aegis128-aesni-glue.c |  10 +-
 arch/x86/crypto/aesni-intel_glue.c    |  28 ++--
 crypto/aegis128-core.c                |  10 +-
 crypto/scatterwalk.c                  |  91 +++++++-----
 crypto/skcipher.c                     |  65 +++------
 drivers/crypto/nx/nx-aes-ccm.c        |  16 +-
 drivers/crypto/nx/nx-aes-gcm.c        |  17 +--
 drivers/crypto/nx/nx.c                |  31 +---
 drivers/crypto/nx/nx.h                |   3 -
 drivers/crypto/s5p-sss.c              |  38 ++---
 drivers/crypto/stm32/stm32-cryp.c     |  34 ++---
 include/crypto/scatterwalk.h          | 203 +++++++++++++++++++++-----
 net/tls/tls_device_fallback.c         |  31 +---
 19 files changed, 363 insertions(+), 353 deletions(-)


base-commit: c346fef6fef53fa57ff323b701e7bad82290d0e7
-- 
2.48.1

