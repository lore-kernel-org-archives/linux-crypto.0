From: Dan Streetman <ddstreet@us.ibm.com>
Subject: Re: [PATCH 6/6] nx-842-platform: if NX842 platform drivers are not
 modules, don't try to load them
Date: Wed, 15 Jul 2015 10:33:30 -0400
Message-ID: <CALZtONBSP+bf-Qp6VgiNOXoNErHYGzAz=T64yxbnxPCo-3x+pA@mail.gmail.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com> <20150702224225.GG1712@linux.vnet.ibm.com>
 <20150706081307.GA20616@gondor.apana.org.au> <20150706170740.GB3578@linux.vnet.ibm.com>
Reply-To: ddstreet@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	gustavold@linux.vnet.ibm.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33285 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbGOOdu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 10:33:50 -0400
Received: by ietj16 with SMTP id j16so34851043iet.0
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2015 07:33:49 -0700 (PDT)
In-Reply-To: <20150706170740.GB3578@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 6, 2015 at 1:07 PM, Nishanth Aravamudan
<nacc@linux.vnet.ibm.com> wrote:
> On 06.07.2015 [16:13:07 +0800], Herbert Xu wrote:
>> On Thu, Jul 02, 2015 at 03:42:26PM -0700, Nishanth Aravamudan wrote:
>> > Based off the CONFIG_SPU_FS_MODULE code, only attempt to load platform
>> > modules if the nx-842 pseries/powernv drivers are built as modules.
>> >
>> > Otherwise, if CONFIG_DEV_NX_COMPRESS=y,
>> > CONFIG_DEV_NX_COMPRESS_PSERIES=y, CONFIG_DEV_NX_POWERNV=y, the following
>> > message is emitted at boot:
>> >
>> > nx_compress: no nx842 driver found.
>> >
>> > even though the drivers successfully loads.
>> >
>> > This is because in the =y case, the module_init() calls get converted to
>> > initcalls and the nx842_init() runs before the platform driver
>> > nx842_pseries_init() or nx842_powernv_init() functions, which are what
>> > normally set the static platform driver.
>> >
>> > Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
>> > Cc: Dan Streetman <ddstreet@us.ibm.com>
>> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: linux-crypto@vger.kernel.org
>> > Cc: linuxppc-dev@lists.ozlabs.org
>>
>> Ugh, I think this whole thing is redundant.  The whole point of
>> the crypto API is to allow the coexistence of multiple underlying
>> implementations.
>
> Sure, that makes sense -- sorry, I was picking this up while Dan was on
> vacation. Will provide a better v2.
>
>> Please get rid of nx-842-platform.c completely and move the crypto
>> registration into the individual platform drivers.  That is, powernv
>> and pseries should each register their own crypto driver.  They can of
>> course share a common set of crypto code which can live in its own
>> module.  There should be no need for mucking with module reference
>> counts at all.
>
> Will do, thanks!

Yep, I originally did it this way because I didn't realize crypto
could register different drivers with the same alg name (but different
driver names).  I have some patches already to start doing this but
they weren't ready enough to send before I left for vacation; I'll
finish them up and send them.

>
> -Nish
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
