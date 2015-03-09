From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue handling
Date: Mon, 9 Mar 2015 14:08:27 +0200
Message-ID: <54FD8D3B.5040409@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
 <1425388897-5434-6-git-send-email-mort@bork.org>
 <20150303182332.546523088b5891a776880c0f@freescale.com>
 <54F8235B.5080301@freescale.com> <20150306044821.GA1411@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kim Phillips <kim.phillips@freescale.com>,
	Martin Hicks <mort@bork.org>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0134.outbound.protection.outlook.com ([65.55.169.134]:18249
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751689AbbCIMIk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 08:08:40 -0400
In-Reply-To: <20150306044821.GA1411@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/6/2015 6:48 AM, Herbert Xu wrote:
> On Thu, Mar 05, 2015 at 11:35:23AM +0200, Horia Geant=C4=83 wrote:
>>
>>> Only potential problem is getting the crypto API to set the GFP_DMA
>>> flag in the allocation request, but presumably a
>>> CRYPTO_TFM_REQ_DMA crt_flag can be made to handle that.
>>
>> Right. And this flag would apply only to request __ctx[].
>>
>> Herbert, would this be an acceptable addition to crypto API?
>=20
> How would such a flag work?

Hm, I thought that GFP_DMA memory could be allocated only for request
private ctx. This is obviously not the case.

*_request_alloc(tfm, gfp) crypto API functions would do:
if (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_DMA)
        gfp |=3D GFP_DMA;

Thanks,
Horia
