From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 13/14] rxrpc: Prepare to remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Wed, 11 Jul 2018 13:36:18 -0700
Message-ID: <20180711203619.1020-14-keescook@chromium.org>
References: <20180711203619.1020-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711203619.1020-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Two uses of SKCIPHER_REQUEST_ON_STACK() will trigger FRAME_WARN warnings
(when less than 2048) once the VLA is no longer hidden from the check:

net/rxrpc/rxkad.c:398:1: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]
net/rxrpc/rxkad.c:242:1: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]

This bumps the affected objects by 20% to silence the warnings while
still providing coverage is anything grows even more.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/rxrpc/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index 6ffb7e9887ce..53e1177129e6 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -32,4 +32,5 @@ rxrpc-y := \
 
 rxrpc-$(CONFIG_PROC_FS) += proc.o
 rxrpc-$(CONFIG_RXKAD) += rxkad.o
+CFLAGS_rxkad.o += $(FRAME_WARN_BUMP_FLAG)
 rxrpc-$(CONFIG_SYSCTL) += sysctl.o
-- 
2.17.1
