From: Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH 3/3] crypto: Fix leak of struct aead_request in
 test_aead_speed()
Date: Mon, 21 Apr 2014 20:47:05 +0200
Message-ID: <20140421204705.07cb8278@spike>
References: <20140421204439.7999f1c6@spike>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VsKpQugEMs+xyMYtiqyszJX"; protocol="application/pgp-signature"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: tim.c.chen@linux.intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140421204439.7999f1c6@spike>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Sig_/VsKpQugEMs+xyMYtiqyszJX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix leakage of memory for struct aead_request that is allocated via
aead_request_alloc() but not released via aead_request_free().
Reported by Coverity - CID 1163869.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 crypto/tcrypt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1849155..09c93ff2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -320,7 +320,7 @@ static void test_aead_speed(const char *algo, int enc, =
unsigned int sec,
 	if (!req) {
 		pr_err("alg: aead: Failed to allocate request for %s\n",
 		       algo);
-		goto out;
+		goto out_noreq;
 	}
=20
 	i =3D 0;
@@ -390,6 +390,8 @@ static void test_aead_speed(const char *algo, int enc, =
unsigned int sec,
 	} while (*keysize);
=20
 out:
+	aead_request_free(req);
+out_noreq:
 	crypto_free_aead(tfm);
 out_notfm:
 	kfree(sg);
--=20
1.9.1

--Sig_/VsKpQugEMs+xyMYtiqyszJX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVWepAAoJEKssnEpaPQKEG1sQAIrzdS97m11xatQoL2arCpJi
LRELctUwW5QF9rcwoE9xfUrzzi/22GdPD8F/7JVjwPzYikcf3KP7llZzGlfkXerj
wY7JFkQqoeCtuVfCAt1R2giMx85aiu7CJj5Yw6LtoQraiQ6i1qbhK8QnRmi6cSfA
uXkeRAu9zIuUSJx1L1pOp1K6Mvps7pbqor4cWYQQEKnuDh5792eE3xUXIEjuxfP+
j1VQEREyJH5HQINlwbrV2leu2+0et9ipogonBP7vp3OEuFybb7CDtBlNVoxeodmL
zcphuJPub5g/vlXi3akMsPXAkvJD95c1o5o9LFPd4h97twox8Qmj/AI2Up+EjaRa
oIvM92zhn3cWsYJCtRToHVFc7vNuV6H8SOBaAfZTrSetMdx/YpxBW8FwXdTdNS8s
+9GJGTTA/y2oURZXvtbe9Frz7nfF6fIKzoJsKVRwGhdz+tiE7J0uF0aTlq4r/sDY
4Z7I1owBPxyPOGY3JeQu1sQw2YH7isz+XucbFthtLccMF+AtnDx0Bg3Y9BcXPIF5
uMIE1eTljDOHfKQhrhNSf343b/EEMrRu+9I399VPWSoS+Vfrwpz6ME8jHDYL0O4p
icICOoU/gxYrW7VgN9AyjIeEsabZGMd/XCSAsD5bd6H3hwLf6t1ofTNh/fgWzh+R
HUfS/hEYAaEZnxgfeweH
=7QJe
-----END PGP SIGNATURE-----

--Sig_/VsKpQugEMs+xyMYtiqyszJX--
