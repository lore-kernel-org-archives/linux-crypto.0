From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] n2rng: Combine substrings for two messages in
 n2rng_probe()
Date: Fri, 21 Apr 2017 11:22:49 -0700
Message-ID: <1492798969.30293.28.camel@perches.com>
References: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
         <fef1883c-4338-5f8a-5dfe-e970b424fbc5@users.sourceforge.net>
         <20170421113641.GA14100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170421113641.GA14100@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2017-04-21 at 19:36 +0800, Herbert Xu wrote:
> On Wed, Apr 19, 2017 at 11:11:35AM +0200, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Wed, 19 Apr 2017 10:50:04 +0200
> > 
> > The script "checkpatch.pl" pointed information out like the following.
> > 
> > WARNING: quoted string split across lines
> > 
> > Thus fix the affected source code places.
> > 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> 
> This patch doesn't seem to add any value so I'm not taking it.

Your choice.

The general reason to merge strings is in CodingStyle

    2) Breaking long lines and strings
    []
    never break user-visible strings such as
    printk messages, because that breaks the ability to grep for them.
