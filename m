From: Ambarus Tudor-Dan-B38632 <b38632@freescale.com>
Subject: variable iv lengths for aes-gcm
Date: Thu, 18 Jun 2015 10:43:18 +0300
Message-ID: <55827696.20704@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:61536
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753360AbbFRH7a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 03:59:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I'm trying to find a method to pass IVs of various lengths to an 
algorithm. A particular case would be aes-gcm IV. It can have any number 
of bits between 1 and 2^64.

A possible way to do this is to set the ivlen per request. Are there any 
(better) ways to do this?

Thanks,
ta
