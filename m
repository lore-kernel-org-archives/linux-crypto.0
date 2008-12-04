From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 0/4 v3] Switch remaining algorithms to shash
Date: Thu,  4 Dec 2008 23:43:44 +0100
Message-ID: <12284306281986-git-send-email-ken@codelabs.ch>
References: <20081204100543.GA19425@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:54594 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYLDWnv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 17:43:51 -0500
In-Reply-To: <20081204100543.GA19425@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series contains the fixed up patches to convert the remaining hash
algorithms to use shash.

The first patch now moves the message schedule W from struct sha512_ctx to
a static percpu area.

The sha512 patch is adjusted to accomodate the changes from patch 1 while
the last two patches remain unchanged since v2.

Adrian
