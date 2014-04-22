From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 0/2] crypto: atmel-aes: fixes on block size of aes cfb mode
Date: Tue, 22 Apr 2014 15:23:22 +0800
Message-ID: <1398151404-23408-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas@eukrea.com>, <nicolas.ferre@atmel.com>,
	<leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:49164 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133AbaDVHar (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Apr 2014 03:30:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

These two patches correct the block size in atmel-aes driver while processing cfb8 and cfb64 mode of aes.

Thanks

Leilei Zhao (2):
  crypto: atmel-aes: correct block size of cfb8 mode
  crypto: atmel-aes: check alignment of cfb64 mode

 drivers/crypto/atmel-aes.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
1.7.9.5
