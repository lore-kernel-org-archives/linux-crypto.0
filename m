From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Tue, 26 May 2015 11:45:11 +0200
Message-ID: <20150526094511.GP8557@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>
 <20150513091733.GW10961@lukather>
 <CAPcyv4jv=xWHbrO=rKhnWt9zFn8vkhS2J5mJiCBKKwESdUk5tg@mail.gmail.com>
 <20150518091454.GP4004@lukather>
 <CAPcyv4jbW=B_mYfx5HfKckLYeWctfC-9jYeDf0Z1APvQZfHj6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0084999847470095171=="
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
 Jason Cooper <jason@lakedaemon.net>, Vinod Koul <vinod.koul@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
 linux-crypto@vger.kernel.org,
 Gregory Clement <gregory.clement@free-electrons.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Thomas Petazzoni <thomas@free-electrons.com>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAPcyv4jbW=B_mYfx5HfKckLYeWctfC-9jYeDf0Z1APvQZfHj6Q@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org


--===============0084999847470095171==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHJAUhyIZkPvF01C"
Content-Disposition: inline


--nHJAUhyIZkPvF01C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2015 at 10:06:55AM -0700, Dan Williams wrote:
> On Mon, May 18, 2015 at 2:14 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi Dan,
> >
> > On Wed, May 13, 2015 at 09:00:46AM -0700, Dan Williams wrote:
> >> On Wed, May 13, 2015 at 2:17 AM, Maxime Ripard
> >> <maxime.ripard@free-electrons.com> wrote:
> >> > Hi Dan,
> >> >
> >> > On Tue, May 12, 2015 at 09:05:41AM -0700, Dan Williams wrote:
> >> >> On Tue, May 12, 2015 at 8:37 AM, Maxime Ripard
> >> >> <maxime.ripard@free-electrons.com> wrote:
> >> >> > Hi,
> >> >> >
> >> >> > This serie refactors the mv_xor in order to support the latest Ar=
mada
> >> >> > 38x features, including the PQ support in order to offload the RA=
ID6
> >> >> > PQ operations.
> >> >> >
> >> >> > Not all the PQ operations are supported by the XOR engine, so we =
had
> >> >> > to introduce new async_tx flags in the process to identify
> >> >> > un-supported operations.
> >> >> >
> >> >> > Please note that this is currently not usable because of a possib=
le
> >> >> > regression in the RAID stack in 4.1 that is being discussed at the
> >> >> > moment here: https://lkml.org/lkml/2015/5/7/527
> >> >>
> >> >> This is problematic as async_tx is a wart on the dmaengine subsystem
> >> >> and needs to be deprecated, I just have yet to find the time to do
> >> >> that work.  It turns out it was a mistake to hide the device details
> >> >> from md, it should be explicitly managing the dma channels, not
> >> >> relying on a abstraction api.  The async_tx api usage of the
> >> >> dma-mapping api is broken in that it relies on overlapping mappings=
 of
> >> >> the same address.  This happens to work on x86, but on arm it needs
> >> >> explicit non-overlapping mappings.  I started the work to reference
> >> >> count dma-mappings in 3.13, and we need to teach md to use
> >> >> dmaengine_unmap_data explicitly.  Yielding dma channel management to
> >> >> md also results in a more efficient implementation as we can dma_ma=
p()
> >> >> the stripe cache once rather than per-io.  The  "async_tx_ack()"
> >> >> disaster can also go away when md is explicitly handling channel
> >> >> switching.
> >> >
> >> > Even though I'd be very much in favor of deprecating / removing
> >> > async_tx, is it something likely to happen soon?
> >>
> >> Not unless someone else takes it on, I'm actively asking for help.
> >>
> >> > I remember discussing this with Vinod at Plumbers back in October, b=
ut
> >> > haven't seen anything since then.
> >>
> >> Right, "help!" :)
> >>
> >> > If not, I think that we shouldn't really hold back patches to
> >> > async_tx, even though we know than in a year from now, it's going to
> >> > be gone.
> >>
> >> We definitely should block new usages, because they make a bad
> >> situation worse.  Russell already warned that the dma_mapping api
> >> abuse could lead to data corruption on ARM (speculative pre-fetching).
> >> We need to mark ASYNC_TX_DMA as "depends on !ARM" or even "depends on
> >> BROKEN" until we can get this resolved.
> >
> > I'm not sure what the issues exactly are with async_tx and ARM, but
> > these patches have been tested on ARM and are working quite well.
>=20
> https://lkml.org/lkml/2011/7/8/363
>=20
> > What I'm doing here is merely using the existing API, I'm not making
> > it worse, just using the API that is used by numerous drivers
> > already. So I'm not sure this is really reasonable to ask for such a
> > huge rework (with a huge potential of regressions) before merging my
> > patches.
>=20
> It happens.
>=20
> https://lwn.net/Articles/641443/

It really depends on what you mean by "help". If you mean "undertake
all by yourself the removal of async tx", then no, sorry, I won't,
especially when you ask to do that for a patch that just enables a
feature of an API already used on that platform.

If you mean, "give me a hand, you can start there", then yeah, I can
do that.

> I'm not happy about not having had the time to do this rework myself.
> Linux is better off with this api deprecated.

You're not talking about deprecating it, you're talking about removing
it entirely.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--nHJAUhyIZkPvF01C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVZECnAAoJEBx+YmzsjxAgh/AQAJkwNybCosWJw8C2lYdP0T/P
CqwZDTyO0UNMIkweYf7NIacRpCZ4xzBH4rZDhk507JgeHnKK5ACicEB3Gesgk6Nm
ix5OfskFGspfaCspcOZ6ZS24kZ0gKSDI0ursx9gmkDcCnlZC21BFnbO8gebLHmxH
19HsY0HgA921VjMgxDNZu8g+hVDlMFlaTVfPZeI083pzFkjDj4dWwHrhmoBC/8ie
VR8CYq6O7yKmYazAeoopEJbVE/jtJDE8VdqcQsfLHTK+pmPN82u0v0vX5WjvRkkw
LHbHwC7jzQ5PlkdYEI/oDmIgVf9seDA+9QsBYchqDdpvC//OfHMVaysSrbDRNoEj
EbRquJjkAtq+2is4E4UGF+c4gu1Q98/wMV6yNU5Pid2IVJU9w+IJBFyRAft8d5Ak
iNz76CgaKVkEqc9s6I0rxvIdM/f8dmPlg5C2e+fiRpKa2lWwjmgLIOWVEkCK8UxL
TrOW7L9f8/gm0uQVrm0kjMfpyFLVk2kfxXj3iNxqFC5wqEV9xIxb4rAhnLCu55JA
LucYVukVG79WSA1VV9JyNDXblDU8XZDWCTnG9NM7qkOVWZ3NLJDae0n+MTNthcl0
Tao+1h5A+bN4SG5aqeo3xmfbxKPTasbzDJPHmhyhPrvQUN0aZnSlVY2rv3qE23+K
K5rTCl4kHTAvm/GhMnOc
=1f72
-----END PGP SIGNATURE-----

--nHJAUhyIZkPvF01C--


--===============0084999847470095171==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============0084999847470095171==--
