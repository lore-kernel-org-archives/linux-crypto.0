From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Fri, 20 Aug 2010 19:03:18 +0200
Message-ID: <4C6EB556.3050608@gmail.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <20100820135612.GC4053@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ted Ts'o <tytso@mit.edu>,
	=?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100820135612.GC4053@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/20/2010 03:56 PM, Ted Ts'o wrote:
> On Fri, Aug 20, 2010 at 10:45:43AM +0200, Miloslav Trma=C4=8D wrote:
>> Hello, following is a patchset providing an user-space interface to
>> the kernel crypto API.  It is based on the older, BSD-compatible,
>> implementation, but the user-space interface is different.
>=20
> What's the goal of exporting the kernel crypto routines to userspace,
> as opposed to just simply doing the crypto in userspace?=20

This was the goal of the original cryptodev OpenBSD API and the
subsequent linux port in http://home.gna.org/cryptodev-linux/. In
typical PCs it might even be slower to use such an accelerator in kerne=
l
space, but in embedded systems where the hardware version of AES might
be 100 times faster than the software it might make sense.

However the design goal of this API is to separate cryptographic
operations from the applications. That is applications in userspace can
use keys, but the keys cannot be extracted from them, so for example
code injection in the web server will not be able to extract the privat=
e
key of the web service. (this approach is also required for
certification of linux on certain fields as Miloslav described in the
first post).

The interface is designed in a way that it can be wrapped by a PKCS #11
module and used transparently by other crypto libraries
(openssl/nss/gnutls). TPM is quite limited in this respect and cannot
fulfill this goal.

> So I'm bit at a list what's the whole point of this patch series.
> Could you explain that in the documentation, please?  Especially for
> crypto, explaining when something should be used, what the threat
> model is, etc., is often very important.

A detailed document describing this framework, threats and model is on
its way.


best regards,
Nikos
