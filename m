From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 0/2] crypto: Introduce Public Key Encryption API
Date: Mon, 04 May 2015 13:42:11 -0700
Message-ID: <5547D9A3.9060800@intel.com>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1> <55477111.2050803@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: corbet@lwn.net, keescook@chromium.org, qat-linux@intel.com,
	jwboyer@redhat.com, richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com,
	dhowells@redhat.com, vgoyal@redhat.com, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	jdelvare@suse.de, linux-crypto@vger.kernel.org
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
	herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55477111.2050803@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Horia,
On 05/04/2015 06:16 AM, Horia Geant=C4=83 wrote:
>> 	int (*sign)(struct pke_request *pkereq);
>> > 	int (*verify)(struct pke_request *pkereq);
>> > 	int (*encrypt)(struct pke_request *pkereq);
>> > 	int (*decrypt)(struct pke_request *pkereq);
> Where would be the proper place for keygen operation?

This will need to be extended to support keygen.

>=20
> AFAICT algorithms currently map to primitives + encoding methods, whi=
ch
> is not flexible. For e.g. current RSA implementation hardcodes the
> PKCS1-v1_5 encoding method, making it hard to add OAEP(+) etc.
>=20
> One solution would be to map algorithms to primitives only. Encoding
> methods need to be abstracted somehow, maybe using templates to wrap =
the
> algorithms.

So far there is only one rsa implementation in kernel and it is only us=
ed
by module signing code.
Later we can add templates or simply one can register "oaep-rsa" algori=
thm.
