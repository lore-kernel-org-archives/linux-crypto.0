From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V4 05/15] asymmetric keys: implement RSASP1
Date: Sun, 15 Sep 2013 08:56:51 +0800
Message-ID: <1379206621-18639-6-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <opensuse-kernel+bounces-5099-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

Implement RSASP1 and fill-in the following data to public key signature
structure: signature length (pkcs->k), signature octet
strings (pks->S) and MPI of signature (pks->rsa.s).

The naming of RSASP1 and the variables used in this function accord PKCS#1
spec but not follow kernel naming convention, it useful when look at them with
spec.

Reference: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1v2/pkcs1ietffinal.txt
Reference: http://www.emc.com/collateral/white-papers/h11300-pkcs-1v2-2-rsa-cryptography-standard-wp.pdf

Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 crypto/asymmetric_keys/rsa.c |   47 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index a092aac..0ede317 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -86,6 +86,39 @@ static const struct {
 };
 
 /*
+ * RSASP1() function [RFC3447 sec 5.2.1]
+ */
+static int RSASP1(const struct private_key *key, MPI m, MPI *_s)
+{
+	MPI s;
+	int ret;
+
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0) {
+		kleave(" = -EBADMSG [m < 0]");
+		return -EBADMSG;
+	}
+	if (mpi_cmp(m, key->rsa.n) >= 0) {
+		kleave(" = -EBADMSG [m >= n]");
+		return -EBADMSG;
+	}
+
+	s = mpi_alloc(0);
+	if (!s)
+		return -ENOMEM;
+
+	/* (2) s = m^d mod n */
+	ret = mpi_powm(s, m, key->rsa.d, key->rsa.n);
+	if (ret < 0) {
+		mpi_free(s);
+		return ret;
+	}
+
+	*_s = s;
+	return 0;
+}
+
+/*
  * RSAVP1() function [RFC3447 sec 5.2.2]
  */
 static int RSAVP1(const struct public_key *key, MPI s, MPI *_m)
@@ -173,9 +206,12 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 static int RSA_OS2IP(u8 *X, size_t XLen, MPI *_x)
 {
 	MPI x;
+	int ret;
 
 	x = mpi_alloc((XLen + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB);
-	mpi_set_buffer(x, X, XLen, 0);
+	ret = mpi_set_buffer(x, X, XLen, 0);
+	if (ret < 0)
+		return ret;
 
 	*_x = x;
 	return 0;
@@ -460,8 +496,13 @@ static struct public_key_signature *RSA_generate_signature(
 	if (ret < 0)
 		goto error_v1_5_encode;
 
-	/* TODO 3): s = RSASP1 (K, m) */
-	s = m;
+	/* 3): s = RSASP1 (K, m) */
+	RSASP1(key, m, &s);
+
+	pks->rsa.s = s;
+	pks->nr_mpi = 1;
+	pks->k = mpi_get_nbits(s);
+	pks->k = (pks->k + 7) / 8;
 
 	/* 4): S = I2OSP (s, k) */
 	_RSA_I2OSP(s, &X_size, &pks->S);
-- 
1.6.0.2
