From: Uri Simchoni <uris@ctera.com>
Subject: Async hash reentrancy
Date: Mon, 1 Mar 2010 23:35:04 -0500
Message-ID: <DDB181A6E7B893429D83CAC8DDBA74F1076A199007@VMBX108.ihostexchange.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.54]:4757 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0CBEk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Mar 2010 23:40:27 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'd like to add sha1/hmac-sha1 support to the Marvell CESA driver. I couldn't see an ahash driver that I can use as a reference. Is there such a driver?

There's a thing I'm not sure I understand, and that's the init-update-final mechanism. I know what it's for (as in other APIs, e.g. OpenSSL), but I'm not sure how it's supposed to work asynchronously.

Assuming the client code is using the init->update->final sequence (and not just the digest call):
- Should it be using it on the same ahash_request object? (probably yes - that's the whole point...)
- If the same ahash_request object is used, it means the driver has to save the SG info per such call, it cannot simply queue the ahash_request as is often done in crypto drivers, right? I mean, the req->src is changing between crypto_ahash_update() calls.
- Same for callback? (.complete pointer)

Thanks,
Uri.
