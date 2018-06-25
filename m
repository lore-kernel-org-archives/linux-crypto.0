From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 01/11] crypto: xcbc: Remove VLA usage
Date: Mon, 25 Jun 2018 14:23:17 -0700
Message-ID: <4d9f90abbf87539d3588f88117806f76c6826030.camel@perches.com>
References: <20180625211026.15819-1-keescook@chromium.org>
         <20180625211026.15819-2-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625211026.15819-2-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2018-06-25 at 14:10 -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this uses
> the maximum blocksize and adds a sanity check. For xcbc, the blocksize
> must always be 16, so use that, since it's already being enforced during
> instantiation.

Is it time yet to change this warning from 'make W=3' to W=1?
---
 scripts/Makefile.extrawarn | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 8d5357053f86..27ba478d40cd 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -29,6 +29,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-option, -Wunused-const-variable)
 warning-1 += $(call cc-option, -Wpacked-not-aligned)
+warning-1 += $(call cc-option, -Wvla)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
 warning-1 += $(call cc-disable-warning, sign-compare)
 
@@ -52,7 +53,6 @@ warning-3 += -Wpointer-arith
 warning-3 += -Wredundant-decls
 warning-3 += -Wswitch-default
 warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
-warning-3 += $(call cc-option, -Wvla)
 
 warning := $(warning-$(findstring 1,
$(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
 warning += $(warning-$(findstring 2,
$(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
