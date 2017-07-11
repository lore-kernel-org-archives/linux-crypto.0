From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/10] Fix alignment issues in staging/ccree
Date: Tue, 11 Jul 2017 19:00:33 +0200
Message-ID: <20170711170033.GA22803@kroah.com>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org
To: Simon =?iso-8859-1?Q?Sandstr=F6m?= <simon@nikanor.nu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755512AbdGKRAg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 13:00:36 -0400
Content-Disposition: inline
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 02, 2017 at 01:25:45AM +0200, Simon Sandström wrote:
> Fixes a total of 195 alignment issues in staging/ccree reported by
> checkpatch.pl. Adds a few "line over 80 characters" warnings as a
> result of the realignments, but I could try to get rid of them in the
> same patchset if needed.

Not all of these applied, some did, if you could rebase the remaining
against my staging-testing branch at the moment, and resend, that would
be great.

thanks,

greg k-h
