From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] use ERR_CAST
Date: Tue, 22 Jan 2013 12:29:25 +0100
Message-ID: <1358854166-3952-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18380
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab3AVK3e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jan 2013 05:29:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ERR_CAST is more concise than PTR_ERR followed by ERR_PTR.  Using it
also occasionally removes the need for an err variable.
