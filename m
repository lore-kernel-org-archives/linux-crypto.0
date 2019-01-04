Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:24291
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726797AbfADPYu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 10:24:50 -0500
From: Horia Geanta <horia.geanta@nxp.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v3] crypto: talitos - fix ablkcipher for CONFIG_VMAP_STACK
Date: Fri, 4 Jan 2019 15:24:44 +0000
Message-ID: <VI1PR0402MB34853754B8F90F5904710526988E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <ae7b64e9415874060977e32ed48b62f1f6148084.1545346337.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3485FC2A3758BCEAC05BF3A2988E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/4/2019 5:17 PM, Horia Geanta wrote:=0A=
> On 12/21/2018 10:07 AM, Christophe Leroy wrote:=0A=
> [snip]=0A=
>> IV cannot be on stack when CONFIG_VMAP_STACK is selected because the sta=
ck=0A=
>> cannot be DMA mapped anymore.=0A=
>> This looks better, thanks.=0A=
> =0A=
>> This patch copies the IV into the extended descriptor when iv is not=0A=
>> a valid linear address.=0A=
>>=0A=
> Though I am not sure the checks in place are enough.=0A=
> =0A=
>> Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")=0A=
>> Cc: stable@vger.kernel.org=0A=
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
>> ---=0A=
>>  v3: Using struct edesc buffer.=0A=
>>=0A=
>>  v2: Using per-request context.=0A=
> [snip]=0A=
>> +	if (ivsize && !virt_addr_valid(iv))=0A=
>> +		alloc_len +=3D ivsize;=0A=
> [snip]=0A=
>>  =0A=
>> +	if (ivsize && !virt_addr_valid(iv))=0A=
> A more precise condition would be (!is_vmalloc_addr || is_vmalloc_addr(iv=
))=0A=
>=0A=
Sorry for the typo, I meant:=0A=
(!virt_addr_valid(iv) || is_vmalloc_addr(iv))=0A=
=0A=
> It matches the checks in debug_dma_map_single() helper, though I am not s=
ure=0A=
> they are enough to rule out all exceptions of DMA API.=0A=
