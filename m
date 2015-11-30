From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 2/2] Removing VRSAVE save and restore
Date: Mon, 30 Nov 2015 16:20:50 -0200
Message-ID: <20151130182046.GA16040@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: pfsmorigo@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:51456 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbbK3SU6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Nov 2015 13:20:58 -0500
Received: from localhost
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 16:20:57 -0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With VSX it no longer makes any sense to try to save
restore individual VRs. Also, each access to save and
restore VRSAVE has a high cost in performance.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@br.ibm.com>
Signed-off-by: Paulo Smorigo <pfsmorigo@br.ibm.com>
---
 drivers/crypto/vmx/aesp8-ppc.pl   | 18 ------------------
 drivers/crypto/vmx/ghashp8-ppc.pl | 11 -----------
 2 files changed, 29 deletions(-)

diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
index 2280539..d0a820f 100644
--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -102,10 +102,6 @@ Lset_encrypt_key:
 	andi.		r0,$bits,0x3f
 	bne-		Lenc_key_abort
 
-	lis		r0,0xfff0
-	mfspr		$vrsave,256
-	mtspr		256,r0
-
 	bl		Lconsts
 	mtlr		r11
 
@@ -334,7 +330,6 @@ Ldone:
 	vsel		$in1,$outhead,$in1,$outmask
 	stvx		$in1,0,$inp
 	li		$ptr,0
-	mtspr		256,$vrsave
 	stw		$rounds,0($out)
 
 Lenc_key_abort:
@@ -402,10 +397,7 @@ my ($inp,$out,$key,$rounds,$idx)=map("r$_",(3..7));
 $code.=<<___;
 .globl	.${prefix}_${dir}crypt
 	lwz		$rounds,240($key)
-	lis		r0,0xfc00
-	mfspr		$vrsave,256
 	li		$idx,15			# 15 is not typo
-	mtspr		256,r0
 
 	lvx		v0,0,$inp
 	neg		r11,$out
@@ -459,7 +451,6 @@ Loop_${dir}c:
 	vsel		v0,v0,v4,v2
 	stvx		v0,$idx,$out
 
-	mtspr		256,$vrsave
 	blr
 	.long		0
 	.byte		0,12,0x14,0,0,0,3,0
@@ -482,9 +473,6 @@ $code.=<<___;
 	bltlr-
 
 	cmpwi		$enc,0			# test direction
-	lis		r0,0xffe0
-	mfspr		$vrsave,256
-	mtspr		256,r0
 
 	li		$idx,15
 	vxor		$rndkey0,$rndkey0,$rndkey0
@@ -630,7 +618,6 @@ Lcbc_done:
 	vsel		$inout,$ivec,$inptail,$outmask
 	stvx		$inout,$idx,$ivp
 
-	mtspr		256,$vrsave
 	blr
 	.long		0
 	.byte		0,12,0x14,0,0,0,6,0
@@ -1238,10 +1225,6 @@ $code.=<<___;
 	${UCMP}i	$len,1
 	bltlr-
 
-	lis		r0,0xfff0
-	mfspr		$vrsave,256
-	mtspr		256,r0
-
 	li		$idx,15
 	vxor		$rndkey0,$rndkey0,$rndkey0
 	le?vspltisb	$tmp,0x0f
@@ -1333,7 +1316,6 @@ Loop_ctr32_enc:
 	vsel		$inout,$outhead,$inout,$outmask
 	stvx		$inout,0,$out
 
-	mtspr		256,$vrsave
 	blr
 	.long		0
 	.byte		0,12,0x14,0,0,0,6,0
diff --git a/drivers/crypto/vmx/ghashp8-ppc.pl b/drivers/crypto/vmx/ghashp8-ppc.pl
index d8429cb..2f83abe 100644
--- a/drivers/crypto/vmx/ghashp8-ppc.pl
+++ b/drivers/crypto/vmx/ghashp8-ppc.pl
@@ -46,7 +46,6 @@ my ($Xip,$Htbl,$inp,$len)=map("r$_",(3..6));	# argument block
 
 my ($Xl,$Xm,$Xh,$IN)=map("v$_",(0..3));
 my ($zero,$t0,$t1,$t2,$xC2,$H,$Hh,$Hl,$lemask)=map("v$_",(4..12));
-my $vrsave="r12";
 
 $code=<<___;
 .machine	"any"
@@ -54,11 +53,8 @@ $code=<<___;
 .text
 
 .globl	.gcm_init_p8
-	lis		r0,0xfff0
 	li		r8,0x10
-	mfspr		$vrsave,256
 	li		r9,0x20
-	mtspr		256,r0
 	li		r10,0x30
 	lvx_u		$H,0,r4			# load H
 	le?xor		r7,r7,r7
@@ -94,7 +90,6 @@ $code=<<___;
 	stvx_u		$H, r9,r3
 	stvx_u		$Hh,r10,r3
 
-	mtspr		256,$vrsave
 	blr
 	.long		0
 	.byte		0,12,0x14,0,0,0,2,0
@@ -104,9 +99,7 @@ $code=<<___;
 .globl	.gcm_gmult_p8
 	lis		r0,0xfff8
 	li		r8,0x10
-	mfspr		$vrsave,256
 	li		r9,0x20
-	mtspr		256,r0
 	li		r10,0x30
 	lvx_u		$IN,0,$Xip		# load Xi
 
@@ -142,7 +135,6 @@ $code=<<___;
 	le?vperm	$Xl,$Xl,$Xl,$lemask
 	stvx_u		$Xl,0,$Xip		# write out Xi
 
-	mtspr		256,$vrsave
 	blr
 	.long		0
 	.byte		0,12,0x14,0,0,0,2,0
@@ -152,9 +144,7 @@ $code=<<___;
 .globl	.gcm_ghash_p8
 	lis		r0,0xfff8
 	li		r8,0x10
-	mfspr		$vrsave,256
 	li		r9,0x20
-	mtspr		256,r0
 	li		r10,0x30
 	lvx_u		$Xl,0,$Xip		# load Xi
 
@@ -209,7 +199,6 @@ Loop:
 	le?vperm	$Xl,$Xl,$Xl,$lemask
 	stvx_u		$Xl,0,$Xip		# write out Xi
 
-	mtspr		256,$vrsave
 	blr
 	.long		0
 	.byte		0,12,0x14,0,0,0,4,0
-- 
2.1.0
