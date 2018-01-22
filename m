From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH -next] hwrng: bcm2835 - Remove redundant dev_err call in
 bcm2835_rng_probe()
Date: Mon, 22 Jan 2018 15:09:48 -0800
Message-ID: <2f6aedf1-4712-73b9-6012-349cdcc2605a@gmail.com>
References: <1516189234-11957-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1516189234-11957-1-git-send-email-weiyongjun1@huawei.com>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/17/2018 03:40 AM, Wei Yongjun wrote:
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
