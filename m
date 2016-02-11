From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v5 1/3] crypto: KEYS: convert public key and digsig asym to the akcipher api
Date: Thu, 11 Feb 2016 09:51:26 +0000
Message-ID: <16626.1455184286@warthog.procyon.org.uk>
References: <56BBC321.1000503@intel.com> <20160202180853.2887.82271.stgit@tstruk-mobl1> <20160202180848.2887.9937.stgit@tstruk-mobl1> <5286.1455113876@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbcBKJv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Feb 2016 04:51:29 -0500
In-Reply-To: <56BBC321.1000503@intel.com>
Content-ID: <16625.1455184286.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> > Why didn't you put the RSA signature parsing - ie. where the OID and the other
> > bits are checked - into crypto/rsa.c?
> > 
> 
> Do you want to get rid of the crypto/asymmetric_keys/rsa.c completely?
> I wanted to make the conversion churn as small as possible.
> I can move it in a subsequent patch if you want.

I was thinking of getting rid of it completely, yes.

But I was wondering if you had some other motivation, such as keeping the
crypto layer purely the mathematical operation.

It's an interesting question where to draw the line, actually.  The answer may
hinge on what things like the TPM do.  I should ask the TPM folks.

David
