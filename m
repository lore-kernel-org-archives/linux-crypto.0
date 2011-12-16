From: Rusty Russell <rusty@ozlabs.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
Date: Fri, 16 Dec 2011 11:11:23 +1030
Message-ID: <8762hhqrf0.fsf@rustcorp.com.au>
References: <87obvdtdwz.fsf@rustcorp.com.au> <87ty56taup.fsf@rustcorp.com.au> <87obvfogc6.fsf@rustcorp.com.au> <8739csq5ac.fsf@rustcorp.com.au> <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com> <30007.1323526114@redhat.com> <26644.1323652900@redhat.com> <21605.1323706287@redhat.com>  <24260.1323908071@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com, Jon Masters <jcm@jonmasters.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:47030 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1LPD5D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Dec 2011 22:57:03 -0500
In-Reply-To: <24260.1323908071@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 15 Dec 2011 00:14:31 +0000, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@ozlabs.org> wrote:
> 
> > > > We can have false positives, but at worst that make us report EINVAL
> > > > (bad signature) instead of ENOENT (no signature).
> > > 
> > > EKEYREJECTED please; that way it's the same as RHEL does now.
> > 
> > OK, sure (who knew that was there?).

Oh yes, I read these, but I didn't appreciate that those errnos had
existed for over 6 years.

Cheers,
Rusty.
