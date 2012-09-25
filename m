From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Wrong system clock vs X.509 date specifiers
Date: Tue, 25 Sep 2012 17:00:20 +0100
Message-ID: <20120925170020.07cf0b26@pyramind.ukuu.org.uk>
References: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk>
	<5555.1348531649@warthog.procyon.org.uk>
	<21845.1348585794@warthog.procyon.org.uk>
	<30071.1348587320@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <30071.1348587320@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 25 Sep 2012 16:35:20 +0100
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > Generate a certificate that is valid from a few minutes before the
> > wallclock time. It's a certificate policy question not a kernel hackery
> > one.
> 
> That doesn't seem to be possible with openssl req.  What would you recommend?

LD_PRELOAD ? or fixing it if GNUTLS certtool can't do the needed. We
shouldn't botch security checks in kernel code to work around crappy
userspace tools.

Alan


