From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Mon, 04 Aug 2008 06:35:39 -0400
Message-ID: <1217846139.20845.25.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:32538 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbYHDKhS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 06:37:18 -0400
In-Reply-To: <1217844725.3454.580.camel@pmac.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 11:12 +0100, David Woodhouse wrote:
> You could perhaps just use 'unsigned long' here, to avoid the ifdef.
Thanks. 
> And it would be nice if we could make libcrc32c use this too, rather
> than just the 'crypto' users.
>From previous discussing, herbert would like to transfer the libcrc32c 
interface by new crypto because there were few user using the current 
libcrc32c interface. 

