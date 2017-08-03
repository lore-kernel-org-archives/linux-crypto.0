From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND,PATCH v4 3/3] crypto : stm32 - Add STM32F4 CRC32 support
Date: Thu, 3 Aug 2017 13:44:23 +0800
Message-ID: <20170803054423.GA11926@gondor.apana.org.au>
References: <1500280056-46251-1-git-send-email-cosardindar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, fabien.dessenne@st.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Cosar Dindar <cosardindar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500280056-46251-1-git-send-email-cosardindar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 17, 2017 at 11:27:36AM +0300, Cosar Dindar wrote:
> This patch adds CRC (CRC32 Crypto) support for STM32F4 series.
> 
> As an hardware limitation polynomial and key setting are not supported.
> They are fixed as 0x4C11DB7 (poly) and 0xFFFFFFFF (key).
> CRC32C Castagnoli algorithm is not used.
> 
> Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
> Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>

This patch doesn't apply anymore.  Please rebase.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
