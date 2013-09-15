From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V4 03/15] asymmetric keys: separate the length checking of octet string from RSA_I2OSP
Date: Sun, 15 Sep 2013 08:56:49 +0800
Message-ID: <1379206621-18639-4-git-send-email-jlee@suse.com>
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
Return-path: <opensuse-kernel+bounces-5097-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

Due to RSA_I2OSP is not only used by signature verification path but also used
in signature generation path. So, separate the length checking of octet string
because it's not for generate 0x00 0x01 leading string when used in signature
generation.

The naming of _RSA_I2OSP and the variables used in this function accord PKCS#1
spec but not follow kernel naming convention, it useful when look at them with
spec.

Reference: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1v2/pkcs1ietffinal.txt
Reference: http://www.emc.com/collateral/white-papers/h11300-pkcs-1v2-2-rsa-cryptography-standard-wp.pdf

Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 crypto/asymmetric_keys/rsa.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 352ba45..aac8b77 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -121,12 +121,30 @@ static int RSAVP1(const struct public_key *key, MPI s, MPI *_m)
 /*
  * Integer to Octet String conversion [RFC3447 sec 4.1]
  */
-static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+static int _RSA_I2OSP(MPI x, unsigned *X_size, u8 **_X)
 {
-	unsigned X_size, x_size;
 	int X_sign;
 	u8 *X;
 
+	X = mpi_get_buffer(x, X_size, &X_sign);
+	if (!X)
+		return -ENOMEM;
+	if (X_sign < 0) {
+		kfree(X);
+		return -EBADMSG;
+	}
+
+	*_X = X;
+	return 0;
+}
+
+static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+{
+	unsigned x_size;
+	unsigned X_size;
+	u8 *X = NULL;
+	int ret;
+
 	/* Make sure the string is the right length.  The number should begin
 	 * with { 0x00, 0x01, ... } so we have to account for 15 leading zero
 	 * bits not being reported by MPI.
@@ -136,13 +154,10 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 	if (x_size != xLen * 8 - 15)
 		return -ERANGE;
 
-	X = mpi_get_buffer(x, &X_size, &X_sign);
-	if (!X)
-		return -ENOMEM;
-	if (X_sign < 0) {
-		kfree(X);
-		return -EBADMSG;
-	}
+	ret = _RSA_I2OSP(x, &X_size, &X);
+	if (ret < 0)
+		return ret;
+
 	if (X_size != xLen - 1) {
 		kfree(X);
 		return -EBADMSG;
-- 
1.6.0.2
