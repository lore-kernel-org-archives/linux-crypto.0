From: David Miller <davem@davemloft.net>
Subject: Re: [sparc64] cryptomgr_test OOPS kernel 4.9.0+
Date: Mon, 26 Dec 2016 17:26:19 -0500 (EST)
Message-ID: <20161226.172619.1321397093716823099.davem@davemloft.net>
References: <CADxRZqwxU+XjTe+jwfrDdsp7Vs47YsJHww3=bsENhrUsYgHvkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org,
        herbert@gondor.apana.org.au, giovanni.cabiddu@intel.com
To: matorola@gmail.com
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CADxRZqwxU+XjTe+jwfrDdsp7Vs47YsJHww3=bsENhrUsYgHvkg@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Anatoly Pugachev <matorola@gmail.com>
Date: Sun, 25 Dec 2016 20:56:08 +0300

> Disabling kernel config option
> CRYPTO_MANAGER_DISABLE_TESTS
> i.e. enable run-time self tests, makes kernel unbootable:
> 
> tested with git kernels v4.9-8648-g5cc60aeedf31 and v4.9-12259-g7c0f6ba682b9

I think the testing code for the new synchronous compression module is
putting kernel image pointers into scatterlists, which in turn we
attempt to transform to and from page structs.

That doesn't work.

It's coming from the test input buffers:

static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
		      struct comp_testvec *dtemplate, int ctcount, int dtcount)
{
 ...
		sg_init_one(&src, ctemplate[i].input, ilen);

These have to be copied into kmalloc() buffers or similar, just like
the skchiper tests do.

The crash on sparc64 shows that we try to dereference a page struct at
a bogus vmemmap address for a page that doesn't exist.

I hacked up the following and this makes the crashes go away:

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f616ad7..117bb33 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1449,22 +1449,31 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
 	unsigned int i;
 	char *output;
+	char *input;
 	int ret;
 	struct scatterlist src, dst;
 	struct acomp_req *req;
 	struct tcrypt_result result;
 
+	pr_info("test_acomp: COMP_BUF_SIZE %d\n", (int) COMP_BUF_SIZE);
+
 	output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
 	if (!output)
 		return -ENOMEM;
+	input = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+	if (!input) {
+		kfree(output);
+		return -ENOMEM;
+	}
 
 	for (i = 0; i < ctcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = ctemplate[i].inlen;
 
 		memset(output, 0, dlen);
+		memcpy(input, ctemplate[i].input, ilen);
 		init_completion(&result.completion);
-		sg_init_one(&src, ctemplate[i].input, ilen);
+		sg_init_one(&src, input, ilen);
 		sg_init_one(&dst, output, dlen);
 
 		req = acomp_request_alloc(tfm);
@@ -1512,8 +1521,9 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 		int ilen = dtemplate[i].inlen;
 
 		memset(output, 0, dlen);
+		memcpy(input, dtemplate[i].input, ilen);
 		init_completion(&result.completion);
-		sg_init_one(&src, dtemplate[i].input, ilen);
+		sg_init_one(&src, input, ilen);
 		sg_init_one(&dst, output, dlen);
 
 		req = acomp_request_alloc(tfm);
@@ -1559,6 +1569,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 	ret = 0;
 
 out:
+	kfree(input);
 	kfree(output);
 	return ret;
 }
