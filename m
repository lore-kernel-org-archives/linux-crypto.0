From: Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 0/2] Fix module autoload for OF platform drivers
Date: Tue, 15 Sep 2015 18:40:38 +0200
Message-ID: <20150915164038.GA5536@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Olof Johansson <olof@lixom.net>, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Wolfram Sang <wsa@the-dreams.de>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Corey Minyard <minyard@acm.org>,
	openipmi-developer@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36352 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbIOQkl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 12:40:41 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

These patches add the missing MODULE_DEVICE_TABLE() for OF to export
the information so modules have the correct aliases built-in and
autoloading works correctly.

A longer explanation by Javier Canillas can be found here:
https://lkml.org/lkml/2015/7/30/519

Thanks,
Luis

Luis de Bethencourt (2):
  char: hw_random: Fix module autoload for OF platform drivers
  char: ipmi: Fix module autoload for OF platform driver

 drivers/char/hw_random/pasemi-rng.c | 1 +
 drivers/char/hw_random/ppc4xx-rng.c | 1 +
 drivers/char/ipmi/ipmi_si_intf.c    | 1 +
 3 files changed, 3 insertions(+)

-- 
2.4.6
