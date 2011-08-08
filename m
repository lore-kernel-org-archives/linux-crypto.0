From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] n2_crypto: Fix a get/put_cpu() imbalance
Date: Sun, 07 Aug 2011 22:55:46 -0700 (PDT)
Message-ID: <20110807.225546.356790607362959299.davem@davemloft.net>
References: <1312619188.5589.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: thomas@m3y3r.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:48605 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1HHF4K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2011 01:56:10 -0400
In-Reply-To: <1312619188.5589.27.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Thomas Meyer <thomas@m3y3r.de>
Date: Sat, 06 Aug 2011 10:26:25 +0200

> From: Thomas Meyer <thomas@m3y3r.de>
> 
> Fix a get/put_cpu() imbalance in the error case when qp == NULL
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: David S. Miller <davem@davemloft.net>
