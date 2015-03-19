From: Andre Wolokita <andre.wolokita@analog.com>
Subject: Re: griffin u-boot failing to boot
Date: Thu, 19 Mar 2015 13:36:36 +1100
Message-ID: <550A3634.5020903@analog.com>
References: <550A2E29.6050209@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0058.outbound.protection.outlook.com ([157.56.110.58]:40651
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750837AbbCSCxV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 22:53:21 -0400
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.72.140])
	by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id t2J2avJ2006661
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2015 19:36:57 -0700
In-Reply-To: <550A2E29.6050209@analog.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 19/03/15 13:02, Andre Wolokita wrote:
> Hi guys,
>
> I'm experiencing a strange issue when booting up u-boot on my older ezkit (red board, pre-1.0). Yesterday I updated u-boot and openocd to the 1.0.0.BR tag and build u-boot. I tried running u-boot on a 1.0 ezkit but found that the board was faulty. Then I went back to using the old ezkit, booting via JTAG, init.elf, u-boot, all that stuff, and everything was still working fine. Today when I get in to work I try to boot up again and get no response over the serial connection. When I check the Griffin registers on GDB, I find that the PC doesn't move from its boot position (0x5094 or thereabouts). Basically the ezkit will no longer boot into uboot. I've tried both my LPC and HPC boards and neither work. Unfortunately I don't have access to a 1.0 board as we only have one and it is being use
 d by someone else.
>
> Any ideas?
>
> Regards,
>
> Andre.
>
Oops! Just ignore this - it was meant for the blackfin mailing list. I guess that's what happens when you haven't had your first coffee and forget that most Linux lists begin with linux-*.

-- 
Andre Wolokita (andre.wolokita@analog.com)
Design Engineer, Analog Devices Australia Pty Ltd
Unit 3, 97 Lewis Road, Wantirna, Victoria, 3152, AUSTRALIA
Direct: +61 3 9881 9933   Main: +61 3 9881 9999
Fax: +61 3 9881 9988      Web: www.analog.com/au

Embedded DSP software for multimedia & telecommunications.

This communication is proprietary and confidential. 
