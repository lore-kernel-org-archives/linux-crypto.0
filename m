From: "Loc Ho" <locnho@sbcglobal.net>
Subject: Async Linux NETKEY (IPSec Stack)
Date: Mon, 4 Feb 2008 10:56:27 -0800
Message-ID: <00bb01c8675f$a5872270$5c05420a@amcc.com>
References: <200801311021.24240.ak@suse.de> <20080201001218.GA13596@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:45621 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754957AbYBDS4U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Feb 2008 13:56:20 -0500
In-Reply-To: <20080201001218.GA13596@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I just want to check on the status of Linux NETKEY change to support
asynchronous Linux CryptoAPI interface. Have ESP, AH, and AEAD changes to
make use of async API?

In addition, I submitted async HASH and DIGEST patch over a week ago. Any
comments and whether it will be accepted?

Thanks,
Loc
