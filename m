From: Colin King <colin.king@canonical.com>
Subject: [PATCH] PKCS#7: fix missing break on OID_sha224 case
Date: Fri, 18 Mar 2016 15:51:31 +0000
Message-ID: <1458316291-25705-1-git-send-email-colin.king@canonical.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Peter Jones <pjones@redhat.com>, linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The OID_sha224 case is missing a break and it falls through
to the -ENOPKG error default.  Since HASH_ALGO_SHA224 seems
to be supported, this looks like an unintentional missing break.

Fixes: 07f081fb5057 ("PKCS#7: Add OIDs for sha224, sha284 and sha512 hash algos and use them")
Cc: <stable@vger.kernel.org> # 4.2+
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 40de03f..bdd0d753 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -237,6 +237,7 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
 		break;
 	case OID_sha224:
 		ctx->sinfo->sig.hash_algo = "sha224";
+		break;
 	default:
 		printk("Unsupported digest algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
-- 
2.7.3
