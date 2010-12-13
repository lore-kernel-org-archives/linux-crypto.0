From: Jeff Garzik <jeff@garzik.org>
Subject: [CRYPTO] skein hash updated
Date: Sun, 12 Dec 2010 22:41:18 -0500
Message-ID: <4D0595DE.5050903@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63113 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab0LMDlZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Dec 2010 22:41:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I've been quietly maintaining a Linux kernel implementation of the 
'skein' hash algorithm, which is one of the proposed SHA-3 algorithms. 
First posted around two years ago: 
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg02373.html

Skein is currently at version 1.3, and as slashdot readers are aware, 
skein is one of the finalists for SHA-3.

The git URL remains unchanged:  branch "skein" of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

Thanks to Tobias Karnat for recent updates, including conversion to shash.
