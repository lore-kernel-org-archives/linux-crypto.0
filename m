From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
Date: Tue, 18 Sep 2012 18:19:06 -0400
Message-ID: <1348006746.12937.7.camel@eddie.install.bos.redhat.com>
References: <20120914103930.1e16ad8b@pyramind.ukuu.org.uk>
	 <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
	 <20120913235005.3575.46218.stgit@warthog.procyon.org.uk>
	 <13189.1347989652@warthog.procyon.org.uk>
	 <20120918195115.6ddcf5fc@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
	rusty@rustcorp.com.au, linux-crypto@vger.kernel.org,
	zohar@us.ibm.com, dmitry.kasatkin@intel.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20120918195115.6ddcf5fc@pyramind.ukuu.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2012-09-18 at 19:51 +0100, Alan Cox wrote:
> On Tue, 18 Sep 2012 18:34:12 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > Why do this in the kernel.That appears to be completely insane.
> > 
> > A number of reasons:
> > 
> >  (1) The UEFI signature/key database may contain ASN.1 X.509 certificates and
> >      we may need to use those very early in the boot process, during initrd.
> 
> Ok that makes some sense. Presumably they've also got to fall within what
> you trust and sign ?

The idea is that you implicitly trust keys in the lists maintained by
your system firmware and/or shim ("mok") key databases, or else you
shouldn't have Secure Boot turned on in the first place.  Using these
keys and hashes allows you to e.g. relatively easily add a key you're
using to sign a module you're currently developing, while still *ahem*
enjoying the many benefits of signed modules, kernel, and bootloader.

(Though obviously we would never recommend adding a public key whose
private half you're normally keeping on that same machine.)

-- 
  Peter

