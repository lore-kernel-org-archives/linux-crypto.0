From: David Howells <dhowells@redhat.com>
Subject: Transferring applied X.509 patches from crypto/next to security/next
Date: Mon, 08 Feb 2016 13:58:34 +0000
Message-ID: <25680.1454939914@warthog.procyon.org.uk>
References: <20160206142705.GA23978@gondor.apana.org.au> <20160206074731.GF22220@gondor.apana.org.au> <20160202180848.2887.9937.stgit@tstruk-mobl1> <11215.1454752821@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, jmorris@namei.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160206142705.GA23978@gondor.apana.org.au>
Content-ID: <25679.1454939914.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > Hmmm...  That means that the crypto branch and the security branch are going
> > to conflict.
> 
> I thought you were OK with it going in now as you said that you'll
> fix it up later.  Sorry for the misunderstanding.  Do you want me to
> revert?

If you can back them out, I'll apply them to my keys-next branch.  Unless
James is willing to rebase security/next on top of your crypto branch?

David
