From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging/ccree: Declare compiled out fuctions static
 inline
Date: Wed, 16 Aug 2017 15:09:09 -0700
Message-ID: <20170816220909.GB29988@kroah.com>
References: <1501492643-7087-1-git-send-email-rishabheudyptula@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        RishabhHardas <rishabhhardas@gmail.com>
To: RishabhHardas <rishabheudyptula@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbdHPWJI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 18:09:08 -0400
Content-Disposition: inline
In-Reply-To: <1501492643-7087-1-git-send-email-rishabheudyptula@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 31, 2017 at 02:47:23PM +0530, RishabhHardas wrote:
> From: RishabhHardas <rishabhhardas@gmail.com>
> 
> Sparse was giving out a warning for symbols 'cc_set_ree_fips_status' and 'fips_handler'
> that they were not declared and need to be made static. This patch makes both the symbols
> static inline, to remove the warnings.
> 
> Signed-off-by: RishabhHardas <rishabhhardas@gmail.com>

I doubt you sign your name on legal documents without a ' ' somewhere in
it :(

Please fix up and resend.

thanks,

greg k-h
