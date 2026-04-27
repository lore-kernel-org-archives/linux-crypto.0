Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2DA3DA7ED;
	Mon, 27 Apr 2026 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310867; cv=none; b=Q3NYmo05o5HZXqxISYJc+jmPWpkElQnqJxY2W/3sZ3XGicT0lxhkW5LaioIG2iy1COh4EUN6gpMLOfDKWiqDXd3lZ0I8YipIg6kwkQwETVEI59rtKY7cD1j7r1t1ywaS8hlhilTtNtybSgat1DXOufMdjvUviOX2/uRzuMW1p04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310867; c=relaxed/simple;
	bh=lffQnEF2HxPa86nR073wmKFncHxsvNGQFc1fCjNgYos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AzMGX48rsSKhknSHm15KeFY+0a5dsD9tnniJejq3fgxGEyyEXh+GS4ZMg5N7zbYkJ2qpfU20Ux3qrjHDbhBEVH7WkbQfgTXOg++aEdh9q3zYFqUo2UDo4BFBbHdeYpE/XcqH+LTK5J4Vr1iXeu3jXzq2fUgj/Z5iMJ/5kaCxl9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQWh91jQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQWh91jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89740C19425;
	Mon, 27 Apr 2026 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310867;
	bh=lffQnEF2HxPa86nR073wmKFncHxsvNGQFc1fCjNgYos=;
	h=From:To:Cc:Subject:Date:From;
	b=FQWh91jQO/zC/C+ji8OmIrTTTUN3CZckMtGiKZREDIZs+oHlCiYRnfeReTMhoBRFM
	 ZA/EykxErVe9XfPJB2laIdM0V4eO1pWY7QImwz9cl9AzutYCb/m60MVWJ6ZOm1nrcd
	 A0kduFH9/hKVNDewi7xjH4NuO+1y8zqlaeJxsUH8ouvlF7lPj2IbA8ISvS/+S3kjQp
	 46WNoddh2xS/Gi5xZaEC35rCJUNFUMCDiwfWVfDp8xWGDHBEs9KJs3mNQp7AMtie4+
	 +AmOFE4hzvrqn11sCbuO04tc0Z8OttaOt0/tWtgct38IN+9bmvU9fwSFKCGuPATRo/
	 yZYZMj5HxFGuw==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
Date: Mon, 27 Apr 2026 10:27:22 -0700
Message-ID: <20260427172727.9310-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tcp-ao-v2

This series is targeting net-next for 7.2.  To make this series
self-contained in the networking code, I dropped the patches that remove
support for transformation cloning from the crypto API, which is a
further negative 275-line cleanup and optimization this series enables.
That will be done as a follow-up, either through the crypto tree for
7.3, or still through net-next for 7.2 at maintainer preference.

This series refactors the TCP-AO (TCP Authentication Option) code to do
MAC and KDF computations using lib/crypto/ instead of crypto_ahash.
This greatly simplifies the code and makes it much more efficient.  The
entire tcp_sigpool mechanism becomes unnecessary and is removed, as the
problems it was designed to solve don't exist with the library APIs.

The crypto API's support for crypto transformation cloning also becomes
unnecessary and will be removed in follow-up patches.  Note that as part
of that, we'll be able to roll back the addition of the reference count
to crypto_tfm, which had regressed performance for all crypto API users.

To make this simplification and optimization possible, this series also
updates the TCP-AO code to support a specific set of algorithms, rather
than arbitrary algorithms that don't make sense and are very likely not
being used, e.g. CRC-32 and HMAC-MD5.

Specifically, this series retains the support for AES-128-CMAC,
HMAC-SHA1, and HMAC-SHA256.  AES-128-CMAC and HMAC-SHA1 are the only
algorithms that are actually standardized for use in TCP-AO, while
HMAC-SHA256 makes sense to continue supporting as a Linux extension.  Of
course, other algorithms can still be (re-)added later if ever needed.
It's worth noting that TCP-AO MACs are limited to 20 bytes by the TCP
options space, which limits the benefit of further algorithm upgrades.

This series passes the tcp_ao selftests
(sudo make -C tools/testing/selftests/net/tcp_ao/ run_tests).

To get a sense for how much more efficient this makes the TCP-AO code,
here's a microbenchmark for tcp_ao_hash_skb() with skb->len == 128:

        Algorithm       Avg cycles (before)     Avg cycles (after)
        ---------       -------------------     ------------------
        HMAC-SHA1       3319                    1256
        HMAC-SHA256     3311                    1344
        AES-128-CMAC    2720                    1107

Changed in v2:
    - Rebased onto v7.1-rc1.
    - Added Ard's Reviewed-by.
    - Dropped patches that clean up things in the crypto/ directory, as
      mentioned above.  They'll be sent separately.
    - Added some mentions of the MAC length being limited by the TCP
      options space.
    - Removed unnecessary explicit assignment of values to enums.

Eric Biggers (5):
  net/tcp-ao: Drop support for most non-RFC-specified algorithms
  net/tcp-ao: Use crypto library API instead of crypto_ahash
  net/tcp-ao: Use stack-allocated MAC and traffic_key buffers
  net/tcp-ao: Return void from functions that can no longer fail
  net/tcp: Remove tcp_sigpool

 include/net/tcp.h                             |  42 +-
 include/net/tcp_ao.h                          |  74 +-
 net/ipv4/Kconfig                              |   8 +-
 net/ipv4/Makefile                             |   1 -
 net/ipv4/tcp_ao.c                             | 677 +++++++++---------
 net/ipv4/tcp_output.c                         |  10 +-
 net/ipv4/tcp_sigpool.c                        | 366 ----------
 net/ipv6/tcp_ao.c                             | 139 ++--
 tools/testing/selftests/net/tcp_ao/config     |   4 -
 .../selftests/net/tcp_ao/key-management.c     |  41 +-
 10 files changed, 440 insertions(+), 922 deletions(-)
 delete mode 100644 net/ipv4/tcp_sigpool.c


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0

