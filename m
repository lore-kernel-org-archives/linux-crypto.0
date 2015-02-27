From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH] crypto: tcrypt speed: fix filter for aead algorithms
Date: Fri, 27 Feb 2015 13:14:20 +0200
Message-ID: <54F0518C.1040801@freescale.com>
References: <1422971988-21517-1-git-send-email-cristian.stoica@freescale.com>
 <20150227092503.GA27831@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:58592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753167AbbB0LO1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2015 06:14:27 -0500
In-Reply-To: <20150227092503.GA27831@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 02/27/2015 11:25 AM, Herbert Xu wrote:
> On Tue, Feb 03, 2015 at 03:59:48PM +0200, Cristian Stoica wrote:
>> test_aead_speed is written for sync algorithms without specifically
[...]
> Please fix it to test asynchronously instead.

Thanks for review.

I think that a fix for async aead requires a different test function as
is the case with test_cipher_speed/test_acipher_speed and also with
test_hash_speed/test_ahash_speed.

But I see a issue here with the current async tests:

int test_acipher_cycles(...)
{
  for (i = 0; i < 8; i++) {
    [...]
    ret = do_one_acipher_op(req, crypto_ablkcipher_encrypt(req));
    [...]
  }
}

and in do_one_acipher_op we wait for completion of
crypto_ablkcipher_encrypt:

if (ret == -EINPROGRESS || ret == -EBUSY) {
	struct tcrypt_result *tr = req->base.data;
	ret = wait_for_completion_interruptible(&tr->completion);
}

Doesn't this defeat the purpose of async execution?

Cristian S.
