From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Wed, 23 Apr 2014 19:41:02 +0200
Message-ID: <201404231941.02739.marex@denx.de>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com> <5357EBE1.9000402@freescale.com> <201404231912.19922.marex@denx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia =?utf-8?q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201404231912.19922.marex@denx.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday, April 23, 2014 at 07:12:19 PM, Marek Vasut wrote:
> On Wednesday, April 23, 2014 at 06:35:45 PM, Horia Geant=C4=83 wrote:
>=20
> [...]
>=20
> > > This entire macro looks somewhat strange.
> >=20
> > I am trying to fix it with minimal changes, so the patch qualifies =
for
> > -stable.
>=20
> This is just broken and you're not fixing it. You're just feeding thi=
s
> slimy monster called technical debt more and more code, so it can gro=
w and
> get uglier and uglier. I hope you have no attachment to this abominat=
ion,
> since I'd like to see it dead.
>=20
> > > 1) Can't you just snprintf() into $str + some offset ? Something =
like:
> > >     snprintf(str + strlen(str), str_total_sz - strlen(str), forma=
t,
> > >     param);
> >=20
> > I think this would work. It also gets rid of memory allocation.
> >=20
> > Note that strlen(str) is undefined if str is not initialized /
> > null-terminated.
> > However, all code paths seem to touch this line in caam_jr_strstatu=
s():
> > sprintf(outstr, "%s: ", status_src[ssrc].error);
> > before reaching SPRINTFCAT macros, so str is null-terminated.
> >=20
> > I'll send v2.
>=20
> No, let us first agree on how to fix this insane abomination please.
>=20
> But while I am looking, I see stuff like:
>=20
> caam_jr_strstatus() can call report_ccb_status( , "CCB"); (basically =
with a
> fixed-size string argument):
>=20
> 265         if (status_src[ssrc].report_ssed)
> 266                 status_src[ssrc].report_ssed(status, outstr);
>=20
> Report_ccb_status( , "CCB"); will call report_jump_idx( , "CCB"); (st=
ill
> with fixed-size string arg), which contains your SPRINTFCAT() macro.
>=20
> This will expand to:
>=20
> ...
> strcat("CCB", tmp);
> ...
>=20
> So basically you are writing into a fixed-size string? But the string=
 is
> three- bytes long, so you are overwriting kernel memory ?

Ok, I apologize. You were right. The 'strcat()' is always called with a=
 fixed-
length 302byte long buffer allocated on stack. Thus this code is only f=
ragile.

I will need to think of this code a bit more before I blurt out some se=
rious=20
nonsense again.

Best regards,
Marek Vasut
