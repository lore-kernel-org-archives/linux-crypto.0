From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] Move cert handling to certs/ directory
Date: Wed, 26 Aug 2015 08:26:38 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1508260826180.7800@namei.org>
References: <29947.1440420712@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org, dwmw2@infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:34761 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbbHYW1P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Aug 2015 18:27:15 -0400
In-Reply-To: <29947.1440420712@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 24 Aug 2015, David Howells wrote:

> Hi James,
> 
> Sorry for the late request, but can you pull this please?  It's a set of
> commits that puts a bit of polish on the previous module signing patches.
> It moves the certificate handling to its own directory rather than sharing
> in the kernel/ directory.  It then moves key generation into the certs/
> directory rather than doing it in the root.
> 
> This allows us to simplify the kernel/Makefile and slightly simplify the
> new certs/Makefile.  It also keeps the various generated files in the same
> place to make them easier to find and clean up.
> 

Pulled to my next branch, thanks.


- James
-- 
James Morris
<jmorris@namei.org>
