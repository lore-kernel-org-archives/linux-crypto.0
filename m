From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: crypto ahash error handling
Date: Mon, 08 Nov 2010 10:48:30 +0200
Message-ID: <4CD7B95E.9040501@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:52748 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860Ab0KHIr5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Nov 2010 03:47:57 -0500
Received: from [172.21.40.64] (esdhcp04064.research.nokia.com [172.21.40.64])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA88lriR030671
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Mon, 8 Nov 2010 10:47:55 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

When using crypto ahash API, is it necessary/mandatory to call
crypto_ahash_final() if crypto_ahash_update() returns error...

Basically it might happen after several calls while calculating hash if
HW error happens.
It is not possible to continue hash calculation. it is necessary to
reset HW and start whole hash again..

Any comments?

Thanks,
Dmitry
