From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC] crypto: compress - Return produced bytes in
 crypto_{,de}compress_{update,final}() (was: Re: [PATCH/RFC] crypto: compress
 - Add comp_request.total_out (was: Re: [PATCH 6/6] squashfs: Make SquashFS
 4 use the new pcomp crypto interface))
Date: Tue, 24 Mar 2009 17:33:01 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au>
 <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763407AbZCXQdx@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 17 Mar 2009, Geert Uytterhoeven wrote:
> On Wed, 11 Mar 2009, Geert Uytterhoeven wrote:
> > On Sun, 8 Mar 2009, Phillip Lougher wrote:
> > > Two API issues of concern (one major, one minor).  Both of these =
relate to the
> > > way Squashfs drives the decompression code, where it repeatedly c=
alls it
> > > supplying additional input/output buffers, rather than using a "s=
ingle-shot"
> > > approach where it calls the decompression code once supplying all=
 the
> > > necessary input and output buffer space.
> > >=20
> > > 1. Minor issue -the lack of a stream.total_out field.  The curren=
t
> > > zlib_inflate code collects the total number of bytes decompressed=
 over the
> > > multiple calls into the stream.total_out field.
> > >=20
> > >    There is clearly no such field available in the cryto API, lea=
ding to the
> > > somewhat clumsy need to track it, i.e. it leads to the following =
additional
> > > code.
> >=20
> > If people feel the need for a total_out field, I can add it to stru=
ct
> > comp_request.
> >=20
> > BTW, what about total_in, which is also provided by plain zlib's z_=
stream?
> > Do people see a need for a similar field?
>=20
> The patch below (on top of the updated one to convert SquashFS to pco=
mp) adds
> comp_request.total_out, so you don't have to calculate and accumulate=
 the
> decompressed output sizes in SquashFS.
>=20
> Notes:
>   - This required the addition of a `struct comp_request *' parameter=
 to
>     crypto_{,de}compress_init()
>   - Still, there's one of the=20
>=20
> 	produced =3D req.avail_out;
> 	...
> 	produced -=3D req.avail_out;
>=20
>     left, as this is part of the logic to discover the end of decompr=
ession
>     (no bytes produced, no error returned).
>=20
> Perhaps it's better to instead make crypto_{,de}compress_{update,fina=
l}()
> return the (positive) number of output bytes (of the current step)?
>=20
> Currently it returns zero (no error) or a negative error value.
> That would allow to get rid of both `produced =3D ... / produced -=3D=
 ...'
> constructs, but the user would have to accumulate the total output si=
ze again
> (which is not such a big deal, IMHO).

Here's an alternative patch, which does exactly that.
Phillip, what do you think?

Thanks for your comments!

=46rom be7d630f96a85d3ce48716b8e328563ba217647b Mon Sep 17 00:00:00 200=
1
=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Tue, 24 Mar 2009 17:19:05 +0100
Subject: [PATCH] crypto: compress - Return produced bytes in crypto_{,d=
e}compress_{update,final}()

If crypto_{,de}compress_{update,final}() succeed, return the actual num=
ber of
bytes produced instead of zero, so their users don't have to calculate =
that
theirselves.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c    |  117 ++++++++++++++++++++++++++++++-------------=
-------
 crypto/zlib.c       |   24 +++++-----
 fs/squashfs/block.c |   33 ++++++---------
 3 files changed, 95 insertions(+), 79 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b50c3c6..9cee018 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -914,24 +914,25 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 	const char *algo =3D crypto_tfm_alg_driver_name(crypto_pcomp_tfm(tfm)=
);
 	unsigned int i;
 	char result[COMP_BUF_SIZE];
