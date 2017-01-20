From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] Introduce AMD Secure Processor device
Date: Fri, 20 Jan 2017 09:45:30 +0100
Message-ID: <20170120084530.GA25333@kroah.com>
References: <148484927002.30852.10568570584817827556.stgit@brijesh-build-machine>
 <20170119182101.GB30851@kroah.com>
 <0442f536-221d-fcef-3009-4bc07403ccd8@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        arnd@arndb.de, lambert.quentin@gmail.com, gary.hook@amd.com,
        linux-kernel@vger.kernel.org, Julia.Lawall@lip6.fr,
        weiyongjun1@huawei.com, linux-crypto@vger.kernel.org,
        umgwanakikbuti@gmail.com
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbdATIxb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 03:53:31 -0500
Content-Disposition: inline
In-Reply-To: <0442f536-221d-fcef-3009-4bc07403ccd8@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2017 at 02:03:12PM -0600, Brijesh Singh wrote:
> Hi Greg,
> 
> On 01/19/2017 12:21 PM, Greg KH wrote:
> > On Thu, Jan 19, 2017 at 01:07:50PM -0500, Brijesh Singh wrote:
> > > The CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
> > > which is not dedicated solely to crypto. The AMD Secure Processor includes
> > > CCP and PSP (Platform Secure Processor) devices.
> > > 
> > > This patch series moves the CCP device driver to the misc directory and
> > > creates a framework that allows functional component of the AMD Secure
> > > Processor to be initialized and handled appropriately.
> > 
> > Why the misc directory?  I don't see the justification here...
> > 
> 
> Since this driver is not solely for crypto purposes and do not fit in any of
> the standard categories hence I thought of moving it into misc directory. I
> am open to other suggestions unless Herbert is ok with leaving it into
> crypto and allowing the addition of the Secure Processor support.
> 
> The patch series allows the CCP driver to support other Secure Processor
> functions, e.g Secure Encrypted Virtualization (SEV) key management. In
> past, I tried to add SEV support into existing CCP driver [1] but we quickly
> learned that CCP driver should be moved outside the crypto directory
> otherwise will end up adding non crypto code into drivers/crypto directory.
> Once this cleanup is accepted then I can work to add SEV support inside the
> CCP driver.
> 
> [1] http://marc.info/?l=linux-kernel&m=147204118426151&w=2

Ok, what type of interface will this driver have with userspace and/or
other parts of the kernel?  Is there a misc char device burried in there
somewhere (I couldn't find it in the big diff sent out), or is this
driver just creating specific apis that other parts of the kernel will
call if available?

I think we need to see more code here, broken up into sane and
reviewable pieces, before we could either say "No don't do that!" or
"sure, let me go merge these!" :)

thanks,

greg k-h
