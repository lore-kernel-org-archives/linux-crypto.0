From: Stafford Horne <shorne@gmail.com>
Subject: [PATCH v2 0/2] Fix GCC -Wstringop-truncation warnings
Date: Mon, 25 Jun 2018 21:45:36 +0900
Message-ID: <20180625124538.21051-1-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org, Stafford Horne <shorne@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

When compiling OpenRISC kernels with our new toolchain based on GCC 9.0.0 I am
seeing various -Wstringop-truncation warnings.  There might be more as I am not
compiling all drivers/modules yet, if someone thinks thats helpful let me know.

I discussed this with Greg KH at the OSS Summit Japan 2018 and it seems no
one has pointed these out yet, so here are the patches...  Actually, the crypto
issue was reported before, but the patch was discarded as it introduced a data
leakage bug pointed out by Erix.

As for merging, I think the maintainers should pick these up separately.  Let me
know if you want something else.


Changes since v1:

 - Fix paper-bag bug in kobject patch, using memcpy() now
 - Fix data leakage issue crypto patch pointed out by Eric Biggers

-Stafford


Stafford Horne (2):
  crypto: Fix -Wstringop-truncation warnings
  kobject: Fix -Wstringop-truncation warning

 crypto/ablkcipher.c | 2 ++
 crypto/blkcipher.c  | 1 +
 lib/kobject.c       | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.17.0
