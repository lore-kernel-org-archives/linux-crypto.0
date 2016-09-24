From: Jan Stancek <jstancek@redhat.com>
Subject: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Fri, 23 Sep 2016 20:22:27 -0400 (EDT)
Message-ID: <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: jstancek@redhat.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: rui.y.wang@intel.com, herbert@gondor.apana.org.au,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I'm chasing a memory corruption with 4.8-rc7 as I'm observing random Oopses
on ppc BE/LE systems (lpars, KVM guests). About 30% of issues is that
module list gets corrupted, and "cat /proc/modules" or "lsmod" triggers
an Oops, for example:

[   88.486041] Unable to handle kernel paging request for data at address 0x00000020
...
[   88.487658] NIP [c00000000020f820] m_show+0xa0/0x240
[   88.487689] LR [c00000000020f834] m_show+0xb4/0x240
[   88.487719] Call Trace:
[   88.487736] [c0000004b605bbb0] [c00000000020f834] m_show+0xb4/0x240 (unreliable)
[   88.487796] [c0000004b605bc50] [c00000000045e73c] seq_read+0x36c/0x520
[   88.487843] [c0000004b605bcf0] [c0000000004e1014] proc_reg_read+0x84/0x120
[   88.487889] [c0000004b605bd30] [c00000000040df88] vfs_read+0xf8/0x380
[   88.487934] [c0000004b605bde0] [c00000000040fd40] SyS_read+0x60/0x110
[   88.487981] [c0000004b605be30] [c000000000009590] system_call+0x38/0xec

0x20 offset is module_use->source, module_use is NULL because module.source_list
gets corrupted.

The source of corruption appears to originate from a 'ahash' test for p8_ghash:

cryptomgr_test
 alg_test
  alg_test_hash
   test_hash
    __test_hash
     ahash_partial_update
      shash_async_export
       memcpy

With some extra traces [1], I'm seeing that ahash_partial_update() allocates 56 bytes
for 'state', and then crypto_ahash_export() writes 76 bytes into it:

[    5.970887] __test_hash alg name p8_ghash, result: c000000004333ac0, key: c0000004b860a500, req: c0000004b860a380
[    5.970963] state: c000000004333f00, statesize: 56
[    5.970995] shash_default_export memcpy c000000004333f00 c0000004b860a3e0, len: 76

This seems to directly correspond with:
  p8_ghash_alg.descsize = sizeof(struct p8_ghash_desc_ctx) == 56
  shash_tfm->descsize = sizeof(struct p8_ghash_desc_ctx) + crypto_shash_descsize(fallback) == 56 + 20
where 20 is presumably coming from "ghash_alg.descsize".

My gut feeling was that these 2 should match, but I'd love to hear
what crypto people think.

Thank you,
Jan

[1]
diff --git a/crypto/shash.c b/crypto/shash.c
index a051541..49fe182 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -188,6 +188,8 @@ EXPORT_SYMBOL_GPL(crypto_shash_digest);

 static int shash_default_export(struct shash_desc *desc, void *out)
 {
+       int len = crypto_shash_descsize(desc->tfm);
+       printk("shash_default_export memcpy %p %p, len: %d\n", out, shash_desc_ctx(desc), len);
        memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(desc->tfm));
        return 0;
 }
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5c9d5a5..2e54579 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -218,6 +218,8 @@ static int ahash_partial_update(struct ahash_request **preq,
                pr_err("alt: hash: Failed to alloc state for %s\n", algo);
                goto out_nostate;
        }
+       printk("state: %p, statesize: %d\n", state, statesize);
+
        ret = crypto_ahash_export(req, state);
        if (ret) {
                pr_err("alt: hash: Failed to export() for %s\n", algo);
@@ -288,6 +290,7 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
                       "%s\n", algo);
                goto out_noreq;
        }
+       printk("__test_hash alg name %s, result: %p, key: %p, req: %p\n", algo, result, key, req);
        ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
                                   tcrypt_complete, &tresult);
