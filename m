From: Roberto Sassu <myrobmail@gmail.com>
Subject: Suspect bug in the authenc module
Date: Sat, 27 Feb 2010 12:14:15 +0100
Message-ID: <201002271214.15414.myrobmail@gmail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_H6PiLh5Sezpallc"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61603 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965569Ab0B0LOQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2010 06:14:16 -0500
Received: by fxm19 with SMTP id 19so894752fxm.21
        for <linux-crypto@vger.kernel.org>; Sat, 27 Feb 2010 03:14:14 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--Boundary-00=_H6PiLh5Sezpallc
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello

i'm trying to use the authenc module and i wrote a small kernel module that 
simply encrypts/decrypts a fixed data using the hmac(sha1) as authentication 
algorithm and cbc(aes) as encryption algorithm. 
The used platform is a KVM quest with Fedora 12 i686 and the latest kernel 
2.6.33.
I have taken the code from the testmgr and from net/ipv4/esp4.c.
But, when testing the code, attached in this mail, the crypto_aead_decrypt() 
function always replies -EBADMSG. 
I tried the same code in a 64-bit machine (user mode kernel and Fedora 12) and 
the decryption was successful. I noted, when comparing the auth portion in 
both systems, that this computed during the encryption from the 32bit KVM 
guest, was different and with no fixed value. I investigated in the code of 
authenc and i recorded some partial result of the encryption operation. That 
is the log:   

--------- testing authenc: encrypt ---------------
assoc: 495C501F1D94CC81BAB7B603AFA5C1A1D85C4268E06CDA8905AC56AC1B2AD386
alg: No test for authenc(hmac(sha1),cbc(aes)) (authenc(hmac(sha1-
generic),cbc(aes-asm)))
Setting ahash key: 313233343536373839303132
Setting blk key: 31323334353637383930313233343536
crypto_authenc_encrypt: ivsize 16 iv: 01010101010101010101010101010101
crypto_authenc_genicv: dump vdst: 
CFE3A997243F38B0D6A89DCAB5126DC93952E493E72EA590CC8D186A4E1654860000000000000000000000000000000000000000
crypto_authenc_genicv ivsize 16,dst offset 3392 iv 
01010101010101010101010101010101
crypto_authenc_genicv: iv after sg_init_table 00000000000000000101010101010101
crypto_authenc_genicv: vdst == iv + ivsize? 0
crypto_authenc_genicv: scatterlist dst 0 before fn assignement (line 355): 
3242265088, 388, 32, dump: 
495C501F1D94CC81BAB7B603AFA5C1A1D85C4268E06CDA8905AC56AC1B2AD386
crypto_authenc_genicv: scatterlist dst 1 before fn assignement (line 355): 
3727819872, 0, 0, dump: 
crypto_authenc_genicv: scatterlist dst 2 before fn assignement (line 355): 
3241960448, 1152, 16, dump: 00000000000000000101010101010101
crypto_authenc_genicv: scatterlist dst 3 before fn assignement (line 355): 
3747577608, 0, 0, dump: 
crypto_authenc_genicv: scatterlist dst 0 after fn assignement (line 355): 
3242265088, 388, 32, dump: 
495C501F1D94CC81BAB7B603AFA5C1A1D85C4268E06CDA8905AC56AC1B2AD386
crypto_authenc_genicv: scatterlist dst 1 after fn assignement (line 355): 
3727819872, 0, 0, dump: 
crypto_authenc_genicv: scatterlist dst 2 after fn assignement (line 355): 
3241960448, 1152, 16, dump: 0000000000000000C01886E0201986E0
crypto_authenc_genicv: scatterlist dst 2 after fn assignement (line 355):: 
3747577608, 0, 0, dump: 
--------------------------------------------------

Just for test, i tried to add a 16bit long offset when defining the memory 
address for the "iv" in the function  crypto_authenc_encrypt() for the 32-bit 
kernel, and everything works fine.
I don't know if i made a mistake in the code that causes this misbehaviour in 
the authenc module or if it is a bug.

Thanks in advance for the reply.

--Boundary-00=_H6PiLh5Sezpallc
Content-Type: text/x-csrc;
  charset="UTF-8";
  name="testaeadesp.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="testaeadesp.c"

#include <crypto/hash.h>
#include <linux/err.h>
#include <linux/module.h>
#include <linux/scatterlist.h>
#include <linux/slab.h>
#include <linux/string.h>
#include <crypto/rng.h>
#include <crypto/authenc.h>
#include <linux/pagemap.h>
#include <linux/rtnetlink.h>

#define MAX_IVLEN		16
#define AUTHSIZE		20

int testmode = 0;

module_param(testmode, int, 0);

void hexdump(unsigned char *buf, int len) 
{
	while(--len >=0)
		printk("%02X", *buf++);
	printk("\n");
}


struct tcrypt_result {
	struct completion completion;
	int err;
};


static void tcrypt_complete(struct crypto_async_request *req, int err)
{
	struct tcrypt_result *res = req->data;

	if (err == -EINPROGRESS)
		return;

	res->err = err;
	complete(&res->completion);
}


