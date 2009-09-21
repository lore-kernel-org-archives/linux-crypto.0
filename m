From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
Subject: Re: Padlock SHA1 failed at boot time
Date: Mon, 21 Sep 2009 09:49:52 +0200
Message-ID: <4AB73020.1050403@e-teleport.net>
References: <20090921061324.GA16944@gondor.apana.org.au>
Reply-To: technique@e-teleport.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.e-teleport.net ([213.190.64.162]:39194 "EHLO
	smtp.e-teleport.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbZIUHtu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2009 03:49:50 -0400
In-Reply-To: <20090921061324.GA16944@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu a =E9crit :
> S=E9guier R=E9gis <rseguier@e-teleport.net> wrote:
>  =20
>> Hi,
>>
>> With 2.6.31, at boot time,i got this error.
>> The previous version i use was 2.6.31-rc6 and work fine for me.
>>
>> cpuidle: using governor menu
>> padlock: Using VIA PadLock ACE for AES algorithm.
>> general protection fault: 0000 [#1] PREEMPT
>> last sysfs file:
>>
>> Pid: 83, comm: cryptomgr_test Not tainted (2.6.31EPIA_NAB7500 #311)=20
>> CN896-8251
>> EIP: 0060:[<c1247ef5>] EFLAGS: 00010202 CPU: 0
>> EIP is at padlock_sha1_finup+0x1a2/0x1f3
>> EAX: 00000000 EBX: 00000003 ECX: 00000003 EDX: 00000001
>> ESI: f734f000 EDI: f7367c88 EBP: f7367d18 ESP: f7367c18
>>    =20
>
> This looks like an alignment fault.
>
> Can you please try this patch? Thanks!
>
> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sh=
a.c
> index 76cb6b3..fe007b6 100644
> --- a/drivers/crypto/padlock-sha.c
> +++ b/drivers/crypto/padlock-sha.c
> @@ -24,6 +24,12 @@
>  #include <asm/i387.h>
>  #include "padlock.h"
> =20
> +#ifdef CONFIG_64BIT
> +#define STACK_ALIGN 16
> +#else
> +#define STACK_ALIGN 4
> +#endif
> +
>  struct padlock_sha_desc {
>  	struct shash_desc fallback;
>  };
> @@ -64,7 +70,8 @@ static int padlock_sha1_finup(struct shash_desc *de=
sc, const u8 *in,
>  	/* We can't store directly to *out as it may be unaligned. */
>  	/* BTW Don't reduce the buffer size below 128 Bytes!
>  	 *     PadLock microcode needs it that big. */
> -	char result[128] __attribute__ ((aligned(PADLOCK_ALIGNMENT)));
> +	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN];
> +	char *result =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
>  	struct padlock_sha_desc *dctx =3D shash_desc_ctx(desc);
>  	struct sha1_state state;
>  	unsigned int space;
> @@ -128,7 +135,8 @@ static int padlock_sha256_finup(struct shash_desc=
 *desc, const u8 *in,
>  	/* We can't store directly to *out as it may be unaligned. */
>  	/* BTW Don't reduce the buffer size below 128 Bytes!
>  	 *     PadLock microcode needs it that big. */
> -	char result[128] __attribute__ ((aligned(PADLOCK_ALIGNMENT)));
> +	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN];
> +	char *result =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
>  	struct padlock_sha_desc *dctx =3D shash_desc_ctx(desc);
>  	struct sha256_state state;
>  	unsigned int space;
>
>  =20
it's good for me now.

Thanks.
--=20
R=E9gis S=E9guier
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
