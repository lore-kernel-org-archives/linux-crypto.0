From: David Howells <dhowells@redhat.com>
Subject: Re: PKCS#7: Verify internal certificate chain
Date: Thu, 31 Jul 2014 15:04:34 +0100
Message-ID: <9951.1406815474@warthog.procyon.org.uk>
References: <20140731093051.GE30276@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGaOEk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jul 2014 10:04:40 -0400
In-Reply-To: <20140731093051.GE30276@mwanda>
Content-ID: <9950.1406815474.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

>    193			if (x509->issuer)
>                             ^^^^^^^^^^^^
> Check.
> 
>    194				pr_debug("- issuer %s\n", x509->issuer);

Actually, x509->subject and x509->issuer are mandatory in the ASN.1 definition
and point to empty strings if there's no name material we can use, so the
check is superfluous.

>    199			    (x509->subject &&

This check too.

However, I probably should check that x509->subject is not an empty string.

>    238                  pr_debug("- issuer %s\n", p->subject);
>                                     ^^^^^^
> Also this looks like it should be "subject" instead of "issuer" but
> maybe they are the same?

This is the subject attribute of issuing certificate (that p points to), not
the issuing attribute of the subject certificate (that x509 points to).

Note this is a debugging line.  x509->issuer was printed by a pr_debug()
several lines above.

David
