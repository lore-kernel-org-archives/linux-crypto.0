From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
Date: Thu, 29 Aug 2013 08:01:45 +0800
Message-ID: <1377734505.19568.39.camel__23732.3015150197$1377734634$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <87eh9dzg00.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
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
To: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87eh9dzg00.fsf-ZqZwdwZz9NfTBotR3TxKnbNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Florian,=20

Thanks for your response.

=E6=96=BC =E4=B8=89=EF=BC=8C2013-08-28 =E6=96=BC 23:01 +0200=EF=BC=8CFl=
orian Weimer =E6=8F=90=E5=88=B0=EF=BC=9A
> * Chun-Yi Lee:
>=20
> >  + EFI bootloader must generate RSA key-pair when system boot:

I should add more information on this sentence for mention need GenS4Ke=
y
runtime variable then re-generate key-pair.

Thanks!

> >    - Bootloader store the public key to EFI boottime variable by it=
self
> >    - Bootloader put The private key to S4SignKey EFI variable for f=
orward to
> >      kernel.
>=20
> Is the UEFI NVRAM really suited for such regular updates?
>=20

Yes, Matthew raised this concern at before. I modified patch to load
private key in efi stub kernel, before ExitBootServices(), that means w=
e
don't need generate key-pair at every system boot. So, the above
procedure of efi bootloader will only run one time.=20

User can enable SNAPSHOT_REGEN_KEYS kernel config to notify efi
booloader regenerate key-pair for every S4 to improve security if he
want. So, the key-pair re-generate procedure will only launched when S4
resume, not every system boot.


Thanks a lot!
Joey Lee
