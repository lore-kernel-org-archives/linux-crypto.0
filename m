From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is seeded before use
Date: Mon, 26 Jun 2017 19:38:06 +0200
Message-ID: <1678474.GnYBdSlWgs@tauon.chronox.de>
References: <20170606174804.31124-1-Jason@zx2c4.com> <2639082.PtrrGWOPPL@positron.chronox.de> <1498440189.26123.85.camel@haakon3.risingtidesystems.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, "Jason A. Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linux Crypto Mailing List <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Return-path: <open-iscsi+bncBDZ7FLXFQ4ORBA4NYXFAKGQETHIAWVA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1498440189.26123.85.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Am Montag, 26. Juni 2017, 03:23:09 CEST schrieb Nicholas A. Bellinger:

Hi Nicholas,

> Hi Stephan, Lee & Jason,
>=20
> (Adding target-devel CC')
>=20
> Apologies for coming late to the discussion.  Comments below.
>=20
> On Sun, 2017-06-18 at 10:04 +0200, Stephan M=C3=BCller wrote:
> > Am Samstag, 17. Juni 2017, 05:45:57 CEST schrieb Lee Duncan:
> >=20
> > Hi Lee,
> >=20
> > > In your testing, how long might a process have to wait? Are we talkin=
g
> > > seconds? Longer? What about timeouts?
> >=20
> > In current kernels (starting with 4.8) this timeout should clear within=
 a
> > few seconds after boot.
> >=20
> > In older kernels (pre 4.8), my KVM takes up to 90 seconds to reach that
> > seeding point. I have heard that on IBM System Z this trigger point
> > requires minutes to be reached.
>=20
> I share the same concern as Lee wrt to introducing latency into the
> existing iscsi-target login sequence.
>=20
> Namely in the use-cases where a single node is supporting ~1K unique
> iscsi-target IQNs, and fail-over + re-balancing of IQNs where 100s of
> login attempts are expected to occur in parallel.
>=20
> If environments exist that require non trivial amounts of time for RNG
> seeding to be ready for iscsi-target usage, then enforcing this
> requirement at iscsi login time can open up problems, especially when
> iscsi host environments may be sensitive to login timeouts, I/O
> timeouts, et al.
>=20
> That said, I'd prefer to simply wait for RNG to be seeded at modprobe
> iscsi_target_mod time, instead of trying to enforce randomness during
> login.
>=20
> This way, those of use who have distributed storage platforms can know
> to avoid putting a node into a state to accept iscsi-target IQN export
> migration, before modprobe iscsi_target_mod has successfully loaded and
> RNG seeding has been confirmed.
>=20
> WDYT..?

We may have a chicken and egg problem when the wait is at the modprobe time=
.=20
Assume the modprobe happens during initramfs time to get access to the root=
=20
file system. In this case, you entire boot process will lock up for an=20
indefinite amount of time. The reason is that in order to obtain events=20
detected by the RNG, devices need to be initialized and working. Such devic=
es=20
commonly start working after the the root partition is mounted as it contai=
ns=20
all drivers, all configuration information etc.

Note, during the development of my /dev/random implementation, I added the=
=20
getrandom-like blocking behavior to /dev/urandom (which is the equivalent t=
o=20
Jason's patch except that it applies to user space). The boot process locke=
d=20
up since systemd wanted data from /dev/urandom while it processed the=20
initramfs. As it did not get any, the boot process did not commence that co=
uld=20
deliver new events to be picked up by the RNG.

As I do not have such an iscsi system, I cannot test Jason's patch. But may=
be=20
the mentioned chicken-and-egg problem I mentioned above is already visible=
=20
with the current patch as it will lead to a blocking of the mounting of the=
=20
root partition in case the root partition is on an iscsi target.

Ciao
Stephan

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
