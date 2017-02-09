From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Thu, 9 Feb 2017 07:47:25 +0100
Message-ID: <20170209064725.GA4363@kroah.com>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alden Tondettar <alden.tondettar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39914 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdBIGrx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 01:47:53 -0500
Content-Disposition: inline
In-Reply-To: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 08, 2017 at 08:31:26PM -0700, Alden Tondettar wrote:
> In short, the situation is:
> 
> A) No usable hardware RNG or arch_get_random() (or we don't trust it...)

Wait, why would you not trust arch_get_random()?  Is it broken somehow
on some arches?  If so, why not fix that as well?

thanks,

greg k-h
