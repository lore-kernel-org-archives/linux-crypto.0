From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: unable to finish booting when "crypto: crct10dif - Wrap
 crc_t10dif function all to use crypto transform framework" applied
Date: Tue, 09 Jul 2013 14:34:14 -0700
Message-ID: <1373405654.22432.258.camel@schen9-DESK>
References: <51D8420C.7010602@internode.on.net>
	 <1373385611.22432.230.camel@schen9-DESK>
	 <51DC52C7.3010101@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab3GIVeM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jul 2013 17:34:12 -0400
In-Reply-To: <51DC52C7.3010101@internode.on.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2013-07-10 at 03:43 +0930, Arthur Marsh wrote:
> Tim Chen wrote, on 10/07/13 01:30:
> > On Sun, 2013-07-07 at 01:43 +0930, Arthur Marsh wrote:
> >> Hi, when I have tried to boot recent kernels with the "crypto: crct10dif
> >> - Wrap crc_t10dif function all to use crypto transform framework" patch
> >> applied, I get a time-out waiting for the UUID of the root disk to appear.
> >>
> >> git-bisect revealed this as the patch that started the problems:
> >>
> >> am64:/usr/src/linux# git bisect good
> >> 2d31e518a42828df7877bca23a958627d60408bc is the first bad commit
> >> commit 2d31e518a42828df7877bca23a958627d60408bc
> >> Author: Tim Chen <tim.c.chen@linux.intel.com>
> >> Date:   Wed May 1 12:52:48 2013 -0700
> >>
> >>       crypto: crct10dif - Wrap crc_t10dif function all to use crypto
> >> transform framework
> >>
> >>       When CRC T10 DIF is calculated using the crypto transform framework, we
> >>       wrap the crc_t10dif function call to utilize it.  This allows us to
> >>       take advantage of any accelerated CRC T10 DIF transform that is
> >>       plugged into the crypto framework.
> >>
> >>       Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> >>       Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >>
> >> :040000 040000 f7691bd794b6c2060bca786cf8c2971d57c7cd21
> >> aff2510c6400c736b89c40fbafab77c5b577ae0d M      crypto
> >> :040000 040000 220b9199c2418dfd2d534298e7374f404f1ab233
> >> d3f635c9c0d504e16f3915b82f80691bd48b12b4 M      include
> >> :040000 040000 dee4ecf93146d700eb95d5804bfd57b5cf0c395f
> >> b66e0ffcef7ed9bda5e56f8629696344858db624 M      lib
> >> am64:/usr/src/linux#
> >
> > Arthur,
> >
> > Thanks for reporting the problem.
> >
> > Can you provide info on to help me trace the issue:
> > 1) What kind of cpu you're using? (can you send info in /proc/cpu)
> > 2) Does your root disk use crct10dif integrity check?
> >
> > Thanks.
> >
> > Tim
> 
> Hi thanks for your reply.
> 
> I've reproduced the problem on x86_64 (AMD Athlon64) and i386 (Pentium 4).

That's odd.  The new crct10dif code should not be built and invoked for i386.
Wonder if something is wrong with the generic algorithm cast as a crypto
transform. 

Can you send me your .config files
you used for building your kernel (for x86_64 and i386)
so I can see how the kernel is built. 

Please also send me the precise version of kernel you are using.  
 
Send me contents of /proc/cpu so I can see 
what are the feature flags on your machine.

> 
> I'm not sure what the root disk is doing, just using Debian's mk-kpkg 
> kernel_package to build a kernel with an initial ramdisk.
> 
> On one of the failed boot-up attempts I saw an error like:
> 
> sd_mod - unknown symbol crc*

If you have any detailed dumps on the messages from sd_mod that will 
be helpful.

> 
> (where crc* could have been a longer symbol name starting with crt10dif)
> 
> I'm happy to look further if I could be given directions on how to find 
> out if the root disk is using crc10dif integrity check or not.
> 
> Regards,
> 
> Arthur.
> 


In the mean time, can you try to apply the following debugging patch
and run it. 

It checks to see if a proper crct10dif crypto transform is allocated
properly. It should print out the crct10dif algorithm being used
(generic or pclmulqdq).

The patch also tests the crct10dif function to see if the test code 
executes (see the printk for the tests).  If everything goes through
properly for a system that supports PCLMULQDQ instruction, you should
see the test pass message.  There should be no error message if
everything runs.  Look for the printk outputs in the patch.

Thanks.

Tim


Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 7845d7f..f85f596 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -127,12 +127,52 @@ static const struct x86_cpu_id crct10dif_cpu_id[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
 
+#define TEST_BUFF_SIZE 8192
+static char input[TEST_BUFF_SIZE];
+extern __u16 crc_t10dif(const unsigned char *buffer, size_t len);
+
+void test_crct10dif(void)
+{
+	__u16   crck, crcp, crc;
+	size_t len;
+	int i;
+
+	input[0] = 'a';
+	input[1] = 'b';
+	input[2] = 'c';
+	for (i=3; i<TEST_BUFF_SIZE; ++i)
+		input[i] = 'd';
+
+	len = 0;
+	printk("............crct10dif pclmulqdq correctness test begins............\n");
+	for (i=0; i<TEST_BUFF_SIZE; ++i) {
+	       crck = crc_t10dif_generic(0, input, len);
+	       kernel_fpu_begin();
+	       crcp = crc_t10dif_pcl(0, input, len);
+	       kernel_fpu_end();
+	       crc = crc_t10dif(input, len);
+	       if (crc != crck || crcp != crck) {
+		       printk("............ERROR: crct10dif failed for lenth:%ld  crck:%-x crcp:%-x crc:%-x\n",
+				len, crck, crcp, crc);
+		       break;
+	       }
+	       ++len;
+	}       
+	if (i == TEST_BUFF_SIZE)
+		printk("............crct10dif pclmulqdq test succeeded............\n"); 
+	else
+		printk("......ERROR: crct10dif pclmulqdq test failed............\n");
+}
+
 static int __init crct10dif_intel_mod_init(void)
 {
+	int ret;
 	if (!x86_match_cpu(crct10dif_cpu_id))
 		return -ENODEV;
 
-	return crypto_register_shash(&alg);
+	ret = crypto_register_shash(&alg);
+	test_crct10dif();
+	return ret; 
 }
 
 static void __exit crct10dif_intel_mod_fini(void)
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index fe3428c..8d4c3d1 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -39,6 +39,11 @@ EXPORT_SYMBOL(crc_t10dif);
 static int __init crc_t10dif_mod_init(void)
 {
 	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
+	if (IS_ERR(crct10dif_tfm)) {
+		printk("............ERROR: crct10dif cannot find a crypto transform function\n");
+		BUG();
+	} else
+		printk("............crct10dif use :%s\n", crypto_tfm_alg_driver_name(&crct10dif_tfm->base));
 	return PTR_RET(crct10dif_tfm);
 }
 