-	int error;
+	int res;
=20
 	for (i =3D 0; i < ctcount; i++) {
 		struct comp_request req;
+		unsigned int produced =3D 0;
=20
-		error =3D crypto_compress_setup(tfm, ctemplate[i].params,
-					      ctemplate[i].paramsize);
-		if (error) {
+		res =3D crypto_compress_setup(tfm, ctemplate[i].params,
+					    ctemplate[i].paramsize);
+		if (res) {
 			pr_err("alg: pcomp: compression setup failed on test "
-			       "%d for %s: error=3D%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
=20
-		error =3D crypto_compress_init(tfm);
-		if (error) {
+		res =3D crypto_compress_init(tfm);
+		if (res) {
 			pr_err("alg: pcomp: compression init failed on test "
-			       "%d for %s: error=3D%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
=20
 		memset(result, 0, sizeof(result));
@@ -941,32 +942,37 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 		req.next_out =3D result;
 		req.avail_out =3D ctemplate[i].outlen / 2;
=20
-		error =3D crypto_compress_update(tfm, &req);
-		if (error && (error !=3D -EAGAIN || req.avail_in)) {
+		res =3D crypto_compress_update(tfm, &req);
+		if (res < 0 && (res !=3D -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=3D%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced +=3D res;
=20
 		/* Add remaining input data */
 		req.avail_in +=3D (ctemplate[i].inlen + 1) / 2;
=20
-		error =3D crypto_compress_update(tfm, &req);
-		if (error && (error !=3D -EAGAIN || req.avail_in)) {
+		res =3D crypto_compress_update(tfm, &req);
+		if (res < 0 && (res !=3D -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=3D%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced +=3D res;
=20
 		/* Provide remaining output space */
 		req.avail_out +=3D COMP_BUF_SIZE - ctemplate[i].outlen / 2;
=20
-		error =3D crypto_compress_final(tfm, &req);
-		if (error) {
+		res =3D crypto_compress_final(tfm, &req);
+		if (res < 0) {
 			pr_err("alg: pcomp: compression final failed on test "
-			       "%d for %s: error=3D%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
+		produced +=3D res;
=20
 		if (COMP_BUF_SIZE - req.avail_out !=3D ctemplate[i].outlen) {
 			pr_err("alg: comp: Compression test %d failed for %s: "
@@ -976,6 +982,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 			return -EINVAL;
 		}
=20
+		if (produced !=3D ctemplate[i].outlen) {
+			pr_err("alg: comp: Compression test %d failed for %s: "
+			       "returned len =3D %u (expected %d)\n", i + 1,
+			       algo, produced, ctemplate[i].outlen);
+			return -EINVAL;
+		}
+
 		if (memcmp(result, ctemplate[i].output, ctemplate[i].outlen)) {
 			pr_err("alg: pcomp: Compression test %d failed for "
 			       "%s\n", i + 1, algo);
@@ -986,21 +999,21 @@ static int test_pcomp(struct crypto_pcomp *tfm,
=20
 	for (i =3D 0; i < dtcount; i++) {
 		struct comp_request req;
+		unsigned int produced =3D 0;
=20
-		error =3D crypto_decompress_setup(tfm, dtemplate[i].params,
-						dtemplate[i].paramsize);
-		if (error) {
+		res =3D crypto_decompress_setup(tfm, dtemplate[i].params,
+					      dtemplate[i].paramsize);
+		if (res) {
 			pr_err("alg: pcomp: decompression setup failed on "
-			       "test %d for %s: error=3D%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
=20
-		error =3D crypto_decompress_init(tfm);
-		if (error) {
+		res =3D crypto_decompress_init(tfm);
+		if (res) {
 			pr_err("alg: pcomp: decompression init failed on test "
-			       "%d for %s: error=3D%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
=20
 		memset(result, 0, sizeof(result));
@@ -1010,35 +1023,38 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 		req.next_out =3D result;
 		req.avail_out =3D dtemplate[i].outlen / 2;
=20
-		error =3D crypto_decompress_update(tfm, &req);
-		if (error  && (error !=3D -EAGAIN || req.avail_in)) {
+		res =3D crypto_decompress_update(tfm, &req);
+		if (res < 0 && (res !=3D -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=3D%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced +=3D res;
=20
 		/* Add remaining input data */
 		req.avail_in +=3D (dtemplate[i].inlen + 1) / 2;
=20
-		error =3D crypto_decompress_update(tfm, &req);
-		if (error  && (error !=3D -EAGAIN || req.avail_in)) {
+		res =3D crypto_decompress_update(tfm, &req);
+		if (res < 0 && (res !=3D -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=3D%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced +=3D res;
=20
 		/* Provide remaining output space */
 		req.avail_out +=3D COMP_BUF_SIZE - dtemplate[i].outlen / 2;
=20
-		error =3D crypto_decompress_final(tfm, &req);
-		if (error  && (error !=3D -EAGAIN || req.avail_in)) {
+		res =3D crypto_decompress_final(tfm, &req);
+		if (res < 0 && (res !=3D -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: decompression final failed on "
-			       "test %d for %s: error=3D%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=3D%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced +=3D res;
=20
 		if (COMP_BUF_SIZE - req.avail_out !=3D dtemplate[i].outlen) {
 			pr_err("alg: comp: Decompression test %d failed for "
@@ -1048,6 +1064,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 			return -EINVAL;
 		}
=20
+		if (produced !=3D dtemplate[i].outlen) {
+			pr_err("alg: comp: Decompression test %d failed for "
+			       "%s: returned len =3D %u (expected %d)\n", i + 1,
+			       algo, produced, dtemplate[i].outlen);
+			return -EINVAL;
+		}
+
 		if (memcmp(result, dtemplate[i].output, dtemplate[i].outlen)) {
 			pr_err("alg: pcomp: Decompression test %d failed for "
 			       "%s\n", i + 1, algo);
diff --git a/crypto/zlib.c b/crypto/zlib.c
index 33609ba..c301573 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -165,15 +165,15 @@ static int zlib_compress_update(struct crypto_pco=
mp *tfm,
 		return -EINVAL;
 	}
=20
+	ret =3D req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in =3D stream->next_in;
 	req->avail_in =3D stream->avail_in;
 	req->next_out =3D stream->next_out;
 	req->avail_out =3D stream->avail_out;
-	return 0;
+	return ret;
 }
=20
 static int zlib_compress_final(struct crypto_pcomp *tfm,
@@ -195,15 +195,15 @@ static int zlib_compress_final(struct crypto_pcom=
p *tfm,
 		return -EINVAL;
 	}
=20
+	ret =3D req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in =3D stream->next_in;
 	req->avail_in =3D stream->avail_in;
 	req->next_out =3D stream->next_out;
 	req->avail_out =3D stream->avail_out;
-	return 0;
+	return ret;
 }
=20
=20
@@ -280,15 +280,15 @@ static int zlib_decompress_update(struct crypto_p=
comp *tfm,
 		return -EINVAL;
 	}
=20
+	ret =3D req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in =3D stream->next_in;
 	req->avail_in =3D stream->avail_in;
 	req->next_out =3D stream->next_out;
 	req->avail_out =3D stream->avail_out;
-	return 0;
+	return ret;
 }
=20
 static int zlib_decompress_final(struct crypto_pcomp *tfm,
@@ -328,15 +328,15 @@ static int zlib_decompress_final(struct crypto_pc=
omp *tfm,
 		return -EINVAL;
 	}
=20
+	ret =3D req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in =3D stream->next_in;
 	req->avail_in =3D stream->avail_in;
 	req->next_out =3D stream->next_out;
 	req->avail_out =3D stream->avail_out;
-	return 0;
+	return ret;
 }
=20
=20
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 6196821..433f065 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -154,9 +154,8 @@ int squashfs_read_data(struct super_block *sb, void=
 **buffer, u64 index,
 	}
=20
 	if (compressed) {
-		int error =3D 0, decomp_init =3D 0;
+		int res =3D 0, decomp_init =3D 0;
 		struct comp_request req;
-		unsigned int produced =3D 0;
=20
 		/*
 		 * Uncompress block.
@@ -194,41 +193,35 @@ int squashfs_read_data(struct super_block *sb, vo=
id **buffer, u64 index,
 			}
=20
 			if (!decomp_init) {
-				error =3D crypto_decompress_init(msblk->tfm);
-				if (error) {
+				res =3D crypto_decompress_init(msblk->tfm);
+				if (res) {
 					ERROR("crypto_decompress_init "
 						"returned %d, srclength %d\n",
-						error, srclength);
+						res, srclength);
 					goto release_mutex;
 				}
 				decomp_init =3D 1;
 			}
=20
-			produced =3D req.avail_out;
-			error =3D crypto_decompress_update(msblk->tfm, &req);
-			if (error) {
+			res =3D crypto_decompress_update(msblk->tfm, &req);
+			if (res < 0) {
 				ERROR("crypto_decompress_update returned %d, "
-					"data probably corrupt\n", error);
+					"data probably corrupt\n", res);
 				goto release_mutex;
 			}
-			produced -=3D req.avail_out;
-
-			length +=3D produced;
+			length +=3D res;
=20
 			if (req.avail_in =3D=3D 0 && k < b)
 				put_bh(bh[k++]);
-		} while (bytes || produced);
+		} while (bytes || res);
=20
-		produced =3D req.avail_out;
-		error =3D crypto_decompress_final(msblk->tfm, &req);
-		if (error) {
+		res =3D crypto_decompress_final(msblk->tfm, &req);
+		if (res < 0) {
 			ERROR("crypto_decompress_final returned %d, data "
-				"probably corrupt\n", error);
+				"probably corrupt\n", res);
 			goto release_mutex;
 		}
-		produced -=3D req.avail_out;
-
-		length +=3D produced;
+		length +=3D res;
=20
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
--=20
1.6.0.4


With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
