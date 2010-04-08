From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 0/10] crypto mv_cesa : Add sha1 and hmac(sha1) support to
 the mv_cesa driver
Date: Thu, 08 Apr 2010 19:25:15 +0300
Message-ID: <4BBE036B.8010001@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36857 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849Ab0DHQZe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:25:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a resubmission of a patchset I set a while ago, and that was corrupted by my email client.

The following patchset adds async hashing (sha1 and hmac-sha1) to the mv_cesa crypto driver. This driver utilizes the Marvell CESA crypto accelerator that exists in some Marvell CPU's (Orion and Kirkwood). The existing driver has AES crypto support.

Compared to SW hashing on a 1.2GHz Kirkwood, the HW acceleration is about 20% faster, but more importantly, at reduced CPU utilization.

The patchset is divided as follows:
- patches 1-4 are bug/warning fixes to the existing driver
- patches 5-9 refactor the existing driver with no functional change to accommodate the added functionality
- patch 10 adds the sha1 and hmac-sha1 support.

The driver requires the sha1 and hmac sw drivers in order to handle some corner cases (i.e. it never falls back on a complete request but sometimes it hashes the last 64 bytes in sw)
