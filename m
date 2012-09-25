From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Wrong system clock vs X.509 date specifiers
Date: Tue, 25 Sep 2012 17:43:43 +0200
Message-ID: <5061D12F.1000308@redhat.com>
References: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk> <5555.1348531649@warthog.procyon.org.uk> <21845.1348585794@warthog.procyon.org.uk> <30071.1348587320@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, rusty@rustcorp.com.au,
	herbert@gondor.hengli.com.au, pjones@redhat.com,
	jwboyer@redhat.com, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53035 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2IYPnu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Sep 2012 11:43:50 -0400
In-Reply-To: <30071.1348587320@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Il 25/09/2012 17:35, David Howells ha scritto:
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>> > Generate a certificate that is valid from a few minutes before the
>> > wallclock time. It's a certificate policy question not a kernel hackery
>> > one.
> That doesn't seem to be possible with openssl req.  What would you recommend?

Disgusting, but: add an LD_PRELOAD library that returns a time well in
the past.

Paolo
