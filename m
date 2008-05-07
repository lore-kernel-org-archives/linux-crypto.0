From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 05/n]: Fix data alignment checks
Date: Wed, 7 May 2008 17:22:51 +0400
Message-ID: <20080507132251.GK23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <48219FF6.2090009@trash.net> <20080507124220.GA23422@2ka.mipt.ru> <4821A45B.7060209@trash.net> <20080507130433.GF23422@2ka.mipt.ru> <4821A92C.1040707@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50997 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbYEGNXL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:23:11 -0400
Content-Disposition: inline
In-Reply-To: <4821A92C.1040707@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 03:05:48PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> As a side-note: its also not just an overseight in the documentation,
> not aligning the destination buffer to a multiple of 4 results in the
> HW freezing, the source buffer alignment changes work fine though.

Probably I just mirrored dst to src alignment and thus forced mask to be
at least 3.

-- 
	Evgeniy Polyakov
