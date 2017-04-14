From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: allow caller to control queue length
Date: Fri, 14 Apr 2017 09:57:12 +0200
Message-ID: <20170414075711.GJ12763@secunet.com>
References: <20170413095213.23513-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:52732 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752028AbdDNH5Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2017 03:57:24 -0400
Content-Disposition: inline
In-Reply-To: <20170413095213.23513-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 13, 2017 at 11:52:13AM +0200, Jason A. Donenfeld wrote:
> Allow users of padata to determine the queue length themselves, via this
> added helper function, so that we can later remove the hard-coded 1000-
> job limit. We thus add a helper function, and then move the limiting
> functionality to pcrypt-proper, since it was the only current consumer
> relying on the 1000-job limit. We do, however, impose a limit on padata
> so that the reference count does not have an integer overflow.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Why do we need this? As long as we don't have a user that needs a
different limit, this patch adds just some useless code.
