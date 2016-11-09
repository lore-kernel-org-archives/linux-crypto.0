From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/14] Revert "crypto: caam - get rid of tasklet"
Date: Thu, 10 Nov 2016 00:19:56 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1611100018170.3501@nanos>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com> <1478681184-9442-12-git-send-email-horia.geanta@nxp.com> <20161109085322.GY1041@n2100.armlinux.org.uk> <alpine.DEB.2.20.1611092358390.3501@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: =?ISO-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59548 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbcKIXWf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 18:22:35 -0500
In-Reply-To: <alpine.DEB.2.20.1611092358390.3501@nanos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 10 Nov 2016, Thomas Gleixner wrote:
> > > which corresponds to an 8% slowdown for the threaded IRQ case.  So,
> > > tasklets are indeed faster than threaded IRQs.

Forgot to say, that this should be:

  So, tasklets are indeed faster than threaded IRQs for this particular use
  case. They are not generally faster.

Thanks,

	tglx
