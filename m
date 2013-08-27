From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 13/18] Hibernate: Avoid S4 sign key data included in
 snapshot image
Date: Tue, 27 Aug 2013 16:33:52 +0800
Message-ID: <1377592432.27967.80.camel__16719.1119668589$1377592537$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-14-git-send-email-jlee@suse.com>
	 <20130825163931.GJ5171@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
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
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130825163931.GJ5171-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E6=97=A5=EF=BC=8C2013-08-25 =E6=96=BC 18:39 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu 2013-08-22 19:01:52, Lee, Chun-Yi wrote:
> > This patch add swsusp_page_is_sign_key() method to hibernate_key.c =
and
> > check the page is S4 sign key data when collect saveable page in
> > snapshot.c to avoid sign key data included in snapshot image.
> >=20
> > Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  kernel/power/snapshot.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> > index 72e2911..9e4c94b 100644
> > --- a/kernel/power/snapshot.c
> > +++ b/kernel/power/snapshot.c
> > @@ -860,6 +860,9 @@ static struct page *saveable_highmem_page(struc=
t zone *zone, unsigned long pfn)
> > =20
> >  	BUG_ON(!PageHighMem(page));
> > =20
> > +	if (swsusp_page_is_sign_key(page))
> > +		return NULL;
> > +
> >  	if (swsusp_page_is_forbidden(page) ||  swsusp_page_is_free(page) =
||
> >  	    PageReserved(page))
> >  		return NULL;
>=20
> Just do set_page_forbidden() on your page?

Before call swsusp_unset_page_forbidden(), we need make sure the
create_basic_memory_bitmaps() function already called to initial
forbidden_pages_map. That means need careful the timing, otherwise the
page of private key will not register to forbidden pages map.

So, I choice to refuse the page of private key when snapshot finding
which page is saveable. It has clearer code and we don't need worry the
future change of hibernate.c or user.c for when they call
create_basic_memory_bitmaps() and when the code clear forbidden pages
map.


Thanks a lot!
Joey Lee
