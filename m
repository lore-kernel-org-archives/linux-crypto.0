From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 12/18] Hibernate: generate and verify signature of
 snapshot
Date: Tue, 27 Aug 2013 11:22:28 +0800
Message-ID: <1377573748.27967.60.camel__14216.4000230425$1377573850$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-13-git-send-email-jlee@suse.com>
	 <20130825163648.GI5171@amd.pavel.ucw.cz>
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
In-Reply-To: <20130825163648.GI5171-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Pavel,=20

Thanks for your time to review my patches.

=E6=96=BC =E6=97=A5=EF=BC=8C2013-08-25 =E6=96=BC 18:36 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu 2013-08-22 19:01:51, Lee, Chun-Yi wrote:
> > This patch add the code for generate/verify signature of snapshot, =
it
> > put the signature to snapshot header. This approach can support bot=
h
> > on userspace hibernate and in-kernel hibernate.
> >=20
> > v2:
> > - Due to loaded S4 sign key before ExitBootServices, we need forwar=
d key from
> >   boot kernel to resume target kernel. So this patch add a empty pa=
ge in
> >   snapshot image, then we keep the pfn of this empty page in snapsh=
ot header.
> >   When system resume from hibernate, we fill new sign key to this e=
mpty page
> >   space after snapshot image checked pass. This mechanism let boot =
kernel can
> >   forward new sign key to resume target kernel but don't need write=
 new private
> >   key to any other storage, e.g. swap.
> >=20
> > Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> > Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  kernel/power/power.h    |    6 +
> >  kernel/power/snapshot.c |  280 +++++++++++++++++++++++++++++++++++=
++++++++++-
> >  kernel/power/swap.c     |   14 +++
> >  kernel/power/user.c     |    9 ++
> >  4 files changed, 302 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/kernel/power/power.h b/kernel/power/power.h
> > index 69a81d8..84e0b06 100644
> > --- a/kernel/power/power.h
> > +++ b/kernel/power/power.h
> > @@ -3,6 +3,9 @@
> >  #include <linux/utsname.h>
> >  #include <linux/freezer.h>
> > =20
> > +/* The maximum length of snapshot signature */
> > +#define SIG_LENG 512
> > +
> >  struct swsusp_info {
> >  	struct new_utsname	uts;
> >  	u32			version_code;
> > @@ -11,6 +14,8 @@ struct swsusp_info {
> >  	unsigned long		image_pages;
> >  	unsigned long		pages;
> >  	unsigned long		size;
> > +	unsigned long           skey_data_buf_pfn;
> > +	u8			signature[SIG_LENG];
> >  } __attribute__((aligned(PAGE_SIZE)));
>=20
> SIG_LEN or SIG_LENGTH. Select one.
>=20

I will use SIG_LEN at next version, thanks!

>=20
> > +static int
> >  copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitma=
p *orig_bm)
> >  {
> >  	struct zone *zone;
> > -	unsigned long pfn;
> > +	unsigned long pfn, dst_pfn;
> ...
> > +	tfm =3D crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
> > +	if (IS_ERR(tfm)) {
> > +		pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
> > +		return PTR_ERR(tfm);
> > +	}
> > +
> > +	desc_size =3D crypto_shash_descsize(tfm) + sizeof(*desc);
> > +	digest_size =3D crypto_shash_digestsize(tfm);
> > +	digest =3D kzalloc(digest_size + desc_size, GFP_KERNEL);
>=20
> Are you sure GFP_KERNEL allocation is okay at this phase of
> hibernation?
>=20
> Could the hashing be done at later phase, when writing the image to
> disk?
>=20

Thanks for you point out!

Yes, call memory allocate here is not a good design due to it causes
garbage in snapshot that will not released by resumed kernel.

I just finished another implementation, the respin patch extracts the
signature generation code to another function then call the function in
swsusp_save() after copy_data_pages() finished. We can write to memory
at that stage.

> > =20
> > +void **h_buf;
>=20
> helpfully named.
>=20

I will change the name to handle_buffers;

> > +	ret =3D verify_signature(s4_wake_key, pks);
> > +	if (ret) {
> > +		pr_err("snapshot S4 signature verification fail: %d\n", ret);
> > +		goto error_verify;
> > +	} else
> > +		pr_info("snapshot S4 signature verification pass!\n");
> > +
> > +	if (pks->rsa.s)
> > +		mpi_free(pks->rsa.s);
> > +	kfree(pks);
>=20
> ret =3D 0 and fall through?
>=20

When verification success, verify_signature() will return 0.

Yes, here have duplicate code, I will clear up it.

> > +	return 0;
> > +
> > +error_verify:
> > +	if (pks->rsa.s)
> > +		mpi_free(pks->rsa.s);
> > +error_mpi:
> > +	kfree(pks);
> > +	return ret;
> > +}
>=20
>=20
> > +	ret =3D crypto_shash_final(desc, digest);
> > +	if (ret)
> > +		goto error_shash;
> > +
> > +	ret =3D snapshot_verify_signature(digest, digest_size);
> > +	if (ret)
> > +		goto error_verify;
> > +
> > +	kfree(h_buf);
> > +	kfree(digest);
> > +	crypto_free_shash(tfm);
> > +	return 0;
>=20
> These four lines can be deleted.
>=20

Yes, here also duplicate, I will remove.

> > +
> > +error_verify:
> > +error_shash:
> > +	kfree(h_buf);
> > +	kfree(digest);
> > +error_digest:
> > +	crypto_free_shash(tfm);
> > +	return ret;
> > +}
> > +
> 									Pavel


Thanks a lot!
Joey Lee
