From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 0/2 v4] Switch remaining algorithms to shash
Date: Sun,  7 Dec 2008 23:17:27 +0100
Message-ID: <1228688249887-git-send-email-ken@codelabs.ch>
References: <20081207113302.GB13736@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:42638 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYLGWRd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 17:17:33 -0500
In-Reply-To: <20081207113302.GB13736@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This resend contains the fixed up sha512 patches to switch the last
remaining algorithm to shash.

The first patch is now correct also in the case of preemption. The
second patch remains unchanged.

Adrian
