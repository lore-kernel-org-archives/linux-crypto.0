From: Stephan Mueller <smueller@chronox.de>
Subject: ATH9K RNG
Date: Mon, 23 May 2016 12:26:12 +0200
Message-ID: <4722005.7KY1oJgCp9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: miaoqing@codeaurora.org, kvalo@qca.qualcomm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39798 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbcEWK0Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 06:26:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Miaoqing, Kalle,

considering the patch ed14dc0af7ccea867b479feb88efdfe43ca2a0f9 which adds the 
invocation of add_hwgenerator_randomness to the ATH9K driver, may I ask about 
more details about how you concluded that the data from the ATH chip is 
entropic?

In addition, can you please elaborate on the ATH9K_RNG_ENTROPY macro? I am 
wondering about the multiplication of 320. If I understand the code right, the 
return code of ath9k_rng_data_read returns the number of u32 values read from 
the device, i.e. at most 320. With the ATH9K_RNG_ENTROPY macro, that return 
value is multiplied by 320 (bytes?) converted into bits. I.e. it sounds to be 
that the macro returns 320 u32 values times 320 bytes converted into bits. I 
am wondering whether the macro should rather read  (((x) * 8 * 32) >> 10) -- 
i.e. at most the entire array size holding the data in bits divided by 1024?

Ciao
Stephan
