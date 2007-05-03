From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 3 May 2007 20:53:22 +0400
Message-ID: <20070503165321.GA19763@2ka.mipt.ru>
References: <20070503132310.GA21082@2ka.mipt.ru> <E1Hjbgd-000086-00@gondolin.me.apana.org.au> <20070503144744.GA9691@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>, mschiller@tdt.de,
	linux-crypto@vger.kernel.org
To: Jordan Crouse <jordan.crouse@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59997 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162176AbXECQxv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 12:53:51 -0400
Content-Disposition: inline
In-Reply-To: <20070503144744.GA9691@cosmic.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 03, 2007 at 08:47:44AM -0600, Jordan Crouse (jordan.crouse@amd.com) wrote:
> On 03/05/07 23:49 +1000, Herbert Xu wrote:
> > Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > > 
> > > Hm, driver does not perform encryption in-place at all.
> > > Since we did not hear from AMD quite for a while, could you please
> > > remove src==dst check in geode_aes_crypt() and run tests again.
> > > If it is software protection against hardware bug, I doubt such hardware
> > > should be used at all...
> >
> > I agree.  Jordan, could you please see if this can be fixed up?
> 
> On older versions of the chip, in-place encryption was not possible, even
> though there was no hardware protection against it.  I can't remember
> if the newer chip version can handle in place encryption or not.
> 
> I missed out on the context of this thread - does the tcrypt demand 
> in-place encryption?

Majority of the in-kernel crypto users require in-place crypto
processing. The only way to fix this I see is to allocate a buffer, copy
data and then perform crypto processing. But I seriously doubt it will
be faster then software encryption/decryption on that processor.

Test for possibility for in-place encryption can be done in module load
time and in case of failed crypto processing driver should fail into
alternative (with allocation) ecryption way (at least similar check I
perform in hifn module).

> Jordan

-- 
	Evgeniy Polyakov
