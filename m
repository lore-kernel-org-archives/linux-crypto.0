From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v3 PATCH] crypto: aesni - Convert rfc4106 to new AEAD interface
Date: Mon, 01 Jun 2015 11:44:22 +0200
Message-ID: <5138754.L8j0JzbJL1@tachyon.chronox.de>
References: <20150528140311.GA8423@gondor.apana.org.au> <2306645.epOL7FXtYn@tauon> <20150601090951.GA12317@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58397 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbFAJoZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:44:25 -0400
In-Reply-To: <20150601090951.GA12317@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 1. Juni 2015, 17:09:51 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jun 01, 2015 at 11:04:39AM +0200, Stephan Mueller wrote:
> > Just FYI: when testing rfc4106(gcm(aes-aesni)) with the old givcipher API,
> > I got a crash in my code invoking the cipher which used to work in older
> > kernels and which works with the C implementations. So, there must be
> > some change in how givcipher is treated by the AESNI implementation.
> > 
> > As this API is sunset now, shall I dig deeper or shall we simply
> > deactivate
> > the API entirely?
> 
> What do you mean by the old givcipher API? Are you referring to the
> old algif_aead that was disabled?

I am referring to the crypto_aead_givencrypt in-kernel API.

Before the big change, the RFC4106 ciphers could be used with the standard 
crypto_aead_encrypt API calls where the caller must provide the IV. When using 
the crypto_aead_givencrypt, the IV was generated using the seqiv.

When testing the current code base with the old crypto_aead_givencrypt API 
call, I get the following results: using rfc4106(gcm(aes-asm)) with the old 
API works just fine. Using rfc4106(gcm(aes-aesni)) with the very same code 
crashes somewhere in my code.

> 
> Can you show me the crash that you got and as much information as
> you can about the caller that triggered the crash?

Again, the caller is my out-of tree crypto API test harness.

That code crashes with the following stacktrace:

