From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH 2/2] crypto: stm32 - Support for STM32 HASH module
Date: Mon, 31 Jul 2017 11:16:25 +0200
Message-ID: <8a6bd548-a23a-7aa3-4b3c-b02e1f167c05@partner.samsung.com>
References: <1499952747-16423-1-git-send-email-lionel.debieve@st.com>
 <CGME20170713133412epcas5p29f30bb8be65b6f7673dbd70182674fc9@epcas5p2.samsung.com>
 <1499952747-16423-3-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Lionel Debieve <lionel.debieve@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1499952747-16423-3-git-send-email-lionel.debieve@st.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 13.07.2017 15:32, Lionel Debieve wrote:
> This module register a HASH module that support multiples
> algorithms: MD5, SHA1, SHA224, SHA256. [...]

> +static irqreturn_t stm32_hash_irq_thread(int irq, void *dev_id)
> +{
> +	struct stm32_hash_dev *hdev = dev_id;
> +	int err;

The 'err' var is used without initialize.

> +
> +	if (HASH_FLAGS_CPU & hdev->flags) {
> +		if (HASH_FLAGS_OUTPUT_READY & hdev->flags) {
> +			hdev->flags &= ~HASH_FLAGS_OUTPUT_READY;
> +			goto finish;
> +		}
> +	} else if (HASH_FLAGS_DMA_READY & hdev->flags) {
> +		if (HASH_FLAGS_DMA_ACTIVE & hdev->flags) {
> +			hdev->flags &= ~HASH_FLAGS_DMA_ACTIVE;
> +				goto finish;
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +
> +finish:
> +	/*Finish current request */
> +	stm32_hash_finish_req(hdev->req, err);
> +
> +	return IRQ_HANDLED;
> +}
> +
and here is beginnig for finish_req:

+static void stm32_hash_finish_req(struct ahash_request *req, int err)
+{
+	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct stm32_hash_dev *hdev = rctx->hdev;
+
+	if (!err && (HASH_FLAGS_FINAL & hdev->flags)) {

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
