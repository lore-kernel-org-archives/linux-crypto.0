From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 01/10] staging: ccree: remove inline qualifiers
Date: Thu, 7 Dec 2017 11:28:31 +0300
Message-ID: <20171207082830.6lixeuudeagkbw6x@mwanda>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
 <1512309503-29766-2-git-send-email-gilad@benyossef.com>
 <20171204093639.7ctulxb4v2htqbmj@mwanda>
 <CAOtvUMcYuuH3ox4RLpaT5EsYUCZRxJX7vD=g7GbWjLbf3to7Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41776 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdLGI2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 03:28:54 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMcYuuH3ox4RLpaT5EsYUCZRxJX7vD=g7GbWjLbf3to7Hw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 07, 2017 at 09:00:11AM +0200, Gilad Ben-Yossef wrote:
> On Mon, Dec 4, 2017 at 11:36 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Sun, Dec 03, 2017 at 01:58:12PM +0000, Gilad Ben-Yossef wrote:
> >> The ccree drivers was marking a lot of big functions in C file as
> >> static inline for no good reason. Remove the inline qualifier from
> >> any but the few truly single line functions.
> >>
> >
> > The compiler is free to ignore inline hints...  It probably would make
> > single line functions inline anyway.
> >
> 
> Yes. I think of it more as a note to the reader: "don't add stuff to
> this function. it is meant to be short and simple".
> 

Ah.  Fine.

regards,
dan carpenter
