From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
Date: Thu, 18 Jul 2013 12:47:05 +0900
Message-ID: <201307180347.r6I3l5e9077577@www262.sakura.ne.jp>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp> <1374098936.22432.322.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:60688 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab3GRDrQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 23:47:16 -0400
In-Reply-To: <1374098936.22432.322.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tim Chen wrote:
> > > Your approach is quite complicated.  I think something simpler like the
> > > following will work:
> >
> > We cannot benefit from PCLMULQDQ. Is it acceptable for you?
> 
> 
> The following code in crct10dif-pclmul_glue.c
> 
> static const struct x86_cpu_id crct10dif_cpu_id[] = {
>         X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
>         {}
> };
> MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
> 
> will put the module in the device table and get the module
> loaded, as long as the cpu support PCLMULQDQ. So we should be able
> to benefit.

Excuse me, how can crct10dif-pclmul.ko get loaded automatically?
Did you test CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m with below debug message?

diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 7845d7f..a8a95aa 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -129,9 +129,10 @@ MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
 
 static int __init crct10dif_intel_mod_init(void)
 {
+	printk(KERN_WARNING "********** Checking for X86_FEATURE_PCLMULQDQ\n");
 	if (!x86_match_cpu(crct10dif_cpu_id))
 		return -ENODEV;
-
+	printk(KERN_WARNING "********** Registering crct10dif-pclmul\n");
 	return crypto_register_shash(&alg);
 }

As far as I tested, crct10dif-pclmul.ko will not be loaded unless manually
adding "modprobe crct10dif-pclmul" to initramfs's /init or choosing
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y.

> So as long as the crct10dif.ko and crct10dif-pclmul.ko are loaded,
> the pclmulqdq t10dif will have a higher priority and get allocated
> and used.

What I'm talking are

  (1) Since mkinitramfs is unable to know that crct10dif-pclmul.ko has higher
      priority than crct10dif.ko , mkinitramfs will not include
      "modprobe crct10dif-pclmul" line in the generated initramfs.

  (2) In order to get benefit from PCLMULQDQ, users have to manually make sure
      that "modprobe crct10dif-pclmul" is called before crc-t10dif.ko (which is
      loaded before sd_mod.ko is loaded) is loaded by their initramfs's /init
      script.

  (3) The cause of (1) is that crct10dif-pclmul.ko will not be loaded
      automatically unless choosing CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y.

  (4) The cause of (3) is that modules.dep does not describe that users will
      benefit by loading crct10dif-pclmul.ko before loading crc-t10dif.ko .

  (5) Currently crct10dif-pclmul.ko cannot be loaded if PCLMULQDQ is not
      supported. This leads to boot failure (since sd_mod.ko cannot be loaded)
      if modules.dep says that "crct10dif-pclmul.ko is required by
      crc-t10dif.ko".

  (6) To solve (4) and (5), modules.dep should say "crct10dif-pclmul.ko is
      preferred for crc-t10dif.ko but is not required by crc-t10dif.ko".
      But there is no such mechanism. Thus, currently available choice is
      "allow loading crct10dif-pclmul.ko even if PCLMULQDQ is not supported"
      or "ignore errors by built-in the crct10dif-pclmul.ko module".

My patch (b) seems to be complicated but is required in order to solve (4)
without asking users to manually add "modprobe crct10dif-pclmul" into their
initramfs. If we choose patch (b) rather than patch (a), we need to solve (5).
