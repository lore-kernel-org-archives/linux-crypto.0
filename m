From: Andy Polyakov <appro@openssl.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Fri, 27 Mar 2015 11:42:55 +0100
Message-ID: <5515342F.6010703@openssl.org>
References: <20150316154835.GA31336@google.com>	<20150323135009.GB820@google.com>	<20150324122702.GJ14457@ns203013.ovh.net>	<CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>	<20150324130511.GK14457@ns203013.ovh.net>	<CAKv+Gu8Px6dYKdrVFyh_5WN3sEAGYy0fv0qHONJ5x+68YZjCOQ@mail.gmail.com>
 <CAKv+Gu_4G69JZJPex_=1xOZ4z5Fxtht4YG4G=TnYrkXPuiXvFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060603060000010008080405"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu_4G69JZJPex_=1xOZ4z5Fxtht4YG4G=TnYrkXPuiXvFg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------060603060000010008080405
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

>> Could you share the error log please?
> 
> OK, I spotted one issue with this code:
> 
> arch/arm/crypto/sha256-core.S: Assembler messages:
> arch/arm/crypto/sha256-core.S:1847: Error: invalid constant (ffffefb0)
> after fixup
> 
> This is caused by the fact that, when building the integer-only code
> for an older architecture, the conditional compilation produces a
> slightly bigger preceding function, and the symbol K256 is out of
> range for the adr instruction.
> 
> @Jean-Christophe: is that the same problem that you hit?
> 
> @Andy: I propose we do something similar as in the bsaes code:
> 
> #ifdef __thumb__
> #define adrl adr
> #endif
> 
> and replace the offending line with
> 
> adrl r14,K256

Sorry about delay. Yes, that would do. I did test all combinations, but
all "my" combinations, i.e. without __KERNEL__ defined :-( And without
__KERNEL__ there are few extra instructions in integer-only subroutine
that "push" instruction in question code toward higher address, so that
constant was ffffefc0, which can be encoded. Anyway, I've chosen to add
that #define next to .thumb directive. See attached.

Ard, you have mentioned that you've verified it on big-endian, but I've
spotted little-endian dependency (see #ifndef __ARMEB__ in attached). I
guess that it worked for you either because it was NEON that was tested
(it does work as is) or __LINUX_ARM_ARCH__ was less than 7 (in which
case it uses endian-neutral byte-by-byte data load). Can you confirm either?


--------------060603060000010008080405
Content-Type: text/x-patch;
 name="sha256-armv4.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="sha256-armv4.diff"

diff --git a/crypto/sha/asm/sha256-armv4.pl b/crypto/sha/asm/sha256-armv4=
=2Epl
index 4fee74d..fac0533 100644
--- a/crypto/sha/asm/sha256-armv4.pl
+++ b/crypto/sha/asm/sha256-armv4.pl
@@ -73,7 +73,9 @@ $code.=3D<<___ if ($i<16);
 	eor	$t0,$e,$e,ror#`$Sigma1[1]-$Sigma1[0]`
 	add	$a,$a,$t2			@ h+=3DMaj(a,b,c) from the past
 	eor	$t0,$t0,$e,ror#`$Sigma1[2]-$Sigma1[0]`	@ Sigma1(e)
+# ifndef __ARMEB__
 	rev	$t1,$t1
+# endif
 #else
 	@ ldrb	$t1,[$inp,#3]			@ $i
 	add	$a,$a,$t2			@ h+=3DMaj(a,b,c) from the past
@@ -166,6 +168,7 @@ $code=3D<<___;
 #else
 .syntax unified
 # ifdef __thumb2__
+#  define adrl adr
 .thumb
 # else
 .code   32
@@ -460,7 +463,7 @@ sha256_block_data_order_neon:
 	stmdb	sp!,{r4-r12,lr}
=20
 	sub	$H,sp,#16*4+16
-	adr	$Ktbl,K256
+	adrl	$Ktbl,K256
 	bic	$H,$H,#15		@ align for 128-bit stores
 	mov	$t2,sp
 	mov	sp,$H			@ alloca

--------------060603060000010008080405
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--------------060603060000010008080405--
