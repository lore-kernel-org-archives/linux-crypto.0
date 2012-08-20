From: David Miller <davem@davemloft.net>
Subject: [PATCH 0/4] Crytpo hash drivers for sparc64 crypto instructions.
Date: Sun, 19 Aug 2012 22:10:00 -0700 (PDT)
Message-ID: <20120819.221000.1440395237780126787.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


SPARC-T4 and later support cryptographic instructions.

This patch series adds support for the hash digest algorithms.

This includes md5, sha1, sha224, sha256, sha384, and sha512.

Herbert, this depends upon sparc64 cpu feature detection
infrastructure that is going in via the sparc-next tree, so I intend
to commit this work there if you don't mind.

Signed-off-by: David S. Miller <davem@davemloft.net>

