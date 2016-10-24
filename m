From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] crypto: mxs-dcp - Remove hash support
Date: Mon, 24 Oct 2016 22:39:45 +0200
Message-ID: <423fc7f0-fcab-eee6-6e7b-9ba2261fd0b3@denx.de>
References: <1477327394-2976-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: gianfranco.costamagna@abinsula.com, linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:51678 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756906AbcJXUkS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 16:40:18 -0400
In-Reply-To: <1477327394-2976-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/24/2016 06:43 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> mxs-dcp driver does not probe for a long time:
> 
> mxs-dcp 80028000.dcp: Failed to register sha1 hash!
> mxs-dcp: probe of 80028000.dcp failed with error -22
> 
> There were some previous attempts to fix this, and the following
> feedback was given by Herbert Xu [1]:
> 
> "This driver is hopelessly broken as its request context doesn't
> contain the hash state at all.  Unless someone can fix that we
> should probably just remove the hash implementations altogether."

This comment looks real unhelpful. I'd really appreciate a bit more
detail on how to fix it.

> [1] http://www.spinics.net/lists/linux-crypto/msg18187.html
> 
> So remove the hash support for now.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
> Changes since v1:
> - Fix typo in commit log
> 

Can't you rather fix it?

-- 
Best regards,
Marek Vasut
