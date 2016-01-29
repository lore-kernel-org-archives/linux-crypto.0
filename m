From: Catalin Vasile <cata.vasile@nxp.com>
Subject: tcrypt bandwidth tests
Date: Fri, 29 Jan 2016 15:33:05 +0200
Message-ID: <1454074387-8321-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-owner@vger.kernel.org>, <horia.geanta@nxp.com>,
	<cristian.stoica@nxp.com>, <alexandru.porosanu@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0059.outbound.protection.outlook.com ([207.46.100.59]:2880
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752959AbcA2Nr1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 08:47:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I have attached to this e-mail a set of patches that introduce bandwitdth tests
for tcrypt.
The mindset of these patches is to send as much asynchronous jobs as possible
and, after a set period of time, to count how many of them have actually been
done.
These patches are at the stage of POC (proof of concept), as an actual flood
of asynchronous jobs should have the possibility of using multiple threads
to make requests.
