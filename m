From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccree: fix iv copying for small buffers
Date: Fri, 22 Jun 2018 14:53:41 +0800
Message-ID: <20180622065341.yparmvx5tspj3zvy@gondor.apana.org.au>
References: <1528361927-4172-1-git-send-email-gilad@benyossef.com>
 <CAOtvUMcJfJDjnMoithRQ4ife09VC+G-w+__jV-JLwh7M=s7JNQ@mail.gmail.com>
 <20180613063030.bsrq3xmufcw4zi52@gondor.apana.org.au>
 <CAOtvUMdtafGwXJFD0Tm1tx1q+TxRsB4nwEKxumE7=--_PMCZrQ@mail.gmail.com>
 <20180619142713.dzipyarpb23a7qne@gondor.apana.org.au>
 <CAOtvUMcChKswKBCOkN7DGvK3DcotJBh0y=-Xi8232uYK26-xQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Hadar Gat <hadar.gat@arm.com>, Ofir Drang <ofir.drang@arm.com>,
        stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMcChKswKBCOkN7DGvK3DcotJBh0y=-Xi8232uYK26-xQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 21, 2018 at 04:35:44PM +0300, Gilad Ben-Yossef wrote:
> 
> What about OFB? unless I've missed something there is no generic
> implementation... ?

In general we shouldn't add hardware drivers for algorithms that
do not have a generic implementation.  Sometimes they slip through
though.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
