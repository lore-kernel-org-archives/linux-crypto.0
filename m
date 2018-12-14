Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:34720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731149AbeLNVl1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Dec 2018 16:41:27 -0500
Date: Fri, 14 Dec 2018 13:41:25 -0800 (PST)
Message-Id: <20181214.134125.654066359681210530.davem@davemloft.net>
To: atul.gupta@chelsio.com
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [tls 4/5] crypto/chelsio/chtls: macro correction in tx path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20181211102040.3665-1-atul.gupta@chelsio.com>
References: <20181211102040.3665-1-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Tue, 11 Dec 2018 02:20:40 -0800

> corrected macro used in tx path. removed redundant hdrlen
> and check for !page in chtls_sendmsg
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

Applied.
