From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 07/n]: Use unique driver names for different algos
Date: Wed, 7 May 2008 17:07:08 +0400
Message-ID: <20080507130708.GG23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <4821A16D.7060905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40485 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbYEGNHU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:07:20 -0400
Content-Disposition: inline
In-Reply-To: <4821A16D.7060905@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:32:45PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>     [HIFN]: Use unique driver names for different algos
>     
>     When the CryptoAPI instantiates a new algorithm, it performs a lookup
>     by driver name. Since hifn uses the same name for all modes of one
>     algorithm, the lookup may return an incorrect algorithm.
>     
>     Change the name to use <mode>-<algo>-<devicename> to provide unique
>     names for the different combinations and devices.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Ack, thanks Patrick.

-- 
	Evgeniy Polyakov
