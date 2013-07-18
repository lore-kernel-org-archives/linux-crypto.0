From: Joel Fernandes <joelf@ti.com>
Subject: Suggestion for 3DES driver
Date: Wed, 17 Jul 2013 22:08:29 -0500
Message-ID: <51E75C2D.40709@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40640 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab3GRDKc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 23:10:32 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id r6I3AVI6029141
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2013 22:10:31 -0500
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id r6I3AV7T032024
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2013 22:10:31 -0500
Received: from [172.24.114.172] (h114-172.vpn.ti.com [172.24.114.172])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id r6I3AUvB007265	for
 <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2013 22:10:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am working on a driver for OMAP 3DES hardware similar to OMAP AES
(drivers/crypto/omap-aes). The hardware is similar in many ways and a lot of it
can be reused from first look.

Can anyone comment if its ok to add to omap-aes, calling it
drivers/crypto/omap-aesdes. That will ensure maximum reuse and reduce LOC too.
Any other suggestions?

Thanks,

-Joel
