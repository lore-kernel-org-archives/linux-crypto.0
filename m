From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: Asymmetric cryptography HW offloading
Date: Fri, 27 Sep 2013 13:58:23 +0300
Message-ID: <524564CF.6030508@freescale.com>
References: <524034A1.70204@freescale.com> <524041EE.5070209@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Yashpal Dutta <yashpal.dutta@freescale.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:29867
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab3I0K6m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Sep 2013 06:58:42 -0400
In-Reply-To: <524041EE.5070209@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/23/2013 4:28 PM, Nikos Mavrogiannopoulos wrote:
> On 09/23/2013 02:31 PM, Horia Geant=C4=83 wrote:
>> Hi,
>>
>> CAAM crypto engine (drivers/crypto/caam/*) is capable of asymmetric
>> operations, like: modular exponentiation, RSA
>> sign/verify/encrypt/decrypt, (EC)DSA sign etc.
>> I would appreciate some design guidelines on how to harness these
>> capabilities, for crypto engines in general.
>>
>> 1. In-kernel interface for asymmetric crypto
>> Should crypto/asymmetric_keys/* be used, i.e. appended with modular
>> exponentiation, other asymmetric operations?
> The BSD's cryptodev supports the following operations which may help =
in
> that aspect (no elliptic curve operations present). I don't know if a=
ll
> of them worth the context switch.
>
> #define CRK_MOD_EXP		0
> #define CRK_MOD_EXP_CRT		1
> #define CRK_DSA_SIGN		2
> #define CRK_DSA_VERIFY		3
> #define CRK_DH_COMPUTE_KEY	4
> #define CRK_MOD_ADD		5
> #define CRK_MOD_ADDINV		6
> #define CRK_MOD_SUB		7
> #define CRK_MOD_MULT		8
> #define CRK_MOD_MULTINV		9
> #define CRK_MOD			10

Thanks for the tip.
I took a look at BSD - AFAICT there is no SW implementation and crypto=20
engine drivers handle only the first two operations (MOD_EXP).

My main concern now is the asymmetric ciphers API, that would eventuall=
y=20
allow implementing the operations in SW/HW.
I was wondering whether the same logic as for symmetric ciphers=20
could/should be used (the API layering mentioned in=20
Documentation/crypto/api-intro.txt).
=46or example, crypto/asymmetric_keys/rsa.c could be registered and the=
n=20
used via Crypto API:
rsa.c: crypto_alg->cra_name =3D "rsa";=20
crypto_alg->cra_driver_name=3D"rsa-generic"; crypto_register_alg(crypto=
_alg);
user: tfm =3D crypto_alloc_tfm("rsa",...);
User would get either the "rsa-generic" SW implementation or a HW=20
implementation, if available.

>
>> 2. User space interface
>> Should AF_ALG be expanded to provide access to this new asymmetric c=
ypto
>> API? The API would allow user space applications to offload PKC oper=
ations in
>> HW.
> I'd be interested into adding this support into cryptodev-linux once
> present in kernel.

Thanks.
We already have a draft implementation of asymmetric crypto +=20
cryptodev-linux, but was developed prior to crypto/asymmetric_keys=20
addition and thus has to be reworked.

Horia
