From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2][RESEND] X.509: unpack RSA signatureValue field from
 BIT STRING
Date: Thu, 21 Jun 2018 11:44:29 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1806211144140.30225@namei.org>
References: <04f372f3-bc26-c629-2269-0e5d258f9d8f@maciej.szmigiero.name> <80e95323-eb7f-6af3-ad05-f174c69fb948@maciej.szmigiero.name> <9a9bfd23-d7be-7f16-925e-5fe00cbfba9f@maciej.szmigiero.name> <20180620143807.fo7c5endwd5yy24r@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        james.morris@microsoft.com, "Serge E. Hallyn" <serge@hallyn.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620143807.fo7c5endwd5yy24r@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 20 Jun 2018, Herbert Xu wrote:

> On Wed, Jun 20, 2018 at 02:24:54PM +0200, Maciej S. Szmigiero wrote:
> > 
> > A friendly ping here.
> > 
> > @AMD people:
> > Without this patch, in-kernel X.509 certificate verification is broken
> > on AMD CCP RSA implementation.
> > 
> > For example, loading wireless regulatory database gives the following
> > errors:
> > > [   21.310361] cfg80211: Problem loading in-kernel X.509 certificate (-22)
> > > [   21.351717] cfg80211: loaded regulatory.db is malformed or signature is missing/invalid
> > 
> > Kernel modules signature verification probably has similar problem, too.
> > 
> > That's why it would be nice if you could ack this patch, please.
> 
> David/James, is there an issue with the patch?

Not from my POV.

-- 
James Morris
<jmorris@namei.org>
