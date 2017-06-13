From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH][crypto-next] crypto: cavium: fix spelling mistake
 "Revsion" -> "Revision"
Date: Tue, 13 Jun 2017 03:44:22 -0700
Message-ID: <1497350662.18751.13.camel@perches.com>
References: <20170613085254.20855-1-colin.king@canonical.com>
         <1497350172.18751.11.camel@perches.com>
         <accc9c81-7f3c-6ebf-ff73-969cffc4b575@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:40070 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752418AbdFMKo0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2017 06:44:26 -0400
In-Reply-To: <accc9c81-7f3c-6ebf-ff73-969cffc4b575@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-06-13 at 11:40 +0100, Colin Ian King wrote:
> On 13/06/17 11:36, Joe Perches wrote:
> > On Tue, 2017-06-13 at 09:52 +0100, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > Trivial fix to spelling mistake in seq_printf message
> > Fixing spelling typos is a good thing, but is it a
> > good thing to change possibly API dependent output
> > in seq_ calls?
> Considering it's in -next and has not landed in upstream I supposed it
> was better to fix it now before it landed in Linus' repo.

Good call, thanks.

> > > diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
> > 
> > []
> > > @@ -399,7 +399,7 @@ static int nitrox_show(struct seq_file *s, void *v)
> > >  	struct nitrox_device *ndev = s->private;
> > >  
> > >  	seq_printf(s, "NITROX-5 [idx: %d]\n", ndev->idx);
> > > -	seq_printf(s, "  Revsion ID: 0x%0x\n", ndev->hw.revision_id);
> > > +	seq_printf(s, "  Revision ID: 0x%0x\n", ndev->hw.revision_id);
> > >  	seq_printf(s, "  Cores [AE: %u  SE: %u]\n",
> > >  		   ndev->hw.ae_cores, ndev->hw.se_cores);
> > >  	seq_printf(s, "  Number of Queues: %u\n", ndev->nr_queues);
