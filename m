From: Stafford Horne <shorne@gmail.com>
Subject: [RFC PATCH 0/2] Fix GCC -Wstringop-truncation warnings
Date: Sat, 23 Jun 2018 11:07:51 +0900
Message-ID: <20180623020753.27266-1-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        linux-crypto@vger.kernel.org, Stafford Horne <shorne@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

When compiling OpenRISC kernels with our new toolchain based on 9.0.0 I am
seeing various -Wstringop-truncation warnings.  There might be more as I am not
compiling all drivers/modules yet, if someone thinks thats helpful let me know.

I discussed this with Greg KH at the OSS Summit Japan yesterday and it seems no
one has pointed these out yet, so here are the patches.

Please let me know if I should keep these on the OpenRISC tree (which I can do
for 4.18) or if the maintainers will pick them up separately.

-Stafford

Stafford Horne (2):
  crypto: Fix -Wstringop-truncation warnings
  kobject: Fix -Wstringop-truncation warning

 crypto/ablkcipher.c | 4 ++--
 crypto/blkcipher.c  | 2 +-
 lib/kobject.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.17.0
