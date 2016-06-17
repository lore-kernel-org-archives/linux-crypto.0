From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Fri, 17 Jun 2016 11:26:23 -0400
Message-ID: <CACXcFm=ysn15Lh9Exeo8nKEAuBoZ7pB3eDesL_P_Ne3Kaxcunw@mail.gmail.com>
References: <1466007463.20087.11.camel@redhat.com> <6137456.oZ1CFC9kFY@positron.chronox.de>
 <1466171773.20087.66.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephan Mueller <smueller@chronox.de>,
	Andi Kleen <andi@firstfloor.org>,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?David_Ja=C5=A1a?= <djasa@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466171773.20087.66.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Ja=C5=A1a <djasa@redhat.com> wrote:

>
> BTW when looking at an old BSI's issue with Linux urandom that Jarod
> Wilson tried to solve with this series:
> https://www.spinics.net/lists/linux-crypto/msg06113.html
> I was thinking:
> 1) wouldn't it help for large urandom consumers if kernel created a D=
RBG
> instance for each of them? It would likely enhance performance and so=
lve
> BSI's concern of predicting what numbers could other urandom consumer=
s
> obtain at cost of memory footprint
> and then, after reading paper associated with this series:
> 2) did you evaluate use of intermediate DRBG fed by primary generator=
 to
> instantiate per-node DRBG's? It would allow initialization of all
> secondary DRBGs right after primary generator initialization.

Theodore Ts'o, the random maintainer, already has a patch that
seems to deal with this issue. He has posted more than one
version & I'm not sure this is the best or latest, but ...
https://lkml.org/lkml/2016/5/30/22
