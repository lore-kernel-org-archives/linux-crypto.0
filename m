From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH] KEYS: Add placeholder for KDF usage with DH
Date: Wed, 1 Jun 2016 12:48:02 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1606011247380.23531@namei.org>
References: <9470.1464302447@warthog.procyon.org.uk> <26983.1464687439@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <26983.1464687439@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 31 May 2016, David Howells wrote:

> Hi James,
> 
> > Could you pass this along to Linus as soon as possible, please?  This
> > alters a new keyctl function added in the current merge window to allow for
> > a future extension planned for the next merge window.
> 
> Is this likely to go to Linus before -rc2?  If not, we'll need to do things
> differently.

It should be ok, I'll see how it goes with Linus.

-- 
James Morris
<jmorris@namei.org>

