Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:34712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbeLNVlU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Dec 2018 16:41:20 -0500
Date: Fri, 14 Dec 2018 13:41:19 -0800 (PST)
Message-Id: <20181214.134119.782627967930017438.davem@davemloft.net>
To: atul.gupta@chelsio.com
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [tls 3/5] crypto/chelsio/chtls: listen fails with multiadapt
From: David Miller <davem@davemloft.net>
In-Reply-To: <20181211102026.3610-1-atul.gupta@chelsio.com>
References: <20181211102026.3610-1-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Tue, 11 Dec 2018 02:20:26 -0800

> listen fails when more than one tls capable device is
> registered. tls_hw_hash is called for each dev which loops
> again for each cdev_list causing listen failure. Hence
> call chtls_listen_start/stop for specific device than loop over all
> devices.
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

Applied.
