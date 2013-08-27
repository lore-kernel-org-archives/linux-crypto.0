From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 13/18] Hibernate: Avoid S4 sign key data included in
 snapshot image
Date: Tue, 27 Aug 2013 16:33:52 +0800
Message-ID: <1377592432.27967.80.camel__49478.8920194425$1377592542$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-14-git-send-email-jlee@suse.com>
	 <20130825163931.GJ5171@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130825163931.GJ5171@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E6=97=A5=EF=BC=8C2013-08-25 =E6=96=BC 18:39 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu 2013-08-22 19:01:52, Lee, Chun-Yi wrote:
> > This patch add swsusp_page_is_sign_key() method to hibernate_key.c =
and
> > check the page is S4 sign key data when collect saveable page in
> > snapshot.c to avoid sign key data included in snapshot image.
> >=20
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
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
