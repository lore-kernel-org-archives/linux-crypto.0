From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH 0/2] crypto: talitos - fix conversion to new AEAD
 interface
Date: Wed, 20 Apr 2016 11:29:52 +0000
Message-ID: <AM2PR04MB0673AF5B5E96C253102C7DC6986D0@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
 <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
 <20160420095838.GB3003@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Jonas Eymann" <J.Eymann@gmx.net>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0074.outbound.protection.outlook.com ([157.56.112.74]:61952
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752158AbcDTL3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 07:29:55 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/20/2016 12:58 PM, Herbert Xu wrote:
> On Tue, Apr 19, 2016 at 08:33:46PM +0300, Horia Geant=E3 wrote:
>> Jonas Eymann reports a crash and some failures of AED algorithms
>> with kernel 4.4.6, all easily reproducible with tcrypt.
>>
>> These have to do with the onversion to the new AEAD interface:
>> aeb4c132f33d crypto: talitos - Convert to new AEAD interface
>>
>> Problems occur for 4.3+ kernels, sending patches to -stable.
>>
>> (*) Proper fix for hash algorithms registration failures
>> (implementation of import/export functionality) will be added separa=
tely.
>=20
> Both applied.  Thanks!
>=20
Thanks Herbert.

Shouldn't these have been included in the recent "Crypto Update for 4.6=
"
pull request?

Horia
