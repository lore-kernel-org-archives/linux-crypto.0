From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Fri, 28 Sep 2012 16:24:06 +0930
Message-ID: <87d3163aep.fsf@rustcorp.com.au>
References: <5555.1348531649@warthog.procyon.org.uk> <87ehlp30pd.fsf@rustcorp.com.au> <1348711443.17807.12.camel@falcor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:60804 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2I1GzM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Sep 2012 02:55:12 -0400
In-Reply-To: <1348711443.17807.12.camel@falcor>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> On Wed, 2012-09-26 at 13:16 +0930, Rusty Russell wrote:
>> David Howells <dhowells@redhat.com> writes:
>> > The module signing patches provide:
>> >
>> >  - Some fixes to Rusty's patch.  Also an additional patch to extend the policy
>> >    handling for modules signed with an unknown key and to handle FIPS mode.
>> 
>> Ok, I merged some of this (after our previous accidentally-off-list
>> discussion).
>
> Rusty, have you pushed this branch out yet?
>
> thanks,
>
> Mimi

git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git modules-next

(That's *not* where linux-next currently pulls from)

Cheers,
Rusty.
