From: Huang Ying <ying.huang@intel.com>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Date: Wed, 12 Aug 2009 10:27:00 +0800
Message-ID: <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
	 <20090805094506.GA12528@gondor.apana.org.au>
	 <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61426 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZHLC1A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Aug 2009 22:27:00 -0400
In-Reply-To: <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2009-08-06 at 10:12 +0800, Huang Ying wrote:
> On Wed, 2009-08-05 at 17:45 +0800, Herbert Xu wrote:
> > On Mon, Aug 03, 2009 at 03:44:43PM +0800, Huang Ying wrote:
> > > When doing "modeprobe tcrypt mode=10", the following error will show
> > > in dmesg.
> > > 
> > > alg: skcipher: Failed to load transform for ctr(aes): -22
> > > alg: skcipher: Failed to load transform for ctr(aes): -22
> > > tcrypt: one or more tests failed!
> > 
> > I can't reproduce it here:
> > 
> > etch1:~# modprobe tcrypt mode=10
> > FATAL: Error inserting tcrypt (/lib/modules/2.6.30/kernel/crypto/tcrypt.ko): Resource temporarily unavailable
> > etch1:~# dmesg|tail
> > alg: No test for digest_null (digest_null-generic)
> > alg: No test for compress_null (compress_null-generic)
> > padlock: VIA PadLock Hash Engine not detected.
> > padlock: VIA PadLock Hash Engine not detected.
> > eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
> > Initializing XFRM netlink socket
> > NET: Registered protocol family 17
> > NET: Registered protocol family 10
> > lo: Disabled Privacy Extensions
> > eth0: no IPv6 routers present
> > etch1:~# 
> > 
> > The tcrypt test shouldn't use geniv at all.
> > 
> > What kernel version was this?
> 
> The version is: v2.6.30-6814-gab30046. Kernel config is attached too.

Any follow-up for this patch? Still can not re-produce?

Best Regards,
Huang Ying


