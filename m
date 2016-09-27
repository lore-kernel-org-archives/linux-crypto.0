From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] padata: remove recently added module usage from bool code
Date: Tue, 27 Sep 2016 11:03:06 +0200
Message-ID: <20160927090306.s5zdwvkeoo6eg5ks@linutronix.de>
References: <20160927011821.6635-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:49626 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbcI0JDN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2016 05:03:13 -0400
Content-Disposition: inline
In-Reply-To: <20160927011821.6635-1-paul.gortmaker@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016-09-26 21:18:21 [-0400], Paul Gortmaker wrote:
> 
> ...and so it currently is not being built as a module by anyone.

that is correct.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
