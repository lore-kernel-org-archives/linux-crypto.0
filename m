From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH 1/1] crypto: picoxcell_crypto: Use of_match_ptr() macro
Date: Fri, 15 Mar 2013 09:54:05 +0000
Message-ID: <20130315095405.GI6473@sycamore.jamieiles.com>
References: <1363256218-26326-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	jamie@jamieiles.com, davem@davemloft.net
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63216 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3COJtG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Mar 2013 05:49:06 -0400
Received: by mail-ea0-f175.google.com with SMTP id o10so1401424eaj.6
        for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2013 02:49:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1363256218-26326-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks Sachin!

On Thu, Mar 14, 2013 at 03:46:58PM +0530, Sachin Kamat wrote:
> This eliminates having an #ifdef returning NULL for the case
> when OF is disabled.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Jamie Iles <jamie@jamieiles.com>
