From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Transferring applied X.509 patches from crypto/next to
 security/next
Date: Mon, 08 Feb 2016 16:25:57 -0500
Message-ID: <1454966757.3037.41.camel@linux.vnet.ibm.com>
References: <20160206142705.GA23978@gondor.apana.org.au>
	 <20160206074731.GF22220@gondor.apana.org.au>
	 <20160202180848.2887.9937.stgit@tstruk-mobl1>
	 <11215.1454752821@warthog.procyon.org.uk>
	 <25680.1454939914@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, jmorris@namei.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([125.16.236.8]:40863 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbcBHV0N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Feb 2016 16:26:13 -0500
Received: from localhost
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Tue, 9 Feb 2016 02:56:08 +0530
In-Reply-To: <25680.1454939914@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Mon, 2016-02-08 at 13:58 +0000, David Howells wrote:
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > > Hmmm...  That means that the crypto branch and the security branch are going
> > > to conflict.
> > 
> > I thought you were OK with it going in now as you said that you'll
> > fix it up later.  Sorry for the misunderstanding.  Do you want me to
> > revert?
> 
> If you can back them out, I'll apply them to my keys-next branch.  Unless
> James is willing to rebase security/next on top of your crypto branch?

Could we upstream these patches via James' tree?  If you re-base these
patches on top of the James' security-next branch and send him a pull
request, we can then base on our patches on top of them.

Mimi
