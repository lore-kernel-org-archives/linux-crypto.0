From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V4 07/15] asymmetric keys: explicitly add the leading zero byte to encoded message
Date: Sun, 15 Sep 2013 08:56:53 +0800
Message-ID: <1379206621-18639-8-git-send-email-jlee@suse.com>
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
Return-path: <opensuse-kernel+bounces-5101-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

Per PKCS1 spec, the EMSA-PKCS1-v1_5 encoded message is leading by 0x00 0x01 in
its first 2 bytes. The leading zero byte is suppressed by MPI so we pass a
pointer to the _preceding_ byte to RSA_verify() in original code, but it has
risk for the byte is not zero because it's not in EM buffer's scope, neither
RSA_verify() nor mpi_get_buffer() didn't take care the leading byte.

To avoid the risk, that's better we explicitly add the leading zero byte to EM
for pass to RSA_verify(). This patch allocate a _EM buffer to capture the
result from RSA_I2OSP(), then set the first byte to zero in EM and copy the
remaining bytes from _EM.

V2:
- Check the memory allocate result of EM to avoid use it when allocate fail.

Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 crypto/asymmetric_keys/rsa.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 0ede317..9763df7 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -408,6 +408,7 @@ static int RSA_verify_signature(const struct public_key *key,
 	/* Variables as per RFC3447 sec 8.2.2 */
 	const u8 *H = sig->digest;
 	u8 *EM = NULL;
+	u8 *EM_tmp = NULL;
 	MPI m = NULL;
 	size_t k;
 
@@ -442,19 +443,28 @@ static int RSA_verify_signature(const struct public_key *key,
 	/* (2c) Convert the message representative (m) to an encoded message
 	 *      (EM) of length k octets.
 	 *
-	 *      NOTE!  The leading zero byte is suppressed by MPI, so we pass a
-	 *      pointer to the _preceding_ byte to RSA_verify()!
+	 *      NOTE!  The leading zero byte is suppressed by MPI, so we add it
+	 *      back to EM before input to RSA_verify()!
 	 */
-	ret = RSA_I2OSP(m, k, &EM);
+	ret = RSA_I2OSP(m, k, &EM_tmp);
 	if (ret < 0)
 		goto error;
 
-	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
+	EM = kmalloc(k, GFP_KERNEL);
+	if (!EM) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	memset(EM, 0, 1);
+	memcpy(EM + 1, EM_tmp, k-1);
+
+	ret = RSA_verify(H, EM, k, sig->digest_size,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].data,
 			 RSA_ASN1_templates[sig->pkey_hash_algo].size);
 
-error:
 	kfree(EM);
+error:
+	kfree(EM_tmp);
 	mpi_free(m);
 	kleave(" = %d", ret);
 	return ret;
-- 
1.6.0.2
