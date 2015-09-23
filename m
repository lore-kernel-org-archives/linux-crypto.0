From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: dma_map_sg can handle chained SG
Date: Wed, 23 Sep 2015 13:55:24 +0200
Message-ID: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35810 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbbIWLzg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Sep 2015 07:55:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hello

Some drivers use two dma_map_sg path according to SG are chained or not.
Since dma_map_sg can handle both case, this patch series clean all code
with references to sg chained.

Note that I could only compile test sahara and caam patch.
And none could be tested due to lack oh hardware.

Regards

LABBE Corentin
