From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Sat, 18 Jun 2016 10:21:16 +0200
Message-ID: <1883152.WnWCHsqf2W@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <6137456.oZ1CFC9kFY@positron.chronox.de> <1466171773.20087.66.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466171773.20087.66.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 17. Juni 2016, 15:56:13 schrieb David Ja=C5=A1a:

Hi David,

> Hi Stephan,
>=20
> thank you for your thorough reply,
>=20
> On St, 2016-06-15 at 18:58 +0200, Stephan Mueller wrote:
> > Am Mittwoch, 15. Juni 2016, 18:17:43 schrieb David Ja=C5=A1a:
> >=20
> > Hi David,
> >=20
> > > Hello Stephan,
> > >=20
> > > Did you consider blocking urandom output or returning error until
> > > initialized? Given the speed of initialization you report, it sho=
uldn't
> > > break any userspace apps while making sure that nobody uses predi=
ctable
> > > pseudoranom numbers.
> >=20
> > My LRNG will definitely touch the beginning of the initramfs bootin=
g until
> > it is fully seeded. As these days the initramfs is driven by system=
d
> > which always pulls from /dev/urandom, we cannot block as this would=
 block
> > systemd. In Ted's last patch, he mentioned that he tried to make
> > /dev/urandom block which caused user space pain.
>=20
> I was thinking along the lines that "almost every important package
> supports FreeBSD as well where they have to handle the condition so
> option to switch to Rather Break Than Generate Weak Keys would be nic=
e"
> - but I didn't expect that systemd could be a roadblock here. :-/
>=20
> I was also thinking of little devices where OpenWRT or proprietary
> Linux-based systems run that ended up with predictable keys way too
> ofter (or as in OpenWRT's case, with cumbersome tutorials how to
> generate keys elsewhere).

I have some ideas on how to handle that issue -- let me run some tests =
and I=20
will report back.
>=20
> > But if you use the getrandom system call, it works like /dev/urando=
m but
> > blocks until the DRBG behind /dev/urandom is fully initialized.
> >=20
> > > I was considering asking for patch (or even trying to write it my=
self)
> > > to make current urandom block/fail when not initialized but that =
would
> > > surely have to be off by default over "never break userspace" rul=
e (even
> > > if it means way too easy security problem with both random and ur=
andom).
> > > Properties of your urandom implementation makes this point moot a=
nd it
> > > could make the random/urandom wars over.
> >=20
> > That patch unfortunately will not work. But if you are interested i=
n that
> > blocking /dev/urandom behavior for your application, use getrandom.
>=20
> I'm QA with a touch of sysadmin so the numbers of apps to fix is larg=
e
> and I don't have neither control over the projects nor abilities to
> patch them all myself. :)

Sure, I can understand that :-)
>=20
> > > Best Regards,
> > >=20
> > > David Ja=C5=A1a
> >=20
> > Ciao
> > Stephan
>=20
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

That issue is partly solved with my patch set: I have one DRBG per NUMA=
 node=20
where all DRBG instances are equally treated. Surely that patch could b=
e=20
expanded on a per-CPU instance. But let us try to use the per-NUMA=20
implementation and see whether that helps.

Besides, the legacy /dev/urandom delivers about 12 MB/s on my system wh=
ereas=20
the DRBG delivers more than 800MB/s. So, we have quite some performance=
=20
improvement.

Note, Ted's patch has a similar implementation.

> and then, after reading paper associated with this series:
> 2) did you evaluate use of intermediate DRBG fed by primary generator=
 to
> instantiate per-node DRBG's? It would allow initialization of all
> secondary DRBGs right after primary generator initialization.

That is exactly what I do.
>=20
> Cheers,
>=20
> David


Ciao
Stephan
