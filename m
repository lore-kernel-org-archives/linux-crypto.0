Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB9D202C29;
	Sat,  7 Mar 2026 22:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772923574; cv=none; b=mrjg18Stmn3dBzGNMRd+vBL6kQNVcBY9fLSrAtUeWfazMS6Psq+iHsbxC4L/Isk2fpEruI1F3nzSAPkX+497EWI6EvzmbHsxqC0JguiwKsuw40vxvq6uDV5Pvd3vGwWqtH+zFbJVlBXp5RxBZsYuuL051lY5bqA/aQBB9/+aAJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772923574; c=relaxed/simple;
	bh=hCRoFUTpcoC9MUKo/CzRUy7a8gJWYpogs+xyO029ryY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Uj89DoqCv3UdAbkBvqI7dvQyyjBCZhhATFQUL5YPuwhD/bKHtbLxdde3D3vnHH+nlAja7IbzYa5X+oJsZGABNsqQzRmAxakOqnbBPd76Y0lbNnOgRVTt1zYKgX3uIMOMDicU17Uzvj4aUob/HVRf0oRwCApCHvNT9Ww4NXwuQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lojrWjYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lojrWjYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA3BC19422;
	Sat,  7 Mar 2026 22:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772923574;
	bh=hCRoFUTpcoC9MUKo/CzRUy7a8gJWYpogs+xyO029ryY=;
	h=From:To:Cc:Subject:Date:From;
	b=lojrWjYvnH0FA8H2gpTBza2sa6Drj44gj3G9Sq1JK1JQ/mvZoVLjiCb2pKlnUMYOi
	 oxWwDvisbpol0tLIdjMWg0GqD0YjWkOxcM5tfZ03R+ilXVzfo0UkLkbFic1i8od89Z
	 b4s630f9e++4wPEDt0TbsmN+nELFCuVlmpn0nkXHiGkXwavBuX9SuUfx59QoM24ZTE
	 tmSa+zKAA7yKgbjc5kxX+8du88uOS0gpgsfx0JH3AxNRysJJOwAzx86yzpECMBcmQR
	 MqmlgS+XYGWCZeuUVWPjOC8oV2JV/s9Y1Sl6kNt7+/fowiecW/RAIv5h+xMNuEjZd7
	 S6eaFfynGA6AA==
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
Subject: [RFC PATCH 0/8] Reimplement TCP-AO using crypto library
Date: Sat,  7 Mar 2026 14:43:33 -0800
Message-ID: <20260307224341.5644-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tcp-ao-v1

For now this series is an RFC, since it depends on the AES-CMAC library
API that is queued in libcrypto-next for 7.1.  So, the soonest that this
could be applied to net-next is 7.2.  I'm sending it out now in case
anyone has any early feedback.

This series refactors the TCP-AO (TCP Authentication Option) code to do
MAC and KDF computations using lib/crypto/ instead of crypto_ahash.
This greatly simplifies the code and makes it much more efficient.  The
entire tcp_sigpool and crypto_ahash cloning mechanisms become
unnecessary and are removed, as the problems they were designed to solve
don't exist with the library APIs.

To make this possible, this series also restricts the supported
algorithms to a reasonable set, rather than supporting arbitrary
algorithms that don't make sense and are very likely not being used.
Specifically, this series leaves in place the support for AES-128-CMAC
and HMAC-SHA1 which are the only algorithms that actually have an RFC
specifying their use in TCP-AO, along with HMAC-SHA256 which is a
reasonable algorithm to continue supporting as a Linux extension.

This passes the tcp_ao selftests (tools/testing/selftests/net/tcp_ao).

To get a sense for how much more efficient this makes the TCP-AO code,
here's a microbenchmark for tcp_ao_hash_skb() with skb->len == 128:

        Algorithm       Avg cycles (before)     Avg cycles (after)
        ---------       -------------------     ------------------
        HMAC-SHA1       3319                    1256
        HMAC-SHA256     3311                    1344
        AES-128-CMAC    2720                    1107

Eric Biggers (8):
  net/tcp-ao: Drop support for most non-RFC-specified algorithms
  net/tcp-ao: Use crypto library API instead of crypto_ahash
  net/tcp-ao: Use stack-allocated MAC and traffic_key buffers
  net/tcp-ao: Return void from functions that can no longer fail
  net/tcp: Remove tcp_sigpool
  crypto: hash - Remove support for cloning hash tfms
  crypto: cipher - Remove support for cloning cipher tfms
  crypto: api - Remove core support for cloning tfms

 crypto/ahash.c                                |  70 --
 crypto/api.c                                  |  26 -
 crypto/cipher.c                               |  28 -
 crypto/cmac.c                                 |  16 -
 crypto/cryptd.c                               |  16 -
 crypto/hmac.c                                 |  31 -
 crypto/internal.h                             |   2 -
 crypto/shash.c                                |  37 -
 include/crypto/hash.h                         |   8 -
 include/crypto/internal/cipher.h              |   2 -
 include/net/tcp.h                             |  42 +-
 include/net/tcp_ao.h                          |  69 +-
 net/ipv4/Kconfig                              |   8 +-
 net/ipv4/Makefile                             |   1 -
 net/ipv4/tcp_ao.c                             | 677 +++++++++---------
 net/ipv4/tcp_output.c                         |  10 +-
 net/ipv4/tcp_sigpool.c                        | 366 ----------
 net/ipv6/tcp_ao.c                             | 139 ++--
 tools/testing/selftests/net/tcp_ao/config     |   3 -
 .../selftests/net/tcp_ao/key-management.c     |  41 +-
 20 files changed, 435 insertions(+), 1157 deletions(-)
 delete mode 100644 net/ipv4/tcp_sigpool.c


base-commit: 0a217be68aedd0f6b48cf0476462bc94bd73eee7
-- 
2.53.0

