Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfARGvB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 01:51:01 -0500
Date: Fri, 18 Jan 2019 07:50:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Subject: Re: [patch 3/9] crypto: morus - Cleanup license mess
Message-ID: <20190118065058.GA9727@kroah.com>
References: <20190117231416.111952141@linutronix.de>
 <20190117231501.068505479@linutronix.de>
 <CAOMZO5CsTiQV78d6ZvUBwzzU9iF8ZnCpp_O7VBrvxstZ6kNNRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CsTiQV78d6ZvUBwzzU9iF8ZnCpp_O7VBrvxstZ6kNNRg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 17, 2019 at 10:26:07PM -0200, Fabio Estevam wrote:
> On Thu, Jan 17, 2019 at 9:17 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > --- a/include/crypto/morus1280_glue.h
> > +++ b/include/crypto/morus1280_glue.h
> > @@ -1,15 +1,10 @@
> > -/* SPDX-License-Identifier: GPL-2.0 */
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> Shouldn't this be: /* SPDX-License-Identifier: GPL-2.0+ */ ?
> 
> At least this is the form documented in Documentation/process/license-rules.rst:
> 
> " License identifiers for licenses like [L]GPL with the 'or later' option
>    are constructed by using a "+" for indicating the 'or later' option.::
> 
>       // SPDX-License-Identifier: GPL-2.0+"

Either works, please see LICENSES/preferred/GPL-2.0

Personally, I think we should stick with the "+" version as that is the
much more prevalent use in the kernel at the moment, but it's Thomas's
call, not mine.

thanks,

greg k-h
