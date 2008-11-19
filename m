From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [HIFN] Bugfix series.
Date: Wed, 19 Nov 2008 17:03:25 +0300
Message-ID: <12271034133347-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37381 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753984AbYKSOHy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This series contains HIFN driver fixes based on Patrick McHardy's work
and additional queue management fix. This set also bumps HIFN performance
almost two times compared to old code. Please apply.
