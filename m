From: Stephan Mueller <smueller@chronox.de>
Subject: Re: BUG in recvmsg using io_submit
Date: Thu, 08 Sep 2016 17:50:27 +0200
Message-ID: <3413258.xKvWDEuyhD@tauon.atsec.com>
References: <2637498.CLV37KecV5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47902 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcIHPud (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2016 11:50:33 -0400
In-Reply-To: <2637498.CLV37KecV5@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 8. September 2016, 04:52:08 CEST schrieb Stephan Mueller:

Hi,

> Hi Herbert,
> 
> another one, different than the first report

Please note that the error seems to be triggered due to a bad use of the user 
space interface: When submitting the iov, I told the kernel that iovlen is the 
size of the buffer instead of the number of iovs.

Ciao
Stephan
