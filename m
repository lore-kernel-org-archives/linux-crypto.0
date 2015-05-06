From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH RFC 0/2] crypto: Introduce Public Key Encryption API
Date: Wed, 6 May 2015 14:31:32 +0300
Message-ID: <5549FB94.6020601@freescale.com>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1>
 <55477111.2050803@freescale.com> <5547D9A3.9060800@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <corbet@lwn.net>, <keescook@chromium.org>, <qat-linux@intel.com>,
	<jwboyer@redhat.com>, <richard@nod.at>, <d.kasatkin@samsung.com>,
	<linux-kernel@vger.kernel.org>, <steved@redhat.com>,
	<dhowells@redhat.com>, <vgoyal@redhat.com>,
	<james.l.morris@oracle.com>, <jkosina@suse.cz>,
	<zohar@linux.vnet.ibm.com>, <davem@davemloft.net>,
	<jdelvare@suse.de>, <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0112.outbound.protection.outlook.com ([65.55.169.112]:21024
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbbEFLbp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 07:31:45 -0400
In-Reply-To: <5547D9A3.9060800@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/4/2015 11:42 PM, Tadeusz Struk wrote:
> Hi Horia,
> On 05/04/2015 06:16 AM, Horia Geant=C4=83 wrote:
>>> 	int (*sign)(struct pke_request *pkereq);
>>>> 	int (*verify)(struct pke_request *pkereq);
>>>> 	int (*encrypt)(struct pke_request *pkereq);
>>>> 	int (*decrypt)(struct pke_request *pkereq);
>> Where would be the proper place for keygen operation?
>=20
> This will need to be extended to support keygen.
>=20
>>
>> AFAICT algorithms currently map to primitives + encoding methods, wh=
ich
>> is not flexible. For e.g. current RSA implementation hardcodes the
>> PKCS1-v1_5 encoding method, making it hard to add OAEP(+) etc.
>>
>> One solution would be to map algorithms to primitives only. Encoding
>> methods need to be abstracted somehow, maybe using templates to wrap=
 the
>> algorithms.
>=20
> So far there is only one rsa implementation in kernel and it is only =
used
> by module signing code.
> Later we can add templates or simply one can register "oaep-rsa" algo=
rithm.

I am thinking that it would be more logical for "rsa" to represent only
the *primitives*, for e.g. RSASP1, RSAVP1, RSAEP, RSADP (in rfc3447
terminology).

Then pkcs1_v15(rsa), oaep(rsa), pss(rsa) (i.e. RSAES-PKCS1-v1_5,
RSAES-OAEP, RSASSA-PSS encryption and/or signature schemes) would share
the primitives implementation, the only thing that would differ being
the encoding/padding method.

This is similar to symmetric ciphers convention of having the mode
defined as a wrapper: we have cbc(aes), ctr(aes), gcm(aes) and not
cbc-aes, ctr-aes, gcm-aes.

Another thing to consider is that there might be crypto engines which
are able to perform only "textbook" rsa. This would allow for the
primitives to be offloaded, while the encoding methods would be
performed in SW.

Thanks,
Horia
