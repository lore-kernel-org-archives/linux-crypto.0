From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 05/n]: Fix data alignment checks
Date: Wed, 7 May 2008 17:04:33 +0400
Message-ID: <20080507130433.GF23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <48219FF6.2090009@trash.net> <20080507124220.GA23422@2ka.mipt.ru> <4821A45B.7060209@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59436 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYEGNEp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:04:45 -0400
Content-Disposition: inline
In-Reply-To: <4821A45B.7060209@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:45:15PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> Of the data buffers only the destination buffer needs to be aligned,
> see the Source Pointer description in "2.2 Source Descriptors" in
> the HIFN documentation.

Ok, thanks for the reference.

-- 
	Evgeniy Polyakov