static int testrun(void)
{
 	const char *algo = "authenc(hmac(sha1),cbc(aes))";

	struct crypto_aead *tfm;
	unsigned int i;
	int ret = -ENOMEM;
	unsigned char *ekey = "1234567890123456";
	unsigned char *akey = "123456789012";
	unsigned char *key, *pp;
	unsigned int ekeylen = 16;
	unsigned int akeylen = 12;
	unsigned int keylen = 0;
	struct aead_request *req;
	struct tcrypt_result result;
	unsigned int authsize = AUTHSIZE;
	char *assoc = "\x49\x5c\x50\x1f\x1d\x94\xcc\x81"
			  "\xba\xb7\xb6\x03\xaf\xa5\xc1\xa1"
			  "\xd8\x5c\x42\x68\xe0\x6c\xda\x89"
			  "\x05\xac\x56\xac\x1b\x2a\xd3\x86";
	int assoclen = 32;
	unsigned char iv[MAX_IVLEN];
	mm_segment_t old_fs = get_fs();
	struct file *fp;
	struct scatterlist src_sg, dst_sg;
	struct scatterlist asg;
	char *filename = "file1.txt";
	char *string = "ciao";
	struct crypto_authenc_key_param *param;
	struct rtattr *rta;
	char *input;
	int blksize = 0;
	int clen = 16;		/* len of data */

	printk("assoc: ");
	hexdump(assoc, 32);

	tfm = crypto_alloc_aead(algo, 0, 0);
	if (IS_ERR(tfm)) {
		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
		       "%ld\n", algo, PTR_ERR(tfm));
		goto out;
	}

	blksize = ALIGN(crypto_aead_blocksize(tfm), 4);
	clen = ALIGN(clen + 2, blksize);
	input = kzalloc(clen + AUTHSIZE, GFP_KERNEL);
	
	if(!testmode) {
		set_fs(KERNEL_DS);

		fp = filp_open(filename, O_RDONLY, 0);
		if(IS_ERR(fp)) {
			printk("Error opening file: %s\n", filename);
			set_fs(old_fs);
			goto out;
		}
		fp->f_op->read(fp, input, clen + AUTHSIZE, &fp->f_pos);

		filp_close(fp, NULL); 
		set_fs(old_fs);
	} else
		memcpy(input, string, strlen(string));	

	init_completion(&result.completion);
	
	req = aead_request_alloc(tfm, GFP_KERNEL);
	if (!req) {
		printk(KERN_ERR "alg: aead: Failed to allocate request for "
		       "%s\n", algo);
		goto out_tfm;
	}
	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
				  tcrypt_complete, &result);

	memset(iv, 1, MAX_IVLEN);
	crypto_aead_clear_flags(tfm, ~0);
	crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
	
	keylen = akeylen + ekeylen + RTA_SPACE(sizeof(*param));
	key = kzalloc(keylen, GFP_KERNEL);
	if (!key)
		goto out_req;

	pp = key;
	rta = (void *)pp;
	rta->rta_type = CRYPTO_AUTHENC_KEYA_PARAM;
	rta->rta_len = RTA_LENGTH(sizeof(*param));
	param = RTA_DATA(rta);
	pp += RTA_SPACE(sizeof(*param));

	if(akeylen) {
		memcpy(pp, akey, akeylen);
		pp += akeylen;
	}

	ret = crypto_aead_setauthsize(tfm, authsize);
	if (ret) {
		printk(KERN_ERR "alg: aead: Failed to set "
		       "authsize to %u on test for %s\n",
		       authsize, algo);
		goto out_key;
	}
	
	param->enckeylen = cpu_to_be32(ekeylen);
	memcpy(pp, ekey, ekeylen);
	
	ret = crypto_aead_setkey(tfm, key, keylen);
	if (ret) {
		printk(KERN_ERR "alg: aead: Failed to set "
		       "the key for %s\n",
		       algo);
		goto out_key;
	}

	sg_init_one(&src_sg, input, clen + AUTHSIZE);
	sg_init_one(&dst_sg, input, clen + AUTHSIZE);
	sg_init_one(&asg, assoc, assoclen);

	aead_request_set_crypt(req, &src_sg, &dst_sg, clen +  (testmode ? 0 : authsize), iv);

	aead_request_set_assoc(req, &asg, assoclen);
	
	ret = testmode ?
		crypto_aead_encrypt(req) :
		crypto_aead_decrypt(req);

	switch (ret) {
		case 0:
			if(!testmode)
				printk("File OK\n");
			break;
		case -EINPROGRESS:	  
		case -EBUSY:
			ret = wait_for_completion_interruptible(
				&result.completion);
			if (!ret && !(ret = result.err)) {
				INIT_COMPLETION(result.completion);
				break;
			}
		case -EBADMSG:
			printk("File corrupted\n");
		default:
			printk(KERN_ERR "alg: aead: %s failed "
						"for %s: ret=%d\n", testmode ? "encrypt" : "decrypt", algo, -ret);
	}
	
	if(ret)
		goto out_key;
	printk("%s: %d\n", testmode ? "encrypt" : "decrypt", ret);
	
	if(testmode) {
		set_fs(KERNEL_DS);

		fp = filp_open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0700);
		if(IS_ERR(fp)) {
			printk("Error opening file: %s\n", filename);
			set_fs(old_fs);
			goto out_key;
		}
		fp->f_op->write(fp, input, clen + AUTHSIZE, &fp->f_pos);
		hexdump(input + clen, AUTHSIZE);
		filp_close(fp, NULL); 
		set_fs(old_fs);
	} else {
		printk("Decrypted: %s\n", input);
	}
	kfree(input);
out_key:
	kfree(key);
out_req:
	aead_request_free(req);
out_tfm:
	crypto_free_aead(tfm);
out:

	return ret;
}

int __init testaead_start(void) {
	int ret;
	printk("--------- testing authenc: %s ---------------\n", testmode ? "encrypt" : "decrypt");
	ret = testrun();
	printk("Result: %d\n", ret);
	printk("--------------------------------------------------\n");

	return -1;
}


void __exit testaead_stop(void) {

}

module_init(testaead_start);
module_exit(testaead_stop);
MODULE_LICENSE("GPL");


--Boundary-00=_H6PiLh5Sezpallc--
