From: jonathan.thieuleux@gmail.com
Subject: XTS and 64-bit block
Date: Wed, 6 May 2015 10:28:25 +0200
Message-ID: <20150506082825.GA13842@arch.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36221 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbbEFI23 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 04:28:29 -0400
Received: by wgiu9 with SMTP id u9so3243226wgi.3
        for <linux-crypto@vger.kernel.org>; Wed, 06 May 2015 01:28:28 -0700 (PDT)
Received: from localhost (lns-bzn-49f-62-147-175-21.adsl.proxad.net. [62.147.175.21])
        by mx.google.com with ESMTPSA id nb9sm1027645wic.10.2015.05.06.01.28.26
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 May 2015 01:28:26 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm implementing a new block cipher algorithm which is GOST 28147-89. This is a
256-bit key and 64-bit block algorithm. This algorithm works well with ECB, CBC
and CTR modes. But, when I try to use the XTS mode, the encryption fails. So I
tried to find the problem and it seems to come from the file crypto/xts.c,
function init_tfm :

	if (crypto_cipher_blocksize(cipher) != XTS_BLOCK_SIZE) {
		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
		crypto_free_cipher(cipher);
		return -EINVAL;
	}

So, I checked the value of XTS_BLOCK_SIZE which is 0x10. The snag is that the
block size of GOST is 0x8. So I changed the block value of my algorithm to 0x10,
and then I tried again with the XTS mode, and it works!

Because of what just happened, I've two questions:

Q1: Why does the GOST algorithm still work? Despite I changed the block size.
Q2: Why in the code, was the block size of XTS fixed? As far as I know,
operations modes should adapt to the size of the block cipher.


Regards,
Thanks in advance
--
Jonathan "Coldshell" Thieuleux
Mail : jonathan.thieuleux@gmail.com
IRC : coldshell [Freenode, OFTC]
Shaarli : https://links.stdcall.me/

"If you write interfaces with more than 4 or 5 function arguments, it's possible that you and I cannot be friends." -- David Miller
