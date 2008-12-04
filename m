From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 0/4 v2] Switch remaining algorithms to shash
Date: Thu,  4 Dec 2008 10:32:06 +0100
Message-ID: <12283831302697-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:50113 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYLDJcM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 04:32:12 -0500
In-Reply-To: 2008120406812.GB18141@gondor.apana.org.au
References: 2008120406812.GB18141@gondor.apana.org.au
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series contains the fixed up patches to convert the remaining hash
algorithms to use the new shash interface.

The first patch is left unchanged and removes the message schedule W from
struct sha512_ctx.

The last three patches now contain the needed Kconfig dependencies.

Adrian
