From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 00/18] crypto: talitos - fixes and performance improvement
Date: Fri, 8 Dec 2017 15:20:40 +0000
Message-ID: <VI1PR0402MB3342A19DE16BEEB714DAA98A98300@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <20171012151959.GI31122@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0075.outbound.protection.outlook.com ([104.47.2.75]:2880
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753656AbdLHPUn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Dec 2017 10:20:43 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/12/2017 6:20 PM, Herbert Xu wrote:=0A=
> On Fri, Oct 06, 2017 at 03:04:31PM +0200, Christophe Leroy wrote:=0A=
>> This serie fixes and improves the talitos crypto driver.=0A=
>>=0A=
>> First 6 patchs are fixes of failures reported by the new tests in the=0A=
>> kernel crypto test manager.=0A=
>>=0A=
Looks like these fixes are required also on older 4.9+ -stable kernels.=0A=
(I haven't seen them on latest 4.9.68-stable mail from Greg, even though=0A=
they are in main tree.)=0A=
=0A=
In case you agree, what would be the recommended way to add the patches=0A=
to -stable?=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
>> The 8 following patches are cleanups and simplifications.=0A=
>>=0A=
>> The last 4 ones are performance improvement. The main improvement is=0A=
>> in the one before the last, it divides by 2 the time needed for a md5=0A=
>> hash on the SEC1.=0A=
>>=0A=
>> Christophe Leroy (18):=0A=
>>   crypto: talitos - fix AEAD test failures=0A=
>>   crypto: talitos - fix memory corruption on SEC2=0A=
>>   crypto: talitos - fix setkey to check key weakness=0A=
>>   crypto: talitos - fix AEAD for sha224 on non sha224 capable chips=0A=
>>   crypto: talitos - fix use of sg_link_tbl_len=0A=
>>   crypto: talitos - fix ctr-aes-talitos=0A=
>>   crypto: talitos - zeroize the descriptor with memset()=0A=
>>   crypto: talitos - declare local functions static=0A=
>>   crypto: talitos - use devm_kmalloc()=0A=
>>   crypto: talitos - use of_property_read_u32()=0A=
>>   crypto: talitos - use devm_ioremap()=0A=
>>   crypto: talitos - don't check the number of channels at each interrupt=
=0A=
>>   crypto: talitos - remove to_talitos_ptr_len()=0A=
>>   crypto: talitos - simplify tests in ipsec_esp()=0A=
>>   crypto: talitos - DMA map key in setkey()=0A=
>>   crypto: talitos - do hw_context DMA mapping outside the requests=0A=
>>   crypto: talitos - chain in buffered data for ahash on SEC1=0A=
>>   crypto: talitos - avoid useless copy=0A=
> =0A=
> All applied.  Thanks.=0A=
> =0A=
