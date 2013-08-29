From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
Date: Fri, 30 Aug 2013 06:30:17 +0800
Message-ID: <1377815417.7080.28.camel__17319.4011942998$1377815606$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <87eh9dzg00.fsf@mid.deneb.enyo.de>
	 <1377734505.19568.39.camel@linux-s257.site>
	 <20130829213249.GA25940@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Machek <pavel-ynQEQJNshbs@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130829213249.GA25940-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-08-29 =E6=96=BC 23:32 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi!
>=20
> > > >    - Bootloader store the public key to EFI boottime variable b=
y itself
> > > >    - Bootloader put The private key to S4SignKey EFI variable f=
or forward to
> > > >      kernel.
> > >=20
> > > Is the UEFI NVRAM really suited for such regular updates?
> > >=20
> >=20
> > Yes, Matthew raised this concern at before. I modified patch to loa=
d
> > private key in efi stub kernel, before ExitBootServices(), that mea=
ns we
> > don't need generate key-pair at every system boot. So, the above
> > procedure of efi bootloader will only run one time.=20
> >=20
> > User can enable SNAPSHOT_REGEN_KEYS kernel config to notify efi
> > booloader regenerate key-pair for every S4 to improve security if h=
e
> > want. So, the key-pair re-generate procedure will only launched whe=
n S4
> > resume, not every system boot.
>=20
> How many writes can UEFI NVRAM survive? (Is it NOR?)

Currently doesn't have enough information for normal. Yes, I don't know=
=2E

>=20
> "every S4 resume" may be approximately "every boot" for some users...
> 									Pavel

Yes, it's possible.

So, this option will be disabled by default. Default will only generate
one key-pair for every hibernate.
If "re-generate key-pair for every S4" is still hurt lift of UEFI NVRAM
too much, then another thinking for re-generate key-pair are:
=20
 + Re-generate key-pair after a number of hibernates.
   e.g. after 5, 10, 20... times
or
 + Random re-generate key-pair?


On the other hand...
In current design, GenS4Key EFI variable could be write by userland
hibernate tool, kernel will respect GenS4Key value from userland when
hibernate launch. So, userland can tell bootloader to lunch the key-pai=
r
regeneration procedure.


Thanks a lot!
Joey LEe
