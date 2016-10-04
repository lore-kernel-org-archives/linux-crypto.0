From: Stephan Mueller <smueller@chronox.de>
Subject: Re: sha1_mb broken
Date: Tue, 04 Oct 2016 18:27:16 +0200
Message-ID: <16231020.QQG8JFOdRi@tauon.atsec.com>
References: <1939675.7gNnqUbNs6@positron.chronox.de> <2176107.gSz0A05ekE@tauon.atsec.com> <1475597322.3916.283.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Dey, Megha" <megha.dey@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48120 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754191AbcJDQ1V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2016 12:27:21 -0400
In-Reply-To: <1475597322.3916.283.camel@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 4. Oktober 2016, 09:08:42 CEST schrieb Tim Chen:

Hi Tim,

> There is a spin lock protecting the completion's wait_queue on the processes
> waiting for the completion of the job, and the queue head.  My suspicion is
> if these structures are not initialized properly, we fail to look up the
> waiting process in the queue properly to call it.  For the other tested
> cases, they may not be a true ahash operation in the sense of passing
> request through the crypto daemon, and have to context switch to let crypto
> daemon complete the job.  The computation proceeds
> and returns in the same call chain.

Thanks a lot for the clarification.

Ciao
Stephan
