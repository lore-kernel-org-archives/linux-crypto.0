From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 2/4] crypto: stm32 - Support for STM32 CRC32 crypto module
Date: Tue, 14 Mar 2017 20:39:54 +0100
Message-ID: <20170314193954.GA12137@Red>
References: <1489509446-32283-1-git-send-email-fabien.dessenne@st.com>
 <1489509446-32283-3-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Fabien Dessenne <fabien.dessenne@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35321 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdCNTkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2017 15:40:04 -0400
Content-Disposition: inline
In-Reply-To: <1489509446-32283-3-git-send-email-fabien.dessenne@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 14, 2017 at 05:37:24PM +0100, Fabien Dessenne wrote:
> +static int stm32_crc_remove(struct platform_device *pdev)
> +{
> +	struct stm32_crc *crc = platform_get_drvdata(pdev);
> +
> +	spin_lock(&crc_list.lock);
> +	list_del(&crc->list);
> +	spin_unlock(&crc_list.lock);
> +
> +	crypto_unregister_shash(algs);
> +
> +	if (crc && crc->clk)
> +		clk_disable_unprepare(crc->clk);

Hello

No need to test for crc, if it was NULL, you dereference it just before in list_del.
Furthermore, It seems that clk_disable_unprepare() handle perfectly NULL, so no test is needed.

Regards
Corentin Labbe
