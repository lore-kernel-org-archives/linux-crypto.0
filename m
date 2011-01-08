From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Crypto Update for 2.6.38
Date: Sat, 8 Jan 2011 15:23:04 +0200
Message-ID: <AANLkTi=wLQNF2p3v_-2F9hLobVVqQTOQB8F76a=fSoLW@mail.gmail.com>
References: <20100519020603.GA19654@gondor.apana.org.au>
	<20100521104404.GA29530@gondor.apana.org.au>
	<20100804140448.GA4042@gondor.apana.org.au>
	<20101024061625.GA23715@gondor.apana.org.au>
	<20110106000157.GA16089@gondor.apana.org.au>
	<AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
	<20110106211645.GA26184@gondor.apana.org.au>
	<AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
	<20110106213932.GA26538@gondor.apana.org.au>
	<AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
	<20110107120451.GA22347@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110107120451.GA22347@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 7, 2011 at 2:04 PM, Neil Horman <nhorman@tuxdriver.com> wro=
te:

>> Btw, it doesn't have to be about performance per se. Does this allow
>> people to use keys without actually _seeing_ those keys? Your exampl=
e
>> implies that that is not the case, but that's actually one of the fe=
w
>> reasons to actually support a kernel crypto interface - the ability =
to
>> have private personal keys around, but not having to actually let
>> possibly untrusted programs see them.
> This actually is an indirect feature of this interface. =C2=A0Using i=
t, you can open
> a algorithm socket, select a specific alg, assign a key, and then pas=
s that
> socket descriptor over a unix socket to an another process using an
> SCM_RIGHTS ancilliary message. =C2=A0The receiving process can then u=
se children
> acceppted from that passed socket to preform the configured crypto op=
eration
> without any knoweldge of the keys used in it. =C2=A0I can write a dem=
o app if you
> like.

Several things have to be considered when extending an interface like
that. For example, do the algorithm implementations protect against
timing attacks, or keys can be recovered, using them? What is the
purpose of cryptographic key separation? If long term keys are to be
protected, then it makes sense to support RSA, DSA keys in addition to
symmetric keys (e.g. microsoft only supports assymetric keys for
separation, since symmetric ones are rarely used as long term keys -
[in TLS-PSK]).

Some of these issues are discussed in my report on a user-space crypto
interface that specifically targeted separation and speed at [0].

regards,
Nikos

[0]. https://www.cosic.esat.kuleuven.be/publications/article-1490.pdf
