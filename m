From: Jorgen Lundman <lundman@lundman.net>
Subject: CCM-AES Compatibility
Date: Fri, 09 Nov 2012 12:45:33 +0900
Message-ID: <509C7C5D.20302@lundman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.lundman.net ([210.157.1.114]:33869 "EHLO mail.lundman.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab2KIDwL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2012 22:52:11 -0500
Received: from localhost (solaris11 [127.0.0.1])
	by mail.lundman.net (Postfix) with ESMTP id 29846680AE
	for <linux-crypto@vger.kernel.org>; Fri,  9 Nov 2012 12:45:35 +0900 (JST)
Received: from mail.lundman.net ([127.0.0.1])
	by localhost (mail.lundman.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mhLQ85kF1gft for <linux-crypto@vger.kernel.org>;
	Fri,  9 Nov 2012 12:45:34 +0900 (JST)
Received: from shinken.interq.or.jp (shinken.interq.or.jp [210.172.146.228])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.lundman.net (Postfix) with ESMTPSA id 3EF21680A9
	for <linux-crypto@vger.kernel.org>; Fri,  9 Nov 2012 12:45:34 +0900 (JST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hello list,

I hope it is ok to ask a question on how to use the crypto API in the Linux
kernel, even though the list appears to be mostly PATCH mails.

I am currently porting some code from Solaris kernel to Linux, which uses
"SUN_CKM_AES_CCM" mech, with ivsize of 12, and hmac computed of len 16.


Looking in tcrypt.c tester, which appears to be the only example that I can
find, I should be using AEAD. But I must admit I could not get my AEAD
example to work. My test code calls crypto_aead_encrypt() and I get -22
back (EINVAL).

http://www.lundman.net/ccm-aes-test.c

But, since ivsize is 16, and there are no API calls to change it to 12,
perhaps I will not be able to use the supplied ccm-aes? Is it a lost cause?
Will I be pasting in the entire AES sources that I need into my module?



Going over the Solaris sources, they appear to call regular AES, then call
the ccm_encrypt_final() function:

         * For CCM mode, aes_ccm_encrypt_final() will take care of any
         * left-over unprocessed data, and compute the MAC
	*/
        if (aes_ctx->ac_flags & CCM_MODE) {
                ret = ccm_encrypt_final((ccm_ctx_t *)aes_ctx, ciphertext,
                    AES_BLOCK_LEN, aes_encrypt_block, aes_xor_block);
}


Which makes me think that perhaps I can do the same on Linux. Ignore AEAD
(which I can not get to work) and use blkcipher "cbc(aes)" instead. Then
port in the ccm_encrypt_final() sources over, which calls final, and
computes the hmac. Could that work? Any examples?

I would very much appreciate some hints here,

Lund


ps. Some peculiarities that I came across are:

1) aead_request_set_assoc() takes a scatterlist *, and a length. And
scatterlist is a pointer, and length. Seems redundant, do I set both, or is
one ignored?

2) crypto_blkcipher_set_iv() takes a pointer and length, which implies you
can set the "ivsize", but length is only used in the iv copy. "->ivsize" is
not modified, and remains the original value. Is it useful to be able to
only partially set the iv?











-- 
Jorgen Lundman       | <lundman@lundman.net>
Unix Administrator   | +81 (0)3 -5456-2687 ext 1017 (work)
Shibuya-ku, Tokyo    | +81 (0)90-5578-8500          (cell)
Japan                | +81 (0)3 -3375-1767          (home)
