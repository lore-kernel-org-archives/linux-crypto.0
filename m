From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2 25/25] crypto: ansi_cprng - If non-deterministic,
 don't buffer old output
Date: Mon, 8 Dec 2014 09:22:40 -0500
Message-ID: <20141208142239.GA3237@localhost.localdomain>
References: <6f29805d8bbde1af112d48201d5fde9a7776027f.1417951990.git.linux@horizon.com>
 <20141207224959.25453.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	smueller@chronox.de
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60455 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbaLHOXD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 09:23:03 -0500
Content-Disposition: inline
In-Reply-To: <20141207224959.25453.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2014 at 05:49:59PM -0500, George Spelvin wrote:
> By the way, this patch includes a bug due to a last minute "oh, I can
> make that more efficient!" which I realized after a night's sleep.
> (The v1 patch worked, FWIW.)
> 
> Anyway, it's an RFC; I'm not even sure if I want this personally,
> but it's a bit of extra paranoia to always genreate fresh seed per
> read.
Wait, I'm confused. You mention in this note that this is an RFC patch, but not
anywhere else in the series.  Are you proposing this for inclusion or not?
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
