From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v3 0/2] crypto: lrw - Simplify and optimize the
	LRW template
Date: Tue, 11 Sep 2018 09:42:37 +0200
Message-ID: <20180911074239.2398-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

This patchset is a follow-up to a similar patch for XTS:
https://patchwork.kernel.org/patch/10588775/

The first patch applies a small optimization to the tweak computation
and the second simplifes away the use of auxiliary buffer to cache
computed tweaks.

Changes in v3:
  - fix a copy-paste error

v2: https://www.spinics.net/lists/linux-crypto/msg34890.html
Changes in v2:
  - small cleanup suggested by Eric Biggers

v1: https://www.spinics.net/lists/linux-crypto/msg34871.html

Ondrej Mosnacek (2):
  crypto: lrw - Optimize tweak computation
  crypto: lrw - Do not use auxiliary buffer

 crypto/lrw.c | 327 ++++++++++++---------------------------------------
 1 file changed, 75 insertions(+), 252 deletions(-)

-- 
2.17.1
