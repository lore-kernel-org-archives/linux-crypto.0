From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V4 13/15] Hibernate: introduced SNAPSHOT_SIG_HASH config for select hash algorithm
Date: Sun, 15 Sep 2013 08:56:59 +0800
Message-ID: <1379206621-18639-14-git-send-email-jlee@suse.com>
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
Return-path: <opensuse-kernel+bounces-5107-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

This patch introduced SNAPSHOT_SIG_HASH config for user to select which
hash algorithm will be used during signature generation of snapshot.

v2:
Add define check of oCONFIG_SNAPSHOT_VERIFICATION in snapshot.c before
declare pkey_hash().

Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 kernel/power/Kconfig    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/snapshot.c |   25 ++++++++++++++++++++-----
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index b592d88..79b34fa 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -78,6 +78,52 @@ config SNAPSHOT_VERIFICATION
 	  dependent on UEFI environment. EFI bootloader should generate the
 	  key-pair.
 
+choice
+	prompt "Which hash algorithm should snapshot be signed with?"
+        depends on SNAPSHOT_VERIFICATION
+        help
+          This determines which sort of hashing algorithm will be used during
+          signature generation of snapshot. This algorithm _must_ be built into
+	  the kernel directly so that signature verification can take place.
+	  It is not possible to load a signed snapshot containing the algorithm
+	  to check the signature on that module.
+
+config SNAPSHOT_SIG_SHA1
+        bool "Sign modules with SHA-1"
+        select CRYPTO_SHA1
+	select CRYPTO_SHA1_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA224
+        bool "Sign modules with SHA-224"
+        select CRYPTO_SHA256
+	select CRYPTO_SHA256_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA256
+        bool "Sign modules with SHA-256"
+        select CRYPTO_SHA256
+	select CRYPTO_SHA256_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA384
+        bool "Sign modules with SHA-384"
+        select CRYPTO_SHA512
+	select CRYPTO_SHA512_SSSE3 if X86_64
+
+config SNAPSHOT_SIG_SHA512
+        bool "Sign modules with SHA-512"
+        select CRYPTO_SHA512
+	select CRYPTO_SHA512_SSSE3 if X86_64
+
+endchoice
+
+config SNAPSHOT_SIG_HASH
+        string
+        depends on SNAPSHOT_VERIFICATION
+        default "sha1" if SNAPSHOT_SIG_SHA1
+        default "sha224" if SNAPSHOT_SIG_SHA224
+        default "sha256" if SNAPSHOT_SIG_SHA256
+        default "sha384" if SNAPSHOT_SIG_SHA384
+        default "sha512" if SNAPSHOT_SIG_SHA512
+
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on HIBERNATION
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 804feb6..896f11d 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1041,7 +1041,22 @@ static inline void copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
 #endif /* CONFIG_HIGHMEM */
 
 #ifdef CONFIG_SNAPSHOT_VERIFICATION
-#define SNAPSHOT_HASH "sha256"
+static const char *snapshot_hash = CONFIG_SNAPSHOT_SIG_HASH;
+
+static int pkey_hash(void)
+{
+	int i, ret;
+
+	ret = -1;
+	for (i = 0; i < PKEY_HASH__LAST; i++) {
+		if (!strcmp(pkey_hash_algo[i], snapshot_hash)) {
+			ret = i;
+			break;
+		}
+	}
+
+	return ret;
+}
 #endif
 
 /*
@@ -1074,7 +1089,7 @@ swsusp_generate_signature(struct memory_bitmap *copy_bm, unsigned int nr_pages)
 	int ret, i;
 
 	ret = -ENOMEM;
-	tfm = crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
+	tfm = crypto_alloc_shash(snapshot_hash, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
 		return PTR_ERR(tfm);
@@ -1127,7 +1142,7 @@ swsusp_generate_signature(struct memory_bitmap *copy_bm, unsigned int nr_pages)
 		goto error_key;
 	}
 
-	pks = generate_signature(s4_sign_key, digest, PKEY_HASH_SHA256, false);
+	pks = generate_signature(s4_sign_key, digest, pkey_hash(), false);
 	if (IS_ERR(pks)) {
 		pr_err("Generate signature fail: %lx", PTR_ERR(pks));
 		ret = PTR_ERR(pks);
@@ -2491,7 +2506,7 @@ int snapshot_verify_signature(u8 *digest, size_t digest_size)
 		pr_err("PM: Allocate public key signature fail!");
 		return -ENOMEM;
 	}
-	pks->pkey_hash_algo = PKEY_HASH_SHA256;
+	pks->pkey_hash_algo = pkey_hash();
 	pks->digest = digest;
 	pks->digest_size = digest_size;
 
@@ -2544,7 +2559,7 @@ int snapshot_image_verify(void)
 	if (ret)
 		goto forward_ret;
 
-	tfm = crypto_alloc_shash(SNAPSHOT_HASH, 0, 0);
+	tfm = crypto_alloc_shash(snapshot_hash, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_err("IS_ERR(tfm): %ld", PTR_ERR(tfm));
 		return PTR_ERR(tfm);
-- 
1.6.0.2
