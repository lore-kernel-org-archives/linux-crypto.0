From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [PATCH] eCryptfs: Clean up crypto initialization
Date: Mon, 25 Jan 2016 17:23:11 +0300
Message-ID: <20160125142311.GA15355@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ecryptfs@vger.kernel.org, linux-crypto@vger.kernel.org
To: mhalcrow@us.ibm.com
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Michael Halcrow,

The patch e5d9cbde6ce0: "[PATCH] eCryptfs: Clean up crypto
initialization" from Oct 30, 2006, leads to the following static
checker warning:

	fs/ecryptfs/crypto.c:1625 ecryptfs_process_key_cipher()
	error: get_random_bytes() 'dummy_key' too small (64 vs 4294967295)

fs/ecryptfs/crypto.c
  1593  static int
  1594  ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
  1595                              char *cipher_name, size_t *key_size)
  1596  {
  1597          char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
  1598          char *full_alg_name = NULL;
  1599          int rc;
  1600  
  1601          *key_tfm = NULL;
  1602          if (*key_size > ECRYPTFS_MAX_KEY_BYTES) {
  1603                  rc = -EINVAL;
  1604                  printk(KERN_ERR "Requested key size is [%zd] bytes; maximum "
  1605                        "allowable is [%d]\n", *key_size, ECRYPTFS_MAX_KEY_BYTES);
  1606                  goto out;
  1607          }
  1608          rc = ecryptfs_crypto_api_algify_cipher_name(&full_alg_name, cipher_name,
  1609                                                      "ecb");
  1610          if (rc)
  1611                  goto out;
  1612          *key_tfm = crypto_alloc_blkcipher(full_alg_name, 0, CRYPTO_ALG_ASYNC);
  1613          if (IS_ERR(*key_tfm)) {
  1614                  rc = PTR_ERR(*key_tfm);
  1615                  printk(KERN_ERR "Unable to allocate crypto cipher with name "
  1616                         "[%s]; rc = [%d]\n", full_alg_name, rc);
  1617                  goto out;
  1618          }
  1619          crypto_blkcipher_set_flags(*key_tfm, CRYPTO_TFM_REQ_WEAK_KEY);
  1620          if (*key_size == 0) {
  1621                  struct blkcipher_alg *alg = crypto_blkcipher_alg(*key_tfm);
  1622  
  1623                  *key_size = alg->max_keysize;

My concern here is that arc4 has a max_keysize of ARC4_MAX_KEY_SIZE (256).

  1624          }
  1625          get_random_bytes(dummy_key, *key_size);

Potentially leading to memory corruption here.  This is static analysis
work so I may be wrong.

  1626          rc = crypto_blkcipher_setkey(*key_tfm, dummy_key, *key_size);
  1627          if (rc) {
  1628                  printk(KERN_ERR "Error attempting to set key of size [%zd] for "
  1629                         "cipher [%s]; rc = [%d]\n", *key_size, full_alg_name,
  1630                         rc);
  1631                  rc = -EINVAL;
  1632                  goto out;
  1633          }
  1634  out:
  1635          kfree(full_alg_name);
  1636          return rc;
  1637  }

regards,
dan carpenter
