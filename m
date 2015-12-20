From: Tadeusz Struk <tstruk@gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: KEYS: convert public key to the akcipher
 api
Date: Sun, 20 Dec 2015 08:53:12 -0800
Message-ID: <5676DCF8.8060705@gmail.com>
References: <201512200735.x3U85zQL%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, kbuild-all@01.org,
	herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201512200735.x3U85zQL%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 12/19/2015 03:49 PM, kbuild test robot wrote:
> Hi Tadeusz,
> 
> [auto build test ERROR on crypto/master]
> [also build test ERROR on v4.4-rc5 next-20151218]
> 
> url:    https://github.com/0day-ci/linux/commits/Tadeusz-Struk/crypto-KEYS-convert-public-key-to-akcipher-api/20151213-103429
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> config: x86_64-randconfig-s4-12200710 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/crypto/public_key.h:17:0,
>                     from include/linux/verify_pefile.h:15,
>                     from arch/x86/kernel/kexec-bzimage64.c:22:
>    include/keys/asymmetric-type.h: In function 'asymmetric_key_ids':
>>> >> include/keys/asymmetric-type.h:74:12: error: dereferencing pointer to incomplete type 'const struct key'
>      return key->payload.data[asym_key_ids];
>                ^
> 
> vim +74 include/keys/asymmetric-type.h
> 
> 7901c1a8 David Howells 2014-09-16  68  							    size_t len_1,
> 7901c1a8 David Howells 2014-09-16  69  							    const void *val_2,
> 7901c1a8 David Howells 2014-09-16  70  							    size_t len_2);
> 146aa8b1 David Howells 2015-10-21  71  static inline
> 146aa8b1 David Howells 2015-10-21  72  const struct asymmetric_key_ids *asymmetric_key_ids(const struct key *key)
> 146aa8b1 David Howells 2015-10-21  73  {
> 146aa8b1 David Howells 2015-10-21 @74  	return key->payload.data[asym_key_ids];
> 146aa8b1 David Howells 2015-10-21  75  }
> 7901c1a8 David Howells 2014-09-16  76  
> 7901c1a8 David Howells 2014-09-16  77  /*
> 
> :::::: The code at line 74 was first introduced by commit
> :::::: 146aa8b1453bd8f1ff2304ffb71b4ee0eb9acdcc KEYS: Merge the type-specific data with the payload data
> 
> :::::: TO: David Howells <dhowells@redhat.com>
> :::::: CC: David Howells <dhowells@redhat.com>

I think there is something missing in this configuration.
cat .config | grep KEXEC_BZIMAGE_VERIFY_SIG gives nothing.
Anyways, this patch should fix it.

---8<---

From: Tadeusz Struk <tadeusz.struk@intel.com>

Fix auto build test ERROR on crypto/master

Reported-by: <kbuild-all@01.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

diff --git a/arch/x86/kernel/kexec-bzimage64.c
b/arch/x86/kernel/kexec-bzimage64.c
index 0f8a6bb..23aa625 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -19,9 +19,10 @@
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/efi.h>
+#ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
#include <linux/verify_pefile.h>
#include <keys/system_keyring.h>
-
+#endif
#include <asm/bootparam.h>
#include <asm/setup.h>
#include <asm/crash.h>
