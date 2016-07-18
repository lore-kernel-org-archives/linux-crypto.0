From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Mon, 18 Jul 2016 15:12:31 -0700
Message-ID: <1468879951.9191.100.camel@linux.intel.com>
References: <20160629144242.GE22818@mwanda>
	 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
	 <1467319339.22178.256.camel@linux.intel.com>
	 <20160701075559.GA11902@gmail.com>
	 <20160701092806.GA13424@gondor.apana.org.au>
	 <20160701101329.GA3833@gmail.com> <20160708162803.GA29111@linux.intel.com>
	 <20160708164502.GA3064@gondor.apana.org.au>
	 <CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com>
	 <20160718085905.GA5701@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Machek <pavel@ucw.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160718085905.GA5701@amd>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2016-07-18 at 10:59 +0200, Pavel Machek wrote:
> On Fri 2016-07-08 10:19:26, Linus Torvalds wrote:
> >=20
> > [ rare comment rant. I think I'll do this once, and then ignore the=
 discussion ]
> >=20
> > On Fri, Jul 8, 2016 at 9:45 AM, Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
> > >=20
> > >=20
> > > Nack.=C2=A0=C2=A0As I said the commenting style in the crypto API=
 is the
> > > same as the network stack.=C2=A0=C2=A0So unless we decide to chan=
ge both
> > > please stick to the current style.
> > Can we please get rid of the brain-damaged stupid networking commen=
t
> > syntax style, PLEASE?
> Please? :-). Having different comment styles between networking and
> the rest is confusing.
>=20
> And yes, this uglyness is documented for net/ and drivers/net/, but
> not for crypto/, so at the very least Documentation/CodingStyle shoul=
d
> be updated.
>=20
> 									Pavel

The cleanup patch has already been merged. =C2=A0Thanks.

Tim
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
