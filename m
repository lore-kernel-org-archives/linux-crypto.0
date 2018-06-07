From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] dh key: fix rounding up KDF output length
Date: Thu,  7 Jun 2018 12:12:01 -0700
Message-ID: <20180607191201.97080-1-ebiggers3@gmail.com>
References: <0000000000009c221d056e0cf53a@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000009c221d056e0cf53a@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit 383203eff718 ("dh key: get rid of stack allocated array") changed
kdf_ctr() to assume that the length of key material to derive is a
multiple of the digest size.  The length was supposed to be rounded up
accordingly.  However, the round_up() macro was used which only gives
the correct result on power-of-2 arguments, whereas not all hash
algorithms have power-of-2 digest sizes.  In some cases this resulted in
a write past the end of the 'outbuf' buffer.

Fix it by switching to roundup(), which works for non-power-of-2 inputs.

Reported-by: syzbot+486f97f892efeb2075a3@syzkaller.appspotmail.com
Reported-by: syzbot+29d17b7898b41ee120a5@syzkaller.appspotmail.com
Reported-by: syzbot+8a608baf8751184ec727@syzkaller.appspotmail.com
Reported-by: syzbot+d04e58bd384f1fe0b112@syzkaller.appspotmail.com
Fixes: 383203eff718 ("dh key: get rid of stack allocated array")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/keys/dh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index f7403821db7f0..b203f7758f976 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -142,6 +142,8 @@ static void kdf_dealloc(struct kdf_sdesc *sdesc)
  * The src pointer is defined as Z || other info where Z is the shared secret
  * from DH and other info is an arbitrary string (see SP800-56A section
  * 5.8.1.2).
+ *
+ * 'dlen' must be a multiple of the digest size.
  */
 static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 		   u8 *dst, unsigned int dlen, unsigned int zlen)
@@ -205,8 +207,8 @@ static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 {
 	uint8_t *outbuf = NULL;
 	int ret;
-	size_t outbuf_len = round_up(buflen,
-			             crypto_shash_digestsize(sdesc->shash.tfm));
+	size_t outbuf_len = roundup(buflen,
+				    crypto_shash_digestsize(sdesc->shash.tfm));
 
 	outbuf = kmalloc(outbuf_len, GFP_KERNEL);
 	if (!outbuf) {
-- 
2.17.1.1185.g55be947832-goog
