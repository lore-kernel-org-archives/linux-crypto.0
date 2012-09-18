From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
Date: Tue, 18 Sep 2012 19:51:15 +0100
Message-ID: <20120918195115.6ddcf5fc@pyramind.ukuu.org.uk>
References: <20120914103930.1e16ad8b@pyramind.ukuu.org.uk>
	<20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
	<20120913235005.3575.46218.stgit@warthog.procyon.org.uk>
	<13189.1347989652@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.hengli.com.au, pjones@redhat.com,
	rusty@rustcorp.com.au, linux-crypto@vger.kernel.org,
	zohar@us.ibm.com, dmitry.kasatkin@intel.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35203 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2IRSqs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Sep 2012 14:46:48 -0400
In-Reply-To: <13189.1347989652@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 18 Sep 2012 18:34:12 +0100
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > Why do this in the kernel.That appears to be completely insane.
> 
> A number of reasons:
> 
>  (1) The UEFI signature/key database may contain ASN.1 X.509 certificates and
>      we may need to use those very early in the boot process, during initrd.

Ok that makes some sense. Presumably they've also got to fall within what
you trust and sign ?

Alan
