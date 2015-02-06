From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCHv2 6/7] Add support for VMS instructions by ASM
Date: Fri, 6 Feb 2015 14:59:35 -0200
Message-ID: <20150206165931.GA24289@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:45207 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbbBFQ7j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2015 11:59:39 -0500
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Fri, 6 Feb 2015 14:59:37 -0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

OpenSSL implements optimized ASM algorithms which support
VMX instructions on Power 8 CPU.

These scripts generate an endian-agnostic ASM implementation
in order to support both big and little-endian.
	- aesp8-ppc.pl: implements suport for AES instructions
	implemented by POWER8 processor.
	- ghashp8-ppc.pl: implements support for  GHASH for Power8.
	- ppc-xlate.pl:  ppc assembler distiller.

These code has been adopted from OpenSSL project in collaboration
with the original author (Andy Polyakov <appro@openssl.org>).

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aesp8-ppc.pl   | 1940 +++++++++++++++++++++++++++++=
++++++++
 drivers/crypto/vmx/ghashp8-ppc.pl |  234 +++++
 drivers/crypto/vmx/ppc-xlate.pl   |  226 +++++
 3 files changed, 2400 insertions(+)
 create mode 100755 drivers/crypto/vmx/aesp8-ppc.pl
 create mode 100755 drivers/crypto/vmx/ghashp8-ppc.pl
 create mode 100755 drivers/crypto/vmx/ppc-xlate.pl

diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8=
-ppc.pl
new file mode 100755
index 0000000..3ee8979
--- /dev/null
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -0,0 +1,1940 @@
+#!/usr/bin/env perl
+#
+# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
+# project. The module is, however, dual licensed under OpenSSL and
+# CRYPTOGAMS licenses depending on where you obtain it. For further
+# details see http://www.openssl.org/~appro/cryptogams/.
+# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+#
+# This module implements support for AES instructions as per PowerISA
+# specification version 2.07, first implemented by POWER8 processor.
+# The module is endian-agnostic in sense that it supports both big-
+# and little-endian cases. Data alignment in parallelizable modes is
+# handled with VSX loads and stores, which implies MSR.VSX flag being
+# set. It should also be noted that ISA specification doesn't prohibit
+# alignment exceptions for these instructions on page boundaries.
+# Initially alignment was handled in pure AltiVec/VMX way [when data
+# is aligned programmatically, which in turn guarantees exception-
+# free execution], but it turned to hamper performance when vcipher
+# instructions are interleaved. It's reckoned that eventual
+# misalignment penalties at page boundaries are in average lower
+# than additional overhead in pure AltiVec approach.
+
+$flavour =3D shift;
+
+if ($flavour =3D~ /64/) {
+	$SIZE_T	=3D8;
+	$LRSAVE	=3D2*$SIZE_T;
+	$STU	=3D"stdu";
+	$POP	=3D"ld";
+	$PUSH	=3D"std";
+	$UCMP	=3D"cmpld";
+	$SHL	=3D"sldi";
+} elsif ($flavour =3D~ /32/) {
+	$SIZE_T	=3D4;
+	$LRSAVE	=3D$SIZE_T;
+	$STU	=3D"stwu";
+	$POP	=3D"lwz";
+	$PUSH	=3D"stw";
+	$UCMP	=3D"cmplw";
+	$SHL	=3D"slwi";
+} else { die "nonsense $flavour"; }
+
+$LITTLE_ENDIAN =3D ($flavour=3D~/le$/) ? $SIZE_T : 0;
+
+$0 =3D~ m/(.*[\/\\])[^\/\\]+$/; $dir=3D$1;
+( $xlate=3D"${dir}ppc-xlate.pl" and -f $xlate ) or
+( $xlate=3D"${dir}../../perlasm/ppc-xlate.pl" and -f $xlate) or
+die "can't locate ppc-xlate.pl";
+
+open STDOUT,"| $^X $xlate $flavour ".shift || die "can't call $xlate: =
$!";
+
+$FRAME=3D8*$SIZE_T;
+$prefix=3D"aes_p8";
+
+$sp=3D"r1";
+$vrsave=3D"r12";
+
+######################################################################=
###
+{{{	# Key setup procedures						#
+my ($inp,$bits,$out,$ptr,$cnt,$rounds)=3Dmap("r$_",(3..8));
+my ($zero,$in0,$in1,$key,$rcon,$mask,$tmp)=3Dmap("v$_",(0..6));
+my ($stage,$outperm,$outmask,$outhead,$outtail)=3Dmap("v$_",(7..11));
+
+$code.=3D<<___;
+.machine	"any"
+
+.text
+
+.align	7
+rcon:
+.long	0x01000000, 0x01000000, 0x01000000, 0x01000000	?rev
+.long	0x1b000000, 0x1b000000, 0x1b000000, 0x1b000000	?rev
+.long	0x0d0e0f0c, 0x0d0e0f0c, 0x0d0e0f0c, 0x0d0e0f0c	?rev
+.long	0,0,0,0						?asis
+Lconsts:
+	mflr	r0
+	bcl	20,31,\$+4
+	mflr	$ptr	 #vvvvv "distance between . and rcon
+	addi	$ptr,$ptr,-0x48
+	mtlr	r0
+	blr
+	.long	0
+	.byte	0,12,0x14,0,0,0,0,0
+.asciz	"AES for PowerISA 2.07, CRYPTOGAMS by <appro\@openssl.org>"
+
+.globl	.${prefix}_set_encrypt_key
+.align	5
+.${prefix}_set_encrypt_key:
+Lset_encrypt_key:
+	mflr		r11
+	$PUSH		r11,$LRSAVE($sp)
+
+	li		$ptr,-1
+	${UCMP}i	$inp,0
+	beq-		Lenc_key_abort		# if ($inp=3D=3D0) return -1;
+	${UCMP}i	$out,0
+	beq-		Lenc_key_abort		# if ($out=3D=3D0) return -1;
+	li		$ptr,-2
+	cmpwi		$bits,128
+	blt-		Lenc_key_abort
+	cmpwi		$bits,256
+	bgt-		Lenc_key_abort
+	andi.		r0,$bits,0x3f
+	bne-		Lenc_key_abort
+
+	lis		r0,0xfff0
+	mfspr		$vrsave,256
+	mtspr		256,r0
+
+	bl		Lconsts
+	mtlr		r11
+
+	neg		r9,$inp
+	lvx		$in0,0,$inp
+	addi		$inp,$inp,15		# 15 is not typo
+	lvsr		$key,0,r9		# borrow $key
+	li		r8,0x20
+	cmpwi		$bits,192
+	lvx		$in1,0,$inp
+	le?vspltisb	$mask,0x0f		# borrow $mask
+	lvx		$rcon,0,$ptr
+	le?vxor		$key,$key,$mask		# adjust for byte swap
+	lvx		$mask,r8,$ptr
+	addi		$ptr,$ptr,0x10
+	vperm		$in0,$in0,$in1,$key	# align [and byte swap in LE]
+	li		$cnt,8
+	vxor		$zero,$zero,$zero
+	mtctr		$cnt
+
+	?lvsr		$outperm,0,$out
+	vspltisb	$outmask,-1
+	lvx		$outhead,0,$out
+	?vperm		$outmask,$zero,$outmask,$outperm
+
+	blt		Loop128
+	addi		$inp,$inp,8
+	beq		L192
+	addi		$inp,$inp,8
+	b		L256
+
+.align	4
+Loop128:
+	vperm		$key,$in0,$in0,$mask	# rotate-n-splat
+	vsldoi		$tmp,$zero,$in0,12	# >>32
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	vcipherlast	$key,$key,$rcon
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	 vadduwm	$rcon,$rcon,$rcon
+	vxor		$in0,$in0,$key
+	bdnz		Loop128
+
+	lvx		$rcon,0,$ptr		# last two round keys
+
+	vperm		$key,$in0,$in0,$mask	# rotate-n-splat
+	vsldoi		$tmp,$zero,$in0,12	# >>32
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	vcipherlast	$key,$key,$rcon
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	 vadduwm	$rcon,$rcon,$rcon
+	vxor		$in0,$in0,$key
+
+	vperm		$key,$in0,$in0,$mask	# rotate-n-splat
+	vsldoi		$tmp,$zero,$in0,12	# >>32
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	vcipherlast	$key,$key,$rcon
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	vxor		$in0,$in0,$key
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	 stvx		$stage,0,$out
+
+	addi		$inp,$out,15		# 15 is not typo
+	addi		$out,$out,0x50
+
+	li		$rounds,10
+	b		Ldone
+
+.align	4
+L192:
+	lvx		$tmp,0,$inp
+	li		$cnt,4
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+	vperm		$in1,$in1,$tmp,$key	# align [and byte swap in LE]
+	vspltisb	$key,8			# borrow $key
+	mtctr		$cnt
+	vsububm		$mask,$mask,$key	# adjust the mask
+
+Loop192:
+	vperm		$key,$in1,$in1,$mask	# roate-n-splat
+	vsldoi		$tmp,$zero,$in0,12	# >>32
+	vcipherlast	$key,$key,$rcon
+
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+
+	 vsldoi		$stage,$zero,$in1,8
+	vspltw		$tmp,$in0,3
+	vxor		$tmp,$tmp,$in1
+	vsldoi		$in1,$zero,$in1,12	# >>32
+	 vadduwm	$rcon,$rcon,$rcon
+	vxor		$in1,$in1,$tmp
+	vxor		$in0,$in0,$key
+	vxor		$in1,$in1,$key
+	 vsldoi		$stage,$stage,$in0,8
+
+	vperm		$key,$in1,$in1,$mask	# rotate-n-splat
+	vsldoi		$tmp,$zero,$in0,12	# >>32
+	 vperm		$outtail,$stage,$stage,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	vcipherlast	$key,$key,$rcon
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+
+	 vsldoi		$stage,$in0,$in1,8
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	 vperm		$outtail,$stage,$stage,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+
+	vspltw		$tmp,$in0,3
+	vxor		$tmp,$tmp,$in1
+	vsldoi		$in1,$zero,$in1,12	# >>32
+	 vadduwm	$rcon,$rcon,$rcon
+	vxor		$in1,$in1,$tmp
+	vxor		$in0,$in0,$key
+	vxor		$in1,$in1,$key
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	 stvx		$stage,0,$out
+	 addi		$inp,$out,15		# 15 is not typo
+	 addi		$out,$out,16
+	bdnz		Loop192
+
+	li		$rounds,12
+	addi		$out,$out,0x20
+	b		Ldone
+
+.align	4
+L256:
+	lvx		$tmp,0,$inp
+	li		$cnt,7
+	li		$rounds,14
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+	vperm		$in1,$in1,$tmp,$key	# align [and byte swap in LE]
+	mtctr		$cnt
+
+Loop256:
+	vperm		$key,$in1,$in1,$mask	# rotate-n-splat
+	vsldoi		$tmp,$zero,$in0,12	# >>32
+	 vperm		$outtail,$in1,$in1,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	vcipherlast	$key,$key,$rcon
+	 stvx		$stage,0,$out
+	 addi		$out,$out,16
+
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in0,$in0,$tmp
+	 vadduwm	$rcon,$rcon,$rcon
+	vxor		$in0,$in0,$key
+	 vperm		$outtail,$in0,$in0,$outperm	# rotate
+	 vsel		$stage,$outhead,$outtail,$outmask
+	 vmr		$outhead,$outtail
+	 stvx		$stage,0,$out
+	 addi		$inp,$out,15		# 15 is not typo
+	 addi		$out,$out,16
+	bdz		Ldone
+
+	vspltw		$key,$in0,3		# just splat
+	vsldoi		$tmp,$zero,$in1,12	# >>32
+	vsbox		$key,$key
+
+	vxor		$in1,$in1,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in1,$in1,$tmp
+	vsldoi		$tmp,$zero,$tmp,12	# >>32
+	vxor		$in1,$in1,$tmp
+
+	vxor		$in1,$in1,$key
+	b		Loop256
+
+.align	4
+Ldone:
+	lvx		$in1,0,$inp		# redundant in aligned case
+	vsel		$in1,$outhead,$in1,$outmask
+	stvx		$in1,0,$inp
+	li		$ptr,0
+	mtspr		256,$vrsave
+	stw		$rounds,0($out)
+
+Lenc_key_abort:
+	mr		r3,$ptr
+	blr
+	.long		0
+	.byte		0,12,0x14,1,0,0,3,0
+	.long		0
+.size	.${prefix}_set_encrypt_key,.-.${prefix}_set_encrypt_key
+
+.globl	.${prefix}_set_decrypt_key
+.align	5
+.${prefix}_set_decrypt_key:
+	$STU		$sp,-$FRAME($sp)
+	mflr		r10
+	$PUSH		r10,$FRAME+$LRSAVE($sp)
+	bl		Lset_encrypt_key
+	mtlr		r10
+
+	cmpwi		r3,0
+	bne-		Ldec_key_abort
+
+	slwi		$cnt,$rounds,4
+	subi		$inp,$out,240		# first round key
+	srwi		$rounds,$rounds,1
+	add		$out,$inp,$cnt		# last round key
+	mtctr		$rounds
+
+Ldeckey:
+	lwz		r0, 0($inp)
+	lwz		r6, 4($inp)
+	lwz		r7, 8($inp)
+	lwz		r8, 12($inp)
+	addi		$inp,$inp,16
+	lwz		r9, 0($out)
+	lwz		r10,4($out)
+	lwz		r11,8($out)
+	lwz		r12,12($out)
+	stw		r0, 0($out)
+	stw		r6, 4($out)
+	stw		r7, 8($out)
+	stw		r8, 12($out)
+	subi		$out,$out,16
+	stw		r9, -16($inp)
+	stw		r10,-12($inp)
+	stw		r11,-8($inp)
+	stw		r12,-4($inp)
+	bdnz		Ldeckey
+
+	xor		r3,r3,r3		# return value
+Ldec_key_abort:
+	addi		$sp,$sp,$FRAME
+	blr
+	.long		0
+	.byte		0,12,4,1,0x80,0,3,0
+	.long		0
+.size	.${prefix}_set_decrypt_key,.-.${prefix}_set_decrypt_key
+___
+}}}
+######################################################################=
###
+{{{	# Single block en- and decrypt procedures			#
+sub gen_block () {
+my $dir =3D shift;
+my $n   =3D $dir eq "de" ? "n" : "";
+my ($inp,$out,$key,$rounds,$idx)=3Dmap("r$_",(3..7));
+
+$code.=3D<<___;
+.globl	.${prefix}_${dir}crypt
+.align	5
+.${prefix}_${dir}crypt:
+	lwz		$rounds,240($key)
+	lis		r0,0xfc00
+	mfspr		$vrsave,256
+	li		$idx,15			# 15 is not typo
+	mtspr		256,r0
+
+	lvx		v0,0,$inp
+	neg		r11,$out
+	lvx		v1,$idx,$inp
+	lvsl		v2,0,$inp		# inpperm
+	le?vspltisb	v4,0x0f
+	?lvsl		v3,0,r11		# outperm
+	le?vxor		v2,v2,v4
+	li		$idx,16
+	vperm		v0,v0,v1,v2		# align [and byte swap in LE]
+	lvx		v1,0,$key
+	?lvsl		v5,0,$key		# keyperm
+	srwi		$rounds,$rounds,1
+	lvx		v2,$idx,$key
+	addi		$idx,$idx,16
+	subi		$rounds,$rounds,1
+	?vperm		v1,v1,v2,v5		# align round key
+
+	vxor		v0,v0,v1
+	lvx		v1,$idx,$key
+	addi		$idx,$idx,16
+	mtctr		$rounds
+
+Loop_${dir}c:
+	?vperm		v2,v2,v1,v5
+	v${n}cipher	v0,v0,v2
+	lvx		v2,$idx,$key
+	addi		$idx,$idx,16
+	?vperm		v1,v1,v2,v5
+	v${n}cipher	v0,v0,v1
+	lvx		v1,$idx,$key
+	addi		$idx,$idx,16
+	bdnz		Loop_${dir}c
+
+	?vperm		v2,v2,v1,v5
+	v${n}cipher	v0,v0,v2
+	lvx		v2,$idx,$key
+	?vperm		v1,v1,v2,v5
+	v${n}cipherlast	v0,v0,v1
+
+	vspltisb	v2,-1
+	vxor		v1,v1,v1
+	li		$idx,15			# 15 is not typo
+	?vperm		v2,v1,v2,v3		# outmask
+	le?vxor		v3,v3,v4
+	lvx		v1,0,$out		# outhead
+	vperm		v0,v0,v0,v3		# rotate [and byte swap in LE]
+	vsel		v1,v1,v0,v2
+	lvx		v4,$idx,$out
+	stvx		v1,0,$out
+	vsel		v0,v0,v4,v2
+	stvx		v0,$idx,$out
+
+	mtspr		256,$vrsave
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0,0,3,0
+	.long		0
+.size	.${prefix}_${dir}crypt,.-.${prefix}_${dir}crypt
+___
+}
+&gen_block("en");
+&gen_block("de");
+}}}
+######################################################################=
###
+{{{	# CBC en- and decrypt procedures				#
+my ($inp,$out,$len,$key,$ivp,$enc,$rounds,$idx)=3Dmap("r$_",(3..10));
+my ($rndkey0,$rndkey1,$inout,$tmp)=3D		map("v$_",(0..3));
+my ($ivec,$inptail,$inpperm,$outhead,$outperm,$outmask,$keyperm)=3D
+						map("v$_",(4..10));
+$code.=3D<<___;
+.globl	.${prefix}_cbc_encrypt
+.align	5
+.${prefix}_cbc_encrypt:
+	${UCMP}i	$len,16
+	bltlr-
+
+	cmpwi		$enc,0			# test direction
+	lis		r0,0xffe0
+	mfspr		$vrsave,256
+	mtspr		256,r0
+
+	li		$idx,15
+	vxor		$rndkey0,$rndkey0,$rndkey0
+	le?vspltisb	$tmp,0x0f
+
+	lvx		$ivec,0,$ivp		# load [unaligned] iv
+	lvsl		$inpperm,0,$ivp
+	lvx		$inptail,$idx,$ivp
+	le?vxor		$inpperm,$inpperm,$tmp
+	vperm		$ivec,$ivec,$inptail,$inpperm
+
+	neg		r11,$inp
+	?lvsl		$keyperm,0,$key		# prepare for unaligned key
+	lwz		$rounds,240($key)
+
+	lvsr		$inpperm,0,r11		# prepare for unaligned load
+	lvx		$inptail,0,$inp
+	addi		$inp,$inp,15		# 15 is not typo
+	le?vxor		$inpperm,$inpperm,$tmp
+
+	?lvsr		$outperm,0,$out		# prepare for unaligned store
+	vspltisb	$outmask,-1
+	lvx		$outhead,0,$out
+	?vperm		$outmask,$rndkey0,$outmask,$outperm
+	le?vxor		$outperm,$outperm,$tmp
+
+	srwi		$rounds,$rounds,1
+	li		$idx,16
+	subi		$rounds,$rounds,1
+	beq		Lcbc_dec
+
+Lcbc_enc:
+	vmr		$inout,$inptail
+	lvx		$inptail,0,$inp
+	addi		$inp,$inp,16
+	mtctr		$rounds
+	subi		$len,$len,16		# len-=3D16
+
+	lvx		$rndkey0,0,$key
+	 vperm		$inout,$inout,$inptail,$inpperm
+	lvx		$rndkey1,$idx,$key
+	addi		$idx,$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vxor		$inout,$inout,$rndkey0
+	lvx		$rndkey0,$idx,$key
+	addi		$idx,$idx,16
+	vxor		$inout,$inout,$ivec
+
+Loop_cbc_enc:
+	?vperm		$rndkey1,$rndkey1,$rndkey0,$keyperm
+	vcipher		$inout,$inout,$rndkey1
+	lvx		$rndkey1,$idx,$key
+	addi		$idx,$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vcipher		$inout,$inout,$rndkey0
+	lvx		$rndkey0,$idx,$key
+	addi		$idx,$idx,16
+	bdnz		Loop_cbc_enc
+
+	?vperm		$rndkey1,$rndkey1,$rndkey0,$keyperm
+	vcipher		$inout,$inout,$rndkey1
+	lvx		$rndkey1,$idx,$key
+	li		$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vcipherlast	$ivec,$inout,$rndkey0
+	${UCMP}i	$len,16
+
+	vperm		$tmp,$ivec,$ivec,$outperm
+	vsel		$inout,$outhead,$tmp,$outmask
+	vmr		$outhead,$tmp
+	stvx		$inout,0,$out
+	addi		$out,$out,16
+	bge		Lcbc_enc
+
+	b		Lcbc_done
+
+.align	4
+Lcbc_dec:
+	${UCMP}i	$len,128
+	bge		_aesp8_cbc_decrypt8x
+	vmr		$tmp,$inptail
+	lvx		$inptail,0,$inp
+	addi		$inp,$inp,16
+	mtctr		$rounds
+	subi		$len,$len,16		# len-=3D16
+
+	lvx		$rndkey0,0,$key
+	 vperm		$tmp,$tmp,$inptail,$inpperm
+	lvx		$rndkey1,$idx,$key
+	addi		$idx,$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vxor		$inout,$tmp,$rndkey0
+	lvx		$rndkey0,$idx,$key
+	addi		$idx,$idx,16
+
+Loop_cbc_dec:
+	?vperm		$rndkey1,$rndkey1,$rndkey0,$keyperm
+	vncipher	$inout,$inout,$rndkey1
+	lvx		$rndkey1,$idx,$key
+	addi		$idx,$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vncipher	$inout,$inout,$rndkey0
+	lvx		$rndkey0,$idx,$key
+	addi		$idx,$idx,16
+	bdnz		Loop_cbc_dec
+
+	?vperm		$rndkey1,$rndkey1,$rndkey0,$keyperm
+	vncipher	$inout,$inout,$rndkey1
+	lvx		$rndkey1,$idx,$key
+	li		$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vncipherlast	$inout,$inout,$rndkey0
+	${UCMP}i	$len,16
+
+	vxor		$inout,$inout,$ivec
+	vmr		$ivec,$tmp
+	vperm		$tmp,$inout,$inout,$outperm
+	vsel		$inout,$outhead,$tmp,$outmask
+	vmr		$outhead,$tmp
+	stvx		$inout,0,$out
+	addi		$out,$out,16
+	bge		Lcbc_dec
+
+Lcbc_done:
+	addi		$out,$out,-1
+	lvx		$inout,0,$out		# redundant in aligned case
+	vsel		$inout,$outhead,$inout,$outmask
+	stvx		$inout,0,$out
+
+	neg		$enc,$ivp		# write [unaligned] iv
+	li		$idx,15			# 15 is not typo
+	vxor		$rndkey0,$rndkey0,$rndkey0
+	vspltisb	$outmask,-1
+	le?vspltisb	$tmp,0x0f
+	?lvsl		$outperm,0,$enc
+	?vperm		$outmask,$rndkey0,$outmask,$outperm
+	le?vxor		$outperm,$outperm,$tmp
+	lvx		$outhead,0,$ivp
+	vperm		$ivec,$ivec,$ivec,$outperm
+	vsel		$inout,$outhead,$ivec,$outmask
+	lvx		$inptail,$idx,$ivp
+	stvx		$inout,0,$ivp
+	vsel		$inout,$ivec,$inptail,$outmask
+	stvx		$inout,$idx,$ivp
+
+	mtspr		256,$vrsave
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0,0,6,0
+	.long		0
+___
+######################################################################=
###
+{{	# Optimized CBC decrypt procedure				#
+my $key_=3D"r11";
+my ($x00,$x10,$x20,$x30,$x40,$x50,$x60,$x70)=3Dmap("r$_",(0,8,26..31))=
;
+my ($in0, $in1, $in2, $in3, $in4, $in5, $in6, $in7 )=3Dmap("v$_",(0..3=
,10..13));
+my ($out0,$out1,$out2,$out3,$out4,$out5,$out6,$out7)=3Dmap("v$_",(14..=
21));
+my $rndkey0=3D"v23";	# v24-v25 rotating buffer for first found keys
+			# v26-v31 last 6 round keys
+my ($tmp,$keyperm)=3D($in3,$in4);	# aliases with "caller", redundant a=
ssignment
+
+$code.=3D<<___;
+.align	5
+_aesp8_cbc_decrypt8x:
+	$STU		$sp,-`($FRAME+21*16+6*$SIZE_T)`($sp)
+	li		r10,`$FRAME+8*16+15`
+	li		r11,`$FRAME+8*16+31`
+	stvx		v20,r10,$sp		# ABI says so
+	addi		r10,r10,32
+	stvx		v21,r11,$sp
+	addi		r11,r11,32
+	stvx		v22,r10,$sp
+	addi		r10,r10,32
+	stvx		v23,r11,$sp
+	addi		r11,r11,32
+	stvx		v24,r10,$sp
+	addi		r10,r10,32
+	stvx		v25,r11,$sp
+	addi		r11,r11,32
+	stvx		v26,r10,$sp
+	addi		r10,r10,32
+	stvx		v27,r11,$sp
+	addi		r11,r11,32
+	stvx		v28,r10,$sp
+	addi		r10,r10,32
+	stvx		v29,r11,$sp
+	addi		r11,r11,32
+	stvx		v30,r10,$sp
+	stvx		v31,r11,$sp
+	li		r0,-1
+	stw		$vrsave,`$FRAME+21*16-4`($sp)	# save vrsave
+	li		$x10,0x10
+	$PUSH		r26,`$FRAME+21*16+0*$SIZE_T`($sp)
+	li		$x20,0x20
+	$PUSH		r27,`$FRAME+21*16+1*$SIZE_T`($sp)
+	li		$x30,0x30
+	$PUSH		r28,`$FRAME+21*16+2*$SIZE_T`($sp)
+	li		$x40,0x40
+	$PUSH		r29,`$FRAME+21*16+3*$SIZE_T`($sp)
+	li		$x50,0x50
+	$PUSH		r30,`$FRAME+21*16+4*$SIZE_T`($sp)
+	li		$x60,0x60
+	$PUSH		r31,`$FRAME+21*16+5*$SIZE_T`($sp)
+	li		$x70,0x70
+	mtspr		256,r0
+
+	subi		$rounds,$rounds,3	# -4 in total
+	subi		$len,$len,128		# bias
+
+	lvx		$rndkey0,$x00,$key	# load key schedule
+	lvx		v30,$x10,$key
+	addi		$key,$key,0x20
+	lvx		v31,$x00,$key
+	?vperm		$rndkey0,$rndkey0,v30,$keyperm
+	addi		$key_,$sp,$FRAME+15
+	mtctr		$rounds
+
+Load_cbc_dec_key:
+	?vperm		v24,v30,v31,$keyperm
+	lvx		v30,$x10,$key
+	addi		$key,$key,0x20
+	stvx		v24,$x00,$key_		# off-load round[1]
+	?vperm		v25,v31,v30,$keyperm
+	lvx		v31,$x00,$key
+	stvx		v25,$x10,$key_		# off-load round[2]
+	addi		$key_,$key_,0x20
+	bdnz		Load_cbc_dec_key
+
+	lvx		v26,$x10,$key
+	?vperm		v24,v30,v31,$keyperm
+	lvx		v27,$x20,$key
+	stvx		v24,$x00,$key_		# off-load round[3]
+	?vperm		v25,v31,v26,$keyperm
+	lvx		v28,$x30,$key
+	stvx		v25,$x10,$key_		# off-load round[4]
+	addi		$key_,$sp,$FRAME+15	# rewind $key_
+	?vperm		v26,v26,v27,$keyperm
+	lvx		v29,$x40,$key
+	?vperm		v27,v27,v28,$keyperm
+	lvx		v30,$x50,$key
+	?vperm		v28,v28,v29,$keyperm
+	lvx		v31,$x60,$key
+	?vperm		v29,v29,v30,$keyperm
+	lvx		$out0,$x70,$key		# borrow $out0
+	?vperm		v30,v30,v31,$keyperm
+	lvx		v24,$x00,$key_		# pre-load round[1]
+	?vperm		v31,v31,$out0,$keyperm
+	lvx		v25,$x10,$key_		# pre-load round[2]
+
+	#lvx		$inptail,0,$inp		# "caller" already did this
+	#addi		$inp,$inp,15		# 15 is not typo
+	subi		$inp,$inp,15		# undo "caller"
+
+	 le?li		$idx,8
+	lvx_u		$in0,$x00,$inp		# load first 8 "words"
+	 le?lvsl	$inpperm,0,$idx
+	 le?vspltisb	$tmp,0x0f
+	lvx_u		$in1,$x10,$inp
+	 le?vxor	$inpperm,$inpperm,$tmp	# transform for lvx_u/stvx_u
+	lvx_u		$in2,$x20,$inp
+	 le?vperm	$in0,$in0,$in0,$inpperm
+	lvx_u		$in3,$x30,$inp
+	 le?vperm	$in1,$in1,$in1,$inpperm
+	lvx_u		$in4,$x40,$inp
+	 le?vperm	$in2,$in2,$in2,$inpperm
+	vxor		$out0,$in0,$rndkey0
+	lvx_u		$in5,$x50,$inp
+	 le?vperm	$in3,$in3,$in3,$inpperm
+	vxor		$out1,$in1,$rndkey0
+	lvx_u		$in6,$x60,$inp
+	 le?vperm	$in4,$in4,$in4,$inpperm
+	vxor		$out2,$in2,$rndkey0
+	lvx_u		$in7,$x70,$inp
+	addi		$inp,$inp,0x80
+	 le?vperm	$in5,$in5,$in5,$inpperm
+	vxor		$out3,$in3,$rndkey0
+	 le?vperm	$in6,$in6,$in6,$inpperm
+	vxor		$out4,$in4,$rndkey0
+	 le?vperm	$in7,$in7,$in7,$inpperm
+	vxor		$out5,$in5,$rndkey0
+	vxor		$out6,$in6,$rndkey0
+	vxor		$out7,$in7,$rndkey0
+
+	mtctr		$rounds
+	b		Loop_cbc_dec8x
+.align	5
+Loop_cbc_dec8x:
+	vncipher	$out0,$out0,v24
+	vncipher	$out1,$out1,v24
+	vncipher	$out2,$out2,v24
+	vncipher	$out3,$out3,v24
+	vncipher	$out4,$out4,v24
+	vncipher	$out5,$out5,v24
+	vncipher	$out6,$out6,v24
+	vncipher	$out7,$out7,v24
+	lvx		v24,$x20,$key_		# round[3]
+	addi		$key_,$key_,0x20
+
+	vncipher	$out0,$out0,v25
+	vncipher	$out1,$out1,v25
+	vncipher	$out2,$out2,v25
+	vncipher	$out3,$out3,v25
+	vncipher	$out4,$out4,v25
+	vncipher	$out5,$out5,v25
+	vncipher	$out6,$out6,v25
+	vncipher	$out7,$out7,v25
+	lvx		v25,$x10,$key_		# round[4]
+	bdnz		Loop_cbc_dec8x
+
+	subic		$len,$len,128		# $len-=3D128
+	vncipher	$out0,$out0,v24
+	vncipher	$out1,$out1,v24
+	vncipher	$out2,$out2,v24
+	vncipher	$out3,$out3,v24
+	vncipher	$out4,$out4,v24
+	vncipher	$out5,$out5,v24
+	vncipher	$out6,$out6,v24
+	vncipher	$out7,$out7,v24
+
+	subfe.		r0,r0,r0		# borrow?-1:0
+	vncipher	$out0,$out0,v25
+	vncipher	$out1,$out1,v25
+	vncipher	$out2,$out2,v25
+	vncipher	$out3,$out3,v25
+	vncipher	$out4,$out4,v25
+	vncipher	$out5,$out5,v25
+	vncipher	$out6,$out6,v25
+	vncipher	$out7,$out7,v25
+
+	and		r0,r0,$len
+	vncipher	$out0,$out0,v26
+	vncipher	$out1,$out1,v26
+	vncipher	$out2,$out2,v26
+	vncipher	$out3,$out3,v26
+	vncipher	$out4,$out4,v26
+	vncipher	$out5,$out5,v26
+	vncipher	$out6,$out6,v26
+	vncipher	$out7,$out7,v26
+
+	add		$inp,$inp,r0		# $inp is adjusted in such
+						# way that at exit from the
+						# loop inX-in7 are loaded
+						# with last "words"
+	vncipher	$out0,$out0,v27
+	vncipher	$out1,$out1,v27
+	vncipher	$out2,$out2,v27
+	vncipher	$out3,$out3,v27
+	vncipher	$out4,$out4,v27
+	vncipher	$out5,$out5,v27
+	vncipher	$out6,$out6,v27
+	vncipher	$out7,$out7,v27
+
+	addi		$key_,$sp,$FRAME+15	# rewind $key_
+	vncipher	$out0,$out0,v28
+	vncipher	$out1,$out1,v28
+	vncipher	$out2,$out2,v28
+	vncipher	$out3,$out3,v28
+	vncipher	$out4,$out4,v28
+	vncipher	$out5,$out5,v28
+	vncipher	$out6,$out6,v28
+	vncipher	$out7,$out7,v28
+	lvx		v24,$x00,$key_		# re-pre-load round[1]
+
+	vncipher	$out0,$out0,v29
+	vncipher	$out1,$out1,v29
+	vncipher	$out2,$out2,v29
+	vncipher	$out3,$out3,v29
+	vncipher	$out4,$out4,v29
+	vncipher	$out5,$out5,v29
+	vncipher	$out6,$out6,v29
+	vncipher	$out7,$out7,v29
+	lvx		v25,$x10,$key_		# re-pre-load round[2]
+
+	vncipher	$out0,$out0,v30
+	 vxor		$ivec,$ivec,v31		# xor with last round key
+	vncipher	$out1,$out1,v30
+	 vxor		$in0,$in0,v31
+	vncipher	$out2,$out2,v30
+	 vxor		$in1,$in1,v31
+	vncipher	$out3,$out3,v30
+	 vxor		$in2,$in2,v31
+	vncipher	$out4,$out4,v30
+	 vxor		$in3,$in3,v31
+	vncipher	$out5,$out5,v30
+	 vxor		$in4,$in4,v31
+	vncipher	$out6,$out6,v30
+	 vxor		$in5,$in5,v31
+	vncipher	$out7,$out7,v30
+	 vxor		$in6,$in6,v31
+
+	vncipherlast	$out0,$out0,$ivec
+	vncipherlast	$out1,$out1,$in0
+	 lvx_u		$in0,$x00,$inp		# load next input block
+	vncipherlast	$out2,$out2,$in1
+	 lvx_u		$in1,$x10,$inp
+	vncipherlast	$out3,$out3,$in2
+	 le?vperm	$in0,$in0,$in0,$inpperm
+	 lvx_u		$in2,$x20,$inp
+	vncipherlast	$out4,$out4,$in3
+	 le?vperm	$in1,$in1,$in1,$inpperm
+	 lvx_u		$in3,$x30,$inp
+	vncipherlast	$out5,$out5,$in4
+	 le?vperm	$in2,$in2,$in2,$inpperm
+	 lvx_u		$in4,$x40,$inp
+	vncipherlast	$out6,$out6,$in5
+	 le?vperm	$in3,$in3,$in3,$inpperm
+	 lvx_u		$in5,$x50,$inp
+	vncipherlast	$out7,$out7,$in6
+	 le?vperm	$in4,$in4,$in4,$inpperm
+	 lvx_u		$in6,$x60,$inp
+	vmr		$ivec,$in7
+	 le?vperm	$in5,$in5,$in5,$inpperm
+	 lvx_u		$in7,$x70,$inp
+	 addi		$inp,$inp,0x80
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	 le?vperm	$in6,$in6,$in6,$inpperm
+	 vxor		$out0,$in0,$rndkey0
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x10,$out
+	 le?vperm	$in7,$in7,$in7,$inpperm
+	 vxor		$out1,$in1,$rndkey0
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x20,$out
+	 vxor		$out2,$in2,$rndkey0
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x30,$out
+	 vxor		$out3,$in3,$rndkey0
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x40,$out
+	 vxor		$out4,$in4,$rndkey0
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x50,$out
+	 vxor		$out5,$in5,$rndkey0
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x60,$out
+	 vxor		$out6,$in6,$rndkey0
+	stvx_u		$out7,$x70,$out
+	addi		$out,$out,0x80
+	 vxor		$out7,$in7,$rndkey0
+
+	mtctr		$rounds
+	beq		Loop_cbc_dec8x		# did $len-=3D128 borrow?
+
+	addic.		$len,$len,128
+	beq		Lcbc_dec8x_done
+	nop
+	nop
+
+Loop_cbc_dec8x_tail:				# up to 7 "words" tail...
+	vncipher	$out1,$out1,v24
+	vncipher	$out2,$out2,v24
+	vncipher	$out3,$out3,v24
+	vncipher	$out4,$out4,v24
+	vncipher	$out5,$out5,v24
+	vncipher	$out6,$out6,v24
+	vncipher	$out7,$out7,v24
+	lvx		v24,$x20,$key_		# round[3]
+	addi		$key_,$key_,0x20
+
+	vncipher	$out1,$out1,v25
+	vncipher	$out2,$out2,v25
+	vncipher	$out3,$out3,v25
+	vncipher	$out4,$out4,v25
+	vncipher	$out5,$out5,v25
+	vncipher	$out6,$out6,v25
+	vncipher	$out7,$out7,v25
+	lvx		v25,$x10,$key_		# round[4]
+	bdnz		Loop_cbc_dec8x_tail
+
+	vncipher	$out1,$out1,v24
+	vncipher	$out2,$out2,v24
+	vncipher	$out3,$out3,v24
+	vncipher	$out4,$out4,v24
+	vncipher	$out5,$out5,v24
+	vncipher	$out6,$out6,v24
+	vncipher	$out7,$out7,v24
+
+	vncipher	$out1,$out1,v25
+	vncipher	$out2,$out2,v25
+	vncipher	$out3,$out3,v25
+	vncipher	$out4,$out4,v25
+	vncipher	$out5,$out5,v25
+	vncipher	$out6,$out6,v25
+	vncipher	$out7,$out7,v25
+
+	vncipher	$out1,$out1,v26
+	vncipher	$out2,$out2,v26
+	vncipher	$out3,$out3,v26
+	vncipher	$out4,$out4,v26
+	vncipher	$out5,$out5,v26
+	vncipher	$out6,$out6,v26
+	vncipher	$out7,$out7,v26
+
+	vncipher	$out1,$out1,v27
+	vncipher	$out2,$out2,v27
+	vncipher	$out3,$out3,v27
+	vncipher	$out4,$out4,v27
+	vncipher	$out5,$out5,v27
+	vncipher	$out6,$out6,v27
+	vncipher	$out7,$out7,v27
+
+	vncipher	$out1,$out1,v28
+	vncipher	$out2,$out2,v28
+	vncipher	$out3,$out3,v28
+	vncipher	$out4,$out4,v28
+	vncipher	$out5,$out5,v28
+	vncipher	$out6,$out6,v28
+	vncipher	$out7,$out7,v28
+
+	vncipher	$out1,$out1,v29
+	vncipher	$out2,$out2,v29
+	vncipher	$out3,$out3,v29
+	vncipher	$out4,$out4,v29
+	vncipher	$out5,$out5,v29
+	vncipher	$out6,$out6,v29
+	vncipher	$out7,$out7,v29
+
+	vncipher	$out1,$out1,v30
+	 vxor		$ivec,$ivec,v31		# last round key
+	vncipher	$out2,$out2,v30
+	 vxor		$in1,$in1,v31
+	vncipher	$out3,$out3,v30
+	 vxor		$in2,$in2,v31
+	vncipher	$out4,$out4,v30
+	 vxor		$in3,$in3,v31
+	vncipher	$out5,$out5,v30
+	 vxor		$in4,$in4,v31
+	vncipher	$out6,$out6,v30
+	 vxor		$in5,$in5,v31
+	vncipher	$out7,$out7,v30
+	 vxor		$in6,$in6,v31
+
+	cmplwi		$len,32			# switch($len)
+	blt		Lcbc_dec8x_one
+	nop
+	beq		Lcbc_dec8x_two
+	cmplwi		$len,64
+	blt		Lcbc_dec8x_three
+	nop
+	beq		Lcbc_dec8x_four
+	cmplwi		$len,96
+	blt		Lcbc_dec8x_five
+	nop
+	beq		Lcbc_dec8x_six
+
+Lcbc_dec8x_seven:
+	vncipherlast	$out1,$out1,$ivec
+	vncipherlast	$out2,$out2,$in1
+	vncipherlast	$out3,$out3,$in2
+	vncipherlast	$out4,$out4,$in3
+	vncipherlast	$out5,$out5,$in4
+	vncipherlast	$out6,$out6,$in5
+	vncipherlast	$out7,$out7,$in6
+	vmr		$ivec,$in7
+
+	le?vperm	$out1,$out1,$out1,$inpperm
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x00,$out
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x10,$out
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x20,$out
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x30,$out
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x40,$out
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x50,$out
+	stvx_u		$out7,$x60,$out
+	addi		$out,$out,0x70
+	b		Lcbc_dec8x_done
+
+.align	5
+Lcbc_dec8x_six:
+	vncipherlast	$out2,$out2,$ivec
+	vncipherlast	$out3,$out3,$in2
+	vncipherlast	$out4,$out4,$in3
+	vncipherlast	$out5,$out5,$in4
+	vncipherlast	$out6,$out6,$in5
+	vncipherlast	$out7,$out7,$in6
+	vmr		$ivec,$in7
+
+	le?vperm	$out2,$out2,$out2,$inpperm
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x00,$out
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x10,$out
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x20,$out
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x30,$out
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x40,$out
+	stvx_u		$out7,$x50,$out
+	addi		$out,$out,0x60
+	b		Lcbc_dec8x_done
+
+.align	5
+Lcbc_dec8x_five:
+	vncipherlast	$out3,$out3,$ivec
+	vncipherlast	$out4,$out4,$in3
+	vncipherlast	$out5,$out5,$in4
+	vncipherlast	$out6,$out6,$in5
+	vncipherlast	$out7,$out7,$in6
+	vmr		$ivec,$in7
+
+	le?vperm	$out3,$out3,$out3,$inpperm
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x00,$out
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x10,$out
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x20,$out
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x30,$out
+	stvx_u		$out7,$x40,$out
+	addi		$out,$out,0x50
+	b		Lcbc_dec8x_done
+
+.align	5
+Lcbc_dec8x_four:
+	vncipherlast	$out4,$out4,$ivec
+	vncipherlast	$out5,$out5,$in4
+	vncipherlast	$out6,$out6,$in5
+	vncipherlast	$out7,$out7,$in6
+	vmr		$ivec,$in7
+
+	le?vperm	$out4,$out4,$out4,$inpperm
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x00,$out
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x10,$out
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x20,$out
+	stvx_u		$out7,$x30,$out
+	addi		$out,$out,0x40
+	b		Lcbc_dec8x_done
+
+.align	5
+Lcbc_dec8x_three:
+	vncipherlast	$out5,$out5,$ivec
+	vncipherlast	$out6,$out6,$in5
+	vncipherlast	$out7,$out7,$in6
+	vmr		$ivec,$in7
+
+	le?vperm	$out5,$out5,$out5,$inpperm
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x00,$out
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x10,$out
+	stvx_u		$out7,$x20,$out
+	addi		$out,$out,0x30
+	b		Lcbc_dec8x_done
+
+.align	5
+Lcbc_dec8x_two:
+	vncipherlast	$out6,$out6,$ivec
+	vncipherlast	$out7,$out7,$in6
+	vmr		$ivec,$in7
+
+	le?vperm	$out6,$out6,$out6,$inpperm
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x00,$out
+	stvx_u		$out7,$x10,$out
+	addi		$out,$out,0x20
+	b		Lcbc_dec8x_done
+
+.align	5
+Lcbc_dec8x_one:
+	vncipherlast	$out7,$out7,$ivec
+	vmr		$ivec,$in7
+
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out7,0,$out
+	addi		$out,$out,0x10
+
+Lcbc_dec8x_done:
+	le?vperm	$ivec,$ivec,$ivec,$inpperm
+	stvx_u		$ivec,0,$ivp		# write [unaligned] iv
+
+	li		r10,`$FRAME+15`
+	li		r11,`$FRAME+31`
+	stvx		$inpperm,r10,$sp	# wipe copies of round keys
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+	stvx		$inpperm,r10,$sp
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+	stvx		$inpperm,r10,$sp
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+	stvx		$inpperm,r10,$sp
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+
+	mtspr		256,$vrsave
+	lvx		v20,r10,$sp		# ABI says so
+	addi		r10,r10,32
+	lvx		v21,r11,$sp
+	addi		r11,r11,32
+	lvx		v22,r10,$sp
+	addi		r10,r10,32
+	lvx		v23,r11,$sp
+	addi		r11,r11,32
+	lvx		v24,r10,$sp
+	addi		r10,r10,32
+	lvx		v25,r11,$sp
+	addi		r11,r11,32
+	lvx		v26,r10,$sp
+	addi		r10,r10,32
+	lvx		v27,r11,$sp
+	addi		r11,r11,32
+	lvx		v28,r10,$sp
+	addi		r10,r10,32
+	lvx		v29,r11,$sp
+	addi		r11,r11,32
+	lvx		v30,r10,$sp
+	lvx		v31,r11,$sp
+	$POP		r26,`$FRAME+21*16+0*$SIZE_T`($sp)
+	$POP		r27,`$FRAME+21*16+1*$SIZE_T`($sp)
+	$POP		r28,`$FRAME+21*16+2*$SIZE_T`($sp)
+	$POP		r29,`$FRAME+21*16+3*$SIZE_T`($sp)
+	$POP		r30,`$FRAME+21*16+4*$SIZE_T`($sp)
+	$POP		r31,`$FRAME+21*16+5*$SIZE_T`($sp)
+	addi		$sp,$sp,`$FRAME+21*16+6*$SIZE_T`
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0x80,6,6,0
+	.long		0
+.size	.${prefix}_cbc_encrypt,.-.${prefix}_cbc_encrypt
+___
+}}	}}}
+
+######################################################################=
###
+{{{	# CTR procedure[s]						#
+my ($inp,$out,$len,$key,$ivp,$x10,$rounds,$idx)=3Dmap("r$_",(3..10));
+my ($rndkey0,$rndkey1,$inout,$tmp)=3D		map("v$_",(0..3));
+my ($ivec,$inptail,$inpperm,$outhead,$outperm,$outmask,$keyperm,$one)=3D
+						map("v$_",(4..11));
+my $dat=3D$tmp;
+
+$code.=3D<<___;
+.globl	.${prefix}_ctr32_encrypt_blocks
+.align	5
+.${prefix}_ctr32_encrypt_blocks:
+	${UCMP}i	$len,1
+	bltlr-
+
+	lis		r0,0xfff0
+	mfspr		$vrsave,256
+	mtspr		256,r0
+
+	li		$idx,15
+	vxor		$rndkey0,$rndkey0,$rndkey0
+	le?vspltisb	$tmp,0x0f
+
+	lvx		$ivec,0,$ivp		# load [unaligned] iv
+	lvsl		$inpperm,0,$ivp
+	lvx		$inptail,$idx,$ivp
+	 vspltisb	$one,1
+	le?vxor		$inpperm,$inpperm,$tmp
+	vperm		$ivec,$ivec,$inptail,$inpperm
+	 vsldoi		$one,$rndkey0,$one,1
+
+	neg		r11,$inp
+	?lvsl		$keyperm,0,$key		# prepare for unaligned key
+	lwz		$rounds,240($key)
+
+	lvsr		$inpperm,0,r11		# prepare for unaligned load
+	lvx		$inptail,0,$inp
+	addi		$inp,$inp,15		# 15 is not typo
+	le?vxor		$inpperm,$inpperm,$tmp
+
+	srwi		$rounds,$rounds,1
+	li		$idx,16
+	subi		$rounds,$rounds,1
+
+	${UCMP}i	$len,8
+	bge		_aesp8_ctr32_encrypt8x
+
+	?lvsr		$outperm,0,$out		# prepare for unaligned store
+	vspltisb	$outmask,-1
+	lvx		$outhead,0,$out
+	?vperm		$outmask,$rndkey0,$outmask,$outperm
+	le?vxor		$outperm,$outperm,$tmp
+
+	lvx		$rndkey0,0,$key
+	mtctr		$rounds
+	lvx		$rndkey1,$idx,$key
+	addi		$idx,$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vxor		$inout,$ivec,$rndkey0
+	lvx		$rndkey0,$idx,$key
+	addi		$idx,$idx,16
+	b		Loop_ctr32_enc
+
+.align	5
+Loop_ctr32_enc:
+	?vperm		$rndkey1,$rndkey1,$rndkey0,$keyperm
+	vcipher		$inout,$inout,$rndkey1
+	lvx		$rndkey1,$idx,$key
+	addi		$idx,$idx,16
+	?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vcipher		$inout,$inout,$rndkey0
+	lvx		$rndkey0,$idx,$key
+	addi		$idx,$idx,16
+	bdnz		Loop_ctr32_enc
+
+	vadduwm		$ivec,$ivec,$one
+	 vmr		$dat,$inptail
+	 lvx		$inptail,0,$inp
+	 addi		$inp,$inp,16
+	 subic.		$len,$len,1		# blocks--
+
+	?vperm		$rndkey1,$rndkey1,$rndkey0,$keyperm
+	vcipher		$inout,$inout,$rndkey1
+	lvx		$rndkey1,$idx,$key
+	 vperm		$dat,$dat,$inptail,$inpperm
+	 li		$idx,16
+	?vperm		$rndkey1,$rndkey0,$rndkey1,$keyperm
+	 lvx		$rndkey0,0,$key
+	vxor		$dat,$dat,$rndkey1	# last round key
+	vcipherlast	$inout,$inout,$dat
+
+	 lvx		$rndkey1,$idx,$key
+	 addi		$idx,$idx,16
+	vperm		$inout,$inout,$inout,$outperm
+	vsel		$dat,$outhead,$inout,$outmask
+	 mtctr		$rounds
+	 ?vperm		$rndkey0,$rndkey0,$rndkey1,$keyperm
+	vmr		$outhead,$inout
+	 vxor		$inout,$ivec,$rndkey0
+	 lvx		$rndkey0,$idx,$key
+	 addi		$idx,$idx,16
+	stvx		$dat,0,$out
+	addi		$out,$out,16
+	bne		Loop_ctr32_enc
+
+	addi		$out,$out,-1
+	lvx		$inout,0,$out		# redundant in aligned case
+	vsel		$inout,$outhead,$inout,$outmask
+	stvx		$inout,0,$out
+
+	mtspr		256,$vrsave
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0,0,6,0
+	.long		0
+___
+######################################################################=
###
+{{	# Optimized CTR procedure					#
+my $key_=3D"r11";
+my ($x00,$x10,$x20,$x30,$x40,$x50,$x60,$x70)=3Dmap("r$_",(0,8,26..31))=
;
+my ($in0, $in1, $in2, $in3, $in4, $in5, $in6, $in7 )=3Dmap("v$_",(0..3=
,10,12..14));
+my ($out0,$out1,$out2,$out3,$out4,$out5,$out6,$out7)=3Dmap("v$_",(15..=
22));
+my $rndkey0=3D"v23";	# v24-v25 rotating buffer for first found keys
+			# v26-v31 last 6 round keys
+my ($tmp,$keyperm)=3D($in3,$in4);	# aliases with "caller", redundant a=
ssignment
+my ($two,$three,$four)=3D($outhead,$outperm,$outmask);
+
+$code.=3D<<___;
+.align	5
+_aesp8_ctr32_encrypt8x:
+	$STU		$sp,-`($FRAME+21*16+6*$SIZE_T)`($sp)
+	li		r10,`$FRAME+8*16+15`
+	li		r11,`$FRAME+8*16+31`
+	stvx		v20,r10,$sp		# ABI says so
+	addi		r10,r10,32
+	stvx		v21,r11,$sp
+	addi		r11,r11,32
+	stvx		v22,r10,$sp
+	addi		r10,r10,32
+	stvx		v23,r11,$sp
+	addi		r11,r11,32
+	stvx		v24,r10,$sp
+	addi		r10,r10,32
+	stvx		v25,r11,$sp
+	addi		r11,r11,32
+	stvx		v26,r10,$sp
+	addi		r10,r10,32
+	stvx		v27,r11,$sp
+	addi		r11,r11,32
+	stvx		v28,r10,$sp
+	addi		r10,r10,32
+	stvx		v29,r11,$sp
+	addi		r11,r11,32
+	stvx		v30,r10,$sp
+	stvx		v31,r11,$sp
+	li		r0,-1
+	stw		$vrsave,`$FRAME+21*16-4`($sp)	# save vrsave
+	li		$x10,0x10
+	$PUSH		r26,`$FRAME+21*16+0*$SIZE_T`($sp)
+	li		$x20,0x20
+	$PUSH		r27,`$FRAME+21*16+1*$SIZE_T`($sp)
+	li		$x30,0x30
+	$PUSH		r28,`$FRAME+21*16+2*$SIZE_T`($sp)
+	li		$x40,0x40
+	$PUSH		r29,`$FRAME+21*16+3*$SIZE_T`($sp)
+	li		$x50,0x50
+	$PUSH		r30,`$FRAME+21*16+4*$SIZE_T`($sp)
+	li		$x60,0x60
+	$PUSH		r31,`$FRAME+21*16+5*$SIZE_T`($sp)
+	li		$x70,0x70
+	mtspr		256,r0
+
+	subi		$rounds,$rounds,3	# -4 in total
+
+	lvx		$rndkey0,$x00,$key	# load key schedule
+	lvx		v30,$x10,$key
+	addi		$key,$key,0x20
+	lvx		v31,$x00,$key
+	?vperm		$rndkey0,$rndkey0,v30,$keyperm
+	addi		$key_,$sp,$FRAME+15
+	mtctr		$rounds
+
+Load_ctr32_enc_key:
+	?vperm		v24,v30,v31,$keyperm
+	lvx		v30,$x10,$key
+	addi		$key,$key,0x20
+	stvx		v24,$x00,$key_		# off-load round[1]
+	?vperm		v25,v31,v30,$keyperm
+	lvx		v31,$x00,$key
+	stvx		v25,$x10,$key_		# off-load round[2]
+	addi		$key_,$key_,0x20
+	bdnz		Load_ctr32_enc_key
+
+	lvx		v26,$x10,$key
+	?vperm		v24,v30,v31,$keyperm
+	lvx		v27,$x20,$key
+	stvx		v24,$x00,$key_		# off-load round[3]
+	?vperm		v25,v31,v26,$keyperm
+	lvx		v28,$x30,$key
+	stvx		v25,$x10,$key_		# off-load round[4]
+	addi		$key_,$sp,$FRAME+15	# rewind $key_
+	?vperm		v26,v26,v27,$keyperm
+	lvx		v29,$x40,$key
+	?vperm		v27,v27,v28,$keyperm
+	lvx		v30,$x50,$key
+	?vperm		v28,v28,v29,$keyperm
+	lvx		v31,$x60,$key
+	?vperm		v29,v29,v30,$keyperm
+	lvx		$out0,$x70,$key		# borrow $out0
+	?vperm		v30,v30,v31,$keyperm
+	lvx		v24,$x00,$key_		# pre-load round[1]
+	?vperm		v31,v31,$out0,$keyperm
+	lvx		v25,$x10,$key_		# pre-load round[2]
+
+	vadduwm		$two,$one,$one
+	subi		$inp,$inp,15		# undo "caller"
+	$SHL		$len,$len,4
+
+	vadduwm		$out1,$ivec,$one	# counter values ...
+	vadduwm		$out2,$ivec,$two
+	vxor		$out0,$ivec,$rndkey0	# ... xored with rndkey[0]
+	 le?li		$idx,8
+	vadduwm		$out3,$out1,$two
+	vxor		$out1,$out1,$rndkey0
+	 le?lvsl	$inpperm,0,$idx
+	vadduwm		$out4,$out2,$two
+	vxor		$out2,$out2,$rndkey0
+	 le?vspltisb	$tmp,0x0f
+	vadduwm		$out5,$out3,$two
+	vxor		$out3,$out3,$rndkey0
+	 le?vxor	$inpperm,$inpperm,$tmp	# transform for lvx_u/stvx_u
+	vadduwm		$out6,$out4,$two
+	vxor		$out4,$out4,$rndkey0
+	vadduwm		$out7,$out5,$two
+	vxor		$out5,$out5,$rndkey0
+	vadduwm		$ivec,$out6,$two	# next counter value
+	vxor		$out6,$out6,$rndkey0
+	vxor		$out7,$out7,$rndkey0
+
+	mtctr		$rounds
+	b		Loop_ctr32_enc8x
+.align	5
+Loop_ctr32_enc8x:
+	vcipher 	$out0,$out0,v24
+	vcipher 	$out1,$out1,v24
+	vcipher 	$out2,$out2,v24
+	vcipher 	$out3,$out3,v24
+	vcipher 	$out4,$out4,v24
+	vcipher 	$out5,$out5,v24
+	vcipher 	$out6,$out6,v24
+	vcipher 	$out7,$out7,v24
+Loop_ctr32_enc8x_middle:
+	lvx		v24,$x20,$key_		# round[3]
+	addi		$key_,$key_,0x20
+
+	vcipher 	$out0,$out0,v25
+	vcipher 	$out1,$out1,v25
+	vcipher 	$out2,$out2,v25
+	vcipher 	$out3,$out3,v25
+	vcipher 	$out4,$out4,v25
+	vcipher 	$out5,$out5,v25
+	vcipher 	$out6,$out6,v25
+	vcipher 	$out7,$out7,v25
+	lvx		v25,$x10,$key_		# round[4]
+	bdnz		Loop_ctr32_enc8x
+
+	subic		r11,$len,256		# $len-256, borrow $key_
+	vcipher 	$out0,$out0,v24
+	vcipher 	$out1,$out1,v24
+	vcipher 	$out2,$out2,v24
+	vcipher 	$out3,$out3,v24
+	vcipher 	$out4,$out4,v24
+	vcipher 	$out5,$out5,v24
+	vcipher 	$out6,$out6,v24
+	vcipher 	$out7,$out7,v24
+
+	subfe		r0,r0,r0		# borrow?-1:0
+	vcipher 	$out0,$out0,v25
+	vcipher 	$out1,$out1,v25
+	vcipher 	$out2,$out2,v25
+	vcipher 	$out3,$out3,v25
+	vcipher 	$out4,$out4,v25
+	vcipher		$out5,$out5,v25
+	vcipher		$out6,$out6,v25
+	vcipher		$out7,$out7,v25
+
+	and		r0,r0,r11
+	addi		$key_,$sp,$FRAME+15	# rewind $key_
+	vcipher		$out0,$out0,v26
+	vcipher		$out1,$out1,v26
+	vcipher		$out2,$out2,v26
+	vcipher		$out3,$out3,v26
+	vcipher		$out4,$out4,v26
+	vcipher		$out5,$out5,v26
+	vcipher		$out6,$out6,v26
+	vcipher		$out7,$out7,v26
+	lvx		v24,$x00,$key_		# re-pre-load round[1]
+
+	subic		$len,$len,129		# $len-=3D129
+	vcipher		$out0,$out0,v27
+	addi		$len,$len,1		# $len-=3D128 really
+	vcipher		$out1,$out1,v27
+	vcipher		$out2,$out2,v27
+	vcipher		$out3,$out3,v27
+	vcipher		$out4,$out4,v27
+	vcipher		$out5,$out5,v27
+	vcipher		$out6,$out6,v27
+	vcipher		$out7,$out7,v27
+	lvx		v25,$x10,$key_		# re-pre-load round[2]
+
+	vcipher		$out0,$out0,v28
+	 lvx_u		$in0,$x00,$inp		# load input
+	vcipher		$out1,$out1,v28
+	 lvx_u		$in1,$x10,$inp
+	vcipher		$out2,$out2,v28
+	 lvx_u		$in2,$x20,$inp
+	vcipher		$out3,$out3,v28
+	 lvx_u		$in3,$x30,$inp
+	vcipher		$out4,$out4,v28
+	 lvx_u		$in4,$x40,$inp
+	vcipher		$out5,$out5,v28
+	 lvx_u		$in5,$x50,$inp
+	vcipher		$out6,$out6,v28
+	 lvx_u		$in6,$x60,$inp
+	vcipher		$out7,$out7,v28
+	 lvx_u		$in7,$x70,$inp
+	 addi		$inp,$inp,0x80
+
+	vcipher		$out0,$out0,v29
+	 le?vperm	$in0,$in0,$in0,$inpperm
+	vcipher		$out1,$out1,v29
+	 le?vperm	$in1,$in1,$in1,$inpperm
+	vcipher		$out2,$out2,v29
+	 le?vperm	$in2,$in2,$in2,$inpperm
+	vcipher		$out3,$out3,v29
+	 le?vperm	$in3,$in3,$in3,$inpperm
+	vcipher		$out4,$out4,v29
+	 le?vperm	$in4,$in4,$in4,$inpperm
+	vcipher		$out5,$out5,v29
+	 le?vperm	$in5,$in5,$in5,$inpperm
+	vcipher		$out6,$out6,v29
+	 le?vperm	$in6,$in6,$in6,$inpperm
+	vcipher		$out7,$out7,v29
+	 le?vperm	$in7,$in7,$in7,$inpperm
+
+	add		$inp,$inp,r0		# $inp is adjusted in such
+						# way that at exit from the
+						# loop inX-in7 are loaded
+						# with last "words"
+	subfe.		r0,r0,r0		# borrow?-1:0
+	vcipher		$out0,$out0,v30
+	 vxor		$in0,$in0,v31		# xor with last round key
+	vcipher		$out1,$out1,v30
+	 vxor		$in1,$in1,v31
+	vcipher		$out2,$out2,v30
+	 vxor		$in2,$in2,v31
+	vcipher		$out3,$out3,v30
+	 vxor		$in3,$in3,v31
+	vcipher		$out4,$out4,v30
+	 vxor		$in4,$in4,v31
+	vcipher		$out5,$out5,v30
+	 vxor		$in5,$in5,v31
+	vcipher		$out6,$out6,v30
+	 vxor		$in6,$in6,v31
+	vcipher		$out7,$out7,v30
+	 vxor		$in7,$in7,v31
+
+	bne		Lctr32_enc8x_break	# did $len-129 borrow?
+
+	vcipherlast	$in0,$out0,$in0
+	vcipherlast	$in1,$out1,$in1
+	 vadduwm	$out1,$ivec,$one	# counter values ...
+	vcipherlast	$in2,$out2,$in2
+	 vadduwm	$out2,$ivec,$two
+	 vxor		$out0,$ivec,$rndkey0	# ... xored with rndkey[0]
+	vcipherlast	$in3,$out3,$in3
+	 vadduwm	$out3,$out1,$two
+	 vxor		$out1,$out1,$rndkey0
+	vcipherlast	$in4,$out4,$in4
+	 vadduwm	$out4,$out2,$two
+	 vxor		$out2,$out2,$rndkey0
+	vcipherlast	$in5,$out5,$in5
+	 vadduwm	$out5,$out3,$two
+	 vxor		$out3,$out3,$rndkey0
+	vcipherlast	$in6,$out6,$in6
+	 vadduwm	$out6,$out4,$two
+	 vxor		$out4,$out4,$rndkey0
+	vcipherlast	$in7,$out7,$in7
+	 vadduwm	$out7,$out5,$two
+	 vxor		$out5,$out5,$rndkey0
+	le?vperm	$in0,$in0,$in0,$inpperm
+	 vadduwm	$ivec,$out6,$two	# next counter value
+	 vxor		$out6,$out6,$rndkey0
+	le?vperm	$in1,$in1,$in1,$inpperm
+	 vxor		$out7,$out7,$rndkey0
+	mtctr		$rounds
+
+	 vcipher	$out0,$out0,v24
+	stvx_u		$in0,$x00,$out
+	le?vperm	$in2,$in2,$in2,$inpperm
+	 vcipher	$out1,$out1,v24
+	stvx_u		$in1,$x10,$out
+	le?vperm	$in3,$in3,$in3,$inpperm
+	 vcipher	$out2,$out2,v24
+	stvx_u		$in2,$x20,$out
+	le?vperm	$in4,$in4,$in4,$inpperm
+	 vcipher	$out3,$out3,v24
+	stvx_u		$in3,$x30,$out
+	le?vperm	$in5,$in5,$in5,$inpperm
+	 vcipher	$out4,$out4,v24
+	stvx_u		$in4,$x40,$out
+	le?vperm	$in6,$in6,$in6,$inpperm
+	 vcipher	$out5,$out5,v24
+	stvx_u		$in5,$x50,$out
+	le?vperm	$in7,$in7,$in7,$inpperm
+	 vcipher	$out6,$out6,v24
+	stvx_u		$in6,$x60,$out
+	 vcipher	$out7,$out7,v24
+	stvx_u		$in7,$x70,$out
+	addi		$out,$out,0x80
+
+	b		Loop_ctr32_enc8x_middle
+
+.align	5
+Lctr32_enc8x_break:
+	cmpwi		$len,-0x60
+	blt		Lctr32_enc8x_one
+	nop
+	beq		Lctr32_enc8x_two
+	cmpwi		$len,-0x40
+	blt		Lctr32_enc8x_three
+	nop
+	beq		Lctr32_enc8x_four
+	cmpwi		$len,-0x20
+	blt		Lctr32_enc8x_five
+	nop
+	beq		Lctr32_enc8x_six
+	cmpwi		$len,0x00
+	blt		Lctr32_enc8x_seven
+
+Lctr32_enc8x_eight:
+	vcipherlast	$out0,$out0,$in0
+	vcipherlast	$out1,$out1,$in1
+	vcipherlast	$out2,$out2,$in2
+	vcipherlast	$out3,$out3,$in3
+	vcipherlast	$out4,$out4,$in4
+	vcipherlast	$out5,$out5,$in5
+	vcipherlast	$out6,$out6,$in6
+	vcipherlast	$out7,$out7,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x10,$out
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x20,$out
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x30,$out
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x40,$out
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x50,$out
+	le?vperm	$out7,$out7,$out7,$inpperm
+	stvx_u		$out6,$x60,$out
+	stvx_u		$out7,$x70,$out
+	addi		$out,$out,0x80
+	b		Lctr32_enc8x_done
+
+.align	5
+Lctr32_enc8x_seven:
+	vcipherlast	$out0,$out0,$in1
+	vcipherlast	$out1,$out1,$in2
+	vcipherlast	$out2,$out2,$in3
+	vcipherlast	$out3,$out3,$in4
+	vcipherlast	$out4,$out4,$in5
+	vcipherlast	$out5,$out5,$in6
+	vcipherlast	$out6,$out6,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x10,$out
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x20,$out
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x30,$out
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x40,$out
+	le?vperm	$out6,$out6,$out6,$inpperm
+	stvx_u		$out5,$x50,$out
+	stvx_u		$out6,$x60,$out
+	addi		$out,$out,0x70
+	b		Lctr32_enc8x_done
+
+.align	5
+Lctr32_enc8x_six:
+	vcipherlast	$out0,$out0,$in2
+	vcipherlast	$out1,$out1,$in3
+	vcipherlast	$out2,$out2,$in4
+	vcipherlast	$out3,$out3,$in5
+	vcipherlast	$out4,$out4,$in6
+	vcipherlast	$out5,$out5,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x10,$out
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x20,$out
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x30,$out
+	le?vperm	$out5,$out5,$out5,$inpperm
+	stvx_u		$out4,$x40,$out
+	stvx_u		$out5,$x50,$out
+	addi		$out,$out,0x60
+	b		Lctr32_enc8x_done
+
+.align	5
+Lctr32_enc8x_five:
+	vcipherlast	$out0,$out0,$in3
+	vcipherlast	$out1,$out1,$in4
+	vcipherlast	$out2,$out2,$in5
+	vcipherlast	$out3,$out3,$in6
+	vcipherlast	$out4,$out4,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x10,$out
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x20,$out
+	le?vperm	$out4,$out4,$out4,$inpperm
+	stvx_u		$out3,$x30,$out
+	stvx_u		$out4,$x40,$out
+	addi		$out,$out,0x50
+	b		Lctr32_enc8x_done
+
+.align	5
+Lctr32_enc8x_four:
+	vcipherlast	$out0,$out0,$in4
+	vcipherlast	$out1,$out1,$in5
+	vcipherlast	$out2,$out2,$in6
+	vcipherlast	$out3,$out3,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x10,$out
+	le?vperm	$out3,$out3,$out3,$inpperm
+	stvx_u		$out2,$x20,$out
+	stvx_u		$out3,$x30,$out
+	addi		$out,$out,0x40
+	b		Lctr32_enc8x_done
+
+.align	5
+Lctr32_enc8x_three:
+	vcipherlast	$out0,$out0,$in5
+	vcipherlast	$out1,$out1,$in6
+	vcipherlast	$out2,$out2,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	le?vperm	$out2,$out2,$out2,$inpperm
+	stvx_u		$out1,$x10,$out
+	stvx_u		$out2,$x20,$out
+	addi		$out,$out,0x30
+	b		Lcbc_dec8x_done
+
+.align	5
+Lctr32_enc8x_two:
+	vcipherlast	$out0,$out0,$in6
+	vcipherlast	$out1,$out1,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	le?vperm	$out1,$out1,$out1,$inpperm
+	stvx_u		$out0,$x00,$out
+	stvx_u		$out1,$x10,$out
+	addi		$out,$out,0x20
+	b		Lcbc_dec8x_done
+
+.align	5
+Lctr32_enc8x_one:
+	vcipherlast	$out0,$out0,$in7
+
+	le?vperm	$out0,$out0,$out0,$inpperm
+	stvx_u		$out0,0,$out
+	addi		$out,$out,0x10
+
+Lctr32_enc8x_done:
+	li		r10,`$FRAME+15`
+	li		r11,`$FRAME+31`
+	stvx		$inpperm,r10,$sp	# wipe copies of round keys
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+	stvx		$inpperm,r10,$sp
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+	stvx		$inpperm,r10,$sp
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+	stvx		$inpperm,r10,$sp
+	addi		r10,r10,32
+	stvx		$inpperm,r11,$sp
+	addi		r11,r11,32
+
+	mtspr		256,$vrsave
+	lvx		v20,r10,$sp		# ABI says so
+	addi		r10,r10,32
+	lvx		v21,r11,$sp
+	addi		r11,r11,32
+	lvx		v22,r10,$sp
+	addi		r10,r10,32
+	lvx		v23,r11,$sp
+	addi		r11,r11,32
+	lvx		v24,r10,$sp
+	addi		r10,r10,32
+	lvx		v25,r11,$sp
+	addi		r11,r11,32
+	lvx		v26,r10,$sp
+	addi		r10,r10,32
+	lvx		v27,r11,$sp
+	addi		r11,r11,32
+	lvx		v28,r10,$sp
+	addi		r10,r10,32
+	lvx		v29,r11,$sp
+	addi		r11,r11,32
+	lvx		v30,r10,$sp
+	lvx		v31,r11,$sp
+	$POP		r26,`$FRAME+21*16+0*$SIZE_T`($sp)
+	$POP		r27,`$FRAME+21*16+1*$SIZE_T`($sp)
+	$POP		r28,`$FRAME+21*16+2*$SIZE_T`($sp)
+	$POP		r29,`$FRAME+21*16+3*$SIZE_T`($sp)
+	$POP		r30,`$FRAME+21*16+4*$SIZE_T`($sp)
+	$POP		r31,`$FRAME+21*16+5*$SIZE_T`($sp)
+	addi		$sp,$sp,`$FRAME+21*16+6*$SIZE_T`
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0x80,6,6,0
+	.long		0
+.size	.${prefix}_ctr32_encrypt_blocks,.-.${prefix}_ctr32_encrypt_block=
s
+___
+}}	}}}
+
+my $consts=3D1;
+foreach(split("\n",$code)) {
+        s/\`([^\`]*)\`/eval($1)/geo;
+
+	# constants table endian-specific conversion
+	if ($consts && m/\.(long|byte)\s+(.+)\s+(\?[a-z]*)$/o) {
+	    my $conv=3D$3;
+	    my @bytes=3D();
+
+	    # convert to endian-agnostic format
+	    if ($1 eq "long") {
+	      foreach (split(/,\s*/,$2)) {
+		my $l =3D /^0/?oct:int;
+		push @bytes,($l>>24)&0xff,($l>>16)&0xff,($l>>8)&0xff,$l&0xff;
+	      }
+	    } else {
+		@bytes =3D map(/^0/?oct:int,split(/,\s*/,$2));
+	    }
+
+	    # little-endian conversion
+	    if ($flavour =3D~ /le$/o) {
+		SWITCH: for($conv)  {
+		    /\?inv/ && do   { @bytes=3Dmap($_^0xf,@bytes); last; };
+		    /\?rev/ && do   { @bytes=3Dreverse(@bytes);    last; };=20
+		}
+	    }
+
+	    #emit
+	    print ".byte\t",join(',',map (sprintf("0x%02x",$_),@bytes)),"\n";
+	    next;
+	}
+	$consts=3D0 if (m/Lconsts:/o);	# end of table
+
+	# instructions prefixed with '?' are endian-specific and need
+	# to be adjusted accordingly...
+	if ($flavour =3D~ /le$/o) {	# little-endian
+	    s/le\?//o		or
+	    s/be\?/#be#/o	or
+	    s/\?lvsr/lvsl/o	or
+	    s/\?lvsl/lvsr/o	or
+	    s/\?(vperm\s+v[0-9]+,\s*)(v[0-9]+,\s*)(v[0-9]+,\s*)(v[0-9]+)/$1$3=
$2$4/o or
+	    s/\?(vsldoi\s+v[0-9]+,\s*)(v[0-9]+,)\s*(v[0-9]+,\s*)([0-9]+)/$1$3=
$2 16-$4/o or
+	    s/\?(vspltw\s+v[0-9]+,\s*)(v[0-9]+,)\s*([0-9])/$1$2 3-$3/o;
+	} else {			# big-endian
+	    s/le\?/#le#/o	or
+	    s/be\?//o		or
+	    s/\?([a-z]+)/$1/o;
+	}
+
+        print $_,"\n";
+}
+
+close STDOUT;
diff --git a/drivers/crypto/vmx/ghashp8-ppc.pl b/drivers/crypto/vmx/gha=
shp8-ppc.pl
new file mode 100755
index 0000000..e76a58c
--- /dev/null
+++ b/drivers/crypto/vmx/ghashp8-ppc.pl
@@ -0,0 +1,234 @@
+#!/usr/bin/env perl
+#
+# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
+# project. The module is, however, dual licensed under OpenSSL and
+# CRYPTOGAMS licenses depending on where you obtain it. For further
+# details see http://www.openssl.org/~appro/cryptogams/.
+# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+#
+# GHASH for for PowerISA v2.07.
+#
+# July 2014
+#
+# Accurate performance measurements are problematic, because it's
+# always virtualized setup with possibly throttled processor.
+# Relative comparison is therefore more informative. This initial
+# version is ~2.1x slower than hardware-assisted AES-128-CTR, ~12x
+# faster than "4-bit" integer-only compiler-generated 64-bit code.
+# "Initial version" means that there is room for futher improvement.
+
+$flavour=3Dshift;
+$output =3Dshift;
+
+if ($flavour =3D~ /64/) {
+	$SIZE_T=3D8;
+	$LRSAVE=3D2*$SIZE_T;
+	$STU=3D"stdu";
+	$POP=3D"ld";
+	$PUSH=3D"std";
+} elsif ($flavour =3D~ /32/) {
+	$SIZE_T=3D4;
+	$LRSAVE=3D$SIZE_T;
+	$STU=3D"stwu";
+	$POP=3D"lwz";
+	$PUSH=3D"stw";
+} else { die "nonsense $flavour"; }
+
+$0 =3D~ m/(.*[\/\\])[^\/\\]+$/; $dir=3D$1;
+( $xlate=3D"${dir}ppc-xlate.pl" and -f $xlate ) or
+( $xlate=3D"${dir}../../perlasm/ppc-xlate.pl" and -f $xlate) or
+die "can't locate ppc-xlate.pl";
+
+open STDOUT,"| $^X $xlate $flavour $output" || die "can't call $xlate:=
 $!";
+
+my ($Xip,$Htbl,$inp,$len)=3Dmap("r$_",(3..6));	# argument block
+
+my ($Xl,$Xm,$Xh,$IN)=3Dmap("v$_",(0..3));
+my ($zero,$t0,$t1,$t2,$xC2,$H,$Hh,$Hl,$lemask)=3Dmap("v$_",(4..12));
+my $vrsave=3D"r12";
+
+$code=3D<<___;
+.machine	"any"
+
+.text
+
+.globl	.gcm_init_p8
+.align	5
+.gcm_init_p8:
+	lis		r0,0xfff0
+	li		r8,0x10
+	mfspr		$vrsave,256
+	li		r9,0x20
+	mtspr		256,r0
+	li		r10,0x30
+	lvx_u		$H,0,r4			# load H
+
+	vspltisb	$xC2,-16		# 0xf0
+	vspltisb	$t0,1			# one
+	vaddubm		$xC2,$xC2,$xC2		# 0xe0
+	vxor		$zero,$zero,$zero
+	vor		$xC2,$xC2,$t0		# 0xe1
+	vsldoi		$xC2,$xC2,$zero,15	# 0xe1...
+	vsldoi		$t1,$zero,$t0,1		# ...1
+	vaddubm		$xC2,$xC2,$xC2		# 0xc2...
+	vspltisb	$t2,7
+	vor		$xC2,$xC2,$t1		# 0xc2....01
+	vspltb		$t1,$H,0		# most significant byte
+	vsl		$H,$H,$t0		# H<<=3D1
+	vsrab		$t1,$t1,$t2		# broadcast carry bit
+	vand		$t1,$t1,$xC2
+	vxor		$H,$H,$t1		# twisted H
+
+	vsldoi		$H,$H,$H,8		# twist even more ...
+	vsldoi		$xC2,$zero,$xC2,8	# 0xc2.0
+	vsldoi		$Hl,$zero,$H,8		# ... and split
+	vsldoi		$Hh,$H,$zero,8
+
+	stvx_u		$xC2,0,r3		# save pre-computed table
+	stvx_u		$Hl,r8,r3
+	stvx_u		$H, r9,r3
+	stvx_u		$Hh,r10,r3
+
+	mtspr		256,$vrsave
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0,0,2,0
+	.long		0
+.size	.gcm_init_p8,.-.gcm_init_p8
+
+.globl	.gcm_gmult_p8
+.align	5
+.gcm_gmult_p8:
+	lis		r0,0xfff8
+	li		r8,0x10
+	mfspr		$vrsave,256
+	li		r9,0x20
+	mtspr		256,r0
+	li		r10,0x30
+	lvx_u		$IN,0,$Xip		# load Xi
+
+	lvx_u		$Hl,r8,$Htbl		# load pre-computed table
+	 le?lvsl	$lemask,r0,r0
+	lvx_u		$H, r9,$Htbl
+	 le?vspltisb	$t0,0x07
+	lvx_u		$Hh,r10,$Htbl
+	 le?vxor	$lemask,$lemask,$t0
+	lvx_u		$xC2,0,$Htbl
+	 le?vperm	$IN,$IN,$IN,$lemask
+	vxor		$zero,$zero,$zero
+
+	vpmsumd		$Xl,$IN,$Hl		# H.lo=B7Xi.lo
+	vpmsumd		$Xm,$IN,$H		# H.hi=B7Xi.lo+H.lo=B7Xi.hi
+	vpmsumd		$Xh,$IN,$Hh		# H.hi=B7Xi.hi
+
+	vpmsumd		$t2,$Xl,$xC2		# 1st phase
+
+	vsldoi		$t0,$Xm,$zero,8
+	vsldoi		$t1,$zero,$Xm,8
+	vxor		$Xl,$Xl,$t0
+	vxor		$Xh,$Xh,$t1
+
+	vsldoi		$Xl,$Xl,$Xl,8
+	vxor		$Xl,$Xl,$t2
+
+	vsldoi		$t1,$Xl,$Xl,8		# 2nd phase
+	vpmsumd		$Xl,$Xl,$xC2
+	vxor		$t1,$t1,$Xh
+	vxor		$Xl,$Xl,$t1
+
+	le?vperm	$Xl,$Xl,$Xl,$lemask
+	stvx_u		$Xl,0,$Xip		# write out Xi
+
+	mtspr		256,$vrsave
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0,0,2,0
+	.long		0
+.size	.gcm_gmult_p8,.-.gcm_gmult_p8
+
+.globl	.gcm_ghash_p8
+.align	5
+.gcm_ghash_p8:
+	lis		r0,0xfff8
+	li		r8,0x10
+	mfspr		$vrsave,256
+	li		r9,0x20
+	mtspr		256,r0
+	li		r10,0x30
+	lvx_u		$Xl,0,$Xip		# load Xi
+
+	lvx_u		$Hl,r8,$Htbl		# load pre-computed table
+	 le?lvsl	$lemask,r0,r0
+	lvx_u		$H, r9,$Htbl
+	 le?vspltisb	$t0,0x07
+	lvx_u		$Hh,r10,$Htbl
+	 le?vxor	$lemask,$lemask,$t0
+	lvx_u		$xC2,0,$Htbl
+	 le?vperm	$Xl,$Xl,$Xl,$lemask
+	vxor		$zero,$zero,$zero
+
+	lvx_u		$IN,0,$inp
+	addi		$inp,$inp,16
+	subi		$len,$len,16
+	 le?vperm	$IN,$IN,$IN,$lemask
+	vxor		$IN,$IN,$Xl
+	b		Loop
+
+.align	5
+Loop:
+	 subic		$len,$len,16
+	vpmsumd		$Xl,$IN,$Hl		# H.lo=B7Xi.lo
+	 subfe.		r0,r0,r0		# borrow?-1:0
+	vpmsumd		$Xm,$IN,$H		# H.hi=B7Xi.lo+H.lo=B7Xi.hi
+	 and		r0,r0,$len
+	vpmsumd		$Xh,$IN,$Hh		# H.hi=B7Xi.hi
+	 add		$inp,$inp,r0
+
+	vpmsumd		$t2,$Xl,$xC2		# 1st phase
+
+	vsldoi		$t0,$Xm,$zero,8
+	vsldoi		$t1,$zero,$Xm,8
+	vxor		$Xl,$Xl,$t0
+	vxor		$Xh,$Xh,$t1
+
+	vsldoi		$Xl,$Xl,$Xl,8
+	vxor		$Xl,$Xl,$t2
+	 lvx_u		$IN,0,$inp
+	 addi		$inp,$inp,16
+
+	vsldoi		$t1,$Xl,$Xl,8		# 2nd phase
+	vpmsumd		$Xl,$Xl,$xC2
+	 le?vperm	$IN,$IN,$IN,$lemask
+	vxor		$t1,$t1,$Xh
+	vxor		$IN,$IN,$t1
+	vxor		$IN,$IN,$Xl
+	beq		Loop			# did $len-=3D16 borrow?
+
+	vxor		$Xl,$Xl,$t1
+	le?vperm	$Xl,$Xl,$Xl,$lemask
+	stvx_u		$Xl,0,$Xip		# write out Xi
+
+	mtspr		256,$vrsave
+	blr
+	.long		0
+	.byte		0,12,0x14,0,0,0,4,0
+	.long		0
+.size	.gcm_ghash_p8,.-.gcm_ghash_p8
+
+.asciz  "GHASH for PowerISA 2.07, CRYPTOGAMS by <appro\@openssl.org>"
+.align  2
+___
+
+foreach (split("\n",$code)) {
+	if ($flavour =3D~ /le$/o) {	# little-endian
+	    s/le\?//o		or
+	    s/be\?/#be#/o;
+	} else {
+	    s/le\?/#le#/o	or
+	    s/be\?//o;
+	}
+	print $_,"\n";
+}
+
+close STDOUT; # enforce flush
diff --git a/drivers/crypto/vmx/ppc-xlate.pl b/drivers/crypto/vmx/ppc-x=
late.pl
new file mode 100755
index 0000000..f89e814
--- /dev/null
+++ b/drivers/crypto/vmx/ppc-xlate.pl
@@ -0,0 +1,226 @@
+#!/usr/bin/env perl
+
+# PowerPC assembler distiller by <appro>.
+
+my $flavour =3D shift;
+my $output =3D shift;
+open STDOUT,">$output" || die "can't open $output: $!";
+
+my %GLOBALS;
+my $dotinlocallabels=3D($flavour=3D~/linux/)?1:0;
+
+################################################################
+# directives which need special treatment on different platforms
+################################################################
+my $globl =3D sub {
+    my $junk =3D shift;
+    my $name =3D shift;
+    my $global =3D \$GLOBALS{$name};
+    my $ret;
+
+    $name =3D~ s|^[\.\_]||;
+=20
+    SWITCH: for ($flavour) {
+	/aix/		&& do { $name =3D ".$name";
+				last;
+			      };
+	/osx/		&& do { $name =3D "_$name";
+				last;
+			      };
+	/linux.*(32|64le)/
+			&& do {	$ret .=3D ".globl	$name\n";
+				$ret .=3D ".type	$name,\@function";
+				last;
+			      };
+	/linux.*64/	&& do {	$ret .=3D ".globl	$name\n";
+				$ret .=3D ".type	$name,\@function\n";
+				$ret .=3D ".section	\".opd\",\"aw\"\n";
+				$ret .=3D ".align	3\n";
+				$ret .=3D "$name:\n";
+				$ret .=3D ".quad	.$name,.TOC.\@tocbase,0\n";
+				$ret .=3D ".previous\n";
+
+				$name =3D ".$name";
+				last;
+			      };
+    }
+
+    $ret =3D ".globl	$name" if (!$ret);
+    $$global =3D $name;
+    $ret;
+};
+my $text =3D sub {
+    my $ret =3D ($flavour =3D~ /aix/) ? ".csect\t.text[PR],7" : ".text=
";
+    $ret =3D ".abiversion	2\n".$ret	if ($flavour =3D~ /linux.*64le/);
+    $ret;
+};
+my $machine =3D sub {
+    my $junk =3D shift;
+    my $arch =3D shift;
+    if ($flavour =3D~ /osx/)
+    {	$arch =3D~ s/\"//g;
+	$arch =3D ($flavour=3D~/64/) ? "ppc970-64" : "ppc970" if ($arch eq "a=
ny");
+    }
+    ".machine	$arch";
+};
+my $size =3D sub {
+    if ($flavour =3D~ /linux/)
+    {	shift;
+	my $name =3D shift; $name =3D~ s|^[\.\_]||;
+	my $ret  =3D ".size	$name,.-".($flavour=3D~/64$/?".":"").$name;
+	$ret .=3D "\n.size	.$name,.-.$name" if ($flavour=3D~/64$/);
+	$ret;
+    }
+    else
+    {	"";	}
+};
+my $asciz =3D sub {
+    shift;
+    my $line =3D join(",",@_);
+    if ($line =3D~ /^"(.*)"$/)
+    {	".byte	" . join(",",unpack("C*",$1),0) . "\n.align	2";	}
+    else
+    {	"";	}
+};
+my $quad =3D sub {
+    shift;
+    my @ret;
+    my ($hi,$lo);
+    for (@_) {
+	if (/^0x([0-9a-f]*?)([0-9a-f]{1,8})$/io)
+	{  $hi=3D$1?"0x$1":"0"; $lo=3D"0x$2";  }
+	elsif (/^([0-9]+)$/o)
+	{  $hi=3D$1>>32; $lo=3D$1&0xffffffff;  } # error-prone with 32-bit pe=
rl
+	else
+	{  $hi=3Dundef; $lo=3D$_; }
+
+	if (defined($hi))
+	{  push(@ret,$flavour=3D~/le$/o?".long\t$lo,$hi":".long\t$hi,$lo");  =
}
+	else
+	{  push(@ret,".quad	$lo");  }
+    }
+    join("\n",@ret);
+};
+
+################################################################
+# simplified mnemonics not handled by at least one assembler
+################################################################
+my $cmplw =3D sub {
+    my $f =3D shift;
+    my $cr =3D 0; $cr =3D shift if ($#_>1);
+    # Some out-of-date 32-bit GNU assembler just can't handle cmplw...
+    ($flavour =3D~ /linux.*32/) ?
+	"	.long	".sprintf "0x%x",31<<26|$cr<<23|$_[0]<<16|$_[1]<<11|64 :
+	"	cmplw	".join(',',$cr,@_);
+};
+my $bdnz =3D sub {
+    my $f =3D shift;
+    my $bo =3D $f=3D~/[\+\-]/ ? 16+9 : 16;	# optional "to be taken" hi=
nt
+    "	bc	$bo,0,".shift;
+} if ($flavour!~/linux/);
+my $bltlr =3D sub {
+    my $f =3D shift;
+    my $bo =3D $f=3D~/\-/ ? 12+2 : 12;	# optional "not to be taken" hi=
nt
+    ($flavour =3D~ /linux/) ?		# GNU as doesn't allow most recent hint=
s
+	"	.long	".sprintf "0x%x",19<<26|$bo<<21|16<<1 :
+	"	bclr	$bo,0";
+};
+my $bnelr =3D sub {
+    my $f =3D shift;
+    my $bo =3D $f=3D~/\-/ ? 4+2 : 4;	# optional "not to be taken" hint
+    ($flavour =3D~ /linux/) ?		# GNU as doesn't allow most recent hint=
s
+	"	.long	".sprintf "0x%x",19<<26|$bo<<21|2<<16|16<<1 :
+	"	bclr	$bo,2";
+};
+my $beqlr =3D sub {
+    my $f =3D shift;
+    my $bo =3D $f=3D~/-/ ? 12+2 : 12;	# optional "not to be taken" hin=
t
+    ($flavour =3D~ /linux/) ?		# GNU as doesn't allow most recent hint=
s
+	"	.long	".sprintf "0x%X",19<<26|$bo<<21|2<<16|16<<1 :
+	"	bclr	$bo,2";
+};
+# GNU assembler can't handle extrdi rA,rS,16,48, or when sum of last t=
wo
+# arguments is 64, with "operand out of range" error.
+my $extrdi =3D sub {
+    my ($f,$ra,$rs,$n,$b) =3D @_;
+    $b =3D ($b+$n)&63; $n =3D 64-$n;
+    "	rldicl	$ra,$rs,$b,$n";
+};
+my $vmr =3D sub {
+    my ($f,$vx,$vy) =3D @_;
+    "	vor	$vx,$vy,$vy";
+};
+
+# PowerISA 2.06 stuff
+sub vsxmem_op {
+    my ($f, $vrt, $ra, $rb, $op) =3D @_;
+    "	.long	".sprintf "0x%X",(31<<26)|($vrt<<21)|($ra<<16)|($rb<<11)|(=
$op*2+1);
+}
+# made-up unaligned memory reference AltiVec/VMX instructions
+my $lvx_u	=3D sub {	vsxmem_op(@_, 844); };	# lxvd2x
+my $stvx_u	=3D sub {	vsxmem_op(@_, 972); };	# stxvd2x
+my $lvdx_u	=3D sub {	vsxmem_op(@_, 588); };	# lxsdx
+my $stvdx_u	=3D sub {	vsxmem_op(@_, 716); };	# stxsdx
+my $lvx_4w	=3D sub { vsxmem_op(@_, 780); };	# lxvw4x
+my $stvx_4w	=3D sub { vsxmem_op(@_, 908); };	# stxvw4x
+
+# PowerISA 2.07 stuff
+sub vcrypto_op {
+    my ($f, $vrt, $vra, $vrb, $op) =3D @_;
+    "	.long	".sprintf "0x%X",(4<<26)|($vrt<<21)|($vra<<16)|($vrb<<11)|=
$op;
+}
+my $vcipher	=3D sub { vcrypto_op(@_, 1288); };
+my $vcipherlast	=3D sub { vcrypto_op(@_, 1289); };
+my $vncipher	=3D sub { vcrypto_op(@_, 1352); };
+my $vncipherlast=3D sub { vcrypto_op(@_, 1353); };
+my $vsbox	=3D sub { vcrypto_op(@_, 0, 1480); };
+my $vshasigmad	=3D sub { my ($st,$six)=3Dsplice(@_,-2); vcrypto_op(@_,=
 $st<<4|$six, 1730); };
+my $vshasigmaw	=3D sub { my ($st,$six)=3Dsplice(@_,-2); vcrypto_op(@_,=
 $st<<4|$six, 1666); };
+my $vpmsumb	=3D sub { vcrypto_op(@_, 1032); };
+my $vpmsumd	=3D sub { vcrypto_op(@_, 1224); };
+my $vpmsubh	=3D sub { vcrypto_op(@_, 1096); };
+my $vpmsumw	=3D sub { vcrypto_op(@_, 1160); };
+my $vaddudm	=3D sub { vcrypto_op(@_, 192);  };
+
+my $mtsle	=3D sub {
+    my ($f, $arg) =3D @_;
+    "	.long	".sprintf "0x%X",(31<<26)|($arg<<21)|(147*2);
+};
+
+while($line=3D<>) {
+
+    $line =3D~ s|[#!;].*$||;	# get rid of asm-style comments...
+    $line =3D~ s|/\*.*\*/||;	# ... and C-style comments...
+    $line =3D~ s|^\s+||;		# ... and skip white spaces in beginning...
+    $line =3D~ s|\s+$||;		# ... and at the end
+
+    {
+	$line =3D~ s|\b\.L(\w+)|L$1|g;	# common denominator for Locallabel
+	$line =3D~ s|\bL(\w+)|\.L$1|g	if ($dotinlocallabels);
+    }
+
+    {
+	$line =3D~ s|(^[\.\w]+)\:\s*||;
+	my $label =3D $1;
+	if ($label) {
+	    printf "%s:",($GLOBALS{$label} or $label);
+	    printf "\n.localentry\t$GLOBALS{$label},0"	if ($GLOBALS{$label} &=
& $flavour =3D~ /linux.*64le/);
+	}
+    }
+
+    {
+	$line =3D~ s|^\s*(\.?)(\w+)([\.\+\-]?)\s*||;
+	my $c =3D $1; $c =3D "\t" if ($c eq "");
+	my $mnemonic =3D $2;
+	my $f =3D $3;
+	my $opcode =3D eval("\$$mnemonic");
+	$line =3D~ s/\b(c?[rf]|v|vs)([0-9]+)\b/$2/g if ($c ne "." and $flavou=
r !~ /osx/);
+	if (ref($opcode) eq 'CODE') { $line =3D &$opcode($f,split(',',$line))=
; }
+	elsif ($mnemonic)           { $line =3D $c.$mnemonic.$f."\t".$line; }
+    }
+
+    print $line if ($line);
+    print "\n";
+}
+
+close STDOUT;
--=20
2.1.0
