From: avital sela <avitalsela95@gmail.com>
Subject: converting sync driver to async
Date: Tue, 16 Feb 2010 18:06:37 +0200
Message-ID: <311e0d1f1002160806j37c8d358xe3bc83805adee176@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56306 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab0BPQLz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 11:11:55 -0500
Received: by bwz19 with SMTP id 19so4518260bwz.28
        for <linux-crypto@vger.kernel.org>; Tue, 16 Feb 2010 08:11:53 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I have written sha and aes HW accelerator drivers for our custom
drivers (thanks for your patient help) and they work great.
To exploit the full potential of the HW I want to port them to the
ASYNC interface and have some questions.
1. Using my current setup I see the following results (measured with iperf)
no ipsec  -85 mbits
ESP in tunnel mode with null algs  - 45 mbits
ESP in tunnel mode with aes and sha1 - 32 mbits
Is it reasonable to have the throughput drop so much even without any
actual crypto going on? Can this mostly be attributed to the bigger
packets ?
My understanding of the results is that the maximum throughput I can
hope to achieve on this systen by only improving the crypto drivers is
45 mbits?
2. Is there any comparison somewhere between OCF performance and Acrypto?
3. Using drivers/crypto/talitos as a reference I am setting the alg
name to "authenc(hmac(sha1),cbc(aes))",cra_flags to
CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
   and cra_type to &crypto_aead_type. My existing driver had a
cra_list field. Is that required for this type of driver as well?

Thanks,
Avital
