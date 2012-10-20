From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: cryptd - disable interrupts in
 cryptd_queue_worker to prevent data corruption
Date: Sat, 20 Oct 2012 13:43:11 -0400 (EDT)
Message-ID: <20121020.134311.245082179756055004.davem@davemloft.net>
References: <20121020091314.32511.49390.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, stable@kernel.org,
	gurucharan.shetty@gmail.com, herbert@gondor.apana.org.au
To: jussi.kivilinna@mbnet.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46448 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab2JTRnN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 13:43:13 -0400
In-Reply-To: <20121020091314.32511.49390.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


You should be disabling software interrupts, not hardware ones.
