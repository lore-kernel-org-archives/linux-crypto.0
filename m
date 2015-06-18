From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2 PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Thu, 18 Jun 2015 14:17:34 +0800
Message-ID: <20150618061734.GA28418@gondor.apana.org.au>
References: <20150616054551.GA21524@gondor.apana.org.au>
 <E1Z4jpH-0005dy-Et@gondolin.me.apana.org.au>
 <5581A826.7060907@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ruchika.gupta@freescale.com, cristian.stoica@freescale.com,
	NiteshNarayanLal@freescale.com, jinyanjiang@gmail.com,
	Tudor Ambarus <tudor.ambarus@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54112 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbFRGRk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:17:40 -0400
Content-Disposition: inline
In-Reply-To: <5581A826.7060907@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 17, 2015 at 08:02:30PM +0300, Horia Geant=C4=83 wrote:
> > =20
> > -#define DESC_MAX_USED_BYTES		(DESC_RFC4543_GIVENC_LEN + \
> > -					 CAAM_MAX_KEY_SIZE)
> > -#define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
> > +#define DESC_MAX_USED_LEN		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
>=20
> This is going to increase the size of caam_ctx struct, but I agree
> previous approach was error-prone.

The problem with the previous code is that it doesn't take into
account the size of the inline key should the key fit into the
64 entries.

However, it appears that I incorrectly removed DESC_MAX_USED_BYTES
and thus made it 4 times bigger than necessary.  I'll fix that up.

> > +	/* skip assoc data */
> > +	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
>=20
> This wasn't previously needed. I assume it's related to your comment:
> "This series converts various GCM implementations to the new AEAD
> interface.  The main changes [...] both src/dst now contain space at =
the
> head equal to assoclen, but only src has the actual AD."

Right.  The new interface always includes assoclen bytes in both
src and dst SG lists.  req->assoc is gone.

> > +static void init_gcm_job(struct aead_request *req,
> > +			 struct aead_edesc *edesc,
> > +			 bool all_contig, bool encrypt)
> > +{
> > +	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
> > +	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);
> > +	unsigned int ivsize =3D crypto_aead_ivsize(aead);
> > +	u32 *desc =3D edesc->hw_desc;
> > +	bool generic_gcm =3D (ivsize =3D=3D 12);
> > +	unsigned int last;
> > +
> > +	init_aead_job(req, edesc, all_contig, encrypt);
> > +
> > +	/* BUG This should not be specific to generic GCM. */
>=20
> AFAICT, for non-generic GCM uses (RFC4106, RFC4543), cryptlen and/or
> assoclen are always > 0. That's why the descriptors do not address th=
ese
> cases.

Of course.  But with the algif_aead interface you need to at least
ensure that you don't crash or do something silly should the user
give you such an input.  So my question is what happens when it is
zero? Does the hardware simply emit an error and recover, or does it
hang/lock up/do something worse?
=20
> Now that GCM is handled separately, is_gcm logic should be removed fr=
om
> all old_aead_* functions.

I haven't touched the old_aead_* path at all because there are more
conversions to come.  Once it's all done we can kill all of the
old_aead_* functions.

> > -		sg_to_sec4_sg_last(req->src,
> > -				   src_nents,
> > -				   edesc->sec4_sg +
> > -				   sec4_sg_index, 0);
> > +		sg_to_sec4_sg(req->src, src_nents,
> > +			      edesc->sec4_sg + sec4_sg_index, 0);
>=20
> Need to mark end of input S/G, use sg_to_sec4_sg_last() instead.

Thanks I'll fix that up too.

BTW does this actually work on your hardware now?

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
