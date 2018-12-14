Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:34694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730909AbeLNVlE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Dec 2018 16:41:04 -0500
Date: Fri, 14 Dec 2018 13:41:02 -0800 (PST)
Message-Id: <20181214.134102.1139109688970987290.davem@davemloft.net>
To: atul.gupta@chelsio.com
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [tls 1/5] net/tls: Init routines in create_ctx
From: David Miller <davem@davemloft.net>
In-Reply-To: <20181211101940.3509-1-atul.gupta@chelsio.com>
References: <20181211101940.3509-1-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Tue, 11 Dec 2018 02:19:40 -0800

> create_ctx is called from tls_init and tls_hw_prot
> hence initialize function pointers in common routine.
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

Applied.
