Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ot1-f48.google.com ([209.85.210.48]:45676 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfARA0S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 19:26:18 -0500
MIME-Version: 1.0
References: <20190117231416.111952141@linutronix.de> <20190117231501.068505479@linutronix.de>
In-Reply-To: <20190117231501.068505479@linutronix.de>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 17 Jan 2019 22:26:07 -0200
Message-ID: <CAOMZO5CsTiQV78d6ZvUBwzzU9iF8ZnCpp_O7VBrvxstZ6kNNRg@mail.gmail.com>
Subject: Re: [patch 3/9] crypto: morus - Cleanup license mess
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 17, 2019 at 9:17 PM Thomas Gleixner <tglx@linutronix.de> wrote:

> --- a/include/crypto/morus1280_glue.h
> +++ b/include/crypto/morus1280_glue.h
> @@ -1,15 +1,10 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

Shouldn't this be: /* SPDX-License-Identifier: GPL-2.0+ */ ?

At least this is the form documented in Documentation/process/license-rules.rst:

" License identifiers for licenses like [L]GPL with the 'or later' option
   are constructed by using a "+" for indicating the 'or later' option.::

      // SPDX-License-Identifier: GPL-2.0+"
