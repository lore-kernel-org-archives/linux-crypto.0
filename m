From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: n2_core: insert '!err' condition in else scope
Date: Sat, 19 Oct 2013 18:38:25 -0400 (EDT)
Message-ID: <20131019.183825.2015665991258674429.davem@davemloft.net>
References: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kernel-br@googlegroups.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: geyslan@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:40194 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3JSWi1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Oct 2013 18:38:27 -0400
In-Reply-To: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Geyslan G. Bem" <geyslan@gmail.com>
Date: Sat, 19 Oct 2013 10:09:31 -0300

> This patch moves the '!err' condition into the above else scope,
> what is more obvious and has the secondary goal of avoid false-positives
> in statical analyze tools.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>

I do not think patches should be applied to satisfy tools if the
code is semantically correct.
