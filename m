From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 12/18] Hibernate: generate and verify signature of
 snapshot
Date: Tue, 27 Aug 2013 11:22:28 +0800
Message-ID: <1377573748.27967.60.camel__2000.53475932709$1377573861$gmane$org@linux-s257.site>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-13-git-send-email-jlee@suse.com>
	 <20130825163648.GI5171@amd.pavel.ucw.cz>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:36705 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3H0DX4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Aug 2013 23:23:56 -0400
In-Reply-To: <20130825163648.GI5171@amd.pavel.ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
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
