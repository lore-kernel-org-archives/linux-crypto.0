From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH 2/4] crypto: qce: dma_map_sg can handle chained SG
Date: Wed, 23 Sep 2015 22:47:49 +0300
Message-ID: <560301E5.6080402@mm-sol.com>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com> <1443009328-12478-3-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net, axboe@fb.com,
	cristian.stoica@freescale.com, dan.j.williams@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443009328-12478-3-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 09/23/2015 02:55 PM, LABBE Corentin wrote:
> The qce driver use two dma_map_sg path according to SG are chained
> or not.
> Since dma_map_sg can handle both case, clean the code with all
> references to sg chained.
> 
> Thus removing qce_mapsg, qce_unmapsg and qce_countsg functions.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/qce/ablkcipher.c | 30 ++++++++----------------
>  drivers/crypto/qce/cipher.h     |  4 ----
>  drivers/crypto/qce/dma.c        | 52 -----------------------------------------
>  drivers/crypto/qce/dma.h        |  5 ----
>  drivers/crypto/qce/sha.c        | 14 ++++-------
>  drivers/crypto/qce/sha.h        |  2 --
>  6 files changed, 15 insertions(+), 92 deletions(-)

Thanks for the patch, very nice diffstat.

I will take care to test the patch next week.


regards,
Stan
