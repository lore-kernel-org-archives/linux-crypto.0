From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix rfc4106 encap shared descriptor
Date: Thu, 30 Jul 2015 18:31:40 +0300
Message-ID: <55BA435C.1000803@freescale.com>
References: <1438263566-22222-1-git-send-email-horia.geanta@freescale.com>
 <20150730134618.GA17539@gondor.apana.org.au> <55BA2DA5.8000807@freescale.com>
 <20150730140318.GA17848@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:48736
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751485AbbG3Pbs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 11:31:48 -0400
In-Reply-To: <20150730140318.GA17848@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/30/2015 5:03 PM, Herbert Xu wrote:
> On Thu, Jul 30, 2015 at 04:59:01PM +0300, Horia Geant=C4=83 wrote:
>>
>> Indeed, there is:
>> A-005473 - Using SEQ FIFO LOAD SKIP and SEQ FIFO STORE SKIP
>> simultaneously will cause the DECO to hang.
>>
>> However, the skip commands are not consecutive, there's a math comma=
nd
>> between them (both for encap and decap descriptors).
>=20
> Cool, I didn't know that inserting a math command could also
> work around the hang.

We double checked this with the HW design team.
While tests pass, we're not safe with the approach, since the issue is
timing sensible and depends on S/G tables format, whether they are
previously fetched etc.

I'll send a v2 shortly, using the proposed erratum workaround.

Thanks,
Horia
