From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Wrong system clock vs X.509 date specifiers
Date: Tue, 25 Sep 2012 16:30:37 +0100
Message-ID: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk>
References: <5555.1348531649@warthog.procyon.org.uk>
	<21845.1348585794@warthog.procyon.org.uk>
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
In-Reply-To: <21845.1348585794@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 25 Sep 2012 16:09:54 +0100
David Howells <dhowells@redhat.com> wrote:

> 
> The X.509 certificate has a pair of times in it that delineate the valid
> period of the cert, and I'm checking that the system clock is within the
> bounds they define before permitting you to use the cert.  I've been setting
> the expiry date to be 100 years in the future - by which time hopefully I
> won't have to worry about it - but occasionally clock skew means a freshly
> built kernel won't boot because the machine trying to boot doesn't think that
> the start time has been reached yet.
> 
> Do we actually want to do this, however?  Or should we just ignore the times?
> Or just the start time?

Generate a certificate that is valid from a few minutes before the
wallclock time. It's a certificate policy question not a kernel hackery
one.

Be careful moving your system clock on 100 years and testing - ext4 gets
some timestamps wrong after 2038.

Alan


