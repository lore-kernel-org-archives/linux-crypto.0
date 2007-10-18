From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Crypto patches
Date: Thu, 18 Oct 2007 12:28:13 +0100
Message-ID: <200710181228.13569.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:33384 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbXJRL2V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Oct 2007 07:28:21 -0400
Received: by nf-out-0910.google.com with SMTP id g13so115181nfb
        for <linux-crypto@vger.kernel.org>; Thu, 18 Oct 2007 04:28:20 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert, Dave,

Sometime ago I sent a patch which makes twofish key setup
code much smaller (2.5 times). Currently, it is so much unrolled
that twofish module's code is ~35k on i386.

I am ok with people disagreeing with me and considering 35k
not too big. However, IIRC that patch was not reviewed
(I've got no reply) and I have no way of knowing whether
it was deemed unacceptable or just was lost in the churn.

I want to rediff and resend it. I also want to send patches
for other modules (e.g. camellia, aes).

Please let me know what is the best channels to send
crypto patches through so that they are not lost. Thanks.
--
vda
