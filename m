From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Crypto test results unused?
Date: Mon, 28 Dec 2009 19:12:50 +0100
Message-ID: <m3ws07q865.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lkml <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56026 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZL1SMx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 13:12:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

is the core crypto code supposed to "kill" algorithms which fail the
test?

On little-endian IXP4xx 3 hardware-assisted algorithms fail (due to
apparently unrelated bug which I will take care of). It seems the kernel
is still using these failing algorithms (my debugging code adds extra
fields to the /proc output):

alg: skcipher: Test 1 failed on encryption for ecb(des)-ixp4xx
00000000: 01 23 45 67 89 ab cd e7
alg: skcipher: Test 1 failed on encryption for ecb(des3_ede)-ixp4xx
00000000: 73 6f 6d 65 64 61 74 61
alg: skcipher: Test 1 failed on encryption for ecb(aes)-ixp4xx
00000000: 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff

# grep 'ecb(des)-ixp4xx\|ecb(des3_ede)-ixp4xx\|ecb(aes)-ixp4xx' /proc/cryp
to -A 6
driver       : ecb(aes)-ixp4xx
module       : ixp4xx_crypto
priority     : 300
refcnt       : 1
flags        : 0x85
ptr          : 0xbf020074
selftest     : unknown
^^^^^^^^^^^^^^^^^^^^^^
--
driver       : ecb(des3_ede)-ixp4xx
module       : ixp4xx_crypto
priority     : 300
refcnt       : 1
flags        : 0x85
ptr          : 0xbf01fe94
selftest     : unknown
--
driver       : ecb(des)-ixp4xx
module       : ixp4xx_crypto
priority     : 300
refcnt       : 1
flags        : 0x85
ptr          : 0xbf01fcb4
selftest     : unknown

I traced the problem to crypto/algapi.c:

int crypto_register_alg(struct crypto_alg *alg)
{
	struct crypto_larval *larval;
	int err;

	err = crypto_check_alg(alg);
	if (err)
		return err;

	down_write(&crypto_alg_sem);
	larval = __crypto_register_alg(alg);
	up_write(&crypto_alg_sem);

	if (IS_ERR(larval))
		return PTR_ERR(larval);

	crypto_wait_for_test(larval);

At this point alg->cra_flags includes CRYPTO_ALG_DEAD (due to failed
test), but larval->alg.cra_flags has only the original flags (0x85).

I'm not sure what's the best fix.
Currently 2.6.31.9, seems to be present in 2.6.32, too.
-- 
Krzysztof Halasa
