From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 0/4] Switch remaining algorithms to shash
Date: Thu,  4 Dec 2008 01:18:08 +0100
Message-ID: <12283498922490-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:40688 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYLDASR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 19:18:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series converts the remaining hash algorithms to use the new shash
interface.

The first patch removes the message schedule W from struct sha512_ctx
since it gets calculated anew on each execution of sha512_transform. This
reduces the size of sha512_ctx considerably and will allow it to be
registered as a shash algorithm (it will pass the size check in
crypto_register_shash (crypto/shash.c:490)).
Herbert, could you explain why descsize must be smaller (or equal)
than PAGE_SIZE / 8?

The next two patches switch sha512 and wp512 to the new shash interface.

The fourth patch is another try to convert michael_mic. The key values
l and r are duplicated in the descriptor part since they are used and
changed during the actual transformation. I would be gratefull for
comments on this patch since I am not sure it's the proper way to do it.

Adrian
