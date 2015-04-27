From: Martin Fuzzey <mfuzzey@parkeon.com>
Subject: Sahara performance on i.MX53
Date: Mon, 27 Apr 2015 19:16:22 +0200
Message-ID: <553E6EE6.2050803@parkeon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: linux-crypto@vger.kernel.org,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36522 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbbD0RQZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 13:16:25 -0400
Received: by wgen6 with SMTP id n6so123332747wge.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2015 10:16:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I've been trying the Sahara crypto module on i.MX53 [mainline 3.19 
kernel + b251638c46a (crypto: sahara - use the backlog)]

I tested using dm-crypt with AES-128:
cryptsetup -v  --key-size=128 luksFormat /dev/mmcblk0p7
cryptsetup luksOpen /dev/mmcblk0p7 cryptotest

dd if=/dev/mapper/cryptotest of=/dev/null bs=1M count=100


CPU Freq (MHz)       Time (s) WITHOUT Sahara        Time (s) WITH Sahara
1200                          3.26         5.34
1000                          3.26         5.62
800                            4.0           6.24
400                            7.72         9.86
166                            18.42       18.87

I was hoping for something better.
There is a reduction in CPU usage as expected but the performance 
figures aren't looking very good.
As this is in kernel use by dm-crypt cryptodev or af_alg aren't involved.

Has anyone else done any measurements?

Something wrong with my setup or with my expectations?

Regards,

Martin
