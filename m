From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH cryptodev-2.6 1/3] crypto: cavium/nitrox - added support
 to identify the NITROX device partname.
Date: Fri, 28 Sep 2018 13:09:48 +0800
Message-ID: <20180928050948.qmoul4drqhs3n7cz@gondor.apana.org.au>
References: <20180921113802.26475-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgadam@cavium.com
To: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180921113802.26475-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 21, 2018 at 05:08:00PM +0530, Srikanth Jampala wrote:
> Get the device partname based on it's capabilities like,
> core frequency, number of cores and revision id.
> 
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_csr.h  | 111 +++++++++++++++++++++
>  drivers/crypto/cavium/nitrox/nitrox_dev.h  |  17 +++-
>  drivers/crypto/cavium/nitrox/nitrox_hal.c  |  57 +++++++++++
>  drivers/crypto/cavium/nitrox/nitrox_hal.h  |   1 +
>  drivers/crypto/cavium/nitrox/nitrox_main.c |  20 ----
>  5 files changed, 184 insertions(+), 22 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
