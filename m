From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 00/24] staging: ccree: more cleanup patches
Date: Tue, 14 Nov 2017 11:33:20 +0200
Message-ID: <CAOtvUMdcFo80GCqQU9q9W7sEGK9fZUEykW59sgJMtFU59=1M_w@mail.gmail.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com> <20171113183339.pdegwo7xexfucvs2@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:45855 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751887AbdKNJdV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 04:33:21 -0500
Received: by mail-oi0-f47.google.com with SMTP id e142so5452616oih.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2017 01:33:21 -0800 (PST)
In-Reply-To: <20171113183339.pdegwo7xexfucvs2@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 13, 2017 at 8:33 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> These cleanups look nice.  Thanks.
>
> I hope you do a mass remove of likely/unlikely in a patch soon.
> Whenever, I see one of those in a + line I always have to remind myself
> that you're planning to do it in a later patch.
>

So, a question about that - there indeed seems to be an inflation of
likely/unlikely in the ccree driver, but
what stopped me from removing them was that I found out I don't have a
clue about when it's a good idea
to use them and when it isn't (obviously in places where you know the
probable code flow of course).

Any hints?

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
