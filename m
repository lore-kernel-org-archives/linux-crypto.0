From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm64/sha256 - add support for SHA256 using NEON instructions
Date: Thu, 29 Sep 2016 15:51:43 -0700
Message-ID: <1475189503-9175-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1475189503-9175-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: appro@openssl.org, victor.chong@linaro.org,
        daniel.thompson@linaro.org, will.deacon@arm.com,
        catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33325 "EHLO
        mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935097AbcI2Wvt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Sep 2016 18:51:49 -0400
Received: by mail-pa0-f41.google.com with SMTP id cd13so28636996pac.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2016 15:51:49 -0700 (PDT)
In-Reply-To: <1475189503-9175-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a port to arm64 of the NEON implementation of SHA256 that lives
under arch/arm/crypto.

Due to the fact that the AArch64 assembler dialect deviates from the
32-bit ARM one in ways that makes sharing code problematic, and given
that this version only uses the NEON version whereas the original
implementation supports plain ALU assembler, NEON and Crypto Extensions,
this code is built from a version sha256-armv4.pl that has been
transliterated to the AArch64 NEON dialect.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig               |   5 +
 arch/arm64/crypto/Makefile              |  11 +
 arch/arm64/crypto/sha256-armv4.pl       | 413 +++++++++
 arch/arm64/crypto/sha256-core.S_shipped | 883 ++++++++++++++++++++
 arch/arm64/crypto/sha256_neon_glue.c    | 103 +++
 5 files changed, 1415 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2cf32e9887e1..d32371198474 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -18,6 +18,11 @@ config CRYPTO_SHA2_ARM64_CE
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_HASH
 
+config CRYPTO_SHA2_ARM64_NEON
+	tristate "SHA-224/SHA-256 digest algorithm (ARMv8 NEON)"
+	depends on ARM64 && KERNEL_MODE_NEON
+	select CRYPTO_HASH
+
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH (for GCM chaining mode) using ARMv8 Crypto Extensions"
 	depends on ARM64 && KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index abb79b3cfcfe..5156ebee0488 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -29,6 +29,9 @@ aes-ce-blk-y := aes-glue-ce.o aes-ce.o
 obj-$(CONFIG_CRYPTO_AES_ARM64_NEON_BLK) += aes-neon-blk.o
 aes-neon-blk-y := aes-glue-neon.o aes-neon.o
 
+obj-$(CONFIG_CRYPTO_SHA2_ARM64_NEON) := sha256-neon.o
+sha256-neon-y := sha256_neon_glue.o sha256-core.o
+
 AFLAGS_aes-ce.o		:= -DINTERLEAVE=4
 AFLAGS_aes-neon.o	:= -DINTERLEAVE=4
 
@@ -40,3 +43,11 @@ CFLAGS_crc32-arm64.o	:= -mcpu=generic+crc
 
 $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
 	$(call if_changed_rule,cc_o_c)
