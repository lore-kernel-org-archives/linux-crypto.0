From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/18] asymmetric keys: implement OS2IP in rsa
Date: Thu, 22 Aug 2013 19:01:43 +0800
Message-ID: <1377169317-5959-5-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
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
Return-path: <opensuse-kernel+bounces-4973-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1377169317-5959-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

Implement Octet String to Integer conversion [RFC3447 sec 4.2] in rsa.c. It's
the second step of signature generation operation.

This patch is temporary set non-RSASP1 message to pks->S for debugging.

Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 crypto/asymmetric_keys/rsa.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index c26ae77..0862018 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -168,6 +168,20 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 }
 
 /*
+ * Octet String to Integer conversion [RFC3447 sec 4.2]
+ */
+static int RSA_OS2IP(u8 *X, size_t XLen, MPI *_x)
+{
+	MPI x;
+
+	x = mpi_alloc((XLen + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB);
+	mpi_set_buffer(x, X, XLen, 0);
+
+	*_x = x;
+	return 0;
+}
+
+/*
  * EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2]
  * @M: message to be signed, and octet string
  * @emLen: intended length in octets of the encoded message
@@ -412,6 +426,9 @@ static struct public_key_signature *RSA_generate_signature(
 {
 	struct public_key_signature *pks;
 	u8 *EM = NULL;
+	MPI m = NULL;
+	MPI s = NULL;
+	unsigned X_size;
 	size_t emLen;
 	int ret;
 
@@ -431,14 +448,16 @@ static struct public_key_signature *RSA_generate_signature(
 	if (ret < 0)
 		goto error_v1_5_encode;
 
-	/* TODO 2): m = OS2IP (EM) */
+	/* 2): m = OS2IP (EM) */
+	ret = RSA_OS2IP(EM, emLen, &m);
+	if (ret < 0)
+		goto error_v1_5_encode;
 
 	/* TODO 3): s = RSASP1 (K, m) */
+	s = m;
 
-	/* TODO 4): S = I2OSP (s, k) */
-
-	/* TODO: signature S to a u8* S or set to sig->rsa.s? */
-	pks->S = EM;		/* TODO: temporary set S to EM */
+	/* 4): S = I2OSP (s, k) */
+	_RSA_I2OSP(s, &X_size, &pks->S);
 
 	return pks;
 
-- 
1.6.4.2
