From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp: remove unused variable qim
Date: Tue, 17 Oct 2017 17:12:12 -0500
Message-ID: <83517ed8-3dc5-4ecd-b3e1-7412e8eef472@amd.com>
References: <20171012165541.32256-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kernel-janitors@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012165541.32256-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/12/2017 11:55 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Variable qim is assigned but never read, it is redundant and can
> be removed.
>
> Cleans up clang warning: Value stored to 'qim' is never read
>
> Fixes: 4b394a232df7 ("crypto: ccp - Let a v5 CCP provide the same function as v3")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>  drivers/crypto/ccp/ccp-dev-v5.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index 65604fc65e8f..44a4d2779b15 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -788,13 +788,12 @@ static int ccp5_init(struct ccp_device *ccp)
>  	struct ccp_cmd_queue *cmd_q;
>  	struct dma_pool *dma_pool;
>  	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
> -	unsigned int qmr, qim, i;
> +	unsigned int qmr, i;
>  	u64 status;
>  	u32 status_lo, status_hi;
>  	int ret;
>
>  	/* Find available queues */
> -	qim = 0;
>  	qmr = ioread32(ccp->io_regs + Q_MASK_REG);
>  	for (i = 0; i < MAX_HW_QUEUES; i++) {
>
>
