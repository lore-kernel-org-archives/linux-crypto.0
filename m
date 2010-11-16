From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
Date: Tue, 16 Nov 2010 15:43:53 -0500
Message-ID: <1289940233.2627.31.camel@localhost.localdomain>
References: <1289918320.3188.16.camel@localhost.localdomain>
	 <1289849751.3027.17.camel@localhost.localdomain>
	 <1289694826.3257.82.camel@localhost.localdomain>
	 <1289595738.2731.80.camel@localhost.localdomain>
	 <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <26689.1289591135@redhat.com> <27900.1289597013@redhat.com>
	 <8268.1289837934@redhat.com> <23151.1289916524@redhat.com>
	 <26645.1289929851@redhat.com>
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
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <26645.1289929851@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2010-11-16 at 17:50 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > I actually like keyctl requiring 'trusted:' or 'user:'.  Forcing the
> > user to indicate which type of key they want, is actually good - no
> > misunderstandings.
> 
> You still need to prefix the description of a user-defined key so that you
> don't collide with other people who're also using user-defined keys for random things.

Although I previously agreed to this change, I'm really not convinced it
is necessary.  encrypted keys don't create new trusted or user keys,
they only use existing keys to encrypt/decrypt encrypted
keys(instantiate,read).  Key names, user or otherwise, should be left up
to the person creating them.

thanks,

Mimi

