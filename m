From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Tue, 2 Jun 2009 11:21:51 +0200
Message-ID: <20090602092151.GJ20366@secunet.com>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:41789 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875AbZFBJT1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 05:19:27 -0400
Content-Disposition: inline
In-Reply-To: <20090602035041.GB22831@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 02, 2009 at 01:50:41PM +1000, Herbert Xu wrote:
> 
> Hmm, it seems that this patch is completely intertwined into the
> rest of the patches so we can't just kill it.  Can you elaborate
> on the rationale behind this wrap work? I'm curious to find out
> what we gain by this over the much simpler patch you had in your
> previous set.
> 

The reason for the wrap work is to have a possibility to choose a
certain version of an algorithm as the system default. The advantage
e.g. for pcrypt is that we can turn over the whole system to pcrypt,
or we can choose for pcrypt by the algorithm name if we want to use
it just for a subset of transforms. In particular we have a possibility
to use pcrypt without touching other subsystems (like networking) and
userspace tools for now.
