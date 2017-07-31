From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: ccree: Fix format/argument mismatches
Date: Mon, 31 Jul 2017 03:17:38 -0700
Message-ID: <1501496258.22828.2.camel@perches.com>
References: <ad38ad75c09fb836cc89127e5049c7619325927d.1501433084.git.joe@perches.com>
         <CAOtvUMfru3VJiBoVrCcLYzuuJAhUOyNknH=Udjj8pAHTtCk4mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:41145 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750847AbdGaKRn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 06:17:43 -0400
In-Reply-To: <CAOtvUMfru3VJiBoVrCcLYzuuJAhUOyNknH=Udjj8pAHTtCk4mQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-07-31 at 09:39 +0300, Gilad Ben-Yossef wrote:
> On Sun, Jul 30, 2017 at 7:45 PM, Joe Perches <joe@perches.com> wrote:
> > By default, debug logging is disabled by CC_DEBUG not being defined.
> > 
> > Convert SSI_LOG_DEBUG to use no_printk instead of an empty define
> > to validate formats and arguments.
> > 
> > Fix fallout.
> > 
> > Miscellanea:
> > 
> > o One of the conversions now uses %pR instead of multiple uses of %pad
> 
> This looks great (I didn't know about no_printk) but does not seem to
> apply on top of
> staging-next.

Applies to next-20170728

b2cf822e075f7a7e7ced8c50af600f9edf5ccc31
