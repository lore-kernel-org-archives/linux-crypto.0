From: "Bhaskara Peela" <bhaskara.peela@broadcom.com>
Subject: Async IPSec in AH4 mode
Date: Fri, 12 Feb 2010 17:33:44 -0800
Message-ID: <197D517E3C8D504283188E2A751290E86F23A1E1D8@IRVEXCHCCR02.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1364 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab0BMBd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2010 20:33:57 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
 
I want to provide asynchronous AH4 IPSec processing for 2.6.30 kernel version.   I am planning to port asynchronous IPSec in AH mode from kernel version 2.6.33.rc6 to 2.6.30.  This involves changes in async hashing in crypto api and net/ipv4/ah4.c.  I am going through the changes between these two versions and I am not able to accurately figure out the minimum changes for AH mode between these two kernel versions.
 
Can you please guide me on dependencies that are required to support IPSec AH4 for kernel version 2.6.30?
 
thanks
bhaskara
