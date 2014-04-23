From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Wed, 23 Apr 2014 19:12:19 +0200
Message-ID: <201404231912.19922.marex@denx.de>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com> <201404230156.41234.marex@denx.de> <5357EBE1.9000402@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia =?utf-8?q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5357EBE1.9000402@freescale.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday, April 23, 2014 at 06:35:45 PM, Horia Geant=C4=83 wrote:

[...]

> > This entire macro looks somewhat strange.
>=20
> I am trying to fix it with minimal changes, so the patch qualifies fo=
r
> -stable.

This is just broken and you're not fixing it. You're just feeding this =
slimy=20
monster called technical debt more and more code, so it can grow and ge=
t uglier=20
and uglier. I hope you have no attachment to this abomination, since I'=
d like to=20
see it dead.

> > 1) Can't you just snprintf() into $str + some offset ? Something li=
ke:
> >     snprintf(str + strlen(str), str_total_sz - strlen(str), format,
> >     param);
>=20
> I think this would work. It also gets rid of memory allocation.
>=20
> Note that strlen(str) is undefined if str is not initialized /
> null-terminated.
> However, all code paths seem to touch this line in caam_jr_strstatus(=
):
> sprintf(outstr, "%s: ", status_src[ssrc].error);
> before reaching SPRINTFCAT macros, so str is null-terminated.
>=20
> I'll send v2.

No, let us first agree on how to fix this insane abomination please.

But while I am looking, I see stuff like:

caam_jr_strstatus() can call report_ccb_status( , "CCB"); (basically wi=
th a=20
fixed-size string argument):

265         if (status_src[ssrc].report_ssed)
266                 status_src[ssrc].report_ssed(status, outstr);

Report_ccb_status( , "CCB"); will call report_jump_idx( , "CCB"); (stil=
l with=20
fixed-size string arg), which contains your SPRINTFCAT() macro.

This will expand to:

=2E..
strcat("CCB", tmp);
=2E..

So basically you are writing into a fixed-size string? But the string i=
s three-
bytes long, so you are overwriting kernel memory ?

If I read the code wrong, I really apologize in advance.

> > 2) Why is noone checking if the $str has enough space for contents =
of
> > $tmp ?
>=20
> All call sites reach this macro via caam_jr_strstatus(tmp, ...), whic=
h
> is always called having:
> char tmp[CAAM_ERROR_STR_MAX];
>=20
> CAAM_ERROR_STR_MAX is 302, probably enough according to commit
> de2954d66408da3ae34effda777bb564fd17781b (crypto: caam - fix printk
> recursion for long error texts).

You are digging in Linux's crypto code, not OpenSSL. We need accurate f=
ixes and=20
accurate discussion ... using 'probably' does not work here.

Best regards,
Marek Vasut
