From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 0/2] crpyto: lrw - Simplify and optimize the LRW
	template
Date: Fri,  7 Sep 2018 13:27:56 +0200
Message-ID: <20180907112758.14602-1-omosnace@redhat.com>
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

Ondrej Mosnacek (2):
  crypto: lrw - Optimize tweak computation
  crypto: lrw - Do not use auxiliary buffer

 crypto/lrw.c | 321 +++++++++++----------------------------------------
 1 file changed, 66 insertions(+), 255 deletions(-)

-- 
2.17.1
