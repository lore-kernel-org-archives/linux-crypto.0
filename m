From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 00/24] staging: ccree: more cleanup patches
Date: Tue, 14 Nov 2017 12:48:18 +0300
Message-ID: <20171114094818.rlwnetzq5qrgsntj@mwanda>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
 <20171113183339.pdegwo7xexfucvs2@mwanda>
 <CAOtvUMdcFo80GCqQU9q9W7sEGK9fZUEykW59sgJMtFU59=1M_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31404 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754382AbdKNJsj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 04:48:39 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMdcFo80GCqQU9q9W7sEGK9fZUEykW59sgJMtFU59=1M_w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 14, 2017 at 11:33:20AM +0200, Gilad Ben-Yossef wrote:
> On Mon, Nov 13, 2017 at 8:33 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > These cleanups look nice.  Thanks.
> >
> > I hope you do a mass remove of likely/unlikely in a patch soon.
> > Whenever, I see one of those in a + line I always have to remind myself
> > that you're planning to do it in a later patch.
> >
> 
> So, a question about that - there indeed seems to be an inflation of
> likely/unlikely in the ccree driver, but
> what stopped me from removing them was that I found out I don't have a
> clue about when it's a good idea
> to use them and when it isn't (obviously in places where you know the
> probable code flow of course).
> 
> Any hints?

They should only be included if benchmarking shows that it makes a
difference.  I think they need to be about 100 right predictions to 1
wrong prediction on a fast path.  So remove them all and add them back
one at a time.


regards,
dan carpenter
