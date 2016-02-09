From: James Morris <jmorris@namei.org>
Subject: Re: Transferring applied X.509 patches from crypto/next to
 security/next
Date: Tue, 9 Feb 2016 12:01:19 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1602091200580.6966@namei.org>
References: <20160206142705.GA23978@gondor.apana.org.au> <20160206074731.GF22220@gondor.apana.org.au> <20160202180848.2887.9937.stgit@tstruk-mobl1> <11215.1454752821@warthog.procyon.org.uk> <25680.1454939914@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <25680.1454939914@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 8 Feb 2016, David Howells wrote:

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
> 

I don't want to rebase my tree.


-- 
James Morris
<jmorris@namei.org>

