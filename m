From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC] crypto: Add support for the Geode AES engine
Date: Thu, 28 Sep 2006 14:23:37 +0400
Message-ID: <20060928102337.GB23342@2ka.mipt.ru>
References: <20060927193147.GA21043@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org, info-linux@ldcmail.amd.com,
	akpm@osdl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56518 "EHLO 2ka.mipt.ru")
	by vger.kernel.org with ESMTP id S1031364AbWI1KYJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Sep 2006 06:24:09 -0400
To: Jordan Crouse <jordan.crouse@amd.com>
Content-Disposition: inline
In-Reply-To: <20060927193147.GA21043@cosmic.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 27, 2006 at 01:31:47PM -0600, Jordan Crouse (jordan.crouse@amd.com) wrote:
> Hey all -
> 
> I've had a poor excuse for a crypto driver for the Geode LX AES hardware
> sitting in my Geode GIT tree (and -mm) for some time now.  I sent out the 
> original version some time ago (June) and I got some very smart 
> recommendations for changes, but other events transpired, and I didn't do 
> a very good job of following up.
> 
> So now, in the interest of getting this out of everybody's hair and on
> the path to mainstreaming, I'm sending out a newly updated version of the 
> driver for comments.  This should be fully updated for all the new API
> changes in the crypto GIT tree.  Once this is acceptable, I would like to get
> this pulled into the crypto tree.

As far as I can see, register access is not protected, how can your
driver handle the case when dm-crypt and IPsec simultaneously try to
encrypt/decrypt some data, it can happen even around 
preemt_disable/enable calls and actually crypto processing can happen 
in interrupt context too (although it is not the best thing to do).

You added timeout for the broken hardware condition, I think it is
better to return some error from _crypt() in that case, and, btw, that
name is not very good choice.

> Thanks,
> Jordan
> -- 
> Jordan Crouse
> Senior Linux Engineer
> Advanced Micro Devices, Inc.
> <www.amd.com/embeddedprocessors>


-- 
	Evgeniy Polyakov
