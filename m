From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: sha1: modify sha1_update to use SHA1_BLOCK_SIZE
Date: Wed, 25 May 2011 23:34:11 -0400 (EDT)
Message-ID: <20110525.233411.1372538972166578285.davem@davemloft.net>
References: <1306379477-24552-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
	linux-crypto@vger.kernel.org
To: msb@chromium.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:41880 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1EZDeW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2011 23:34:22 -0400
In-Reply-To: <1306379477-24552-1-git-send-email-msb@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Mandeep Singh Baines <msb@chromium.org>
Date: Wed, 25 May 2011 20:11:17 -0700

> Plus some other minor cleanup.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

The temp[] buffer is explicitly places inside the inner most
basic block so that the compiler doesn't allocate the stack
space unless that code path is taken.

Besides the use of the SHA_* macros, I think your changes
actually make the code worse.
