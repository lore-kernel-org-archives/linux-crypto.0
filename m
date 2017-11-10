From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/1] crypto: stm32/hash - Fix return issue on update
Date: Fri, 10 Nov 2017 22:37:20 +1100
Message-ID: <20171110113720.GC26163@gondor.apana.org.au>
References: <1510008112-1573-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: lionel.debieve@st.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:35798 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752918AbdKJLia (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 06:38:30 -0500
Content-Disposition: inline
In-Reply-To: <1510008112-1573-1-git-send-email-lionel.debieve@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 06, 2017 at 11:41:52PM +0100, lionel.debieve@st.com wrote:
> From: Lionel Debieve <lionel.debieve@st.com>
> 
> When data append reached the threshold for processing,
> we must inform that processing is on going to wait before
> managing the next request.
> 
> Signed-off-by: Lionel Debieve <lionel.debieve@st.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
