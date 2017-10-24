From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH] staging: ccree: Fix lines longer than 80 characters
Date: Tue, 24 Oct 2017 14:02:45 +1100
Message-ID: <20171024030245.GC1429@eros>
References: <20171023145318.8748-1-stephen@brennan.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Stephen Brennan <stephen@brennan.io>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59533 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751282AbdJXDCt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 23:02:49 -0400
Content-Disposition: inline
In-Reply-To: <20171023145318.8748-1-stephen@brennan.io>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 23, 2017 at 07:53:18AM -0700, Stephen Brennan wrote:
> Simply break down some long lines and tab-indent them.

Hi Stephen,

Welcome to the Linux kernel. Great that you have put in a patch, you are, however, unlikely to see
success fixing 'line over 80' warnings. There are a bunch of arguments for and against the line over
80 limit, a web search will surely show them to you. The TL;DR is that it these changes do not
_really_ improve the readability of the code, they are just changes to quiet the static analysis
tool.

There are a bunch of other white space fixes that are more beneficial, perhaps you could wet your
feet with these (incorrect placement of parenthesis for example).

Good luck,
Tobin.
