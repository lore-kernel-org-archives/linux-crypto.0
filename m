From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Wed, 16 Apr 2008 20:40:16 +0200
Message-ID: <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: "Huang, Ying" <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756219AbYDPSkf@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1208333949.4322.5.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

cut Alexander Kjeldaas <astor@fast.no> from CC coz his mails bounce.

* Huang, Ying | 2008-04-16 16:19:09 [+0800]:

>Can you help me to test these patches
>to find out the reason for degradation on AMD CPU.
Sure. 

>> >--- a/include/crypto/aes.h
>> >+++ b/include/crypto/aes.h
>> >@@ -19,6 +19,7 @@
>> > 
>> > struct crypto_aes_ctx {
>> > 	u32 key_length;
>> >+	u32 _pad1;
>> 
>> Why is this pad required? Do you want special alignment of the keys?
>
>Because the key is loaded in 64bit in this patch, I want to align the
>key with 64bit address.

Than this won't work all the time. To make it bulletproof
- set .cra_alignmask in the glue code properly
- use the attribute aligned thing
- retrieve your private struct via crypto_tfm_ctx_aligned()

You might want to take a look on padlock-aes.c. The same thing is done
there but instead of crypto_tfm_ctx_aligned() a private function is
used (to let the compiler optimize most of the code away). Depending on
Herbert's mood you might get away with this as well (what would be
probably the case since you might prefer to do it asm) :)

>> > 	u32 key_enc[AES_MAX_KEYLENGTH_U32];
>> > 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
>> > };
>> >
>
>Best Regards,
>Huang Ying
>

Sebastian
