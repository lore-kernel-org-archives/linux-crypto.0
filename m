From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
Date: Mon, 20 May 2013 12:09:45 -0700
Message-ID: <1369076985.27102.319.camel@schen9-DESK>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
	 <5193CCEC.7070909@infradead.org>
	 <alpine.DEB.2.02.1305161152530.31865@M2420>
	 <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
	 <1368723552.27102.286.camel@schen9-DESK>
	 <1368727412.27102.289.camel@schen9-DESK>
	 <20130520114707.GA1187@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Xiong Zhou <jencce.kernel@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130520114707.GA1187@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2013-05-20 at 19:47 +0800, Herbert Xu wrote:

> 
> Nope this is still broken.  We need to move the actual crct10dif
> code into crypto/.  I'll fix up the patch in the tree.
> 
> Also I'm going to get rid of crc_t10dif_update_lib function.  If you
> still want to maintain the ordering you should do so using the
> *_init constructs.
> 

Herbert, 

I used the following constructs in the pclmulqdq version of t10dif
to get the module loaded. 

static const struct x86_cpu_id crct10dif_cpu_id[] = {
        X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
        {}
};
MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);

However, the default generic algorithm is used
in the library function. The options CRC_T10DIF, CRYPTO_CRCT10DIF
and CRYPTO_CRCT10DIF_PCLMUL are selected as modules (which
is most likely usage scenario in distribution) on my
test machine.  The library module and generic crypto module was loaded
before the pclmulqdq t10dif module during boot.  How should
things be changed to get this crypto module loaded earlier before the
library?  Should we add another init call level between fs and device
init calls for loading the available crypto algorithms?  
The crc_t10dif_update_lib was originally used to side step this issue.

BTW, latest crypto-dev need the following modification if we get
rid of crc_t10dif_update_lib.

Thanks.

Tim



diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c
b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 3c0abd3..d838b7f 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -136,8 +136,6 @@ static int __init crct10dif_intel_mod_init(void)
                return -ENODEV;
 
        ret = crypto_register_shash(&alg);
-       if (!ret)
-               crc_t10dif_update_lib();
        return ret;
 }
