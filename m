From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 2/8] KEYS: Provide keyctls to drive the new key type ops for asymmetric keys [ver 3]
Date: Thu, 12 May 2016 11:16:41 +0100
Message-ID: <24969.1463048201@warthog.procyon.org.uk>
References: <alpine.OSX.2.20.1605111426140.16566@mjmartin-mac01.local> <20160511142152.4743.14414.stgit@warthog.procyon.org.uk> <20160511142207.4743.40300.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, tadeusz.struk@intel.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1605111426140.16566@mjmartin-mac01.local>
Content-ID: <24968.1463048201.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:

> > +     If the key must be unlocked with a password before it can be used,
> > +     password_id should point to a logon-type key that holds this.
> 
> It should be noted that the password_id should be 0 if no password is to be
> used.

Currently I'm just ignoring it if I don't need it, but this makes more sense.

David
