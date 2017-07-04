From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] sha1-avx2 and read beyond
Date: Tue, 4 Jul 2017 12:21:12 +0800
Message-ID: <20170704042112.GA32734@gondor.apana.org.au>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
 <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
 <20170623084330.GA30353@gondor.apana.org.au>
 <1943517473.41520875.1498207731142.JavaMail.zimbra@redhat.com>
 <ea4d8991-7452-053e-8e53-8dcb6d28f69d@linux.intel.com>
 <E31A9F2A86F5F543BC6B7554E63385C5504A413B@fmsmsx115.amr.corp.intel.com>
 <20170703123344.GB30067@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Jan Stancek <jstancek@redhat.com>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Locktyukhin, Maxim" <maxim.locktyukhin@intel.com>,
        "Zohar, Ronen" <ronen.zohar@intel.com>,
        "mouli@linux.intel.com" <mouli@linux.intel.com>,
        "minipli@googlemail.com" <minipli@googlemail.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "marex@denx.de" <marex@denx.de>
To: "Albrekht, Ilya" <ilya.albrekht@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51870 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdGDEVt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2017 00:21:49 -0400
Content-Disposition: inline
In-Reply-To: <20170703123344.GB30067@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 03, 2017 at 08:33:44PM +0800, Herbert Xu wrote:
> On Sat, Jun 24, 2017 at 12:56:52AM +0000, Albrekht, Ilya wrote:
> > Hello all,
> > 
> > I'm sorry for late reply (I was out of office for a month).
> > 
> > It's been a while since we touched this code. We are going to do our best to support it. I'll be back to the office earlier next week and will figure out the fix ASAP.
> 
> Any update on this?

For the time being I'm going to disable this:

---8<---
Subject: crypto: sha1-ssse3 - Disable avx2

It has been reported that sha1-avx2 can cause page faults by reading
beyond the end of the input.  This patch disables it until it can be
fixed.

Cc: <stable@vger.kernel.org>
Fixes: 7c1da8d0d046 ("crypto: sha - SHA1 transform x86_64 AVX2")
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index fc61739..f960a04 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -201,7 +201,7 @@ asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
 
 static bool avx2_usable(void)
 {
-	if (avx_usable() && boot_cpu_has(X86_FEATURE_AVX2)
+	if (false && avx_usable() && boot_cpu_has(X86_FEATURE_AVX2)
 		&& boot_cpu_has(X86_FEATURE_BMI1)
 		&& boot_cpu_has(X86_FEATURE_BMI2))
 		return true;

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
