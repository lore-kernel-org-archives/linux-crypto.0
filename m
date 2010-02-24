From: Roel Kluin <roel.kluin@gmail.com>
Subject: Is kernel optimized with dead store removal?
Date: Wed, 24 Feb 2010 23:13:50 +0100
Message-ID: <4B85A49E.6000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "lkml" <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212]:42312 "EHLO
	mail-ew0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab0BXWF6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2010 17:05:58 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

According to http://cwe.mitre.org/data/slices/2000.html#14 due to optimization
A call to memset() can be removed as a dead store when the buffer is not used
after its value is overwritten. Does this optimization also occur during
compilation of the Linux kernel? Then I think I may have found some
vulnerabilities. One is sha1_update() where memset(temp, 0, sizeof(temp)); may
be removed.

Roel
