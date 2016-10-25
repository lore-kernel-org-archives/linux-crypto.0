From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] nvmem: sunxi-sid: SID content is not a valid source of
 randomness
Date: Tue, 25 Oct 2016 15:26:48 +0200
Message-ID: <20161025132648.txeo3rw6yz5wutrg@lukather>
References: <1477144408-15896-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161024201020.h6akyqad2o42xkhq@lukather>
 <20161025053855.GA901@Red>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2151382642327635458=="
Cc: wens@csie.org, srinivas.kandagatla@linaro.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161025053855.GA901@Red>
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


--===============2151382642327635458==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="l2m3ygi2en6ylpof"
Content-Disposition: inline


--l2m3ygi2en6ylpof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 25, 2016 at 07:38:55AM +0200, LABBE Corentin wrote:
> On Mon, Oct 24, 2016 at 10:10:20PM +0200, Maxime Ripard wrote:
> > On Sat, Oct 22, 2016 at 03:53:28PM +0200, Corentin Labbe wrote:
> > > Since SID's content is constant over reboot,
> >=20
> > That's not true, at least not across all the Allwinner SoCs, and
> > especially not on the A10 and A20 that this driver supports.
> >=20
>=20
> On my cubieboard2 (A20)
> hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eeprom/sunxi-sid0/=
nvmem=20
> 00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH=
=2E.ur|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
> *
> 00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH=
=2E.ur|
> 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
> *
> 00000200
> cubiedev ~ # reboot
> cubiedev ~ # hexdump -C /sys/devices/platform/soc\@01c00000/1c23800.eepro=
m/sunxi-sid0/nvmem=20
> 00000000  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH=
=2E.ur|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
> *
> 00000100  16 51 66 83 80 48 50 72  56 54 48 48 03 c2 75 72  |.Qf..HPrVTHH=
=2E.ur|
> 00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |............=
=2E...|
> *
> 00000200
>=20
> So clearly for me its constant.

It's constant across reboots, but not across devices. Each device have
a different SID content, therefore it's a relevant source of entropy
in the system.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--l2m3ygi2en6ylpof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYD12YAAoJEBx+YmzsjxAgE6wP/A5VE+Qy9Jt3/C5BMcwtqkk9
oxLNXOJCa3+aMMcpt696REILpxhfZ/b+PzQBv1R/wZ+Yt5gddknp9USgUb8UzV5V
/uJpvugHSXGoco7Xf8RbWMs55jCntfMIavIhiiiibtONntm2kW1tzVQ59w68onm5
yqnBBGHK8PE55YKBkNEEMpAMffQNPVX6vFXXUTsMj/6v63rvcI5KRyH4Cv264DTL
7CUOTa/qHHwI7Jn3Bx9jRkmcDvLFzHhmPjFTuq88+VvNnFczYSpwK00TE2NenUVr
i4yMJn1vDcd2JbwgWAL9K7jcaHa1n485QrErV56PN7ay+ylnSTJaBPpEV/ZODuVP
JNzaBdxfuPKcJYiVlj8qt51Td8nay04bAYIDhBUzACxhky1SBc+nPjDZmQhvM44e
SmjG6Azc2jNGMFLN0vmKaBc3A96Q2tEsmGDWciqFaSIT7VknXefarcJKx2aeoNoz
l0jgFJde9fFkP9kMuoCeyVdaMPw1uvvsTwVx50uqqnsyuz4lEs4qFpDNMSQw/hPw
AvjTiuN5hWm9ErChdyvdVoEG0yI5QrXLTbgIYaq0zekXJlHMaENjV8Jn/GIkacSO
2n7VYyxnfM6Zj3eAlfwB0A+eTDHMbZMjWuExeaLZzpwQ7PdAsgEzC9xxfz8cNIJh
JTj/QcNElBQ408JhcGHF
=FYUn
-----END PGP SIGNATURE-----

--l2m3ygi2en6ylpof--


--===============2151382642327635458==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============2151382642327635458==--
