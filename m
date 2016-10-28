From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: mxs-dcp - Remove hash support
Date: Fri, 28 Oct 2016 22:05:50 +0200
Message-ID: <6a1488ea-f9b9-bf9d-81a8-2f970ad1aa0d@denx.de>
References: <1477327226-2904-1-git-send-email-festevam@gmail.com>
 <CACJOhtJqx6+QN9gefSWtw_vgR3vps7tobXLQdbGM7FeUum_C3A@mail.gmail.com>
 <CACJOhtLFGOmrLZfPjb7TXPTcqPAdCXn6H7HEHG-8iQN3Z6gJnA@mail.gmail.com>
 <1477960343.1079728.1477669573195@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Gianfranco Costamagna <locutusofborg@debian.org>,
        "To: Fabio Estevam" <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:40049 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756750AbcJ1Ukz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 16:40:55 -0400
In-Reply-To: <1477960343.1079728.1477669573195@mail.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/28/2016 05:46 PM, Gianfranco Costamagna wrote:
> Hi,
> (sending with my debian.org mail address to avoid spam filters)
> I tested the patch and indeed solves my problem (the driver loads correctly now with no warnings)
> 
> Tested-by: Gianfranco Costamagna <gianfranco.costamagna@abinsula.com>'

Well it "solves" the problem, but it cripples the driver and removes
useful functionality.

-- 
Best regards,
Marek Vasut
