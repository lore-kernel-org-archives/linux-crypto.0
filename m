From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v5 08/13] cifs: use get_random_u32 for 32-bit lock random
Date: Thu,  8 Jun 2017 01:26:02 +0200
Message-ID: <20170607232607.26870-9-Jason@zx2c4.com>
References: <20170607232607.26870-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Steve French <sfrench@samba.org>
To: Theodore Ts'o <tytso@mit.edu>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Eric Biggers <ebiggers3@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>
Return-path: <kernel-hardening-return-8435-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170607232607.26870-1-Jason@zx2c4.com>
List-Id: linux-crypto.vger.kernel.org

Using get_random_u32 here is faster, more fitting of the use case, and
just as cryptographically secure. It also has the benefit of providing
better randomness at early boot, which is sometimes when this is used.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Steve French <sfrench@samba.org>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9a1667e0e8d6..fe0c8dcc7dc7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1359,7 +1359,7 @@ init_cifs(void)
 	spin_lock_init(&cifs_tcp_ses_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
-	get_random_bytes(&cifs_lock_secret, sizeof(cifs_lock_secret));
+	cifs_lock_secret = get_random_u32();
 
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
-- 
2.13.0
