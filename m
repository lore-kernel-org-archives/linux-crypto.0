From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH][crypto-next] crypto: cavium: fix spelling mistake
 "Revsion" -> "Revision"
Date: Tue, 13 Jun 2017 03:36:12 -0700
Message-ID: <1497350172.18751.11.camel@perches.com>
References: <20170613085254.20855-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:39051 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751895AbdFMKgQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2017 06:36:16 -0400
In-Reply-To: <20170613085254.20855-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-06-13 at 09:52 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in seq_printf message

Hey Colin.

Fixing spelling typos is a good thing, but is it a
good thing to change possibly API dependent output
in seq_ calls?

> diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
[]
> @@ -399,7 +399,7 @@ static int nitrox_show(struct seq_file *s, void *v)
>  	struct nitrox_device *ndev = s->private;
>  
>  	seq_printf(s, "NITROX-5 [idx: %d]\n", ndev->idx);
> -	seq_printf(s, "  Revsion ID: 0x%0x\n", ndev->hw.revision_id);
> +	seq_printf(s, "  Revision ID: 0x%0x\n", ndev->hw.revision_id);
>  	seq_printf(s, "  Cores [AE: %u  SE: %u]\n",
>  		   ndev->hw.ae_cores, ndev->hw.se_cores);
>  	seq_printf(s, "  Number of Queues: %u\n", ndev->nr_queues);
