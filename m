Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:34706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbeLNVlO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Dec 2018 16:41:14 -0500
Date: Fri, 14 Dec 2018 13:41:13 -0800 (PST)
Message-Id: <20181214.134113.1168474273454555070.davem@davemloft.net>
To: atul.gupta@chelsio.com
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [tls 2/5] net/tls: sleeping function from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <20181211102009.3561-1-atul.gupta@chelsio.com>
References: <20181211102009.3561-1-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Tue, 11 Dec 2018 02:20:09 -0800

> HW unhash within mutex for registered tls devices cause sleep
> when called from tcp_set_state for TCP_CLOSE. Release lock and
> re-acquire after function call with ref count incr/dec.
> defined kref and fp release for tls_device to ensure device
> is not released outside lock.
 ...
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

Applied.
