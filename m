From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is
 seeded before use
Date: Sun, 25 Jun 2017 18:23:09 -0700
Message-ID: <1498440189.26123.85.camel@haakon3.risingtidesystems.com>
References: <20170606174804.31124-1-Jason@zx2c4.com>
	 <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
	 <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
	 <2639082.PtrrGWOPPL@positron.chronox.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, "Jason A. Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>,
 Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linux Crypto Mailing List
 <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Greg Kroah-Hartman
 <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric
 Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <open-iscsi+bncBDAIFWGVYMJRB76DYHFAKGQEDO6ZAZI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <2639082.PtrrGWOPPL-jJGQKZiSfeo1haGO/jJMPxvVK+yQ3ZXh@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hi Stephan, Lee & Jason,

(Adding target-devel CC')

Apologies for coming late to the discussion.  Comments below.

On Sun, 2017-06-18 at 10:04 +0200, Stephan M=C3=BCller wrote:
> Am Samstag, 17. Juni 2017, 05:45:57 CEST schrieb Lee Duncan:
>=20
> Hi Lee,
>=20
> > In your testing, how long might a process have to wait? Are we talking
> > seconds? Longer? What about timeouts?
> >
>=20
> In current kernels (starting with 4.8) this timeout should clear within a=
 few=20
> seconds after boot.
>=20
> In older kernels (pre 4.8), my KVM takes up to 90 seconds to reach that=
=20
> seeding point. I have heard that on IBM System Z this trigger point requi=
res=20
> minutes to be reached.
>=20

I share the same concern as Lee wrt to introducing latency into the
existing iscsi-target login sequence.

Namely in the use-cases where a single node is supporting ~1K unique
iscsi-target IQNs, and fail-over + re-balancing of IQNs where 100s of
login attempts are expected to occur in parallel.

If environments exist that require non trivial amounts of time for RNG
seeding to be ready for iscsi-target usage, then enforcing this
requirement at iscsi login time can open up problems, especially when
iscsi host environments may be sensitive to login timeouts, I/O
timeouts, et al.

That said, I'd prefer to simply wait for RNG to be seeded at modprobe
iscsi_target_mod time, instead of trying to enforce randomness during
login.

This way, those of use who have distributed storage platforms can know
to avoid putting a node into a state to accept iscsi-target IQN export
migration, before modprobe iscsi_target_mod has successfully loaded and
RNG seeding has been confirmed.

WDYT..?

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