[ 2000.433502] BUG: unable to handle kernel NULL pointer dereference at           
(null)
[ 2000.433505] IP: [<          (null)>]           (null)
[ 2000.433508] PGD 44aa5067 PUD 7c2d3067 PMD 0 
[ 2000.433511] Oops: 0010 [#3] SMP 
[ 2000.433514] Modules linked in: kcapi_cavs(OE) ctr ghash_generic gcm ecb cbc 
sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 sha1_generic 
nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT 
nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 ebtable_nat ebtable_broute 
bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security 
ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security 
iptable_raw crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel 
aesni_intel aes_x86_64 glue_helper ablk_helper joydev microcode virtio_balloon 
serio_raw pcspkr acpi_cpufreq i2c_piix4 virtio_blk qxl virtio_net 
drm_kms_helper ttm drm virtio_pci virtio_ring virtio [last unloaded: 
kcapi_cavs]
[ 2000.433550] CPU: 0 PID: 12614 Comm: perl Tainted: G      D    OE   4.0.0+ 
#228
[ 2000.433552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.8.1-20150318_183358- 04/01/2014
[ 2000.433554] task: ffff88007beaee80 ti: ffff880001bcc000 task.ti: 
ffff880001bcc000
[ 2000.433556] RIP: 0010:[<0000000000000000>]  [<          (null)>]           
(null)
[ 2000.433558] RSP: 0018:ffff880001bcfd20  EFLAGS: 00010206
[ 2000.433560] RAX: ffff8800363a5040 RBX: ffff88007c59e800 RCX: 
0200000000000000
[ 2000.433561] RDX: ffffffffa02e2280 RSI: ffffffffa02e051c RDI: 
ffff880064291c00
[ 2000.433563] RBP: ffff880001bcfde8 R08: 00000000000191e0 R09: 
ffff880001bcfd40
[ 2000.433564] R10: ffffffff811636d1 R11: 0000000000000006 R12: 
ffff880064291c00
[ 2000.433566] R13: ffff8800363a5000 R14: 0000000000000000 R15: 
0000000000000010
[ 2000.433568] FS:  00007f7b0e85f700(0000) GS:ffff88007fc00000(0000) 
knlGS:0000000000000000
[ 2000.433570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2000.433571] CR2: 0000000000000000 CR3: 000000007bc7d000 CR4: 
00000000000407f0
[ 2000.433577] Stack:
[ 2000.433579]  ffffffffa02de986 ffff880001bcfd40 0200000000000000 
0000000000eaee80
[ 2000.433582]  ffffea000005b002 0000002000000000 0000000000000000 
0000000000000000
[ 2000.433585]  ffffea000005c802 0000000800000000 0000000000000000 
0000000000000000
[ 2000.433587] Call Trace:
[ 2000.433593]  [<ffffffffa02de986>] ? kccavs_test_aead_givenc+0x226/0x3b0 
[kcapi_cavs]
[ 2000.433597]  [<ffffffffa02ddf17>] kccavs_data_read+0xf7/0x130 [kcapi_cavs]
[ 2000.433602]  [<ffffffff811a9928>] __vfs_read+0x28/0xc0
[ 2000.433605]  [<ffffffff81294324>] ? security_file_permission+0x84/0xa0
[ 2000.433607]  [<ffffffff811a9ff3>] ? rw_verify_area+0x53/0x100
[ 2000.433609]  [<ffffffff811aa12a>] vfs_read+0x8a/0x140
[ 2000.433612]  [<ffffffff811aab56>] SyS_read+0x46/0xb0
[ 2000.433616]  [<ffffffff8104a0f7>] ? trace_do_page_fault+0x37/0xb0
[ 2000.433620]  [<ffffffff816877ee>] system_call_fastpath+0x12/0x71
[ 2000.433622] Code:  Bad RIP value.
[ 2000.433625] RIP  [<          (null)>]           (null)
[ 2000.433627]  RSP <ffff880001bcfd20>
[ 2000.433628] CR2: 0000000000000000
[ 2000.433630] ---[ end trace d4df29cff525b7a9 ]---

The entire code that triggers the crash is the following:

#ifndef NEWAEAD
/* tie all data structures together */
struct kccavs_givaead_def {
	struct crypto_aead *tfm;
	struct aead_givcrypt_request *req;
	struct kccavs_tcrypt_res result;
};

/* Perform encryption */
static unsigned int kccavs_givaead_enc(struct kccavs_givaead_def *aead)
{
	int rc = crypto_aead_givencrypt(aead->req);

	switch (rc) {
	case 0:
		break;
	case -EINPROGRESS:
	case -EBUSY:
		rc = wait_for_completion_interruptible(&aead-
>result.completion);
		if (!rc && !aead->result.err) {
#ifdef OLDASYNC
			INIT_COMPLETION(aead->result.completion);
#else
			reinit_completion(&aead->result.completion);
#endif
			break;
		}
	default:
		dbg(DRIVER_NAME": aead cipher operation returned with %d 
result"
		    " %d\n",rc, aead->result.err);
		break;
	}
	init_completion(&aead->result.completion);

	return rc;
}
#endif

/*
 * GIV AEAD encryption
 * input: type
 * input: name
 * input: plaintext / ciphertext in kccavs_test->data
 * input: AuthTag is appended to ciphertext
 * input: Authsize
 * input: key in kccavs_test->key
 * input: associated data in kccavs_test->aead_assoc
 * output: ciphertext / plaintext in kccavs_test->data
 * output: IV in kccavs_test->iv
 *
 * Note: for decryption, the data->data will contain deadbeef if the
 *	 authentication failed.
 */
static int kccavs_test_aead_givenc(size_t nbytes)
{
	int ret = -EFAULT;

	struct crypto_aead *tfm = NULL;
#ifdef NEWAEAD
	struct kccavs_aead_def aead;
	struct aead_request *req = NULL;
	struct scatterlist sg[3];
#else
	struct kccavs_givaead_def aead;
	struct aead_givcrypt_request *req = NULL;
	struct scatterlist sg;
	struct scatterlist assocsg;
#endif
	struct kccavs_data *data = &kccavs_test->data;
	struct kccavs_data *key = &kccavs_test->key;
	struct kccavs_data *iv = &kccavs_test->iv;
	struct kccavs_data *aead_assoc = &kccavs_test->aead_assoc;
	u32 authsize = kccavs_test->aead_authsize;

	/* data will hold plaintext and tag */
	if (kccavs_test->type & TYPE_ENC &&
	    data->len + authsize > MAXDATALEN)
		return -ENOSPC;

	tfm = crypto_alloc_aead(kccavs_test->name, 0, 0);
	if (IS_ERR(tfm)) {
		pr_info("could not allocate aead handle for %s %ld\n",
			kccavs_test->name, PTR_ERR(tfm));
		return PTR_ERR(tfm);
	}

#ifdef NEWAEAD
	req = aead_request_alloc(tfm, GFP_KERNEL);
#else
	req = aead_givcrypt_alloc(tfm, GFP_KERNEL);
#endif
	if (IS_ERR(req)) {
		pr_info("could not allocate request queue\n");
		ret = PTR_ERR(req);
		goto out;
	}

	ret = crypto_aead_setkey(tfm, key->data, key->len);
	if (ret) {
		pr_info("key could not be set %d\n", ret);
		goto out;
	}

	ret = crypto_aead_setauthsize(tfm, authsize);
	if (ret) {
		pr_info("authsize %u could not be set %d\n", authsize, ret);
		ret = -EAGAIN;
		goto out;
	}

	aead.tfm = tfm;
	aead.req = req;

#ifdef NEWAEAD
	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
				  kccavs_aead_cb, &aead.result);
#else
	aead_givcrypt_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
				  kccavs_aead_cb, &aead.result);
#endif

#ifdef NEWAEAD
	iv->len = crypto_aead_ivsize(aead.tfm);
	sg_init_table(sg, 3);
	sg_set_buf(&sg[0], aead_assoc->data, aead_assoc->len);
	sg_set_buf(&sg[1], iv->data, iv->len);
	sg_set_buf(&sg[2], data->data, data->len +
		   (kccavs_test->type & TYPE_ENC ? authsize : 0));
	aead_request_set_ad(req, aead_assoc->len);
	aead_request_set_crypt(req, sg, sg, data->len + iv->len, iv->data);
#else
	sg_init_one(&sg, data->data, data->len +
		    ((kccavs_test->type & TYPE_ENC) ? authsize : 0));
	sg_init_one(&assocsg, aead_assoc->data, aead_assoc->len);
	aead_givcrypt_set_assoc(req, &assocsg, aead_assoc->len);
	iv->len = crypto_aead_ivsize(aead_givcrypt_reqtfm(req));
	/*
	 * The IV pointer for AEAD is moved behind the IV value to be 
generated
	 * by seqiv - regardless of what is found there, it will be 
overwritten
	 * by seqiv. Moreover, we do not care what is found there as the
	 * seqiv generated IV is stored in iv->data anyhow.
	 */
	aead_givcrypt_set_crypt(req, &sg, &sg, data->len, iv->data);

	sg_init_one(&sg, data->data, data->len +
		    ((kccavs_test->type & TYPE_ENC) ? authsize : 0));

	/*
	 * The IV pointer for the seqiv generated IV is iv->data to allow
	 * it to be extracted with the IV debugfs read function
	 *
	 * We use a sequence number starting at 0 as defined by RFC4303
	 */
	aead_givcrypt_set_giv(req, iv->data, 0);
#endif

	init_completion(&aead.result.completion);

	if (kccavs_test->type & TYPE_ENC) {
#ifdef NEWAEAD
		ret = kccavs_aead_encdec(&aead, 1);
#else
		ret = kccavs_givaead_enc(&aead);
#endif
		/* data now contains ciphertext and concatenated tag */
		data->len += authsize;
		if (0 > ret) {
			pr_info("AEAD encryption failed: %d\n", ret);
		}
	} else {
		pr_err("AEAD: givcrypt is only intended for encrypt\n");
	}

out:
	if (tfm)
		crypto_free_aead(tfm);
	if (req)
#ifdef NEWAEAD
		aead_request_free(req);
#else
		aead_givcrypt_free(req);
#endif
	return ret;
}

-- 
Ciao
Stephan
