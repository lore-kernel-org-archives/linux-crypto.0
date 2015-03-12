From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: linux-next: Tree for Mar 11 (powerpc build failure due to vmx
 crypto code)
Date: Wed, 11 Mar 2015 20:51:32 -0700
Message-ID: <55010D44.7030900@roeck-us.net>
References: <20150311163558.6a09cfcc@canb.auug.org.au> <20150311154717.GA22169@roeck-us.net> <20150312012315.GA12660@gondor.apana.org.au> <5500FD4A.7050408@roeck-us.net> <20150312032829.GA13737@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:50594 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbCLDvj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 23:51:39 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.82)
	(envelope-from <linux@roeck-us.net>)
	id 1YVu9p-000YfC-UY
	for linux-crypto@vger.kernel.org; Thu, 12 Mar 2015 03:51:38 +0000
In-Reply-To: <20150312032829.GA13737@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/11/2015 08:28 PM, Herbert Xu wrote:
> On Wed, Mar 11, 2015 at 07:43:22PM -0700, Guenter Roeck wrote:
>>
>> It looks like the perl scripts do run - I see the .S files, and I do see .o files created.
>> But I still get the error.
>>
>> Looking into the object files, I see
>>
>> $ nm vmx-crypto.o | grep aes_p8_cbc_encrypt
>> 0000000000000680 t .aes_p8_cbc_encrypt
>>                   U .aes_p8_cbc_encrypt
>> 00000000000000a8 D aes_p8_cbc_encrypt
>
> Ugh, does this patch help?
>
> Thanks,
>
> --8<--
> crypto: vmx - Fix assembler perl to use _GLOBAL
>
> Rather than doing things by hand for global symbols to deal with
> different calling conventions we already have a macro _GLOBAL in
> Linux to handle this.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
Yes, this helps.

Feel free to add

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

> diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
> old mode 100755
> new mode 100644
> index 3ee8979..6c5c20c
> --- a/drivers/crypto/vmx/aesp8-ppc.pl
> +++ b/drivers/crypto/vmx/aesp8-ppc.pl
> @@ -85,8 +85,6 @@ Lconsts:
>   .asciz	"AES for PowerISA 2.07, CRYPTOGAMS by <appro\@openssl.org>"
>
>   .globl	.${prefix}_set_encrypt_key
> -.align	5
> -.${prefix}_set_encrypt_key:
>   Lset_encrypt_key:
>   	mflr		r11
>   	$PUSH		r11,$LRSAVE($sp)
> @@ -348,8 +346,6 @@ Lenc_key_abort:
>   .size	.${prefix}_set_encrypt_key,.-.${prefix}_set_encrypt_key
>
>   .globl	.${prefix}_set_decrypt_key
> -.align	5
> -.${prefix}_set_decrypt_key:
>   	$STU		$sp,-$FRAME($sp)
>   	mflr		r10
>   	$PUSH		r10,$FRAME+$LRSAVE($sp)
> @@ -405,8 +401,6 @@ my ($inp,$out,$key,$rounds,$idx)=map("r$_",(3..7));
>
>   $code.=<<___;
>   .globl	.${prefix}_${dir}crypt
> -.align	5
> -.${prefix}_${dir}crypt:
>   	lwz		$rounds,240($key)
>   	lis		r0,0xfc00
>   	mfspr		$vrsave,256
> @@ -484,8 +478,6 @@ my ($ivec,$inptail,$inpperm,$outhead,$outperm,$outmask,$keyperm)=
>   						map("v$_",(4..10));
>   $code.=<<___;
>   .globl	.${prefix}_cbc_encrypt
> -.align	5
> -.${prefix}_cbc_encrypt:
>   	${UCMP}i	$len,16
>   	bltlr-
>
> @@ -1243,8 +1235,6 @@ my $dat=$tmp;
>
>   $code.=<<___;
>   .globl	.${prefix}_ctr32_encrypt_blocks
> -.align	5
> -.${prefix}_ctr32_encrypt_blocks:
>   	${UCMP}i	$len,1
>   	bltlr-
>
> diff --git a/drivers/crypto/vmx/ghashp8-ppc.pl b/drivers/crypto/vmx/ghashp8-ppc.pl
> old mode 100755
> new mode 100644
> index e76a58c..0a6f899
> --- a/drivers/crypto/vmx/ghashp8-ppc.pl
> +++ b/drivers/crypto/vmx/ghashp8-ppc.pl
> @@ -54,8 +54,6 @@ $code=<<___;
>   .text
>
>   .globl	.gcm_init_p8
> -.align	5
> -.gcm_init_p8:
>   	lis		r0,0xfff0
>   	li		r8,0x10
>   	mfspr		$vrsave,256
> @@ -98,8 +96,6 @@ $code=<<___;
>   .size	.gcm_init_p8,.-.gcm_init_p8
>
>   .globl	.gcm_gmult_p8
> -.align	5
> -.gcm_gmult_p8:
>   	lis		r0,0xfff8
>   	li		r8,0x10
>   	mfspr		$vrsave,256
> @@ -148,8 +144,6 @@ $code=<<___;
>   .size	.gcm_gmult_p8,.-.gcm_gmult_p8
>
>   .globl	.gcm_ghash_p8
> -.align	5
> -.gcm_ghash_p8:
>   	lis		r0,0xfff8
>   	li		r8,0x10
>   	mfspr		$vrsave,256
> diff --git a/drivers/crypto/vmx/ppc-xlate.pl b/drivers/crypto/vmx/ppc-xlate.pl
> old mode 100755
> new mode 100644
> index f89e814..a591884
> --- a/drivers/crypto/vmx/ppc-xlate.pl
> +++ b/drivers/crypto/vmx/ppc-xlate.pl
> @@ -27,25 +27,13 @@ my $globl = sub {
>   	/osx/		&& do { $name = "_$name";
>   				last;
>   			      };
> -	/linux.*(32|64le)/
> -			&& do {	$ret .= ".globl	$name\n";
> -				$ret .= ".type	$name,\@function";
> -				last;
> -			      };
> -	/linux.*64/	&& do {	$ret .= ".globl	$name\n";
> -				$ret .= ".type	$name,\@function\n";
> -				$ret .= ".section	\".opd\",\"aw\"\n";
> -				$ret .= ".align	3\n";
> -				$ret .= "$name:\n";
> -				$ret .= ".quad	.$name,.TOC.\@tocbase,0\n";
> -				$ret .= ".previous\n";
> -
> -				$name = ".$name";
> +	/linux/
> +			&& do {	$ret = "_GLOBAL($name)";
>   				last;
>   			      };
>       }
>
> -    $ret = ".globl	$name" if (!$ret);
> +    $ret = ".globl	$name\nalign 5\n$name:" if (!$ret);
>       $$global = $name;
>       $ret;
>   };
> @@ -187,6 +175,8 @@ my $mtsle	= sub {
>       "	.long	".sprintf "0x%X",(31<<26)|($arg<<21)|(147*2);
>   };
>
> +print "#include <asm/ppc_asm.h>\n" if $flavour =~ /linux/;
> +
>   while($line=<>) {
>
>       $line =~ s|[#!;].*$||;	# get rid of asm-style comments...
> @@ -200,15 +190,6 @@ while($line=<>) {
>       }
>
>       {
> -	$line =~ s|(^[\.\w]+)\:\s*||;
> -	my $label = $1;
> -	if ($label) {
> -	    printf "%s:",($GLOBALS{$label} or $label);
> -	    printf "\n.localentry\t$GLOBALS{$label},0"	if ($GLOBALS{$label} && $flavour =~ /linux.*64le/);
> -	}
> -    }
> -
> -    {
>   	$line =~ s|^\s*(\.?)(\w+)([\.\+\-]?)\s*||;
>   	my $c = $1; $c = "\t" if ($c eq "");
>   	my $mnemonic = $2;
>
