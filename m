From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/4] net: esp: check CRYPTO_TFM_REQ_DMA flag when
 allocating crypto request
Date: Sat, 14 Mar 2015 14:27:47 -0400 (EDT)
Message-ID: <20150314.142747.1227972959046492974.davem@davemloft.net>
References: <1426266922-31679-1-git-send-email-horia.geanta@freescale.com>
	<20150313.154608.548532696978553073.davem@davemloft.net>
	<550426A5.4090603@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org, kim.phillips@freescale.com
To: horia.geanta@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:35146 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbbCNS1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Mar 2015 14:27:51 -0400
In-Reply-To: <550426A5.4090603@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Horia Geant=E3 <horia.geanta@freescale.com>
Date: Sat, 14 Mar 2015 14:16:37 +0200

> However, ESP is not using aead_request_alloc().

Then find a way to adjust it to do so.
