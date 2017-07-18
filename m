From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Tue, 18 Jul 2017 10:45:12 +0200
Message-ID: <150039607.torZXMN7kc@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <2686871.50X2Wu6ijA@positron.chronox.de> <20170718083210.GB18340@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60636 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdGRIpO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 04:45:14 -0400
In-Reply-To: <20170718083210.GB18340@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 18. Juli 2017, 10:32:10 CEST schrieb Greg Kroah-Hartman:

Hi Greg,

> external references do not last as long as the kernel change log does :(

What would be the best way to cite a 50+ page document? I got a suggestion to 
include the ASCII version of the document into Documentation/ -- but for the 
first inclusion request, I was not sure whether to add such large document.
> 
> Also a "wholesale" replacement of random.c is a major thing, why not
> just submit patches to fix it up to add the needed changes you feel are
> necessary?  We don't like to have major changes like this, that's not
> how kernel development is done.

I have to admit that I tried that over the last years. I sent numerous small 
cleanup patches (not changing any logic) and larger patches (with logic 
changes). Even after pinging, I hardly got a response to any of my patches, 
let alone that patches were accepted.

I have stated the core concerns I have with random.c in [1]. To remedy these 
core concerns, major changes to random.c are needed. With the past experience, 
I would doubt that I get the changes into random.c.

[1] https://www.spinics.net/lists/linux-crypto/msg26316.html

Ciao
Stephan
