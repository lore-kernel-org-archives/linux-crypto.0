From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: cryptd - disable interrupts in
 cryptd_queue_worker to prevent data corruption
Date: Sun, 21 Oct 2012 00:24:38 +0300
Message-ID: <20121021002438.18361lrqj69x27c0@www.dalek.fi>
References: <20121020091314.32511.49390.stgit@localhost6.localdomain6>
 <20121020.134311.245082179756055004.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, gurucharan.shetty@gmail.com,
	herbert@gondor.apana.org.au
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:52065 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2JTVYl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 17:24:41 -0400
In-Reply-To: <20121020.134311.245082179756055004.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting David Miller <davem@davemloft.net>:

>
> You should be disabling software interrupts, not hardware ones.
>

Ok, I'll roll out v2.

-Jussi
