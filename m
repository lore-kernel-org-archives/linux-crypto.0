From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: get_next is never NULL
Date: Fri, 14 Apr 2017 09:46:43 +0200
Message-ID: <20170414074643.GH12763@secunet.com>
References: <20170411091601.GA24844@mwanda>
 <20170412084019.16190-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-crypto@vger.kernel.org>, <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:52640 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751502AbdDNHqs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2017 03:46:48 -0400
Content-Disposition: inline
In-Reply-To: <20170412084019.16190-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 12, 2017 at 10:40:19AM +0200, Jason A. Donenfeld wrote:
> Per Dan's static checker warning, the code that returns NULL was removed
> in 2010, so this patch updates the comments and fixes the code
> assumptions.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

This looks ok,

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
