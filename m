From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: INFO: inconsistent lock state in ecryptfs_calculate_md5
Date: Sat, 16 Apr 2016 15:01:09 +0800
Message-ID: <20160416070109.GA6499@gondor.apana.org.au>
References: <CANMq1KBeZrH6Mvm=gy1BEnMthGpGb21udPrvsbxuu1D8DWkk6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ecryptfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>
To: Nicolas Boichat <drinkcat@chromium.org>
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANMq1KBeZrH6Mvm=gy1BEnMthGpGb21udPrvsbxuu1D8DWkk6g@mail.gmail.com>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 14, 2016 at 10:03:48PM +0800, Nicolas Boichat wrote:
> 
> We've run into the following lockdep warning while using a system with
> ecryptfs, under heavy memory pressure.
> 
> If I understand the issue correctly,
> fs/ecryptfs/crypto.c:ecryptfs_calculate_md5:
>  - Locks &crypt_stat->cs_hash_tfm_mutex
>  -> Calls crypto_alloc_hash
>    -> Calls crypto_alloc_base
>       ->  __crypto_alloc_tfm
>         -> kzalloc(tfm_size, GFP_KERNEL)
>            -> Which, under memory pressure, may attempt to flush
> pages, which would reenter ecryptfs_calculate_md5, try to lock the
> mutex again, and cause a deadlock.

Well the following patch should fix this bug but it's really
just one piece of a much bigger problem.  For example, the function
ecryptfs_encrypt_page also does a GFP_USER allocation.  So to
completely fix this filesystem someone should audit all the data
paths to ensure that no FS allocations occur.

---8<---
Subject: eCryptfs: Do not allocate hash tfm in NORECLAIM context

You cannot allocate crypto tfm objects in NORECLAIM or NOFS contexts.
The ecryptfs code currently does exactly that for the MD5 tfm.

This patch fixes it by preallocating the MD5 tfm in a safe context.

The MD5 tfm is also reentrant so this patch removes the superfluous
cs_hash_tfm_mutex.

Reported-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 64026e5..5600496 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -105,19 +105,7 @@ static int ecryptfs_calculate_md5(char *dst,
 	struct crypto_shash *tfm;
 	int rc = 0;
 
-	mutex_lock(&crypt_stat->cs_hash_tfm_mutex);
 	tfm = crypt_stat->hash_tfm;
-	if (!tfm) {
-		tfm = crypto_alloc_shash(ECRYPTFS_DEFAULT_HASH, 0, 0);
-		if (IS_ERR(tfm)) {
-			rc = PTR_ERR(tfm);
-			ecryptfs_printk(KERN_ERR, "Error attempting to "
-					"allocate crypto context; rc = [%d]\n",
-					rc);
-			goto out;
-		}
-		crypt_stat->hash_tfm = tfm;
-	}
 	rc = ecryptfs_hash_digest(tfm, src, len, dst);
 	if (rc) {
 		printk(KERN_ERR
@@ -126,7 +114,6 @@ static int ecryptfs_calculate_md5(char *dst,
 		goto out;
 	}
 out:
-	mutex_unlock(&crypt_stat->cs_hash_tfm_mutex);
 	return rc;
 }
 
@@ -207,16 +194,29 @@ out:
  *
  * Initialize the crypt_stat structure.
  */
-void
-ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
+int ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
 {
+	struct crypto_shash *tfm;
+	int rc;
+
+	tfm = crypto_alloc_shash(ECRYPTFS_DEFAULT_HASH, 0, 0);
+	if (IS_ERR(tfm)) {
+		rc = PTR_ERR(tfm);
+		ecryptfs_printk(KERN_ERR, "Error attempting to "
+				"allocate crypto context; rc = [%d]\n",
+				rc);
+		return rc;
+	}
+
 	memset((void *)crypt_stat, 0, sizeof(struct ecryptfs_crypt_stat));
 	INIT_LIST_HEAD(&crypt_stat->keysig_list);
 	mutex_init(&crypt_stat->keysig_list_mutex);
 	mutex_init(&crypt_stat->cs_mutex);
 	mutex_init(&crypt_stat->cs_tfm_mutex);
-	mutex_init(&crypt_stat->cs_hash_tfm_mutex);
+	crypt_stat->hash_tfm = tfm;
 	crypt_stat->flags |= ECRYPTFS_STRUCT_INITIALIZED;
+
+	return 0;
 }
 
 /**
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index d123fba..c7761a9 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -242,7 +242,6 @@ struct ecryptfs_crypt_stat {
 	struct list_head keysig_list;
 	struct mutex keysig_list_mutex;
 	struct mutex cs_tfm_mutex;
-	struct mutex cs_hash_tfm_mutex;
 	struct mutex cs_mutex;
 };
 
@@ -577,7 +576,7 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
 			int sg_size);
 int ecryptfs_compute_root_iv(struct ecryptfs_crypt_stat *crypt_stat);
 void ecryptfs_rotate_iv(unsigned char *iv);
-void ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
+int ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
 void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
 void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 121114e..0caec70 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -898,8 +898,11 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 	struct ecryptfs_crypt_stat *crypt_stat;
 
 	crypt_stat = &ecryptfs_inode_to_private(d_inode(dentry))->crypt_stat;
-	if (!(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))
-		ecryptfs_init_crypt_stat(crypt_stat);
+	if (!(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED)) {
+		rc = ecryptfs_init_crypt_stat(crypt_stat);
+		if (rc)
+			return rc;
+	}
 	inode = d_inode(dentry);
 	lower_inode = ecryptfs_inode_to_lower(inode);
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 77a486d..85411ce 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -55,7 +55,10 @@ static struct inode *ecryptfs_alloc_inode(struct super_block *sb)
 	inode_info = kmem_cache_alloc(ecryptfs_inode_info_cache, GFP_KERNEL);
 	if (unlikely(!inode_info))
 		goto out;
-	ecryptfs_init_crypt_stat(&inode_info->crypt_stat);
+	if (ecryptfs_init_crypt_stat(&inode_info->crypt_stat)) {
+		kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
+		goto out;
+	}
 	mutex_init(&inode_info->lower_file_mutex);
 	atomic_set(&inode_info->lower_file_count, 0);
 	inode_info->lower_file = NULL;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
