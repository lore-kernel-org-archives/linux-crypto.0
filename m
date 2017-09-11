From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ccree: Add missing newlines
Date: Mon, 11 Sep 2017 09:25:46 -0700
Message-ID: <20170911162546.GA24534@kroah.com>
References: <250d3f881f7a02ff4a0a7650446499be48b52691.1505024246.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <250d3f881f7a02ff4a0a7650446499be48b52691.1505024246.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 09, 2017 at 11:18:02PM -0700, Joe Perches wrote:
> Logging without newlines are still prone to interleaving.
> Add newlines where necessary.

Doesn't apply to my staging-testing branch, due to other changes in this
driver.  Can you rebase it onto that branch and resend?

thanks,

greg k-h
