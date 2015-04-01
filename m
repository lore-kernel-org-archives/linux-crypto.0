From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] crypto: af_alg - make exports consistant
Date: Wed, 01 Apr 2015 15:33:01 -0400 (EDT)
Message-ID: <20150401.153301.352043757333109452.davem@davemloft.net>
References: <20150330212543.7156.92708.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:60205 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbbDATdE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Apr 2015 15:33:04 -0400
In-Reply-To: <20150330212543.7156.92708.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tadeusz Struk <tadeusz.struk@intel.com>
Date: Mon, 30 Mar 2015 14:25:43 -0700

> Use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
