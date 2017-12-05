From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [crypto 4/8] chtls: CPL handler definition
Date: Tue, 05 Dec 2017 16:49:25 +0100
Message-ID: <1512488965.868125.1194799280.3FF09307@webmail.messagingengine.com>
References: <1512474000-6681-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, davem@davemloft.net, davejwatson@fb.com,
        ganeshgr@chelsio.com, harsh@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44161 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752592AbdLEP6s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 10:58:48 -0500
In-Reply-To: <1512474000-6681-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

On Tue, Dec 5, 2017, at 12:40, Atul Gupta wrote:
> CPL handlers for TLS session, record transmit and receive

This does very much looks like full TCP offload with TLS on top? It
would be nice if you could give a few more details in the patch
descriptions.

Bye,
Hannes
