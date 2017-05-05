From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 01/14] crypto: sun4i-ss - simplify optional reset
 handling
Date: Fri, 5 May 2017 08:48:09 +0200
Message-ID: <20170505064809.GB31657@Red>
References: <20170315113128.8809-1-p.zabel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org
To: Philipp Zabel <p.zabel@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:35439 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753368AbdEEGsN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 May 2017 02:48:13 -0400
Content-Disposition: inline
In-Reply-To: <20170315113128.8809-1-p.zabel@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 15, 2017 at 12:31:28PM +0100, Philipp Zabel wrote:
> As of commit bb475230b8e5 ("reset: make optional functions really
> optional"), the reset framework API calls use NULL pointers to describe
> optional, non-present reset controls.
> 
> This allows to return errors from devm_reset_control_get_optional and to
> call reset_control_(de)assert unconditionally.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---

Sorry for the delay
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
