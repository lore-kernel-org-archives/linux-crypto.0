From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 0/6] crypto: talitos - various fixes
Date: Tue, 19 Sep 2017 14:58:59 +0200 (CEST)
Message-ID: <cover.1505825623.git.christophe.leroy@c-s.fr>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 David S. Miller <davem@davemloft.net>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

This serie provide various fixes on the talitos driver.

Christophe Leroy (6):
  crypto: talitos - Don't provide setkey for non hmac hashing algs.
  crypto: talitos - fix hashing
  crypto: talitos - fix sha224
  crypto: talitos - fix AEAD test failures
  crypto: talitos - use kzalloc instead of kmalloc
  crypto: talitos - fix memory corruption on SEC2

 drivers/crypto/talitos.c | 81 +++++++++++++++++++++---------------------------
 drivers/crypto/talitos.h |  2 --
 2 files changed, 36 insertions(+), 47 deletions(-)

-- 
2.13.3
