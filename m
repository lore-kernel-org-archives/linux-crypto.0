Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46419 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbeJYX3A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Oct 2018 19:29:00 -0400
Date: Thu, 25 Oct 2018 09:55:48 -0500
From: Rob Herring <robh@kernel.org>
To: AnilKumar Chimata <anilc@codeaurora.org>
Cc: andy.gross@linaro.org, david.brown@linaro.org,
        mark.rutland@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: qce: ice: Add support for Inline Crypto
 Engine
Message-ID: <20181025145548.GA30244@bogus>
References: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
 <1539789476-6098-4-git-send-email-anilc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539789476-6098-4-git-send-email-anilc@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 17, 2018 at 08:47:56PM +0530, AnilKumar Chimata wrote:
> This patch adds support for Inline Crypto Engine (ICE), which
> is embedded into storage device/controller such as UFS/eMMC.
> ICE is intended for high throughput cryptographic encryption
> or decryption of storage data.
> 
> Signed-off-by: AnilKumar Chimata <anilc@codeaurora.org>
> ---
>  Documentation/crypto/msm/ice.txt |  235 ++++++
>  drivers/crypto/Kconfig           |   10 +
>  drivers/crypto/qce/Makefile      |    1 +
>  drivers/crypto/qce/ice.c         | 1613 ++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/qce/iceregs.h     |  159 ++++
>  include/crypto/ice.h             |   80 ++
>  6 files changed, 2098 insertions(+)
>  create mode 100644 Documentation/crypto/msm/ice.txt
>  create mode 100644 drivers/crypto/qce/ice.c
>  create mode 100644 drivers/crypto/qce/iceregs.h
>  create mode 100644 include/crypto/ice.h
> 
> diff --git a/Documentation/crypto/msm/ice.txt b/Documentation/crypto/msm/ice.txt
> new file mode 100644
> index 0000000..58f7081
> --- /dev/null
> +++ b/Documentation/crypto/msm/ice.txt
> @@ -0,0 +1,235 @@
> +Introduction:
> +=============
> +Storage encryption has been one of the most required feature from security
> +point of view. QTI based storage encryption solution uses general purpose
> +crypto engine. While this kind of solution provide a decent amount of
> +performance, it falls short as storage speed is improving significantly
> +continuously. To overcome performance degradation, newer chips are going to
> +have Inline Crypto Engine (ICE) embedded into storage device. ICE is supposed
> +to meet the line speed of storage devices.

Is ICE part of the storage device or part of the host as the binding 
suggests?

Rob
