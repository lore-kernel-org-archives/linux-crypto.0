From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 00/27] crypto: fixes for omap family of devices
Date: Wed, 22 Jun 2016 16:23:33 +0300
Message-ID: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:36713 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbcFVNY4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:24:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Changes compared to v1 of the series:

- dropped first patch from the series (crypto: omap-aes: Fix registration of
  algorithms) as it was queued by Herbert already
- modified the second (now first) patch of the series to use runtime auto-
  suspend instead of getting static sync over a cra lifetime
- re-ordered the DTS / hwmod changes in the series, the merge order of
  these must be maintained to avoid issues

Patches #01 .. #14 should be merged via crypto tree, the rest should be
handled by Tony.

Merging the omap / dts parts can be done safely separately, assuming
you just use omap2plus_defconfig (enabling crypto features will
cause some issues without the driver level fixes.)

- Tero
