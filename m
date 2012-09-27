From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Wed, 26 Sep 2012 22:04:03 -0400
Message-ID: <1348711443.17807.12.camel@falcor>
References: <5555.1348531649@warthog.procyon.org.uk>
	 <87ehlp30pd.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39545 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2I0CJn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Sep 2012 22:09:43 -0400
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 26 Sep 2012 22:09:41 -0400
In-Reply-To: <87ehlp30pd.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2012-09-26 at 13:16 +0930, Rusty Russell wrote:
> David Howells <dhowells@redhat.com> writes:
> > The module signing patches provide:
> >
> >  - Some fixes to Rusty's patch.  Also an additional patch to extend the policy
> >    handling for modules signed with an unknown key and to handle FIPS mode.
> 
> Ok, I merged some of this (after our previous accidentally-off-list
> discussion).

Rusty, have you pushed this branch out yet?

thanks,

Mimi
