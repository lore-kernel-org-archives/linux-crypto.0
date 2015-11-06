From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH 5/7] crypto: picoxcell: check return value of
 sg_nents_for_len
Date: Fri, 6 Nov 2015 15:30:57 +0000
Message-ID: <20151106153057.GA10738@page>
References: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
 <1446668045-8620-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	jamie@jamieiles.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36657 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbbKFPbA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Nov 2015 10:31:00 -0500
Received: by wmww144 with SMTP id w144so32762586wmw.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2015 07:30:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1446668045-8620-5-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 04, 2015 at 09:13:37PM +0100, LABBE Corentin wrote:
> The sg_nents_for_len() function could fail, this patch add a check for
> its return value.
> In the same time, we remove sg_count() as it is used as an alias of
> sg_nents_for_len.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Acked-by: Jamie Iles <jamie@jamieiles.com>

thanks for doing this!

Jamie
