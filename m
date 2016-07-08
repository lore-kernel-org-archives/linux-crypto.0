From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Fri, 08 Jul 2016 10:17:32 -0700
Message-ID: <1467998252.9191.8.camel@linux.intel.com>
References: <20160629144242.GE22818@mwanda>
	 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
	 <1467319339.22178.256.camel@linux.intel.com>
	 <20160701075559.GA11902@gmail.com>
	 <20160701092806.GA13424@gondor.apana.org.au>
	 <20160701101329.GA3833@gmail.com> <20160708162803.GA29111@linux.intel.com>
	 <20160708164502.GA3064@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21195 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbcGHRR5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2016 13:17:57 -0400
In-Reply-To: <20160708164502.GA3064@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2016-07-09 at 00:45 +0800, Herbert Xu wrote:
> On Fri, Jul 08, 2016 at 09:28:03AM -0700, Tim Chen wrote:
> >=20
> >=20
> > Sorry I was on vacation and didn't get to respond earlier.
> > Let's switch the above from | to || so the code logic is
> > clearer.=C2=A0=C2=A0Also clean up various multi-line comment style
> > inconsistencies in patch below.
> Nack.=C2=A0=C2=A0As I said the commenting style in the crypto API is =
the
> same as the network stack.=C2=A0=C2=A0So unless we decide to change b=
oth
> please stick to the current style.
>=20

Will you like a patch with just the | to || change, or leave
the code as is?

Tim
