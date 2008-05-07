From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 01/n]: Endianess fixes
Date: Wed, 7 May 2008 17:00:11 +0400
Message-ID: <20080507130011.GD23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59420 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYEGNAh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:00:37 -0400
Content-Disposition: inline
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:14:28PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>     [HIFN]: Endianess fixes
>     
>     HIFN uses little-endian by default, move cpu_to_le32 conversion to hifn_write_0/
>     hifn_write_1, add sparse annotations and fix an invalid endian conversion in
>     hifn_setup_src_desc.

We can also be safe without volatile annotations.
Ack, thanks Patrick.


-- 
	Evgeniy Polyakov
