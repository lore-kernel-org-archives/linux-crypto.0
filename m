From: Andre Wolokita <andre.wolokita@analog.com>
Subject: griffin u-boot failing to boot
Date: Thu, 19 Mar 2015 13:02:17 +1100
Message-ID: <550A2E29.6050209@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>,
	"Wu, Aaron" <Aaron.Wu@analog.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:52453
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbbCSCTR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 22:19:17 -0400
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.72.140])
	by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id t2J22jrv005032
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2015 19:02:45 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi guys,

I'm experiencing a strange issue when booting up u-boot on my older ezkit (red board, pre-1.0). Yesterday I updated u-boot and openocd to the 1.0.0.BR tag and build u-boot. I tried running u-boot on a 1.0 ezkit but found that the board was faulty. Then I went back to using the old ezkit, booting via JTAG, init.elf, u-boot, all that stuff, and everything was still working fine. Today when I get in to work I try to boot up again and get no response over the serial connection. When I check the Griffin registers on GDB, I find that the PC doesn't move from its boot position (0x5094 or thereabouts). Basically the ezkit will no longer boot into uboot. I've tried both my LPC and HPC boards and neither work. Unfortunately I don't have access to a 1.0 board as we only have one and it is being used 
 by someone else.

Any ideas?

Regards,

Andre.

-- 
Andre Wolokita (andre.wolokita@analog.com)
Design Engineer, Analog Devices Australia Pty Ltd
Unit 3, 97 Lewis Road, Wantirna, Victoria, 3152, AUSTRALIA
Direct: +61 3 9881 9933   Main: +61 3 9881 9999
Fax: +61 3 9881 9988      Web: www.analog.com/au

Embedded DSP software for multimedia & telecommunications.

This communication is proprietary and confidential. 
