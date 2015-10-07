From: Dave Hansen <dave@sr71.net>
Subject: Re: [PATCH] crypto x86/camellia_aesni_avx: Fix CPU feature checks
Date: Wed, 7 Oct 2015 07:02:53 -0700
Message-ID: <5615260D.7000301@sr71.net>
References: <1444131093.2956.122.camel@decadent.org.uk>
 <20151007072558.GF7837@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080108040908000601010103"
Cc: linux-crypto@vger.kernel.org,
	=?UTF-8?Q?St=c3=a9phane_Glondu?= <glondu@debian.org>,
	stable <stable@vger.kernel.org>, x86@kernel.org
To: Ingo Molnar <mingo@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20151007072558.GF7837@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------080108040908000601010103
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 10/07/2015 12:25 AM, Ingo Molnar wrote:
> * Ben Hutchings <ben@decadent.org.uk> wrote:
>> We need to explicitly check the AVX and AES CPU features, as we can't
>> infer them from the related XSAVE feature flags.  For example, the
>> Core i3 2310M passes the XSAVE feature test but does not implement
>> AES-NI.
...
>> diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
>> index 80a0e43..bacaa13 100644
>> --- a/arch/x86/crypto/camellia_aesni_avx_glue.c
>> +++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
>> @@ -554,6 +554,11 @@ static int __init camellia_aesni_init(void)
>>  {
>>  	const char *feature_name;
>>  
>> +	if (!cpu_has_avx || !cpu_has_aes || !cpu_has_osxsave) {
>> +		pr_info("AVX or AES-NI instructions are not detected.\n");
>> +		return -ENODEV;
>> +	}
>> +
>>  	if (!cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, &feature_name)) {
>>  		pr_info("CPU feature '%s' is not supported.\n", feature_name);
>>  		return -ENODEV;
> 
> Good catch!
> 
> Do we still need the cpu_has_xfeatures() check after the cpuid based check?

Practically, no.  Today, we either enable all of the XFEATUREs we know
about, or we disable XSAVE completely.  But, if we ever somehow disabled
support for the YMM xstate on a CPU that still had AVX and AES support,
we would need this check.  (this is not likely)

FWIW, the SDM also spells out that you should check cpuid bits and XCR0
state (which cpu_has_xfeatures() does implicitly).

I was actually looking at simplifying all of the CPUID/XSTATE_* checks
in arch/x86/crypto/* and I came up with a similar fix.  I also added
some sse2/avx/avx2_usable() functions that save a lot of this repetitive
copy/paste.  I need to clean those up and submit them (part of the
series is attached).

Feel free to add my acked-by on this though.  It looks good to me.

--------------080108040908000601010103
Content-Type: text/x-patch;
 name="x86-fpu-simplify-avx-xsave-checks-part003.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-fpu-simplify-avx-xsave-checks-part003.patch"


From: Dave Hansen <dave.hansen@linux.intel.com>

camellia_aesni_avx_glue uses AVX and AESNI.  Use the new AVX function.
Note that this was likely to be broken before since it did not actually
check for AESNI.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/crypto/camellia_aesni_avx_glue.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/x86/crypto/camellia_aesni_avx_glue.c~x86-fpu-simplify-avx-xsave-checks-part003 arch/x86/crypto/camellia_aesni_avx_glue.c
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c~x86-fpu-simplify-avx-xsave-checks-part003	2015-09-28 10:04:21.534884514 -0700
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c	2015-09-28 10:04:21.538884696 -0700
@@ -20,6 +20,7 @@
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
 #include <asm/fpu/api.h>
+#include <asm/feature-checks.h>
 #include <asm/crypto/camellia.h>
 #include <asm/crypto/glue_helper.h>
 
@@ -552,11 +553,8 @@ static struct crypto_alg cmll_algs[10] =
 
 static int __init camellia_aesni_init(void)
 {
-	const char *feature_name;
-
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+	if (!avx_usable() || !cpu_has_aes) {
+		pr_info("AVX2 or AESNI instructions are unsupported.\n");
 		return -ENODEV;
 	}
 
_

--------------080108040908000601010103
Content-Type: text/x-patch;
 name="x86-fpu-simplify-avx-xsave-checks-part014.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-fpu-simplify-avx-xsave-checks-part014.patch"


From: Dave Hansen <dave.hansen@linux.intel.com>

A bunch of crypto code tries to do the same detection logic.  Some
get it right, but most probably get it wrong.

For instance, some check for XFEATURE_MASK_YMM, but don't check
for AVX itself.  Especially if the *software* X86_FEATURE_AVX bit
is cleared, we might end up with XFEATURE_MASK_YMM set, but we
do not want to support AVX.

This also formally checks for SSE2 before checking for AVX and
AVX prior to the AVX2 checks, as the SDM suggests.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/feature-checks.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff -puN /dev/null arch/x86/include/asm/feature-checks.h
--- /dev/null	2015-07-13 14:24:11.435656502 -0700
+++ b/arch/x86/include/asm/feature-checks.h	2015-09-28 10:04:20.290827923 -0700
@@ -0,0 +1,32 @@
+#ifndef _ASM_X86_FEATURE_CHECKS_H
+#define _ASM_X86_FEATURE_CHECKS_H
+
+/*
+ *
+ */
+
+static inline bool __init sse2_usable(void)
+{
+	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+		return false;
+	return true;
+}
+
+static inline bool __init avx_usable(void)
+{
+	if (!sse2_usable())
+		return false;
+	if (!cpu_has_avx || !cpu_has_osxsave)
+		return false;
+	return true;
+}
+
+static inline bool __init avx2_usable(void)
+{
+       if (avx_usable() && cpu_has_avx2)
+               return true;
+
+       return false;
+}
+
+#endif /* _ASM_X86_FEATURE_CHECKS_H */
_

--------------080108040908000601010103--