+
+quiet_cmd_perl = PERL    $@
+      cmd_perl = $(PERL) $(<) > $(@)
+
+$(src)/sha256-core.S_shipped: $(src)/sha256-armv4.pl
+	$(call cmd,perl)
+
+.PRECIOUS: $(obj)/sha256-core.S
diff --git a/arch/arm64/crypto/sha256-armv4.pl b/arch/arm64/crypto/sha256-armv4.pl
new file mode 100644
index 000000000000..9ff788339b1c
--- /dev/null
+++ b/arch/arm64/crypto/sha256-armv4.pl
@@ -0,0 +1,413 @@
+#!/usr/bin/env perl
+
+#
+# AArch64 port of the OpenSSL SHA256 implementation for ARM NEON
+#
+# Copyright (c) 2016 Linaro Ltd. <ard.biesheuvel@linaro.org>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+# ====================================================================
+# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
+# project. The module is, however, dual licensed under OpenSSL and
+# CRYPTOGAMS licenses depending on where you obtain it. For further
+# details see http://www.openssl.org/~appro/cryptogams/.
+#
+# Permission to use under GPL terms is granted.
+# ====================================================================
+
+# SHA256 block procedure for ARMv4. May 2007.
+
+# Performance is ~2x better than gcc 3.4 generated code and in "abso-
+# lute" terms is ~2250 cycles per 64-byte block or ~35 cycles per
+# byte [on single-issue Xscale PXA250 core].
+
+# July 2010.
+#
+# Rescheduling for dual-issue pipeline resulted in 22% improvement on
+# Cortex A8 core and ~20 cycles per processed byte.
+
+# February 2011.
+#
+# Profiler-assisted and platform-specific optimization resulted in 16%
+# improvement on Cortex A8 core and ~15.4 cycles per processed byte.
+
+# September 2013.
+#
+# Add NEON implementation. On Cortex A8 it was measured to process one
+# byte in 12.5 cycles or 23% faster than integer-only code. Snapdragon
+# S4 does it in 12.5 cycles too, but it's 50% faster than integer-only
+# code (meaning that latter performs sub-optimally, nothing was done
+# about it).
+
+# May 2014.
+#
+# Add ARMv8 code path performing at 2.0 cpb on Apple A7.
+
+while (($output=shift) && ($output!~/^\w[\w\-]*\.\w+$/)) {}
+open STDOUT,">$output";
+
+$ctx="x0";	$t0="w0";	$xt0="x0";
+$inp="x1";	$t4="w1";	$xt4="x1";
+$len="x2";	$t1="w2";	$xt1="x2";
+		$t3="w3";
+$A="w4";
+$B="w5";
+$C="w6";
+$D="w7";
+$E="w8";
+$F="w9";
+$G="w10";
+$H="w11";
+@V=($A,$B,$C,$D,$E,$F,$G,$H);
+$t2="w12";
+$xt2="x12";
+$Ktbl="x14";
+
+@Sigma0=( 2,13,22);
+@Sigma1=( 6,11,25);
+@sigma0=( 7,18, 3);
+@sigma1=(17,19,10);
+
+######################################################################
+# NEON stuff
+#
+{{{
+my @VB=map("v$_.16b",(0..3));
+my @VS=map("v$_.4s",(0..3));
+
+my ($TS0,$TS1,$TS2,$TS3,$TS4,$TS5,$TS6,$TS7)=("v4.4s","v5.4s","v6.4s","v7.4s","v8.4s","v9.4s","v10.4s","v11.4s");
+my ($TB0,$TB1,$TB2,$TB3,$TB4,$TB5,$TB6,$TB7)=("v4.16b","v5.16b","v6.16b","v7.16b","v8.16b","v9.16b","v10.16b","v11.16b");
+my ($TD5HI,$TD5LO,$TD7LO)=("v9.d[1]", "d9", "v11.d[0]");
+my $Xfer=$xt4;
+my $j=0;
+
+sub AUTOLOAD()          # thunk [simplified] x86-style perlasm
+{ my $opcode = $AUTOLOAD; $opcode =~ s/.*:://; $opcode =~ s/_/\./;
+  my $arg = pop;
+    $arg = "#$arg" if ($arg*1 eq $arg);
+    $code .= "\t$opcode\t".join(',',@_,$arg)."\n";
+}
+
+sub Xupdate()
+{ use integer;
+  my $body = shift;
+  my @insns = (&$body,&$body,&$body,&$body);
+  my ($a,$b,$c,$d,$e,$f,$g,$h);
+
+	&ext		($TB0,@VB[0],@VB[1],4);	# X[1..4]
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&ext		($TB1,@VB[2],@VB[3],4);	# X[9..12]
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&ushr		($TS2,$TS0,$sigma0[0]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&add 		(@VS[0],@VS[0],$TS1);	# X[0..3] += X[9..12]
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&ushr		($TS1,$TS0,$sigma0[2]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&sli		($TS2,$TS0,32-$sigma0[0]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&ushr		($TS3,$TS0,$sigma0[1]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&eor		($TB1,$TB1,$TB2);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&sli		($TS3,$TS0,32-$sigma0[1]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &ushr		($TS4,@VS[3],$sigma1[0]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&eor		($TB1,$TB1,$TB3);	# sigma0(X[1..4])
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &sli		($TS4,@VS[3],32-$sigma1[0]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &ushr		($TS5,@VS[3],$sigma1[2]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&add		(@VS[0],@VS[0],$TS1);	# X[0..3] += sigma0(X[1..4])
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &eor		($TB5,$TB5,$TB4);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &ushr		($TS4,@VS[3],$sigma1[1]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &sli		($TS4,@VS[3],32-$sigma1[1]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &eor		($TB5,$TB5,$TB4);	# sigma1(X[14..15])
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&mov		($TD5LO, $TD5HI);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&add		(@VS[0],@VS[0],$TS5);	# X[0..1] += sigma1(X[14..15])
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &ushr		($TS6,@VS[0],$sigma1[0]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &sli		($TS6,@VS[0],32-$sigma1[0]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &ushr		($TS7,@VS[0],$sigma1[2]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &eor		($TB7,$TB7,$TB6);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &ushr		($TS6,@VS[0],$sigma1[1]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&ld1		("{$TS0}","[$Ktbl], #16");
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &sli		($TS6,@VS[0],32-$sigma1[1]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	  &eor		($TB7,$TB7,$TB6);	# sigma1(X[16..17])
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&eor		($TB5,$TB5,$TB5);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&mov		($TD5HI, $TD7LO);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&add		(@VS[0],@VS[0],$TS5);	# X[0..3] += sigma1(X[14..17])
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&add		($TS0,$TS0,@VS[0]);
+	 while($#insns>=2) { eval(shift(@insns)); }
+	&st1		("{$TS0}","[$Xfer], #16");
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+
+	push(@VB,shift(@VB));		# "rotate" X[]
+	push(@VS,shift(@VS));		# "rotate" X[]
+}
+
+sub Xpreload()
+{ use integer;
+  my $body = shift;
+  my @insns = (&$body,&$body,&$body,&$body);
+  my ($a,$b,$c,$d,$e,$f,$g,$h);
+
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&ld1		("{$TS0}","[$Ktbl], #16");
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&rev32		(@VB[0],@VB[0]);
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	 eval(shift(@insns));
+	&add		($TS0,$TS0,@VS[0]);
+	 foreach (@insns) { eval; }	# remaining instructions
+	&st1		("{$TS0}","[$Xfer], #16");
+
+	push(@VB,shift(@VB));		# "rotate" X[]
+	push(@VS,shift(@VS));		# "rotate" X[]
+}
+
+sub body_00_15 () {
+	(
+	'($a,$b,$c,$d,$e,$f,$g,$h)=@V;'.
+	'&add	($h,$h,$t1)',			# h+=X[i]+K[i]
+	'&eor	($t1,$f,$g)',
+	'&eor	($t0,$e,$e,"ror#".($Sigma1[1]-$Sigma1[0]))',
+	'&add	($a,$a,$t2)',			# h+=Maj(a,b,c) from the past
+	'&and	($t1,$t1,$e)',
+	'&eor	($t2,$t0,$e,"ror#".($Sigma1[2]-$Sigma1[0]))',	# Sigma1(e)
+	'&eor	($t0,$a,$a,"ror#".($Sigma0[1]-$Sigma0[0]))',
+	'&ror	($t2,$t2,"#$Sigma1[0]")',
+	'&eor	($t1,$t1,$g)',			# Ch(e,f,g)
+	'&add	($h,$h,$t2)',			# h+=Sigma1(e)
+	'&eor	($t2,$a,$b)',			# a^b, b^c in next round
+	'&eor	($t0,$t0,$a,"ror#".($Sigma0[2]-$Sigma0[0]))',	# Sigma0(a)
+	'&add	($h,$h,$t1)',			# h+=Ch(e,f,g)
+	'&ldr	($t1,sprintf "[sp,#%d]",4*(($j+1)&15))	if (($j&15)!=15);'.
+	'&ldr	($t1,"[$Ktbl]")				if ($j==15);'.
+	'&ldr	($xt1,"[sp,#64]")			if ($j==31)',
+	'&and	($t3,$t3,$t2)',			# (b^c)&=(a^b)
+	'&ror	($t0,$t0,"#$Sigma0[0]")',
+	'&add	($d,$d,$h)',			# d+=h
+	'&add	($h,$h,$t0);'.			# h+=Sigma0(a)
+	'&eor	($t3,$t3,$b)',			# Maj(a,b,c)
+	'$j++;	unshift(@V,pop(@V)); ($t2,$t3)=($t3,$t2);'
+	)
+}
+
+$code.=<<___;
+
+.text
+.type	K256,%object
+.align	5
+K256:
+.word	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
+.word	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
+.word	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
+.word	0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
+.word	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
+.word	0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
+.word	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
+.word	0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
+.word	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
+.word	0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
+.word	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
+.word	0xd192e819,0xd6990624,0xf40e3585,0x106aa070
+.word	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
+.word	0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
+.word	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
+.word	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
+.size	K256,.-K256
+.word	0				// terminator
+
+.global	sha256_block_data_order_neon
+.type	sha256_block_data_order_neon,%function
+.align	4
+sha256_block_data_order_neon:
+.LNEON:
+	stp	x29, x30, [sp, #-16]!
+	mov	x29, sp
+	sub	sp,sp,#16*4+32
+	adr	$Ktbl,K256
+	bic	x15,x15,#15		// align for 128-bit stores
+	add	$len,$inp,$len,lsl#6	// len to point at the end of inp
+
+	ld1		{@VB[0]},[$inp], #16
+	ld1		{@VB[1]},[$inp], #16
+	ld1		{@VB[2]},[$inp], #16
+	ld1		{@VB[3]},[$inp], #16
+	ld1		{$TS0},[$Ktbl], #16
+	ld1		{$TS1},[$Ktbl], #16
+	ld1		{$TS2},[$Ktbl], #16
+	ld1		{$TS3},[$Ktbl], #16
+	rev32		@VB[0],@VB[0]		// yes, even on
+	str		$ctx,[sp,#64]
+	rev32		@VB[1],@VB[1]		// big-endian
+	str		$inp,[sp,#72]
+	mov		$Xfer,sp
+	rev32		@VB[2],@VB[2]
+	str		$len,[sp,#80]
+	rev32		@VB[3],@VB[3]
+	add		$TS0,$TS0,@VS[0]
+	add		$TS1,$TS1,@VS[1]
+	st1		{$TS0},[$Xfer], #16
+	add		$TS2,$TS2,@VS[2]
+	st1		{$TS1},[$Xfer], #16
+	add		$TS3,$TS3,@VS[3]
+	st1		{$TS2-$TS3},[$Xfer], #32
+
+	ldp		$A, $B, [$ctx]
+	ldp		$C, $D, [$ctx, #8]
+	ldp		$E, $F, [$ctx, #16]
+	ldp		$G, $H, [$ctx, #24]
+	sub		$Xfer,$Xfer,#64
+	ldr		$t1,[sp,#0]
+	mov		$xt2,xzr
+	eor		$t3,$B,$C
+	b		.L_00_48
+
+.align	4
+.L_00_48:
+___
+	&Xupdate(\&body_00_15);
+	&Xupdate(\&body_00_15);
+	&Xupdate(\&body_00_15);
+	&Xupdate(\&body_00_15);
+$code.=<<___;
+	cmp	$t1,#0				// check for K256 terminator
+	ldr	$t1,[sp,#0]
+	sub	$Xfer,$Xfer,#64
+	bne	.L_00_48
+
+	ldr		$inp,[sp,#72]
+	ldr		$xt0,[sp,#80]
+	sub		$Ktbl,$Ktbl,#256	// rewind $Ktbl
+	cmp		$inp,$xt0
+	mov		$xt0, #64
+	csel		$xt0, $xt0, xzr, eq
+	sub		$inp,$inp,$xt0		// avoid SEGV
+	ld1		{@VS[0]},[$inp], #16	// load next input block
+	ld1		{@VS[1]},[$inp], #16
+	ld1		{@VS[2]},[$inp], #16
+	ld1		{@VS[3]},[$inp], #16
+	str		$inp,[sp,#72]
+	mov		$Xfer,sp
+___
+	&Xpreload(\&body_00_15);
+	&Xpreload(\&body_00_15);
+	&Xpreload(\&body_00_15);
+	&Xpreload(\&body_00_15);
+$code.=<<___;
+	ldr	$t0,[$xt1,#0]
+	add	$A,$A,$t2			// h+=Maj(a,b,c) from the past
+	ldr	$t2,[$xt1,#4]
+	ldr	$t3,[$xt1,#8]
+	ldr	$t4,[$xt1,#12]
+	add	$A,$A,$t0			// accumulate
+	ldr	$t0,[$xt1,#16]
+	add	$B,$B,$t2
+	ldr	$t2,[$xt1,#20]
+	add	$C,$C,$t3
+	ldr	$t3,[$xt1,#24]
+	add	$D,$D,$t4
+	ldr	$t4,[$xt1,#28]
+	add	$E,$E,$t0
+	str	$A,[$xt1],#4
+	add	$F,$F,$t2
+	str	$B,[$xt1],#4
+	add	$G,$G,$t3
+	str	$C,[$xt1],#4
+	add	$H,$H,$t4
+	str	$D,[$xt1],#4
+
+	stp	$E, $F, [$xt1]
+	stp	$G, $H, [$xt1, #8]
+
+	b.eq	0f
+	mov	$Xfer,sp
+	ldr	$t1,[sp,#0]
+	eor	$t2,$t2,$t2
+	eor	$t3,$B,$C
+	b	.L_00_48
+
+0:	add	sp,sp,#16*4+32
+	ldp	x29, x30, [sp], #16
+	ret
+
+.size	sha256_block_data_order_neon,.-sha256_block_data_order_neon
+___
+}}}
+
+foreach (split($/,$code)) {
+
+	s/\`([^\`]*)\`/eval $1/geo;
+
+	print $_,"\n";
+}
+
+close STDOUT; # enforce flush
+	
diff --git a/arch/arm64/crypto/sha256-core.S_shipped b/arch/arm64/crypto/sha256-core.S_shipped
new file mode 100644
index 000000000000..1d9b55367ee0
--- /dev/null
+++ b/arch/arm64/crypto/sha256-core.S_shipped
@@ -0,0 +1,883 @@
+
+.text
+.type	K256,%object
+.align	5
+K256:
+.word	0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
+.word	0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
+.word	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
+.word	0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
+.word	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
+.word	0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
+.word	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
+.word	0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
+.word	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
+.word	0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
+.word	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
+.word	0xd192e819,0xd6990624,0xf40e3585,0x106aa070
+.word	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
+.word	0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
+.word	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
+.word	0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
+.size	K256,.-K256
+.word	0				// terminator
+
+.global	sha256_block_data_order_neon
+.type	sha256_block_data_order_neon,%function
+.align	4
+sha256_block_data_order_neon:
+.LNEON:
+	stp	x29, x30, [sp, #-16]!
+	mov	x29, sp
+	sub	sp,sp,#16*4+32
+	adr	x14,K256
+	bic	x15,x15,#15		// align for 128-bit stores
+	add	x2,x1,x2,lsl#6	// len to point at the end of inp
+
+	ld1		{v0.16b},[x1], #16
+	ld1		{v1.16b},[x1], #16
+	ld1		{v2.16b},[x1], #16
+	ld1		{v3.16b},[x1], #16
+	ld1		{v4.4s},[x14], #16
+	ld1		{v5.4s},[x14], #16
+	ld1		{v6.4s},[x14], #16
+	ld1		{v7.4s},[x14], #16
+	rev32		v0.16b,v0.16b		// yes, even on
+	str		x0,[sp,#64]
+	rev32		v1.16b,v1.16b		// big-endian
+	str		x1,[sp,#72]
+	mov		x1,sp
+	rev32		v2.16b,v2.16b
+	str		x2,[sp,#80]
+	rev32		v3.16b,v3.16b
+	add		v4.4s,v4.4s,v0.4s
+	add		v5.4s,v5.4s,v1.4s
+	st1		{v4.4s},[x1], #16
+	add		v6.4s,v6.4s,v2.4s
+	st1		{v5.4s},[x1], #16
+	add		v7.4s,v7.4s,v3.4s
+	st1		{v6.4s-v7.4s},[x1], #32
+
+	ldp		w4, w5, [x0]
+	ldp		w6, w7, [x0, #8]
+	ldp		w8, w9, [x0, #16]
+	ldp		w10, w11, [x0, #24]
+	sub		x1,x1,#64
+	ldr		w2,[sp,#0]
+	mov		x12,xzr
+	eor		w3,w5,w6
+	b		.L_00_48
+
+.align	4
+.L_00_48:
+	ext	v4.16b,v0.16b,v1.16b,#4
+	add	w11,w11,w2
+	eor	w2,w9,w10
+	eor	w0,w8,w8,ror#5
+	ext	v5.16b,v2.16b,v3.16b,#4
+	add	w4,w4,w12
+	and	w2,w2,w8
+	eor	w12,w0,w8,ror#19
+	ushr	v6.4s,v4.4s,#7
+	eor	w0,w4,w4,ror#11
+	ror	w12,w12,#6
+	add	v0.4s,v0.4s,v5.4s
+	eor	w2,w2,w10
+	add	w11,w11,w12
+	ushr	v5.4s,v4.4s,#3
+	eor	w12,w4,w5
+	eor	w0,w0,w4,ror#20
+	sli	v6.4s,v4.4s,#25
+	add	w11,w11,w2
+	ldr	w2,[sp,#4]
+	ushr	v7.4s,v4.4s,#18
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	eor	v5.16b,v5.16b,v6.16b
+	add	w7,w7,w11
+	add	w11,w11,w0
+	eor	w3,w3,w5
+	sli	v7.4s,v4.4s,#14
+	add	w10,w10,w2
+	ushr	v8.4s,v3.4s,#17
+	eor	w2,w8,w9
+	eor	w0,w7,w7,ror#5
+	eor	v5.16b,v5.16b,v7.16b
+	add	w11,w11,w3
+	and	w2,w2,w7
+	sli	v8.4s,v3.4s,#15
+	eor	w3,w0,w7,ror#19
+	eor	w0,w11,w11,ror#11
+	ushr	v9.4s,v3.4s,#10
+	ror	w3,w3,#6
+	eor	w2,w2,w9
+	add	v0.4s,v0.4s,v5.4s
+	add	w10,w10,w3
+	eor	w3,w11,w4
+	eor	v9.16b,v9.16b,v8.16b
+	eor	w0,w0,w11,ror#20
+	add	w10,w10,w2
+	ushr	v8.4s,v3.4s,#19
+	ldr	w2,[sp,#8]
+	and	w12,w12,w3
+	sli	v8.4s,v3.4s,#13
+	ror	w0,w0,#2
+	add	w6,w6,w10
+	eor	v9.16b,v9.16b,v8.16b
+	add	w10,w10,w0
+	eor	w12,w12,w4
+	mov	d9,v9.d[1]
+	add	w9,w9,w2
+	eor	w2,w7,w8
+	add	v0.4s,v0.4s,v9.4s
+	eor	w0,w6,w6,ror#5
+	add	w10,w10,w12
+	ushr	v10.4s,v0.4s,#17
+	and	w2,w2,w6
+	eor	w12,w0,w6,ror#19
+	sli	v10.4s,v0.4s,#15
+	eor	w0,w10,w10,ror#11
+	ror	w12,w12,#6
+	ushr	v11.4s,v0.4s,#10
+	eor	w2,w2,w8
+	add	w9,w9,w12
+	eor	v11.16b,v11.16b,v10.16b
+	eor	w12,w10,w11
+	eor	w0,w0,w10,ror#20
+	ushr	v10.4s,v0.4s,#19
+	add	w9,w9,w2
+	ldr	w2,[sp,#12]
+	ld1	{v4.4s},[x14], #16
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	sli	v10.4s,v0.4s,#13
+	add	w5,w5,w9
+	add	w9,w9,w0
+	eor	w3,w3,w11
+	eor	v11.16b,v11.16b,v10.16b
+	add	w8,w8,w2
+	eor	v9.16b,v9.16b,v9.16b
+	eor	w2,w6,w7
+	eor	w0,w5,w5,ror#5
+	mov	v9.d[1],v11.d[0]
+	add	w9,w9,w3
+	and	w2,w2,w5
+	add	v0.4s,v0.4s,v9.4s
+	eor	w3,w0,w5,ror#19
+	eor	w0,w9,w9,ror#11
+	add	v4.4s,v4.4s,v0.4s
+	ror	w3,w3,#6
+	eor	w2,w2,w7
+	add	w8,w8,w3
+	eor	w3,w9,w10
+	eor	w0,w0,w9,ror#20
+	add	w8,w8,w2
+	ldr	w2,[sp,#16]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w4,w4,w8
+	st1	{v4.4s},[x1], #16
+	add	w8,w8,w0
+	eor	w12,w12,w10
+	ext	v4.16b,v1.16b,v2.16b,#4
+	add	w7,w7,w2
+	eor	w2,w5,w6
+	eor	w0,w4,w4,ror#5
+	ext	v5.16b,v3.16b,v0.16b,#4
+	add	w8,w8,w12
+	and	w2,w2,w4
+	eor	w12,w0,w4,ror#19
+	ushr	v6.4s,v4.4s,#7
+	eor	w0,w8,w8,ror#11
+	ror	w12,w12,#6
+	add	v1.4s,v1.4s,v5.4s
+	eor	w2,w2,w6
+	add	w7,w7,w12
+	ushr	v5.4s,v4.4s,#3
+	eor	w12,w8,w9
+	eor	w0,w0,w8,ror#20
+	sli	v6.4s,v4.4s,#25
+	add	w7,w7,w2
+	ldr	w2,[sp,#20]
+	ushr	v7.4s,v4.4s,#18
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	eor	v5.16b,v5.16b,v6.16b
+	add	w11,w11,w7
+	add	w7,w7,w0
+	eor	w3,w3,w9
+	sli	v7.4s,v4.4s,#14
+	add	w6,w6,w2
+	ushr	v8.4s,v0.4s,#17
+	eor	w2,w4,w5
+	eor	w0,w11,w11,ror#5
+	eor	v5.16b,v5.16b,v7.16b
+	add	w7,w7,w3
+	and	w2,w2,w11
+	sli	v8.4s,v0.4s,#15
+	eor	w3,w0,w11,ror#19
+	eor	w0,w7,w7,ror#11
+	ushr	v9.4s,v0.4s,#10
+	ror	w3,w3,#6
+	eor	w2,w2,w5
+	add	v1.4s,v1.4s,v5.4s
+	add	w6,w6,w3
+	eor	w3,w7,w8
+	eor	v9.16b,v9.16b,v8.16b
+	eor	w0,w0,w7,ror#20
+	add	w6,w6,w2
+	ushr	v8.4s,v0.4s,#19
+	ldr	w2,[sp,#24]
+	and	w12,w12,w3
+	sli	v8.4s,v0.4s,#13
+	ror	w0,w0,#2
+	add	w10,w10,w6
+	eor	v9.16b,v9.16b,v8.16b
+	add	w6,w6,w0
+	eor	w12,w12,w8
+	mov	d9,v9.d[1]
+	add	w5,w5,w2
+	eor	w2,w11,w4
+	add	v1.4s,v1.4s,v9.4s
+	eor	w0,w10,w10,ror#5
+	add	w6,w6,w12
+	ushr	v10.4s,v1.4s,#17
+	and	w2,w2,w10
+	eor	w12,w0,w10,ror#19
+	sli	v10.4s,v1.4s,#15
+	eor	w0,w6,w6,ror#11
+	ror	w12,w12,#6
+	ushr	v11.4s,v1.4s,#10
+	eor	w2,w2,w4
+	add	w5,w5,w12
+	eor	v11.16b,v11.16b,v10.16b
+	eor	w12,w6,w7
+	eor	w0,w0,w6,ror#20
+	ushr	v10.4s,v1.4s,#19
+	add	w5,w5,w2
+	ldr	w2,[sp,#28]
+	ld1	{v4.4s},[x14], #16
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	sli	v10.4s,v1.4s,#13
+	add	w9,w9,w5
+	add	w5,w5,w0
+	eor	w3,w3,w7
+	eor	v11.16b,v11.16b,v10.16b
+	add	w4,w4,w2
+	eor	v9.16b,v9.16b,v9.16b
+	eor	w2,w10,w11
+	eor	w0,w9,w9,ror#5
+	mov	v9.d[1],v11.d[0]
+	add	w5,w5,w3
+	and	w2,w2,w9
+	add	v1.4s,v1.4s,v9.4s
+	eor	w3,w0,w9,ror#19
+	eor	w0,w5,w5,ror#11
+	add	v4.4s,v4.4s,v1.4s
+	ror	w3,w3,#6
+	eor	w2,w2,w11
+	add	w4,w4,w3
+	eor	w3,w5,w6
+	eor	w0,w0,w5,ror#20
+	add	w4,w4,w2
+	ldr	w2,[sp,#32]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w8,w8,w4
+	st1	{v4.4s},[x1], #16
+	add	w4,w4,w0
+	eor	w12,w12,w6
+	ext	v4.16b,v2.16b,v3.16b,#4
+	add	w11,w11,w2
+	eor	w2,w9,w10
+	eor	w0,w8,w8,ror#5
+	ext	v5.16b,v0.16b,v1.16b,#4
+	add	w4,w4,w12
+	and	w2,w2,w8
+	eor	w12,w0,w8,ror#19
+	ushr	v6.4s,v4.4s,#7
+	eor	w0,w4,w4,ror#11
+	ror	w12,w12,#6
+	add	v2.4s,v2.4s,v5.4s
+	eor	w2,w2,w10
+	add	w11,w11,w12
+	ushr	v5.4s,v4.4s,#3
+	eor	w12,w4,w5
+	eor	w0,w0,w4,ror#20
+	sli	v6.4s,v4.4s,#25
+	add	w11,w11,w2
+	ldr	w2,[sp,#36]
+	ushr	v7.4s,v4.4s,#18
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	eor	v5.16b,v5.16b,v6.16b
+	add	w7,w7,w11
+	add	w11,w11,w0
+	eor	w3,w3,w5
+	sli	v7.4s,v4.4s,#14
+	add	w10,w10,w2
+	ushr	v8.4s,v1.4s,#17
+	eor	w2,w8,w9
+	eor	w0,w7,w7,ror#5
+	eor	v5.16b,v5.16b,v7.16b
+	add	w11,w11,w3
+	and	w2,w2,w7
+	sli	v8.4s,v1.4s,#15
+	eor	w3,w0,w7,ror#19
+	eor	w0,w11,w11,ror#11
+	ushr	v9.4s,v1.4s,#10
+	ror	w3,w3,#6
+	eor	w2,w2,w9
+	add	v2.4s,v2.4s,v5.4s
+	add	w10,w10,w3
+	eor	w3,w11,w4
+	eor	v9.16b,v9.16b,v8.16b
+	eor	w0,w0,w11,ror#20
+	add	w10,w10,w2
+	ushr	v8.4s,v1.4s,#19
+	ldr	w2,[sp,#40]
+	and	w12,w12,w3
+	sli	v8.4s,v1.4s,#13
+	ror	w0,w0,#2
+	add	w6,w6,w10
+	eor	v9.16b,v9.16b,v8.16b
+	add	w10,w10,w0
+	eor	w12,w12,w4
+	mov	d9,v9.d[1]
+	add	w9,w9,w2
+	eor	w2,w7,w8
+	add	v2.4s,v2.4s,v9.4s
+	eor	w0,w6,w6,ror#5
+	add	w10,w10,w12
+	ushr	v10.4s,v2.4s,#17
+	and	w2,w2,w6
+	eor	w12,w0,w6,ror#19
+	sli	v10.4s,v2.4s,#15
+	eor	w0,w10,w10,ror#11
+	ror	w12,w12,#6
+	ushr	v11.4s,v2.4s,#10
+	eor	w2,w2,w8
+	add	w9,w9,w12
+	eor	v11.16b,v11.16b,v10.16b
+	eor	w12,w10,w11
+	eor	w0,w0,w10,ror#20
+	ushr	v10.4s,v2.4s,#19
+	add	w9,w9,w2
+	ldr	w2,[sp,#44]
+	ld1	{v4.4s},[x14], #16
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	sli	v10.4s,v2.4s,#13
+	add	w5,w5,w9
+	add	w9,w9,w0
+	eor	w3,w3,w11
+	eor	v11.16b,v11.16b,v10.16b
+	add	w8,w8,w2
+	eor	v9.16b,v9.16b,v9.16b
+	eor	w2,w6,w7
+	eor	w0,w5,w5,ror#5
+	mov	v9.d[1],v11.d[0]
+	add	w9,w9,w3
+	and	w2,w2,w5
+	add	v2.4s,v2.4s,v9.4s
+	eor	w3,w0,w5,ror#19
+	eor	w0,w9,w9,ror#11
+	add	v4.4s,v4.4s,v2.4s
+	ror	w3,w3,#6
+	eor	w2,w2,w7
+	add	w8,w8,w3
+	eor	w3,w9,w10
+	eor	w0,w0,w9,ror#20
+	add	w8,w8,w2
+	ldr	w2,[sp,#48]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w4,w4,w8
+	st1	{v4.4s},[x1], #16
+	add	w8,w8,w0
+	eor	w12,w12,w10
+	ext	v4.16b,v3.16b,v0.16b,#4
+	add	w7,w7,w2
+	eor	w2,w5,w6
+	eor	w0,w4,w4,ror#5
+	ext	v5.16b,v1.16b,v2.16b,#4
+	add	w8,w8,w12
+	and	w2,w2,w4
+	eor	w12,w0,w4,ror#19
+	ushr	v6.4s,v4.4s,#7
+	eor	w0,w8,w8,ror#11
+	ror	w12,w12,#6
+	add	v3.4s,v3.4s,v5.4s
+	eor	w2,w2,w6
+	add	w7,w7,w12
+	ushr	v5.4s,v4.4s,#3
+	eor	w12,w8,w9
+	eor	w0,w0,w8,ror#20
+	sli	v6.4s,v4.4s,#25
+	add	w7,w7,w2
+	ldr	w2,[sp,#52]
+	ushr	v7.4s,v4.4s,#18
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	eor	v5.16b,v5.16b,v6.16b
+	add	w11,w11,w7
+	add	w7,w7,w0
+	eor	w3,w3,w9
+	sli	v7.4s,v4.4s,#14
+	add	w6,w6,w2
+	ushr	v8.4s,v2.4s,#17
+	eor	w2,w4,w5
+	eor	w0,w11,w11,ror#5
+	eor	v5.16b,v5.16b,v7.16b
+	add	w7,w7,w3
+	and	w2,w2,w11
+	sli	v8.4s,v2.4s,#15
+	eor	w3,w0,w11,ror#19
+	eor	w0,w7,w7,ror#11
+	ushr	v9.4s,v2.4s,#10
+	ror	w3,w3,#6
+	eor	w2,w2,w5
+	add	v3.4s,v3.4s,v5.4s
+	add	w6,w6,w3
+	eor	w3,w7,w8
+	eor	v9.16b,v9.16b,v8.16b
+	eor	w0,w0,w7,ror#20
+	add	w6,w6,w2
+	ushr	v8.4s,v2.4s,#19
+	ldr	w2,[sp,#56]
+	and	w12,w12,w3
+	sli	v8.4s,v2.4s,#13
+	ror	w0,w0,#2
+	add	w10,w10,w6
+	eor	v9.16b,v9.16b,v8.16b
+	add	w6,w6,w0
+	eor	w12,w12,w8
+	mov	d9,v9.d[1]
+	add	w5,w5,w2
+	eor	w2,w11,w4
+	add	v3.4s,v3.4s,v9.4s
+	eor	w0,w10,w10,ror#5
+	add	w6,w6,w12
+	ushr	v10.4s,v3.4s,#17
+	and	w2,w2,w10
+	eor	w12,w0,w10,ror#19
+	sli	v10.4s,v3.4s,#15
+	eor	w0,w6,w6,ror#11
+	ror	w12,w12,#6
+	ushr	v11.4s,v3.4s,#10
+	eor	w2,w2,w4
+	add	w5,w5,w12
+	eor	v11.16b,v11.16b,v10.16b
+	eor	w12,w6,w7
+	eor	w0,w0,w6,ror#20
+	ushr	v10.4s,v3.4s,#19
+	add	w5,w5,w2
+	ldr	w2,[sp,#60]
+	ld1	{v4.4s},[x14], #16
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	sli	v10.4s,v3.4s,#13
+	add	w9,w9,w5
+	add	w5,w5,w0
+	eor	w3,w3,w7
+	eor	v11.16b,v11.16b,v10.16b
+	add	w4,w4,w2
+	eor	v9.16b,v9.16b,v9.16b
+	eor	w2,w10,w11
+	eor	w0,w9,w9,ror#5
+	mov	v9.d[1],v11.d[0]
+	add	w5,w5,w3
+	and	w2,w2,w9
+	add	v3.4s,v3.4s,v9.4s
+	eor	w3,w0,w9,ror#19
+	eor	w0,w5,w5,ror#11
+	add	v4.4s,v4.4s,v3.4s
+	ror	w3,w3,#6
+	eor	w2,w2,w11
+	add	w4,w4,w3
+	eor	w3,w5,w6
+	eor	w0,w0,w5,ror#20
+	add	w4,w4,w2
+	ldr	w2,[x14]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w8,w8,w4
+	st1	{v4.4s},[x1], #16
+	add	w4,w4,w0
+	eor	w12,w12,w6
+	cmp	w2,#0				// check for K256 terminator
+	ldr	w2,[sp,#0]
+	sub	x1,x1,#64
+	bne	.L_00_48
+
+	ldr		x1,[sp,#72]
+	ldr		x0,[sp,#80]
+	sub		x14,x14,#256	// rewind x14
+	cmp		x1,x0
+	mov		x0, #64
+	csel		x0, x0, xzr, eq
+	sub		x1,x1,x0		// avoid SEGV
+	ld1		{v0.4s},[x1], #16	// load next input block
+	ld1		{v1.4s},[x1], #16
+	ld1		{v2.4s},[x1], #16
+	ld1		{v3.4s},[x1], #16
+	str		x1,[sp,#72]
+	mov		x1,sp
+	add	w11,w11,w2
+	eor	w2,w9,w10
+	eor	w0,w8,w8,ror#5
+	add	w4,w4,w12
+	ld1	{v4.4s},[x14], #16
+	and	w2,w2,w8
+	eor	w12,w0,w8,ror#19
+	eor	w0,w4,w4,ror#11
+	ror	w12,w12,#6
+	rev32	v0.16b,v0.16b
+	eor	w2,w2,w10
+	add	w11,w11,w12
+	eor	w12,w4,w5
+	eor	w0,w0,w4,ror#20
+	add	v4.4s,v4.4s,v0.4s
+	add	w11,w11,w2
+	ldr	w2,[sp,#4]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w7,w7,w11
+	add	w11,w11,w0
+	eor	w3,w3,w5
+	add	w10,w10,w2
+	eor	w2,w8,w9
+	eor	w0,w7,w7,ror#5
+	add	w11,w11,w3
+	and	w2,w2,w7
+	eor	w3,w0,w7,ror#19
+	eor	w0,w11,w11,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w9
+	add	w10,w10,w3
+	eor	w3,w11,w4
+	eor	w0,w0,w11,ror#20
+	add	w10,w10,w2
+	ldr	w2,[sp,#8]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w6,w6,w10
+	add	w10,w10,w0
+	eor	w12,w12,w4
+	add	w9,w9,w2
+	eor	w2,w7,w8
+	eor	w0,w6,w6,ror#5
+	add	w10,w10,w12
+	and	w2,w2,w6
+	eor	w12,w0,w6,ror#19
+	eor	w0,w10,w10,ror#11
+	ror	w12,w12,#6
+	eor	w2,w2,w8
+	add	w9,w9,w12
+	eor	w12,w10,w11
+	eor	w0,w0,w10,ror#20
+	add	w9,w9,w2
+	ldr	w2,[sp,#12]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w5,w5,w9
+	add	w9,w9,w0
+	eor	w3,w3,w11
+	add	w8,w8,w2
+	eor	w2,w6,w7
+	eor	w0,w5,w5,ror#5
+	add	w9,w9,w3
+	and	w2,w2,w5
+	eor	w3,w0,w5,ror#19
+	eor	w0,w9,w9,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w7
+	add	w8,w8,w3
+	eor	w3,w9,w10
+	eor	w0,w0,w9,ror#20
+	add	w8,w8,w2
+	ldr	w2,[sp,#16]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w4,w4,w8
+	add	w8,w8,w0
+	eor	w12,w12,w10
+	st1	{v4.4s},[x1], #16
+	add	w7,w7,w2
+	eor	w2,w5,w6
+	eor	w0,w4,w4,ror#5
+	add	w8,w8,w12
+	ld1	{v4.4s},[x14], #16
+	and	w2,w2,w4
+	eor	w12,w0,w4,ror#19
+	eor	w0,w8,w8,ror#11
+	ror	w12,w12,#6
+	rev32	v1.16b,v1.16b
+	eor	w2,w2,w6
+	add	w7,w7,w12
+	eor	w12,w8,w9
+	eor	w0,w0,w8,ror#20
+	add	v4.4s,v4.4s,v1.4s
+	add	w7,w7,w2
+	ldr	w2,[sp,#20]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w11,w11,w7
+	add	w7,w7,w0
+	eor	w3,w3,w9
+	add	w6,w6,w2
+	eor	w2,w4,w5
+	eor	w0,w11,w11,ror#5
+	add	w7,w7,w3
+	and	w2,w2,w11
+	eor	w3,w0,w11,ror#19
+	eor	w0,w7,w7,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w5
+	add	w6,w6,w3
+	eor	w3,w7,w8
+	eor	w0,w0,w7,ror#20
+	add	w6,w6,w2
+	ldr	w2,[sp,#24]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w10,w10,w6
+	add	w6,w6,w0
+	eor	w12,w12,w8
+	add	w5,w5,w2
+	eor	w2,w11,w4
+	eor	w0,w10,w10,ror#5
+	add	w6,w6,w12
+	and	w2,w2,w10
+	eor	w12,w0,w10,ror#19
+	eor	w0,w6,w6,ror#11
+	ror	w12,w12,#6
+	eor	w2,w2,w4
+	add	w5,w5,w12
+	eor	w12,w6,w7
+	eor	w0,w0,w6,ror#20
+	add	w5,w5,w2
+	ldr	w2,[sp,#28]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w9,w9,w5
+	add	w5,w5,w0
+	eor	w3,w3,w7
+	add	w4,w4,w2
+	eor	w2,w10,w11
+	eor	w0,w9,w9,ror#5
+	add	w5,w5,w3
+	and	w2,w2,w9
+	eor	w3,w0,w9,ror#19
+	eor	w0,w5,w5,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w11
+	add	w4,w4,w3
+	eor	w3,w5,w6
+	eor	w0,w0,w5,ror#20
+	add	w4,w4,w2
+	ldr	w2,[sp,#32]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w8,w8,w4
+	add	w4,w4,w0
+	eor	w12,w12,w6
+	st1	{v4.4s},[x1], #16
+	add	w11,w11,w2
+	eor	w2,w9,w10
+	eor	w0,w8,w8,ror#5
+	add	w4,w4,w12
+	ld1	{v4.4s},[x14], #16
+	and	w2,w2,w8
+	eor	w12,w0,w8,ror#19
+	eor	w0,w4,w4,ror#11
+	ror	w12,w12,#6
+	rev32	v2.16b,v2.16b
+	eor	w2,w2,w10
+	add	w11,w11,w12
+	eor	w12,w4,w5
+	eor	w0,w0,w4,ror#20
+	add	v4.4s,v4.4s,v2.4s
+	add	w11,w11,w2
+	ldr	w2,[sp,#36]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w7,w7,w11
+	add	w11,w11,w0
+	eor	w3,w3,w5
+	add	w10,w10,w2
+	eor	w2,w8,w9
+	eor	w0,w7,w7,ror#5
+	add	w11,w11,w3
+	and	w2,w2,w7
+	eor	w3,w0,w7,ror#19
+	eor	w0,w11,w11,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w9
+	add	w10,w10,w3
+	eor	w3,w11,w4
+	eor	w0,w0,w11,ror#20
+	add	w10,w10,w2
+	ldr	w2,[sp,#40]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w6,w6,w10
+	add	w10,w10,w0
+	eor	w12,w12,w4
+	add	w9,w9,w2
+	eor	w2,w7,w8
+	eor	w0,w6,w6,ror#5
+	add	w10,w10,w12
+	and	w2,w2,w6
+	eor	w12,w0,w6,ror#19
+	eor	w0,w10,w10,ror#11
+	ror	w12,w12,#6
+	eor	w2,w2,w8
+	add	w9,w9,w12
+	eor	w12,w10,w11
+	eor	w0,w0,w10,ror#20
+	add	w9,w9,w2
+	ldr	w2,[sp,#44]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w5,w5,w9
+	add	w9,w9,w0
+	eor	w3,w3,w11
+	add	w8,w8,w2
+	eor	w2,w6,w7
+	eor	w0,w5,w5,ror#5
+	add	w9,w9,w3
+	and	w2,w2,w5
+	eor	w3,w0,w5,ror#19
+	eor	w0,w9,w9,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w7
+	add	w8,w8,w3
+	eor	w3,w9,w10
+	eor	w0,w0,w9,ror#20
+	add	w8,w8,w2
+	ldr	w2,[sp,#48]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w4,w4,w8
+	add	w8,w8,w0
+	eor	w12,w12,w10
+	st1	{v4.4s},[x1], #16
+	add	w7,w7,w2
+	eor	w2,w5,w6
+	eor	w0,w4,w4,ror#5
+	add	w8,w8,w12
+	ld1	{v4.4s},[x14], #16
+	and	w2,w2,w4
+	eor	w12,w0,w4,ror#19
+	eor	w0,w8,w8,ror#11
+	ror	w12,w12,#6
+	rev32	v3.16b,v3.16b
+	eor	w2,w2,w6
+	add	w7,w7,w12
+	eor	w12,w8,w9
+	eor	w0,w0,w8,ror#20
+	add	v4.4s,v4.4s,v3.4s
+	add	w7,w7,w2
+	ldr	w2,[sp,#52]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w11,w11,w7
+	add	w7,w7,w0
+	eor	w3,w3,w9
+	add	w6,w6,w2
+	eor	w2,w4,w5
+	eor	w0,w11,w11,ror#5
+	add	w7,w7,w3
+	and	w2,w2,w11
+	eor	w3,w0,w11,ror#19
+	eor	w0,w7,w7,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w5
+	add	w6,w6,w3
+	eor	w3,w7,w8
+	eor	w0,w0,w7,ror#20
+	add	w6,w6,w2
+	ldr	w2,[sp,#56]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w10,w10,w6
+	add	w6,w6,w0
+	eor	w12,w12,w8
+	add	w5,w5,w2
+	eor	w2,w11,w4
+	eor	w0,w10,w10,ror#5
+	add	w6,w6,w12
+	and	w2,w2,w10
+	eor	w12,w0,w10,ror#19
+	eor	w0,w6,w6,ror#11
+	ror	w12,w12,#6
+	eor	w2,w2,w4
+	add	w5,w5,w12
+	eor	w12,w6,w7
+	eor	w0,w0,w6,ror#20
+	add	w5,w5,w2
+	ldr	w2,[sp,#60]
+	and	w3,w3,w12
+	ror	w0,w0,#2
+	add	w9,w9,w5
+	add	w5,w5,w0
+	eor	w3,w3,w7
+	add	w4,w4,w2
+	eor	w2,w10,w11
+	eor	w0,w9,w9,ror#5
+	add	w5,w5,w3
+	and	w2,w2,w9
+	eor	w3,w0,w9,ror#19
+	eor	w0,w5,w5,ror#11
+	ror	w3,w3,#6
+	eor	w2,w2,w11
+	add	w4,w4,w3
+	eor	w3,w5,w6
+	eor	w0,w0,w5,ror#20
+	add	w4,w4,w2
+	ldr	x2,[sp,#64]
+	and	w12,w12,w3
+	ror	w0,w0,#2
+	add	w8,w8,w4
+	add	w4,w4,w0
+	eor	w12,w12,w6
+	st1	{v4.4s},[x1], #16
+	ldr	w0,[x2,#0]
+	add	w4,w4,w12			// h+=Maj(a,b,c) from the past
+	ldr	w12,[x2,#4]
+	ldr	w3,[x2,#8]
+	ldr	w1,[x2,#12]
+	add	w4,w4,w0			// accumulate
+	ldr	w0,[x2,#16]
+	add	w5,w5,w12
+	ldr	w12,[x2,#20]
+	add	w6,w6,w3
+	ldr	w3,[x2,#24]
+	add	w7,w7,w1
+	ldr	w1,[x2,#28]
+	add	w8,w8,w0
+	str	w4,[x2],#4
+	add	w9,w9,w12
+	str	w5,[x2],#4
+	add	w10,w10,w3
+	str	w6,[x2],#4
+	add	w11,w11,w1
+	str	w7,[x2],#4
+
+	stp	w8, w9, [x2]
+	stp	w10, w11, [x2, #8]
+
+	b.eq	0f
+	mov	x1,sp
+	ldr	w2,[sp,#0]
+	eor	w12,w12,w12
+	eor	w3,w5,w6
+	b	.L_00_48
+
+0:	add	sp,sp,#16*4+32
+	ldp	x29, x30, [sp], #16
+	ret
+
+.size	sha256_block_data_order_neon,.-sha256_block_data_order_neon
diff --git a/arch/arm64/crypto/sha256_neon_glue.c b/arch/arm64/crypto/sha256_neon_glue.c
new file mode 100644
index 000000000000..149a4bb869ea
--- /dev/null
+++ b/arch/arm64/crypto/sha256_neon_glue.c
@@ -0,0 +1,103 @@
+/*
+ * AArch64 port of the OpenSSL SHA256 implementation for ARM NEON
+ *
+ * Copyright (c) 2016 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/internal/hash.h>
+#include <linux/cryptohash.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <crypto/sha.h>
+#include <crypto/sha256_base.h>
+#include <asm/neon.h>
+
+MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 NEON");
+MODULE_AUTHOR("Andy Polyakov <appro@openssl.org>");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+asmlinkage void sha256_block_data_order_neon(u32 *digest, const void *data,
+					     unsigned int num_blks);
+
+static int sha256_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	if ((sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
+		return crypto_sha256_update(desc, data, len);
+
+	kernel_neon_begin_partial(12);
+	sha256_base_do_update(desc, data, len,
+			(sha256_block_fn *)sha256_block_data_order_neon);
+	kernel_neon_end();
+
+	return 0;
+}
+
+static int sha256_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	kernel_neon_begin_partial(12);
+	if (len)
+		sha256_base_do_update(desc, data, len,
+			(sha256_block_fn *)sha256_block_data_order_neon);
+	sha256_base_do_finalize(desc,
+			(sha256_block_fn *)sha256_block_data_order_neon);
+	kernel_neon_end();
+
+	return sha256_base_finish(desc, out);
+}
+
+static int sha256_final(struct shash_desc *desc, u8 *out)
+{
+	return sha256_finup(desc, NULL, 0, out);
+}
+
+static struct shash_alg algs[] = { {
+	.digestsize		= SHA256_DIGEST_SIZE,
+	.init			= sha256_base_init,
+	.update			= sha256_update,
+	.final			= sha256_final,
+	.finup			= sha256_finup,
+	.descsize		= sizeof(struct sha256_state),
+	.base.cra_name		= "sha256",
+	.base.cra_driver_name	= "sha256-neon",
+	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA256_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHA224_DIGEST_SIZE,
+	.init			= sha224_base_init,
+	.update			= sha256_update,
+	.final			= sha256_final,
+	.finup			= sha256_finup,
+	.descsize		= sizeof(struct sha256_state),
+	.base.cra_name		= "sha224",
+	.base.cra_driver_name	= "sha224-neon",
+	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SHA224_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+} };
+
+static int __init sha256_neon_mod_init(void)
+{
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+}
+
+static void __exit sha256_neon_mod_fini(void)
+{
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+}
+
+module_init(sha256_neon_mod_init);
+module_exit(sha256_neon_mod_fini);
-- 
2.7.4
