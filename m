From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: doc - clarify hash callbacks state machine
Date: Tue, 20 Mar 2018 10:29:45 +0000
Message-ID: <DBXPR04MB463D8753202F6587C526B1E98AB0@DBXPR04MB463.eurprd04.prod.outlook.com>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
 <CGME20180320075741epcas5p3a7c026ba8644e54478955afcb6091023@epcas5p3.samsung.com>
 <20180320075612.22719-1-horia.geanta@nxp.com>
 <d036a7ef-d900-4858-b821-05c50b2b739e@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3/20/2018 10:50 AM, Kamil Konieczny wrote:=0A=
> On 20.03.2018 08:56, Horia Geant=E3 wrote:=0A=
>> Add a note that it is perfectly legal to "abandon" a request object:=0A=
>> - call .init() and then (as many times) .update()=0A=
>> - _not_ call any of .final(), .finup() or .export() at any point in=0A=
>>   future=0A=
>>=0A=
>> Link: https://lkml.kernel.org/r/20180222114741.ga27...@gondor.apana.org.=
au=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> ---=0A=
>>  Documentation/crypto/devel-algos.rst | 8 ++++++++=0A=
>>  1 file changed, 8 insertions(+)=0A=
>>=0A=
>> diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto=
/devel-algos.rst=0A=
>> index 66f50d32dcec..c45c6f400dbd 100644=0A=
>> --- a/Documentation/crypto/devel-algos.rst=0A=
>> +++ b/Documentation/crypto/devel-algos.rst=0A=
>> @@ -236,6 +236,14 @@ when used from another part of the kernel.=0A=
>>                                 |=0A=
>>                                 '---------------> HASH2=0A=
>>  =0A=
>> +Note that it is perfectly legal to "abandon" a request object:=0A=
>> +- call .init() and then (as many times) .update()=0A=
>> +- _not_ call any of .final(), .finup() or .export() at any point in fut=
ure=0A=
>> +=0A=
>> +In other words implementations should mind the resource allocation and =
clean-up.=0A=
>> +No resources related to request objects should remain allocated after a=
 call=0A=
> -- ^^^^^^^^^^^^=0A=
>> +to .init() or .update(), since there might be no chance to free them.=
=0A=
> =0A=
> is it for crypto api  users or for drivers ?=0A=
> =0A=
For drivers / providers (below crypto API).=0A=
=0A=
> the creator of request context is responsible for alloc and destroy,=0A=
> so why there are no chance of free ?=0A=
> =0A=
Hash request object (including request context) is allocated by the user /=
=0A=
client by means of ahash_request_alloc(), and later on freed using=0A=
ahash_request_free().=0A=
I don't see a problem with this.=0A=
=0A=
However, besides the memory allocated for the request context, other resour=
ces=0A=
(related to the request) might be needed by the driver.=0A=
I provided an example of needing to DMA map a buffer (to load/store HW stat=
e=0A=
from/to crypto engine), and I am not happy with either solutions:=0A=
-DMA map & unmap after each .update()=0A=
-Herbert's proposal to use a convoluted DMA mapping scheme=0A=
=0A=
Another example: dynamic memory allocation might be needed beyond what's=0A=
available in request context, i.e. driver might not have apriori all the=0A=
information needed to inform the tfm about required memory using=0A=
crypto_ahash_set_reqsize().=0A=
=0A=
This happens due to the semantics of the crypto API, which allows the user =
to=0A=
initialize a request object and drop it without getting a result (final or=
=0A=
partial hash).=0A=
I don't see what below use case is good for, maybe just for benchmarking:=
=0A=
req =3D ahash_request_alloc();=0A=
[...]=0A=
crypto_ahash_init(req);=0A=
crypto_ahash_update(req);=0A=
ahash_request_free(req);=0A=
=0A=
Horia=0A=
=0A=
