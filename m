From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: crypto: Add support for the Geode AES engine
Date: Fri, 29 Sep 2006 12:53:51 +0400
Message-ID: <20060929085351.GA18626@2ka.mipt.ru>
References: <20060927193147.GA21043@cosmic.amd.com> <LYRIS-4270-86779-2006.09.28-04.27.47--jordan.crouse#amd.com@whitestar.amd.com> <20060928163115.GL25387@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org, info-linux@ldcmail.amd.com,
	akpm@osdl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:29920 "EHLO 2ka.mipt.ru")
	by vger.kernel.org with ESMTP id S1030423AbWI2IzG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Sep 2006 04:55:06 -0400
To: Jordan Crouse <jordan.crouse@amd.com>
Content-Disposition: inline
In-Reply-To: <20060928163115.GL25387@cosmic.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 28, 2006 at 10:31:15AM -0600, Jordan Crouse (jordan.crouse@amd.com) wrote:
> > As far as I can see, register access is not protected, how can your
> > driver handle the case when dm-crypt and IPsec simultaneously try to
> > encrypt/decrypt some data, it can happen even around 
> > preemt_disable/enable calls and actually crypto processing can happen 
> > in interrupt context too (although it is not the best thing to do).
> 
> I had the mutex in there, but I took it out based on our previous
> conversations, which probably was a little rash.  If CRYPTO_TFM_REQ_MAY_SLEEP
> is still a valid flag to check, I could use that along with a spin lock of
> some sort.   I'll think about this a bit more.

If it is set, then you can safely sleep there, but if it is not, it does
not always mean that sleeping is forbidden.

-- 
	Evgeniy Polyakov
