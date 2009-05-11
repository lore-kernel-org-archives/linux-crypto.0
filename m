From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: compress - Return produced bytes in
 crypto_{,de}compress_{update,final}()
Date: Mon, 11 May 2009 17:35:08 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0905111731490.302@vixen.sonytel.be>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
 <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be> <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
	linux-crypto@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47099 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695AbZEKPfJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 11:35:09 -0400
In-Reply-To: <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If crypto_{,de}compress_{update,final}() succeed, return the actual num=
ber of
bytes produced instead of zero, so their users don't have to calculate =
that
theirselves.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
As we're already at 2.6.30-rc5, I do not want to delay any longer this =
API
change for a new module introduced for 2.6.30.

Herbert, please apply for 2.6.30.
Thanks!

 crypto/testmgr.c |  117 ++++++++++++++++++++++++++++++++--------------=
--------
 crypto/zlib.c    |   24 ++++++------
 2 files changed, 82 insertions(+), 59 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index bfee6e9..b55bccc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -916,24 +916,25 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -943,32 +944,37 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -978,6 +984,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -988,21 +1001,21 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -1012,35 +1025,38 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -1050,6 +1066,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
--=20
1.6.2.4


With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
