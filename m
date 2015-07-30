From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix rfc4106 encap shared descriptor
Date: Thu, 30 Jul 2015 16:59:01 +0300
Message-ID: <55BA2DA5.8000807@freescale.com>
References: <1438263566-22222-1-git-send-email-horia.geanta@freescale.com>
 <20150730134618.GA17539@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0112.outbound.protection.outlook.com ([65.55.169.112]:60192
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752308AbbG3OOV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 10:14:21 -0400
In-Reply-To: <20150730134618.GA17539@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/30/2015 4:46 PM, Herbert Xu wrote:
> On Thu, Jul 30, 2015 at 04:39:26PM +0300, Horia Geant=C4=83 wrote:
>> The encap shared descriptor was changed to use the new IV convention=
=2E
>> In the process some commands were shifted, making the output length
>> zero, caam effectively writing garbage in dst.
>=20
> Thanks.
>=20
>> While here, update the decap descriptor to execute the "write" comma=
nds
>> before the "read"s (as it previously was).
>> This makes sure the input fifo is drained before becoming full.
>=20
> Actually, I deliberately did it that way because there was an errata
> which said that doing a skipping load concurrently with a skipping
> store may cause a hang.  Is this not the case?
>=20
Indeed, there is:
A-005473 - Using SEQ FIFO LOAD SKIP and SEQ FIFO STORE SKIP
simultaneously will cause the DECO to hang.

However, the skip commands are not consecutive, there's a math command
between them (both for encap and decap descriptors).

Horia
