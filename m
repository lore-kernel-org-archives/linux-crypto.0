From: David Miller <davem@davemloft.net>
Subject: Re: [PATCHv2] tls: Add support for encryption using async offload
 accelerator
Date: Wed, 31 Jan 2018 10:33:29 -0500 (EST)
Message-ID: <20180131.103329.1363126229531535840.davem@davemloft.net>
References: <20180131160437.6583-1-vakul.garg@nxp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, ilyal@mellanox.com,
        aviadye@mellanox.com, davejwatson@fb.com, netdev@vger.kernel.org
To: vakul.garg@nxp.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131160437.6583-1-vakul.garg@nxp.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Vakul Garg <vakul.garg@nxp.com>
Date: Wed, 31 Jan 2018 21:34:37 +0530

> Async crypto accelerators (e.g. drivers/crypto/caam) support offloading
> GCM operation. If they are enabled, crypto_aead_encrypt() return error
> code -EINPROGRESS. In this case tls_do_encryption() needs to wait on a
> completion till the time the response for crypto offload request is
> received.
> 
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
> ---
> v1-v2:
>  - Used crypto_wait_req() to wait for async operation completion
>  - Passed CRYPTO_TFM_REQ_MAY_BACKLOG to crypto_aead_encrypt

Applied.
