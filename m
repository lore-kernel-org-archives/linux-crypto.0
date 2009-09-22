From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
Subject: Re: Padlock SHA1 failed at boot time
Date: Tue, 22 Sep 2009 19:34:17 +0200
Message-ID: <4AB90A99.6040008@e-teleport.net>
References: <20090922171716.GA2977@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.e-teleport.net ([213.190.64.162]:47000 "EHLO
	smtp.e-teleport.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZIVReR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2009 13:34:17 -0400
In-Reply-To: <20090922171716.GA2977@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu a =E9crit :
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
>  =20
>> crypto: padlock-sha - Fix stack alignment
>>
>> The PadLock hardware requires the output buffer for SHA to be
>> 128-bit aligned.  We currentply place the buffer on the stack,
>> and ask gcc to align it to 128 bits.  That doesn't work on i386
>> because the kernel stack is only aligned to 32 bits.  This patch
>> changes the code to align the buffer by hand so that the hardware
>> doesn't fault on unaligned buffers.
>>
>> Reported-by: S=E9guier R=E9gis <rguier@e-teleport.net>
>> Tested-by: S=E9guier R=E9gis <rguier@e-teleport.net>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>>    =20
>
> For the record I modified the patch slightly to ensure that
> we get the minimum alignment from gcc
Ok, tested, good for me.

Just, not important, my mail is not rguier@e-teleport.net but=20
rseguier@e-teleport.net for the changelog.

--=20
R=E9gis S=E9guier
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
