From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 2/2] chcr: Add support for Inline IPSec
Date: Tue, 14 Nov 2017 16:09:43 +0900 (KST)
Message-ID: <20171114.160943.123536330718664026.davem@davemloft.net>
References: <1510226941-20472-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        harsh@chelsio.com, ganeshgr@chelsio.com
To: atul.gupta@chelsio.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1510226941-20472-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Thu,  9 Nov 2017 16:59:01 +0530

> register xfrmdev_ops callbacks, Send IPsec tunneled data
> to HW for inline processing.
> The driver use hardware crypto accelerator to encrypt and
> generate ICV for the transmitted packet in Inline mode.
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Signed-off-by: Harsh Jain <harsh@chelsio.com>
> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
> ---
> V2: Fixed the build warnings and created patch against cryptodev
>     to avoid possible merge conflicts

Herbert, feel free to merge these two patches via your crypto
tree.

Thanks!
