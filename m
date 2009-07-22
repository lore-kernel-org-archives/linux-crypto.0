From: Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: [PATCH 0/1] crypto: Undefined behaviour in crypto_aes_expand_key
Date: Wed, 22 Jul 2009 17:57:02 +0300
Message-ID: <1248274623-17158-1-git-send-email-ext-phil.2.carmody@nokia.com>
Cc: linux-crypto@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36394 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZGVO75 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 10:59:57 -0400
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The following patch applies to the current head of torvalds/linux-2.6.git.
However, due to the relatively stable nature of the only file patched, it
should apply anywhere. Apologies if there are any mail mangling issues, 
they aren't unheard of, alas, and I will resend from home if need be. 

The nitty gritty details of the undefined behaviour can be found in the C
standards documents sections:
n869.txt (C89) - 3.3.2.1 Array subscripting, and 3.3.6 Additive operators
n1256.pdf (C99) - 6.5.2.1 Array subscripting, and 6.5.6 Additive operators

I trust that the nature of the patch should be self-evident.

