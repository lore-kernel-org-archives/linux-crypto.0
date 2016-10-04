From: Stephan Mueller <smueller@chronox.de>
Subject: Re: sha1_mb broken
Date: Tue, 04 Oct 2016 16:10:51 +0200
Message-ID: <2176107.gSz0A05ekE@tauon.atsec.com>
References: <1939675.7gNnqUbNs6@positron.chronox.de> <9643256.KgnRM79R5B@positron.chronox.de> <C440BA31B54DCD4AAC682D2365C8FEE703CEF891@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
To: "Dey, Megha" <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48108 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751404AbcJDOK5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2016 10:10:57 -0400
In-Reply-To: <C440BA31B54DCD4AAC682D2365C8FEE703CEF891@ORSMSX111.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 4. Oktober 2016, 00:25:07 CEST schrieb Dey, Megha:

Hi Megha,

> 
> > Hi Stephan,
> > 
> > Your test code initialized the completion structure incorrectly, that led
> > to the missing completion from being received. The init_completion call
> > should be made before the crypto_ahash_digest call. The following change

Thanks a lot for pointing that one out. Can you help me understand why your 
code trips over that issue whereas other ahash implementations do not (all 
other SHA-1 or SHA-2 implementations work perfectly fine with that code)?

Thanks again!

Ciao
Stephan
