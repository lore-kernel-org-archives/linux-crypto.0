From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
Date: Tue, 16 Nov 2010 09:38:40 -0500
Message-ID: <1289918320.3188.16.camel@localhost.localdomain>
References: <1289849751.3027.17.camel@localhost.localdomain>
	 <1289694826.3257.82.camel@localhost.localdomain>
	 <1289595738.2731.80.camel@localhost.localdomain>
	 <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <26689.1289591135@redhat.com> <27900.1289597013@redhat.com>
	 <8268.1289837934@redhat.com>   <23151.1289916524@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39292 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab0KPOiq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Nov 2010 09:38:46 -0500
In-Reply-To: <23151.1289916524@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2010-11-16 at 14:08 +0000, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Am assuming you mean something like this:
> > 
> > keyctl add encrypted name "new trusted:master-key-name keylen" ring
> > keyctl add encrypted name "new user:master-key-name keylen" ring
> > 
> > and, as you said, works without changing the API.
> 
> No, that's not what I mean.  I maeant that when your internal functions look
> for the user key, they should preface the description with a prefix.
> 
> It should be handled in request_user_key() or request_master_key().  The
> description given to request_trusted_key() should have the prefix applied
> there.  There's no need to mention it at all in the encrypted key add_key
> command line.
> 
> David

I actually like keyctl requiring 'trusted:' or 'user:'.  Forcing the
user to indicate which type of key they want, is actually good - no
misunderstandings. Another benefit, would be allowing 'keyctl update' to
update the key description, not the key type.

Mimi 
